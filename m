Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDBEEEAF
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbfKDWDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:03:48 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7167 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388839AbfKDWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:03:46 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc0a0470001>; Mon, 04 Nov 2019 14:03:51 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 14:03:44 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 Nov 2019 14:03:44 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 22:03:44 +0000
Subject: Re: [PATCH v2 07/18] infiniband: set FOLL_PIN, FOLL_LONGTERM via
 pin_longterm_pages*()
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-8-jhubbard@nvidia.com>
 <20191104203346.GF30938@ziepe.ca>
 <578c1760-7221-4961-9f7d-c07c22e5c259@nvidia.com>
 <20191104205738.GH30938@ziepe.ca>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <1560fa00-0c2b-0f3b-091c-d628f021ce09@nvidia.com>
Date:   Mon, 4 Nov 2019 14:03:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104205738.GH30938@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572905031; bh=IKdbp+ZVTpqbHTn5cPPMdPyF8t8FSY9+XIKb+nTmNZA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Exr6wtS04dnOA7OKyG8C6jmfOJgvmOKQ4ryKtK8dYLUGAUhW1ANa3Y76nirEfKZWL
         BfmKpwQhdZf164GA7TThLAA8XYE7rEB43E5uVykOUw8vjqq+Z5vuPr4RoWB+EBwJmI
         82WUaxumGAw7uDlxCOHsZWA/nWll4Fj5SlWn1ViJ0PmXPDYlJ4UyJMEdDl6CCPpwkA
         3kXnuXZEeEzWyHIHP7bnpZdIk11g5n/Fmufuu3stG/XnD2YhIKLkCmPY0tP07oCg3I
         PY8WkQI5XHEQ8FF1wEe8DPqFUCcb0SNQiASk6Fs41GXmDSlssuX1FKG+oppzdi+q5D
         gW3LGN7zuApVg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 12:57 PM, Jason Gunthorpe wrote:
> On Mon, Nov 04, 2019 at 12:48:13PM -0800, John Hubbard wrote:
>> On 11/4/19 12:33 PM, Jason Gunthorpe wrote:
>> ...
>>>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
>>>> index 24244a2f68cc..c5a78d3e674b 100644
>>>> +++ b/drivers/infiniband/core/umem.c
>>>> @@ -272,11 +272,10 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
>>>>  
>>>>  	while (npages) {
>>>>  		down_read(&mm->mmap_sem);
>>>> -		ret = get_user_pages(cur_base,
>>>> +		ret = pin_longterm_pages(cur_base,
>>>>  				     min_t(unsigned long, npages,
>>>>  					   PAGE_SIZE / sizeof (struct page *)),
>>>> -				     gup_flags | FOLL_LONGTERM,
>>>> -				     page_list, NULL);
>>>> +				     gup_flags, page_list, NULL);
>>>
>>> FWIW, this one should be converted to fast as well, I think we finally
>>> got rid of all the blockers for that?
>>>
>>
>> I'm not aware of any blockers on the gup.c end, anyway. The only broken thing we
>> have there is "gup remote + FOLL_LONGTERM". But we can do "gup fast + LONGTERM". 
> 
> I mean the use of the mmap_sem here is finally in a way where we can
> just delete the mmap_sem and use _fast
>  
> ie, AFAIK there is no need for the mmap_sem to be held during
> ib_umem_add_sg_table()
> 
> This should probably be a standalone patch however
> 

Yes. Oh, actually I guess the patch flow should be: change to 
get_user_pages_fast() and remove the mmap_sem calls, as one patch. And then change 
to pin_longterm_pages_fast() as the next patch. Otherwise, the internal fallback
from _fast to slow gup would attempt to take the mmap_sem (again) in the same
thread, which is not good. :)

Or just defer the change until after this series. Either way is fine, let me
know if you prefer one over the other.

The patch itself is trivial, but runtime testing to gain confidence that
it's solid is much harder. Is there a stress test you would recommend for that?
(I'm not promising I can quickly run it yet--my local IB setup is still nascent 
at best.)


thanks,
-- 
John Hubbard
NVIDIA

