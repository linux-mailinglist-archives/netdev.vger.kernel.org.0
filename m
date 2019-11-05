Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9557AEF37E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 03:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfKECcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 21:32:39 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47052 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729917AbfKECci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 21:32:38 -0500
Received: by mail-qt1-f194.google.com with SMTP id u22so27190540qtq.13
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 18:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4urm9i82HUz7ctZoqeaJ+eDwbY+Le9I8/NmP0pY1rnA=;
        b=RrEUUprScGGCs1P3lOuGj4a5RoiWbVbfDZ4+HpgRvyTXCYVlJAXQB+MYamRZtedVHY
         f5+sxNxk2K5wkp7PjMMeD8HJWFAJHo3RtLYXlCrUl00LuH1GNIO+43+qB9VoRPGoMtd2
         MhxxJSrVmcyNdw2dcAOft+ieDHmjkqcbx3xo51HlgztpG3sVxpkHZVlG9m+fgORfqdhb
         XySrfwIPRDIjnSUQNZ9F7DSfvHrKSEQZxN/D+pZKoiFoN1H+0mMnDQ/zYc1NegbKO5Qw
         fR/889wgnwS9AagFL4h4X1w9N0H+8w+Cg8HTo2zBy3ABWuxHxMoo0KJgJWvcNzShW5B1
         QLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4urm9i82HUz7ctZoqeaJ+eDwbY+Le9I8/NmP0pY1rnA=;
        b=mX5K2QRw3WUwE3JH+9n0SWWVCw9ojqJl7pFTASY5fDAN5b0gZUB8ql8ZaFwdwst2L0
         QYswseBGMNYwYM8r7VlQ6NJKblcxucfrte9hGRfUQLLP9JQkuS02o1iYBg9FBzW+D+BY
         NT2S1kcgls/1nQHc+I67o8JHmWrSpR3LuqskjSibRAdqyeVWTjCuwOaPtoDCOZmhVLG5
         jSs+bKipVm9ukYHcPs2yanN03iQeHzLYqhldBe/NprGmoSSFh/dLNpFF2qoC3pcl3WiA
         aQaJZPL+wk0J4LRW8lfXnmWeukrrFvT/STLhLW2S1gEuwRNZ7ci37i5riu2LCiqAkUS5
         JdbQ==
X-Gm-Message-State: APjAAAWZkX5VguOXpKs6veajDT1pv9NrbxzW1srWoILuZDDzauGz3xFG
        rHk9xhC2BK1dAgAE5RrGzlkL5A==
X-Google-Smtp-Source: APXvYqzymmufBg1PiSWGxkk4f7LXgsvyOrzTuuRBB+uFmwh9UO+iQP682ubsI0h94l7eDVroneUqZg==
X-Received: by 2002:a0c:9838:: with SMTP id c53mr25556531qvd.250.1572921156814;
        Mon, 04 Nov 2019 18:32:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id t65sm8907102qkh.23.2019.11.04.18.32.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Nov 2019 18:32:36 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iRoe3-0002uH-K9; Mon, 04 Nov 2019 22:32:35 -0400
Date:   Mon, 4 Nov 2019 22:32:35 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/18] infiniband: set FOLL_PIN, FOLL_LONGTERM via
 pin_longterm_pages*()
Message-ID: <20191105023235.GA11093@ziepe.ca>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-8-jhubbard@nvidia.com>
 <20191104203346.GF30938@ziepe.ca>
 <578c1760-7221-4961-9f7d-c07c22e5c259@nvidia.com>
 <20191104205738.GH30938@ziepe.ca>
 <1560fa00-0c2b-0f3b-091c-d628f021ce09@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560fa00-0c2b-0f3b-091c-d628f021ce09@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 02:03:43PM -0800, John Hubbard wrote:
> On 11/4/19 12:57 PM, Jason Gunthorpe wrote:
> > On Mon, Nov 04, 2019 at 12:48:13PM -0800, John Hubbard wrote:
> >> On 11/4/19 12:33 PM, Jason Gunthorpe wrote:
> >> ...
> >>>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> >>>> index 24244a2f68cc..c5a78d3e674b 100644
> >>>> +++ b/drivers/infiniband/core/umem.c
> >>>> @@ -272,11 +272,10 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
> >>>>  
> >>>>  	while (npages) {
> >>>>  		down_read(&mm->mmap_sem);
> >>>> -		ret = get_user_pages(cur_base,
> >>>> +		ret = pin_longterm_pages(cur_base,
> >>>>  				     min_t(unsigned long, npages,
> >>>>  					   PAGE_SIZE / sizeof (struct page *)),
> >>>> -				     gup_flags | FOLL_LONGTERM,
> >>>> -				     page_list, NULL);
> >>>> +				     gup_flags, page_list, NULL);
> >>>
> >>> FWIW, this one should be converted to fast as well, I think we finally
> >>> got rid of all the blockers for that?
> >>>
> >>
> >> I'm not aware of any blockers on the gup.c end, anyway. The only broken thing we
> >> have there is "gup remote + FOLL_LONGTERM". But we can do "gup fast + LONGTERM". 
> > 
> > I mean the use of the mmap_sem here is finally in a way where we can
> > just delete the mmap_sem and use _fast
> >  
> > ie, AFAIK there is no need for the mmap_sem to be held during
> > ib_umem_add_sg_table()
> > 
> > This should probably be a standalone patch however
> > 
> 
> Yes. Oh, actually I guess the patch flow should be: change to 
> get_user_pages_fast() and remove the mmap_sem calls, as one patch. And then change 
> to pin_longterm_pages_fast() as the next patch. Otherwise, the internal fallback
> from _fast to slow gup would attempt to take the mmap_sem (again) in the same
> thread, which is not good. :)
> 
> Or just defer the change until after this series. Either way is fine, let me
> know if you prefer one over the other.
> 
> The patch itself is trivial, but runtime testing to gain confidence that
> it's solid is much harder. Is there a stress test you would recommend for that?
> (I'm not promising I can quickly run it yet--my local IB setup is still nascent 
> at best.)

If you make a patch we can probably get it tested, it is something
we should do I keep forgetting about.

Jason
