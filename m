Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEBC373803
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhEEJos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhEEJoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:44:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7304CC06134B;
        Wed,  5 May 2021 02:43:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c11so1650536lfi.9;
        Wed, 05 May 2021 02:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6c3Xgmn5T37TIiY6YlqNonCt6qbYnwH+SLVXsWNUIl0=;
        b=tlTyUi3kNACJZhVQLNA0q8gUswN+/IMa21mbaLzlaLXmWzl7Wu/8y3gc7AI4RJ7gp5
         hkz1WvvJr4s16xg4aIGzXIiaFq++4fidadR9bsQtZVGviOdXVS5+sCckZ/S8tZB7OF7i
         mN+OyC3oW7V0DgYb7z4XiON9PrXOB6FqDvFbeZVyOpSGqydB78TCyIk1nYnrCmMy4YCr
         Tpu3gWJsG36gx1d3SQi6bArBRjmJQBi16tJQ0dBTJOjxi+dR/7zn/s30V9BovD0g2HbN
         13nAhm0Wmx65jEDp0PeKMWOU+RWpsh834jaNzxv91k/ORKN5U0m/BcIlQfSqyPOYO4FQ
         kg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6c3Xgmn5T37TIiY6YlqNonCt6qbYnwH+SLVXsWNUIl0=;
        b=YMsSbxF1ZkQ5xOzW3drQVlIe/3h3hgIJVhZf/MJBO7qLNrkcmyEmeZE4+y2gxT6zYE
         srBJJQj0ihS8Z+0CGdsepHNA736HXcr1USUFW/AdrLEudP3Vk8v37dOCs1IfIZZmJ49G
         4r++auyT1fuOKEZ1RlrSwJMSeOlzb7tTYNPlqL1attiutebNqVXqDU3dXPh/Ul4hL1aS
         dlJg8blhlPm0pm+w2Plguq1DAayL1LTlO3k0zfUk7ESWmtwWqEFuhD3OT3RI//C2XoX4
         44PTkI30HvbAXg4k0him2J+evoLBhZWfqCFtC4DV2Q3wXgVJ6g8xy11YSqzWqx1xAJuD
         Z/Aw==
X-Gm-Message-State: AOAM531yy/gtNYc1TlPqKjPRP+nc4m6+f/jKH+cZhg99eDRIuAKa2Keg
        q4OTYKMHnzxjFBgeDrebIqxzxUj5nRf979Z3ZiQ=
X-Google-Smtp-Source: ABdhPJw6OWZKpcheUIXN4U6xqnJjupiMHWXCfxCTfUuc3HFjNvUcQ9YcgrDewl5kohtJyeEZNwEigc4i9Z3u2NQfWlY=
X-Received: by 2002:ac2:44b1:: with SMTP id c17mr1737771lfm.527.1620207812971;
 Wed, 05 May 2021 02:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210429062130.29403-1-dqfext@gmail.com> <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
 <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
 <YIv7w8Wy81fmU5A+@lunn.ch> <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
 <YIwCliT5NZT713WD@lunn.ch> <trinity-c45bbeec-5b7c-43a2-8e86-7cb22ad61558-1619794787680@3c-app-gmx-bap03>
 <YIwxpYD1jnFMPQz+@lunn.ch> <fc962daf8b7babc22b043b2b0878a206780b55f3.camel@mediatek.com>
In-Reply-To: <fc962daf8b7babc22b043b2b0878a206780b55f3.camel@mediatek.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 5 May 2021 17:43:21 +0800
Message-ID: <CALW65ja5mRPoNM2EZsONMh8Kda5OgQg79R=Xp71CaQcp4cprnQ@mail.gmail.com>
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

On Wed, May 5, 2021 at 5:31 PM Landen Chao <landen.chao@mediatek.com> wrote:
> How about using mediatek-ge.ko. 'ge' is the abbreviation of gigabit
> Ethernet. Most mediatek products use the same gigabit Ethernet phy.

Well, MT7620's PHY is FE..

>
> Landen
