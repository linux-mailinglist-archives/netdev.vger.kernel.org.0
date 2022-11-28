Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C075E63AAAA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiK1OQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiK1OQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:16:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF28659A;
        Mon, 28 Nov 2022 06:16:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wql2f0DMNjB8iA5Bddtle/YZauwjD907t4DQh+5aHJxviZ9Cpywjea9vatPtzwNdCI0wj0yO1gsPJ04PYhBCcX88A/0z7CQiqTsOcMnvCzRInx7uLyN/fjabRRhg4+g98b9+2pQIPfM9V9MJurCgAUrTXHDdemTigf+TrJTnuE2hA8yNvBgk2d8PbLRW1x3Q0nBMC4zMlICTLLAmPJ2RR203uBXGO6w+DKYYbTR0HF6PlSy169Ny3t5LE8TuyvzVzW75/wy2pnt9CkhvBbTIb+IGtn6Ckg2Q1frpEWm1kpPhNpEM7h9gAdTScAZHS/ea8UT7pJHA1CDw9KgVcGP10A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqZ2ovek96zJgtCIfTuLDLaNRAhoJYeEY+x6HUh+tO4=;
 b=K+5COq8+mP59piQCQP2W+xyEN3XsiAUPDqPNpSJOeQK895ByeKJRpaEUi4NJxLaZpSTPOqcpj/azU2XhA1W3PuKCkMnrqN33Oan7pNcUAgyeMDG//ywLFvRyUGZ2oFd986oci3h/djXscqZPnUMjc0NSYFOV7bmDQvaiJaVG5xMlQ2ZxHPag3KkTbpV5ErAtGJGZidI3AYl+dz/nkF9li4Ln7mzLcQZSUwQ5iVEddiu8/GWND8HUohO2h+Kc1jwFG3Jxw4F/ufnpRb7Z3Q/Ei3bzuuCKKs7QgyLeNNXvBaAb8SwQAYY75RhiqAwfBoFeQwtMJOcic6TGHr+cBAIYfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqZ2ovek96zJgtCIfTuLDLaNRAhoJYeEY+x6HUh+tO4=;
 b=SS6r7qOxGDJ15AoA0EbOSrN+9qJka1kPG/0vZJu1Tm1pJGjSgPsovP361OhgAuCkBpC7q4tmq7NvJwpvbQ0I7B4xWw9SScIFguIfU3FaFYtCyfcwmBQI/Pn3p02WOgh3IwtMIFNxfiZ8gOavDCAOFm7Ma6lxvtPaYYLxSjedhZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CO6PR12MB5426.namprd12.prod.outlook.com (2603:10b6:5:35d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 14:16:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d2d2:c91a:5927:104b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d2d2:c91a:5927:104b%5]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 14:16:02 +0000
