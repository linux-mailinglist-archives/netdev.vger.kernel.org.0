Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48126B09B3
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCHNqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjCHNps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:45:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D52386E;
        Wed,  8 Mar 2023 05:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8TKxRu++VFoSSVqlF4KgFVHHMcvl3WVVlzCkMfcoDbI=; b=cFBFBuPrdh5yUSCs7IuOyMl4U5
        Q9eFGeNXzXRR7h18kSyMjE3cduR06XKQqDNYTNB1+BRuM1GBcCK9AFqd6CZlsqbYO3sjAwm9Zju5A
        +0CiepYzRGtAHMtEMtQxOwUxwogqYqsTyzfk42mdM+m0aj3lcm1zp1DWjqCN/R2VLu0FGb8tivrBY
        CXzA1K2YNEV30WOxRnqBvnnGSlPnVdlYsfuxsKw3bUKgOS7PWDIf9VBbqHYMnky2Sy9bNn5rB+Z2B
        hY4bc1pqvV+j8CFBMtXXu71xHeEuWmKuBSgfO7WrzRe6Z4ELQTQDf9AkXXri/LPj6yvRdTvLC2H6a
        MLxSkwQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50882)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZu6F-0002e9-DT; Wed, 08 Mar 2023 13:44:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZu6A-0002dH-CK; Wed, 08 Mar 2023 13:44:54 +0000
Date:   Wed, 8 Mar 2023 13:44:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Richard van Schagen <richard@routerhints.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Fix Flooding: Disable by default on User ports and
 Enable on CPU ports
Message-ID: <ZAiRVnqMtqYQ7IGP@shell.armlinux.org.uk>
References: <20230212214027.672501-1-richard@routerhints.com>
 <6da6d5bf-be12-ec7a-58ac-a1a1cef23fd0@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6da6d5bf-be12-ec7a-58ac-a1a1cef23fd0@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 04:34:11PM +0300, Arınç ÜNAL wrote:
> Richard, will you send a new patch series for this and your other two
> patches? They are essential for the port5 <-> gmac1 link to work properly.
> Without them, port5 as a CPU port won't work properly.

... and maybe detail exactly what the effect of this is.

For example, does it affect multicast frames received on user ports
being multicast to other user ports when they are part of the same
bridge device (which is essential for IPv6 to function.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
