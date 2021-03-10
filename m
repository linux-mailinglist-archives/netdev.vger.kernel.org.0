Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF7C334C3B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhCJXKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhCJXK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 18:10:29 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4D0C061574;
        Wed, 10 Mar 2021 15:10:29 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id p7so30833969eju.6;
        Wed, 10 Mar 2021 15:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Y9MjRts8tJjHgCUb2Iq9KHOIcaGo0V2pW4Fp5XYQq0=;
        b=t5WCXHDCAqWoOY8vvWjS/p98fmmrH0F+h6H5pURHoN8BEnzWfMl2aouEntq+FPFgI9
         GDAzlnWeW+3+Ghn6KfC1qbH0xHIAJVanWaGJPS+mfIhc9LA0KDmrNf0JmmS6JkAIXfTn
         /t+WKh1rgyDH/B0i4ehnaSTcLCxwlMf5TJNzPTY1W9s6J8jKgqKnU1CO3EwrJCdAJ4Vz
         49HDZntyJHHxlg4EH4m3n64MwXfiEkj09hIU+Bc0shA3TiMMVeIqzid6HY0euxrBoNh/
         5AcPlr1Ind4FFNh18T3wydqCHQcGlNoQWz5jwUYVMeWaY0xm6cjGMNJVoEf3n0ZNwu9C
         fyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Y9MjRts8tJjHgCUb2Iq9KHOIcaGo0V2pW4Fp5XYQq0=;
        b=LDw5/a3wro/0WSaiAKTJw6gCO1BvotWfl90unpxHjXClA4K8q4qiX4hdhATofd3erA
         G86ocpkpR8CDGu5YHNd9bk/sYphH+aCfLwBwK6GlpYRax5Rcpm6OrmtzQIPXb32mXmRT
         eiQB/9DDpUEK94Rg0dNGPTAunnrtJWIYqrx/tBhLCrOXOd4+C7WI6E3tUm14UT7QmTwT
         F/x1x9rtP/RG/cc3Hoxc66HrWXar+Cd10RYV2Ot6WalRMcPWz6gL5mgjcCaI6/prIzqR
         FQ+F3/84tufkOS6/vKBRpUOHxOjSJ3AWP/GEar6eVBdDc2uFl2v+i3U4/w0OtHedz4oR
         g85A==
X-Gm-Message-State: AOAM5326ejaCWizyM4sUEJqnFRwWWoJyf7k4Y53Yp1jndNdn4s8WxOnE
        DQyH+n2gploToN2EYkF1MXo=
X-Google-Smtp-Source: ABdhPJzpCw/su5dc23eER+GYr7msTlNS7+5Mn+Zm9/S1spB5ac9PVKV85UZGOsHF3uMOZxcT9C+f7A==
X-Received: by 2002:a17:906:95d1:: with SMTP id n17mr242829ejy.394.1615417828283;
        Wed, 10 Mar 2021 15:10:28 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id gq25sm387319ejb.85.2021.03.10.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 15:10:27 -0800 (PST)
Date:   Thu, 11 Mar 2021 01:10:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: dsa: mt7530: setup core clock even in TRGMII
 mode
Message-ID: <20210310231026.lhxakeldngkr7prm@skbuf>
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-3-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310211420.649985-3-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ilya,

On Wed, Mar 10, 2021 at 01:14:20PM -0800, Ilya Lipnitskiy wrote:
> 3f9ef7785a9c ("MIPS: ralink: manage low reset lines") made it so mt7530
> actually resets the switch on platforms such as mt7621 (where bit 2 is
> the reset line for the switch). That exposed an issue where the switch
> would not function properly in TRGMII mode after a reset.
>
> Reconfigure core clock in TRGMII mode to fix the issue.
>
> Also, disable both core and TRGMII Tx clocks prior to reconfiguring.
> Previously, only the core clock was disabled, but not TRGMII Tx clock.
>
> Tested on Ubiquity ER-X (MT7621) with TRGMII mode enabled.
>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---

For the networking subsystem there are two git trees, "net" for bugfixes
and "net-next" for new features, and we specify the target tree using
git send-email --subject-prefix="PATCH net-next".

I assume you would like the v5.12 kernel to actually be functional on
the Ubiquiti ER-X switch, so I would recommend keeping this patch
minimal and splitting it out from the current series, and targeting it
towards the "net" tree, which will eventually get merged into one of the
v5.12 rc's and then into the final version. The other patches won't go
into v5.12 but into v5.13, hence the "next" name.

Also add these lines in your .gitconfig:

[core]
	abbrev = 12
[pretty]
	fixes = Fixes: %h (\"%s\")

and run:

git show 3f9ef7785a9c --pretty=fixes
Fixes: 3f9ef7785a9c ("MIPS: ralink: manage low reset lines")

and paste that "Fixes:" line in the commit message, right above your
Signed-off-by: tag.
