Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A2FEC9B9
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKAUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:39:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbfKAUjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YS4a3ZNNWwxoEHS3cJMKgJEYm+W8098i8mBXYJZy+Sg=; b=QcgSnX3g2LtM+hFBG755ZdeUM0
        FD1obClVRdzY0u9JmFIquGe5yYy2FTJuuWytkxGxeRvsJDBcFslHX5IOafBjjT5SOvX4eWhGFh2vY
        GixbmbRnHJApgQYg/sV+Kox6EyFj/wSjXQjzF4SUrrmWhDT9HuPT5gm3y91WbBohRapI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iQdhR-0000Gs-Hl; Fri, 01 Nov 2019 21:39:13 +0100
Date:   Fri, 1 Nov 2019 21:39:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
Message-ID: <20191101203913.GD31534@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029122422.GL15259@lunn.ch>
 <d87c72e1-cb91-04a2-c881-0d8eec4671e2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d87c72e1-cb91-04a2-c881-0d8eec4671e2@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static const struct devlink_ops cpsw_devlink_ops;
> > 
> > It would be nice to avoid this forward declaration.
> 
> It's not declaration, it's definition of devlink_ops without any standard callbacks implemented.

Ho Grygorii

Ah, yes.

How about

= {
  };

to make it clearer?

> > > +static const struct devlink_param cpsw_devlink_params[] = {
> > > +	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_ALE_BYPASS,
> > > +			     "ale_bypass", DEVLINK_PARAM_TYPE_BOOL,
> > > +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> > > +			     cpsw_dl_ale_ctrl_get, cpsw_dl_ale_ctrl_set, NULL),
> > > +};
> > 
> > Is this documented?
> 
> In patch 9. But I'll update it and add standard devlink parameter definition, like:
> 
> ale_bypass	[DEVICE, DRIVER-SPECIFIC]
> 		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes
> 		Type: bool
> 		Configuration mode: runtime

And please you the standard file naming and location,
Documentation/networking/devlink-params-foo.txt

Thanks
	Andrew
