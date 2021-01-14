Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2324D2F5960
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhANDbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:31:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbhANDbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:31:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C162376E;
        Thu, 14 Jan 2021 03:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595035;
        bh=rqT1SPq1HqR/g3z7jDbJZ+QXwPtGXQvq14DJ6zclXLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S54VCsyRmyc/+VUJYPbjeVijIyC8NfVdtqJ2REi2yHNxl/avS5iQ/BJ7WcIZJdm3Y
         AUgamHjzIJ5aMpKwmvAXFTixPT3HvVxf+YVQFFFXz2cAJc7wjdqjlYDpmEq3cr6yMJ
         bafT0x+SP0w/PWXgnLGlpqBN5BaVA4wFjQbOaH59Nyccie8+J8p50Q1NJVhSS2olxw
         /qDdzovjHZRSs53JT34vdneq38eLmTi87TRHKQ1WvaALgeWGlSUFIOgsMkdI8MgvpH
         MiEdWPsAVr+DqWsuwi1Rt05C7xUKKioMKSOlTd0Pt1VNTEa96if9a04Ei2hT8iMbxG
         DCfycPrUqa2BA==
Date:   Wed, 13 Jan 2021 19:30:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210113193033.77242881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111174316.3515736-9-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
        <20210111174316.3515736-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:43:14 +0200 Vladimir Oltean wrote:
> +struct ocelot_devlink_private {
> +	struct ocelot *ocelot;
> +};

I don't think you ever explained to me why you don't put struct ocelot
in the priv.

-	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
-	if (!ocelot)
+	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
+	if (!devlink)
                 return -ENOMEM;
+	ocelot = devlink_priv(ocelot->devlink);
