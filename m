Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB56B252E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCINVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjCINVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:21:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B968E7741;
        Thu,  9 Mar 2023 05:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dNVZ1FoHPA9y7GJqssX9FfFzSPM4P5yBtJIpechZ4W0=; b=oQsg7yg3iU/BaQ3jYgBp5Q57Oe
        Yx2LnYE2RY3+ZEROovUsAAsIHeMe7302nNpbp+yKgxfRKAT7LH2cc9ytBLEyg+SUfTgazfuuvapSb
        xCYYXnf10GEeFc3Nr9nbNj8irewYoQK+6YVLBu29M4zks3NnDdE2roKREnypMCq2TIFd55Tx28QqD
        jG6nB7siwOxSBCbVi1LEfhlxK7FU4ZHhsAHs6YLy4RKqMrkDrEpTJD4IuBvVyn8+zm5ODXl+f2hWb
        0QH/HU02UmZMTyRO9qWrkDvieASrm3B1gy0V1MsVkIS52XQjS2EH761m3WxyKFfabYTU1sEzHFY/r
        BEyNpjFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43874)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1paGCq-0004dB-Fp; Thu, 09 Mar 2023 13:21:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1paGCn-0003gm-Fv; Thu, 09 Mar 2023 13:21:13 +0000
Date:   Thu, 9 Mar 2023 13:21:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dsa: marvell: Add helper function to validate the
 max_frame_size variable
Message-ID: <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-6-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125421.3900962-6-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:54:19PM +0100, Lukasz Majewski wrote:
> This commit shall be regarded as a transition one, as this function helps
> to validate the correctness of max_frame_size variable added to
> mv88e6xxx_info structure.
> 
> It is necessary to avoid regressions as manual assessment of this value
> turned out to be error prone.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>

Shouldn't this be patch 2 - immediately after populating the
.max_frame_size members, and before adding any additional devices?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
