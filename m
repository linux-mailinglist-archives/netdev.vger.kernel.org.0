Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCAA63F806
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLATT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLATT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:19:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35850B3915
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:19:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEYcyFjKmqo1Cf/4/YDSlZiSNmFhvPjGnguPL7+d47fZ9KXJNEjRhVNv736p/gfhaX4yMDcIBtdsK6J/QpAY7RFE8SO+PGIrkqeUsJUSqn2WJiTrgoyVin0dztBowymcUYc4LCBCUQ1e2zw5Wtia2DZCzgM+Eux8dJnOLKsn4dGRthBd9ZjajmDaI2wNWQVckjmmxKXl0Wzb76JNg6+kVW3OsGJunzYGAxbjtbPcslojZKB7aJNbL29y5ileLTSkx5Olg9JHb8dBC0zVxMLwiHVxFtYRTb4y63bi3PFhljYmLh/sjhX19Cf6fAFe6vgphUSdhmxTj68dU/CSsK/K7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMEsJ3fgdPVBzlY1GNTXUrkgxtfZy3pz2wpgReVVCnA=;
 b=Demb0HJbvig9LGbRolLQ7ALEyWC548B32rkSsHPf53n68CYbb7xFHG4RQ8gEWzl4kRQDxf6KdiXxsYuO7HYpGxqqZRXY2KlHqJ5LQvMWIogjpLv3xirbvCPYdbqFOy/cTojqdhJT1gMvhSIgAHW24khKOb8ygJ3Gf3kBR10fUwgKCU4/skCBOIbmDcHDZ9LyPv7cNjefCeofpK3324IkpBGEvotNh/Cvhx1JHTGTOduDevCAAGBQ5m5ok3ckcztY2EE171ZAlRbAU3yRMPCqTO/LcXThIcjIboH31CoDTVEJhgoY6XVjp7m9dTxP5/bmnshSqin23PNTJEZ+1s2GHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMEsJ3fgdPVBzlY1GNTXUrkgxtfZy3pz2wpgReVVCnA=;
 b=5Ot0RraSazPsd5uLqO5AF4bCFbw5x78SLDGnpwiFBna1E6XfqpPz4RrBU0gmQBqYwB1rc1g9Iv9TXo7x3uZX1LHzv/MA5GJZ23pN9j1AT/E3tRRg+aGi4KS8n6apyURC+t4zNYPNcxpG+vhs/79zMRnIeDA7KkbhdMFEBSCO1O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 19:19:54 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 19:19:54 +0000
Message-ID: <6a174081-0187-551c-4b34-17a59ad38230@amd.com>
Date:   Thu, 1 Dec 2022 11:19:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-9-snelson@pensando.io>
 <20221128102828.09ed497a@kernel.org>
 <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
 <20221128153719.2b6102cc@kernel.org>
 <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
 <20221128165522.62dcd7be@kernel.org>
 <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
 <20221128175448.3723f5ee@kernel.org>
 <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
 <20221129180250.3320da56@kernel.org>
 <b839c112-df1f-a36a-0d89-39b336956492@amd.com>
 <20221130194506.642031db@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221130194506.642031db@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB7734:EE_
