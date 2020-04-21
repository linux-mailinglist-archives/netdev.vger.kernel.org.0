Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595BC1B1FB0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgDUHW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgDUHW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:22:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAEAB2074B;
        Tue, 21 Apr 2020 07:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587453776;
        bh=QOOwcYd5TgcnT/ZogHq/DUL3wNZH/tor06LBtz9Zmzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yyYVMrbSdNSAQVuoMCPEMmK2ZALl9e64pjD5OL0hZTwExdgmh819X4sZxdXPHqWfS
         8YtY9RTlNkNIdHIKg8lZPgmv9nHtS500m5iOOZrERiTM5Xcs96abCl6BWKgmVQSnA6
         zaethii1nUcQJ83omtHFgjuv6etVnxEVe0EvBOl0=
Date:   Tue, 21 Apr 2020 10:22:53 +0300
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
Subject: Re: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20200421072253.GH121146@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-15-jeffrey.t.kirsher@intel.com>
 <20200417194300.GC3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD485D1@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD485D1@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:29:15AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
> >
> > On Fri, Apr 17, 2020 at 10:12:49AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Add ABI definitions for irdma.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  include/uapi/rdma/irdma-abi.h | 140
> > > ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 140 insertions(+)
> > >  create mode 100644 include/uapi/rdma/irdma-abi.h
> > >
> > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > 000000000000..2eb253220161
> > > --- /dev/null
> > > +++ b/include/uapi/rdma/irdma-abi.h
> > > @@ -0,0 +1,140 @@
> > > +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR
> > > +Linux-OpenIB) */
> > > +/*
> > > + * Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > > + */
> > > +
> > > +#ifndef IRDMA_ABI_H
> > > +#define IRDMA_ABI_H
> > > +
> > > +#include <linux/types.h>
> > > +
> > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > + * and user-space whose last ABI ver is 5  */ #define IRDMA_ABI_VER 6
> > > +
> > > +enum irdma_memreg_type {
> > > +	IW_MEMREG_TYPE_MEM  = 0,
> > > +	IW_MEMREG_TYPE_QP   = 1,
> > > +	IW_MEMREG_TYPE_CQ   = 2,
> > > +	IW_MEMREG_TYPE_RSVD = 3,
> > > +	IW_MEMREG_TYPE_MW   = 4,
> > > +};
> > > +
> > > +struct irdma_alloc_ucontext_req {
> > > +	__u32 rsvd32;
> > > +	__u8 userspace_ver;
> > > +	__u8 rsvd8[3];
> > > +};
> > > +
> > > +struct i40iw_alloc_ucontext_req {
> > > +	__u32 rsvd32;
> > > +	__u8 userspace_ver;
> > > +	__u8 rsvd8[3];
> > > +};
> > > +
> > > +struct irdma_alloc_ucontext_resp {
> > > +	__aligned_u64 feature_flags;
> > > +	__aligned_u64 db_mmap_key;
> > > +	__u32 max_hw_wq_frags;
> > > +	__u32 max_hw_read_sges;
> > > +	__u32 max_hw_inline;
> > > +	__u32 max_hw_rq_quanta;
> > > +	__u32 max_hw_wq_quanta;
> > > +	__u32 min_hw_cq_size;
> > > +	__u32 max_hw_cq_size;
> > > +	__u32 rsvd1[7];
> > > +	__u16 max_hw_sq_chunk;
> > > +	__u16 rsvd2[11];
> > > +	__u8 kernel_ver;
> >
> > Why do you need to copy this kernel_ver from i40iw?
> > Especially given the fact that i40iw didn't use it too much
> >  120 static int i40iw_alloc_ucontext(struct ib_ucontext *uctx,
> >  121                                 struct ib_udata *udata)
> >  <...>
> >  140         uresp.kernel_ver = req.userspace_ver;
> >
> Its used to pass the current driver ABI ver. to user-space so that
> there is compatibility check in user-space as well.
> for example: old i40iw user-space provider wont bind to gen_2 devices
> by checking the kernel_ver and finding its incompatible. It will bind with
> gen_1 devices though..

I understand that you must keep it in struct i40iw_alloc_ucontext_resp,
but here we are talking about struct irdma_alloc_ucontext_resp. Anyway
the rdma-core should be extended to work with this new struct and you
always return kernel_ver == userspace_ver, which makes impossible to
do any compatibility check.

Plus kernel is expected to be backward compatible.

Thanks

>
