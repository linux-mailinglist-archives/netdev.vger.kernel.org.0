Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D50E607329
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiJUJAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJUJAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:00:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6E034990;
        Fri, 21 Oct 2022 02:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4iMBphw13KTQLLQRfUG/2Q1TsUUh89Ar5EYrCCnD96k=; b=wh3/gEmC9mepUk1fTEqfrqlJEy
        7LxX5iGvzCultd99ss4GAQLzu47Tznnc1PQKPA+dLeQQ1U/2J0eqEGdpKKoAMVIlGBtg41DJUL7cD
        kcASAQQfNiEmBACrIMYPnPdNwR1cusbIry2QS08ZHAZiCmSloL5Ym4v98A+J/P1nkT590E9zRlIua
        25f64/PnDS4f9cbTgmeBIOoleCgTLQcVqfoLRA/XV0olSiogHasssrNWEnijciwmDoNXVvTVafw+/
        lA7mEPSANpOChXuPjPHmwwrtNfqsNiOMwW05rDG0nm9rCzYooiOCisTqROtT2k8ckMA2rME1CHzYi
        1ZAZ8JSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34854)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olnt7-0008PG-Jd; Fri, 21 Oct 2022 10:00:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olnt2-000421-4a; Fri, 21 Oct 2022 10:00:16 +0100
Date:   Fri, 21 Oct 2022 10:00:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
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
Message-ID: <Y1JfoAD8NxvvR8+6@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JJEtvra2F3JGQS@shell.armlinux.org.uk>
 <9E91B812-8687-463D-8B98-3C4BF26CBE08@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E91B812-8687-463D-8B98-3C4BF26CBE08@fw-web.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 10:41:22AM +0200, Frank Wunderlich wrote:
> Am 21. Oktober 2022 09:24:02 MESZ schrieb "Russell King (Oracle)" <linux@armlinux.org.uk>:
> >On Fri, Oct 21, 2022 at 08:04:51AM +0200, Frank Wunderlich wrote:
> >> On my board (bpi-r3) we have no autoneg on the gmacs. We have a switch (mt7531) with fixed-link on the first and a sfp-cage on the other. Second mac gets speed-setting (1000base-X or 2500base-X) from sfp eeprom, but no advertisement from the "other end". Imho it is always full duplex.
> >
> >If it's a fixed link, then this function you're adding won't be called.
> >It's only called for in-band mode which is exclusive with fixed-link
> >mode.
> >
> >-- 
> >RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> >FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> Right, i get this trace for the second mac which is without fixed-link because of in-band-managed for sfp (read speed settings from sfp eeprom).

So, you need to set state->duplex to DUPLEX_FULL if this is what the
hardware is actually doing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
