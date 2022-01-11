Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3348A934
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348848AbiAKIRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:17:22 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:10081
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235106AbiAKIRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 03:17:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWlnJ/4Gn0EDXlYuw5mnbnOEeKf0KiHC6XmWAA7y2/OWimPHWJQd+BtL2rdtXJJ37Xh6gbW11Q3adFm8Lxl6aLjlOYBppxnyL0VvXKYGJdUXwStCvHjDwo0DEq8c3qcFro+7X67wFnkoZESwQ4/7VKZP89agSdAXB/GxcY29pAvOEd4ZwilyoKlLqiDyuJJ1xvB9lB9XW5CsQcquGXIrQ5GBSU5M4tKaM2HPy3LCzjIUZvb7jZEF9W0MvK5VM30KQphAGI/4ntU/yMhQis4qs7iVcRnyDSfk2ZSBDbc66uoQiQsfjQ9Ugar47HNuFHO2JfsjaD9O3J+DBm9N1+L+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9fU9A0Nf66xZwOS+XOjwQYV5e2Qb1M31TEJ/WEqZ8M=;
 b=Qv7j4ec8RQZ1cVy0kLXXyn2pryAF/DRZLtKOykLa3DEIRb9Vh6TlD5Xufn22AyMrjtSiiyTqMzvaw2UQG5PlDQRArA1rRzE8eUYik9tJuhg9z6hXJiINZmPYi5HUnfaCl3Y1SIaNtsSSerLwQ8RNDGEAB4iUy4F4aBy7wFhvULcXOu6hbYrxjcLOwFol0Adp1YyTJrGm3pPn99gws3rlU3bWCNqiMmwExcZ/KMDWMZ6YfUwBjzvrHcZIYZM/jnmt+XO3sYBAaDbKC+BaiIEb9Now2wvzErpQ3dLqp9TXj8BWqMEfrA4XT5OhLHE4Ek2itkzYw1v1W3HtCla4VoiGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9fU9A0Nf66xZwOS+XOjwQYV5e2Qb1M31TEJ/WEqZ8M=;
 b=NKqbm0tm8d7L/4apjEVkTa+jrKDQ4B3QcqJzYi7lc1BGfHiIR5g8aXkRko/v0w9GNvi9Z5rmaYDjJNfskFDcXHoEXiZ+8HZPseismLFPZEo/JVTuf78rLsBKqVwfZzR1z11cQ9T4VdznwA6he9utnSnt8XoKiGJRDwYmlXGNFbnVWGI/zSk5bB6vLs6/FAsKJrFCyc7P03HmFre59ML4r5OL6OncyPY9QWdO1Y2KrrYmkxoEBb7x++1QLEfdNLZWmCrYCf9O2esHVXYuLs6xFFPsV3KYMMjtVZFENTe/Qh5ZVig7r9kAmN7zEv2S3wGyhb6ZnvsWf9wIGl+cv5OY8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BY5PR12MB4305.namprd12.prod.outlook.com (2603:10b6:a03:213::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 08:17:19 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::8496:16fd:65c5:4af7]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::8496:16fd:65c5:4af7%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 08:17:19 +0000
