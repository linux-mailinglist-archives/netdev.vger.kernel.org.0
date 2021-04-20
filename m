Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2DA365B06
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhDTORg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbhDTORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:17:34 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFF8C06174A;
        Tue, 20 Apr 2021 07:17:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so15073188pjl.5;
        Tue, 20 Apr 2021 07:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UIwFEv9Tdve32KSnkSNK+uSX3oxpeexxuh6b/UYPgCA=;
        b=SVEcqqjQDN+pAb0FIxomH9lnECcqwn9ioGJB9rPdblKTm7CUPl8CyfcBY6DPk9m5bl
         8I34DXZGVDDuQvmeUuVsJLfTC6NR6HJO3DP6i6u1PMF5KRVmmHZi5IIu6MYiEyq1STPy
         uxlO6pWQvh5+7g/JvtLx/U0VXoHLS7RM1+I9RP2XCEVKjt4YzTcfo27djQt3bxpzpil3
         HVRhjc1lpZ6fYLoCPVfCFZO7FMHgx81Ck4m/B9TnARILbI0ag1YBgn3og098g37TVJfB
         hX4950RCUvVA7ygIIGjmypEbXdaOXaJPRyHH5FJrrBIiE9BnmbYS4fFS5jslSoRtEU7Z
         8Cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UIwFEv9Tdve32KSnkSNK+uSX3oxpeexxuh6b/UYPgCA=;
        b=cKBA2rBuJktWcX/NY9Gw+jRlH4HVFQCciRtrnwbXRmwAygLod/by9c1EZQLZFPoifv
         8yfZVYiSP+CozUnTLXR2O9fX4o7/pcUcv72t7h4cjGk7FWEV8aYiiHZqNnJb5tJiz/yD
         +2QWQt9wm5voHUAmKnaZsA7O3O4CI9gsF8WYpb+nAHrRbyLf7bjBpy3spWZUttKskGn6
         8XPKvXUMnTSF7yjhXkN3FFpWGmb9Ze+xR/Bjrueom6NUA8mexmPkILrtG1AXNNMWB09Y
         1BNHSeh/a/18tDy0SJacFM5kL+F0Ez6ebLbdDxBfrZ8EOpBlLNHW8Z86bzfeX0+zdtZ/
         x2cg==
X-Gm-Message-State: AOAM530lGzg4etfABD98kk2aceoXkMtrdWoUghX06hD4PIasAMZQWifm
        q7VhNAwgh/qED1IRfz2EWwDPm1ZrM6gy9w==
X-Google-Smtp-Source: ABdhPJzXtzkAoARVl/ZAB0IWlrCrIq1zqmNiZzSkH0EZZ+WVcYo5/766QHPAgnecFpGimAIs4eLLdg==
X-Received: by 2002:a17:90a:684b:: with SMTP id e11mr5387090pjm.87.1618928221826;
        Tue, 20 Apr 2021 07:17:01 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a27sm3380347pfl.64.2021.04.20.07.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:17:01 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:16:50 +0300
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
Message-ID: <20210420141650.hiu6feeaj7zrdmco@skbuf>
References: <20210416234225.3715819-1-olteanv@gmail.com>
 <fa2347b25d25e71f891e50f6f789e421@walle.cc>
 <20210420140433.hajuvfiz4humhhkt@skbuf>
 <0bf4aa61dea7be0723fda2d8597644ad@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bf4aa61dea7be0723fda2d8597644ad@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 04:10:34PM +0200, Michael Walle wrote:
> Hi Vladimir,
> 
> Am 2021-04-20 16:04, schrieb Vladimir Oltean:
> > On Tue, Apr 20, 2021 at 03:27:24PM +0200, Michael Walle wrote:
> > > Hi Vladimir,
> > > 
> > > Am 2021-04-17 01:42, schrieb Vladimir Oltean:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > This patch series contains logic for enabling the lossless mode on the
> > > > RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> > > > memory.
> > > >
> > > > During testing it was found that, with the default FIFO configuration,
> > > > a sender which isn't persuaded by our PAUSE frames and keeps sending
> > > > will cause some MAC RX frame errors. To mitigate this, we need to ensure
> > > > that the FIFO never runs completely full, so we need to fix up a setting
> > > > that was supposed to be configured well out of reset. Unfortunately this
> > > > requires the addition of a new mini-driver.
> > > 
> > > What happens if the mini driver is not enabled? Then the fixes aren't
> > > applied and bad things happen (now with the addition of flow control),
> > > right?
> > > 
> > > I'm asking because, if you have the arm64 defconfig its not enabled.
> > > 
> > > shouldn't it be something like:
> > > 
> > > diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig
> > > b/drivers/net/ethernet/freescale/enetc/Kconfig
> > > index d88f60c2bb82..cdc0ff89388a 100644
> > > --- a/drivers/net/ethernet/freescale/enetc/Kconfig
> > > +++ b/drivers/net/ethernet/freescale/enetc/Kconfig
> > > @@ -2,7 +2,7 @@
> > >  config FSL_ENETC
> > >         tristate "ENETC PF driver"
> > >         depends on PCI && PCI_MSI
> > > -       depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
> > > +       select FSL_ENETC_IERB
> > >         select FSL_ENETC_MDIO
> > >         select PHYLINK
> > >         select PCS_LYNX
> > 
> > Yes, ideally the IERB driver and the ENETC PF driver should be built in
> > the same way, or the IERB driver can be built-in and the PF driver can
> > be module. I don't know how to express this using Kconfig, sorry.
> 
> With the small patch above it is:
>  FSL_ENETC=m -> FSL_ENETC_IERB = m or y
>  FSL_ENETC=y -> FSL_ENETC_IERB = y
>  FSL_ENETC=n -> FSL_ENETC_IERB = m,y or n
> 
> Will you fix it? Should I prepare a patch?

Could you please send the patch? Thanks.
