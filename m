Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F16F5A9612
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiIALwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiIALwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:52:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D61299E7
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 04:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn4o4/XPRVBDQmhZNp91RE9dRe1Jz5qwueyYnIR4kGOM9DLExrAR9eO/Y6DWZKZMQ5wpIVtdHNIkAJRFmcNhnd7GTTOKuVxVztpb0jq7iHwngBcU+/Sli/xGev/BJevbHvca/8fMCpCILLNUY1RRjfsBow9cWb5M0hoomQSlI2abq0qtyFP4m8yC4W34ZmfnKMyJnMYC4SaOgR3zgOOoxDvIhaO7WY/U5KH4FogKQNRY+D7nnM9bTSM3WKl7MmQFVU2fHEyXEQyBqvvS1m+Oz+0lWeUYSnziT4cEBhKTRYn7UDkXPXuViC6JR+tn6wtmtz3hqA12KTtC1Jo0lHc7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GB81gORpeacs8RjEcs9TCoRy3qbl3oDvVMCDO4jJE6c=;
 b=WsDRhrEViw2DVGoe4ZV5Jt935RneOtoFFzbQngwUxAl0HOr9Z7+3z8NuRgJRsEo6aPqx2whMIg38iSBSR+RajpTF8Uw8yF7JmDmCQttKHf55itLDZ67/0iV3YoZ1KtpUCsoevXT8DBXQRhb5e40cSAKE39eSIV5IkefEGwtXw2cErqHZ74RE4JzVYgW3u+YRZy3PC0elSHXRjfjkId3WXLpC4pvAU1Kg6xuefadm1KQ+7nklskIFIyM+2wvn1RS6nGQ1Un1kARODeouhr5nosoGK5y3vwisPiT60MqObQmgo34Hvx0fUgF/dBptoxTT5oVOx0F9F+R6HgoiusLfN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GB81gORpeacs8RjEcs9TCoRy3qbl3oDvVMCDO4jJE6c=;
 b=mKtfbNhoJXYoEI1xapDewWgr087fqEUj/PVloWK4aDMvgxWPXHN7x7JTTGTkENGzm2XPKp+7F+J8thGbI3B3ClRCdxwO0PlwnkKdl/pWoqswpJXvWfEAcuJm5k+Ub/h0uQCmPTIN1zvIHOCf+a0YmrGB3fm4cMtTEtUOnuk1lYofC4RRbK8dLkK0t3U0i29g104884T2Yt5Cp1WrK0UR9bA0mIKKGbVOpAMzq3sDucjvWE1M/ai0DcxWppf9lVr9WR/MH10BMSWAct+UgVnqnTH4OIVKl4QZPFyfwkcotkEQrs3deJ9iAbt+/KbedBGtnUqNLcRjANyYgdZCi0gssg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 11:52:11 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a%7]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 11:52:11 +0000
Message-ID: <35516c1f-c000-1ed7-ae00-627ac2240dcb@nvidia.com>
Date:   Thu, 1 Sep 2022 14:52:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
 <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
 <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
 <20220831103624.4ce0207b@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220831103624.4ce0207b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:458::32) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65406d21-8682-4f1e-c03b-08da8c10676b
