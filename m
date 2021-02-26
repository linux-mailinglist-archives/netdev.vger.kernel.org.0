Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3343266C5
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBZSPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBZSPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 13:15:13 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78309C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:14:33 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so16379439ejc.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 10:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oa1KlckD67pLosX1ZViVyxz3DGGD3vGhE0D0W4kw/Xo=;
        b=XManrh8eC0M2844mHJARNFjLnAQjjEged+LMesLsZDZnqvsZpdKOszvxwLnRXLiJqE
         9+Z++pIAG+eD+21gSiOxYcOO24C82VvIX3pgwenyarK7RJVrN7lVFUWqvniodT9Wvtt/
         PsziXNW8WuK1GBr88m6BzdBtYmqlHPK6qDCjHMUMkn+s+6pevXjRePxpSvb6twsihRPK
         6ysPkkon1s7Ol63us/K9opYFseiSGrSPFMXdDdj4cqqMqHOWykvpE080nn6uyM6lTaR6
         yMdG3WCqgwtg9i4WVO2U05hDsuox/pHAJH9o6xb+cZXUwX2UjHQ7QZ7M7Lh10I+YMF3Y
         vXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oa1KlckD67pLosX1ZViVyxz3DGGD3vGhE0D0W4kw/Xo=;
        b=U0lPPI5YqUDp5M8PGBG3CiOXJpHATMSTUxw/Dry5L7m1Hu/67+/sLLM4A1sfmkDyqq
         dPiKFPayG9GRwMQy8SIY8DfLjAiNEya69zfTZcbNEVj2ed7RdPJFOaxgKgBK+byoGSbw
         PvePyOnnghtqsKfPEDeSsNlMBQKcKv9muS6le38bRsFHSso8kApY0yYycHU+6Z0DNlqt
         5E6aT/cqlGFYhijZ0b1mYTNas/jnGZz1yUzSRWGxNqcBipZPqku9gPMum3vjdOuu3FYp
         L+msoGN/bV0ogFDmnrzEgJYt3K4Xdwh49e+oMHWtm5txVDhZBehHfmkrDPpdQUnS5jGa
         SB4g==
X-Gm-Message-State: AOAM532z+wvZQpOuaKj2V/oJYMi567d19hCcdlZD4pZj/odK/OcBAPuQ
        6pfvFQMuUZTHh9oLqBYnueE=
X-Google-Smtp-Source: ABdhPJwiEByHvMbWv5UAwvm/sYKY7Bs3iiCTVeGGKFdeDvaqNbpoRdQrRWMZTymFQ4fJAsim3WP9Ng==
X-Received: by 2002:a17:906:2344:: with SMTP id m4mr4581807eja.327.1614363272267;
        Fri, 26 Feb 2021 10:14:32 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id dc20sm5882911ejb.103.2021.02.26.10.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:14:31 -0800 (PST)
Date:   Fri, 26 Feb 2021 20:14:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [PATCH net-next 4/4] net: dsa: don't set skb->offload_fwd_mark
 when not offloading the bridge
Message-ID: <20210226181430.5q3olzmozpqpl2fm@skbuf>
References: <20210214155326.1783266-1-olteanv@gmail.com>
 <20210214155326.1783266-5-olteanv@gmail.com>
 <875z2grluk.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z2grluk.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 08:25:23PM +0100, Tobias Waldekranz wrote:
> On Sun, Feb 14, 2021 at 17:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > DSA has gained the recent ability to deal gracefully with upper
> > interfaces it cannot offload, such as the bridge, bonding or team
> > drivers. When such uppers exist, the ports are still in standalone mode
> > as far as the hardware is concerned.
> >
> > But when we deliver packets to the software bridge in order for that to
> > do the forwarding, there is an unpleasant surprise in that the bridge
> > will refuse to forward them. This is because we unconditionally set
> > skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> > were already forwarded in hardware by us.
> >
> > Since dp->bridge_dev is populated only when there is hardware offload
> > for it, but not in the software fallback case, let's introduce a new
> > helper that can be called from the tagger data path which sets the
> > skb->offload_fwd_mark accordingly to zero when there is no hardware
> > offload for bridging. This lets the bridge forward packets back to other
> > interfaces of our switch, if needed.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> 
> For the generic and tag_dsa.c related changes:
> 
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>

Actually with my switchdev_bridge_port_offload_notify() proposal, I
don't think this patch is going to be needed at all. I think the bridge
happily ignores a packet with skb->offload_fwd_mark = 1 if it comes from
a port which has an offload_fwd_mark of 0, although I haven't tested that.
