Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED75376187
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhEGH4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhEGH4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:56:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6509C061574;
        Fri,  7 May 2021 00:55:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x20so11545127lfu.6;
        Fri, 07 May 2021 00:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d1FrNuovi6qchn9VoSrH/ZZcEV9n4ZW2UXgmvYmjE+g=;
        b=u/fBwS9p8+ZJ1uzUyj9xWfncK+l0n+O3W0A4tJwhN9+RVhbt/VxvDgu1xrwj2TQchS
         T/WPQv24Xe7/GAMWEocVZZ+VeKuAueYMPejrAQ4dHHkQAaQ0f9lWCavmcbn4ZeuMHtyd
         G0q3a5q2xnS7zV2HZgTnSwnhjlmYBHQujJe9LsIZ5vndhGoSOKiL7mXJZ78Qr6SDkgkk
         I2yUR6lRzrz7o/PcVSpNT+6WPcHUdg3M6VcLyoKjuCE8zy3empFn+fAyPxxgJbGbFFzG
         gedCmZnjFIIrU9ayPlv9omPusy40prB3L31vMgUr0/mQKWtGrPNBiYiQJ67pkAMJZj0h
         Oj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1FrNuovi6qchn9VoSrH/ZZcEV9n4ZW2UXgmvYmjE+g=;
        b=S4jjChb7VfoOXGWuSGGLjN0ctrXjdmQsi2c3RpxgOJ9DnpFSGdR5csKQIWnt7HHacm
         j53FQJy7qwDcrSbQQGArPEtsLT2tXBZsuY77UcwTR0lXkkUaD2HJsvouzCzPuNMlUDRH
         M2POHPHdhlrTJJbq/sR69YCCj0NGdkRc0iW9jnOZKTEHFjwFaan0RmJO+uKxfqwrerhc
         p+75yGl7vqt71cH/B7B9Tjd6/t7+zihcBwkaI2VqIBLESkZHR72tAypzSyhZ2Oer4uKR
         atv+zqOAW99oYHJFwiLv4IwUYHa2tiB0nii/5rnSTVdqUSiPFDY/5vY3lLzX3lMa5t24
         83sQ==
X-Gm-Message-State: AOAM531OqDFSmh5KvB81OKTcewmtrGJLjalhqx+pIwhka0jUTtBKepXn
        5EUl6qh9AGrR8XHnRKj/9q8CBncOzlB1Qjh63M0=
X-Google-Smtp-Source: ABdhPJxmOfmHUfXXyaTbU88iBMHRGJL5QKoxgPRItgy6u662XlJ1CgzE8LYRu4JF7W41BVjOUogeB1Zoj1BFMzNjYeM=
X-Received: by 2002:a05:6512:3f27:: with SMTP id y39mr5490221lfa.166.1620374142511;
 Fri, 07 May 2021 00:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210429062130.29403-1-dqfext@gmail.com> <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
 <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
 <YIv7w8Wy81fmU5A+@lunn.ch> <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
 <YIwCliT5NZT713WD@lunn.ch> <trinity-c45bbeec-5b7c-43a2-8e86-7cb22ad61558-1619794787680@3c-app-gmx-bap03>
 <YIwxpYD1jnFMPQz+@lunn.ch> <fc962daf8b7babc22b043b2b0878a206780b55f3.camel@mediatek.com>
 <CALW65ja5mRPoNM2EZsONMh8Kda5OgQg79R=Xp71CaQcp4cprnQ@mail.gmail.com> <f3f5167f60b7897b952f5fff7bcaef976c3c6531.camel@mediatek.com>
In-Reply-To: <f3f5167f60b7897b952f5fff7bcaef976c3c6531.camel@mediatek.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 7 May 2021 15:55:31 +0800
Message-ID: <CALW65jaPO52vX02KGqEooE2LRUMNMgFoHYMfyXUtOa7SPS-jqg@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
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
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 8:54 PM Landen Chao <landen.chao@mediatek.com> wrote:
> MT7620's FE PHY HW is different from MT753x's GE PHY. Vendor registers
> of these two PHY are totally different.

Okay. So if the FE PHY is added later, it can be named mediatek-fe.c.
