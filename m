Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A3D62C4F3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiKPQnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbiKPQmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:42:14 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310435E3CD;
        Wed, 16 Nov 2022 08:38:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyiyJcXJjCu8INIZ87KDxsqpHeoS86qNTBqxj/eLo0ltpWfpAYw/x+oAF0DEFrd/8xSJ3KJEEJrrGHSplHVwm2CS5TGbC3PisfZ/vYWEsFfWhYNuti08Wi/bA9QW+fIV0U553+kItO/0BnHy7xv0zGBIuFtI4SMMF7cuC4xP1S8yMl7JsWiiCjg0JvvlIrxafvemg0qWb6Oo4BLkEYOD3P+W5kn7se6s6adpi2sKxm1t/iJ1y4LdNiBt4Zfx2rd0D7ZZUhv36EuwcvPSmhCeHVa2FUPr1LgZZiAN8FoHTUXqkKyFDkGSJOoXwKTvv9cira+Ef3AYZkVnAk2S9Fcp2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMSqpaMQ5RnYG1UOKzcoFuI8DAY0tfNJKi6TP2uAgcg=;
 b=bD5Q8bpg6N91/dSg6LV9RveYEm/ESQEowOso1nlwCIw6x3bHoXSlHHd2WoDT86EOCNZxMCdG3GjUqLH9dMyeyoC9bcwKSm802cVt2i3GoWoyKkh880RnSyNkVwpTtrc6Jgy7+pXATNmAynmFBJ8p32SXXUq/0jUpeKQ+wZM9XJ+hrXRk7RRuaMiry9KT/YkN6neTThrmU1tgEzvIgG+eDO74feDw7pyM5RgIf3MHuavSpdtr6l3bNuCWQbNkHWwuuPKhytIRAHpaUy3XYYKVLvDyFcNB47/VnYM72IfvZB6m7BrEP8IS1yta7e6TMB37Ik4KiBaSmA/tg0P5kYc5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMSqpaMQ5RnYG1UOKzcoFuI8DAY0tfNJKi6TP2uAgcg=;
 b=kzhVnjR5I2EtqxA4uj2dMgEoEd7U6zAjxm7//8ciL009GtkTu+v4YON/K8wVP3O+0XjVTQIBIQLxls0vvd8UM9Kt5GbO6lX9tlxn4ZKo0JpbXpqfdBGEn8H40jWM2B5hV3ZNKAbxM2gccKkUDaIlPsaPNbfnU+hTkcd0TFmiuYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB6088.namprd12.prod.outlook.com (2603:10b6:8:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 16:38:12 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 16:38:12 +0000
