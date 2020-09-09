Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1A263221
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgIIQfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgIIQf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:35:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E175C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:35:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k15so3639761wrn.10
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jl9MdazYbMEWqQTTd81RjRbyt2goVkCILtjWlQep6lI=;
        b=P1g4tv/aZx1p5lq5m7/VNtwAhX7o2KyOJ4wyvqVfJoA1wLHpYlQ5bvOVj8DlQI848i
         S/D5SkfiM2CYKJhbYhVqm9CG9tLp7v/MbrQUU3MeL3w113tsnGy4nNKF+2Y0hOVSTTuL
         AdYOqTAjSfbRdTsD/NzWtNhvtHTwP7awfaDcqWzRQ9tvrKEE4rMa8m4hcPcKpOGw6Crd
         SngBf654kOWp0S6hGdxvU2EYDLElXMXBSKz6XLPMHzLTWVvcTxq8Lwv9h7HV0Oq70Zof
         47POt990a1Qq8PH/HRuKp5zICdfrvpA2cJyTqZk2UzFzgyS2f+mRvIsCyI2mfPgtJus9
         59xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jl9MdazYbMEWqQTTd81RjRbyt2goVkCILtjWlQep6lI=;
        b=W8oLjJzQHhJb0nhiq0Q32a3M+BjKHFLS+M3WfWAyCLI0+QfjI+fzI6S3qbLhpVsSU6
         qmQDFymM4dCUjZrRgXw+ClWHFJPWNWz/Fp797kT9AI1PFCfxPgWH8bQJjFYv7CS0kr3w
         NVPYBqENRovHa2mCcwhmtkI9BBdY1IxNTFGdgSZK8f+WTEMh3vSktOmlXMvbO8KxmFSn
         L901bQM3/eJItbr1qwO2oAdDGq6abcDHfllC9UmZYn28eKeURG3FTWkg/rJDNhOG1Z8x
         czxB84mlePB0Q6NNXY1ywIg8opxf1yF8sNcg0X2g/cDgIN28hZPpUsH02HhW6KwKQFAt
         LGAQ==
X-Gm-Message-State: AOAM532HueCX9GMLTK3McZsQPh4isCANN/2a4e6bfGeKVkeiky9bJRrm
        EKip0ax+4kivah63FxnqrsjijA==
X-Google-Smtp-Source: ABdhPJzAULheBBlNK80MB6HC04/qDw7O/ArPTdSVlw9oJqtOKg3QPeeAGr45u2Eqsc1lJL3Oz4pa7w==
X-Received: by 2002:adf:c58c:: with SMTP id m12mr4673332wrg.88.1599669325941;
        Wed, 09 Sep 2020 09:35:25 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id l126sm4627871wmf.39.2020.09.09.09.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:35:25 -0700 (PDT)
Date:   Wed, 9 Sep 2020 18:35:24 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet: fix a typo for stmmac_pltfr_suspend
Message-ID: <20200909163523.GC28336@netronome.com>
References: <1599653964-29741-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599653964-29741-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

On Wed, Sep 09, 2020 at 08:19:21PM +0800, Wang Qing wrote:
> Change the comment typo: "direcly" -> "directly".
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

git log  tells me that the correct prefix for this patch
is probably "net: stmmac:"  rather than "drivers/net/ethernet:'

Probably this patch is targeted at net-next and should include net-next
in the subject like this: [PATCH net-next] ...

> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index f32317f..b666bb9
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -711,7 +711,7 @@ EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
>  /**
>   * stmmac_pltfr_suspend
>   * @dev: device pointer
> - * Description: this function is invoked when suspend the driver and it direcly
> + * Description: this function is invoked when suspend the driver and it directly
>   * call the main suspend function and then, if required, on some platform, it
>   * can call an exit helper.
>   */
> -- 
> 2.7.4
> 
