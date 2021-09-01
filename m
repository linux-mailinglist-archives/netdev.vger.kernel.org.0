Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944483FD83B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhIAK5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhIAK5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:57:12 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362F5C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 03:56:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id e21so5598722ejz.12
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GwQHGXB4kuTmkhxX61KsNK+v4dZ8F5i92XQ76NNSHOI=;
        b=ZcA2PxuQVx40PLSs/G+RVtXsRmxSZj32SsZoL+mHV59DgDw6dTfX5LL96xuAJVEWtC
         Mb47a+YLSYKsrX5pkYNodbBV11LISAEu25GNdsFJ/wleBxxh+7ET3o2vRCh5Db9SncTl
         yZO7cshXbdaw+zzycDYUDHV00AhfNbt3yFLUbT9IOBLk+K1VtrTxC1gYWo37AOlXs04g
         zDV/WNch1CkSC94S7YCbb0+wEpMmHihL1hq1W+fmGQNycNdEyATdGLw4Ifj6nTLMizCU
         YDlxglBNoh689WexrOmnonHDbAyyfIKml5bAdN3h4+w5nFXLiDIfmrxNYgk8okXxsK3e
         RAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GwQHGXB4kuTmkhxX61KsNK+v4dZ8F5i92XQ76NNSHOI=;
        b=m1wrJopX7e0a2768HdM1nH4eLEEzpanGBMet/lKTSrqqx3OOiiKmayyU8qhnfPeCgl
         Y6qd7Ciuchem4vi5TpVikay1KHVKKsUGT4TXjX/i6AlFmT98Hc/hMRNmLv6l9yUcnYVA
         W/gqiSQ6wbF4pyr1/g2wP414Nzc1Xqd24dGkM2rrZVfSM5IIMd3guxp0usyOAV7beTPR
         IzP5/+V4XbLNTkmctNdvj4B87mmc4B5ITrfO6t8mFZGhmfeokL7McUS1YxAlwk+g0uGA
         UGePLeCVKayW9SRkAd3PFrcmeAAVR7wRuIWiI0Yb59kwhZY+Aw7oNZ5oVivTWjSRiKDK
         tUWQ==
X-Gm-Message-State: AOAM530+r/5afCY+xWGclOBH36q6sWp2AKEHhdrxzr4KhG2zY6QAP8HV
        cQgd9FRxtaEL1yOhZorsRUo=
X-Google-Smtp-Source: ABdhPJzqAc2K6UCN2xG2zHl23iE+5nObArAar18mbzmTCQ/IIsbVQC6xnW63yoD+AMzFNcHoCi53BQ==
X-Received: by 2002:a17:906:12d8:: with SMTP id l24mr28715518ejb.126.1630493773734;
        Wed, 01 Sep 2021 03:56:13 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id l16sm9924128eje.67.2021.09.01.03.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:56:13 -0700 (PDT)
Date:   Wed, 1 Sep 2021 13:56:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210901105611.y27yymlyi5e4hys5@skbuf>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 10:25:15AM +0000, Joakim Zhang wrote:
>
> Hi Vladimir,
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: 2021年9月1日 17:22
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com; linux@armlinux.org.uk;
> > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> >
> > On Wed, Sep 01, 2021 at 05:02:28PM +0800, Joakim Zhang wrote:
> > > We can reproduce this issue with below steps:
> > > 1) enable WoL on the host
> > > 2) host system suspended
> > > 3) remote client send out wakeup packets We can see that host system
> > > resume back, but can't work, such as ping failed.
> > >
> > > After a bit digging, this issue is introduced by the commit
> > > 46f69ded988d
> > > ("net: stmmac: Use resolved link config in mac_link_up()"), which use
> > > the finalised link parameters in mac_link_up() rather than the
> > > parameters in mac_config().
> > >
> > > There are two scenarios for MAC suspend/resume:
> > >
> > > 1) MAC suspend with WoL disabled, stmmac_suspend() call
> > > phylink_mac_change() to notify phylink machine that a change in MAC
> > > state, then .mac_link_down callback would be invoked. Further, it will
> > > call phylink_stop() to stop the phylink instance. When MAC resume
> > > back, firstly phylink_start() is called to start the phylink instance,
> > > then call phylink_mac_change() which will finally trigger phylink
> > > machine to invoke .mac_config and .mac_link_up callback. All is fine
> > > since configuration in these two callbacks will be initialized.
> > >
> > > 2) MAC suspend with WoL enabled, phylink_mac_change() will put link
> > > down, but there is no phylink_stop() to stop the phylink instance, so
> > > it will link up again, that means .mac_config and .mac_link_up would
> > > be invoked before system suspended. After system resume back, it will
> > > do DMA initialization and SW reset which let MAC lost the hardware
> > > setting (i.e MAC_Configuration register(offset 0x0) is reset). Since
> > > link is up before system suspended, so .mac_link_up would not be
> > > invoked after system resume back, lead to there is no chance to
> > > initialize the configuration in .mac_link_up callback, as a result,
> > > MAC can't work any longer.
> >
> > Have you tried putting phylink_stop in .suspend, and phylink_start in .resume?
>
> Yes, I tried, but the system can't be wakeup with remote packets.
> Please see the code change.

That makes it a PHY driver issue then, I guess?
At least some PHY drivers avoid suspending when WoL is active, like lan88xx_suspend.
Even the phy_suspend function takes wol.wolopts into consideration
before proceeding to call the driver. What PHY driver is it?

> > Do you know exactly why it used to work prior to this patch?
>
> Yes, since it configures the MAC_CTRL_REG register in .mac_config callback,
> it will be called when system resume back with WoL enabled.
> https://elixir.bootlin.com/linux/v5.4.143/source/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c#L852
>
> If configure the MAC_CTRL_REG register in .mac_link_up callback, when system resume back with WoL active,
> .mac_link_up would not be called, so MAC can't work any longer.
> https://elixir.bootlin.com/linux/v5.14-rc7/source/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c#L1044

Ok, so it worked because phylink_mac_change triggers a phylink resolve,
and that function calls phylink_mac_config if the link is up (which it is),
but phylink_link_up only if the link state actually changed (which it did not).
So you are saying that the momentary link flap induced by phylink_mac_change(false),
which set pl->mac_link_dropped = true, all consumed itself _before_ the actual
suspend, and therefore does not help after the resume. Interesting behavior.
Bad assumption in the stmmac driver, if the intention was for the link
state change to be induced to phylink after the resume?