Message-ID: <fbf2cdcc-4ff7-b466-a6af-7a147f3bc94d@amd.com>
Date:   Mon, 28 Nov 2022 08:15:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <01d7c7cc-bd4e-ee9b-f5b2-73ea367e602f@linux.intel.com>
 <BYAPR21MB1688A31ED795ED1B5ACB6D26D7099@BYAPR21MB1688.namprd21.prod.outlook.com>
 <SA1PR21MB133512D4B7B78DB38765EBFEBF139@SA1PR21MB1335.namprd21.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <SA1PR21MB133512D4B7B78DB38765EBFEBF139@SA1PR21MB1335.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:610:54::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CO6PR12MB5426:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ecb2ecf-5a97-4bfa-ed65-08dad14b1449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+QoF1RtLXqO7H6EJyloXOiSayKKqE8SqTWFUvDZc5Uu6lmV6lOqpG+6tDZhoyINKiFkhAj4BLTKHCUCUBZDSekUZCVERw0YaKRSkN4nT2hTsfGeRpTpBYVM7W3RBAwS/5oWTBlkwo54gzB8ZnlTiax3do8RWRG3STbQfEb/TwNYWx5snD8hLeuyZxJrdAFlw0R7GmqvTKTtDeKW6eygCu2VLlmTCYI+QIecEnIKSqH/OKI+kNBoyinPuAG1w+UAF02Nuu+gW/kEJGmLdysRd84egaYz1PJDiO1VMrqezvZFlsyp37TaFcqtCX5JLJovkUJf314B6B6fkk/Dz+tB3OZazucYgf9qL+jGrGEzY1JKL5jxXEZfSvThpGX3232unPI5zjL01ckbbPxMhFHTO8wVl8kgXqoCXlOPR5PpvNFI4aG+C64ZXi1h61HwUQBih7DHm2Oy6nfqWscD2dXGphmIfeR52MGyNtXBPcgyw9zgUQuJfcm0lWgQKWvTpG/gn2icI19o+ioeBFL6K7jNvNDMTAaHL/qn/J0o1UwSoJfdsYBPOKEqupZWIxEq3tOTeVO7ueBtLrWBkdfS0MI3qtQV08bOlH+8UKYf4rL6MYt9v1pQ6U662ybWKbXB77JHHrTpTFW7H2u0cYg/3by+brrvhNMi6T7mDEVMaS+hI3BaX7Tb3C2S4I3gZve3kyEf3iZxRj47EUIzH/+r5gr2eDkQGK6/6mBBGR05SKKWlPM2GjWvwHbqxg+elHmPOB4G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199015)(921005)(53546011)(36756003)(45080400002)(6666004)(478600001)(38100700002)(26005)(6512007)(6506007)(6486002)(41300700001)(8676002)(66556008)(66476007)(66946007)(2616005)(86362001)(31696002)(7406005)(7416002)(316002)(110136005)(8936002)(5660300002)(186003)(31686004)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjhZblI2cW5rOE5XNFF5aG03dzFmbmNpb2Fic215VUtWWW9hTENwM3NuN3Zl?=
 =?utf-8?B?U2gzYXJob3lSeWhWbkRwRFZybDdUZWdCNmdPQWxnbm1UYkYyYTJDTk9zL1lR?=
 =?utf-8?B?OWF6MW1wbWorTDlkc3crdFQ1Yng3UnRzZzV0Y1lwSUVYZFBma1hrUmt1dEJH?=
 =?utf-8?B?U01QMUE2QkNJRHE0L1FqWm5tU21mbVpKblZSNlplckt6Q3VFMzNBMHk2Rk56?=
 =?utf-8?B?YmU4aXBJYitMSUhBOXhIYnQrUjIxL2VmTDdyYTMwWjl6ZzRWdjZ5L25BZlox?=
 =?utf-8?B?dzcxK1QwZXFDQWVML3JVRitSWitNdFFIbjNLMzd0T0JBVUlmRUJhMHQybXJF?=
 =?utf-8?B?UDZNdFRmdFV1Uk41cVRqYlVocnRtc05jaWx0L250TTJ3UnpxODZKMlRWWmoy?=
 =?utf-8?B?TTd0SGNoWnRiRmV2aG1ReHVIeHZVNmsyN0hFeHJpcmpNMDkxYS9XdHRMekFM?=
 =?utf-8?B?WURxUGZBZnVweG9aTFcvN25IdHpnVFU3anV4aUY2OWVPR2lNMDhGbHZkOWtZ?=
 =?utf-8?B?NGJyWFpvRVlTYVcrTENRSWxpTVlJYnZTaWwwS2w3UGlwV29mWG1vdVlRazBk?=
 =?utf-8?B?NzFkcEtXa1hzc2xpT3h1VTdBV1hNamFscmpxeEN6WTBVU1JGSGdocEZIVDhj?=
 =?utf-8?B?VHVhZGVSelFickdnZ25YM1NtRHVNWVljMmhtcUNnRmRSN2YwcVgxTnpOUDd4?=
 =?utf-8?B?eUU2M0lMbG4vT2ZqK2lISHM4eURZRTIxbUZieG1DQmprMEk3UGxZUGdNdFZZ?=
 =?utf-8?B?S2FObjludEEya3FjcHl3Vmk5ZWlsaGVveXVIcFNlNjNJUUh6NEM5WG5NbVlm?=
 =?utf-8?B?aXp6WWxzZ2RDWitVSjdEbFYvWFpKNW41emdKRWYzdC9NYWhtK2FoVUxsQ2xF?=
 =?utf-8?B?WkFtcm44VHM5Y3pWa0xpWU1NakZhWHNEUlltR3JraDMxNnBsVjFSU21CUlRU?=
 =?utf-8?B?S0QxVlltd3FPb1hBTkRNaDNGZFV3TWNGVTRxRGZzK2pndFBSS1RjbjFrcjNX?=
 =?utf-8?B?dFQ3akNDU2MyenNZdmFuejRlakNMeElZQjczODgzZk1xVVU1Y09LK2pvYUN3?=
 =?utf-8?B?TWFKenRUZncrdDdTZkE3ODUzWmtpRE1qVjkzRDdhREt2K09ySHVlamx1Tmlv?=
 =?utf-8?B?YWZsTk5ZeGNDTWU4akM3SVBMUHFqMkxnRXJ1eUsyY20xL3Z1S1N0V2lGcWI2?=
 =?utf-8?B?QTl3cHh2NXBLWkg4MmRka0NNY3N2MkhVSkxFSFVxSWhYZytIMmFvYzljTHVH?=
 =?utf-8?B?bHJITHpHUjFHaFlFV3BJcGpvZTBIOTJnU0FINjBLVm5uK3VCcG1sYitQMmM2?=
 =?utf-8?B?RFZJWnFmRmxxUHZwclphTitueGNsVHkzWHl3bEhvVndqaHEySG5KMlpzakpv?=
 =?utf-8?B?U2hiVStvSFZSdGNjMi9GLzRhc1dPQS9YTnpvWXVxS0hYK3VqSncwT3dSN2dT?=
 =?utf-8?B?TVk3Nit6UjB5clZyWVIzQkdNMzZ0dTU4NE5RckhSUDR0RDZkKzh0YUtUTGtT?=
 =?utf-8?B?R2M2ckoxdEx1aXNyeWs4VjM5bjlUQm9rd2JqRFdGemVDdmRhOGFYM1dlQTRM?=
 =?utf-8?B?NVVUS2M0RUVCdWtqRVdiN28vZVdnbGE5Zmc5LzJxbXNJYUwwc1ppQ0ZBc21N?=
 =?utf-8?B?N1hMUjBVSU8rdENFemJGYXZmaWFFNUJDd01TNEtZM1EyVmJadWVYR3ZudnlW?=
 =?utf-8?B?L3hoU3lzbzUwd0ZnUWp6WUFZT1ZMc2llQllRSFNuWHh4WENSMTdSWjNaL1Uy?=
 =?utf-8?B?VHFjV2FwSzA2Ym9ka1lzM3BEanlEWHlUWkZSMGdnL2VUSHZGWEJnSGhSajQy?=
 =?utf-8?B?SGxoMjlVSnhVOHZBK2lmRFJJOGUvOEF1cUJmd3ovR1ZjMlZIZzZNcVlrdldp?=
 =?utf-8?B?VHV1b3h1MnJhRWxNVHowK3RJRXFpREZEMkwzTDVKL2o5QVY5WEdpSGRKNHlL?=
 =?utf-8?B?VUUwdWVpRnpxTitjUTVUSldsUE5RYTNGZnVqb2w3MU9QQXBUOHY3NXNzWUdn?=
 =?utf-8?B?ZmwrTkdabEY0YVdNdkRNSG00NXJjYjdvYlA5VDA0YVczcVdjWEN1c3QxRVBs?=
 =?utf-8?B?UkdEUFFkZDk2TzllcmhLL2U3R1h5SlByaEVQL3F0SjVCY2pRK0ZTUGZCc09O?=
 =?utf-8?Q?l0gF+56ui57ZIaCA7AcaLQXKv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ecb2ecf-5a97-4bfa-ed65-08dad14b1449
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 14:16:02.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjGuXdJBHaP6sgR1nFeJ6OpW1NUYL5d7l3kDN9uKna/wC6MnONlGEhqwesEkC8tTeINDa1rcTLhcoXrOAC9I7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5426
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/22 20:52, Dexuan Cui wrote:
>> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
>> Sent: Thursday, November 17, 2022 6:56 PM
>> [...]
>>
>> But I had not thought about TDX.  In the TDX case, it appears that
>> sme_postprocess_startup() will not decrypt the bss_decrypted section.
>> The corresponding mem_encrypt_free_decrypted_mem() is a no-op unless
>> CONFIG_AMD_MEM_ENCRYPT is set.  But maybe if someone builds a
>> kernel image that supports both TDX and AMD encryption, it could break
>> at runtime on a TDX system.  I would also note that on a TDX system
>> without CONFIG_AMD_MEM_ENCRYPT, the unused memory in the
>> bss_decrypted section never gets freed.
> 
> On a TDX system *with* CONFIG_AMD_MEM_ENCRYPT, the unused
> memory in the bss_decrypted section also never gets freed due to the
> below "return;"
> 
> I'd suggest a Fixes tag should be added to make sure the distro vendors
> notice the patch and backport it :-)
> 
> BTW, I just posted a similar patch as I didn't notice this patch. I have
> replied to my patch email, asking people to ignore my patch.
> 
> Fixes: b3f0907c71e0 ("x86/mm: Add .bss..decrypted section to hold shared variables")

I think the Fixes: tag should really be:

e9d1d2bb75b2 ("treewide: Replace the use of mem_encrypt_active() with cc_platform_has()")

since mem_encrypt_active() used to return sme_me_mask, so the checks were
balanced at that point.

Thanks,
Tom

> 
> void __init mem_encrypt_free_decrypted_mem(void)
> {
>          unsigned long vaddr, vaddr_end, npages;
>          int r;
> 
>          vaddr = (unsigned long)__start_bss_decrypted_unused;
>          vaddr_end = (unsigned long)__end_bss_decrypted;
>          npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
> 
>          /*
>           * The unused memory range was mapped decrypted, change the encryption
>           * attribute from decrypted to encrypted before freeing it.
>           */
>          if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
>                  r = set_memory_encrypted(vaddr, npages);
>                  if (r) {
>                          pr_warn("failed to free unused decrypted pages\n");
>                          return;
>                  }
>          }
> 
>          free_init_pages("unused decrypted", vaddr, vaddr_end);
> }
> 
