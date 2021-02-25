Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142D23256AC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhBYT2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhBYT0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:26:07 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F414C0617AB
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:25:26 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u4so7809778ljh.6
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ZFakH3LvdHqyZYhKOfg/pXJukT7Cv00+9KnGRvVM7Mk=;
        b=F35c0t4W+RkMArFuYPtZ0vl3i8lU5YAte/cts5CkLZPDtJah/F6SxCG83CNfJ8UZ/I
         J1xyGp1l1POADnL4Qe/cE8aijNvgMn9D/V3BCfo3HNajoq9Fa6FSzFiUb9StBKSQfmC0
         usbu/fH3hFirejiRpphPX8gJfq2fg6vi1OkbenexkfhAfAIF55z859w2JNjvMob65sBu
         +yKRshhVbtqVcHd9/bxyWp4fqNMpM1DOOUqCI7ghYdZIvopQiyT+FBMpvqb04D/Mdeoe
         3jxs3D04hBLFfopekugTwUlurl0TJRfRuuA5S/umZ07LeSu8mKaOo6BboBYqRxUzlOcb
         FeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZFakH3LvdHqyZYhKOfg/pXJukT7Cv00+9KnGRvVM7Mk=;
        b=JcrvTSo5AdKdYCUq7P11JJYImRVvaDYMg/diBt80iCjTknijeGuP3NpiwT1LUzYMHk
         rRnd02RC8GQMR8vpssDLCL0Jg9/5gSZ0fMZ2AEa9SAFziMfWMJGXSwgb5d4ryo0guTSq
         SZoalzApg/HTjyqtu/Xt7m2mnJyzw/pptaOoDT21PJCXoOHri+XFRiIsMz7ePMebBvyA
         l9MPniQftVuMANnco+L8v7PTb5deAspoqvb5bNSHFAm5ZiQHJ48A5QDrmmeVyXXqktKE
         F0T3LC1DO8FIT8QSl94Z2MgCOI8mPGo17UVzZWFFl2Ik0TctCH/k5JQOr7zXMPnSiC9W
         TRJw==
X-Gm-Message-State: AOAM5321r61zXYhxbX/Lcjc97k9JkKUJc0HUzSV3hmD4M9mYt3WHWtQW
        dutC0/IbL4k2VAYwRX8gXp/hiA==
X-Google-Smtp-Source: ABdhPJwicU+QTk5kvaHc9sSpofx70wmz6HY4k1XJQDf7IkvhPferTZUo3HgJHoBzW5XaqewGj91TMQ==
X-Received: by 2002:a2e:8095:: with SMTP id i21mr2434175ljg.259.1614281125039;
        Thu, 25 Feb 2021 11:25:25 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id s3sm1167259ljp.23.2021.02.25.11.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:25:24 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next 4/4] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
In-Reply-To: <20210214155326.1783266-5-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com> <20210214155326.1783266-5-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 20:25:23 +0100
Message-ID: <875z2grluk.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 17:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> DSA has gained the recent ability to deal gracefully with upper
> interfaces it cannot offload, such as the bridge, bonding or team
> drivers. When such uppers exist, the ports are still in standalone mode
> as far as the hardware is concerned.
>
> But when we deliver packets to the software bridge in order for that to
> do the forwarding, there is an unpleasant surprise in that the bridge
> will refuse to forward them. This is because we unconditionally set
> skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> were already forwarded in hardware by us.
>
> Since dp->bridge_dev is populated only when there is hardware offload
> for it, but not in the software fallback case, let's introduce a new
> helper that can be called from the tagger data path which sets the
> skb->offload_fwd_mark accordingly to zero when there is no hardware
> offload for bridging. This lets the bridge forward packets back to other
> interfaces of our switch, if needed.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

For the generic and tag_dsa.c related changes:

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
