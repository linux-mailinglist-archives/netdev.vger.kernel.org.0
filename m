Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ABD2EFC17
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbhAIAW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAIAW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:22:27 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC7C061573;
        Fri,  8 Jan 2021 16:21:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id h16so12919965edt.7;
        Fri, 08 Jan 2021 16:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SVjrZHS1z9/LfAkQQVlQkPWbRRh+b9cjLLIJ+BUfI/o=;
        b=ROe310CEXN5w5chetm/q09Ju86rDbg22e9wnb7057rGPXIv9vUBc9VNQFkWyRahK+1
         OhMTrinNnLr/oI2bVV1dz5qmKB1V6a8XNOMH+YhaJV0z8YmD+75sfoNOnRJvsqgVjE15
         9czlN0xhzyK/OpEhvL9Tf8EYNfEHyHHMhvQ6DMMI2pR3aKURFrdwxiBx2C8Ftm10L9QY
         a5hKr50hnd6cg8kMdqZAkEtrGg/XkgrZNnh+a5qKpl6I9qBWVXyBUEZQgWMpFOrCAjlB
         QpViGMfvL7aF96LF2BRjrB9GfCnSEX8HZOsNQrnrtJ4zkH/09DGDZhNrVB9aq1r/VRZC
         jj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SVjrZHS1z9/LfAkQQVlQkPWbRRh+b9cjLLIJ+BUfI/o=;
        b=huQTBGqOoYTjTjror4zqcEvKlvJfovArUIiz1Fy7kSdfoKQPFhPOvIEq8rfPWcaaId
         eSQzmMNC320JIc/M/c3WNS+88IcjtPuSVRRfsoPwyuUwdQiwN/Iv3SiyBUgsMzVqSvQR
         YRvcyLZJNGSkWFNz3Bhr/fb1xFuVO3mOLf3/sFzEty4GBwGMRWXtl7DDh2X3F+T3ledo
         gCNoWBzuhHLNhw9FYnCaFdVLItcT1pdYsY1WSHRejQ99sVscn6h8FJE/dvat8H3vZBvz
         Yqg83ln/iSsOZOJLxTUEB1LLUIPW13Rk+WHUUT9SA2kzCtSFKJhLEi+brbuF3APRFISw
         xInA==
X-Gm-Message-State: AOAM533wsMM5ZHf1dKkssmO4z8DXB1cIan+Mg0OYECWlldsPptbthYAj
        wwPkRydYOURrimF9WZTlhz0=
X-Google-Smtp-Source: ABdhPJx7Tkr3/eQR3Sikolg6+F5j6qjGA0HG++ZdfTMDo7zdnYsts0o0HBYS9twc18lAHRNW53VExQ==
X-Received: by 2002:a50:fd18:: with SMTP id i24mr7135813eds.146.1610151705460;
        Fri, 08 Jan 2021 16:21:45 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e27sm4061827ejm.60.2021.01.08.16.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:21:44 -0800 (PST)
Date:   Sat, 9 Jan 2021 02:21:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20210109002143.r4aokvewrgwv3qqv@skbuf>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
 <20210107125613.19046-3-o.rempel@pengutronix.de>
 <X/ccfY+9a8R6wcJX@lunn.ch>
 <20210108053228.2efctejqxbqijm6l@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108053228.2efctejqxbqijm6l@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 06:32:28AM +0100, Oleksij Rempel wrote:
> May be the "net: dsa: add optional stats64 support" can already be
> taken?

I'm not sure that I see the point. David and Jakub won't cherry-pick
partial series, and if you resend just patch 1/2, they won't accept new
code that doesn't have any callers.

You don't have to wait for my series if you don't want to. If you're
going to conflict with it anyway (it changes the prototype of
ndo_get_stats64), you might as well not wait. I don't know when, or if,
it's going to be over with it. It is going to take at least one more
respin since it now conflicts with net.git commit 9f9d41f03bb0 ("docs:
net: fix documentation on .ndo_get_stats") merged a few hours ago into
net-next. So just say which way it is that you prefer.
