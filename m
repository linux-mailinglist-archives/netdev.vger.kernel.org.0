Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85744104D8A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfKUIK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:10:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfKUIKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DZddNdyW5FRrAXgTdc6w5huJMr/L+GTDCsXkrpDZQWE=; b=Mafq4UPzuRzO9+6g0idvgtn8y
        WcDSiCT7hQFVoaJkaXestyiwMGnqfYjgbEOz0r27XeQ+Y5KvjD4Nuhy0YaDkgeX1N2nHrE2fymh9/
        Kl6qsPzn8bgO9GwKGkSXLJ6yif29++yxYwWthonAbKTOkkQzaykODs/kBCpIPvEL9IlVjXYjhMRJE
        HObsxeSD97VjwE1Ac50vXPpo12MNChRAcbknrDS9loF08kQwig/wzQVsPl/cwUiTKkHvJYvfDWnFU
        FO6tlhkm1YjoPatb8/UhLvWJuQFmCn5wpi+24IGZ7mIRAGQpgH/fHbaZ8f9hs4dGNlP7WUQjseLo0
        O4T8RJ40Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXhXf-0001ki-FW; Thu, 21 Nov 2019 08:10:19 +0000
Date:   Thu, 21 Nov 2019 00:10:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
        Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v7 09/24] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191121081019.GF30991@infradead.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-10-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121071354.456618-10-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should this be two patches, one for th core infrastructure and one for
the user?  These changes also look like another candidate to pre-load.