Message-ID: <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
Date:   Tue, 11 Jan 2022 00:17:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Phyr Starter
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0363.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::8) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55c7d45c-8bfa-4041-58e5-08d9d4dac969
X-MS-TrafficTypeDiagnostic: BY5PR12MB4305:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43053DE6E2B38BA4D290956DA8519@BY5PR12MB4305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60CH+Hyoaml9QFV4YmihFyCKZxxTa4mYnOtQcVBDSO5XQ95vjQrWPkhBHb/iLQMd+CtPxScY3B+jO15MDety8r8VkECyROLve66OkhLfNYQkV6Jl82YVM6XOCCPDjbqzgtye7/UIftMhmDZ/eh/6Mz2+hZMWAj6TcgoZ7/s8MG9lL5dhiuHJph488Kqh87Q5dB39MybOuf82nUWgkZAcH3OSG6XpCquLDdsRZyHlRT3r92o/enkZ9m5D3M2APUoQ9RjN3YO+jUexPDmmPPQZa5NEn7fLmkcDI/tMLpSwJq2hEIQX8VNwvr9VPMZgogldMyexdVIBRs/P9x5qAvTFmuEMtbCXamXHF3yCnzyGOmctUnwro4LXxvyg0BrYVGTDFkTMXJz/AG8EXJOvFsddFU7bYemD5AlvbifbDBj+uaFSBJqOEt9Xrbz7WsQce34Byj5Q5V8C9rRhMKPnFzyorNH50Dk0VolSh1ptS+R8nO+P1deG9RrmrMkmn6n5BA5RkC4ZYnikmLac+T6EeUANOUL1iY+F3S2Kba1XnPXUhJlc2fIDSKsz5QmOMvrDk3TazVfO04aivvRowmqY4jeJqOxWWjyJi8hcHyEaJwCVeh0U1LOwzBe69Wl2V5Q6kQ39IMoj8cY8ncoClVYjaiN94W2mvXM5YyXo4XiH38EOvYizT+hyk3q5bB+MzxDD3CbEjwoNJ+4EmpbkC68p4kF5gTIzvpg0InLAibJwkoluKW3J2FYeCPS6AnRvyepGGXOq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(66946007)(5660300002)(8936002)(26005)(316002)(508600001)(86362001)(8676002)(36756003)(7416002)(38100700002)(31686004)(7116003)(186003)(6512007)(54906003)(4326008)(6486002)(3480700007)(31696002)(2906002)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1pCdjd0QnIyNUlLekNtbkJGU0F4MXp0VFB0dFhLMk5tTjA0K050Mm1Fb214?=
 =?utf-8?B?MEVvZFZ2Mk0vQUt0QW9jUFlQV2I3ZW5VSlFmeldxUW9ObklGd2c0NUJiblNQ?=
 =?utf-8?B?ZHJ0VU4xLzJFNlVSS0llTlNtSWdycW03VEVwVDF1MmVkcUNBUzkrOTg1NldF?=
 =?utf-8?B?S3NNanRFNGRlOWVYcHZJaXF4TlFoY0ZWK1pwa0JxakZlam5xckVKVXhQK1R1?=
 =?utf-8?B?NlR5MllLaHdjSTQ5YmFvVm80MkpxQ1J2VlJRNEJKNEVwbWFWc1hNNDQxVlFp?=
 =?utf-8?B?MUpnVVROTU12bXIwU3ZmclZHbnNOWlJHTTNOWStOdE5MWnpNYTRUb2Zmd0ho?=
 =?utf-8?B?WEhhMWZRTmJleU9OMXMxTVFSUUtVREg4cDBWbzhqWk9TaVVDTmREWFMvZDFz?=
 =?utf-8?B?SDRyRWFlVGRFMXBscDBMVW11N0RyTk51VnRXajVRUUQrZGw4RC9GUGUyTDVD?=
 =?utf-8?B?V1pyckVrQncxR1BlbFN0WGEyN3FUM01YZERJaitYamZ0cmNKTlNWWTJLcHFu?=
 =?utf-8?B?eWUvZmN4NU53d0Y4Q25ZQXZwb0loVEVRb1ZZNGdOKy9QWHVReW92RUhYUTdZ?=
 =?utf-8?B?bFc2OHV4Q0M5a29SM0JzQkNzL3k3b0N4QlNkR1VLa0ZsY0dzR01BcjN3STJq?=
 =?utf-8?B?djRsNU82RUg4cGJuVEw0VDgrUkc5cktLYXNvTmNzOXpRelpZSE5hYVZTUlNV?=
 =?utf-8?B?SzhHZC9rK0dldVlab2NXdnFNNUM4Yi9uVlNLQVNLU0ozRWo0Ri91T09od1VF?=
 =?utf-8?B?bWszemVmZjlIdlVSU0NDblRYYVdoK0hCekcydXRKS2E3WnFZd2drTkh5S2sr?=
 =?utf-8?B?YVB0ajA1VnB5aE82YXM5QmV1V3owODExTWVoWUFILzVxUzErdnQzRjJSNUtY?=
 =?utf-8?B?OGJjQTcxTkluai9NSCtOWVU4Y1JFT2hwZitOY0M3YnhoTTNVRndVSmpJVUE3?=
 =?utf-8?B?RVkyNWRGK0VONG9vOUJ5eFNPR1ZlREUzUUFvYTBxQzdXQlNEVTMzQ2ZNaFp2?=
 =?utf-8?B?LzVzVTlESnZlVk50N0o0Qm9PQWZ2UldpUm5BcEVLeHNRRkcycFA5dHZJRUZX?=
 =?utf-8?B?UGNScU91SFVLVkliQmE4UysxeXV2cHovMGFPcnoyelFncTk0bGt2U2Z5WmhS?=
 =?utf-8?B?YnN3dWdUQm1sdzhraEJZT0UxdTViRFBRMXBhR2ZyZEJyMUI2UWNnWVRHRDIr?=
 =?utf-8?B?TW02MUVvT2g4Q0U5cEJWcmxlYThvTzdLSjVBdjhSZmJJZlpvNG90QWdNMkpq?=
 =?utf-8?B?RE01NnhLais5ZVp6RXNYYXlGTVQyZEZqVVBoUEpicTg2WnlLbW9ySFN6a1Z4?=
 =?utf-8?B?UWJoQ3VVYjUxSmlnZmpjV0JUL3AvbVBLRmppU0VrZmZQQ2k1K3hHV2tOR3Bt?=
 =?utf-8?B?NUlXYi8wWGVxZlEyMS9abHZJdzY1T3RyeWcvdituQnRhVGxkazV3Q1dsVFFr?=
 =?utf-8?B?MVRNU0UyaFpqbmFuZWRJWXh1NnBlRWJsL05lZjh6M1VmV3d3TXN5eVhXNFRH?=
 =?utf-8?B?ZWdMa0k0UDBZQ1JXSGVlSDlwQ3BWR05kbHM1YjVPVWRUT1VNR2R2WDRzQnkr?=
 =?utf-8?B?TDBJWjQ1UHlxRHdMdmN5TUZtZUtkeEVGZlZhZFpWTVJreis2S2ZLYWxQM1ZW?=
 =?utf-8?B?c0sxNGdDWHpVdVdEazRZN3ZMbDE1Zm1TSTBqNXk4ME5veWkyNnBkYjJyNWpt?=
 =?utf-8?B?VnA0dm5NR0ZsQnJ4SVZDUFJ1UHNTV3R5MG9sMXBpRWorVUlLU2ZHUEJyaWY0?=
 =?utf-8?B?eEI5ekZSS0Q5YjZVcUFGblRLekVUQmd3Um1tVnVkR1RrSkVyZDlobzkzT2pC?=
 =?utf-8?B?QVJieFBCc0t0TDVkeFNXNDJ6YkF3VWlGSVBwUUtTdTlOS0R0YllVTVA5YmFZ?=
 =?utf-8?B?TWNGckF4aG56Vk5BdmxXelRlTGpGdmx1d3VXdzJtYTBONVR1MFlma0IwandK?=
 =?utf-8?B?Z21EaXpmYTRmaW52dkFIVnU5Y212OHBZdVNkREJpWTNTTERLK2N3WkhtUVor?=
 =?utf-8?B?bHpWaGI2WVpFRFdPWGdlRE9HUm1ZU3JDZVp1dzdiazlqWWRPVkF3Smg4dVlV?=
 =?utf-8?B?NTlLUktxNmhTQXhPZFBRMGFOcitxZmo1bGpWalBCSEJvMEtTSjV5RHpSVDFY?=
 =?utf-8?B?VENJZzBVejVodU5Fblk4ZGdHcmpodWVhNmVhOXpCMEdKUU9id0V4a20xT0lR?=
 =?utf-8?Q?ruvCMzeGk6Qn28hHuV327Rc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c7d45c-8bfa-4041-58e5-08d9d4dac969
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 08:17:19.7969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDZFBaelhXR0sHmbFzkatZoIRfhVh+QzK35+mDTszAvZM+GIOV5SUIN3IVN3Q+yzEIfEAk1mktniUBKcBEN6OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4305
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/22 11:34, Matthew Wilcox wrote:
> TLDR: I want to introduce a new data type:
> 
> struct phyr {
>          phys_addr_t addr;
>          size_t len;
> };
> 
> and use it to replace bio_vec as well as using it to replace the array
> of struct pages used by get_user_pages() and friends.
> 
> ---

