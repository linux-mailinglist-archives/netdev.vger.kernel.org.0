Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4D67E8F4
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbjA0PJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjA0PJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:09:02 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1A7D6DE;
        Fri, 27 Jan 2023 07:09:01 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id v6so14520283ejg.6;
        Fri, 27 Jan 2023 07:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jNKwj7IWvpGptrusc3pRYBqANEuNHkuWJThhB95Vjd0=;
        b=VPlHIX+oQFTlSAfg8sGI/IFRDGfdsXLhnB+qYCVgk9lwivtCq34o9iAbAEc07qx/iC
         eSKSKaZjii8L/9wfp4uwfPOSlX795T2VObR8/Zo9LCH9xCuesqUM7phjiGMiFtedfiiw
         IDkvPA2/E1T0KFvmFS20QjNHtuhWFGGuzd1n9jI2goY3RYm4tbGFAJKn9GNhQ8VnkGag
         GFF3IxnfGq+vlPd6bLABfHQaMuOYe1n+C3EZivBLUndmOtcsPvIXzwnPf4NNv9HPbN4n
         zADxO/uMqzPU+A6YwvNA9avKuVWzubLBwfI6owNb1mF/+E+DNMtdFtbk9R6Nbwfdg8kW
         2faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNKwj7IWvpGptrusc3pRYBqANEuNHkuWJThhB95Vjd0=;
        b=LjcwvgZsjxTr1A7zjO6c+dj+tePkwQJmROtra92edkGDedf3gpEth21SkRWGzb13EL
         tl9sVZmsoRKbuc5EMrr1nGRCfLqqrlkeoh12QhnA09OFMmtEzLt6N+EUL3Gv43da6vN6
         sv/gIIrqRFuCGsb9jcj0oX2vDlUXJPT7+m/tvR/4sOGLOOIYktahIR6eEL7UvEGT5nU6
         yBLocXZLO5UgDWV5J8PEp8ep3xGMYjZvOYReMPyIeqtEaebdBrzHyLfk7yC5s+lFP5K/
         7GOgaDnD97jFQCyEB0n/GNtt69GZ78xHh//7enTBpPXGVthnqRjkOlzXJ4RpMTueZTuT
         RNIw==
X-Gm-Message-State: AFqh2kqc4xcRUc4cv0xD0CGwCDLqOeV4KFaVnhhGoYiukxBraw06J4Rq
        JuCAr1MI4iVLcXXuDKKMiIBJ7fYPngqVzQcQKyU=
X-Google-Smtp-Source: AMrXdXtnnNEUb/io4XFLuc+yD4vzvIFncclei5EjO4eJeKmGkP/e9zXAQjWyqHu1VdJGeSy0pNSS8m2s9HBklp71dkY=
X-Received: by 2002:a17:906:4a8f:b0:86c:e07a:3ce2 with SMTP id
 x15-20020a1709064a8f00b0086ce07a3ce2mr5568180eju.58.1674832139953; Fri, 27
 Jan 2023 07:08:59 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com> <CAL+tcoAci+fwk6-JsTL7+yOiom08XSpc9Y5xbTZZ=WWRjYvnuw@mail.gmail.com>
In-Reply-To: <CAL+tcoAci+fwk6-JsTL7+yOiom08XSpc9Y5xbTZZ=WWRjYvnuw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 27 Jan 2023 23:08:23 +0800
Message-ID: <CAL+tcoCeBtiOeemuhQsTK8pnNLjmRRK7ukXLsiPt3YkOrJbYYA@mail.gmail.com>
Subject: Re: [PATCH v2 net] ixgbe: allow to increase MTU to some extent with
 XDP enabled
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 10:54 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> My bad. It's not that right. Please ignore the v2 patch. I need some
> time to do more studies and tests on this part.
>

In the meantime, any suggestions and help are appreciated :) I'm still
working on it.


> Thanks,
> Jason
>
> On Fri, Jan 27, 2023 at 8:20 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > I encountered one case where I cannot increase the MTU size directly
> > from 1500 to 2000 with XDP enabled if the server is equipped with
> > IXGBE card, which happened on thousands of servers in production
> > environment.
> >
> > This patch follows the behavior of changing MTU as i40e/ice does.
> >
> > Referrences:
> > commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
> > commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")
> >
> > Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > v2:
> > 1) change the commit message.
> > 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index ab8370c413f3..2c1b6eb60436 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
> >                         ixgbe_free_rx_resources(adapter->rx_ring[i]);
> >  }
> >
> > +/**
> > + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > + * @adapter - device handle, pointer to adapter
> > + */
> > +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> > +{
> > +       if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> > +               return IXGBE_RXBUFFER_2K;
> > +       else
> > +               return IXGBE_RXBUFFER_3K;
> > +}
> > +
> >  /**
> >   * ixgbe_change_mtu - Change the Maximum Transfer Unit
> >   * @netdev: network interface device structure
> > @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
> >  {
> >         struct ixgbe_adapter *adapter = netdev_priv(netdev);
> >
> > -       if (adapter->xdp_prog) {
> > +       if (ixgbe_enabled_xdp_adapter(adapter)) {
> >                 int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
> >                                      VLAN_HLEN;
> > -               int i;
> > -
> > -               for (i = 0; i < adapter->num_rx_queues; i++) {
> > -                       struct ixgbe_ring *ring = adapter->rx_ring[i];
> >
> > -                       if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> > -                               e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > -                               return -EINVAL;
> > -                       }
> > +               if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> > +                       e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > +                       return -EINVAL;
> >                 }
> >         }
> >
> > --
> > 2.37.3
> >
