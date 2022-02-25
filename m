Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8684C4395
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbiBYL05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240143AbiBYL0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:26:45 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631E61DBA8C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:25:54 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vz16so10319089ejb.0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UhJpIBqeAhff5vkCAqwKxmWQw0UfgDIqXoOiorspq1E=;
        b=lr9sf2yE23o9nebJfHdo7WPPScauuiWge11lW3boSFhjZzFFxs/JcTn87ilbD0XoUj
         Ot/ObYp8SqSpcDIMhyiOSC0oZ8NUUs+OKUhVBO1YSu/KzrVNg7Rw/5NUje033eJcSY1Y
         JwxpUOuCv8p5JXoVUCp6rWRqFMj/SWgmGQWacd6MFWKXaH69/CBjGWM9sBmj6Q+BFPP8
         ZmLSJ9XyjVGqTBP7w3pA4lnuob4iS2DBgZT4+tWen4vg+ixGlsdqCTiO5jm0/G/lVuIF
         NVp71g9nsQPPba/OIY51xPncejFByJ7xb3h82OZUU2nDOL/LH8yxFtr3Uwr+kfCVBCL1
         yilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UhJpIBqeAhff5vkCAqwKxmWQw0UfgDIqXoOiorspq1E=;
        b=NiLdnUgXhjaOSuPmmpVYxw+FSuoYxU0iMreaKe2Bs7tPoxScBnotBbm8h7oeneixJ4
         dtTP2nwDSk1C4PkwSHdHLqODDZdK/v/GTvhxdmR/nv+tbHKaKgB9OIUiehfrLMh2Xvmt
         OKn0m/XhVpSGqVbyN9gWmMKe4kM6yaxYRoVkhZNJkOPYC1gwNVnU2bN2aGIFKeKDyywi
         ucsH96qeHzfTtowZQdcQLmDGEGUW8/Px3GGtHjfd3UR492MmjrgBXOwujFGuvwmcDSde
         +4a6jHXqFneOezB0twWwL8KBSwFofMhanLLrfWwKgwmmUulPE8v1KE0iFD+t/CQ25IRw
         lhFg==
X-Gm-Message-State: AOAM532fLuPqmm2vaJMrWHmzfASXGourots8LC0KyKSyb9AYg+Xx5EYV
        u9KxMBRda+qy0EvQvJd8LiI=
X-Google-Smtp-Source: ABdhPJy6gL6iei+oIZ/nageVjd9G/lxEHm3PoBXNarmQpAH68pXPyAE6WPc01XugPLInqOTmCxAg6Q==
X-Received: by 2002:a17:906:f74c:b0:6ce:709a:368a with SMTP id jp12-20020a170906f74c00b006ce709a368amr5868277ejb.655.1645788352547;
        Fri, 25 Feb 2022 03:25:52 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id bm23-20020a170906c05700b006d597fd51c6sm899617ejb.145.2022.02.25.03.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:25:52 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:25:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/6] net: dsa: sja1105: use
 .mac_select_pcs() interface
Message-ID: <20220225112550.33psz64i6eekmld5@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGm6-00AOip-6r@rmk-PC.armlinux.org.uk>
 <20220225103913.abn4pc57ow6dy2m6@skbuf>
 <Yhi2JHfZ+QI95J9V@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhi2JHfZ+QI95J9V@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 10:57:40AM +0000, Russell King (Oracle) wrote:
> > > -	.phylink_mac_config	= sja1105_mac_config,
> > 
> > Deleting sja1105_mac_config() here is safe not because
> > phylink_mac_config() stops calling pl->mac_ops->mac_config(), but
> > because dsa_port_phylink_mac_config() first checks whether
> > ds->ops->phylink_mac_config is implemented, and that is purely an
> > artefact of providing a phylib-style ds->ops->adjust_link, right?
> 
> Yes and no.
> 
> We already have a several DSA drivers that have NULL phylink_mac_config
> and that don't provide an adjust_link function. Even if adjust_link was
> eventually killed off, the test in dsa_port_phylink_mac_config() would
> still be necessary unless all these DSA drivers are updated with a stub
> function for it.
> 
> Consequently, I view phylink_mac_config in DSA as entirely optional and
> that optionality is already very much a part of the DSA interface, even
> though that is not the case with the corresponding phylink_mac_ops
> .mac_config method.
> 
> Moreover, this optionality is a common theme in DSA switch operations
> methods.
> 
> > Maybe it's worth mentioning.
> 
> Given that .phylink_mac_config is already established as being optional
> in DSA, does the addition of one more instance need to be explicitly
> mentioned?

I am aware of that, I am just pointing out that this is an unintended
side effect of the existence of adjust_link, and non-DSA phylink drivers
still need the mac_config stub. When going back and forth between a DSA
and a non-DSA driver, this is not obvious until you take into account
the dsa_port_phylink_mac_config() trampoline. Anyway, don't mention it
if you don't think it is necessary.
