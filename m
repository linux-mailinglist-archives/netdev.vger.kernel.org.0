Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98B355037D
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 10:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiFRIWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 04:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiFRIWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 04:22:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FC42E08F;
        Sat, 18 Jun 2022 01:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SzEjeSGXZFEaqB9vXXzQNKk9zN7fQH9ukpLvS0OVS2M=; b=vA9STYCQoTjYq+AGGChv+hbWj0
        PdygWIlFSBPOLYaALXcAleTGSGilqne+tGwXUbC924aYUZi6JM7z64hek4o1oG4HwV22H5DmD2VNi
        6pKSqOq2cb91/DiSEWzQBm0tSqbVAKBOF7m8jcM8nx8RobrXs2D0YMX2E54LzI01Z+ufZfNBGTPtb
        nx7NUaKDVyqhdi2eMeS465ROROJX61peARkfEDy6djRlig4q3thlgCCxMklhPWdjqTRff2oRWn8Xl
        pxdd1ndlGanNQuYh2y2IwFxk6NPZMsBy4e1Le2AucZokH5LZ+CU5UXqXy/VT2wXTih1P7Xm6x0E0X
        cZNvlHzQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32912)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o2Tib-00046R-KM; Sat, 18 Jun 2022 09:22:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o2TiX-0002ly-TU; Sat, 18 Jun 2022 09:22:05 +0100
Date:   Sat, 18 Jun 2022 09:22:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
Message-ID: <Yq2LLW5twHaHtRBY@shell.armlinux.org.uk>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
 <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
 <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 08:45:38PM -0400, Sean Anderson wrote:
> Hi Russell,
> 
> Thanks for the quick response.
>...
> Yes, I've been using the debug prints in phylink extensively as part of
> debugging :)
> 
> In this case, I added a debug statement to phylink_resolve printing out
> cur_link_state, link_state.link, and pl->phy_state.link. I could see that
> the phy link state was up and the mac (pcs) state was down. By inspecting
> the PCS's registers, I determined that this was because AN had not completed
> (in particular, the link was up in BMSR). I believe that forcing in-band-status
> (by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
> up on any interface without it. In particular, the pre-phylink implementation
> disabled PCS AN only for fixed links (which you can see in patch 23).

I notice that prior to patch 23, the advertisment register was set to
0x4001, but in phylink_mii_c22_pcs_encode_advertisement() we set it to
0x0001 (bit 14 being the acknowledge bit from the PCS to the PHY, which
is normally managed by hardware.

It may be worth testing whether setting bit 14 changes the behaviour.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
