Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3243E618B1C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiKCWGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKCWGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:06:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D563F22293;
        Thu,  3 Nov 2022 15:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v4cHUAKIN1alQhVRV36kZWuJBkfRVyQW/FYiebl3tq8=; b=1mhhdmhlzvYWloNOey+D2i8JgM
        91UFtRrqSK/mkAGorKaZEdD5UWadNP2o1zk/EGSnAbI7YjzEGWRTHPzeA5Ubf/Zb+35h6da4u/AhW
        kJP7UbkRlgCWC6ZsNOMYIWIZSv3VnBckU4ZMP2WUCzW4f6jn63Ltb/XNznNY5RzdrquE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqiL4-001Lyy-Pq; Thu, 03 Nov 2022 23:05:30 +0100
Date:   Thu, 3 Nov 2022 23:05:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc:     Rob Herring <robh@kernel.org>, Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y2Q7KtYkvpRz76tn@lunn.ch>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +      - description: Main GMAC clock
> > > +      - description: Peripheral registers clock
> > > +      - description: Transmit SGMII clock
> > > +      - description: Transmit RGMII clock
> > > +      - description: Transmit RMII clock
> > > +      - description: Transmit MII clock
> > > +      - description: Receive SGMII clock
> > > +      - description: Receive RGMII clock
> > > +      - description: Receive RMII clock
> > > +      - description: Receive MII clock
> > > +      - description:
> > > +          PTP reference clock. This clock is used for programming the
> > > +          Timestamp Addend Register. If not passed then the system
> > > +          clock will be used.

> Not clear to me has been whether the PHY mode can be switched at runtime
> (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by board
> design.

Does the hardware support 1000BaseX? Often the hardware implementing
SGMII can also do 1000BaseX, since SGMII is an extended/hacked up
1000BaseX.

If you have an SFP connected to the SERDES, a fibre module will want
1000BaseX and a copper module will want SGMII. phylink will tell you
what phy-mode you need to use depending on what module is in the
socket. This however might be a mute point, since both of these are
probably using the SGMII clocks.

Of the other MII modes listed, it is very unlikely a runtime swap will
occur.

	Andrew
