Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A46EEE9BA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKDUhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:37:05 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37085 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKDUhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:37:04 -0500
Received: by mail-qk1-f196.google.com with SMTP id e187so6271149qkf.4
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 12:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rGN1CMMcv27mrbyjqTfJtMw4/MfiXe8ZUNAjLnIfNc8=;
        b=TG8Hk1NeRC++G6+F2yPv9zRlkB5zmpjIx9ZuDUNKab/C+J6d7xxfOxxIO7eKgvsTt+
         p3r7qXvBb+Zz3r5NF9wt7yEiPQTVgxKnL+HEF2RNhT/2isit4pN3VfgQ2DIpr/R7/4Hw
         u7TwLaFjyPwmRXIFAaBFi4fpQejOEyaDwRD+BmP4qgv0NQc4ENsX+0jMxqrPG0iCiCMO
         7RWUYzK0XfILQOzslmYaqc8eKt7DtdAn4YRVb6r7EuXFpZ7WiuUUv4iKaUItPpl758jM
         1rA117djJwEsfQGPp7Z0dJc7+OtMVamSH8lioe2hkB5VkJCtZKnaAY/7jmqeoI1EBbdB
         D0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rGN1CMMcv27mrbyjqTfJtMw4/MfiXe8ZUNAjLnIfNc8=;
        b=D1YrDW+II35PO2vxH/hUm4VRYRjBFYlZYoXB0Erimawe0ck7YzNXQs3zHe3fE2JriW
         UiBbac1rOvC6ZoJcGSPciZnQ9bwkUk5VXQNQPTJX21NwkDYS2JijcqML+yCkndc+5MO4
         xx9LpjMwDDCunkSdtleHlKqlIb39DN1Y6dRmDGOZM79JOdKMD+r/bEuI0W/Tc+x9wnd2
         uEiz/+VlaMmOpmFWTNL1GzGMJQu3So2xwclwvedufM8cq9RZP1KLGOa+wG+CPNfa6pH0
         a8mIfVaFtPQ3+X7RSPdJfBVhDQZQTieR6KnMVmTGoaxxRzFjgaAnOIoGDBPB/rZntCT0
         B8Dw==
X-Gm-Message-State: APjAAAUE4IwKTWReQhNEdApDr+f/JD1q09zVFM0bYmCH+50NjyALCciw
        4Db5FgG3P7KzBGJ19lTqCfhWkw==
X-Google-Smtp-Source: APXvYqyT2XrB8OH9lK27HX22fLNbm8bipIFqvEED+1gyXtGC25AghyQahqXSG6rV31VKukiCJdMK8w==
X-Received: by 2002:a05:620a:90a:: with SMTP id v10mr18785575qkv.195.1572899823664;
        Mon, 04 Nov 2019 12:37:03 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u189sm9293005qkd.62.2019.11.04.12.37.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Nov 2019 12:37:03 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iRj5y-0005JK-NP; Mon, 04 Nov 2019 16:37:02 -0400
Date:   Mon, 4 Nov 2019 16:37:02 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
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
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191104203702.GG30938@ziepe.ca>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
 <20191104195248.GA7731@redhat.com>
 <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
 <20191104203153.GB7731@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104203153.GB7731@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 03:31:53PM -0500, Jerome Glisse wrote:
> > Note for Jason: the (a) or (b) items are talking about the vfio case, which is
> > one of the two call sites that now use pin_longterm_pages_remote(), and the
> > other one is infiniband:
> > 
> > drivers/infiniband/core/umem_odp.c:646:         npages = pin_longterm_pages_remote(owning_process, owning_mm,
> > drivers/vfio/vfio_iommu_type1.c:353:            ret = pin_longterm_pages_remote(NULL, mm, vaddr, 1,
> 
> vfio should be reverted until it can be properly implemented.
> The issue is that when you fix the implementation you might
> break vfio existing user and thus regress the kernel from user
> point of view. So i rather have the change to vfio reverted,
> i believe it was not well understood when it got upstream,
> between in my 5.4 tree it is still gup_remote not longterm.

It is clearly a bug, vfio must use LONGTERM, and does right above this
remote call:

        if (mm == current->mm) {
                ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
                                     vmas);
        } else {
                ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
                                            vmas, NULL);


I'm not even sure that it really makes any sense to build a 'if' like
that, surely just always call remote??

Jason
