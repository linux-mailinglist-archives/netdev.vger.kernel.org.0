Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C43C36AB
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhGJUCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:02:01 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A775C0613DD;
        Sat, 10 Jul 2021 12:59:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hc16so23754073ejc.12;
        Sat, 10 Jul 2021 12:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Udxr2pk5ZrdHgL88c1gZyLSsUDHuHRik6kMAroTBdyo=;
        b=NucATfMYLX4hdjS8fAJuY3Dcgf1ccYNn2p6Qc2uhoeIZ93hxzKC/+wObQRHK+uN+qC
         NGAKtgfiKz4IcjQtvLK4+uAmcI8A0SfeweH4aZ78Kv+mmy6FsH/GxuJr4ptFZ9qq2GbH
         GGLr8zPVq8q4+/KEc5B/2mbPeDdu3VFH2TGFTfXzicnzIPP+NRqz0WFqTOm2yDM32yPR
         YZqCqhzISew5Rw4k3wpe6ya100cg/d8PnhRpaujz4bNWywhtc8MWYN2m/DF6s8n5CksQ
         5bDBL/kKYzDxtRtbLp584Ge56BBux3COby4wgJ34dkqpml/Hi2OvzCk8mQV4SkigyllV
         roGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Udxr2pk5ZrdHgL88c1gZyLSsUDHuHRik6kMAroTBdyo=;
        b=rJJORsddHl25qdjSL3QtaYEODecH3ReCy2BbOkJ+DjfHDHfXtaae3XjeKtX+N4Zaiy
         ajj8HNBdzy3rLCYWg8FeHvqOdZ+CAvpX9p8RBh/J/99waxERds3bfpmDAhNsTa/n98TW
         fA9yVPTTtnD6Kkr+KiMLbYiVioe4ZzShw0TfohaChcj1YnuObZCpEzErUT/3Rq0lIGli
         fG2EFqprcJxxTxPKjbIsAayazZ+o4E3vDdGR/PuzoqxTF2DkK8xqPEacTxp7PUk5OpBa
         H6xXkUOfQNLkshdyFdyk3qfG5p0/pcViCe/86Q3vwiQm80wI5KBWj5Ozfcnu2etldHf8
         sJ3A==
X-Gm-Message-State: AOAM531GFFilQPBXq2h9rGril7WIvCIXh/zZnt5K/vKftp7/wYhf3Syu
        ufecQajDiuJuK+lJ15FnbMw=
X-Google-Smtp-Source: ABdhPJyNp6JaUJIbByUTZjOSglRvy6gr/p47WOMtWrriOR30LOau66Wu00yMyrHtT1wkFHqVZZJGwQ==
X-Received: by 2002:a17:906:c34b:: with SMTP id ci11mr18852910ejb.223.1625947154680;
        Sat, 10 Jul 2021 12:59:14 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id z10sm4960601edd.11.2021.07.10.12.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:59:14 -0700 (PDT)
Date:   Sat, 10 Jul 2021 22:59:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 2/8] net: dsa: ocelot: felix: move MDIO
 access to a common location
Message-ID: <20210710195913.owqvc7llnya74axl@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-3-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:25:56PM -0700, Colin Foster wrote:
> Indirect MDIO access is a feature that doesn't need to be specific to the
> Seville driver. Separate the feature to a common file so it can be shared.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

In fact, this same piece of hardware has a dedicated driver inside
drivers/net/mdio/mdio-mscc-miim.c. The only problem is that it doesn't
work with regmap, and especially not with a caller-supplied regmap. I
was too lazy to do that, but it is probably what should have been done.

By comparison, felix_vsc9959.c was coded up to work with an internal
MDIO bus whose ops are implemented by another driver (enetc_mdio). Maybe
you could take that as an example and have mdio-mscc-miim.c drive both
seville and ocelot.
