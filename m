Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD163F2D29
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhHTNbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:31:33 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:11361
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhHTNbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:31:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYbNohynw1dwZkENpWuS9EeVpZoOsCEeYwWfir8ADcGcV5qvruzikLkpnGYox0aflbY8M32/sgsF1ge170JhmsjQig1MRZBnwUeQtXhXiN/Ooj8ph06FQhj07dMMNbcPSRxoXhCc2vZam2T/m5ESVDWbciDCY7mQ+nMwlV62gYgG90HQHSwAZtZs39E7Fm27fM+oGXZE0ltbYz2jA2EFhqYR+cDxVT0i0uQQ87d7JYlfJX+ldZaDoUxBMZxqijkGbeW9xL/azb1/xk9CIqHc6nRtLvrOfoJoqPGmMhSfPtvsiELZrIDiBoCK2cgpQU2lZS8PLMUNOM9XnVPWlOP57Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2xoiIec73wfWq4W/xdhp0kJ0euoZbXzd3Kj0SBhyoA=;
 b=FOt1ncds7gc5flmmxmouzNnWagRE4w7c/aA6XgymUjxYuNEyLv+TiT9ZsYrBZlm8IuLEs6dK3HfyhYsojNOYlRSbKTOmXlILn/BXe29thT9M6WgGbnIS4L7f7fHt02CvZdkWXEPe0j/gUVSMchOFXgrAWEM+yd9Zoo70GdNwusEhJxug9jn7OdardKCJPdtQaHBeHgm0N4L5cX652GG4SBLh5KuJsok9zBPI03p2WfjuB2+laYl5ahfeJUWIGnqHXvQrR0bgV3RWXW/TBha1lsMAdhNcyJvIsAblp/yb4pfVreYb766NUCqzB+AeKIS1pORyPheJiyoIo0hl5+1h6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2xoiIec73wfWq4W/xdhp0kJ0euoZbXzd3Kj0SBhyoA=;
 b=OsJlYQd1i67xL9Vk4OXig18TWdkVh1rBAGSxxV8KMtvG2i8P3wHGYouyjv+0qsudX2GKN4++xoyqU7o8IHjom+bKZVHsQmGuoqNCGG3NJmk01kL5rPpwZONDWoVVODqwRwR5ASTIwieIl4Wx5UWb6ukXn7Bq6Pc23QXU4oDT4gY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by BL0PR12MB5505.namprd12.prod.outlook.com (2603:10b6:208:1ce::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Fri, 20 Aug
 2021 13:30:47 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::8ce1:ecac:a5bd:e463]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::8ce1:ecac:a5bd:e463%6]) with mapi id 15.20.4436.021; Fri, 20 Aug 2021
 13:30:46 +0000
Subject: Re: [PATCH V3 12/13] HV/Netvsc: Add Isolation VM support for netvsc
 driver
To:     "hch@lst.de" <hch@lst.de>, Michael Kelley <mikelley@microsoft.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-13-ltykernel@gmail.com>
 <MWHPR21MB15936FE72E65A62FBA3EF4F2D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210820042151.GB26450@lst.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <276f30b6-d741-f88b-ae93-f3d6653498cb@amd.com>
