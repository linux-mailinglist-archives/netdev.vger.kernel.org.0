Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61B3678CE8
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjAXAfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjAXAfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:35:51 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB0E3A1;
        Mon, 23 Jan 2023 16:35:50 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0DA8B12D5;
        Tue, 24 Jan 2023 01:35:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674520549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0QJrzM/nos+48dBriFtlRQxmABdt2ZEF0ScwZ5Vbs0=;
        b=ndtJ1iSIARIvIWBd0cmm/w/WB3Hldz0MrlyhnReyeEm+9J+0i6qZuk5+9fM7XsXdpHijm9
        7OqX7Nmi1ZHUf2S8Cn7Ve259lvO/sMwTg2z53lJnvUvjwmKXo2jy7FIPGGfmRvS1F4n6+7
        f8Q/w3i4Xckrc/RAMgBLB+cj4F7YRJCLZwpA6lZHQNoDSKdBiSFOMDpjxkPDuixory2n7B
        fkpKo2CtxcXiOh9CqibhWzFmQveR6V6m3+/TwjKk4GhjHBFKdEE69aTn3n9UpqJ+tXSICR
        Kow5VEUFQLB8X3ZmbH2uHItcznfrDXADxVW5ewxN1e+sjlbgCRY6vrzqSNel9g==
MIME-Version: 1.0
Date:   Tue, 24 Jan 2023 01:35:48 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
In-Reply-To: <Y87og1SIe1OsoLfU@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch> <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
 <Y87og1SIe1OsoLfU@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <05e044a5f308ad81919d28a5b2dfdd42@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>       - const: ethernet-phy-ieee802.3-c45
>         description: PHYs that implement IEEE802.3 clause 45
> 
> But it is not clear what that actually means. Does it mean it has c45
> registers, or does it mean it supports C45 bus transactions?

PHYs which support C45 access but don't have C45 registers aren't
a thing I presume - or doesn't make any sense, right?

PHYs which have C45 registers but don't support C45 access exists.
e.g. the EEE registers of C22 PHYs. But they are C22 PHYs.

So I'd say if you have compatible = "ethernet-phy-ieee802.3-c45",
it is a PHY with C45 registers _and_ which are accessible by
C45 transactions. But they might or might not support C22 access.
But I think thats pretty irrelevant because you always do C45 if
you can. You cannot do C45 if:
  (1) the mdio bus doesn't support C45
  (2) you have a broken C22 phy on the mdio bus

In both cases, if the PHY doesn't support C22-over-C45 you are
screwed. Therefore, if you have either (1) or (2) we should always
fall back to C22-over-C45.

> If we have that compatible, we could probe first using C45 and if that
> fails, or is not supported by the bus master, probe using C45 over
> C22. That seems safe. For Michael use case, the results of
> mdiobus_prevent_c45_scan(bus) needs keeping as a property of bus, so
> we know not to perform the C45 scan, and go direct to C45 over C22.

So you are talking about DT, in which case there is no auto probing.
See phy_mask in the dt code. Only PHYs in the device tree are probed.
(unless of course there is no reg property.. then there is some
obscure auto scanning). So if you want a C45 PHY you'd have to
have that compatible in any case.

Btw. I still don't know how you can get a C45 PHY instance without
a device tree, except if there is a C45 only bus or the PHY doesn't
respond on C22 ids. Maybe I'm missing something here..

-michael
