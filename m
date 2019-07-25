Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391EF75869
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfGYTwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:52:39 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:43723 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYTwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:52:38 -0400
Received: by mail-ua1-f68.google.com with SMTP id o2so20360945uae.10
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NtToBUUoEbCqChwzeYr06AS46mrqcW9whj4wIInF5Bk=;
        b=mDUTcBdI6hHxavvFRN9EkVjrZ5c0UenKDQz7bDJqViyLkUxGxy8xw91wkD4Y/61wHg
         Igcxyo1vrkHruAr7AuMvzl766ijOO+mSJRwMtKw3BoMeCLE+9zxf2kxbW9zNPxkIlj/p
         wht62Wnfyu1qxG96rp3E3A3nb5cjmGYL64BF0gcR8+bukdu/RrVCH00n6vMRhvRZztsc
         fVYLDb8rmyldl+aDOsKzAhN9BjY/tawjr6hjiz30u/uDl43dmiUJe49Gq0XteyvNCPqu
         JtG99Sz0nLR28Zm1wv4K5HSwNLzZRXqCY4i9vfpGMu2F9td3ZrfIwfXVpZhfwxPZMZmW
         Viyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NtToBUUoEbCqChwzeYr06AS46mrqcW9whj4wIInF5Bk=;
        b=uC4M6D8VnFaDBFCBHGWk/pyNgMIFqsEhCJqrCgzDDpdByRLayr/QrjTvyulWlROGIA
         0B0b0axidc5q1OymW9dc1KMf2uf0MQCSMy0PAf8HxpVL/P3nt+U2FMuRad5xgFgVdyir
         9lbpaZPAJH9KxpE4abvzK+kWLrKUcNwIaPf1qoOzpISbLEgqsMuBgHaSuseyb9eH9Jkp
         Vo64DHapGjfVx7bdglSniehdOzG6hpAuGBqRaMFvpGhmyWllxozzPCruU3Em9qA5wjj4
         WKSlWm0pAa5x41zfR9ppmtrOprldYEFNWiKlEwNuKqDadmTdjeQf8NbXRcHEKidv+I4Q
         1NSg==
X-Gm-Message-State: APjAAAWybOoiAaOiDqHCzoGXB8nHL7Ck+y0vn5BHuq0w/9oRInRh19YE
        hDvCt+2ZT5E9ZUihUxMQe+88pw==
X-Google-Smtp-Source: APXvYqw2XPAm7nn0NCCmWDgtDzI4KR4fd20Fs236rdGP5cZtSAV35+ewIFh2H4ijoKuuhpP9tfrd7Q==
X-Received: by 2002:ab0:36:: with SMTP id 51mr59768902uai.105.1564084357823;
        Thu, 25 Jul 2019 12:52:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id z124sm13746806vkd.20.2019.07.25.12.52.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 12:52:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hqjn2-0001aS-Hf; Thu, 25 Jul 2019 16:52:36 -0300
Date:   Thu, 25 Jul 2019 16:52:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190725195236.GF7467@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 07:34:15PM +0000, Michal Kalderon wrote:
> > > +	ibdev_dbg(ucontext->device,
> > > +		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx]
> > removed\n",
> > > +		  entry->obj, key, entry->address, entry->length);
> > > +
> > > +	return entry;
> > > +}
> > > +EXPORT_SYMBOL(rdma_user_mmap_entry_get);
> > 
> > It is a mistake we keep making, and maybe the war is hopelessly lost now,
> > but functions called from a driver should not be part of the ib_uverbs module
> > - ideally uverbs is an optional module. They should be in ib_core.
> > 
> > Maybe put this in ib_core_uverbs.c ?

> But if there isn't ib_uverbs user apps can't be run right ? and then
> these functions Won't get called anyway ?

Right, but, we don't want loading the driver to force creating
/dev/infiniband/uverbs - so the driver support component of uverbs
should live in ib_core, and the /dev/ component should be in ib_uverbs

> > > +	xa_lock(&ucontext->mmap_xa);
> > > +	if (check_add_overflow(ucontext->mmap_xa_page,
> > > +			       (u32)(length >> PAGE_SHIFT),
> > 
> > Should this be divide round up ?

> For cases that length is not rounded to PAGE_SHIFT? 

It should never happen, but yes
 
> > 
> > > +			       &next_mmap_page))
> > > +		goto err_unlock;
> > 
> > I still don't like that this algorithm latches into a permanent failure when the
> > xa_page wraps.
> > 
> > It seems worth spending a bit more time here to tidy this.. Keep using the
> > mmap_xa_page scheme, but instead do something like
> > 
> > alloc_cyclic_range():
> > 
> > while () {
> >    // Find first empty element in a cyclic way
> >    xa_page_first = mmap_xa_page;
> >    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
> > 
> >    // Is there a enough room to have the range?
> >    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
> >       mmap_xa_page = 0;
> >       continue;
> >    }
> > 
> >    // See if the element before intersects
> >    elm = xa_find(xa, &zero, xa_page_end, 0);
> >    if (elm && intersects(xa_page_first, xa_page_last, elm->first, elm->last)) {
> >       mmap_xa_page = elm->last + 1;
> >       continue
> >    }
> > 
> >    // xa_page_first -> xa_page_end should now be free
> >    xa_insert(xa, xa_page_start, entry);
> >    mmap_xa_page = xa_page_end + 1;
> >    return xa_page_start;
> > }
> > 
> > Approximately, please check it.

> But we don't free entires from the xa_array ( only when ucontext is destroyed) so how will 
> There be an empty element after we wrap ?  

Oh!

That should be fixed up too, in the general case if a user is
creating/destroying driver objects in loop we don't want memory usage
to be unbounded.

The rdma_user_mmap stuff has VMA ops that can refcount the xa entry
and now that this is core code it is easy enough to harmonize the two
things and track the xa side from the struct rdma_umap_priv

The question is, does EFA or qedr have a use model for this that
allows a userspace verb to create/destroy in a loop? ie do we need to
fix this right now?

Jason
