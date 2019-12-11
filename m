Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C6F11A033
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 01:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLKAtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 19:49:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLKAtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 19:49:32 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACEC206D5;
        Wed, 11 Dec 2019 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576025371;
        bh=mS7zyk9RzK8MLQp+5nvdMy6P3ysyYQCDC3Bah6kmlfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UvC0RIny6iqVEumpqrPw6rq1+xZGMHezDVxIFrfIHyEiEEKaKQc5hGaYaeoZSLVqv
         OiKjZB9JvOrs5D8lM5PO+WX7OQOLW/u0awaO48QIwAJPLeFa0zJF2HELO5AISWbm2x
         nMOoibFNiErcex5Kfzt1sOkhZk08/M0uQclzXbn4=
Date:   Tue, 10 Dec 2019 16:49:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?ISO-8859-1?Q?J=E9r?= =?ISO-8859-1?Q?=F4me?= Glisse 
        <jglisse@redhat.com>, Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 20/26] powerpc: book3s64: convert to pin_user_pages()
 and put_user_page()
Message-Id: <20191210164929.b3f54fe95c3fc4b6c756e65e@linux-foundation.org>
In-Reply-To: <61e0c3a5-992e-4571-e22d-d63286ce10ec@nvidia.com>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
        <20191209225344.99740-21-jhubbard@nvidia.com>
        <08f5d716-8b31-b016-4994-19fbe829dc28@nvidia.com>
        <61e0c3a5-992e-4571-e22d-d63286ce10ec@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 21:53:00 -0800 John Hubbard <jhubbard@nvidia.com> wrote:

> > Correction: this is somehow missing the fixes that resulted from Jan Kara's review (he
> > noted that we can't take a page lock in this context). I must have picked up the
> > wrong version of it, when I rebased for -rc1.
> > 
> 
> Andrew, given that the series is now in -mm, what's the preferred way for me to fix this?
> Send a v9 version of the whole series? Or something else?

I think a full resend is warranted at this time - it's only been in
there a day and there seem to be quite a number of changes to be made.

