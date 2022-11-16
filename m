Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3572C62CC5E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiKPVOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKPVOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:14:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E62F3F;
        Wed, 16 Nov 2022 13:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZDNLDrV3vIJhll8XjCIotmTR3HMnEZ5raROKkbfxVVVzaOc+I6VA/jRU/eqwhAxmGMfZ5gIg+iK0rK5lEaiWyJKlWZKBeY7CfOrMueyTU9TsrMLnwY70z/3scUTM8TEhwchL0gOpeknHx49aqvqFbSnNIEHTfsyayBjdZmCmGwzEJya1WUXWt6bomZP26Wa//wUokRSbspSkD5Q9ewL8j8Q7wapRVqf9WQhfpJv594txe2k0BSlCNLBgQTuC59CVaQnBDnm0JFhR7UQFdsD9UhHyHntMR64OHig7uOXVOuOMOrYfFjer+vP9wjHktKs6yPltZRh4u36+t/Nv4ZUbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uw7BmxV4dH8kfRSP6Gqsd8VEZ+xNkHW7CYxy+zyH3+Q=;
 b=DbnKq/4rsAxPQJgBwhAWbroGmiVgtpW7jCTRphXeQvm6XUlElmt8B3SM5Y4Pq46zPyoYgWvuwJSFDhecrb8LivCXHGAVtPcjOXCDsOu45+7LI7WMNQkVroNQQRCCwchhd6U9WBgOMH3GPh2muNZRABlGIxgKIQTyUNDCzTgmuktVPOSR3Ewx/QTEHO5fV7YTRWFsEpZoaludT7hTS6ve/6IwSRZ08tovRBGzYzap9o14j+7qzJX42bjbzmCACZgqJ5VXvtUpqhtMiM5q+x7L7NI1Ey6PBBE+u0J25e8PM2oEgUxQrlj0mOTd2NNwFHPuw62BRNePEfmYcNqchOINKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uw7BmxV4dH8kfRSP6Gqsd8VEZ+xNkHW7CYxy+zyH3+Q=;
 b=hwcyGO1b8OkmIe+OqSJYti8PS6ZkEjZJggr0ikG8yVDikk8qptrx4WDnbvUyeeOWyczWf4KWPZ5urXZzucssLxvKYmvi8+fPQ8b8B2KzKmyRItMDv+jQ6qxjBiQ0NsalUVLD/nytcqoeUQZg2lySNguAHAafyCrpd8ca+nQyj+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4941.namprd12.prod.outlook.com (2603:10b6:5:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 21:14:21 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 21:14:21 +0000
Message-ID: <b194eaa1-cc79-226f-b87b-3e58090ca08e@amd.com>
Date:   Wed, 16 Nov 2022 15:14:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Patch v3 06/14] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-7-git-send-email-mikelley@microsoft.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <1668624097-14884-7-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM6PR12MB4941:EE_
X-MS-Office365-Filtering-Correlation-Id: a0e9be25-e07b-485c-e229-08dac8178768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C7MidTFs03QniomSFQsjpjHWoDT2PkiOEkxLDLcxaLLf0PVicpVhj3iGcLR2a+IqkG8I7WRmIUaek1tTvC5jqC8Zb3uS0G8OO5W7e4WkEDEaFo76+fpgF7KK1mQhyTIsTojlkgwZvtKAiMNSNpXVp96PxLWYVl+Nm0CBrHutfy0YGK5YPr/rLDkmEJ6xqYTbUj7eh+eCWzNKs57UuEzLkVRpnoN4St2C2YgoUXHEyqNZzPTGpV82KhW8b8V1U+puMUWsFADNWgKFg3410QiWaooi2Rzf+/m2HsFbuWUMjInK3+dra1wEZj4zC9kI8aFUhACnfNpjNWLOraYHWb4f5eeaAxeymBBadULxiwSrGvOwL1KEVaXlrtflMSIJB/c/FmcSo3NAthMhlQ6gvbxmxeUZ4UZjEz9kFh7MnzhY5r/LCWFohbjngfnplKn97DRrOynEQ9OH5smBh5Jb1W/mBlJYQgJyBvHQs8rrqEFPn0cpveem2zJvg6TPnB6uhysyEHMoyqjfmOXIlHHvl2/zYotGZ2H3ABfQA+EEtl6cHF4NtxXBpOF2jU3eymU0osZQ6xjLpcGqbzeTo7plniEPlhvQWcm8soi4u3HUtdBlKpbPLMheZfZueGA/2W3YcHQwp0vi7XagBQ38HUK4j2Vlg4WBDPa+Hf8I0srHD+GLk/xKW+FFLYnqJ01y+FBhsZ6QiaDnMQBvBWIUMnbb2SU3ddqoRGvD/c88gKwfm4NM/gNjlAJEA4lqq03Y02ZLfrZE9MbjZL3YAorTOYbLAbQYXjXKOHR/L5n+ftQQP0qks5WjF9/fbim35T9d75V5AyCs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(66556008)(6666004)(45080400002)(478600001)(31686004)(6486002)(31696002)(6506007)(8936002)(36756003)(7406005)(66476007)(7416002)(2616005)(41300700001)(2906002)(26005)(316002)(53546011)(66946007)(8676002)(6512007)(83380400001)(921005)(86362001)(186003)(5660300002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mldhelg2US84MmhOMW9POTVNNnA0R3RwRU1aSk5kNXpwU2NnVE1aL1lBSjdI?=
 =?utf-8?B?ZXRGSTNWamdzWm1JQkxNVUxtTjkvWGJiME1tV0lPbG00QVJPV0dGU0xnNmhj?=
 =?utf-8?B?bTBiS3BFeDVUbVMwMzhCUU1qUldnTTZzL2hML0gybWRaM1VPZmtXQ0FONk5H?=
 =?utf-8?B?ZytFY3IrUFJsb25hUVlpRWpCa3cyRHU3eUlGU0lZT3VPUjV3RzVsSENCMTIw?=
 =?utf-8?B?eTlDa0tUakxMSmN1U1dpT3dWaVJsemYvbTVpZ29SRlBYTXo5M0NWaHZWKzRm?=
 =?utf-8?B?V2tLYUpMdE95ZkJGcmZoL1p2QkJ1aDlVbSsvTC9tdVZ2V1VINVhDMjl5cFVD?=
 =?utf-8?B?a3pDMVBGTktDRUJTWTV4NURna2tSNENFTmw1cGUxd3NjdEl4cDZYUDBNVHJY?=
 =?utf-8?B?MzRFYzd0ei9tRDB3MUJpcUFoWTdwUUIxaHJFQ0UwcllpNHl0Q25UMjFKbFZo?=
 =?utf-8?B?RzMwc3FZYmtTYWxvZldCRHpYUEkvb3lzd05RY095Wk9pN3JNTzNSY2RHdE9Q?=
 =?utf-8?B?RWVlVXgzMTlaQnVFbXhkOVp0cXVOQllINVFCVW9mSk5XMlgzUWtVY0xnSTBT?=
 =?utf-8?B?VVliaUVBN1lUdDVUVlFKNjVtTXc0MHZPMzFLUGF4OTNxVldvNm1aYnZSTEpN?=
 =?utf-8?B?WVhmbW1vT1c4aVlaaFhzeDB2QnFyQWNiTDJNOG03QkhESmhiTnRwQ3Zydi9R?=
 =?utf-8?B?aExRQkl1Szk1UjhocWVWRFFPQ0piQ1pSNCtsK1d1aDVsbUhmTVBwY29OVWI1?=
 =?utf-8?B?b29EVTZVcm5uRytRSm03RythQU41NWZmVFRmaUtpMVNER2R4b2xzWGF5TkpD?=
 =?utf-8?B?bjBOUGIreEtscmtpYmNtYS93UWkweEM1Vi9OeDZNcGMrK01CWERvemdpemk1?=
 =?utf-8?B?dnQwNGpzOGpoQXUvT3EvZlA2ekpVREpaZzNjRElqbHdhYU5BcE82Ykl4Q3Jj?=
 =?utf-8?B?MGo5amRkR1BpVnl3RTZRY1Y4Q2k4czMrUzRvb3k1Wnl6WDNwTS9GYi9HR1Y5?=
 =?utf-8?B?TlZSWUFFbUFiT0NIWkhNTnpneUZZUkVEM0VEeWVWZ3RmTWs1bnFrM0ZNR3Fi?=
 =?utf-8?B?RmVXRXVrNGduOExjZnp3NUM2ZWY2QTF0VHMxL0lMTnEvLy8xOEF4b241T0kv?=
 =?utf-8?B?T2VxMXEzRWFmM2l0alhmYW42QXJhTyt0M29hOVpBTVFhbGpaWVNPaUpBMStr?=
 =?utf-8?B?QS95MksvQlJaNVlpY3pJMmo4aWEwazZ2ejNJRHdNOFI5SjVubU9uU2c3cjNX?=
 =?utf-8?B?enNtM01TY0RhWDM0VWxLNEJTeDhYMWpVVUpMVjdHMzBiaGRvR2ljZ3ZZa3VG?=
 =?utf-8?B?d0NMQ0cvc3p2dmtaaUZTbE1mdVFzamE0K2xJTWtOOXRtdTRuVGppaFUwNTJU?=
 =?utf-8?B?cjBidGhaRC9iQ3dtZ040azVyWWlVYTRybnlRc3lvUTJKRjdBY2RyVVg0K1Fj?=
 =?utf-8?B?enlyMzlnTTJzR04xY0loRmp1UER2aTRxUSswanBKTG1HQ296QWlDVjEwQXlU?=
 =?utf-8?B?WW42SlBoeEJKcEQ0dzhvL1ZlSHQ5VnRrZmV1YUpIUFl2c3paL24zem5hSXRw?=
 =?utf-8?B?czVtUUxWVDF4aUR5YmFrQkE2aHFwa0FodktXRmZ1MW9CdWwrVU1JRXpZbWx6?=
 =?utf-8?B?ellDOUxsa21rMmpvZlZTSWgzY1k4K1pXNkxNbmpxTXBweXhETDI5WDhTK3I2?=
 =?utf-8?B?VURDb3RsZjloeVIrckV5OXVTbXFWYmpsRko5L21mMlpxaXdrR0ZpditMK3NY?=
 =?utf-8?B?YXFOcmFQSzdpK3M5Tkkyb2xXeDBqOGwzVDdQREc3eVIySHZKSlpzaE9KL00z?=
 =?utf-8?B?MkZZeHdmNHlQa0t3Z2I0TEhlaGpCSllSdFFnRjdxVG91dGhxSjc5YmM2S2hr?=
 =?utf-8?B?R1dTcmNRVGNOcllwcHl5WFVRSkdVVllPOWpRaVltelU0RXc5aWcwZEF5YVdy?=
 =?utf-8?B?UU1rd1RsNlZkd2xZclRPeEVFTC84Tjg0L3RzYlA3MWVONFAyQk9yRW1VQTdH?=
 =?utf-8?B?RUpRMmF6bm4ydzUrYWZ2a3ppTmF5VDlLbzhRWlUwRjVIZWpCQkNmUDc3M2dJ?=
 =?utf-8?B?RGhnckFyazR2cUk2dFFWcDNia21KMTZSMWNVNkU5UGVCQkpQd2UvdTdlcElp?=
 =?utf-8?Q?JBYRctXFqGZ6d+BAoYWSQDZCA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e9be25-e07b-485c-e229-08dac8178768
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:14:20.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrjI/nT8EmVK/6Wa1nFdh9Ra/YYjictTrpu1DvDc+6ACvNDfwLTrV4yxOGrZ2+4K9Hw/WCKu2SvgMu2z12WEEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4941
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 12:41, Michael Kelley wrote:
> Full Hyper-V initialization, including support for hypercalls, is done
> as an apic_post_init callback via late_time_init().  mem_encrypt_init()
> needs to make hypercalls when it marks swiotlb memory as decrypted.
> But mem_encrypt_init() is currently called a few lines before
> late_time_init(), so the hypercalls don't work.
> 
> Fix this by moving mem_encrypt_init() after late_time_init() and
> related clock initializations. The intervening initializations don't
> do any I/O that requires the swiotlb, so moving mem_encrypt_init()
> slightly later has no impact.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>

Some quick testing with mem_encrypt_init() in the new location hasn't 
shown any problems under SME/SEV.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   init/main.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index e1c3911..5a7c466 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1088,14 +1088,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
>   	 */
>   	locking_selftest();
>   
> -	/*
> -	 * This needs to be called before any devices perform DMA
> -	 * operations that might use the SWIOTLB bounce buffers. It will
> -	 * mark the bounce buffers as decrypted so that their usage will
> -	 * not cause "plain-text" data to be decrypted when accessed.
> -	 */
> -	mem_encrypt_init();
> -
>   #ifdef CONFIG_BLK_DEV_INITRD
>   	if (initrd_start && !initrd_below_start_ok &&
>   	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
> @@ -1112,6 +1104,17 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
>   		late_time_init();
>   	sched_clock_init();
>   	calibrate_delay();
> +
> +	/*
> +	 * This needs to be called before any devices perform DMA
> +	 * operations that might use the SWIOTLB bounce buffers. It will
> +	 * mark the bounce buffers as decrypted so that their usage will
> +	 * not cause "plain-text" data to be decrypted when accessed. It
> +	 * must be called after late_time_init() so that Hyper-V x86/x64
> +	 * hypercalls work when the SWIOTLB bounce buffers are decrypted.
> +	 */
> +	mem_encrypt_init();
> +
>   	pid_idr_init();
>   	anon_vma_init();
>   #ifdef CONFIG_X86
