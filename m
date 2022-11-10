Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5F6249EE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKJSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKJSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:50:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4628A14028
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QKdGnCKxpuTh9fhvavU8cWMge7d1DhtKAJibrny01yg=; b=KQw0ZO6ZcEBYnKesCL60YxJaNh
        rY84E1GhkPUwTYg2l3ja9XdzsluWi9Agu3xNtH10AVRtlHloAGWlLWPJRHl6M3S6jE3Igl+st17pm
        sUI4EKhWwOfnpVpqKQXKlATlahV4LvRnw7a4l7EEwql8YLckSc8LJvFYOGi8ORE5Op/d01GMjgvQq
        7gOexK4sdHiPkpElv1z+MHqB4jcU+qv9teEhg+EzMRMpOQXg4caHVjOXG9h4Lxj6baarMmRZ2Ff51
        1h5xM5m1JqDww24hjEESPFSfGyYKxKM8AHG06Kamx8/V7FUy2v3f6B+2jYfjYhyr3Dx/FNfTsFj3P
        XcppuzMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35208)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1otCcm-0005yV-Dv; Thu, 10 Nov 2022 18:50:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1otCcl-0006r4-QG; Thu, 10 Nov 2022 18:50:03 +0000
Date:   Thu, 10 Nov 2022 18:50:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v2 00/12] Multiqueue + DSA untag support + fixes
 for mtk_eth_soc
Message-ID: <Y21H22Geh0a0pcta@shell.armlinux.org.uk>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix,

Not directly related to your patch series, but as you seem to be
tinkering with the driver, it seems appropriate to ask. Are you
using hardware that uses RGMII? If not, do you know anyone who is?

It would be good to fix mtk_mac_config(), specifically the use
of state->speed therein - see the FIXME that I placed in that
function. Honestly, I think this code is broken, since if the
RGMII interface speed changes, the outer if() won't allow this
code path to be re-executed (since mac->interface will be the
same as state->interface for speed changes.)

It would be nice to get rid of that, because this is the very
last pre-March 2020 legacy ethernet driver, and it's marked as
such for this very reason.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
