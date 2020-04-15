Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AD1A9297
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 07:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390403AbgDOFmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 01:42:08 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44846 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393366AbgDOFmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 01:42:00 -0400
Received: by mail-ed1-f65.google.com with SMTP id dm15so783211edb.11;
        Tue, 14 Apr 2020 22:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GnTx0izeYvyDZyS+vHAcMDpC99flKBZNWxhXwvZUWs=;
        b=VUo1VXpmPj24j9xkbeVdkMd+L04jWL0kfZdB/gRDY0KeR5K3VLnKPQ0Rm/gfK0sCLD
         IvKHdUmyiP2pzPzKUMTR0ieFZ2iUXZlGB8nkeL0BbiUB+3PS6yC9IWuUVY2iQFKF4FS6
         JDIcNGiwV6TKuFbzSPYVb0dwx5T7OzW/OA0KXG3EbFpNE71QShmdTVz/rvVo41y7BIgk
         bH18UK10XZRIjyQBTT6sGH/lceT3h+r5i9IgQFuFvqhtY24WtJl5gDZVDOzLBaJmx9u+
         T7z9HUrhYyOVMAz7DwZ7/4W312hRA5iA8vFbGRn4io57EkiM/s7Dy1TZCE89848U94CB
         qK3g==
X-Gm-Message-State: AGi0PuYXfl+ixOxF+UQ6y1PyOut1UZfAtlJLFAjmq6zIRkYBzU/NC4wb
        OZcshP2krUbhldIqlez9TrcCBRbx71U=
X-Google-Smtp-Source: APiQypL/n8V+ZQZvugotPgd7z7T851tPo40Y+C9GSeXYEOpO2KRYIssrjtM+WKpLsET5dnbpFWruFA==
X-Received: by 2002:a17:906:6b10:: with SMTP id q16mr3468776ejr.170.1586929317849;
        Tue, 14 Apr 2020 22:41:57 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id ce16sm2445776ejc.74.2020.04.14.22.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 22:41:57 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id x18so13265426wrq.2;
        Tue, 14 Apr 2020 22:41:57 -0700 (PDT)
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr19082552wrw.104.1586929316945;
 Tue, 14 Apr 2020 22:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200414223952.5886-1-f.fainelli@gmail.com>
In-Reply-To: <20200414223952.5886-1-f.fainelli@gmail.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 15 Apr 2020 13:41:47 +0800
X-Gmail-Original-Message-ID: <CAGb2v65XwJ30_g1qf5a=1LR63BZ=DEq0qG9GQae0YuZfH1C79g@mail.gmail.com>
Message-ID: <CAGb2v65XwJ30_g1qf5a=1LR63BZ=DEq0qG9GQae0YuZfH1C79g@mail.gmail.com>
Subject: Re: [PATCH net] net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, olteanv@gmail.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 6:40 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
> configure the MTU for switch ports") my Lamobo R1 platform which uses
> an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
> by rejecting a MTU of 1536. The reason for that is that the DMA
> capabilities are not readable on this version of the IP, and there
> is also no 'tx-fifo-depth' property being provided in Device Tree. The
> property is documented as optional, and is not provided.
>
> Chen-Yu indicated that the FIFO sizes are 4KB for TX and 16KB for RX, so
> provide these values through platform data as an immediate fix until
> various Device Tree sources get updated accordingly.
>
> Fixes: eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
> Suggested-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Chen-Yu Tsai <wens@csie.org>
