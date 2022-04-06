Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965344F613F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiDFN6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiDFN5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:57:21 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348F7362FDE;
        Wed,  6 Apr 2022 02:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=2bYtZaY82UR+toaii6rgTQB2neDCnsVr9ZEMwIx3gBE=;
        b=VpHybvzSO3sJrDCGfrS+4p8/OyKo7WnJ2YQdpUZRiHkbC0oIohsCKP7QH5dGR4DN+EJlNyIrvEbDg
         krZnJ1dMl/x8NGrpj9o6sA1ej/VIF8QkOn6QGNEtqk3ed/Ww0BtutQnJ0rbi4zwpLuUUolkZxnUfrz
         TcvgjoqOtHB5FLpappca3IS3vM6iJQuA1YDAfCygfJ4gWFJxWklEkpsDFiqaPdybsfiooWRfzjD9op
         wD/jsNI9K+2/TNjhDgNqOWTwC8xt3svZMbHYzNvA1nelokFE8gEGcza8Xg50hHyWbWFdHVhGZeH0ZG
         4hSAi5Q2mpyK2GieI7mE6zNF2YAa4Pw==
X-Kerio-Anti-Spam:  Build: [Engines: 2.16.2.1410, Stamp: 3], Multi: [Enabled, t: (0.000008,0.004499)], BW: [Enabled, t: (0.000016,0.000001)], RTDA: [Enabled, t: (0.065283), Hit: No, Details: v2.33.0; Id: 15.52k7j2.1fvv2599b.8gs; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from h-e2.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Wed, 6 Apr 2022 12:09:15 +0300
Date:   Wed, 6 Apr 2022 12:09:08 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: Re: [PATCH net] net: phy: marvell-88x2222: set proper phydev->port
Message-ID: <20220406090908.mkpvndnsby5f3473@h-e2.ddg>
References: <20220405150305.151573-1-i.bornyakov@metrotek.ru>
 <Ykxq0wx7eMiZCXgx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykxq0wx7eMiZCXgx@lunn.ch>
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 06:14:11PM +0200, Andrew Lunn wrote:
> On Tue, Apr 05, 2022 at 06:03:05PM +0300, Ivan Bornyakov wrote:
> > phydev->port was not set and always reported as PORT_TP.
> > Set phydev->port according to inserted SFP module.
> 
> This is definitely something for Russell to review.
> 
> But i'm wondering if this is the correct place to do this? What about
> at803x and marvell10g?

I guess them need this too, but I only have HW with Marvell 88X2222.

> It seems like this should be done once in the
> core somewhere, not in each driver.
> 
>      Andrew

Apart from sfp_parse_port(), sfp_parse_support() and
sfp_select_interface() are also present in all
sfp_upstream_ops->module_insert PHY callbacks.

