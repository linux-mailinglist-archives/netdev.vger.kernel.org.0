Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8666832569F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhBYT1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhBYTZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:25:18 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DE8C06178A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:24:33 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id a17so9809745lfb.1
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=i/27qzdi06B2sG86ad3inSpf+Yw1TpwHO2LBa03+m2U=;
        b=f9kAhhhh1MmndUQxa/xynNfKskoi+/p4UoXjmV7mqBjU4QmkCF1Aa1g37r/GtXZUs/
         MdX/HfHX0bS8K51F5yl1mxe+4rFCJL7f5No+S+FTibWm8/H+BumJ397bl2E82g8QL6QO
         6NQKufTt77iiXcuuw3D2ztN+nOJJppMvHaXS3QZcYfRqWUd8xbAQxda0gxJJFcw/QVhU
         L7OcSIech32+zfj+GAUoYEeXQmJsVNOP9oyfb5PEMWvVTsoB+8xuA9dl0H9NV2cjR4HX
         Vkr3nGd6J6rhecQB32vNBmsYErPI3js5rKjak4LxBppzNDr3VtWOrbPPW9gv9yBThXY5
         PWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i/27qzdi06B2sG86ad3inSpf+Yw1TpwHO2LBa03+m2U=;
        b=io0RBAN0Kz1kBuiLkBpeNAngrmUlKCtSRn8Y/J2IEJj/hR4raE5jLPc3psg7uwqXRQ
         EZgJJJHcTHARvnx5vDD4Oml0rT7ROkgq+vzntfl9zNLZ5bMlHaSSGFa3P1aNOMTIyEUz
         /HP1QGI+MAzEXVZU8/79MZraS9ILzTxFCtlqOYpdf9bebWyom/BQ2raI5P8RFjczdhwo
         eGAWH3hMnjG6u0C3THYUsq5l1f2pFUQIotO4zW6Q0gdExZx8TEy9VZ3AiAxu+bY6SAty
         4I4dIG8EMUuZ2c+lfw8K48RF96rhMJxWX8C7A36DP97Ywg+iK54D7DP/Ja0isgrT6ghv
         ogYA==
X-Gm-Message-State: AOAM530AbOrzNieiB0OiuncKBNskFI79M3lV3xMWwjnHPejtVdr6lhVv
        quLX8HPubo3cIOYbUX09kvrIRw==
X-Google-Smtp-Source: ABdhPJwaAVq0A5gWJ1tWlL5/7s+ndMScxw/zwDaROrCdGEFLP3xvsjDKr8VqCfyrF0VBHonQp3Q7FA==
X-Received: by 2002:a05:6512:31cc:: with SMTP id j12mr2581806lfe.408.1614281071755;
        Thu, 25 Feb 2021 11:24:31 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id k11sm752621ljg.119.2021.02.25.11.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:24:31 -0800 (PST)
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
Subject: Re: [PATCH net-next 3/4] net: dsa: return -EOPNOTSUPP if .port_lag_join is not implemented
In-Reply-To: <20210214155326.1783266-4-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com> <20210214155326.1783266-4-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 20:24:30 +0100
Message-ID: <878s7crlw1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 17:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> There is currently some provisioning for DSA to use the software
> fallback for link aggregation, but only if the .port_lag_join is
> implemented but it fails (for example because there are more link
> aggregation groups than the switch supports, or because the xmit hash
> policy cannot be done in hardware, or ...).
>
> But when .port_lag_join is not implemented at all, the DSA switch
> notifier returns zero and software fallback does not kick in.
> Change that.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
