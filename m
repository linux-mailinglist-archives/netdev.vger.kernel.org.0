Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A94355843
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244150AbhDFPjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345987AbhDFPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:39:23 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BFC06174A;
        Tue,  6 Apr 2021 08:39:15 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x17so16043569iog.2;
        Tue, 06 Apr 2021 08:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWxFzfKKOt+ryNUGtIA7HKn1wCE+QFswqU/+uqCUAzo=;
        b=G9jof8Q6D3iqyUddjnM66ZIpqBpTUSY4OWVPX8B4ht0B5FcM9cGnncIhteSSSAr0gg
         W5rBCFvuOHQrzdf+5g6y5T32ts5lLZbBdZgH9c0rnnMQvC0id5owFpSPczcltIl8ey7i
         ajQkhLrsn5aEschOSp66HTvuDLnCd68+crEVnaqLn3ZT/BXRoXbVJHk2EuxwnGTgks8z
         sg/rqazXZPXiGDrOEgW1PO+Aa256W77paqMIfiabrszEDIxpC5eMTVaT4z85klx1Wg7t
         5zZdVf4ZcsCsBrXVwZwd4JNTGdVaTTFM0ixQK000QhzlxbUv1Kv/bvwsezy0Yg9nwk4k
         tERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWxFzfKKOt+ryNUGtIA7HKn1wCE+QFswqU/+uqCUAzo=;
        b=B3Ufh5edYd3tU02XHn55CasYm3HziywmJTmfGd54hebvMS94MexsAcbvLQNt+RAwJi
         8XiKcxqMjrchDkMlTVOgJmlSF9qOIl3U2eCdXwWI7OZ3lVH9jz2u42lLTSIDpUpFUw5r
         RVI8sCZQ9+1Vf5ZlnpKSzTMTckEStM3OQr7I3lLZydxI8TUKyU2Q9AJ4afc6qCPfppRn
         ZxpqvVdw2HkKkVSlxKYME9BAd6bUqfQpAwdhbj7zYyc09lX9VK7zkXbmaIGMzN55lQqr
         5GGnInCLg7gk8QQbb4yOLjsLRATB1ieZf4FzrMw5y34BHzzGWO/wlr7MOhGsGTdWHM1z
         F2JQ==
X-Gm-Message-State: AOAM531Rzfe60GQddeW8ycfEdh/J3EGfnGb7xio2LAxjMW2OhB+wSr4w
        4brbi2lPrAnSCFwQplkWzVTJzP3wpQD7y3ZRbm8=
X-Google-Smtp-Source: ABdhPJy3YG+5BM+JKU8AQNUYeKtb+jJMAndWgE0jQ+keqRMn1E2k/TmrjG0/9fN38Ubih2KJL/q8MeujGEdUnK9jZgo=
X-Received: by 2002:a02:ccda:: with SMTP id k26mr2514289jaq.136.1617723555190;
 Tue, 06 Apr 2021 08:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210406141819.1025864-1-dqfext@gmail.com> <20210406141819.1025864-3-dqfext@gmail.com>
 <YGx+nyYkSY3Xu0Za@lunn.ch>
In-Reply-To: <YGx+nyYkSY3Xu0Za@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 6 Apr 2021 23:39:12 +0800
Message-ID: <CALW65jYhBGmz8dy+9C_YCpJU5wa-KAwgrGjCSpa3nqUNT+xU+g@mail.gmail.com>
Subject: Re: [RFC net-next 2/4] net: dsa: mt7530: add interrupt support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 11:30 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Apr 06, 2021 at 10:18:17PM +0800, DENG Qingfang wrote:
> > Add support for MT7530 interrupt controller to handle internal PHYs.
>
> Are the interrupts purely PHY interrupts? Or are there some switch
> operation interrupts, which are currently not used?

There are other switch operations interrupts as well, such as VLAN
member violation, switch ACL hit.

>
> I'm just wondering if it is correct to so closely tie interrupts and
> MDIO together.
>
>      Andrew
