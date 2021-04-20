Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0DA365AC1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhDTOFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhDTOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:05:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66045C06138A;
        Tue, 20 Apr 2021 07:04:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g1-20020a17090adac1b0290150d07f9402so1855625pjx.5;
        Tue, 20 Apr 2021 07:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GWZ9/iUv0FXDeIpnx9QoQpsz7gywyohQ1hXkns45YHk=;
        b=ZaRkSt5KlIUTQC5awcwrSay8EjrsfYLcEGIdVI/hfGabX8AQ85CfLf8aMjKJkKmvzW
         1om80L/5MfBcQD5KiyZrfZCZlp+ylttGuHF9xA96nGcI7Bkz1EJdbTu5HlfpMbu4X9KN
         LyyPh0PxEuA9ckcSoX+tH/t1DBwMj63PVbUpWasTCQ0IC2t/y7XhTnsV8f83Nzkgv9ya
         +1DMuh9o7rwi9/X4F7yMVwvGz7c6uKljqB9mrs3T2r4pEOd4c2Y8UxcOLFK7yEu8EjU0
         wsJ8yVhz4EKieCxilWO3+flHeFTpShUfPBBIPSU5KAN7QAcANZTJA6WuGjvQA2TOLXlL
         RR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GWZ9/iUv0FXDeIpnx9QoQpsz7gywyohQ1hXkns45YHk=;
        b=K24R0nonKKff0mTMpn8q8jKK1ErlINDQ6ircA1wQQGXwyY5Vwp2z+YeKOd6nHWFsI1
         KSJyFsoEZKNiNZBkhivlaHjUehRe7nH8NV6T/nDZiMRA1BSXAmvpu0ZwgyiX/ypllGKd
         x9fz5ODcAcaEHOFp9C6aZyywx2YiyJUZUn61Wbdn/bVl9e/9eVMC8ynFOksAZBajoMt3
         P6EDkMxWP6uqXxQ7hgC9mu/nH96yOirAoFBEK9L7MT4BRgkz/XhJYkcH3oyMbmGmo43z
         YAtdMqNJDMj8DNVrmI7yMt3GiiZ7RQf1dPTcRhTmkLss9AtGMLdMcVb7hYaKLgyzINNA
         8F2A==
X-Gm-Message-State: AOAM531w7EmteUMDgxu4LdQtNT7yUJ9vf9qUeLQTtcs38KGnUvEtvKzQ
        ZMV9RSjMpmSFcjnVaJEKdAlylp2S4DBB+Q==
X-Google-Smtp-Source: ABdhPJxa+tOj6HMWgne03HIClGYrmW6UvTyxsScQNcsf2xFSurAAxJcynVxP2gTfZ3ds5HO10TPRfA==
X-Received: by 2002:a17:902:f54d:b029:ec:939f:747d with SMTP id h13-20020a170902f54db02900ec939f747dmr16157951plf.84.1618927485895;
        Tue, 20 Apr 2021 07:04:45 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id hi5sm2600734pjb.31.2021.04.20.07.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:04:45 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:04:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
Message-ID: <20210420140433.hajuvfiz4humhhkt@skbuf>
References: <20210416234225.3715819-1-olteanv@gmail.com>
 <fa2347b25d25e71f891e50f6f789e421@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa2347b25d25e71f891e50f6f789e421@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, Apr 20, 2021 at 03:27:24PM +0200, Michael Walle wrote:
> Hi Vladimir,
> 
> Am 2021-04-17 01:42, schrieb Vladimir Oltean:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > This patch series contains logic for enabling the lossless mode on the
> > RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> > memory.
> > 
> > During testing it was found that, with the default FIFO configuration,
> > a sender which isn't persuaded by our PAUSE frames and keeps sending
> > will cause some MAC RX frame errors. To mitigate this, we need to ensure
> > that the FIFO never runs completely full, so we need to fix up a setting
> > that was supposed to be configured well out of reset. Unfortunately this
> > requires the addition of a new mini-driver.
> 
> What happens if the mini driver is not enabled? Then the fixes aren't
> applied and bad things happen (now with the addition of flow control),
> right?
> 
> I'm asking because, if you have the arm64 defconfig its not enabled.
> 
> shouldn't it be something like:
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig
> b/drivers/net/ethernet/freescale/enetc/Kconfig
> index d88f60c2bb82..cdc0ff89388a 100644
> --- a/drivers/net/ethernet/freescale/enetc/Kconfig
> +++ b/drivers/net/ethernet/freescale/enetc/Kconfig
> @@ -2,7 +2,7 @@
>  config FSL_ENETC
>         tristate "ENETC PF driver"
>         depends on PCI && PCI_MSI
> -       depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
> +       select FSL_ENETC_IERB
>         select FSL_ENETC_MDIO
>         select PHYLINK
>         select PCS_LYNX

Yes, ideally the IERB driver and the ENETC PF driver should be built in
the same way, or the IERB driver can be built-in and the PF driver can
be module. I don't know how to express this using Kconfig, sorry.
