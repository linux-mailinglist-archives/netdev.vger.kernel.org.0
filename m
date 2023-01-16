Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7341266CEA8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjAPSVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjAPSVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:21:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F712A9AA;
        Mon, 16 Jan 2023 10:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=STAu0ZvL1JnFuFLemKT4UYZst/0+TtBmkzPQi1PH8dg=; b=vDiV5ggCRJN0kqAjTIaKhYIBa2
        cV2coQaFNKsQfW51wPmzHr7n2bPhG3avdRjjBFFsyaeD28xy3jppAuF5vn8Nio7JisC6JXhaJ9Pjv
        PNX7FIxA9No4th5njjxMUo97R8Vxa1xQ0yuv7+Uj+6FDSirBGQ4ABdSfPDXqknmaQOlKMNs2vjL8q
        1NJ2WoiQlwXqzpiquvI4x2oX0iC38lsqYtV7oHCSAxqxF/fmzKxG8RZnzXyG3fVcYBIxHJVUOjn1A
        Q01Fm6BBkrxY4r/+waipQdaqIvMXPOlzDU6NpzyLjKkL49hkr85pHe33jO1/mml5mQVTsYf5AxQDQ
        7rvIg9Ow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36142)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHTsn-0005cC-03; Mon, 16 Jan 2023 18:06:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHTsk-0006Cx-27; Mon, 16 Jan 2023 18:06:54 +0000
Date:   Mon, 16 Jan 2023 18:06:54 +0000
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
Message-ID: <Y8WSPjyz2TxyX3/R@shell.armlinux.org.uk>
References: <87o7qy39v5.fsf@miraculix.mork.no>
 <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
 <87h6wq35dn.fsf@miraculix.mork.no>
 <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
 <87bkmy33ph.fsf@miraculix.mork.no>
 <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
 <875yd630cu.fsf@miraculix.mork.no>
 <871qnu2ztz.fsf@miraculix.mork.no>
 <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
 <87pmbe1hu0.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmbe1hu0.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:59:19PM +0100, Bjørn Mork wrote:
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> 
> > On Mon, Jan 16, 2023 at 05:45:12PM +0100, Bjørn Mork wrote:
> >> Bjørn Mork <bjorn@mork.no> writes:
> >> 
> >> >> You have bmcr=0x1000, but the code sets two bits - SGMII_AN_RESTART and
> >> >> SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
> >> >> 0x1000. Any ideas why?
> >> >
> >> > No, not really
> >> 
> >> Doh! Looked over it again, and this was my fault of course.  Had an
> >> 
> >>   "bmcr = SGMII_AN_ENABLE;"
> >>   
> >> line overwriting the original value from a previous attempt without
> >> changing the if condition.. Thanks for spotting that.
> >> 
> >> But this still doesn't work any better:
> >> 
> >> [   43.019395] mtk_soc_eth 15100000.ethernet wan: Link is Down
> >> [   45.099898] mtk_sgmii_select_pcs: id=1
> >> [   45.103653] mtk_pcs_config: interface=4
> >> [   45.107473] offset:0 0x140
> >> [   45.107476] offset:4 0x4d544950
> >> [   45.110181] offset:8 0x20
> >> [   45.113305] forcing AN
> >> [   45.118256] mtk_pcs_config: rgc3=0x0, advertise=0x1 (changed), link_timer=1600000,  sgm_mode=0x103, bmcr=0x1200, use_an=1
> >> [   45.129191] mtk_pcs_link_up: interface=4
> >> [   45.133100] offset:0 0x81140
> >> [   45.133102] offset:4 0x4d544950
> >> [   45.135967] offset:8 0x1
> >> [   45.139104] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full - flow control rx/tx
> >
> > In your _dump_pcs_ctrl() function, please can you dump the
> > SGMSYS_SGMII_MODE register as well (offset 0x20), in case this gives
> > more clue as to what's going on.
> 
> 
> [   49.339410] mtk_soc_eth 15100000.ethernet wan: Link is Down
> [   52.459913] mtk_sgmii_select_pcs: id=1
> [   52.463673] mtk_pcs_config: interface=4
> [   52.467494] offset:0 0x140
> [   52.467496] offset:4 0x4d544950
> [   52.470199] offset:8 0x20
> [   52.473325] offset:20 0x10000
> [   52.475929] forcing AN
> [   52.481232] mtk_pcs_config: rgc3=0x0, advertise=0x1 (changed), link_timer=1600000,  sgm_mode=0x103, bmcr=0x1200, use_an=1
> [   52.492166] mtk_pcs_link_up: interface=4
> [   52.496072] offset:0 0x81140
> [   52.496074] offset:4 0x4d544950
> [   52.498938] offset:8 0x1
> [   52.502067] offset:20 0x10000
> [   52.504599] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full - flow control rx/tx
> [   65.979410] mtk_soc_eth 15100000.ethernet wan: Link is Down
> [   70.139856] mtk_sgmii_select_pcs: id=1
> [   70.143616] mtk_pcs_config: interface=22
> [   70.147523] offset:0 0x81140
> [   70.147525] offset:4 0x4d544950
> [   70.150402] offset:8 0x1
> [   70.153526] offset:20 0x10000
> [   70.156049] mtk_pcs_config: rgc3=0x4, advertise=0x20 (changed), link_timer=10000000,  sgm_mode=0x0, bmcr=0x0, use_an=0
> [   70.169672] mtk_pcs_link_up: interface=22
> [   70.173664] offset:0 0x40140
> [   70.173666] offset:4 0x4d544950
> [   70.176530] offset:8 0x20
> [   70.179659] offset:20 0x10000
> [   70.182279] mtk_soc_eth 15100000.ethernet wan: Link is Up - 2.5Gbps/Full - flow control rx/tx

Umm. What's at offset:20 seems to be unprogrammable - it always reads
back with only bit 16 set! This probably explains why it's not working,
as it looks like it can't be programmed to operate in SGMII mode!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
