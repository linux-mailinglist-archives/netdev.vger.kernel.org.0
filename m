Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A62C680554
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 06:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbjA3FCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 00:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjA3FCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 00:02:36 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5768AEFA1;
        Sun, 29 Jan 2023 21:02:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id kt14so28443549ejc.3;
        Sun, 29 Jan 2023 21:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ucvWXBNw5kZZoiktcuCaAE6zb+7r9nERTMtKuxTV85U=;
        b=FEtru0v7RaSXnV9O2jjVqHEyMoh3l2tOTGp1y1do9DYptfK2wWOHsxsHcOg3RaGmUC
         zsUCc3AYS58TiaXbZW6pJ1iMi5a4ra3gWBBrEQdzohDDZVFt13C9VBcMtmONJR3Cl25i
         RcY/Godi/dgwpV77F8OMdMT/1xml25ORFuVdf9ZrN3qWCW6uaCvaENMDbrA98/UsRs4X
         iXD4YcEkg4h0sebasXWMpB5iuP1+0uLueR8kvGRkRbv7CpFo+C2MWEnjkFI+eUK1Icbd
         8XKy+FelA6VcjNDXZJU8T5Ov5Ig1hHG/lghR23oxjt3n5/WvJhEuXkGYp1GpSUC56esV
         CyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucvWXBNw5kZZoiktcuCaAE6zb+7r9nERTMtKuxTV85U=;
        b=Lp2b7EUMmCAUr0WWcwCRApdVcKdwVZrRPsC7MchfHL7C4YH3P8oZ8ov2BAQhFF43ng
         YB9ROGsVGd5V1YVrhUzeg6W28BOW8zzoakNAUDFNRTu9Es/Dgyx9x3waXNuyXugQH3SM
         TQUjPvhrpGu5DSrGvr1qo3ZGoBl7M8snB7KcaKa06iMgsn+9bwyUZg35wWkF8ci07gzl
         1TC3tu8vB7HHkrgVuQKgP8d68y92m0yPlGbTXwL5QwBcPbug8o2x9utz/7ok2eZwYxTp
         g68MdLPTqwodriphovhvZHHHVCJ661TuKpY6/z1Us1CewpqghSqhlaDIJwPZIO3OGKIK
         vppQ==
X-Gm-Message-State: AO0yUKU7Hqzl0UYGHUD/RXknd0vqAr0Ru+YGGRf/FX0JZxMAppE7ig63
        5CPvEhAoUusRojGf66VHEgd0E5lvDygc/io0waU=
X-Google-Smtp-Source: AK7set/1bWOi0vgWnv7nXRS/B/6XwRAnvIb8kktwR+a43Jhs0iJD4i7oaqA8TbVkRLiHuwht+0TDBSTzypeQm5X+CNc=
X-Received: by 2002:a17:906:1304:b0:888:f761:87aa with SMTP id
 w4-20020a170906130400b00888f76187aamr474904ejb.163.1675054953659; Sun, 29 Jan
 2023 21:02:33 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <CAL+tcoAci+fwk6-JsTL7+yOiom08XSpc9Y5xbTZZ=WWRjYvnuw@mail.gmail.com> <CAL+tcoCeBtiOeemuhQsTK8pnNLjmRRK7ukXLsiPt3YkOrJbYYA@mail.gmail.com>
In-Reply-To: <CAL+tcoCeBtiOeemuhQsTK8pnNLjmRRK7ukXLsiPt3YkOrJbYYA@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 30 Jan 2023 13:01:57 +0800
Message-ID: <CAL+tcoCTH_yADMeQvpAV5FCgg+hEEW2NQNee7bHq92+NtN6oyg@mail.gmail.com>
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

On Fri, Jan 27, 2023 at 11:08 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Fri, Jan 27, 2023 at 10:54 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > My bad. It's not that right. Please ignore the v2 patch. I need some
> > time to do more studies and tests on this part.
> >
>
> In the meantime, any suggestions and help are appreciated :) I'm still
> working on it.
>

Dear maintainers,  after several tests I did during this time as much
as possible,  I couldn't find anything wrong though I am not that
familiar with the whole ixgbe code. I decided to 'reopen' this patch
v2. Please help me review the current patch.

Thanks,
Jason


>
> > Thanks,
> > Jason
> >
> > On Fri, Jan 27, 2023 at 8:20 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > I encountered one case where I cannot increase the MTU size directly
> > > from 1500 to 2000 with XDP enabled if the server is equipped with
> > > IXGBE card, which happened on thousands of servers in production
> > > environment.
> > >
> > > This patch follows the behavior of changing MTU as i40e/ice does.
> > >
> > > Referrences:
> > > commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
> > > commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")
> > >
> > > Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > ---
> > > v2:
> > > 1) change the commit message.
> > > 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> > > ---
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
> > >  1 file changed, 16 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > index ab8370c413f3..2c1b6eb60436 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
> > >                         ixgbe_free_rx_resources(adapter->rx_ring[i]);
> > >  }
> > >
> > > +/**
> > > + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > > + * @adapter - device handle, pointer to adapter
> > > + */
> > > +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> > > +{
> > > +       if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> > > +               return IXGBE_RXBUFFER_2K;
> > > +       else
> > > +               return IXGBE_RXBUFFER_3K;
> > > +}
> > > +
> > >  /**
> > >   * ixgbe_change_mtu - Change the Maximum Transfer Unit
> > >   * @netdev: network interface device structure
> > > @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
> > >  {
> > >         struct ixgbe_adapter *adapter = netdev_priv(netdev);
> > >
> > > -       if (adapter->xdp_prog) {
> > > +       if (ixgbe_enabled_xdp_adapter(adapter)) {
> > >                 int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
> > >                                      VLAN_HLEN;
> > > -               int i;
> > > -
> > > -               for (i = 0; i < adapter->num_rx_queues; i++) {
> > > -                       struct ixgbe_ring *ring = adapter->rx_ring[i];
> > >
> > > -                       if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> > > -                               e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > > -                               return -EINVAL;
> > > -                       }
> > > +               if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> > > +                       e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > > +                       return -EINVAL;
> > >                 }
> > >         }
> > >
> > > --
> > > 2.37.3
> > >
