Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58269127BBD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfLTNe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:34:27 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:37728 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfLTNe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:34:26 -0500
Received: by mail-qv1-f65.google.com with SMTP id f16so3608170qvi.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 05:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5r9Zi+Au/gtKbsFaE0fKhn5Z9mh4Uiv+qjM4b27ESt8=;
        b=gS91bsS4NjRyWzEDV454oc5qOgomjYBCltRmKzH7Nu9vdI8tQd65a6Yp2TVGSlgA1T
         37v5Lb1zFtvOvSi94i0Yt83/4AqEpVzmzRwSkFPiESUgqKx4PUFqFCjV/s3xXBOVi9U4
         w+ZUvVeXy6xbZ8B7zSi+DLnr0w1yjX7v6UIJiebq6UOkRZYcGvU4/THsXU/G/ZDo26P9
         Xc2y8nF265eAeIX5xgl66hBVWEixNbJ1XzQjNRNan6ViT+Wn6RFHm+C8bWOAWNCFyUU3
         D0D+BCr//3+mjkgiCcFfBfObTFOz8gI7nHowmgBdF1XYr9LIFcBR6SXbWA6e0W7l8hfH
         tNRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5r9Zi+Au/gtKbsFaE0fKhn5Z9mh4Uiv+qjM4b27ESt8=;
        b=stPAXSoEjjQDAw4+mMG8ij45bh3PyrAbECq/Q+m7orUzjqMWuiz+MNuh4Et2HuG3Gp
         uD1pCUCE8S8jkXB7QHsKlyRoKD94t+6B5uvbfQ5HOvlf9PzoEJ7IUqPe0enGtVJXYpuh
         LR+eDcA/RTCIvR0POm8Z7wh847tAexDeLeonDy54+ErWpNj9SLs3Bz7GWCJCtptPUviR
         cElyKrJR1nCwgLL/bxTmpqKqUZsK7I/aDNmrY4lPN3nYBFy1lG/rHX27Sd2Wc6oJLaji
         YyYKoGb4hEJOoj0J0YoOkoV/MECtJ7hptUEyYL/mzWHsLQBgxCkvF+7NkG4RS10wDzrI
         XRoQ==
X-Gm-Message-State: APjAAAV6vMXVE/Yh3l0Nm6V3UipjrV/dKL8gkNfi4GbRitz8RJe3X75R
        BThhhLUMBhm1QUVYxuIAHUb79g==
X-Google-Smtp-Source: APXvYqz9az5JjtCMEl1OLVSzBMZYIFm7RbLMGJ3PjpAUx1pKMUVrf5ynor78RCoLoFWtbwHwcCO7NQ==
X-Received: by 2002:a0c:893d:: with SMTP id 58mr4949386qvp.4.1576848864984;
        Fri, 20 Dec 2019 05:34:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id q73sm2786969qka.56.2019.12.20.05.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Dec 2019 05:34:24 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iiIQB-0003cq-Co; Fri, 20 Dec 2019 09:34:23 -0400
Date:   Fri, 20 Dec 2019 09:34:23 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
Message-ID: <20191220133423.GA13506@ziepe.ca>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
 <42a3e5c1-6301-db0b-5d09-212edf5ecf2a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42a3e5c1-6301-db0b-5d09-212edf5ecf2a@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 01:13:54PM -0800, John Hubbard wrote:
> On 12/19/19 1:07 PM, Jason Gunthorpe wrote:
> > On Thu, Dec 19, 2019 at 12:30:31PM -0800, John Hubbard wrote:
> > > On 12/19/19 5:26 AM, Leon Romanovsky wrote:
> > > > On Mon, Dec 16, 2019 at 02:25:12PM -0800, John Hubbard wrote:
> > > > > Hi,
> > > > > 
> > > > > This implements an API naming change (put_user_page*() -->
> > > > > unpin_user_page*()), and also implements tracking of FOLL_PIN pages. It
> > > > > extends that tracking to a few select subsystems. More subsystems will
> > > > > be added in follow up work.
> > > > 
> > > > Hi John,
> > > > 
> > > > The patchset generates kernel panics in our IB testing. In our tests, we
> > > > allocated single memory block and registered multiple MRs using the single
> > > > block.
> > > > 
> > > > The possible bad flow is:
> > > >    ib_umem_geti() ->
> > > >     pin_user_pages_fast(FOLL_WRITE) ->
> > > >      internal_get_user_pages_fast(FOLL_WRITE) ->
> > > >       gup_pgd_range() ->
> > > >        gup_huge_pd() ->
> > > >         gup_hugepte() ->
> > > >          try_grab_compound_head() ->
> > > 
> > > Hi Leon,
> > > 
> > > Thanks very much for the detailed report! So we're overflowing...
> > > 
> > > At first look, this seems likely to be hitting a weak point in the
> > > GUP_PIN_COUNTING_BIAS-based design, one that I believed could be deferred
> > > (there's a writeup in Documentation/core-api/pin_user_page.rst, lines
> > > 99-121). Basically it's pretty easy to overflow the page->_refcount
> > > with huge pages if the pages have a *lot* of subpages.
> > > 
> > > We can only do about 7 pins on 1GB huge pages that use 4KB subpages.
> > 
> > Considering that establishing these pins is entirely under user
> > control, we can't have a limit here.
> 
> There's already a limit, it's just a much larger one. :) What does "no limit"
> really mean, numerically, to you in this case?

I guess I mean 'hidden limit' - hitting the limit and failing would
be managable.

I think 7 is probably too low though, but we are not using 1GB huge
pages, only 2M..

> > If the number of allowed pins are exhausted then the
> > pin_user_pages_fast() must fail back to the user.
> 
> I'll poke around the IB call stack and see how much of that return
> path is in place, if any. Because it's the same situation for
> get_user_pages_fast().  This code just added a warning on overflow
> so we could spot it early.

All GUP callers must be prepared for failure, IB should be fine...

Jason
