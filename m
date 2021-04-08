Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7783587AF
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhDHPAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhDHPAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 11:00:34 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E837C061760;
        Thu,  8 Apr 2021 08:00:21 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g8so4510889lfv.12;
        Thu, 08 Apr 2021 08:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FjPNKJFXnPLlIkn9ofe/hgNOiX4jHuRRHt6hgl/CzlA=;
        b=XbZQ46kuRoE8CvvYGZdRG7dg/QOplHjo7etUJYk4YVHrjZT3NA85gaoysHXoEEMscI
         5eIzjIauhjJHRn+s2BeO6XCW/EP6IrCLfCsVbyDyrXM3rg0uFrSBSAYOLHTlOhNwux0B
         5eVE73WtGFAuKNOUnbvg+u0JYoB+0Ah4UenNLHTLYmBzLjXeaOAQoLGOeGQQ422RsPfi
         Hcvu7QB8tkyboyurVK1mjBv9DEqucCDuu3igcXiJ5GZTW3T3cGJBdDcU5FUP7f+mphm0
         ZmsLpKKnyHiHsSH38Cud7G2mu5HWtCsI3f0l5qzwjUrfneucL4Bg2uatzY8F+tp45Sp0
         aX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FjPNKJFXnPLlIkn9ofe/hgNOiX4jHuRRHt6hgl/CzlA=;
        b=MAL/oW8NWWo108A9x3GJWpL+e4mbbNvnLwHUs+wRL4UFTNogMlEALiJdT9V5PgIqXB
         DJlZNeSyQbvtWTx+zmophv28RzWpOWS4FMS6O4YgM4aGeXHh3SJJZM90UOCHtTA63PXm
         JSsvh7htJIHVT+Iowguu9cvyV0OaNkdCOSg/gBRZcQCxoZap7ijD0nXdUyS6sfIPI9/g
         9exnBY2vB6Dr3YpBLxZc3mp62WMgnVIgTRItbuAr0gwQ4ke8MZn0uoz1i+EW1mLQzYpW
         nzEwQ/angVyEJ0yH2I+T23/mpqxj1LFYo3v90ToJF1amGpH1XGsi7a6kOemPiEZ5F6PW
         XUzQ==
X-Gm-Message-State: AOAM532MtSo3NMqaJwAlwb6oslJwvm8rbc88IR9cBoTvp034GGmIUGlZ
        ambn0NmuUBXVbjNOQFZRHHCEObESieFq74wQXjY=
X-Google-Smtp-Source: ABdhPJzjEAtp7tSnx5kIvHtgEJeseYxS+FKQnHvpnDHWEm/cOFqXyqTMKAR3dgjC0R3Fe6+Hrb+V8yEVk7P8pi+tQOc=
X-Received: by 2002:a05:6512:2295:: with SMTP id f21mr2490389lfu.166.1617894019468;
 Thu, 08 Apr 2021 08:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210408123919.2528516-1-dqfext@gmail.com> <20210408140255.Horde.Pl-DXtrqmiH9imsWjDqblfM@www.vdorst.com>
In-Reply-To: <20210408140255.Horde.Pl-DXtrqmiH9imsWjDqblfM@www.vdorst.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 8 Apr 2021 23:00:08 +0800
Message-ID: <CALW65jZujSCk16RX_xgcg+NGrc9yyFQOQ9Y-z3qz-Qv1TvUQLg@mail.gmail.com>
Subject: Re: [RFC v3 net-next 0/4] MT7530 interrupt support
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
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
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ren=C3=A9,

On Thu, Apr 8, 2021 at 10:02 PM Ren=C3=A9 van Dorst <opensource@vdorst.com>=
 wrote:
>
> Tested on Ubiquiti ER-X-SFP (MT7621) with 1 external phy which uses irq=
=3DPOLL.
>

I wonder if the external PHY's IRQ can be registered in the devicetree.
Change MT7530_NUM_PHYS to 6, and add the following to ER-X-SFP dts PHY node=
:

interrupt-parent =3D <&switch0>;
interrupts =3D <5>;
