Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B030C3F6FB6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhHYGmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbhHYGmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:42:14 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1BFC061757;
        Tue, 24 Aug 2021 23:41:29 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id a10so17107373qka.12;
        Tue, 24 Aug 2021 23:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B78/Mqfs38V9eecPQ+aJTxWd5qTXY3a6sF60GgAjOg8=;
        b=aqKJQ1DXulcYX3IPCCBvAaj+pWV7jvYqaeZBUnskFjvApGYCUE+dvuyAbPojODnbFh
         KWckjDNyT0Ue/Y8VTH5Nhcwu9QxL5jC/BY3D7CmoxwOrVqKerU6+njhC5TsSJMvu70Gi
         oiTBq995iiEq7TU37uePjiIa43dm6vgSvNqhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B78/Mqfs38V9eecPQ+aJTxWd5qTXY3a6sF60GgAjOg8=;
        b=eVzvnNCYgpYWZ5mxT0T/HZdd9qgtOfQQQUEqRzSq/0B9yTmlLffn0zMpUu+6uqLFt4
         p3Sgybqqh24KdsAMUyHl1qhh+L2Gu0MrBnY9ECyeornJUIEYZD0Rn1jl3eKmQaZLnap7
         jM7zvgiFzRqNwlglGCflagDfyf0nFkEt4StbVMuFQ07Z6lD7oMza4wVBDiPs3gD/NoQS
         Q+rx0xvTAJwbaZKMODkrW/bhqZlRODBn+qRdThUUsT24TwMvng9haTFU6TwE4SzP8Xss
         +3366fVsnqJA8UXV3AgmwNM9LxVG16EwX1t3HPwgTVmgBcK3rs7ed/6Sep6HciF+bT+v
         qnMA==
X-Gm-Message-State: AOAM530NADhYyNGaB9xgZderRiNfqbUEQlE0ErCRPSe4fAMfoi8lskk5
        hSW+9BQehUyjhtr/Jctu3iz9CkVxPRgXMwdnDKQ=
X-Google-Smtp-Source: ABdhPJy6w+sX2r1+gBTOEU6feSNb7QbVbKGLvKnedYy7IUjLflE2duuHWGdOdWMMssLrev5sCRLxs6H3R7Wsr9qrEkY=
X-Received: by 2002:a37:a094:: with SMTP id j142mr30582706qke.465.1629873688720;
 Tue, 24 Aug 2021 23:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210820074726.2860425-3-joel@jms.id.au> <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
 <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
In-Reply-To: <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 25 Aug 2021 06:41:16 +0000
Message-ID: <CACPK8XdLp8Ue0vuGT8ALPDkoFCG-Pb4_fxvDk7kMpm-se_wECg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: Add driver for LiteX's LiteEth network interface
To:     "Gabriel L. Somlo" <gsomlo@gmail.com>,
        Florent Kermarrec <florent@enjoy-digital.fr>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Shah <dave@ds0.me>, Stafford Horne <shorne@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 at 06:35, Joel Stanley <joel@jms.id.au> wrote:
>
> On Tue, 24 Aug 2021 at 19:43, Gabriel L. Somlo <gsomlo@gmail.com> wrote:
> > > diff --git a/drivers/net/ethernet/litex/Makefile b/drivers/net/ethernet/litex/Makefile
> > > new file mode 100644
> > > index 000000000000..9343b73b8e49
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/litex/Makefile
> > > +int liteeth_setup_slots(struct liteeth *priv)
> > > +{
> > > +     struct device_node *np = priv->dev->of_node;
> > > +     int err, depth;
> > > +
> > > +     err = of_property_read_u32(np, "rx-fifo-depth", &depth);
> > > +     if (err) {
> > > +             dev_err(priv->dev, "unable to get rx-fifo-depth\n");
> > > +             return err;
> > > +     }
> > > +     if (depth < LITEETH_BUFFER_SIZE) {
> >
> > If I set depth to be *equal* to LITEETH_BUFFER_SIZE (2048) in DTS,
> > no traffic makes it out of my network interface (linux-on-litex-rocket
> > on an ecpix5 board, see github.com/litex-hub/linux-on-litex-rocket).
> >
> > May I suggest rejecting if (depth / LITEETH_BUFFER_SIZE < 2) instead?
> > When that's enforced, the interface actually works fine for me.
>
> Yes, I was using BUFFER_SIZE as the slot size, which it is not. I'll
> rework it to use the slot size I think.
>
> I spent some time digging through the migen source and I couldn't work
> out where the 1024 length comes from. If anything it should be
> eth_mtu, which is 1530.
>
> Florent, can you clear that up?

Replying to myself, the 0x800 is the slot size. I will fix the maths
so the number of slots is calculated correctly.
