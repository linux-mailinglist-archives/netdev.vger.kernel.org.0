Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26DE287CC5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgJHUC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbgJHUC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:02:56 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F6BC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 13:02:56 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o9so2472522ilo.0
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EpFqPi/WffB740uEvA80XvaKjJGc1YrmBO/U3WKT3uc=;
        b=qJH2yWmRIMLZQcn9zTNgJh5eiSHwX3BbFv3xg/VC2LkJSBZQ1143aYpFmQ7+QeLbOi
         zi/B/BCOlrvMOmZgKthveSTei381zf16XqXNYCrKQzYjKs5VIbj1fNKL/46N86K4gq5J
         dObEFswQGBXW0Rng47V5SV3uyvQ643wx9StcViAXx6pWQezaJai/mpVbf28S8WliflQ1
         1Vz06/NgL1rHViH+h65x4Dz3FeBUbKa3If+1dna5mwdQSDwNkBlnVA4C67gO3gDISDG0
         6AyfTZWXZyt5BFlV2+vy6hIIkvq4JqmNp7jHhYdX/e9qQRWq32ASZApXctxkTZBOJA0l
         0uUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EpFqPi/WffB740uEvA80XvaKjJGc1YrmBO/U3WKT3uc=;
        b=I1mjmRtCufA3cLgpp38a5h/WhVlCve09x84MdxnLs06zoOnyct+DuEh4QzyFA5FWs/
         lWi8n8vJh+JK4XYCFEpglOT2srXq3hBhfCORG7a8l6HAqvGOBd6pmiDUj4Bg0fnu9bpo
         TZA4DYWvtXFoVQP0Wsyb5KFD8BuSAV6DbFRCSUZ0nuPUiMJ+3DW8Sz/EUF4c6PNrtBk2
         tx/2ZyhzmLeJsIFynvDAWTNEr6XhKKvGKYuxpEAaXb86K/UFfKU+jA8oFaJWVhY81lP+
         jZTo4As92AwTjw20yPIbdyPja4ZzgBGdwaQ52+B9q3Lpdf3uT5rzofyy2/P0gXwfnJ5Z
         8bXw==
X-Gm-Message-State: AOAM531AIV0NAyt6OU063n/gN7wMKLfTI2jeRzuacFgJrxhoflgZBgRX
        ZinJgN+DjLFs45T5ywAhdN1UiBtG1CIyGoYWVjA=
X-Google-Smtp-Source: ABdhPJytNGdqx217iwP5BFdieo/eqCBD+SnhTcUIUS9CeOYOiwHBKII9DTj7XOaP0xxrnDZ54D2w52GchdK0xgizXpg=
X-Received: by 2002:a92:7751:: with SMTP id s78mr5401483ilc.144.1602187375550;
 Thu, 08 Oct 2020 13:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201008061821.24663-1-xiyou.wangcong@gmail.com> <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Oct 2020 13:02:44 -0700
Message-ID: <CAM_iQpUBzszbhg0jr9aXZFwTOM0XXRo4rFoFEXPoLRoUw_4doQ@mail.gmail.com>
Subject: Re: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 10:34 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  7 Oct 2020 23:18:21 -0700 Cong Wang wrote:
> > This fixes an uninit-value warning:
> > BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:650
> >
> > Reported-and-tested-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com
> > Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> > Cc: Robin van der Gracht <robin@protonic.nl>
> > Cc: Oleksij Rempel <linux@rempel-privat.de>
> > Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> > Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/can/j1939/transport.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> > index 0cec4152f979..88cf1062e1e9 100644
> > --- a/net/can/j1939/transport.c
> > +++ b/net/can/j1939/transport.c
> > @@ -580,6 +580,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
> >       skb->dev = priv->ndev;
> >       can_skb_reserve(skb);
> >       can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
> > +     can_skb_prv(skb)->skbcnt = 0;
> >       /* reserve CAN header */
> >       skb_reserve(skb, offsetof(struct can_frame, data));
>
> Thanks! Looks like there is another can_skb_reserve(skb) on line 1489,
> is that one fine?

I don't know, I only attempt to address the syzbot report. To me,
it at least does not harm to fix that one too. I am fine either way.

Thanks.