Message-ID: <686b824d-e175-1997-7712-1eeee77ae9cb@amd.com>
Date:   Wed, 16 Nov 2022 10:38:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
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
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-6-git-send-email-mikelley@microsoft.com>
 <177144ce-aa63-58f9-d3ea-dec9cde482a5@amd.com>
 <BYAPR21MB16885EAC0F3670125073F32DD7029@BYAPR21MB1688.namprd21.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <BYAPR21MB16885EAC0F3670125073F32DD7029@BYAPR21MB1688.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:610:53::39) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM4PR12MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 00b3e63e-95ec-4cbf-5ce9-08dac7f0f3f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sk0EOBHjzcfdlZOZiIouJm4qFjeBva5kmqGReug0n6jMH9NnWvX7BVhtw/2M12VSGR5R9XQ7XG0+nKDy4SZAO4Dlwc1uiG/wLrQe0ur9yMyYZBRn4iZiUNjknX11iA+tlHhP9GHPF0jL+/bQjuVyWdhuYNZ1qmGdLOGI0vBIJqB5Mt+xsVQOjk+MtJaXFKVzqqBEZgljFEXENZyFTioRoTF/SchqwsPz0NzGdPKCagAuYM1ir+KWaBlOiBWlydVvU9/ihpVcjBmlmvz89N5uLH2ZkvwRvWCuX2fGPeF+lpUVe+fs82hjW1mSdE3A5ntyyuTEaZu9zlvBW3cOYsMGSUvsPlBBgrj+Dd7x8Ca/ED7lp1RYcA8J/CGMCUsjGnEKTW7bXgQkyequLXyZOF4mXXStsewrdTYakj/bYJGQAqPFW23E2T45+hum+RPfJLtP+w9+bFBJW1zFSypH5qgjAk3XRW+liqDPNTRZbAsLhQt6JpVNOtce/ZadajXWU1NzwlbcUmRP865aJbo2C3EalP9aA4/Pt8AjPPZwbjJSlW2S1zBu9IxyBPJyw7e47dHdJRoW98t7+k4CRxkQt1APSIYlt1BJRrHT/xuD04QSD6bIP7wySw1ZFq9V2gsajhlhbdzkAXIPsIUaK2SI5CIYBU8VO69aZV5jUggbj+G2PQ0jdl43NaWTotaJ1ZHmsld/FS6L23o/i+Mw7BotUiI0N7tDOTYqaLpCkjeTM6b3NyGw+YLwNUHSVBSS8cgq2BAJRxL9U6WMaITuPMsPL4w8AzM8X3rcAOK7RN5HNsYamsbij+Y9Mv7nH8FyX7m/CH+0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(7416002)(2906002)(5660300002)(31696002)(7406005)(41300700001)(921005)(2616005)(26005)(83380400001)(8936002)(316002)(38100700002)(86362001)(110136005)(66946007)(66476007)(8676002)(6666004)(66556008)(6506007)(6512007)(53546011)(478600001)(31686004)(6486002)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW9WaGs5cVRsblZ5dmFhY1cxYmo2ZGZLKzQyRTRBL2JGN3g2VS9UdEIzaW9Y?=
 =?utf-8?B?VmEyZnY4TTZsdnVnTVBrcGIzcUZwVjNHUy9BTTh1UXhnVXp3bjZBVWNKdSs3?=
 =?utf-8?B?L3J2ZDJJTGxoMkFrUnNyTC94WFdsY3ZJeDhWeWlkUnJNT2t2b2xyaDJFY2J4?=
 =?utf-8?B?aDk5YVVZM0JuTldHSHNtT0x6bjBCZis3YWtlRi9PUXA3YjRHZVovQ3JNeDFp?=
 =?utf-8?B?VjhqS2gvSjQ4RnJuRTNrTWxueDgvQmlFN0lNdFQyMHVPdGwwTFVxdVl0UCtP?=
 =?utf-8?B?cFBETCtPMncxQklFTWVjZnNNOW4rbVRIZkthSjNaaHdpNUkzZXh3VUxnVHBm?=
 =?utf-8?B?ZlEyREdmRnMzQ2tCall5RkxlTUc0WjNhQ1AyOWRXNURhNG9FcFdMQ1pwYlB2?=
 =?utf-8?B?Y1FGbW55OU8reGZYV1h5NklsSjdpc21HcnhkOHlkcUtkUHJ5RDBSU3drR2h1?=
 =?utf-8?B?ZDFaa2N6aTZ1T1FjdmgyQUk4WHZFanlnRHpVYU9nejVDalVjNlBJdXhpRS80?=
 =?utf-8?B?emVlZ1pVdG9kOFBsdWdYblF3Y3M4Qzh6Ymtac211bHZKZFFxK0pZRDNOWlJ6?=
 =?utf-8?B?VHQxdjdVSERiUTNHNE5jZ1RwSVdoUTRvNVQvZkxac0Y2bnY1ZnBQVnNvK2gv?=
 =?utf-8?B?eDB6dTUrcDZ0aklSb1hBNjFoQkpEM1BnZjA0WUxRNHFrekxCSHVBTXQzclRl?=
 =?utf-8?B?d2dOdDhUdnF2VWZhUnNNMm1HZFRNVUJwR2M4Y25aRlN2NDZnS2ZMODhhSkFr?=
 =?utf-8?B?bGM1NTMrSncyRCtSSkh2M2Ztbi9KMGlKTnBaT0RDeUZWRTh0M0ExTWwyME5E?=
 =?utf-8?B?ditLcm5TSlh6dEpvNG1SZVZVWm5ibXZxWlZrWjIwTGJnOEtTWk9mUysrRTc2?=
 =?utf-8?B?UTcwSGxNcWxyL0J0cnYzeG1WMTgwY3VzMlZVU1F6N2VrYmJ2TE0xczZzS1V0?=
 =?utf-8?B?WnpVWXZnR29wYUg0QUswN1dydEV1eXh2aEdUV3RsUVpNeS95eHR5WWlLS29r?=
 =?utf-8?B?bnh2L1pUTVN4TXBDMmwvT092OTlsZTdQSHRwOXEzT0o2SUNjdXJpRXplSGNa?=
 =?utf-8?B?N3NITnhORUhZT2VmN2dFZVVtT3ArN0ttalVnYlBHQTVyZ0Z3Q2JPZFJCaGF2?=
 =?utf-8?B?Y29FRUFNaUZNT1FmdXVlcldxeFB6YTFYSXpFS0VsQytQQWF2WXN2Zkczdjdm?=
 =?utf-8?B?czdWRy9TU2FwY0NYZ2RFSCtlcXJCVWhiWUMxVnhWL1lUWnkvQW1lbHNNZks4?=
 =?utf-8?B?T3M0Z0drUTNvQjRmVzBnMGw2R0NtWEtqMWlqY2FVVldJeTNaM1hpNkh6ajZv?=
 =?utf-8?B?OGROUkFYa0lqT0NkM1VUSk9BcnRnL3dUM2ZVbnJQWXNUOWpUckFaS1NmR0Er?=
 =?utf-8?B?ci80TzRDeFVKUUgydEhsSm13alBLRTFLcjV0WEowNEVSL1NVOEF3UzhQM21W?=
 =?utf-8?B?NzM4cGgybzZGeTFUNlR2clhhaElDYjVPdG1JQ0daNUUrQXBHbSsremY5RDhJ?=
 =?utf-8?B?TXVpRXZvdFhYOS8vallYMnFIZytpQ3FRaE5wQ05ic2xKRWUvbzVGR1hWaXkw?=
 =?utf-8?B?bDFJVUczOEw5SzlKQ2lIVDZJKzdyaDkyK1N5WFFSRzlENDhXV0FvNW9QV1o2?=
 =?utf-8?B?Z0VsSjcrQ3VGQXZzbFZuaWNIQmE2MEtUajNuZ0RKT2luc2dPVkVYK2V2OCsr?=
 =?utf-8?B?dHNOdHF0OFZjM2JRQXVzZzVodkhSaXZYVXRMeko4MGJ4b3JnaWg5YWRxY2sv?=
 =?utf-8?B?MkloV2VHcDhPck5VellqQzQyMHF3TEVETUF5L2JveXZETVRlOWgvM2xrRWNV?=
 =?utf-8?B?dUxSaG0wVE9ONWkxYXBNbDJpZXhpcmhyNXlBRDRiYlNnU2s5QW5WSlQ5Yml0?=
 =?utf-8?B?UDBoTjh4NDFDV3dldmlUbGV3MXlQVVdHUDRLYS8vMFZGc1krT0FOTnExYWx5?=
 =?utf-8?B?M09zRjhEdXZxTURWT09jakVwSC8rY0c3cndrMS9GT0R4aFRmWGhTYzlxK3Fs?=
 =?utf-8?B?WnRKc05DQ3E2Y285SlJOa1I1bjM0YVFJSitINVBrVlR3UnZVRFVtR1NmeTY5?=
 =?utf-8?B?MzR6WEVNYzRkUVFWdnRubnlra1RjWnV3RlR2ZmRSTTdTbkQvWVBMd2lBVDA3?=
 =?utf-8?Q?xYNMWiHbEhUnQfn0ztJnzxLk/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b3e63e-95ec-4cbf-5ce9-08dac7f0f3f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 16:38:12.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJTB/gHpJ22Xny7P5Ng6fZVaQ71L5Y5vsf8UQDJcs3t/r9DGDr7YrrugujqSJt2q07qpgfECGOFMm0jfqX95SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/22 10:01, Michael Kelley (LINUX) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com> Sent: Friday, November 11, 2022 10:50 AM
