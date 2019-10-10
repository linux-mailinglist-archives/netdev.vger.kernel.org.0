Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B2AD3420
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfJJXBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:01:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36307 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJJXBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:01:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id o12so11208714qtf.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hKb1hJiJoZr7sDzi9awmt+z6YG7rgK/yyFTSM1pIHvc=;
        b=rBl0cx6+eIElwhvMYT30TfWDTrbVzMZqR9vc1u08+8UkgRFWwsWJItiHPlbIz75bbO
         yjErSPaO+d+mOXOukCkpOiBJnqGmHKu50/Uyz9FW/epJCtKe8478nPgRPB6CcvAY1a1I
         Ceuu7vL7cH8gJEFTgdiOM8xNWMPqzJ4hpm14bppd6CQU3FROOOIgnoJhKh5GJ4rvJ7G7
         trLU5f3s1a3fEC2JtQtzqks393lZwdH9IdblrWwCQZ01vQ7JRdlrHsiigbRxkJSzRSvm
         +LnPGfJbwjrZh5kS1fHLpLjgKlFwoFNpuGaKfGkNdVIg8LEUr2UFHovhiakkDrFMacbh
         yd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hKb1hJiJoZr7sDzi9awmt+z6YG7rgK/yyFTSM1pIHvc=;
        b=WRynJ+lzyg1tWUnwg2nRXqiFLhKK5rUKyThs5qfJ3pcNXy5KMNIV88cO6Nv8X8kwjj
         VFyToXxb+pjC1bYD3RO8wBlhLXXq/hpi8mIkzzpUVOLlRZr4Ds9deDQ0wtlVm7SAri3u
         5WWXiyDbS9KkMLCn535Js8uZ5w0p2pb5OZVix+QDYIZkr8jBWI3aPC6CLHo3pN/9u/v7
         3vdufyaQHgjveKJk0dqVe3BEW7QX25bxI0C3Zph0EH8nQz/PRGSdKOPdBMZHMORnVSRk
         J6BkQlp0Vu91FaPqdA7NpygxChyvCWcJK7PKAj0oyKxZLNmRWl1f1zu5F1pYYielIwCh
         MECQ==
X-Gm-Message-State: APjAAAVXDyLpr5TtpIXCQMszUF2VFIM9PEBxRiHzaRh6ufbYF5Itvj6N
        wJcU/6RqkySQaQuGR3AH/tNRgg==
X-Google-Smtp-Source: APXvYqzlvVcUTrNNKzaif/kXN8GZwkAMecaGfYJIaGrr9Y2IjFLnQDpHQHTA/hY/Sd8K4BincCEN3w==
X-Received: by 2002:a0c:f8cd:: with SMTP id h13mr12808457qvo.53.1570748480202;
        Thu, 10 Oct 2019 16:01:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 64sm3058098qkk.63.2019.10.10.16.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:01:20 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:01:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>, <boon.leong.ong@intel.com>
Subject: Re: [PATCH] net: stmmac: disable/enable ptp_ref_clk in
 suspend/resume flow
Message-ID: <20191010160103.63c3c0ed@cakuba.netronome.com>
In-Reply-To: <20191009085649.6736-1-biao.huang@mediatek.com>
References: <20191009085649.6736-1-biao.huang@mediatek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 16:56:49 +0800, Biao Huang wrote:
> disable ptp_ref_clk in suspend flow, and enable it in resume flow.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index c7c9e5f162e6..b592aeecc3dd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4469,6 +4469,8 @@ int stmmac_suspend(struct device *dev)
>  		stmmac_mac_set(priv, priv->ioaddr, false);
>  		pinctrl_pm_select_sleep_state(priv->device);
>  		/* Disable clock in case of PWM is off */
> +		if (priv->plat->clk_ptp_ref)
> +			clk_disable_unprepare(priv->plat->clk_ptp_ref);

I don't know much embedded, but it seems like this should perhaps just
be clk_disable() without the unprepare? stmmac_hw_teardown() is called
when driver is removed so it needs to unprepare as well.

Please feel free to explain to me why this needs to be
clk_disable_unprepare(), as I said - not an expert.

Also - if this is a bug fix and you'd like to have it backported to
older releases you need to add a Fixes tag.

Thanks!

>  		clk_disable(priv->plat->pclk);
>  		clk_disable(priv->plat->stmmac_clk);
>  	}
> @@ -4535,6 +4537,8 @@ int stmmac_resume(struct device *dev)
>  		/* enable the clk previously disabled */
>  		clk_enable(priv->plat->stmmac_clk);
>  		clk_enable(priv->plat->pclk);
> +		if (priv->plat->clk_ptp_ref)
> +			clk_prepare_enable(priv->plat->clk_ptp_ref);
>  		/* reset the phy so that it's ready */
>  		if (priv->mii)
>  			stmmac_mdio_reset(priv->mii);