Date:   Fri, 20 Aug 2021 08:30:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210820042151.GB26450@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:806:121::21) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR04CA0076.namprd04.prod.outlook.com (2603:10b6:806:121::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 13:30:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f130b86-2f2b-4289-9e36-08d963deb7af
X-MS-TrafficTypeDiagnostic: BL0PR12MB5505:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5505050EC4C321D2C86CD03AECC19@BL0PR12MB5505.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2gfyETn3qPjvqavDCPew+TbbzgP+8XxltXMx17ZYNVD/4NlalSsAa+KKIR5Urkr1sSmB3/cwDqgdMmq/6tIOrYHz3HUDWAJ1jRNk83r8L7ctDyM5orPKlCNMPJE0k2NYF57OQkPDPQX67Z2cWpCBiFGajyWwuk5ERFLtMHAR0frKoScRPP0Ib166timsFJDDm4TIfcApAH4jBVneW2eco07NnbT8RMMS0P5zH3T4YjMtY8afcND9BJkYrLRpbOIRfq3u6mHGT8MNI/7VCMsVlSS2PRY7MQrovF9YajDJuyULwIDlDB6sn7ypAEH8lRok36nSZ1YgRkJlJREdc+hqKaQgYgWIL69OOwyNSC9OE+KAXOc2uv5TFK2ofy7YP2H2ueuPDrYSH3lVXvYfF7hGCyQzIqcUvaICv1OeePXtWS6Ca9UZG5uIhmWA7AgMHZ8Y2jJFZ+HeJSNsm5QPQrwoDiwV2kK3CIpWu4wThn57uOulGOqMfWXVkX3Jt6bVadIyHnoj/6FYbTI74Dh8kr86w6JEnzwTX/Tc34GTPethoDCh9kuVYLTNKdmaddsQ/IbVgcRi5pbEb/V/+p3BFtlAdCQc7QKzjkKmnzMVoGce4+AruedyzRFY2qttWyH3AYFcci3qlakIY1mygl4fcfzNG6YjBTAOEe9B359sdcQlR9uxhErmU2HrYhY6c5JX2XdLDgdhRnPBva7vzYeIJ+lVWnAduHgWqkhLxtMGrPYVoi28hUqIBdlWm37bQ6+fm5KONCejKiNDWleqCg0FK6JHcOkeFHG9eym4dN6mMHmbF8HDC58Be8feZt+3ShZbk0w1GZ2SNV6ZC8d6fpMsCU6LhgB7ge0ZPvT1StHBWHpv3Ms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(478600001)(6486002)(26005)(31696002)(6512007)(186003)(2906002)(38100700002)(5660300002)(53546011)(6506007)(36756003)(4326008)(66946007)(966005)(86362001)(66476007)(8676002)(2616005)(7416002)(956004)(54906003)(8936002)(316002)(110136005)(83380400001)(31686004)(66556008)(7366002)(7406005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJtTlQzdEo1eThEUWNGZ3VZaTBsbnRkRGorRHNWVHhvN2VKdnV4cWpyaDM4?=
 =?utf-8?B?MVBIL2VnR3lRVWJiZ2ZGc081dFkrZ29pdTlvOXZZY1JoN1dSU1dqbm5VNlpB?=
 =?utf-8?B?L3dmMzVDb2MzeWVNSU02bmRydlFNRkc5WGFMMjhGanh3TzhFVzNUWnAzWXpO?=
 =?utf-8?B?YVpuTkJFQTV0aG1wL2Nmek93TVdGWGZ6R1BOcjlSdGFWNzVpOGpKYXFjak5j?=
 =?utf-8?B?WjF2ZHVuUFUzcHNXYzJvRVVkci96MWxVWmFmVnFkN2FwTzNGbjZWNmh4emFF?=
 =?utf-8?B?V0Z5NUFxRWdYREk4WDdydjJ1dnJ1ZlloSXFPTmdmYXlBZyt2aXRyVGhaM01w?=
 =?utf-8?B?VDBRUmRMSi9XTU9kMS84MFNIdG44YWVIdGdmeUpERjVpRGV5MU1ETGRVZWQy?=
 =?utf-8?B?RWRBbER3bExYU0p2SzVTSEZWZ1N0MXE0MGMvZit3NUpWbk1GdlFLT1VCY3dQ?=
 =?utf-8?B?MjFhQjlQYmM3bCtmcUYzMkJkbm5RQlhvcys2UHlUSExvZUNtWXJpc1ZGK09w?=
 =?utf-8?B?cVFDbDlTcjFUWmF6RERGZk9qQzBMcllDaytaZWk2RXZoaDROTTJjNERCS2s5?=
 =?utf-8?B?SWVtMW1xRTV5QnNoTUxTOHY5b3hxTEZjVlBtT0dCRUZGM0NsQ0ZkaUx4N010?=
 =?utf-8?B?U3JwWG01Zmo4Z0RNei9Eb0ljSjJiU3doNWoyYUljcVBBZGZqZlJwZkY2bG5h?=
 =?utf-8?B?RDhkRSttWE1zZjFUQjRDWnpDVS8wd0ozaUZKMEh6SVF1N0FqaVc4TVA3TStF?=
 =?utf-8?B?VkhXN01MSHc2eHFrZUZJMU1LOE4rUmMwT05IZnFQTG5JVlM2Mzc0TWs0Ymd6?=
 =?utf-8?B?azZTNytNS08yNkszRU9mWUVnSERGVlI3Y0dQbUVITFJRRmVUREpmQUR2L1A0?=
 =?utf-8?B?c3lYaWRVV3F0d3FRSTJ6QmdGTTBHYWlrd0hLckpHUkxCZDA4VmlQTjFEUExI?=
 =?utf-8?B?SUFxQjdSQ3pmMldEdE1OTDFEK0UyWUxBQWVBMWxKVk8yRkJubzRRSDVmalNa?=
 =?utf-8?B?dmpmem1kaVhyejE1RGpWYkNJV0dYbXpuQ1RTWXFvaHFOcTlOZ2pmbFZDNnFO?=
 =?utf-8?B?b2toU1BXU2VSRURSOXVYdDJmOGdQQis5UG9CUDVXd3VEa1paRWdtbzV1QkFx?=
 =?utf-8?B?Mjl3QXBqZm9PeUp1aWtmcTRPcjFwdjFmdTFzK3lHRjFjbmV5UHRUZkt0OGRC?=
 =?utf-8?B?eUszOHdYdUI1WlVJaU84OGJoVmJ3bzZReHZZK3ZPbXJrakl3Z1hhUG9FYVQv?=
 =?utf-8?B?RjI2WjhqZlBsZEpkbEFHT245aS9sVE5ZWEVsVUFFYlNLcDdtMWc3YXdLeEE3?=
 =?utf-8?B?aHBGZ1QxVGkxRDlxd0JLYVlXSGRFVFFzUDNTNUhxRUxWbkR6LytjYUJzMms1?=
 =?utf-8?B?NE5TeC9YcVRZRng5dmUwdzdTNUdzRVo2TkZOT1F1cUdJbE9USFVTTDV6alpl?=
 =?utf-8?B?K2lKZlhxamRiUEpKMk14aXh1RmZyK3VPb09lalJaK1RTdlhjVXBuTW0wdmhy?=
 =?utf-8?B?Uy9pamFZTDlMMGlpSitMdUpiU0lSa1ZLOVREd2hwOGt0eWZ5Q3REZGVEbnFF?=
 =?utf-8?B?WlFWTzc1L0FBWTA0MDg2NnFoeXRtbFNKeDZ5b1lmN3orNk5nQkpTZ2EyOWVV?=
 =?utf-8?B?ckJLUTdlOExXeHpSamRqa0t4aHRnUTIwblRNTDdGTUgzNXJIZEQvZVkrTnlQ?=
 =?utf-8?B?cjFrMFNxWWJPNEZLMFZ4cmRzeC9YVXN6SXAvWFlSeHl4Q2Z6cnBXbWY3RXZU?=
 =?utf-8?Q?hfuG64VcprR6WNR3AoY7QKRoELfMUz5I9Lk+qaJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f130b86-2f2b-4289-9e36-08d963deb7af
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 13:30:46.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8hF636Kko5E5awL4utZAAnAsHYUJ8Xk+OiOcjEEkkOPM6jQoYTv0V+JT3OSFZsDActObVEyU8+GN5p2WRrXMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5505
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 11:21 PM, hch@lst.de wrote:
> On Thu, Aug 19, 2021 at 06:14:51PM +0000, Michael Kelley wrote:
>>> +	if (!pfns)
>>> +		return NULL;
>>> +
>>> +	for (i = 0; i < size / HV_HYP_PAGE_SIZE; i++)
>>> +		pfns[i] = virt_to_hvpfn(buf + i * HV_HYP_PAGE_SIZE)
>>> +			+ (ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
>>> +
>>> +	vaddr = vmap_pfn(pfns, size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
>>> +	kfree(pfns);
>>> +
>>> +	return vaddr;
>>> +}
>>
>> This function appears to be a duplicate of hv_map_memory() in Patch 11 of this
>> series.  Is it possible to structure things so there is only one implementation?  In
> 
> So right now it it identical, but there is an important difference:
> the swiotlb memory is physically contiguous to start with, so we can
> do the simple remap using vmap_range as suggested in the last mail.
> The cases here are pretty weird in that netvsc_remap_buf is called right
> after vzalloc.  That is we create _two_ mappings in vmalloc space right
> after another, where the original one is just used for establishing the
> "GPADL handle" and freeing the memory.  In other words, the obvious thing
> to do here would be to use a vmalloc variant that allows to take the
> shared_gpa_boundary into account when setting up the PTEs.
> 
> And here is somthing I need help from the x86 experts:  does the CPU
> actually care about this shared_gpa_boundary?  Or does it just matter
> for the generated DMA address?  Does somehow have a good pointer to
> how this mechanism works?

The CPU does care. Here's some info:

APM Volume 2, Section 15.36.8:
https://www.amd.com/system/files/TechDocs/24593.pdf

AMD SEV-SNP Whitepaper, Virtual Machine Privilege Levels (~page 14):
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf

Thanks,
Tom

> 
