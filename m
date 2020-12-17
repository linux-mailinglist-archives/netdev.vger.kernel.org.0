Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82DA2DD29F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgLQOLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLQOLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 09:11:03 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF951C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 06:10:22 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r5so28738320eda.12
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 06:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IR4DWHBzJnKe6b+a6dEE4Wgp8wJ0QLFCwGYNaFUnjKA=;
        b=tjCezsmsGTqgvsvRQobA4Px9UIkotKHjP66T85jKpzzTRV7yVhLrffrqv/AaLhTR4b
         wWq3WWdq/T33aWnM0gSZbdFcGworK7X37xjIdtlEkiWBxLMjKKz27m9+adt8a6oASM+L
         tAEVyrdl7eSgE+6kNlTPoDoIfSx8SDc9KIqTeHiaVgimJgMKwYK42fJdn55LCGxdAjci
         /U9PeTGzbQKaH+0Fio724u82dlDo3C/u0PmkwAXAYW5RrPepJbyplZwfxROc5diu4cvH
         U1Ut4QD2LYrHHLoReAJZhdp+OAXQ0m2mlc89ZBImNBCdn2IXqJh3zSFM5rHxt9xCUtys
         umRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IR4DWHBzJnKe6b+a6dEE4Wgp8wJ0QLFCwGYNaFUnjKA=;
        b=LzGy1KDQVeMoGIhnpEX1G1zed0NsHIV/m3CD0EtDt2J7GR5MPUk7wgECE99xSN13Ap
         IDgJ91sHdHHlWOnDrvu2uP7LQHSh1wHPLU/IRnNJhe+CG94jRvOZQMp5MKdFawpwbM0T
         HalJwE3QX83b+eTYIHNBnzVmRKoMWB4mdqdnY53Gt08GNu5LDD9KpMiY3UF2ds8k4LEc
         Zp9PvCyhhUH9Y3nkLJaKRPHFFFCO/n2aRYYjcGVDuF+l0e1WKceCQ1tJvSu70/i4NYRW
         gefk1CNQSL5pVjW6XRQf7Vue7j8+QalUhR4hQ6MbC4vAZI8LZU2E1esuu7VXXpO/XC2t
         jMcQ==
X-Gm-Message-State: AOAM533UcVqBoCwwqDTynFEefWGw/7tKsHB85+0XsNPOHS5fXeToRHDJ
        RaCoS1LS0uSHRd+Q6rXB/H999MM8kQGFRWxiRA1fWA==
X-Google-Smtp-Source: ABdhPJwPyvhzeRiyL+qQ0xtNzIXXH9bQmYJAKTjMda2qieOz3hlg55v1Skxw7aNJXtlDnLTkVzcbpCrL2SkMxPIgsK0=
X-Received: by 2002:a50:f307:: with SMTP id p7mr38822681edm.368.1608214220785;
 Thu, 17 Dec 2020 06:10:20 -0800 (PST)
MIME-Version: 1.0
References: <1607962344-26325-1-git-send-email-loic.poulain@linaro.org> <20201216112056.4224a4a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216112056.4224a4a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 17 Dec 2020 15:16:57 +0100
Message-ID: <CAMZdPi_Gsk=-g58ng77t8xDic=w_coedBpHF9Fc1W=9=Qbi_Xg@mail.gmail.com>
Subject: Re: [PATCH] net: mhi: Add raw IP mode support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 at 20:20, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Dec 2020 17:12:24 +0100 Loic Poulain wrote:
> > MHI net is protocol agnostic, the payload protocol depends on the modem
> > configuration, which can be either RMNET (IP muxing and aggregation) or
> > raw IP. This patch adds support for incomming IPv4/IPv6 packets, that
> > was previously unconditionnaly reported as RMNET packets.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  drivers/net/mhi_net.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> > index 5af6247..a1fb2b8 100644
> > --- a/drivers/net/mhi_net.c
> > +++ b/drivers/net/mhi_net.c
> > @@ -260,7 +260,18 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> >               u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
> >               u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> >
> > -             skb->protocol = htons(ETH_P_MAP);
> > +             switch (skb->data[0] & 0xf0) {
> > +             case 0x40:
> > +                     skb->protocol = htons(ETH_P_IP);
> > +                     break;
> > +             case 0x60:
> > +                     skb->protocol = htons(ETH_P_IPV6);
> > +                     break;
> > +             default:
> > +                     skb->protocol = htons(ETH_P_MAP);
> > +                     break;
> > +             }
>
> This doesn't apply, there is a skb_put() right here in the networking
> tree :S Are we missing some other fix?

Yes, my bad, going to rebase that.

Regards,
Loic
