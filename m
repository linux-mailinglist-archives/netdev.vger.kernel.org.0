Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF06F3E3B4E
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 18:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhHHQMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 12:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhHHQMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 12:12:54 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF764C061760;
        Sun,  8 Aug 2021 09:12:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so16750514pjy.0;
        Sun, 08 Aug 2021 09:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=f5fFjNuLaESLtt6NpxalDxQH6QXq4SR6rkuDvkhfkdY=;
        b=kZ1Y8YHhslgLJBNqqU0v9tleoLWjAmdqD+tYyymu2xJB62MfxAqZRHmZkkr1rU7ZVi
         ePkUaDXmYH74LuIaIn8fAIJmaIxbQjyYnbeknS/kYcgiTZ4oll7oLajDkSiMDmqkrjFU
         0GusmTLlMKK4Fo23xLj429nTEvj+hA46gYFamO5RuWZth4jVV4fv79rDRJLKh+TBHMu1
         Ovp36p3+7vLSIDse+TnTIpYxoGV+IUguVw/NJcGMjk8/75hBXAUR4BidPZbcQBaIuwOu
         2Jl9n6nxsBeALQm8ehek3v+iHbNfDrLPaqIn+pjBFaUjcxQGKqOw5J/U/BYxuN8XAuMC
         fYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=f5fFjNuLaESLtt6NpxalDxQH6QXq4SR6rkuDvkhfkdY=;
        b=WR7QTvxdxoQm1Rj0QPUU7QXvodklTucJPGjbK+DM6RWfu+iefHx5V6bc2UUZg+s6bG
         sgSKbU/7WmXT1sFkTP/I+8COjFKfoZfxejXC9XTVhxOqoVbfpl2d+uFcmfSRItVXfQ0m
         E66WKKQIqTNfNGx3gOgEJMU64xmrCZnjirodnFJIpxM3F6Q0u0mAXZaTcENO4lPsWdxm
         epzXUpVAX5Oa87qre9av8IG7PytDkbvK6OgufwUJXmAOrKi1qkC9AGJiu/muCGV8hIqJ
         WgWA954C9sUrHfWgzL+y0yxws0+VtLRiUgzcRhfPpDhGka/od9FY+HVizl1Ps+E3dNDm
         8rKQ==
X-Gm-Message-State: AOAM5332Z34xvTyuf/WmUilcfY+Oo6MnxkAq0W8TCpGLfx7j7Wit2ySm
        qkOnwl8PIPSJUP8d1ZCF3X0=
X-Google-Smtp-Source: ABdhPJxpHd7sA+xj/K264Oysk9odcZnnHttjMMytkovw4nHImrjX41umo5G/CyvxRFzEZwTxDoOzLg==
X-Received: by 2002:a17:90b:20b:: with SMTP id fy11mr30703033pjb.79.1628439155383;
        Sun, 08 Aug 2021 09:12:35 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x7sm16760227pfn.70.2021.08.08.09.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:12:34 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?iso-8859-1?Q?Andr=E9?= Valentin <avalentin@marcant.net>
Subject: Re: [RFC net-next 3/3] net: dsa: tag_qca: set offload_fwd_mark
Date:   Mon,  9 Aug 2021 00:12:24 +0800
Message-Id: <20210808161224.228001-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210807225721.xk5q6osyqoqjmhmp@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com> <20210807120726.1063225-4-dqfext@gmail.com> <20210807225721.xk5q6osyqoqjmhmp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 01:57:21AM +0300, Vladimir Oltean wrote:
> In this day and age, I consider this commit to be a bug fix, since the
> software bridge, seeing an skb with offload_fwd_mark = false on an
> offloaded port, will think it hasn't been forwarded and do that job
> itself. So all broadcast and multicast traffic flooded to the CPU will
> end up being transmitted with duplicates on the other bridge ports.
> 
> When the qca8k tagger was added in 2016 in commit cafdc45c949b
> ("net-next: dsa: add Qualcomm tag RX/TX handler"), the offload_fwd_mark
> framework was already there, but no DSA driver was using it - the first
> commit I can find that uses offload_fwd_mark in DSA is f849772915e5
> ("net: dsa: lan9303: lan9303_rcv set skb->offload_fwd_mark") in 2017,
> and then quite a few more followed suit. But you could still blame
> commit cafdc45c949b.

The driver currently only enables flooding to the CPU port (like MT7530
back then), so offload_fwd_mark should NOT be set until bridge flags
offload is supported.

> 
> Curious, I also see that the gswip driver is in the same situation: it
> implements .port_bridge_join but does not set skb->offload_fwd_mark.
> I've copied Hauke Mehrtens to make him aware. I would rather not send
> the patch myself because I would do a rather lousy job and set it
> unconditionally to 'true', but the hardware can probably do better in
> informing the tagger about whether a frame was received only by the host
> or not, since it has an 8 byte header on RX.
> 
> For the record, I've checked the other tagging drivers too, to see who
> else does not set skb->offload_fwd_mark, and they all correspond to
> switch drivers which don't implement .port_bridge_join, which in that
> case would be the correct thing to do.
