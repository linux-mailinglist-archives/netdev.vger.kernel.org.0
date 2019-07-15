Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEFE683CE
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 08:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbfGOG7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 02:59:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36672 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfGOG7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 02:59:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so7244577pgm.3;
        Sun, 14 Jul 2019 23:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IwKOrj6wOs1CFDvdOT5gCaug974d+VVC2EWPEZyUC1Y=;
        b=t/+vMyBobZw0yRt1qj7jE3Hv3+ghewmbrlf1rvJGn+lPMgvyfvDx6cugAWNVxd8j97
         hVwx5mP2evT4/5buRUfwS8eLDCxI+aBX3bgCz20FFQApUJ56xzyc13BmxDzwNYE8jtdP
         5kVdnTfQCP2I6xoQWTBcnZRuiq5fxBeBK5pJ+ztIPKWpUD5GeFX4RFrdyOjovs9+vR3V
         xRzXOvvIagWzbmeCdNDvSLmFsoun9S1NnAZximqWbTF5UJU/N+cTCzk3SV4cVA5ph1fI
         G8NDPKhHyemJg5LOOz3NLKuEXNeAogyGjjXQq8sWXD2JtdeO3CnG6GLJ2pe09Z64g0rL
         eB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IwKOrj6wOs1CFDvdOT5gCaug974d+VVC2EWPEZyUC1Y=;
        b=LjzR8JRvE/ih9KzS8JFdv8+IyiXIelW/EXM0164NS+wOvRVFWt9qs0zIhmhmaStA2R
         rcCKxAfb6Vj6uRZoVW3eJLnwGb9WV0MRIPQbAsIfLGCUIThneFJySlv1e3HC44L28CX4
         RxYe6jkDRojvRUnOxLO02kUfqxPVtJVdGW0pX2mTeMPzT0HrXMLqT1typHDCbJwrMWpW
         fF+ayX14PSje6bqbbkNUlEOna/FX4MEvwmfk8Bwn88KykFrVzEcvVG3XKzR+KpUBJjb3
         NwjcHL/010LnmNNy0/A8dU2povkPNQw8pt/Pme8f7t4u3skSjcDuLCLKQy/G2GCZ69/m
         yRNA==
X-Gm-Message-State: APjAAAW9TXIx3ibKtM8gEyagKivbK7DpNEkaKqnBqdK3oRLdkGy87caX
        SYSEZ07i4MJCg6edSmNIsgE=
X-Google-Smtp-Source: APXvYqxlTY9pqlj/BPGdaqjVxWccUIuIsUVjY5d4MIOOEnUblRLiyLEc5qKix+00afDAkA/xNHMT2g==
X-Received: by 2002:a63:224a:: with SMTP id t10mr25187948pgm.289.1563173976925;
        Sun, 14 Jul 2019 23:59:36 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id o130sm27438459pfg.171.2019.07.14.23.59.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 23:59:36 -0700 (PDT)
Date:   Mon, 15 Jul 2019 12:29:17 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     akpm@linux-foundation.org, ira.weiny@intel.com,
        jhubbard@nvidia.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Matt Sickler <Matt.Sickler@daktronics.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        YueHaibing <yuehaibing@huawei.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org
Subject: Re: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
Message-ID: <20190715065917.GB3716@bharath12345-Inspiron-5559>
References: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
 <018ee3d1-e2f0-ca12-9f63-945056c09985@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018ee3d1-e2f0-ca12-9f63-945056c09985@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 08:33:57PM -0600, Jens Axboe wrote:
> On 7/14/19 1:08 PM, Bharath Vedartham wrote:
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 4ef62a4..b4a4549 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2694,10 +2694,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
> >   			 * if we did partial map, or found file backed vmas,
> >   			 * release any pages we did get
> >   			 */
> > -			if (pret > 0) {
> > -				for (j = 0; j < pret; j++)
> > -					put_page(pages[j]);
> > -			}
> > +			if (pret > 0)
> > +				put_user_pages(pages, pret);
> > +
> >   			if (ctx->account_mem)
> >   				io_unaccount_mem(ctx->user, nr_pages);
> >   			kvfree(imu->bvec);
> 
> You handled just the failure case of the buffer registration, but not
> the actual free in io_sqe_buffer_unregister().
> 
> -- 
> Jens Axboe
Yup got it! Thanks! I won't be sending a patch again as fs/io_uring.c
may have larger local changes for put_user_pages.

Thanks
