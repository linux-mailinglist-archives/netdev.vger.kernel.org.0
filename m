Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03364104D6F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKUIKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:10:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfKUIKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ayytCJcth5GS0yhMc7G3JkwZ14SgYTl8WFFvY2/7v8M=; b=tSf+ntFIx+E4ElPWg7N/YrDA5
        DJpdGB/LPxrZKjR8XgqAl2zR85VHA697aheq0Zg246jsWgb8mrSdltGy5yMP9HbBodsPoR+gwGpD+
        QVOFwWDZ+KabSirkp4Tt9dB6kmJIUn0J+Il59Ko2Pkv3hkIl+fSJj/KbwMadKof/10NbX4BVK4ecW
        CzXkmxFI+A8ZBzCm+FXsPX/uDD3s0HAgf0WBL/2Hz3XeBUWuBLfRR+cpozCLlR9UfRS5SZMBsI4/v
        eMEAVutB9ql9MJsVHEW4sKjJfLq4kUoa0IJZZM6O6F/e7LcxIe5kML6J3bUd6SLeM+OcPR4CPMA97
        R/3mfYL1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXhVv-0008IQ-Ap; Thu, 21 Nov 2019 08:08:31 +0000
Date:   Thu, 21 Nov 2019 00:08:31 -0800
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 06/24] goldish_pipe: rename local pin_user_pages()
 routine
Message-ID: <20191121080831.GD30991@infradead.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-7-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121071354.456618-7-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:13:36PM -0800, John Hubbard wrote:
> +static int pin_goldfish_pages(unsigned long first_page,
> +			      unsigned long last_page,
> +			      unsigned int last_page_size,
> +			      int is_write,
> +			      struct page *pages[MAX_BUFFERS_PER_COMMAND],
> +			      unsigned int *iter_last_page_size)

Why not goldfish_pin_pages?  Normally we put the module / subsystem
in front.

Also can we get this queued up for 5.5 to get some trivial changes
out of the way?
