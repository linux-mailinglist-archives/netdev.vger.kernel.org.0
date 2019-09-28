Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE48DC0FE0
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 07:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfI1Fx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 01:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfI1Fx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 01:53:28 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 256222081B;
        Sat, 28 Sep 2019 05:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569650007;
        bh=aLkH+ZdXUFIBcnSNGNrkMg1yQ10pKKBf+tsQRFofYUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tC8wWFASvdAwXxb1tq5/NbfGDjw8Fu64StyGXFnwkdea8uJ8yfHEev2RAZ9ydTIhc
         oeTDtpwsJZ2V78NTTjk4fIDTnOvF64WweqIdAw7jefT2WQtGgEuJxEo0e6Sccostth
         M9bi1MkOp9rOisSlHyCcbwHS78RI/pm3FcOZ9tdU=
Date:   Sat, 28 Sep 2019 08:53:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
Message-ID: <20190928055322.GH14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-16-jeffrey.t.kirsher@intel.com>
 <20190926174948.GE14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BC6@fmsmsx123.amr.corp.intel.com>
 <20190927044653.GF14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC704647@fmsmsx123.amr.corp.intel.com>
 <20190927182346.GE1804168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927182346.GE1804168@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 08:23:46PM +0200, gregkh@linuxfoundation.org wrote:
> On Fri, Sep 27, 2019 at 02:28:20PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
> > >
> > > On Thu, Sep 26, 2019 at 07:49:33PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility
> > > > > definitions
> > > > >
> > > > > On Thu, Sep 26, 2019 at 09:45:14AM -0700, Jeff Kirsher wrote:
> > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > >
> > > > > > Add miscellaneous utility functions and headers.
> > > > > >
> > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > ---
> > > > > >  drivers/infiniband/hw/irdma/osdep.h  |  108 ++
> > > > > >  drivers/infiniband/hw/irdma/protos.h |   96 ++
> > > > > >  drivers/infiniband/hw/irdma/status.h |   70 +
> > > > > >  drivers/infiniband/hw/irdma/utils.c  | 2333
> > > > > > ++++++++++++++++++++++++++
> > > > > >  4 files changed, 2607 insertions(+)  create mode 100644
> > > > > > drivers/infiniband/hw/irdma/osdep.h
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> > > > > >
> > > > > > diff --git a/drivers/infiniband/hw/irdma/osdep.h
> > > > > > b/drivers/infiniband/hw/irdma/osdep.h
> > > > > > new file mode 100644
> > > > > > index 000000000000..5885b6fa413d
> > > > > > --- /dev/null
> > > > > > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > > > > > @@ -0,0 +1,108 @@
> > > > > > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > > > > > +/* Copyright (c) 2019, Intel Corporation. */
> > > > > > +
> > > > > > +#ifndef IRDMA_OSDEP_H
> > > > > > +#define IRDMA_OSDEP_H
> > > > > > +
> > > > > > +#include <linux/version.h>
> > > > > > +#include <linux/kernel.h>
> > > > > > +#include <linux/vmalloc.h>
> > > > > > +#include <linux/string.h>
> > > > > > +#include <linux/bitops.h>
> > > > > > +#include <linux/pci.h>
> > > > > > +#include <net/tcp.h>
> > > > > > +#include <crypto/hash.h>
> > > > > > +/* get readq/writeq support for 32 bit kernels, use the low-first
> > > > > > +version */ #include <linux/io-64-nonatomic-lo-hi.h>
> > > > > > +
> > > > > > +#define MAKEMASK(m, s) ((m) << (s))
> > > > >
> > > > > It is a little bit over-macro.
> > > > >
> > > >
> > > > Why is this a problem?
> > > > We are not translating any basic kernel construct here.
> > >
> > > See BIT() definition.
> > >
> > OK. And?
>
> And you just re-created GENMASK().  Please use in-kernel definitions
> instead of creating your own.

More on that, they also redefined so basic C-operation that it looks
embarrassing. I tried to find any advantages of doing that and failed.
 * Does it save typing (less to type) significantly ? - No
 * Is it different between compilers/archs? - No
 * Is it so tricky that average developer needs helper? - No

Thanks

>
> thanks,
>
> greg k-h
