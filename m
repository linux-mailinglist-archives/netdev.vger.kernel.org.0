Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEDE2C7315
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389422AbgK1VuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387670AbgK1USv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 15:18:51 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428F2C0613D1
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 12:18:05 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id j10so10269319lja.5
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 12:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=LQzNZ3tR8v49OlYP/cuskc0MHqi8TGhcA3E3U0cvtzQ=;
        b=VwVaXHLyYUlhDyeQh1wP5lWtskbZlVKwQI3PzgbPuQ2B5rk0MBndvWxI5iSUi/u4b+
         EDo6jU9YVT8agweJSWUlsd2TKWC93//UtuDQ4PX/zZgPbdjg+hR9ucSiTG5LfBEI+N3O
         S7xeRH/i/gs451F08gi+JIA5GVNZPUbL9kOk/xO76Ci1gqMcjWuSnTnMYM1V4KTEAAz6
         aUF+eqL61WidqVEQnek3mklRMDiDc7yImqqGBGXlwkP4KyA3bR6H82i9+GNyjFiZTIvO
         tm7pd39xiEyS+aHMxOUwqu0oLHzsXBxsfp9HhsudqUXwjEpSoehby7Sf2HX1P5/6HJuj
         E6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=LQzNZ3tR8v49OlYP/cuskc0MHqi8TGhcA3E3U0cvtzQ=;
        b=ekY8ONQoE6ohyhOC4RlD3OPNoNuBrwxYoeeE0po/1vHkQN1K588KsU8ZWK2ukvQtAU
         BZkVkVtu5pgjZh37i7So/JayPblp4MNfYNCk7ZMpu9h+APn+hNVSf2v5COeov/zrvG1G
         /AM75EFXNiYsgx+RAtv2PllUvYah7Gr0KFxVaiNAv++kUUpOXShMPeg42A6wFcDni1Hw
         oAVkpfZ2gwpc93m4S+2d96j7DHrmAlcl6bo6kBx0tPLZA7SSTT+0anIcL5Mdzo5y5ALz
         ZpAtPEerVJTTQC9zqLCyIc3nBPznjhgLWC6aA3lLisQpZqtv+QiY4ME8DdPU7FgYZDK9
         qjrw==
X-Gm-Message-State: AOAM5317h4TY7hytvJd2e88dA41EJcI+bvv4+8MnyvY+EULWvkcn9iXc
        zyDE3qgbuKjJHNb2V/mHFxkM4fzlCAZsuU5r
X-Google-Smtp-Source: ABdhPJyzYMNfFg3RhAAZoH2VOAmbcXUs/BCrpmwUyz0Rnh9pHZQI3z+QiY6jhes/aABvRv5YmPxkcw==
X-Received: by 2002:a2e:a590:: with SMTP id m16mr5729034ljp.462.1606594682293;
        Sat, 28 Nov 2020 12:18:02 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id z20sm984965ljh.86.2020.11.28.12.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Nov 2020 12:18:01 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "Tobias Waldekranz" <tobias@waldekranz.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andrew Lunn" <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Date:   Sat, 28 Nov 2020 20:48:52 +0100
Message-Id: <C7F5NW46RGKW.HWQYN850NOTL@wkz-x280>
In-Reply-To: <20201128163805.GB2191767@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Nov 28, 2020 at 6:38 PM CET, Andrew Lunn wrote:
> > > OK I think I finally see what you are saying. Sorry it took me this
> > > long. I do not mean to be difficult, I just want to understand.
>
> Not a problem. This is a bit different to normal, the complexity of
> the stack means you need to handle this different to most drivers. If
> you have done any deeply embedded stuff, RTOS, allocating everything
> up front is normal, it eliminates a whole class of problems.

Yeah I am well aware, Linux is pretty far from that kind of embedded
though :)

The problem here, IMHO, is not really the allocation. Rather we want
to shift as much work as possible from CHANGEUPPER to PRECHANGEUPPER
to signal errors early, this was the part that was not clicking for
me.

And you can not allocate anything in PRECHANGE, because there may
never be a corresponding CHANGEUPPER if another subscriber on the
chain throws an error. _That_ is what forces you to use the static
array.

> This is all reasonable. I just wonder what that number is for the
> mv88e6xx case, especially for D in DSA. I guess LAGs are global in
> scope across a set of switches. So it does not matter if there is one
> switch or lots of switches, the lags_max stays the same.

For everything up to Agate, the max is 16. Peridot (and I guess Topaz)
can potentially do 32, but mv88e6xxx never sets the "5-bit port" mode
AFAIK, so in practice the max is 16 across the board.

Yes the LAG IDs are global, they must be configured on all switches,
even those that have no local member ports. So the pool will hold 16
entries on a mv88e6xxx tree.
