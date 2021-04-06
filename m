Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182F235589C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346112AbhDFP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhDFP5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:57:25 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1310EC06174A;
        Tue,  6 Apr 2021 08:57:18 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id p8so9168704ilm.13;
        Tue, 06 Apr 2021 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FEHBLN0Zstx1GJN7oNvdBnFUfGg0YcWpGNgAuqNChPM=;
        b=ewEZauKlnvV70GX0on1+GRjS9gR/bGnmqPzBG+GSpy2uOxwLfOllm9KCl5/p7dFAZz
         nHE1PVAjQimYXKTfna3TXgFuubqMlL3UaczMGaC0r2bCDW0X7qg4nOxFzZQWrUtkB/YD
         BzgGmPkk1FdLZw8Lm4U/X/4ppblG8V4pG8bAO8hmaMKKJrxoLBEtm9W127DFBGtAU2UE
         t3oVu54JpKY9oq21Gcsu+T9VbuEM+KXkKbmTjDvs4o3q9lJnzsOVa9zbWtBpT67TMG3R
         2h/Iowp2LUCrtcdi5khnKDrSoXByGh5FqI6GimUrmfcfLjd+XhdyCMM4ZLElYNd3Vb9C
         CGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FEHBLN0Zstx1GJN7oNvdBnFUfGg0YcWpGNgAuqNChPM=;
        b=DPx6sZlEJ9b46Msw3hGsH+gzNREmsZ0Mv0ilTRNBTIG0ZaESBbSy904hllG4j+CyQ/
         1xer1EAPv/LjAJrIvObm2rrV7eQeqfB9enALA9dLKH2eipn1LVVfk9eLC0LR+BDTx/ll
         qbDUt/KDo25aoQamAM6saee6b/V7JrbgBEfjOgPImTW44mRwp6I0KzDNIi1g003BA0T+
         eTVc4rpvWECwn5C35eyyrZtwt1JtqwsOI5ntad7FWKrL4QVV58P6FKbexnTtQTMhznVy
         vIeI+2S5BBDsiVBqnxh3v5Ue39qnk1nJOBJxgh4h/uFEfo9nXSODefl6zWdnRCimdQif
         u7gA==
X-Gm-Message-State: AOAM533z6pJD34/W5ebck+2EaMu89m1rXXr5rDd8LSQ0rYG0Z7qdZu+R
        DvpIhuchwFXp/5rk6rKbVqUF65wn67iqbzLbNX1oZBv6SlZfXw==
X-Google-Smtp-Source: ABdhPJwcAo2Mlxz7UGgC2fTg8jHTyNrSATURmH+oza/tZhdRnPEtDe7seeMK4cOStjDtCgSO2NPZMkI6wNVpe9+DdWk=
X-Received: by 2002:a92:de0c:: with SMTP id x12mr2017100ilm.169.1617724637582;
 Tue, 06 Apr 2021 08:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-2-dqfext@gmail.com>
 <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
In-Reply-To: <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 6 Apr 2021 23:57:14 +0800
Message-ID: <CALW65jbbQSFbgjsMkKCyFWnbkLOenM_+2q6K7BQG5bc4-R0CpA@mail.gmail.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
To:     Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev, DTML <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 11:47 PM Chun-Kuang Hu <chunkuang.hu@kernel.org> wro=
te:
>
> Hi, Qingfang:
>
> DENG Qingfang <dqfext@gmail.com> =E6=96=BC 2021=E5=B9=B44=E6=9C=886=E6=97=
=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:19=E5=AF=AB=E9=81=93=EF=BC=9A
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
> >           Support for the Marvell 88X2222 Dual-port Multi-speed Etherne=
t
> >           Transceiver.
> >
> > +config MEDIATEK_PHY
>
> There are many Mediatek phy drivers in [1], so use a specific name.

So "MEDIATEK_MT7530_PHY" should be okay?

>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/drivers/phy/mediatek?h=3Dv5.12-rc6
>
> Regards,
> Chun-Kuang.
