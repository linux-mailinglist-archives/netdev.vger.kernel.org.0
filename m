Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C80F6CEF97
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjC2QjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC2QjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:39:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF84CF0;
        Wed, 29 Mar 2023 09:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VsYhrL4QtC5ZNA+kq7n/KEZPoa+gL9m0J5D2VbucwVQ=; b=yydGJAtSK1nqRobhiENbWmwZLY
        0rux+2yOz3bBQg9V1LLqsADGFqtceIQXhoXO1XvBzI2IB9eLT7PfoOgCEYLyf7uDUKzOZa8poZDii
        PIlK0ypB1cnReKyhNoMsdZTnyxxREExfqAuWOPoJmBst0iVZsJwDO9SJJAbTF6jUhGJk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYpD-008mdt-D6; Wed, 29 Mar 2023 18:39:03 +0200
Date:   Wed, 29 Mar 2023 18:39:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v3 11/15] net: dsa: mt7530: skip locking if
 MDIO bus isn't present
Message-ID: <022e2a44-31de-4667-9474-6a8518ca030a@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <4e6d1cbba2ff16cad5b9ac48ccdf4407f45c7857.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e6d1cbba2ff16cad5b9ac48ccdf4407f45c7857.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:59:47PM +0100, Daniel Golle wrote:
> As MT7530 and MT7531 internally use 32-bit wide registers, each access
> to any register of the switch requires several operations on the MDIO
> bus. Hence if there is congruent access, e.g. due to PCS or PHY
> polling, this can mess up and interfere with another ongoing register
> access sequence.
> 
> However, the MDIO bus mutex is only relevant for MDIO-connected
> switches. Prepare switches which have there registers directly mapped
> into the SoCs register space via MMIO which do not require such
> locking. There we can simply use regmap's default locking mechanism.
> 
> Hence guard mutex operations to only be performed in case of MDIO
> connected switches.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
