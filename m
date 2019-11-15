Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D5EFDFB3
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfKOOIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:08:45 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33066 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfKOOIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 09:08:45 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so10972512qty.0
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 06:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8ZGdiHZxf3ZHqX3I8ydxFdLkSWkpE5WrCI0dICjPpHU=;
        b=i+UlYqHpSoy9hrCL3gQPMJUhUw3RKIgDls07tcBvdNTrD4jl5OTOMJfNN1MASvpOc/
         n/RUaDL07zMYWDhclWHPDZnaqTZ6YdpZfzuTyA+HrehI2Ydc75hfkUNiRgV5KLUhGbZ5
         hwJR6j62hBrGSzy1DyO8h1zN9TlzptjO0LEx4CpgETqR3CBgJNCsKnZKRcbg5KwHic/q
         pEIdohRRBLTVk18YHW5Vi8NX67r/lGgj0cpRlIJEz6SaDVQBInMFNoQa60kFdiQzPjma
         xgI2yhuOWu+cTXk9NFpI3of3yS1+C6h76JgFDhrvoDw5piCzGcHI/ud3iOPSS57DuCxF
         BfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8ZGdiHZxf3ZHqX3I8ydxFdLkSWkpE5WrCI0dICjPpHU=;
        b=smRMbgal1JqFs47PldRQXpAKLOCS5DYIk838BTazy2SrnWIrX0OCPke9G40gV3oleu
         q3PMmr+RVSWWW515bSAGJP6n8fxBPC9sYbpOtIEABqqFJTdIR206n+DzP31x1b0FyaSb
         qi6hFq8iPnAE6IJv4UPnreY4r/zUfChdGXLRb+HrsxFwwSL+POOzZy8wNgFcr8UBvZdo
         YcsB7G/5eJpm93Dsga4vokB1MM8zJpnTF5htqodPLfkmh2wx2s2/M6DsZslw0UaINPyY
         76A497AtbmYHPXZd/gHkUQya55Aad3dTIq8HbBZV27QAHjVArVN7prpta0qlNfQKaeiO
         z9FA==
X-Gm-Message-State: APjAAAWNKcvcMmI7uhGG55QTx0OVCy2lcVSitTJBWcjMzS53UG2l6WvJ
        3o9aH6AbrQkA5QKjkNouOpw1og==
X-Google-Smtp-Source: APXvYqyXZJAB3M+2SHRriOZec9Rfd1hMhPGpVi3+hL/5cz80ckTUMXVgMRzWDvTX6XEGdZam3s9/QQ==
X-Received: by 2002:ac8:661a:: with SMTP id c26mr13620771qtp.317.1573826923526;
        Fri, 15 Nov 2019 06:08:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id s21sm5382292qtc.12.2019.11.15.06.08.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Nov 2019 06:08:42 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iVcHC-0002xg-A8; Fri, 15 Nov 2019 10:08:42 -0400
Date:   Fri, 15 Nov 2019 10:08:42 -0400
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
Subject: Re: [PATCH v5 09/24] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191115140842.GA4055@ziepe.ca>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-10-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115055340.1825745-10-jhubbard@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 09:53:25PM -0800, John Hubbard wrote:
> As it says in the updated comment in gup.c: current FOLL_LONGTERM
> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> FS DAX check requirement on vmas.
> 
> However, the corresponding restriction in get_user_pages_remote() was
> slightly stricter than is actually required: it forbade all
> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> that do not set the "locked" arg.
> 
> Update the code and comments accordingly, and update the VFIO caller
> to take advantage of this, fixing a bug as a result: the VFIO caller
> is logically a FOLL_LONGTERM user.
> 
> Also, remove an unnessary pair of calls that were releasing and
> reacquiring the mmap_sem. There is no need to avoid holding mmap_sem
> just in order to call page_to_pfn().
> 
> Also, move the DAX check ("if a VMA is DAX, don't allow long term
> pinning") from the VFIO call site, all the way into the internals
> of get_user_pages_remote() and __gup_longterm_locked(). That is:
> get_user_pages_remote() calls __gup_longterm_locked(), which in turn
> calls check_dax_vmas(). It's lightly explained in the comments as well.
> 
> Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
> and to Dan Williams for helping clarify the DAX refactoring.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++-------------------------
>  mm/gup.c                        | 27 ++++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 30 deletions(-)

Looks OK now  

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
