Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD07C2F8E1B
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbhAPRGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbhAPQaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 11:30:09 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB357C06135B
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 07:51:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b2so12873756edm.3
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 07:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0CK16M5dkE+kf7pLhqQ0N5SRW0N9ktke7GLStL8eHM4=;
        b=mZIXAGiy7YzzBOaSM+5kXUu2EUUb74apl4Dv1VCRQv9US2f3kLtNA06g5PlbRA0JVS
         BEDTU9AdZG1zrD5HMBP7Mp/v1XLXWH2qkNQ3VjkUt3+L/zYFLXB6ReJf4fbqYW7VmUdx
         +TvZmnTqEfKmVxd3qWnM6HiFCtstAujx3QWFpwXhLbPT6umZJju8Ja62kIH6/hPF0v/7
         YqOGPg8blSTCtXZc4DywYjYxEygdO58jxAaXImnoOj0CDeunEhoMGbqgZPwIXDA2KLEH
         6q1uxHuyHnB5eM/UkM8dQ3rnL+eFxujm70gqgCUiigktUebwSFo8wvuvViKm7naCnwvL
         vtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0CK16M5dkE+kf7pLhqQ0N5SRW0N9ktke7GLStL8eHM4=;
        b=gpRpLdLSnn4+oJw+lzs/hscp8ne6Ynjhc5FXS/L/NFd6tBDbRjrg1izgIVw1VJ0EzL
         CsXz4zhfMqJJTo62aZ8CKBjwM84EcBkkr1B2xh7O9RJGfpQpKemH2rqFeydB3nMKuFmH
         OoWhHVKTfjg/RIma5x4V480qDoPNd9gJ2fpgbKh7Tg8ARt4ApWM+z46QQti6GJczIl8U
         NJ4CKaWVtc4/fXC7OhLhP7Bb/adwWc/LStyh0399W2Fh53lqUN76adubrIG7LiHSpGea
         bBMb/QfSX3iD0moR3WIdq86pUTYP79YLOqMP6JpVI+9PCAZC5oWgjzumXvrYA9RQNf07
         YJBQ==
X-Gm-Message-State: AOAM532oxfKbNkxwASYQ35DJdm6zQWlM1OLLrPyi8eC7G81CzAE0ys71
        uNdJ9ZENrKuxRKj+GGAM7Zo=
X-Google-Smtp-Source: ABdhPJzVDQ46Lq0zQqJ03JAq1liW8Ig6WfK3Usd3KIYISZWHmrAkJlAgMWE8Txdo0Sfw56pgYQC2HQ==
X-Received: by 2002:a05:6402:8d5:: with SMTP id d21mr14014446edz.57.1610812265676;
        Sat, 16 Jan 2021 07:51:05 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t21sm4580315edv.82.2021.01.16.07.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 07:51:04 -0800 (PST)
Date:   Sat, 16 Jan 2021 17:51:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH v2 net-next 00/14] LAG offload for Ocelot DSA switches
Message-ID: <20210116155103.eftu5m5ot7ntjqj5@skbuf>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:59:29AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series reworks the ocelot switchdev driver such that it could
> share the same implementation for LAG offload as the felix DSA driver.

Jakub, I sent these patches a few hours early because I didn't want to
wait for the devlink-sb series to get accepted. Now that it did, can you
move the patches back from the RFC state into review, or do I need to
resend them?
