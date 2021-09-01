Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7D3FD6AF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhIAJWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243617AbhIAJWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:22:49 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF63C061760
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 02:21:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so1059511wmq.0
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 02:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n98mwoAfaU9AP+3ubF17hDj0gbBeEiHm5XPkiJxyJoc=;
        b=KD14hU4xYSjeEVHKS+AEbheCLy8ArrkDscZ8gM4aIfc2i27Bppz8oPYDLJ8ZTblnWE
         LnXASD1ZnaiNG8hYD2J2h8+qOPB5InvAMstICeyT/i+sT2N8UoqMyZw9Olca0BTuyruT
         Vl9DiETaj3nYO9W8u0ALspKVewTEUAVKIHdA0tybvzLWTTtNr8Lcih0qGEJV5AhuRQ8r
         y2VEjWseUNq3y9Uw1nPU4nmwomz9p7rmrj+bZ402lqhlMPyq5Tpy/gqXlEL3Xil5+ZHF
         DhRLivm4fF/iFeqfOXMS5QNaxHXBMnKcXPrE3KT8rZ0SQjkGZmxurqXyDQpO5sMl4ZeL
         OX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n98mwoAfaU9AP+3ubF17hDj0gbBeEiHm5XPkiJxyJoc=;
        b=ZZp8658xK/XEKP04Weds547Jp3zbntUMrsoccdiOaqE7V82z5OhenlCy1pySLMxkZZ
         pAcfIjmv2ZJP9EGVhXTzsH+p3beAaONk3VE56jd7ekjzPtJUcSBQZYCKpYtV/RTkGTps
         qjTtVGiiz0juzUwRYgcrikIu7QAFRF+REqD8E1xh5RicR9Q1bB2ZALpiAYNY/45JLeIB
         ByJLJ/ZnYD6DpuaI9AnjESOKtL1hb3fSiEnRO/2XBsG4CzXxSP7IcvOZyjGFkr81qZwF
         OcDL/Mj1cfV5FNoPX8b0FuEMljIEZPHWW/6fXNRbW2VBMvBvFQ4Lh/Dh6/crThQMareo
         199w==
X-Gm-Message-State: AOAM533+ky8ATSs8b/5ruTZTN+NbAwzjs2ZdvUWnSW/CFP7bVVLTLS58
        HlZo8ASTa4L7Qh4OZz+D4eA=
X-Google-Smtp-Source: ABdhPJzDNLfjSC8sEHRNDyT4oMMvo8MvTjWtH5na3egsan9Mezbeo8eR9Cz1ihqFtN/2PpXPbP3ufQ==
X-Received: by 2002:a1c:a747:: with SMTP id q68mr8691298wme.149.1630488111220;
        Wed, 01 Sep 2021 02:21:51 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id g1sm9939392wrc.65.2021.09.01.02.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:21:50 -0700 (PDT)
Date:   Wed, 1 Sep 2021 12:21:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-imx@nxp.com
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210901092149.fmap4ac7jxf754ao@skbuf>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 05:02:28PM +0800, Joakim Zhang wrote:
> We can reproduce this issue with below steps:
> 1) enable WoL on the host
> 2) host system suspended
> 3) remote client send out wakeup packets
> We can see that host system resume back, but can't work, such as ping failed.
> 
> After a bit digging, this issue is introduced by the commit 46f69ded988d
> ("net: stmmac: Use resolved link config in mac_link_up()"), which use
> the finalised link parameters in mac_link_up() rather than the
> parameters in mac_config().
> 
> There are two scenarios for MAC suspend/resume:
> 
> 1) MAC suspend with WoL disabled, stmmac_suspend() call
> phylink_mac_change() to notify phylink machine that a change in MAC
> state, then .mac_link_down callback would be invoked. Further, it will
> call phylink_stop() to stop the phylink instance. When MAC resume back,
> firstly phylink_start() is called to start the phylink instance, then
> call phylink_mac_change() which will finally trigger phylink machine to
> invoke .mac_config and .mac_link_up callback. All is fine since
> configuration in these two callbacks will be initialized.
> 
> 2) MAC suspend with WoL enabled, phylink_mac_change() will put link
> down, but there is no phylink_stop() to stop the phylink instance, so it
> will link up again, that means .mac_config and .mac_link_up would be
> invoked before system suspended. After system resume back, it will do
> DMA initialization and SW reset which let MAC lost the hardware setting
> (i.e MAC_Configuration register(offset 0x0) is reset). Since link is up
> before system suspended, so .mac_link_up would not be invoked after
> system resume back, lead to there is no chance to initialize the
> configuration in .mac_link_up callback, as a result, MAC can't work any
> longer.

Have you tried putting phylink_stop in .suspend, and phylink_start in .resume?

> 
> Above description is what I found when debug this issue, this patch is
> just revert broken patch to workaround it, at least make MAC work when
> system resume back with WoL enabled.
> 
> Said this is a workaround, since it has not resolve the issue completely.
> I just move the speed/duplex/pause etc into .mac_config callback, there are
> other configurations in .mac_link_up callback which also need to be
> initialized to work for specific functions.
> 
> Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
> 
> Broken patch cannot be reverted directly, so manually modified it.
> 
> I also tried to fix in other ways, but failed to find a better solution,
> any suggestions would be appreciated. Thanks.
> 
> Joakim

Do you know exactly why it used to work prior to this patch?
