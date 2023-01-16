Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0066C404
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjAPPfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjAPPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:34:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930054EE8;
        Mon, 16 Jan 2023 07:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uu7nSecGWseQ3bOuTyemkP6Mkcu9D4Vr+8fK+fSf+bU=; b=SdDjm8sXL/UOT1grM+JtNQ/Ux6
        En1SAU0mVmdeycI1VuSFQC7EbaHARW+S3qRy2OMHH7YmsFQYeyY66oB8kYxSWwEHg7hCw26UV3es3
        6gB4ZQaIuFstj+VoxPf1hodh+V8K3DC2Zr2hkBMnnEVqBgXamgxEsCRcZMtJRl3hwTyOK6vFZMoV7
        s45ICygDMZk1NxE5295RXxy0/M9FPHw5VeqLegB1u9eB7Ae1s97d2gBZO+ReEezxC/nl4E+tNDQeo
        DbiniybZGTOE0LwdKCAAjmQzgPDQyvsY1+uP9+LZRfs3VkrbK0D8tCSA6EWBOeYvvPb86003AaCI+
        akm0Urww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36132)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHRT1-0005H6-2n; Mon, 16 Jan 2023 15:32:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHRSw-00067Q-Ao; Mon, 16 Jan 2023 15:32:06 +0000
Date:   Mon, 16 Jan 2023 15:32:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
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
Message-ID: <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
References: <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
 <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
 <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
 <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
 <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
 <87o7qy39v5.fsf@miraculix.mork.no>
 <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
 <87h6wq35dn.fsf@miraculix.mork.no>
 <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
 <87bkmy33ph.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bkmy33ph.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 04:21:30PM +0100, Bjørn Mork wrote:
> [   54.539438] mtk_soc_eth 15100000.ethernet wan: Link is Down
> [   56.619937] mtk_sgmii_select_pcs: id=1
> [   56.623690] mtk_pcs_config: interface=4
> [   56.627511] offset:0 0x140
> [   56.627513] offset:4 0x4d544950
> [   56.630215] offset:8 0x20
> [   56.633340] forcing AN
> [   56.638292] mtk_pcs_config: rgc3=0x0, advertise=0x1 (changed), link_timer=1600000,  sgm_mode=0x103, bmcr=0x1000, use_an=1
> [   56.649226] mtk_pcs_link_up: interface=4
> [   56.653135] offset:0 0x81140
> [   56.653137] offset:4 0x4d544950
> [   56.656001] offset:8 0x1
> [   56.659137] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full - flow control rx/tx

Thanks - there seems to be something weird with the bmcr value printed
above in the mtk_pcs_config line.

You have bmcr=0x1000, but the code sets two bits - SGMII_AN_RESTART and
SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
0x1000. Any ideas why?

Can you also hint at what the bits in the PHY register you quote mean
please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
