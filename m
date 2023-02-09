Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29834690A60
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBINgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:36:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF425EF86;
        Thu,  9 Feb 2023 05:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fx8iFMyCgB7HyH9Espp2nPfUarro5nGFLOTsVtWbQy4=; b=il8XwAwgfriM/TQ67AvQ/ELfHn
        45/8Ohlp9aNmk5CqLahp8zYrY5WeDJK49EOhjHjpgXM2JkQehsmnQokacz2o4jxinJLBPHqPRmSZX
        ZypWC3WL2z+RcTYnr3aydaJGlJhdn6d/fVBdpfuqE65AbrB0SOQO+ZkI+bo6xBhyasZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQ75G-004VPn-Ja; Thu, 09 Feb 2023 14:35:30 +0100
Date:   Thu, 9 Feb 2023 14:35:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
Cc:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Message-ID: <Y+T2oku3ocAuafe0@lunn.ch>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
 <Y+REjDdjHkv4g45o@lunn.ch>
 <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
 <DB9PR04MB81063375BAC5F0B9CBBB6A0D88D99@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <60f22dab4c51ee7e1a62d91c64e55205c18b9265.camel@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60f22dab4c51ee7e1a62d91c64e55205c18b9265.camel@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You are right, there is unfortunately no i.MX8 support in the upstream
> tree, so it's not possible to reproduce anything.

commit 947240ebcc635ab063f17ba027352c3a474d2438
Author: Fugang Duan <fugang.duan@nxp.com>
Date:   Wed Jul 28 19:51:59 2021 +0800

    net: fec: add imx8mq and imx8qm new versions support
    
    The ENET of imx8mq and imx8qm are basically the same as imx6sx,
    but they have new features support based on imx6sx, like:
    - imx8mq: supports IEEE 802.3az EEE standard.
    - imx8qm: supports RGMII mode delayed clock.

Are you using some other imx8 SoC?

> Just wanted to discuss the probe concept of this driver, which is
> rather fragile with all there static local variables, probe call
> counters and relying on the probe order. All of this falls together
> like a house of cards if something gets deferred.

I agree with the comments about it being fragile. It would be good to
get all the naming from OF nodes/addresses. But it needs doing by
somebody with access to a test farm of lots of different boards with
IMX2/5, IMX6 through to 8 and Vybrid.

    Andrew