This would certainly solve quite a few problems at once. Very compelling.

Zooming in on the pinning aspect for a moment: last time I attempted to
convert O_DIRECT callers from gup to pup, I recall wanting very much to
record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
or some non-FOLL_PIN method. Because at the end of the IO, it is not
easy to disentangle which pages require put_page() and which require
unpin_user_page*().

And changing the bio_vec for *that* purpose was not really acceptable.

But now that you're looking to change it in a big way (and with some
spare bits avaiable...oohh!), maybe I can go that direction after all.

Or, are you looking at a design in which any phyr is implicitly FOLL_PIN'd
if it exists at all?

Or any other thoughts in this area are very welcome.

> 
> There are two distinct problems I want to address: doing I/O to memory
> which does not have a struct page and efficiently doing I/O to large
> blobs of physically contiguous memory, regardless of whether it has a
> struct page.  There are some other improvements which I regard as minor.
> 
> There are many types of memory that one might want to do I/O to that do
> not have a struct page, some examples:
>   - Memory on a graphics card (or other PCI card, but gfx seems to be
>     the primary provider of DRAM on the PCI bus today)
>   - DAX, or other pmem (there are some fake pages today, but this is
>     mostly a workaround for the IO problem today)
>   - Guest memory being accessed from the hypervisor (KVM needs to
>     create structpages to make this happen.  Xen doesn't ...)
> All of these kinds of memories can be addressed by the CPU and so also
> by a bus master.  That is, there is a physical address that the CPU
> can use which will address this memory, and there is a way to convert
> that to a DMA address which can be programmed into another device.
> There's no intent here to support memory which can be accessed by a
> complex scheme like writing an address to a control register and then
> accessing the memory through a FIFO; this is for memory which can be
> accessed by DMA and CPU loads and stores.
> 
> For get_user_pages() and friends, we currently fill an array of struct
> pages, each one representing PAGE_SIZE bytes.  For an application that
> is using 1GB hugepages, writing 2^18 entries is a significant overhead.
> It also makes drivers hard to write as they have to recoalesce the
> struct pages, even though the VM can tell it whether those 2^18 pages
> are contiguous.
> 
> On the minor side, struct phyr can represent any mappable chunk of memory.
> A bio_vec is limited to 2^32 bytes, while on 64-bit machines a phyr
> can represent larger than 4GB.  A phyr is the same size as a bio_vec
> on 64 bit (16 bytes), and the same size for 32-bit with PAE (12 bytes).
> It is smaller for 32-bit machines without PAE (8 bytes instead of 12).
> 
> Finally, it may be possible to stop using scatterlist to describe the
> input to the DMA-mapping operation.  We may be able to get struct
> scatterlist down to just dma_address and dma_length, with chaining
> handled through an enclosing struct.
> 
> I would like to see phyr replace bio_vec everywhere it's currently used.
> I don't have time to do that work now because I'm busy with folios.
> If someone else wants to take that on, I shall cheer from the sidelines.

I'm starting to wonder if I should jump in here, in order to get this
as a way to make the O_DIRECT conversion much cleaner. But let's see.

> What I do intend to do is:
> 
>   - Add an interface to gup.c to pin/unpin N phyrs
>   - Add a sg_map_phyrs()
>     This will take an array of phyrs and allocate an sg for them
>   - Whatever else I need to do to make one RDMA driver happy with
>     this scheme
> 
> At that point, I intend to stop and let others more familiar with this
> area of the kernel continue the conversion of drivers.
> 
> P.S. If you've had the Prodigy song running through your head the whole
> time you've been reading this email ... I'm sorry / You're welcome.
> If people insist, we can rename this to phys_range or something boring,
> but I quite like the spelling of phyr with the pronunciation of "fire".

A more conservative or traditional name might look like:

     phys_vec (maintains some resemblance to what it's replacing)
     phys_range
     phys_addr_range

phyr is rather cool, but it also is awfully too close to "phys" for
reading comfort. And there is a lot to be said for self-descriptive names,
which phyr is not.

And of course, you're signing for another huge naming debate with Linus
if you go with the "cool" name here. :)


thanks,
-- 
John Hubbard
NVIDIA
