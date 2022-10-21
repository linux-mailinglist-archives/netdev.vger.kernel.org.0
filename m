Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C22B60733C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiJUJGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiJUJGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:06:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A914A1B65D4;
        Fri, 21 Oct 2022 02:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Btl6lB7/jBAwJDOo52HZvR/bEdbyeTvFLPuY3K4Zko0=; b=pyplzieDCI1Jkh1GoGLbvsYVVx
        uHCqQJzf9myydjTTCZyJlfAgIL1Ad0QHfgNBMrbpvkz7KgN1NltByM6anYZbVpEgik+sT8GiBRbAT
        003jASt0qJW3q47hyaUXY64m2CxLNu4WQ7Emdhdc804IodgwWCgGWPPZN6k0zHLCnvWsiAGQf5Ue8
        V/plhE17pQYby+ANZNCJzfQM3Bk0iBn/UjzZcx62Xbi8kABllHXJLFTR+reIcdzdrFJHv5LHpqIi6
        hJLuuJb6YzhZpjpzeiql/TKGeFMOoYRkwlvDaqIW6SALh19LUTHxkNhnXwgZKfqymljlkOrHSfqOF
        NU6e4DpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34856)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olnz3-0008Q4-Ka; Fri, 21 Oct 2022 10:06:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olnyz-00042A-Dw; Fri, 21 Oct 2022 10:06:25 +0100
Date:   Fri, 21 Oct 2022 10:06:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 08:04:51AM +0200, Frank Wunderlich wrote:
> I have no register documentation to check if there is any way to read out pause/duplex setting. Maybe MTK can answer this or extend function later.

I suspect we can probably guess.

Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BMCR in
the low 16 bits, and BMSR in the upper 16 bits, so:

At address 4, I'd expect the PHYSID.
At address 8, I'd expect the advertisement register in the low 16 bits
and the link partner advertisement in the upper 16 bits.

Can you try an experiment, and in mtk_sgmii_init() try accessing the
regmap at address 0, 4, and 8 and print their contents please?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
