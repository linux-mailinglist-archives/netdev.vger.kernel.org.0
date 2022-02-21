Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753D94BE40D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378496AbiBUO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:56:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378482AbiBUO4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:56:07 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BCD205F8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:55:43 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vz16so34056060ejb.0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R6tbRgnav0NVatnJIBLZzCorlK7swYro1ARDqOwI80M=;
        b=pt8oL6V2zcvagVDfu2HKkXI9j0akNaeZZMYhTtskAlGNVlqBEBN1d/Ct2LOLPqw0F1
         XN1YusrQyD0/y/0tDj50GuLNThcfmOGtYkX9J4LNuxY9ygj3dQGdeSpthnO9Va21me44
         cDnsdsrJYYCYaaHd5w5++3Fcsg6cR4iy0pqslSoNBA5Fxqu678bbtbPEQy7CW+dNJdK9
         WKnH5AnlVom73EOkT/r6F00Xl6J2/HzbcefQbgwfY0AdY4jHZaSgqq0D6NI0racGaG9l
         71y58oZbU5d50nVz/dMGiguGBoRJUAUJ1D1lq+TVGi0rVpe/K63UcJFZ8Rjze3u4b/Af
         eBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6tbRgnav0NVatnJIBLZzCorlK7swYro1ARDqOwI80M=;
        b=cHTGiI0ruEm2/SVfFxc6zgTamGgEcQB+e1KCxAZ4yKnauXY7c2JWU8+2CvepZ7HHHd
         OMGLuMUDEw+dzgz5fAehaha8GeKTQ6IQAW9niKx5aXEs96pyCC/qLj5p8j+E4f7aDKvP
         YBNCMSPTOhW8qCNFq68NThRvCVl+LcMP+VytAsQSgC+IqAzr7nQ5w8SvBmo18n/wX5wp
         7fSIzwDhZ0+V2BibWteJqqxoUTW87huBLHfNuMHFZ1DfAlfE656r1SkcEnRuZQ298KUk
         q9AphdjRc3/p56KiuiKIMSMcU+zBws4zvAQ4pNK0DZoJAkhGD1n4BZEVux0rEaiEnUTm
         l8lQ==
X-Gm-Message-State: AOAM533To1evnG7V483zliUjBU/h7RjiS8Ukvi+qRNY2Dh2ukR1dx95g
        N4lRj00tvyA8rvLRtH9Mulk=
X-Google-Smtp-Source: ABdhPJynTc9N/ladrXNtZRO6wJUuR3dgXFzR1fsQ0z2/as40/sz9uVHxe5qtOJohP+RaG8KlIctadg==
X-Received: by 2002:a17:907:30cc:b0:6ce:d97:cb0f with SMTP id vl12-20020a17090730cc00b006ce0d97cb0fmr16281044ejb.0.1645455342456;
        Mon, 21 Feb 2022 06:55:42 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id j18sm5257468ejc.166.2022.02.21.06.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 06:55:42 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:55:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220221145540.ek375azxukz3nrvj@skbuf>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
 <20220221143254.3g3iqysqkqrfu5rm@skbuf>
 <YhOlUtcr7CQunM6M@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhOlUtcr7CQunM6M@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 02:44:34PM +0000, Russell King (Oracle) wrote:
> On Mon, Feb 21, 2022 at 04:32:54PM +0200, Vladimir Oltean wrote:
> > Alternatively, phylink_create() gets the initial PHY interface mode
> > passed to it, I wonder, couldn't we call mac_select_pcs() with that in
> > order to determine whether the function is a stub or not?
> 
> That would be rather prone to odd behaviour depending on how
> phylink_create() is called, depending on the initial interface mode.
> If the initial interface mode causes mac_select_pcs() to return NULL
> but it actually needed to return a PCS for a different interface mode,
> then we fail.

I agree. I just wanted to make it clear that if you have a better idea
than a pointer-encoded -EOPNOTSUPP, I'm not bent on going with -EOPNOTSUPP.

> > *and as I haven't considered, to be honest. When phylink_major_config()
> > gets called after a SGMII to 10GBaseR switchover, and mac_select_pcs is
> > called and returns NULL, the current behavior is to keep working with
> > the PCS for SGMII. Is that intended?
> 
> It was not originally intended, but as a result of the discussion
> around this patch which didn't go anywhere useful, I dropped it as
> a means to a path of least resistance.
> 
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk/

Oh, but that patch didn't close exactly this condition that we're
talking about here, did it? It allows phylink_set_pcs() to be called
with NULL, but phylink_major_config() still has the non-NULL check,
which prevents it from having any effect in this scenario:

	/* If we have a new PCS, switch to the new PCS after preparing the MAC
	 * for the change.
	 */
	if (pcs)
		phylink_set_pcs(pl, pcs);

I re-read the conversation and I still don't see this argument being
given, otherwise I wouldn't have opposed...
