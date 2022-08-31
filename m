Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715585A7E6D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiHaNOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiHaNOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:14:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7A9C742F
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOOjtZgmVFQIzfCP7d1JoRLM/PHz4Udnl5aLBLs4NsYS4GVQNsMaj/LqbE648OT5lz2yChs9JQJpeYTzXF5wdGYFaUQOtTYGa1ROUX7vcH40COwz97O+m6j+UGgYdCwNQpEhMY+hxMTRM5yCvbGzlfsVFw6EdDcDU8u3MqeIf6PQ/saj8poeLWxhAcpiULefFii41pznUBRXd5xqdunQkZlGMc45lbBUOCt365Teo5F2p124nQUQu/kw/ClAuSQJTUyxZ2GLzp6qTd4BLPaNaUATktf9egIFAcJiMoRButT+rqynHLSCL+aijcnQSJ1CmU1guPn7riX7adN5S5TXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKkE/Hid6nbo89QfsV9R47WqvCiKrY7wW15Zd3Cbbg8=;
 b=IiYlTzkT2gNEghAULCMsLTY894w7ToCiw5w5tlZA3Skpj+U1vwVzQ93AWi8LPIra1jNN0UxxXdF5wH2GRn+1/u3DgDMi8xFHXw3lApiQ0XOUcmjC4I7v6aysHZFi62ONTxY5gD/si6WJ7LSDHrOmEuzhUSqvFwokl6K8A6M+gv/NQgDDoEAV+3SETTYMYmtW7AVOK5dRYvkelOU1Lye02Q2xfGZnhemj694KzkhsMLoHOQG0UOUQCveNHkmsx8vzAhzyPdZwB/EQj50lQCymlfI3bxZpn4XtegiHSuhWJWzBSsjI98YADQ3UvgsEBDzKvpIJdRAqZbHbVXtgFODoOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKkE/Hid6nbo89QfsV9R47WqvCiKrY7wW15Zd3Cbbg8=;
 b=YU9gk5WxQdyrAJZpmZQQb5S4l00okUX/M7pAN1rYraobLwl+MI7kjN/qcZ1Cdz2ZjUJMftNdq0BIUZ7vNMuqIsY3kB+lU5V4vrFY5B8qeRH38zaDl7h6Oq0hEIKAa6WA1Hjo8AOELCfWX+VEL2ljRyAMXBVDFJt06euX+n3v9iuSl5ZbyIR27GTytsg2DMSEyLZVaVKvJix1DZ9IeOqZjUb34clN/pI+W8Qhse6R0y7SsLfyPmE3UN4iDGmxQ4+TuI9ZQI2AgLe4vjJ+8Q7B4FPXjPVhOhbJnXFZBY4fMj9jFIJCPwcU9oJ0mjnOpy/eWaXy7mLDCH1p1ZX43wMMDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH8PR12MB7205.namprd12.prod.outlook.com (2603:10b6:510:227::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 13:14:13 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::e52a:9fc5:c7f0:7612%6]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 13:14:13 +0000
Message-ID: <74de3ef9-960c-12b5-6782-7a38854a6ac2@nvidia.com>
Date:   Wed, 31 Aug 2022 21:14:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH RESEND v4 2/2] virtio-net: use mtu size as buffer length
 for big packets
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220831130541.81217-1-gavinl@nvidia.com>
 <20220831130541.81217-3-gavinl@nvidia.com>
 <20220831090907-mutt-send-email-mst@kernel.org>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <20220831090907-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623a4d35-a1f2-4be0-0f63-08da8b52b29d
