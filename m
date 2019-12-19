Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEFD126F61
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLSVHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:07:47 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40659 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfLSVHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:07:46 -0500
Received: by mail-qt1-f196.google.com with SMTP id e6so6256164qtq.7
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 13:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b1m6ooTcPBF03IyS8tXbQFWmui5q38MZyl7sgcWDrVc=;
        b=I0eeHPXEKyhR6F3+w0uZp8nZL74lZ+A5yJ1jcW4KB5MO7vY9ONwJPcIUEGlT8SbUeO
         LH81YaW3GC7SMUuObdRRRlnGzTOYLS475Sg1mUPvLmi4JlCQaPrNqV+lDtlEr4ByHobI
         ZOHWHIxyfXKwjF07HIG3BbuRvW3BGN4Y76jyGe62WEFR0v3gEx92h1yDdyRSLYhNDwBJ
         tpCIZrQ8KxYH2/vN+ZSvjy5imMLbf+TFj3Y+cP0N+OLWwhHVLOxCMvkJX7OZ7EDojcBc
         GAxbNt0FBcreyN8pFhlQHApx98BWQ2R7K6v8eS90taP+fCjutUcn9h1snaULI5tTj6Dz
         Afvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b1m6ooTcPBF03IyS8tXbQFWmui5q38MZyl7sgcWDrVc=;
        b=H7oBqO/UGqXWwDCPhZIo1E1spxhojZ7+WGG1M9D6ZqICgQTOwj7bBzzBPyk5rCkNoK
         709t5mAHd+emLAN5BIpnRlIUZ3GftqUDi82QWg2GCyypC4TTY3kEKpRadmUe35tB1c5G
         5GAfg5rewo7I84yPoyY+FH+JGZxoYrLEGHUtI+vHOh2JAOYH9UnWq52bQJVXc1aYU200
         PJdblR8TQMNC6goJPoGuSs6vb8NsU/XmRpGfqt7mP6YGQIyBnQWG3R8bDwmgF4nRm4t5
         V7BfTPMQiA1MNiyNiAcjFTD4owi86/nOSEt3btYBpP6agRlClwnVYM/Qh8oAJX6zO3Kw
         SZeA==
X-Gm-Message-State: APjAAAVIxq+48cgUYvor9pWxh7OJyL8T9ueHZ+AhPxvTjXZXaSpU+WvQ
        M4LuEeY6qy8Fb+/Cwtn+7OiSGQ==
X-Google-Smtp-Source: APXvYqxVnwIXGsi0o/bO9dZGQ7XuTOfFwgCWi/4t790OZPxPymgdPJt3SfFmZqkv2903tXMsYUoGBQ==
X-Received: by 2002:ac8:2d30:: with SMTP id n45mr8586782qta.203.1576789665577;
        Thu, 19 Dec 2019 13:07:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m20sm2085982qkk.15.2019.12.19.13.07.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Dec 2019 13:07:44 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ii31L-0007mU-Uf; Thu, 19 Dec 2019 17:07:43 -0400
Date:   Thu, 19 Dec 2019 17:07:43 -0400
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
Message-ID: <20191219210743.GN17227@ziepe.ca>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 12:30:31PM -0800, John Hubbard wrote:
> On 12/19/19 5:26 AM, Leon Romanovsky wrote:
> > On Mon, Dec 16, 2019 at 02:25:12PM -0800, John Hubbard wrote:
> > > Hi,
> > > 
> > > This implements an API naming change (put_user_page*() -->
> > > unpin_user_page*()), and also implements tracking of FOLL_PIN pages. It
> > > extends that tracking to a few select subsystems. More subsystems will
> > > be added in follow up work.
> > 
> > Hi John,
> > 
> > The patchset generates kernel panics in our IB testing. In our tests, we
> > allocated single memory block and registered multiple MRs using the single
> > block.
> > 
> > The possible bad flow is:
> >   ib_umem_geti() ->
> >    pin_user_pages_fast(FOLL_WRITE) ->
> >     internal_get_user_pages_fast(FOLL_WRITE) ->
> >      gup_pgd_range() ->
> >       gup_huge_pd() ->
> >        gup_hugepte() ->
> >         try_grab_compound_head() ->
> 
> Hi Leon,
> 
> Thanks very much for the detailed report! So we're overflowing...
> 
> At first look, this seems likely to be hitting a weak point in the
> GUP_PIN_COUNTING_BIAS-based design, one that I believed could be deferred
> (there's a writeup in Documentation/core-api/pin_user_page.rst, lines
> 99-121). Basically it's pretty easy to overflow the page->_refcount
> with huge pages if the pages have a *lot* of subpages.
> 
> We can only do about 7 pins on 1GB huge pages that use 4KB subpages.

Considering that establishing these pins is entirely under user
control, we can't have a limit here.

If the number of allowed pins are exhausted then the
pin_user_pages_fast() must fail back to the user.

> 3. It would be nice if I could reproduce this. I have a two-node mlx5 Infiniband
> test setup, but I have done only the tiniest bit of user space IB coding, so
> if you have any test programs that aren't too hard to deal with that could
> possibly hit this, or be tweaked to hit it, I'd be grateful. Keeping in mind
> that I'm not an advanced IB programmer. At all. :)

Clone this:

https://github.com/linux-rdma/rdma-core.git

Install all the required deps to build it (notably cython), see the README.md

$ ./build.sh
$ build/bin/run_tests.py 

If you get things that far I think Leon can get a reproduction for you

Jason
