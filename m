Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609546B6AF0
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCLUKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 16:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCLUKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 16:10:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012A12B9C5;
        Sun, 12 Mar 2023 13:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EEa+VzyXGmMo8k+OhfFO6nrKKSd1RKBu+PutBDnuaPU=; b=j1nEDkOjxpnnRy0axAW7EmHNun
        n/36i/yQUnBRvy76G6quvVhPn5cPmeG/cbz8OPkzyOIEqlaJ3MYL4REE5sCCWL7NTFBwAVDLrRvUP
        FKH6+T+ohBePyo/iNMIMD9WIFjj75Mrbqpuga9DiME6TLk/uqYJBShxNmqlCsVFMPI1RRA/jW6PuM
        YUCXE+bmzbqsc/gsu3PgZMtILlofxWv+dngPHLlRhGORoQC/p3sws097Kvik2mfU8wk+kU7b+d80O
        /7W5eYyUmcAF2QPu4inYwlpcMcSYSN6qGD92AYRcyev6BuY6lfKNFtBNru70O4HJ2lvLsoh7JncEM
        YVN8npjw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49170)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pbS14-0001rj-JQ; Sun, 12 Mar 2023 20:10:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pbS13-00070e-4S; Sun, 12 Mar 2023 20:10:01 +0000
Date:   Sun, 12 Mar 2023 20:10:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc:
 fix 1000Base-X and 2500Base-X modes
Message-ID: <ZA4xmRTTm0vjHmMN@shell.armlinux.org.uk>
References: <ZAijM91F18lWC80+@shell.armlinux.org.uk>
 <ZAik+I1Ei+grJdUQ@makrotopia.org>
 <ZAioqp21521NsttV@shell.armlinux.org.uk>
 <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <trinity-27a405f3-fece-4500-82ef-4082af428a7a-1678631183133@3c-app-gmx-bap51>
 <trinity-eb5bbb4a-b96f-4436-ae9f-8ee5f4b8fe9b-1678639848562@3c-app-gmx-bap51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-eb5bbb4a-b96f-4436-ae9f-8ee5f4b8fe9b-1678639848562@3c-app-gmx-bap51>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 05:50:48PM +0100, Frank Wunderlich wrote:
> Just to make it clear...the issue with the copper-sfps is no regression of this series it exists before.
> i only had none of them to test for until this weekend....my 1g fibre-sfp were working fine with the inband-flag.
> 
> this patch tries to fix it in mtk driver, this was rejected (as far as i understand it should be handled in phylink core instead of pcs driver).
> and no more in the v13, so we try to fix it another way.
> 
> whatever i do in phylink_parse_mode the link is always inband...i tried to add a new state to have the configuration not FIXED or PHY or INBAND
> 
> drivers/net/phy/phylink.c
> @@ -151,6 +151,7 @@ static const char *phylink_an_mode_str(unsigned int mode)
>                 [MLO_AN_PHY] = "phy",
>                 [MLO_AN_FIXED] = "fixed",
>                 [MLO_AN_INBAND] = "inband",
> +               [MLO_AN_INBAND_DISABLED] = "inband disabled",
>         };
> 
> include/linux/phylink.h
> @@ -20,6 +20,7 @@ enum {
>         MLO_AN_PHY = 0, /* Conventional PHY */
>         MLO_AN_FIXED,   /* Fixed-link mode */
>         MLO_AN_INBAND,  /* In-band protocol */
> +       MLO_AN_INBAND_DISABLED
> 
> is my start the right way?

Oh ffs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
