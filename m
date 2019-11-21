Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65889105490
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 15:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfKUOgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 09:36:47 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42139 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKUOgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 09:36:47 -0500
Received: by mail-qv1-f67.google.com with SMTP id n4so1466102qvq.9
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 06:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rv5c3PJEtM2ffNdfZuVl2p9Xs+FPDxJaOjEmQ2G8DAo=;
        b=XkP12c/ibS/aRyryTCd4qjn/PXxyYCusK1THaNAzNjypEGkjhmCt9LtT+qYEnSe3fB
         R0spZ8YqysCDI95uGLLvFVswmZUjEqJ9cNCyHcavEFwClRwZ6y4PKDy88MyzZlAfM967
         hisIg3vRQPZ469GZRWnqA3CNAZUY/hKDr+kXV7+2R0BibPU9CM1KGy5uODfMlNXxTJJo
         tHEs5mFWOzUwzAdEjcr2fH3dCNIBIBIgehoNt8ki1/1o3yu01BkPAihfF+3/v5R6c6NG
         mm7J2IKwvLhTCpGsMr85umCSjimcUeH9XgLjTylXIMq1THOPpUYiNcR9NxoGX25nyfzV
         YKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rv5c3PJEtM2ffNdfZuVl2p9Xs+FPDxJaOjEmQ2G8DAo=;
        b=mVKKDHGxA020SltHn2dQCED/PLJR0yJnefpZmZDXe7QV9ZvorBToutW1f543EhKHG6
         u4UHpkM2mJgXMvw61Pbc410dZ4evIcpfGZV8V1YeNnokO4IAVpbqzfKigm0TiWt6G0Rj
         12MKX0sa0Jg8jhujCg/9IJGHcfm5qG5t/mpbqOs9aa+U4iV6MYQarTmtMwzlIlJzX2Lo
         4F6TY8A1LgD05nzc2K7C3hcNaOJuUsWCDRihMvJ+pzA59bR76jaaaOQSVlAB0MvVti38
         7jfd5Lq/upRjqLIdrQKzOGtwvDxa5BXfXAROmM2YWTy6tHYVJY5AMY7NixJodAX9yYru
         62sA==
X-Gm-Message-State: APjAAAVrqBCv/oL0cJO+uoaIXE++e8Rw309dK2d4wh3ff+SWOgKRMBoL
        QgTH0/yMoUqy1/SBhYOor66zXw==
X-Google-Smtp-Source: APXvYqxiPTD6uqfSlGreW7CNwXwCXJOA4tNSbO40QzzV7IhKLzuaPAx4PWY7OQoHdNILaiGopmJlAA==
X-Received: by 2002:a0c:e74a:: with SMTP id g10mr8540002qvn.29.1574347005412;
        Thu, 21 Nov 2019 06:36:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id 40sm1584912qtc.95.2019.11.21.06.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Nov 2019 06:36:44 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXnZb-0004bF-SZ; Thu, 21 Nov 2019 10:36:43 -0400
Date:   Thu, 21 Nov 2019 10:36:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
Subject: Re: [PATCH v7 07/24] IB/umem: use get_user_pages_fast() to pin DMA
 pages
Message-ID: <20191121143643.GC7448@ziepe.ca>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-8-jhubbard@nvidia.com>
 <20191121080746.GC30991@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121080746.GC30991@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 12:07:46AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 11:13:37PM -0800, John Hubbard wrote:
> > And get rid of the mmap_sem calls, as part of that. Note
> > that get_user_pages_fast() will, if necessary, fall back to
> > __gup_longterm_unlocked(), which takes the mmap_sem as needed.
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Jason, can you queue this up for 5.5 to reduce this patch stack a bit?

Yes, I said I'd do this in an earlier revision. Now that it is clear this
won't go through Andrew's tree, applied to rdma for-next

Thanks,
Jason