>>
>> On 11/11/22 00:21, Michael Kelley wrote:
> 
> [snip]
> 
>>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>>> index 06eb8910..024fbf4 100644
>>> --- a/arch/x86/mm/pat/set_memory.c
>>> +++ b/arch/x86/mm/pat/set_memory.c
>>> @@ -2126,10 +2126,8 @@ static int __set_memory_enc_pgtable(unsigned long
>> addr, int numpages, bool enc)
>>>
>>>    static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>>    {
>>> -	if (hv_is_isolation_supported())
>>> -		return hv_set_mem_host_visibility(addr, numpages, !enc);
>>> -
>>> -	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
>>> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) ||
>>> +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>>
>> This seems kind of strange since CC_ATTR_MEM_ENCRYPT is supposed to mean
>> either HOST or GUEST memory encryption, but then you check for GUEST
>> memory encryption directly. Can your cc_platform_has() support be setup to
>> handle the CC_ATTR_MEM_ENCRYPT attribute in some way?
>>
>> Thanks,
>> Tom
> 
> Current upstream code for Hyper-V guests with vTOM enables only
> CC_ATTR_GUEST_MEM_ENCRYPT.  I had been wary of also enabling
> CC_ATTR_MEM_ENCRYPT because that would enable other code paths that
> Might not be right for the vTOM case.  But looking at it more closely, enabling
> CC_ATTR_MEM_ENCRYPT may work.
> 
> There are two problems with Hyper-V vTOM enabling CC_ATTR_MEM_ENCRYPT,
> but both are fixable:
> 
> 1) The call to mem_encrypt_init() happens a little bit too soon.  Hyper-V is fully
> initialized and hypercalls become possible after start_kernel() calls late_time_init().
> mem_encrypt_init() needs to happen after the call to late_time_init() so that
> marking the swiotlb memory as decrypted can make the hypercalls to sync the
> page state change with the host.   Moving mem_encrypt_init() a few lines later in
> start_kernel() works in my case, but I can't test all the cases that you probably
> have.  This change also has the benefit of removing the call to
> swiotlb_update_mem_attributes() at the end of hyperv_init(), which always
> seemed like a hack.

