Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6871B1FD2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgDUHau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgDUHat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:30:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BA082073A;
        Tue, 21 Apr 2020 07:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587454249;
        bh=PLdec2VhYKoRkrfdBBvI2uwHqB9CC0keaMo/Y3pT4r8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UmEHoFc6f/AOGss3bSJ/zK/oDbZhuRzrXchkMuO8t8Nm61xT8U0LuSDOq5/vJvTCl
         dn8CoNAuLdysIVlKUrx9a/CBEG9bHi59XjhDS881BcSFBIs2CTFr85euW7lE2Ep2WK
         +ok9IjrFp8oIycBWEEuibKrXJo6DmecQSl/i9+Os=
Date:   Tue, 21 Apr 2020 10:30:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Message-ID: <20200421073044.GI121146@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
 <20200417203216.GH3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD485B7@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD485B7@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:27:28AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
> > definitions
> >
> > On Fri, Apr 17, 2020 at 10:12:47AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Add miscellaneous utility functions and headers.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/osdep.h  |  105 ++
> > >  drivers/infiniband/hw/irdma/protos.h |   93 +
> > >  drivers/infiniband/hw/irdma/status.h |   69 +
> > >  drivers/infiniband/hw/irdma/utils.c  | 2445
> > > ++++++++++++++++++++++++++
> > >  4 files changed, 2712 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> > >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> > >
> > > diff --git a/drivers/infiniband/hw/irdma/osdep.h
> > > b/drivers/infiniband/hw/irdma/osdep.h
> > > new file mode 100644
> > > index 000000000000..23ddfb8e9568
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > > @@ -0,0 +1,105 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #ifndef
> > > +IRDMA_OSDEP_H #define IRDMA_OSDEP_H
> > > +
> > > +#include <linux/version.h>
> >
> > Why is that?
> Not needed. Thanks!
>
> >
> > > +#define irdma_debug_buf(dev, prefix, desc, buf, size)	\
> > > +	print_hex_dump_debug(prefix ": " desc " ",	\
> > > +			     DUMP_PREFIX_OFFSET,	\
> > > +			     16, 8, buf, size, false)
> > > +
> >
> > I think that it can be beneficial to be as ibdev_print_buf().
>
> Macro itself looks a little weird since dev is not used and needs to be fixed.
> I wonder why there isn't a struct device ver. of this print buf
> to start with.
>
> [...]
>
> > > +	IRDMA_ERR_BAD_STAG			= -66,
> > > +	IRDMA_ERR_CQ_COMPL_ERROR		= -67,
> > > +	IRDMA_ERR_Q_DESTROYED			= -68,
> > > +	IRDMA_ERR_INVALID_FEAT_CNT		= -69,
> > > +	IRDMA_ERR_REG_CQ_FULL			= -70,
> > > +	IRDMA_ERR_VF_MSG_ERROR			= -71,
> > > +};
> >
> > Please don't do vertical space alignment in all the places
>
> vertically aligning groups of defines that are related or enum constants
> look more readable.
>
> +       IRDMA_ERR_BAD_STAG = -66,
> +       IRDMA_ERR_CQ_COMPL_ERROR = -67,
> +       IRDMA_ERR_Q_DESTROYED = -68,
> +       IRDMA_ERR_INVALID_FEAT_CNT = -69,
> +       IRDMA_ERR_REG_CQ_FULL = -70,
> +       IRDMA_ERR_VF_MSG_ERROR = -71,
>
> This looks less readable IMHO.

It works well until you need some ridiculous long name to introduce,
for example https://lore.kernel.org/linux-rdma/20200413141538.935574-8-leon@kernel.org

>
> >
> > > +#endif /* IRDMA_STATUS_H */
> > > diff --git a/drivers/infiniband/hw/irdma/utils.c
> > > b/drivers/infiniband/hw/irdma/utils.c
> > > new file mode 100644
> > > index 000000000000..be46d672afc5
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/irdma/utils.c
> > > @@ -0,0 +1,2445 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include
> > > +<linux/mii.h> #include <linux/in.h> #include <linux/init.h> #include
> > > +<asm/irq.h> #include <asm/byteorder.h> #include <net/neighbour.h>
> > > +#include "main.h"
> > > +
> > > +/**
> > > + * irdma_arp_table -manage arp table
> > > + * @rf: RDMA PCI function
> > > + * @ip_addr: ip address for device
> > > + * @ipv4: IPv4 flag
> > > + * @mac_addr: mac address ptr
> > > + * @action: modify, delete or add
> > > + */
> > > +int irdma_arp_table(struct irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
> > > +		    u8 *mac_addr, u32 action)
> >
> > ARP table in the RDMA driver looks strange, I see that it is legacy from i40iw, but
> > wonder if it is the right thing to do the same for the new driver.
> >
>
> See response in Patch #1.

OK, let's me rephrase the question.
Why can't you use arp_tbl from include/net/arp.h and need
to implement it in the RDMA driver?

Thanks
