Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F6779A73
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfG2U5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbfG2U5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 16:57:38 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40047C060204;
        Mon, 29 Jul 2019 20:57:37 +0000 (UTC)
Received: from redhat.com (ovpn-112-31.rdu2.redhat.com [10.10.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D8C65C219;
        Mon, 29 Jul 2019 20:57:24 +0000 (UTC)
Date:   Mon, 29 Jul 2019 16:57:21 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        v9fs-developer@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org,
        John Hubbard <jhubbard@nvidia.com>,
        Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH 03/12] block: bio_release_pages: use flags arg instead of
 bool
Message-ID: <20190729205721.GB3760@redhat.com>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
 <20190724042518.14363-4-jhubbard@nvidia.com>
 <20190724053053.GA18330@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190724053053.GA18330@infradead.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 29 Jul 2019 20:57:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:30:53PM -0700, Christoph Hellwig wrote:
> On Tue, Jul 23, 2019 at 09:25:09PM -0700, john.hubbard@gmail.com wrote:
> > From: John Hubbard <jhubbard@nvidia.com>
> > 
> > In commit d241a95f3514 ("block: optionally mark pages dirty in
> > bio_release_pages"), new "bool mark_dirty" argument was added to
> > bio_release_pages.
> > 
> > In upcoming work, another bool argument (to indicate that the pages came
> > from get_user_pages) is going to be added. That's one bool too many,
> > because it's not desirable have calls of the form:
> 
> All pages releases by bio_release_pages should come from
> get_get_user_pages, so I don't really see the point here.

No they do not all comes from GUP for see various callers
of bio_check_pages_dirty() for instance iomap_dio_zero()

I have carefully tracked down all this and i did not do
anyconvertion just for the fun of it :)

Cheers,
Jérôme
