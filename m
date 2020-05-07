Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8E1C8745
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEGKuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgEGKu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:50:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B55AC061A10
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 03:50:27 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s9so5437511qkm.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 03:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1TQDLXk4eka+0Oxp2Bn8b1wcydmS2119xNQQ8v9Of3A=;
        b=1lm1uYG4FqWg47V6Y+gYDIshBO9zX4KSYru04NwBJPv6kFFVFfM5JuAxDs6tZvphbJ
         oTJilxGIAeSQOYU0i6u9kVh9LY2c67xWbyrpnSBiPqECpZSiW2moygN7fZbQTfav8QK2
         PVhyXc4CtEJIGCrd0bzJhiTefp0mzyZ+EbOyJMUDZqyQufbiHgLItmYN1hQD9wMB44pb
         +U7sR5l34T2+ELpQdAtOqjowgdxN4GWWNkcVU6+j6hZhi4t6FdtitjmBcfH4EYiq0eXp
         4P1xej1eG3C2yyeUwdIE9QTRIDhAZrZ/5hXNsRThBODI7DVg3bGoIKHJESig7V88bGr5
         VM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1TQDLXk4eka+0Oxp2Bn8b1wcydmS2119xNQQ8v9Of3A=;
        b=L5Bhg+MPeEe/blxMyqgD6jx6N28PGa+0t5spDmhZReK5BmMlRrEP9KnVrAyyanEKfV
         yxrgLCvx3OyxhMNPxiGGCgZFnrG/vUr8iI+8bHvfiU1XQ5HPNwJ9JDD3tZU4yir/qo+z
         bkH0BCewo+JBsmIWQt902P4n0X2zy+/lzZGUqufoCFK+wSJGbxDyivVmRQhk5H+3CvJT
         TB1Mpd/w1vVNLsHPiVTDSbQZ6peUBn31TeQy/vkdhKPCviUjfDakDxManlMogyTp36IG
         iBt9jd2yUHXq1ySyT4fb5+Cl+ufV9ppcaBBm2kdeRk7lV+Mb/UTPq0dAl1+9pk1vOf0m
         9Xeg==
X-Gm-Message-State: AGi0PuYXaWcFdsKRvhjAJJd69shu6SmvsIevNzCd9LwKoLXFluBVEVYF
        gDDe2BrXQ67TdI5s4ef3151vxoTdOBXSg7WYNEX5Vg==
X-Google-Smtp-Source: APiQypJYXCCd2c3pYbt+kfphPDDGvjl+YT7aIrmnou1JUBqsathcHJRlRjCQ8fMwJjvYV4gCZxU1KJCPXjpaGZcnQi0=
X-Received: by 2002:a05:620a:1f1:: with SMTP id x17mr13989074qkn.330.1588848626441;
 Thu, 07 May 2020 03:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-7-brgl@bgdev.pl>
 <1588844771.5921.27.camel@mtksdccf07>
In-Reply-To: <1588844771.5921.27.camel@mtksdccf07>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 7 May 2020 12:50:15 +0200
Message-ID: <CAMpxmJW4qZ_Wnp_oRa=j=YnvTzVa3HZ13Hgwy71jS6L3Bd3oMQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
To:     "Mark-MC.Lee" <Mark-MC.Lee@mediatek.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 7 maj 2020 o 11:46 Mark-MC.Lee <Mark-MC.Lee@mediatek.com> napisa=C5=
=82(a):
>
> Hi Bartosz:
>  I think the naming of this driver and its Kconfig option is too generic
> that will confuse with current mediatek SoCs eth driver architecture(for
> all mt7xxx SoCs).
>   Since mtk_eth_mac.c is not a common MAC part for all mediatek SoC but
> only a specific eth driver for mt85xx, it will be more reasonable to
> name it as mt85xx_eth.c and change NET_MEDIATEK_MAC to
> NET_MEDIATEK_MT85XX. How do you think?
>

Hi Mark,

I actually consulted this with MediaTek and the name is their idea.
Many drivers in drivers/net/ethernet have very vague names. I guess
this isn't a problem.

Bart
