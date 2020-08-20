Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBBA24BF26
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgHTNlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgHTNl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:41:26 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F1C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:41:25 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u126so2156917iod.12
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AeFXsBpjEjXwZArxk4fkIGZScXLaU3nnXdZ7iWShA4M=;
        b=szb4kcaW6eguluz8VeLToO/0TMw9o4SlOzHCU/VG+BtIFFxlNcIzz0mohHZq+p5I8P
         2NAlR9GDcEfsAdlNwIvJVFNNlHa/8yPr7k4B44+WvHgpMqc7VfwyG1J9JwKlyYUmT5rt
         7aR3WTUjVehvJf5n/GgMAX+r4ZVChx4e7U41LTo0ZhkEqPng9AToLmMFhFY940PYyleN
         3fLeNGyXGsryV543jMLhNFIO7V4v/0/mXI6pPLkx1RT8ayaFfU8JGhfTv1+DD8hxCNGV
         B2+sbvTvGBATedpboEIleNLc/A3KLkmTWNSVpkUBbAQGgLd5TKswb0qtwTbKVDPfJr13
         soVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AeFXsBpjEjXwZArxk4fkIGZScXLaU3nnXdZ7iWShA4M=;
        b=MWBTtvVcQanDGn38GH4iQcNzTU7vqfOa8YQBnVhn1u2KEHKg30JfncqfQ4hmb04EYC
         kombl0wNThOJ0oljh2xuPsXWmDsnPpiSH+UXUVNxYbBdujC8jjbqdBNt9hQ6ySBjtoEH
         wtLbnGXOQ+mIu/dO+uTezC66Vv+/F9SHXZQU6/tJfVQkbLMLJqTCqbquc5+QzNNBag2m
         W++xvDpHt4BN37XfmGb29y0Ho/cDvPih6NHFiVoCIjWqC5jpHkZCN61ITfaeBJ3NgCMQ
         5cjaJA8zf7L7CXEmgSUFK738FJxgSwIlAv5HU1yWN9av0e/xIi6WZ/4tlgSvUYSUkSB4
         yqmA==
X-Gm-Message-State: AOAM5317CUJqEpfNpcxRqZJFsmqcjJBJbbUTzyU+ixiC2wd3RJjJWwEu
        sWLRp2nfymZhOQzWw1DBZqN1Hqe0bq5RvQVe090=
X-Google-Smtp-Source: ABdhPJxB+IgzLVvvmXuTYo0jxpHh7Sm7XmkGNgHKC0Ji5dk+KO+0Y0lRngNySH4tQvkaTaJy2iwNuCv3siKrSo4+K9w=
X-Received: by 2002:a5e:d505:: with SMTP id e5mr2649540iom.77.1597930882655;
 Thu, 20 Aug 2020 06:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
 <1597770557-26617-3-git-send-email-sundeep.lkml@gmail.com> <20200819090002.00005f4a@intel.com>
In-Reply-To: <20200819090002.00005f4a@intel.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 20 Aug 2020 19:11:11 +0530
Message-ID: <CALHRZup5G+U0KGxfVLAKxfkHPQq09xNt8vYm9JORcUWbgGbr-w@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 2/3] octeontx2-af: Add support for Marvell PTP coprocessor
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 19, 2020 at 9:30 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> sundeep.lkml@gmail.com wrote:
>
> > From: Aleksey Makarov <amakarov@marvell.com>
> >
> > This patch adds driver for Precision Time
> > Protocol Clock and Timestamping block found on
> > Octeontx2 platform. The driver does initial
> > configuration and exposes a function to adjust
> > PTP hardware clock.
>
> Please explain in the commit message why you have two methods of
> handling the clocks PCI space, as without that it seems like some of
> the code is either un-necessary or not clear why it's there.
>
Sure will elaborate it.
> >
> > Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
> >  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  17 ++
> >  drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 248 +++++++++++++++++++++
> >  drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  22 ++
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
> >  6 files changed, 318 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> >  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> > index 1b25948..0bc2410 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> > @@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
> >
> >  octeontx2_mbox-y := mbox.o
> >  octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
> > -               rvu_reg.o rvu_npc.o rvu_debugfs.o
> > +               rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > index c89b098..4aaef0a 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > @@ -127,6 +127,7 @@ M(ATTACH_RESOURCES,       0x002, attach_resources, rsrc_attach, msg_rsp)  \
> >  M(DETACH_RESOURCES,  0x003, detach_resources, rsrc_detach, msg_rsp)  \
> >  M(MSIX_OFFSET,               0x005, msix_offset, msg_req, msix_offset_rsp)   \
> >  M(VF_FLR,            0x006, vf_flr, msg_req, msg_rsp)                \
> > +M(PTP_OP,            0x007, ptp_op, ptp_req, ptp_rsp)                \
> >  M(GET_HW_CAP,                0x008, get_hw_cap, msg_req, get_hw_cap_rsp)     \
> >  /* CGX mbox IDs (range 0x200 - 0x3FF) */                             \
> >  M(CGX_START_RXTX,    0x200, cgx_start_rxtx, msg_req, msg_rsp)        \
> > @@ -862,4 +863,20 @@ struct npc_get_kex_cfg_rsp {
> >       u8 mkex_pfl_name[MKEX_NAME_LEN];
> >  };
> >
> > +enum ptp_op {
> > +     PTP_OP_ADJFINE = 0,
> > +     PTP_OP_GET_CLOCK = 1,
> > +};
> > +
> > +struct ptp_req {
> > +     struct mbox_msghdr hdr;
> > +     u8 op;
> > +     s64 scaled_ppm;
> > +};
> > +
> > +struct ptp_rsp {
> > +     struct mbox_msghdr hdr;
> > +     u64 clk;
> > +};
> > +
> >  #endif /* MBOX_H */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > new file mode 100644
> > index 0000000..e9e131d
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > @@ -0,0 +1,248 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Marvell PTP driver */
>
> Your file is missing Copyrights, is that your intent?
>
From the discussion during VF driver submission @
https://patchwork.ozlabs.org/project/netdev/patch/1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com/#2384778
we are putting only the two lines SPDX and short driver description

> I didn't have any comments for the rest of the patch, except that there
> is a lack of comments and communication of intent of the code. I can
> see what it does, but think of the point of view of a kernel consumer
> getting this code in the future and wanting to extend it or debug it,
> and the code being able to talk to "future you" who has no idea why the
> code was there or what it was trying to do.
>
Okay I will add comments where seems necessary.

Thanks,
Sundeep
> <snip>
