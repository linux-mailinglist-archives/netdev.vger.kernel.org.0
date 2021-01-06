Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA12C2EC2A9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbhAFRop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:44:45 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49273 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727176AbhAFRop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:44:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 43878580649;
        Wed,  6 Jan 2021 12:43:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 12:43:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=R9cHpU
        jZgNw/Gcr7ubUDVTY7DA+QU9o1PGZo8Xw6bUY=; b=Hos9Cx2a0cDzhoumhGRd1X
        kYlpGmxWieLWG8JdRmBzGLaJTxLuifz24OY0R1TqYpeQourUBkadhwAVAxvKMQ/b
        YSkt/SNnASdiPEzgHWvw8uHlQ0fknlu1WomAx65xDn6vCV8CiFgEPFbbv/t81ziP
        3C5IXo2Hb2EcQDp2kjDTsjUBLe2/wRYqKtCyLycB5AFu8f7K+mynPpxy2eHyedn8
        b5hzOb/tPX8oSOReVxGbT7T/5TgMvvXM7sPjryxW8zo44Qk6SCi6jZSqMLMpCtlJ
        Y/xyb6wMm0phEGFQvDxSCdr/8+VQl9z9qvSLJk/ID/c5fNfp1CJhGEFKjjktq0bw
        ==
X-ME-Sender: <xms:yfb1X4oXCDlrIm2Vqbp7MW8gD_euosKPqDM9QBRjLqP2NWPx6Rm1gQ>
    <xme:yfb1X-odxjScyPt3HfPVn3TdLy1Y-WxwvJARA5cBTFvI7lVsd9u-NAPZJku56gll9
    4XWob7ETfYadZc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yfb1X9NQU-7lYWK7ZOi2oltnGumqTsrnzTFIghLyg54yAbbFNrZYtQ>
    <xmx:yfb1X_5nfhUk6BjkNLFVbX0JMUrtcZoa8kc5HteyBWELM3Ky_47zJA>
    <xmx:yfb1X34_rBaoA18WPH1O8PAcvhusul98Psj0prrYK59j0DIRBeNLMA>
    <xmx:y_b1XxtqHPzxPeeiz_rzxGhdB-Ql37dXpfFSgKol_oO9vSd8Ddtj7g>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB58F1080057;
        Wed,  6 Jan 2021 12:43:36 -0500 (EST)
Date:   Wed, 6 Jan 2021 19:43:34 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 03/10] net: switchdev: delete
 switchdev_port_obj_add_now
Message-ID: <20210106174334.GB1082997@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:09:59PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the removal of the transactional model inside
> switchdev_port_obj_add_now, it has no added value and we can just call
> switchdev_port_obj_notify directly, bypassing this function. Let's
> delete it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