It seems safe for SME/SEV since mem_encrypt_init() is only updating the 
SWIOTLB attributes at this point. I'll do some quick testing, but you 
might want to verify with TDX folks, too.

> 
> 2)  mem_encrypt_free_decrypted_mem() is mismatched with
> sme_postprocess_startup() in its handling of bss decrypted memory.  The
> decryption is done if sme_me_mask is non-zero, while the re-encryption is
> done if CC_ATTR_MEM_ENCRYPT is true, and those conditions won't be
> equivalent in a Hyper-V vTOM VM if we enable CC_ATTR_MEM_ENCRYPT
> (sme_me_mask is always zero in a Hyper-V vTOM VM).  Changing
> mem_encrypt_free_decrypted_mem() to do re-encryption only if sme_me_mask
> is non-zero solves that problem.  Note that there doesn't seem to be a way for a

Hmmm, yes, this was because of an issue using the cc_platform_has() call 
during identity mapped paging. I think matching them in this case would be 
best, e.g., changing mem_encrypt_free_decrypted_mem() to check for a 
non-zero sme_me_mask - along with a nice comment on why it is checking 
sme_me_mask.

Thanks,
Tom

> Hyper-V vTOM VM to have decrypted bss, since there's no way to sync the
> page state change with the host that early in the boot process, but I don't think
> there's a requirement for such, so all is good.
> 
> With the above two changes, Hyper-V vTOM VMs can enable
> CC_ATTR_MEM_ENCRYPT.  The Hyper-V hack in __set_memory_enc_dec()
> still goes away, and there's no change to the condition for invoking
> __set_memory_enc_pgtable().
> 
> Thoughts?  Have I missed anything?  Overall, I'm persuaded that this is a better
> approach and can submit a v3 patch series with these changes if you agree.
> 
> Michael