X-MS-TrafficTypeDiagnostic: MN0PR12MB6198:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xjfuaNjhT18+ec1luFLKi9Lm3Se562uHbwrQoZ13XrT+dsS/xaSdC6c2J1s/4Wj52b3wfAt4swclFxsznLlkoNi4Q1kTGNz/4Cko9bega1hEO1i9x3kb37nngfN36HIjnybNaMIxVM6p8fb09poRD5JJpGNc79ImUh+sNMjD9XFzzq324bvD4Z7YAOIc/CjIwx1cmz5/2mvkGwnwAo/OTlOaDq44Hz/+uppwIIYRqf77wD5Qewk98gnq8CgavMVTb/6ug6y2T2avEvd0kDeottvI7j3obDzqUW+xkM5ZZ7/RFnYsNTo+L93vEj+o24ND71JiBF/PEPD5fmLe5FINVhjqtrpwEkfjOQaHvO2N9EY09FobnaJwG6Qnx2Cp4GVnTI7HcRJtBsYcvXWoeMj86OYWbz3i+XPEG7lWrUPQ52aWLItH5dX6wKNDiR+vJLDZC00Ttntx8/5gsKgwyFKjqAnc3/fpL7x1C8Na3/ENtkfsffGYNOaQ+R04qIPM4nyzHDe1g8n04p9sPdML+bQ1byEAJj0YHp2VAbGl++RULSe6NVqeOTc7Sn0WJplO9XPXDN/bef8a6x72gHdAcyfRkgeQXXU2ZMCIB45pR0E/coR63Ppk9+LD23Zo9Mwspo6dw6LqTGL4aICcj1eR4pOfzNmQ6JP5wZQ1w5u0h6oWfeXM3MofUIfPt7pAiiuk9TiV/j9JF6Yy8SGhURywAgvncu5u09mTy5I79w9vQf8QDSUqftGb4AZWXU895kUxHpQSStsDRMZHTgY5gdlaKaCpIjlXbciifxF45nn6WpdTU4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(83380400001)(6512007)(53546011)(26005)(6506007)(2906002)(2616005)(186003)(38100700002)(86362001)(31696002)(8936002)(6486002)(66946007)(5660300002)(41300700001)(8676002)(478600001)(36756003)(316002)(4326008)(66476007)(31686004)(66556008)(6916009)(54906003)(6666004)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTVtZVduNjhQaUVJNnFIeXh1ekRZYkRkdGxoYzIrSGZubVpGV3VSVEo0ZGo3?=
 =?utf-8?B?d3hVYWs3VVNMVXp2empRUEtaNVFTWFRLaExxc2FEaDFZUXU1R0lESmhtVkxU?=
 =?utf-8?B?MEVRNHVwV2hQQU9HNTZ3NWczaFp4dWVTQ3hEdWovOHdBOTRoVksxZ05JYUNN?=
 =?utf-8?B?VHFPVXErWCtCZ3U0OElEVDhYWjM1UzFWWWYyeDJVWXlUVkY1RCt0Y1BLdHls?=
 =?utf-8?B?V053bys5MEx1enRHRVc0bmlzNXQ4U0kvT3pOZW5HQi95M2hESjVBaDVQUmxH?=
 =?utf-8?B?bEY4SjhzVFJzUVNmL2taRGdTeXpYSzEzeHhzLzVxaUg5UjhIc0lQUE9zOGZm?=
 =?utf-8?B?dVhmZ21vODNzOW9iUE4vUHJmOXhYTnRINm5uVW5tRG9rZlBzMG5ySEVEKzFE?=
 =?utf-8?B?VEZvNmxTQWJrNlcrSXpoRERtaG8yRXZ2ckxoRit1VFhzblN4NzdwcjB5NGRV?=
 =?utf-8?B?eFlSU3RSc1dWK0V5N1Q0RVN2SEdXTHBYMC92OVppbWg4V3J1Z2ltbldFYUNm?=
 =?utf-8?B?VlR5TzVTaDliOVhFZXk3ekRCdWJKbDNHdjVPMURrc3lMZzN3ZkgwMkovMHJY?=
 =?utf-8?B?Mlk0bXVhZ3orMjl6dFUrUm12KzFQcVlrUXI0YmI4UVMxQ1R6eUR0VnZVMmZY?=
 =?utf-8?B?Y1F6R0ZySER4WlBCaXFhNnRqVGdzQXdlaWRWQ1cza1JDSWg1U05iOHFJSllS?=
 =?utf-8?B?U3doOWtMc0IvekpHcmIxM3A4emZISGNzd29Od3VRUm1WSElGWjFqVnZhVHVE?=
 =?utf-8?B?RktHZ3E3UWZsRHBRNndWSW5RYS9SQVFnOGc4SDhPS1dZZTkxSXMyOG1EcWdl?=
 =?utf-8?B?S3RmZzV6QjBaMEd4VG5vb0FTdVJ5Q00zaUp4UTFtbEZ3QXRxWTFqbXpxanRS?=
 =?utf-8?B?Uks5a1AwMFcxZ2VZZ3JLdm1oalY4ZncvRjBybWtsOGxZN2R1TStMcUxCcEFD?=
 =?utf-8?B?dE95clBqL0lxd2g0VTNVMDZ0WTVaNC9QeE9KQ0NBaFEzOVZFN0QvaVYyaEp4?=
 =?utf-8?B?Q3lmUC9CWlAyb05zZUpyaVB1Yzd3K0ZIM0QwOGxLQXpCMEVMV0ZlVi9qc3FV?=
 =?utf-8?B?VGlVbWVQVTV1eDhzZXdRR2dxMEFRMG9IbHFYcVlMbXlNZDdwYlNkdEdqS2xZ?=
 =?utf-8?B?RlJKaU1ZRXZka0g1bHM3ZGF6eUZ1Rk9McHNMeXFJTUhEVFlzZmNza0w5MGNV?=
 =?utf-8?B?Nm5HTktlbGRvVUpOdWVDNCttaHVNWWk3ZDQ1RnJCRDRrSmVvSmZ6dzBPNHIr?=
 =?utf-8?B?WkVlNVBRWm9ua3UxZlZnb1NEMVRoMFYvbkJPRTgzdWFEVzdUQkNEK2FxTHNa?=
 =?utf-8?B?KzBuZzEvQUFlYzBUMWswaDA0QUNIMEduYWQrK0x1MFVBZ0MzWTUzUmgzcFNI?=
 =?utf-8?B?eTVvTktJN1NVZHRWMGFJaUU3d2JTdjlJYWE3bS9FZDV6UHpoNCtxWWxSdlk1?=
 =?utf-8?B?UlY3eUoxK1RsTUpZZXZ1ZlhwT01ORlBuR3d6SDhDdDR2cXNzWTVkVVllUWZi?=
 =?utf-8?B?czU1bFE0Rjd4MzduN09vbXY3b2t2QUhBZERQVFlkdVpwbjNTZGhpOUNSLzhS?=
 =?utf-8?B?MzNBaXIwLzZpc0N2UUNSTFJBK0RsUklBZW01SUVUQXVVY0xHaEp2WTJHa3E3?=
 =?utf-8?B?TFg1WTR2ajVPbURWbzhwOFM0SU82NWtETjgwVjY1Qkdrc3A3Qkx1RXJSdjBp?=
 =?utf-8?B?UVoyYnEvaWJOVzBrZENHc2FsajZBYU1CWGZGd0RoNFRNS2g4RUpZY3YycEVO?=
 =?utf-8?B?dzZ0S3d2Si92L05paGcvMHNJMERiMHEwLzRMdzJuTFpzRDdaaTVhRnRIb09k?=
 =?utf-8?B?d0RRWEhsYVFURFROYWZkMytUdTkyTDljVXBmcHpRQit3QlhFdXR1YlVpTUQr?=
 =?utf-8?B?QVhFVjdIaW9GT09DeDRJdm80c0tydEpyd21iSWlWWGtObFdRTzFXaEhiNXI4?=
 =?utf-8?B?enVUSmVxWnRhR01zOUlJeXF6NkFLZ1BYK25ObFlhVEtrZ0xDWVUvYTZOc2tk?=
 =?utf-8?B?TzI2QmFJYXQ1dS96RzI2bFp6byttWWxWSmpLcHlzMXkvdjR4cGFJOTI2b2Iv?=
 =?utf-8?B?ZTVJSTE1N1hxOFVDVHVrTEorNFRwZFBxbzlSM1ZUeXBOd1NvZlEydkFqSFNp?=
 =?utf-8?Q?RxzQOYCzoFDcpAi9Y4QZLz0NY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65406d21-8682-4f1e-c03b-08da8c10676b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 11:52:11.0388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZItLVKHkkDZCG9tuFhu+s3PR8M9r0aHZgVIE/h6Q276/4QxShMuD52cjR1bDD8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
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

On 31/08/2022 20:36, Jakub Kicinski wrote:
> On Wed, 31 Aug 2022 14:01:10 +0300 Gal Pressman wrote:
>> When autoneg is disabled (and auto fec enabled), the firmware chooses
>> one of the supported modes according to the spec. 
> Would you be able to provide the pointer in the spec / section which
> defines the behavior?  It may be helpful to add that to the kdoc for 
> ETHTOOL_FEC_AUTO_BIT.

Asked our architect for a pointer, hope I'll get it soon (he's OOO,
might take a few days).
