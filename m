Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E53373370
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhEEBIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 21:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhEEBIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 21:08:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2A6C061574;
        Tue,  4 May 2021 18:07:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id bf4so12594201edb.11;
        Tue, 04 May 2021 18:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=crK4YYFoFhZe/LEhsOWEgXs311qsi121FrLKq410wFg=;
        b=GWzn1iUXRMpF3MDZ0Dzw1GA/VEsYSOgothjRHcsRGsK+xFzs1LO6A/uMmgb7LW055Q
         04IjL0Es8oM4FeQq5JSo4tD/upwYEj8HChN82fJOThptlTaRW5pcVlxHrdJ9gZGV4gkV
         iUEv7dFcPzzrabC5Osklwey63FbPDUJRd3nQy9u76gHhc3WpJcG3+Yxpn0j7/cvA36k3
         RabmZHU6nmSsZVHnau4eml0GsfEX/KmpuznQDYGOAMs6ncUb/8c3dBPCnI5tgRHvc4WL
         MaQoRp8u1LdmrNzd27MkvBY3T3m47Oksvut4dS8Ct/VmqDvlLv4prjt0K5NKS4IL11JP
         F15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=crK4YYFoFhZe/LEhsOWEgXs311qsi121FrLKq410wFg=;
        b=WUHsNqCTp8uUnsQ/k1UAheOyKgWYaNuAwnb1XBEBKSCcaczuuQvimKfwq1E6ajRfU+
         F4+xDgX4md8T6JiwOpNK6ZfSwaxLkUywfOLujrwnLTearqjpAz9+VkrnvawjVQGTXH/E
         sIgUgrF/TMCmgTjrVmwIaQQ14HVmOIgIPSfTEfvWn6PAw8xmaIFR12AK/u8EdgVnieH9
         5QEwKMbmYVq/u+eLXw19kACS8wbVvXckr9vCS5aT+fZOjZgd1jDI59NzwsqZxijmjZ+i
         mP3/zE93bzZ1nbqL6MMXVRcAalLtvv5s8JmfVydabKmD3JYLQoj8MZUmLxX62Vz+HTvs
         8/7Q==
X-Gm-Message-State: AOAM530ZXmNMtLIA6QxrtvekJc8/zd6SUBRjyp7322iqq3PWJmGPDKjc
        FzVmeN7f+LgWnV9BjXD7WUw=
X-Google-Smtp-Source: ABdhPJwmLLQsOGsjnzd77aTw3yReydobuTsCPXITFRdn8ukNEV+PTmdEyErcQSmnzG1lGTunGaUNtw==
X-Received: by 2002:aa7:de02:: with SMTP id h2mr29039005edv.61.1620176832632;
        Tue, 04 May 2021 18:07:12 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id p21sm15599227edw.18.2021.05.04.18.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 18:07:12 -0700 (PDT)
Date:   Wed, 5 May 2021 03:07:15 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 13/20] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJHvw3AZkzJSiqov@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-13-ansuelsmth@gmail.com>
 <YJHuPdyj9B19sbUJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHuPdyj9B19sbUJ@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 03:00:45AM +0200, Andrew Lunn wrote:
> On Wed, May 05, 2021 at 12:29:07AM +0200, Ansuel Smith wrote:
> > The legacy qsdk code used a different delay instead of the max value.
> > Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
> > using the standard rx/tx-internal-delay-ps ethernet binding and apply
> > qsdk values by default. The connected gmac doesn't add any delay so no
> > additional delay is added to tx/rx.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
> >  drivers/net/dsa/qca8k.h | 11 +++++----
> >  2 files changed, 55 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 22334d416f53..cb9b44769e92 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -779,6 +779,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
> >  	return 0;
> >  }
> >  
> > +static int
> > +qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
> > +{
> > +	struct device_node *ports, *port;
> > +	u32 val;
> > +
> > +	ports = of_get_child_by_name(priv->dev->of_node, "ports");
> > +	if (!ports)
> > +		return -EINVAL;
> > +
> > +	/* Assume only one port with rgmii-id mode */
> > +	for_each_available_child_of_node(ports, port) {
> 
> Are delays global? Or per port? They really should be per port.  If it
> is global, one value that applies to all ports, i would not use
> it. Have the PHY apply the delay, not the MAC.
> 
>     Andrew

It's expected to set the delay in the port node. But yes the value is
global and assigned to every port (in reality this is only assigned to
the unique rgmii cpu port). The switch has only one rgmii port
and one sgmii, that's why I skipped any logic about handling more than
one case with internal delay. If you want I can try to add some logic to
handle this value per port. But again on the switch there is only one
reg to set the delay and the qca8k_phylink_mac_config function use this
only for the rgmii cpu port.


