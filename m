Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4714A71BCB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbfGWPgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:36:44 -0400
Received: from verein.lst.de ([213.95.11.211]:42749 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbfGWPgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 11:36:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A348468B02; Tue, 23 Jul 2019 17:36:40 +0200 (CEST)
Date:   Tue, 23 Jul 2019 17:36:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm/gup: introduce __put_user_pages()
Message-ID: <20190723153640.GB720@lst.de>
References: <20190722223415.13269-1-jhubbard@nvidia.com> <20190722223415.13269-2-jhubbard@nvidia.com> <20190723055359.GC17148@lst.de> <8ab4899c-ec12-a713-cac2-d951fff2a347@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab4899c-ec12-a713-cac2-d951fff2a347@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 11:33:32PM -0700, John Hubbard wrote:
> I'm seeing about 18 places where set_page_dirty() is used, in the call site
> conversions so far, and about 20 places where set_page_dirty_lock() is
> used. So without knowing how many of the former (if any) represent bugs,
> you can see why the proposal here supports both DIRTY and DIRTY_LOCK.

Well, it should be fairly easy to audit.  set_page_dirty() is only
safe if we are dealing with a file backed page where we have reference
on the inode it hangs off.  Which should basically be never or almost
never.
