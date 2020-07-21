Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE60227666
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgGUDI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:08:57 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57536 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGUDI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:08:56 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06L38T5M067344;
        Mon, 20 Jul 2020 22:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595300909;
        bh=eQGqxP1QWHp4sxGYk/YkYc0H0zt+vKwY/jDQBq7XFtU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=J383kpAi1TnccBq+kgRzAXc9Ox2mEIVibxoA8Iq5yLGQ3UjtYJPa9NoqGODp6yGVt
         pSaojeK5mDEnCw/Qh7+HdfEG1Em8mrLbAa8Fy3xZam0b1dBJ1jIp4Mr8vkAxZfiws2
         OEevvoTGEaicRfdE9jh2y3bA3Hz7IUVS/GkQp7XY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06L38Tp0113319
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 22:08:29 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 22:08:28 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 22:08:28 -0500
Received: from [10.24.69.198] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06L38OVg050719;
        Mon, 20 Jul 2020 22:08:25 -0500
Subject: Re: [PATCH] ARM: dts: keystone-k2g-evm: fix rgmii phy-mode for
 ksz9031 phy
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <ssantosh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20200715085427.8713-1-grygorii.strashko@ti.com>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <f35d8ae5-c0f8-dcb2-f2f7-a4e56ea03825@ti.com>
Date:   Tue, 21 Jul 2020 08:38:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200715085427.8713-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

On 7/15/20 2:24 PM, Grygorii Strashko wrote:
> Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
> KSZ9031 PHY") the networking is broken on keystone-k2g-evm board.
> 
> The above board have phy-mode = "rgmii-id" and it is worked before because
> KSZ9031 PHY started with default RGMII internal delays configuration (TX
> off, RX on 1.2 ns) and MAC provided TX delay by default.
> After above commit, the KSZ9031 PHY starts handling phy mode properly and
> enables both RX and TX delays, as result networking is become broken.
> 
> Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
> behavior.
> 
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Philippe Schenker <philippe.schenker@toradex.com>
> Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Fix for one more broken TI board with KSZ9031 PHY.

This is coming bit late, but its important to get into v5.8 since NFS
boot fails without this blocking all mainline testing for this platform.

Can we send this to ARM SoC for -rc7. If you are going to be busy this
week, I am happy to send a pull request on your behalf with your ack
included. Let me know.

Thanks,
Sekhar
