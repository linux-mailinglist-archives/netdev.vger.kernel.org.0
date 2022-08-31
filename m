Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771EA5A810D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiHaPTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiHaPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:19:08 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9349BD87C0;
        Wed, 31 Aug 2022 08:19:05 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id p16so25931450ejb.9;
        Wed, 31 Aug 2022 08:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AjYYOLxvx2jekNqZDl7wXYDi23BDknMWSlc/IN0+80w=;
        b=gxttH2CPeop7edLLlVSsCMw39O3HAAMttx2XsBwtoFGQPveBRn3aPIM764gX8UClYr
         NVOrNviKHnWMvfTEsbiAe+Wo/Ee70rh9VhyGR0fy5LD2aV/FepKFxLpppAVaEhP/gTxc
         Y3I4aIHOMTGYJ7jsTfdE0G+pEz8PsDKYXWBCDmfQcriWEj9vmUAKFfaQrfzw6K9bHuoA
         SaZMe/XcJvmiC6k8qwoQCFGF9CYGTB6SurnB2zuLy5QjmhZQ+f6idqUXmLYPLAGOZ8lh
         KUOY0oGre3ewh+zXDyPyU6VSvumGOfaZ83UVdLdd8e8Vc4ilFQJZ/gZNl9bXE2YeVkgT
         THRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AjYYOLxvx2jekNqZDl7wXYDi23BDknMWSlc/IN0+80w=;
        b=Tmtn4k/F/H+uRJyQj4sW0l+Qn6JJfOToPH7ZMHnXcaRBuycygzzqM+TwNTrCfAT7lc
         viuCwVAi3efr4VRum7Xr18p5k3D9Ql19hF0a15fy3dGWW7edR6GAI6s4LnFs4PttvGB7
         bBinbvqMAXV+jbrLow9pKeYwBBw11LeCJqCGBQ5DrRqssH5ZZ3rZ9F0qBjkpH0a/d6wT
         pkAKRGGt0Tq2yWcOn3+zGzdBa1asiG+Ykfyk/8g/alCbuhggLgeNDRHxIK5sgF+ya0Y+
         sBrvsQGVFA5mNQb88HSInnbPGOLQ8dTfJeiJZ1hjbNeFHRSCyhOzSpTW2wFSTzGrfrBO
         nTVw==
X-Gm-Message-State: ACgBeo2X8PvQVK5YAl3jQKtaSfiYz2wMQGPlEYIT7m51cEdUJj9kZHN1
        GTEQuknox7Rsa/Ag+vAcaWw=
X-Google-Smtp-Source: AA6agR4oD3Rcr7CT1xO+iy9feSh+QRmmT98lFp8l224tccLLOjIqkOASrSICqWAxR+mptfBrQlQnDQ==
X-Received: by 2002:a17:906:cc16:b0:73d:c874:f89e with SMTP id ml22-20020a170906cc1600b0073dc874f89emr21420540ejb.666.1661959143391;
        Wed, 31 Aug 2022 08:19:03 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id a3-20020a1709063e8300b0072b3406e9c2sm7270743ejj.95.2022.08.31.08.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:19:02 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:18:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Arun.Ramadoss@microchip.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, san@skov.dk, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220831151859.ubpkt5aljrp3hiph@skbuf>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
 <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
 <20220830095830.flxd3fw4sqyn425m@skbuf>
 <20220830160546.GB16715@pengutronix.de>
 <20220831074324.GD16715@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831074324.GD16715@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 09:43:24AM +0200, Oleksij Rempel wrote:
> > > Should we point them to ksz8795_xmii_ctrl0 and ksz8795_xmii_ctrl1? I don't know.
> > > Could you find out what these should be set to?
> > 
> > xmii_ctrl0/1 are missing and it make no sense to add it.
> > KSZ8873 switch is controlling CPU port MII configuration over global,
> > not port based register.
> > 
> > I'll better define separate ops for this chip.
> 
> Hm, not only KSZ8830/KSZ8863/KSZ8873 are affected. ksz8795 compatible
> series with defined .xmii_ctrl0/.xmii_ctrl1 are broken too. Because it
> is writing to the global config register over ksz_pwrite8 function. It
> means, we are writing to 0xa6 instead of 0x06. And to 0xf6 instead of
> 0x56.

What do you mean by "global config register"? The Is_1Gbps bit is still
part of a port register, it's just that this particular register is only
defined for the 5th port (port #4, the only xMII port on KSZ7895 AFAIU).
That doesn't necessarily make it a "global" register.

Datasheet says:

Register 22 (0x16): Reserved
Register 38 (0x26): Reserved
Register 54 (0x36): Reserved
Register 70 (0x46): Reserved
Register 86 (0x56): Port 5 Interface Control 6

I wonder if it's ok to modify the regs table like this, because we
should then only touch P_XMII_CTRL_1 using port 4:

 static const u16 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
 	[REG_IND_DATA_CHECK]		= 0x72,
 	[REG_IND_DATA_HI]		= 0x71,
 	[REG_IND_DATA_LO]		= 0x75,
 	[REG_IND_MIB_CHECK]		= 0x74,
 	[REG_IND_BYTE]			= 0xA0,
 	[P_FORCE_CTRL]			= 0x0C,
 	[P_LINK_STATUS]			= 0x0E,
 	[P_LOCAL_CTRL]			= 0x07,
 	[P_NEG_RESTART_CTRL]		= 0x0D,
 	[P_REMOTE_STATUS]		= 0x08,
 	[P_SPEED_STATUS]		= 0x09,
 	[S_TAIL_TAG_CTRL]		= 0x0C,
 	[P_STP_CTRL]			= 0x02,
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
-	[P_XMII_CTRL_1]			= 0x56,
+	[P_XMII_CTRL_1]			= 0x06,
 };

Arun, what is your proposed solution?
