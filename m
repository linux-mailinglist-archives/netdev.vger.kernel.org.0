Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D820309188
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 03:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhA3CbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 21:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhA3CWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 21:22:01 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351CFC0613ED
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:12:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g12so15656188ejf.8
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 18:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fL3Y1yRxa3KxBTnLvLwYPIR5U7Jn1pCiIMHmpT/r6/c=;
        b=lH9ywQXkfLXOwhDQx3AxipoCFzPAVVJgpXTfV7ocdDzXcghtN5e/Zm02EIbltOUgLa
         xJw68RJE2vqRUX3teMA13I78v/PdTBDfhDr5fqxjCQLl9Fi2WhLS7qagBsnR1kR/r1iy
         Tu0HbaJVaCKp6FVNelfY/s4XrHr5N5y4nAFBb6js7Hy5o2w9l2efK/CTv9xi0maso8GJ
         Ihe0xyF6s9vTz152SR6g5YS3cF/nAj46PMWFI3RpnCy90JTEmbRHDg2/CadcWXXlgzSm
         tWPl3FMFSplTFf+n70kUO9zWz0bMSpzAkmc5fEfF63NmmfnLFLoWfil0lI8EHhZik8eH
         fJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fL3Y1yRxa3KxBTnLvLwYPIR5U7Jn1pCiIMHmpT/r6/c=;
        b=W6bH8/w/RLBWAgFLpy5Gfw8EozxKoMLHVKxQs0oZCJ7Ob5CSpXKDXxQKh6s6jC1PGZ
         8Sw9Ad2eiD3Zt3/xq6Xk3qkcOVkSSo9Wa1K/00drgGcAYkhrUpqMBbD0EdWkDtzFbBHH
         8vLnPPM2O/pFWbSXSBKcjbM8yXKyGO4bQ61EGvM7avpmYm/r5OuF+4/UigxSsb5aw8hl
         UNHEPrDYxfOBlLCToy5/I/BYEJTh5MnKjEJp9w4Nmthpk4rwJadz1XI+I5N/MdvxhDYf
         MJvpM+B7krR38ylJ0F/bi/4aYGssTjo/8LeyOT0Z+iSyZW/74wALm1wG9CDR9bZN7sFS
         +9CA==
X-Gm-Message-State: AOAM532NCrAqRso708AeBZnvSozBNc8ngQA+ja4yllYu0RvTgePzE/ET
        RwzSZV0ZE9LAj6BNjR2qUj+izrI82zClV3NgS5M=
X-Google-Smtp-Source: ABdhPJwrx0bXnoGaxjgA0myLvIgWqsPE8+EfHOEMOYmpoksqtM5u8io9ZeBfATca+Qa3SqzZBzGcZc5GKanX+/g7Q6w=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr6943603ejk.538.1611972760408;
 Fri, 29 Jan 2021 18:12:40 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org> <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 21:12:03 -0500
Message-ID: <CAF=yD-Lc2YPxqEccXyBjXr1_WrSZ=30KSgHg1gk3PnxmURrZRQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 8:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> > When device side MTU is larger than host side MRU, the packets
> > (typically rmnet packets) are split over multiple MHI transfers.
> > In that case, fragments must be re-aggregated to recover the packet
> > before forwarding to upper layer.
> >
> > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > each of its fragments, except the final one. Such transfer was
> > previoulsy considered as error and fragments were simply dropped.
> >
> > This patch implements the aggregation mechanism allowing to recover
> > the initial packet. It also prints a warning (once) since this behavior
> > usually comes from a misconfiguration of the device (modem).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>
> > +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> > +                                       struct sk_buff *skb1,
> > +                                       struct sk_buff *skb2)
> > +{
> > +     struct sk_buff *new_skb;
> > +
> > +     /* This is the first fragment */
> > +     if (!skb1)
> > +             return skb2;
> > +
> > +     /* Expand packet */
> > +     new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> > +     dev_kfree_skb_any(skb1);
> > +     if (!new_skb)
> > +             return skb2;
>
> I don't get it, if you failed to grow the skb you'll return the next
> fragment to the caller? So the frame just lost all of its data up to
> where skb2 started? The entire fragment "train" should probably be
> dropped at this point.
>
> I think you can just hang the skbs off skb_shinfo(p)->frag_list.
>
> Willem - is it legal to feed frag_listed skbs into netif_rx()?

As far as I know. udp gro will generate frag_list packets through
dev_gro_receive. That and netif_rx share most downstream code. I don't
think anything between netif_rx and __netif_receive_skb_core cares
about the skb contents.