X-MS-TrafficTypeDiagnostic: PH8PR12MB7205:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuKZFV+PLnRqgxJ8JA9tpjZjq5MCNpwae0UYynHVgDDGcOCRO2SDMCPnFqZZOPOgu0PKQAzOUM7kUjinYWSCmgtGog/QdfBBZeTIVLl2wmLATsnN/rA7QenR24Cstmgzh5vy1XBa+yr+wiWRVQNKOJz65pdCZJXv8dKE4vNeNZGbwq+LGfiYAFQGxHkS2AvDm8Ku4HeUDUsdxhPFFVk4m4VGy98Xy4/fQrxSkpN5ZKgKF6PgvnfHGcZZ9Oq0Xyv143glMY8hgmW/jh4Kj/hWdxivMXu/CBB0x067S70ojEBOIfC1pyEFr088BR3ORtEBBOdBEr6cPg+CqlqJF9OteIOqERkK+Yr61kV3dvKxDriVwIa195k7Qbbs+5StpIIbZqwxkY6H+L12boQt9W1k7NZjKFd1uDJaffljJ9xTYnawGXt/ZiKBauWZ6fdMgZcGsV4R6DhK3z7yZQFaBZ5V9WWNiw6GyMTP/8Al4aMQyrrZpHf9XlFlQfJD8h1/ZhsBK3edOTx/NaBwjOJEXWHDbgBTnCI3vyBW81bhqPFXcaALNcDBnqVsS8aIldhXqhUME2tqaBLKBHuiABg5O4HgJ6Nf0p9IrfIrg6v3dMQECgDYAlyrdBKebdiFK1L0rFK8vLGlLo29XwvYA/62uHx2jBW9W5eZMjo54f+W1qasTSx62ThGLhWw5vcKbjdvPxh49lPWrPiRVzn31Bk5kGLo1c4Gu2nTT8U3MwepvlpZfHjqdmhsxjyTDTb0p+9ZF+SFy4PI+WawXqMZLDrhiQVjG4VlloRX5eOH1xqUKoMyCiM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(8936002)(7416002)(5660300002)(38100700002)(31686004)(8676002)(4326008)(66946007)(66476007)(66556008)(83380400001)(2906002)(36756003)(41300700001)(86362001)(6666004)(186003)(2616005)(6512007)(558084003)(53546011)(316002)(26005)(6506007)(6916009)(54906003)(31696002)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFM4WVA2Z2w0amFGV010UEFkdXhQa0d6dCtmSzFtempTMjYvK3BqSW9CRExX?=
 =?utf-8?B?QlZMeU9Ydmo4TVp2WmhFWit6SlZGUE5qMmRzK21BOGRTc1pKQTByejV5ZFF3?=
 =?utf-8?B?b1RLci9JclFEMnYwRkhKam5oSW1yNkQrZmdSejlLZ0JHR09XVGtSUmhEaS9M?=
 =?utf-8?B?N2pJZm1jZXM5VmlkNzYwNFZqTTR1TDBPZHU1OXZzSXgvaHNzN1BmV3pnMVRH?=
 =?utf-8?B?Rjg2b3RiRDh4aWlJR25XR3hVQzVWcUw1MUdQM3kva3J6ejMwUUZOYzFrOG1J?=
 =?utf-8?B?aG1YbUxxQzhDVisyN0h1WHJzMWQydHVKVnMrbTRwd3hqSjVid1VYTXJkSllR?=
 =?utf-8?B?SFhtemx4elNVamtNYU1WZ3hxaDJCY2ttZXQ2Q1F2Tm1XSEVCWHcvUjZib3k5?=
 =?utf-8?B?ME9pRERsZXRpa3pwbUpBV253QlpwT0pjN2N6TERmRG9wQ1Q5U1Rld2NnQ0V2?=
 =?utf-8?B?aDNidStuOHdXdzlIU3d4RjZCTzE4V2xuWFNLMWpWZTlRZnBTd2t3WjMvd0do?=
 =?utf-8?B?WlEzSmZTN1lXeXBJQVgxVkVFVzJaVjdpOC9nZXZUc1lEWURzTkFrek4xcU9o?=
 =?utf-8?B?aVlqVERLZGlCVTV2d3cyelRJcGttNEIxd0pjN1dBbzk3dnJjcFlqcGN2ODM5?=
 =?utf-8?B?dWxHbDdFUW9HNk5pNFJLU0U0d3luZkVQM0x4TS9lRm1WZ1VaKzNiaHN1clcr?=
 =?utf-8?B?c2dBNmVCNjExS2lQMTF5WjBhMm1VVnduT1JYaWRaMFpNTEs5ZTZ2MWs2VktE?=
 =?utf-8?B?empJVE9vaWg5S2kxaE5kWlA5aFVyUFlBejZ3dW5pc2JYSGUyM1Q1UkRmQ1Vq?=
 =?utf-8?B?VVZYNzgrNWxmbVRUdW1sVlpiUlNVWnlMQlFrZVRXZFZrdFJnRUpYZkN3NHNx?=
 =?utf-8?B?TjZpaXFpd1ZBSkVZUHVScURvNWJuc0J4b3VDYmwycFBadkdUYStMSlVPbEJQ?=
 =?utf-8?B?SktPTDQ1QnhqRlZwS0JYZ2JvMG82ZzdaVGY1U1dST2R1RkJrdUYzY29vTWdV?=
 =?utf-8?B?YVdTNFBWaENLaVByZzg3ci9GMGJLSXAyeUY5SHF0cEJ6SDJIRTFkV0kxbGVN?=
 =?utf-8?B?RG5xaGMwRERSYUN4UnpRNEpQZDFkTWlTT0xSMWl1R1NYUWJFZnE0eVBRTnQ5?=
 =?utf-8?B?Ym95bnFLRy9qVFNHdE9sQ08zck9lNlNxNmF4RXJSNlY3ODlYRjUvSVB0ODI4?=
 =?utf-8?B?THgvKzlzcm5KZ0FzQkVidXR5NzZKRmU1MlducmpCZEN5cVljY3pvSmMvWFVP?=
 =?utf-8?B?dWZWcXZzSjJtRkRlRENKUFluUzdpekthMFVLdDZ1ZkR0dktrQlMxeXhFTEl0?=
 =?utf-8?B?Vlk2S05EYWZkRHA4VnFRV0VNZXdmaEdNWW5VZXIzQlZrc2RVb0Q5YkM1OUlQ?=
 =?utf-8?B?bEhKbnFaaGRYdVBMYThHK3FnNGczMDhUMjhjVktGM3pPNHNMOVZYTlZqc211?=
 =?utf-8?B?ZFZ3V2RzWVFtdU83b2o5bThzVnJiQVNhN0R2KzluazFFYjd5eHZ3SnV3RE1K?=
 =?utf-8?B?Z0R5ZzE2VWx0cXd1Um54UGZKTTY5MXpnTlRES0h4WVptaWpWQWZKZlRKcHF2?=
 =?utf-8?B?Y1NQL1RUQWtCUVdDUlJZNlFRNmo1eGxQRkwyaE5zU0Fpd3FRQ3RCeWVsZkt6?=
 =?utf-8?B?NGZPVllsSzVZZzhuNzRVUCtoczZzMkg3QzJnWTMzYTlFd3hRMXp5SzlPdzZw?=
 =?utf-8?B?VmlNbFp0UUtNb2dsTDNaVzdNWmtHSkVrU24xTWcvL0VXRHcyczBscEIxalBm?=
 =?utf-8?B?NTRLWElpLzZMdmNlNGVLK0dqWGM4aTdYNG4rWEg0ZGJlNmJ4cW5XT1dyVXI3?=
 =?utf-8?B?UGl2ZW1ySW9QYUNwQnovaDNmT2JDTW5nQmNVaVVYOG1ySWFkSkJJVU1tajN3?=
 =?utf-8?B?TFMxNXJIaVFIdU43ZDVIamhNcThRb2tGQ1lCRzBkbjJQWXViQ1J0aW5SQUhS?=
 =?utf-8?B?VXlueGYrZ1kyOHVkVXkrcUFWQ1VPL20wdnZENllaMGpiZlF5V0ErenpFUDJn?=
 =?utf-8?B?dkNIb29iaGxRTFgxYnE5UUxxMEhaSFhQN1ZHWFpHQWorZkFSUnJaVVlmSjhJ?=
 =?utf-8?B?eTFabDU3M3ltelRlQ2RVbUhqS1ZUU09UUTJnaVBGM1RCOStNMWpDWXJKOVVo?=
 =?utf-8?Q?w3Iu9O3u9LwrVz2bwV0OHNw52?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623a4d35-a1f2-4be0-0f63-08da8b52b29d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 13:14:13.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwykJhn0pYCQYxSY7f6Ue6Ar0Pw8SbA8S+PFjEbImKo8dJ914/A2ovrqrYNdUof1AlVGOWNpLjCmCJnWfa1tyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2022 9:11 PM, Michael S. Tsirkin wrote:
> Accordingly, for now we assume that if GSO has been negotiated
> then it has been enabled, even if it's actually been disabled
> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
ACK
