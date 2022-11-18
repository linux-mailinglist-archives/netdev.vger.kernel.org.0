Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5E762FD74
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbiKRS7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242029AbiKRS6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:58:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FDADF26;
        Fri, 18 Nov 2022 10:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U/nlGv1M4b5GNo9zHM3JahGEYmRaE9UM6k5mmYcVw1U=; b=o/i42WV/0cJwm7QRV4143fwvcT
        MlrfHmJMnUmQE7nygOK8l7l9xZ508s5bYIs/ktdKSCEpOq5sq0vTFT/9rnZSTHL8llDOYQulEFu6p
        56K4etOrjz+hgBC+l7v1B+MB05qrkNNfBvtfoqGvOgdYWM8Phf01dLGvXiHvWrr74Rz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow6Xq-002pVA-G4; Fri, 18 Nov 2022 19:56:58 +0100
Date:   Fri, 18 Nov 2022 19:56:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <Y3fVej+tsB8FP2kf@lunn.ch>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <Y3bLlUk1wxzAqKmj@lunn.ch>
 <20221118171643.vu6uxbnmog4sna65@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118171643.vu6uxbnmog4sna65@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What might be an even bigger offence than giving different provisioning
> to different customers is giving different documentation to different
> customers. In the Aquantia Register Specification for Gen4 PHYs given
> to NXP, the SerDes mode field in register 1E.31C cannot even _take_ the
> value of 6. They're all documented only from 0 to 5. I only learned that
> 6 (XFI/2) was a thing from the discussion between Sean and Tim.

At some point we just have to declare the hardware unsupportable in
mainline, too many landmines. We simply stop any further development
on it. If it works for you, great. Otherwise use the vendor crap
driver and complain loudly to the vendor.

The way out could be Marvell puts firmware in linux-firmware with no
provisioning, or a known provisioning. We load that firmware at probe
time, and we only support that.

But do Marvell actually care about mainline? I guess not.

Microchip seem like the better vendor if you care about mainline.
Open datasheets, engagement with the community, etc.

    Andrew