X-MS-Office365-Filtering-Correlation-Id: d05c5a36-d177-432b-1745-08dad3d106cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Im91jhWKi91gXdqFx7WmhfwjiW7BdIE9Kh0J4Rb7kCnkMIPyn3RpuI5fXsZhT5cWzvlx8SNUXVSub9lG04EwHEyKCkN04i6B0enjacRCsEVC0eLDEelcP7IDlD6j08ivUVFUObHxXwqGo4sf+aKZkdcE+HIugi7Qgx1p135TSpFe2+9oNBzLDdVRDqaGSjmirV5NCdD97UA7WnajvA48AbvvEpvtIL8RsZcRXGwEbhNp9HdkBrv5TUTGO96gpbSB+hkcfE7zDX8Tgc4l3Clht9h+LM+I+b98JvArF24omMbWZIeeT6RrWFwZRNSO6TmtSqewZPf9ZnumUtkA3DAGUPROAOSXdg6FXrfh1l26OWPDuJ4Whr4hlyvFBNnl3TK1pUXxFmmY4Xw4j0VNKdKcO2JJH3xfzHr5vS48bBMb95/eq8yqNt+xbkwtAgIqOyedFnmutF2nGXv7Q9dxfsSz39N8l05tX/vvmWfDTMrHx+08UU1RME1O60AbOqyVmP5hd0URzyNXrnp0NFIIWw7VJ34qrg+6E709VgKsoFKzXkqKu/aLdEv2UiHlMUg9MGJlewZG8NBloLr27vbQaP7xTPQY55jyg5cB3xU1+5KMG1R1Tt50GhigdUbR+GJNEEb4xVQto54m8/BdxdunGMqrK/ezm+Fz/bdt85Ht+64tUkUdqOboU5iEavghzEilgAwvqzNI1ucW+Jn6L3ZAme4hIpfeg1YJbQyITXDUYzZQ3o0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(5660300002)(66476007)(8676002)(4326008)(31686004)(41300700001)(66556008)(8936002)(6486002)(36756003)(478600001)(316002)(2906002)(31696002)(6512007)(2616005)(6506007)(6916009)(66946007)(186003)(6666004)(53546011)(26005)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnlPK3JHNzFpdE80QUpEcW9Vek1zM3JZeWI1emJPT1VQOFpMd0Z0cTlReEht?=
 =?utf-8?B?ZHJLT0JLbUo4d0xPOFVsTzVvc2t1UVlHb1pDZ0VXNmpzUk5FSmU5S3MvYlFF?=
 =?utf-8?B?ZjNXSkdZT09wUjA0aHNjdEx6MEo3ckREMXJxVGd4c1FGMVJyaXZJdzdsYmY5?=
 =?utf-8?B?QWNOK2wzU1lSejVPdnIxcWJpRFlTaUJPM2h4a3pjU3ZIZFNZV2ZtRVlFSkFH?=
 =?utf-8?B?MzRjZ2FTak9yS2R4emVWSGluSHk5aHd0ZGVqeDRoeFl3K1JqOWR6dVpXdWFV?=
 =?utf-8?B?ME5RbG5kbDFoNGtla0VGV3VqNHd3ZnlnUEhRVW9BaS9YV3pZSXJGTzFtSVFE?=
 =?utf-8?B?TXAvcTJYR0ZHYXRaNVVLY3dub215eWROZ3gya0d5VXIwdTRVRDAxMG5PeEht?=
 =?utf-8?B?WjRFMzZpSENHMVJPU2F1WGorZ3pDaTZjTC84WFVBek1zTUl0WDRJN2RFS3pF?=
 =?utf-8?B?Rmova0dEMnZHK1o2SVNxYXRpcmtRbmVMODN5ZElWZFhxVFo5dVN4TnlzVDdq?=
 =?utf-8?B?cGppYVFTeUwrdHFwaE5BaTJyZTFvMHVyN1I1bEtqRy9tayszbFVGOTVoSUdr?=
 =?utf-8?B?THFpSmNvT2Fkb1h0MVJiZWlQR1MyVDZVb2hVcXovYXY3c0s0Q0F2aUxDOEZQ?=
 =?utf-8?B?UHJaOUNaQjY1YzdkZ1loZE8wczU2dWFURThiQkV2V3M4NGxBOHFhV0J4eHls?=
 =?utf-8?B?VWJsMkZNcGlBeUhDNHpma1pOQXpPOUxQUDJDWVh6ekRIbGZtelFNRTR2QkpN?=
 =?utf-8?B?aERBSkZYRlY3NENnOTBhZDFqcVd3SmJTVVBwNTVCUFhuWjVDbXNYcFE1N1pI?=
 =?utf-8?B?ZWxqWkRqR05qN20wS1NkTnVLNEFkaThITmRCdGN0U2V5TExPN1BpQmJDS3R2?=
 =?utf-8?B?NkJmb3BUYzhDa1JVL3VkZ2JzZlM1S0daa1k5NktONTlBNXVSd0JNUHlVeWlL?=
 =?utf-8?B?MnJXc3dMejJHOWF5T0hDRnJ0cEdYeHdscmRaV3graTduejRwY2F4VnB4SW1z?=
 =?utf-8?B?dkJ3aUVYT1VyM2ZNbnhFZ2p4bFhHZHJ1YUtWMVRYek9JWm5xaGx0YU1IQkZF?=
 =?utf-8?B?aUZwdS8rNUM3anFTU2FSM2VBblhQZDlVU3BLOGp4QmxDNTk2OFhPTGszM25i?=
 =?utf-8?B?dFBuNnJMbTc0MUEvcTN2eDFmU2hDc3VTRXlyRHRZd3doUGVlUGtyWE9Yb3FP?=
 =?utf-8?B?b29ZV0V4dWN2NTJPeG5hUTZSS0VRcFplYnRNN3k4ZGVyaTIzLzdUQzZrYWpq?=
 =?utf-8?B?ajd6TndCY2hGUDUvRE95eE1seFcybXlzRnFMM1p2Z0U0cW9PMjZVenNkOWxM?=
 =?utf-8?B?cGRDWFNSWjg5Um9HTERhMmFZTm0xM09IekF1OHJMbVJKekhrYVI2SE9nOVIw?=
 =?utf-8?B?ZHJUdG9IblhXODRPTVFTdGE5VHRPMnVGczRqdmdoczc5KzRNU0JoWFZreG1I?=
 =?utf-8?B?bDRyZEc3eitOaGVtOGc2aU5aODFqeUFPeklNTjIzRGRRRlhSb0x6ZFUzQi9V?=
 =?utf-8?B?Nk1ydFJnU1hBM3VXdG4wcDM5YzFIaUlLaUpwTTN6VG53NTMyS29JZ2k0akp0?=
 =?utf-8?B?aUtuSkE1RkUvOTgyQ3BKMk5qc0xsVCsvUHB0cEpKWTFpZGlEdWJlUUpyWURD?=
 =?utf-8?B?KzRRMFZJbVhWcTN3VitCUEhDR25zRGtVQURHVW0xdkxYOVJNeTBneGN5bWN2?=
 =?utf-8?B?SlJFR2JrcG9oVVV4WE56UllIVlJTNmZPZ1hSSzBmRlhKVGZVNGJ4L1RGUzNK?=
 =?utf-8?B?N0cwd25YLzg3WGZaak55TXpSRS9BNTA0YWFXbEtqSEFZeEFGL0FUb3BadmN6?=
 =?utf-8?B?Vlc2VUFXQ1RBdi90NDVsTlpjUGhZVldqQmtnOUo1OG9ydmN4R0xRVFN2cmpW?=
 =?utf-8?B?OFF5cUhDRDlxU0V1QndVSStvVFBPWDBCMGlUOVQ0SElTSXVlczVteVhHRDJu?=
 =?utf-8?B?a3RTK3l5dlI1TnRUSC9xZnRjNjhpRW42YzJOdkw4SGhrOVhJUERRdlNNZUlq?=
 =?utf-8?B?M1YzZ210dEZFU3ViZ00rdzBWNTFvL054TUxhY3RGemVqaVRlanlCU24xSmdv?=
 =?utf-8?B?T0cwUE5WMkVLY1VncDB0UHhML1FsUkQ3MHIrZVhkNXA4UE93dGlqZGJackh0?=
 =?utf-8?Q?WUEyIqqiMjbaD0/g4sA8ikANG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05c5a36-d177-432b-1745-08dad3d106cd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 19:19:54.3482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyjPH/T+ZHxKDVgmD8uipTgMLaFWdjMq4ayJXvSGNWWqT8UGyaql83tTQedCw2GGUFm1/QOp+KsFMsr/EDkZhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 7:45 PM, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 16:12:23 -0800 Shannon Nelson wrote:
>>
>> We're not asking for a special model, just to use the PF interface to
>> configure VFs as has been the practice in the past.
> 
> It simply does not compute for me. You're exposing a very advanced vDPA
> interface, and yet you say you don't need any network configuration
> beyond what Niantic had.

Would you have the same responses if we were trying to do this same kind 
of PF netdev on a simple Niantic-like device (simple sr-iov support, 
little filtering capability)?

> 
> There are no upstream-minded users of IPUs, if it was up to me I'd flat
> out ban them from the kernel.

Yeah, there's a lot of hidden magic going on behind the PCI devices 
presented to the host, and a lot of it depends on the use cases 
attempting to be addressed by the different product vendors and their 
various cloud and enterprise customers.  I tend to think that the most 
friction here comes from us being more familiar and comfortable with the 
enterprise use cases where we typically own the whole host, and not so 
comfortable these newer cloud use cases with control and configuration 
coming from outside the host.

sln

