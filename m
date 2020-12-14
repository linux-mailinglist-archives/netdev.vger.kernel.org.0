Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEFB2D9895
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407748AbgLNNLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgLNNLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:11:13 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A2BC0613CF
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:10:33 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id g25so8971885wmh.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aXkFoBl8i2692U5AWnbbA3iCvpPu6NAZkvKJJXIJLR8=;
        b=FTlMVLfLwYSUs372XB0Rw+FmrVgaPgFUbGLc3rCl1agp3KyIFqzcVpO9QTzJ0oMx6S
         ylxrw54h6lMd3JpJpcDmCIqHlgx1zXTgOc+Lk7WhCyNyKHPbgcaY9yCGx/DEYVt8mRed
         pmtAEd1XkOV3WMVRSHZxbNL5mNBhFbBEz0sCsLQ0doEkUyJUgZfgrLLAdp2OOoCr0yBn
         stGcOUR28gzuwdiPOjpBtNbgWouRUcXAmxsshzf1sugHK9ZNILpXughJ1unl8y6/Sl8k
         CELZMlFDjW3P09eN8bjGruQji6Ag3Z4cHDZTw7viuTKJuzkxVjzcZQ0WZs+AHuZ/BsRK
         yuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=aXkFoBl8i2692U5AWnbbA3iCvpPu6NAZkvKJJXIJLR8=;
        b=CicyzmEj0SGYBYOX20Eo21d43WVbx6orAYbAJG69rwR9Dsdb0owkgxkneH3sbBl5wC
         GUMvs73RwaU66IBu+MtKxZjDaNx5Mo+WwBp6OJy5IsTm+ME985koceGYbJuMs8kUrg8v
         m24ue7zl2ZYivAjRbfrEf/QHTnDG6RBRI1saSM3nuk9T017Hm5L8Cx5UduJIbq0ho9fq
         W/RXirI12W3hxBR+bxJ6fgo/voysq9mPPVQ+llvtHeDDF/BJAvY3bSjYrFcu2nw/c2lb
         akc6Vc8eobzBjnUT5C9cK07r34kzkAz03laMeEAm8/cANLOqwbyA3qkOfjXMdeL5TY15
         AJhw==
X-Gm-Message-State: AOAM532pwcatvCqSRH8+lp3IJnodbyL/vT77QnlPqOtJJfSfTNxwHDYx
        5rdm2kXN3v/t3sHPA30gf4M=
X-Google-Smtp-Source: ABdhPJxurzJcC8pRGEmu/4YeHQ4SLKnP+W6K0MLQbFrJjUQRIseKws84reELjD63DoxoS5KosiZoIQ==
X-Received: by 2002:a1c:6283:: with SMTP id w125mr27427356wmb.155.1607951431968;
        Mon, 14 Dec 2020 05:10:31 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id m8sm31059119wmc.27.2020.12.14.05.10.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 05:10:31 -0800 (PST)
Date:   Mon, 14 Dec 2020 13:10:28 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] sfc: backport XDP EV queue sharing from the
 out-of-tree driver
Message-ID: <20201214131028.f4fey3yhjugfcftr@gmail.com>
Mail-Followup-To: Ivan Babrou <ivan@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
 <20201213122305.kpg5tb6dppq3ow42@gmail.com>
 <CABWYdi1VWaOOhOx6wOAd0DjSXMGaPvL_x6d=M0jtX15naecBWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi1VWaOOhOx6wOAd0DjSXMGaPvL_x6d=M0jtX15naecBWA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 10:44:56AM -0800, Ivan Babrou wrote:
> On Sun, Dec 13, 2020 at 4:23 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Thu, Dec 10, 2020 at 04:18:53PM -0800, Ivan Babrou wrote:
> > > Queue sharing behaviour already exists in the out-of-tree sfc driver,
> > > available under xdp_alloc_tx_resources module parameter.
> >
> > This comment is not relevant for in-tree patches. I'd also like to
> > make clear that we never intend to upstream any module parameters.
> 
> Would the following commit message be acceptable?
> 
> sfc: reduce the number of requested xdp ev queues
> 
> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)

Yes, that looks fine to me.

> > > This avoids the following issue on machines with many cpus:
> > >
> > > Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> > >
> > > Which in turn triggers EINVAL on XDP processing:
> > >
> > > sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> >
> > The code changes themselves are good.
> > The real limit that is hit here is with the number of MSI-X interrupts.
> > Reducing the number of event queues needed also reduces the number of
> > interrupts required, so this is a good thing.
> > Another way to get around this issue is to increase the number of
> > MSI-X interrupts allowed bu the NIC using the sfboot tool.
> 
> I've tried that, but on 5.10-rc7 with the in-tree driver both ethtool -l
> and sfboot are unable to work for some reason with sfc adapter.
> 
> The docs about the setting itself says you need to contact support
> to figure out the right values to use to make sure it works properly.

Indeed, our support may be better placed to help with this.

> What is your overall verdict on the patch? Should it be in the kernel
> or should users change msix-limit configuration? The configuration
> change requires breaking pcie lockdown measures as well, which is
> why I'd prefer for things to work out of the box.

The patch itself is good, as it saves on resources.

Thanks,
Martin

> Thanks!
> 
> >
> > Best regards,
> > Martin
> >
> > > Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> > > ---
> > >  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/sfc/efx_channels.c
> > > b/drivers/net/ethernet/sfc/efx_channels.c
> > > index a4a626e9cd9a..1bfeee283ea9 100644
> > > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > > @@ -17,6 +17,7 @@
> > >  #include "rx_common.h"
> > >  #include "nic.h"
> > >  #include "sriov.h"
> > > +#include "workarounds.h"
> > >
> > >  /* This is the first interrupt mode to try out of:
> > >   * 0 => MSI-X
> > > @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> > >  {
> > >   unsigned int n_channels = parallelism;
> > >   int vec_count;
> > > + int tx_per_ev;
> > >   int n_xdp_tx;
> > >   int n_xdp_ev;
> > >
> > > @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
> > >   * multiple tx queues, assuming tx and ev queues are both
> > >   * maximum size.
> > >   */
> > > -
> > > + tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
> > >   n_xdp_tx = num_possible_cpus();
> > > - n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> > > + n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
> > >
> > >   vec_count = pci_msix_vec_count(efx->pci_dev);
> > >   if (vec_count < 0)
> > > --
> > > 2.29.2
> >
> > --
> > Martin Habets <habetsm.xilinx@gmail.com>

-- 
Martin Habets <habetsm.xilinx@gmail.com>
