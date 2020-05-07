Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6095F1C96FF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEGRBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgEGRBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:01:54 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BABC05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 10:01:54 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b1so1171784qtt.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 10:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AogGO7KQ2cbQNwYsj968bylJ7TQTugwVFwFQ369LPww=;
        b=B9521p8GGVcZpv1qM6GfYzouKvPp4grKwjYFaXKUDPG4zfEuTqq3geopKa9AL0tOb+
         5Mxtar2ygaAjvMyZDIRb0W9xvnacTchxTSMHI1tZPA2PbNDtQCUh8e9BQackKUrAvFvD
         K/r3KBj6JEFLxpFwhYYzgnUafXu+gr4v+lpgKsj9w51U75EBYUNEN5AEE+mpiXIoVLfX
         YUCLKWuxDU6umtMxIF3sS2wwRZWavK4GF7RBR78va/EV/Trd0n92xXmWZM15cG1YUCPE
         447hhPafKpmEgEnBqlAtJlVO7nr1VcdIbXbeVCxKhZwsqhFlAFqrzadqLRKUS34zqkYz
         Sbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AogGO7KQ2cbQNwYsj968bylJ7TQTugwVFwFQ369LPww=;
        b=XO/10z2iMrGE3OibRmndppRLBkBl4vg0BvGlZasjdZohuvWTNAjzzGYYMP4vJ6Quzl
         /c7EFlby5wy8xTS6abc851g90WIF3b3k6hZFzNBDTz37b+4avhrqO2xOEK1MTwDTgPlM
         quzC+3TZpsqS4o3VLi0vB9xwQ2NsBQ8PSTlWdCjUx4V7q5E8+VVrwCtCrq88o23tjO/Q
         FX2feztYiCxoOY2uqNWtiebkqWCMYAkhczGZPBrmUJyBcxArcX9vtZwVCMDM0ZhmHNxW
         CCqQk6D+PAqzLQhLzJR5t5eUDEq9ubIa5aNWykO0J2bzTW7sVXnO1Ggynza6/Gc7hmRQ
         XzsA==
X-Gm-Message-State: AGi0PuZVd1Vx0f0hlhtMMtGHeRpqWbrSLwgnqRO8Yw66FBSX4Gw/Bjjw
        p/Ecb4q74PMFGG/gq/KOL8o5YNKJItdobLZF7Jsbnw==
X-Google-Smtp-Source: APiQypIICB3A2kzpJhwMTKVrN3+4Xn62nAmH23vrPICDvrpFzW7p9tV7KhQx84nSLJLOK2UmDVQW8wd1hjqshOZqSn0=
X-Received: by 2002:ac8:568b:: with SMTP id h11mr15009985qta.197.1588870913354;
 Thu, 07 May 2020 10:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-7-brgl@bgdev.pl>
 <1588844771.5921.27.camel@mtksdccf07> <CAMpxmJW4qZ_Wnp_oRa=j=YnvTzVa3HZ13Hgwy71jS6L3Bd3oMQ@mail.gmail.com>
 <20200507131645.GM208718@lunn.ch>
In-Reply-To: <20200507131645.GM208718@lunn.ch>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 7 May 2020 19:01:42 +0200
Message-ID: <CAMpxmJV7xGhE4DoZAEYg=wjE-a1MEnc7carZ39zdvWtKAp+qfA@mail.gmail.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Mark-MC.Lee" <Mark-MC.Lee@mediatek.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, Arnd Bergmann <arnd@arndb.de>,
        netdev <netdev@vger.kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sean Wang <sean.wang@mediatek.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        arm-soc <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 7 maj 2020 o 15:16 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Thu, May 07, 2020 at 12:50:15PM +0200, Bartosz Golaszewski wrote:
> > czw., 7 maj 2020 o 11:46 Mark-MC.Lee <Mark-MC.Lee@mediatek.com> napisa=
=C5=82(a):
> > >
> > > Hi Bartosz:
> > >  I think the naming of this driver and its Kconfig option is too gene=
ric
> > > that will confuse with current mediatek SoCs eth driver architecture(=
for
> > > all mt7xxx SoCs).
> > >   Since mtk_eth_mac.c is not a common MAC part for all mediatek SoC b=
ut
> > > only a specific eth driver for mt85xx, it will be more reasonable to
> > > name it as mt85xx_eth.c and change NET_MEDIATEK_MAC to
> > > NET_MEDIATEK_MT85XX. How do you think?
> > >
> >
> > Hi Mark,
> >
> > I actually consulted this with MediaTek and the name is their idea.
> > Many drivers in drivers/net/ethernet have very vague names. I guess
> > this isn't a problem.
>
> They have vague names, but they tend to be not confusing.
>
> NET_MEDIATEK_MAC vs NET_MEDIATEK_SOC is confusing.
>
> I think the proposed name, mt85xx_eth.c and NET_MEDIATEK_MT85XX is
> good. Or some variant on this, mt8xxx?
>

I've just verified with MediaTek that this IP will be used in future
designs as well - even on ones that don't share the mt8* prefix. It
doesn't really have a name though by itself. How much confusion can it
cause anyway? People who want to compile this driver will know which
one to choose, right? It's not like it's an i2c component shared
across many board designs.

Bart
