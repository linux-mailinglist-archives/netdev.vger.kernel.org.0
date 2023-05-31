Return-Path: <netdev+bounces-6881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DAE17188F6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFC731C20F06
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C26B18B0A;
	Wed, 31 May 2023 18:00:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23C171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:00:16 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF44126;
	Wed, 31 May 2023 11:00:13 -0700 (PDT)
Received: from arisu.localnet (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id D2C2B66056D7;
	Wed, 31 May 2023 19:00:10 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685556012;
	bh=2DlD47EuurI1+4uewQzR4DdZPPGxHv74VYEPxfWFriA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8Milrc/OCzz6XoLcw5ODsOcLv8R4jhlet06ofcsKTjPko5PkxM/w63HqRGnPDXJX
	 ChHOxwOd4lj66xBwN1/dROtagK8pxlBSYRq2hO/xOuF7GKIfh+Byb4jLYD1hm4BxNg
	 aldQw2NCm4ZidPdA5tOqkW6k3UYYvfzPmyMI83yt+LPDqvqWxJGx/wNc8unh2aQaRS
	 bI72ZkYBkQvljpJ2n/MUkqQ+nde/2yHc7HyieoPyQCui3OKvH5K3n/ZeYCOOCpZ88X
	 ZgL9qevAH42WHNNZ0klBKOZmCuDC3qVGMrzUhC6EOzxWnXJmxkS0wIuhFTxL4hJVnh
	 /xVMqD3nHyROg==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: phy: Support external PHY xtal
Date: Wed, 31 May 2023 14:00:12 -0400
Message-ID: <6646604.lOV4Wx5bFT@arisu>
In-Reply-To: <ade45bcf-c174-429a-96ca-d0ffb41748d4@lunn.ch>
References:
 <20230531150340.522994-1-detlev.casanova@collabora.com>
 <ade45bcf-c174-429a-96ca-d0ffb41748d4@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 31, 2023 11:16:46 A.M. EDT Andrew Lunn wrote:
> On Wed, May 31, 2023 at 11:03:39AM -0400, Detlev Casanova wrote:
> > Ethernet PHYs can have external an clock that needs to be activated before
> > probing the PHY.
> > 
> > Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
> > ---
> > 
> >  .../devicetree/bindings/net/ethernet-phy.yaml          | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > b/Documentation/devicetree/bindings/net/ethernet-phy.yaml index
> > 4f574532ee13..e83a33c2aa59 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > 
> > @@ -93,6 +93,16 @@ properties:
> >        the turn around line low at end of the control phase of the
> >        MDIO transaction.
> > 
> > +  clock-names:
> > +    items:
> > +      - const: xtal
> 
> I don't think xtal is the best of names here. It generally is used as
> an abbreviation for crystal. And the commit message is about there not
> being a crystal, but an actual clock.
> 
> How is this clock named on the datasheet?

In the case of the PHY I used (RTL8211F), it is EXT_CLK. But this must be 
generic to any (ethernet) PHY, so using ext_clk to match it would not be
good either.

Now this is about having an external clock, so the ext_clk name makes sense in 
this case.

I'm not pushing one name or another, let's use what you feel is more natural.

Detlev.




