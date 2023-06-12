Return-Path: <netdev+bounces-10091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D4872C2C4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D832810C3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCFE168AC;
	Mon, 12 Jun 2023 11:28:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9018F11C99
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:28:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5327EE4;
	Mon, 12 Jun 2023 04:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UiExvDORYw74p5QnBqYdJuBBOJSP+9ub4ysJtQa9u/0=; b=B6frrpLUni4MIqPsM7uz4qf/C3
	hmuB/hiJpsdAw4oSuoMF3Dn9AQvmpy2lyr5diQJeDg4pVYzj7hncyCT9Sq4u61sa0a3hx1BVyIttA
	G/O36YSgf99zex7N97ziUa0IivcGdQY4UZmVwDyhrTsAIXnkwXWTXY8A4WR9NdQE5qChBbLkQR1yA
	y6ay0LMUQpnpd9tlEmG6mjG0SX85WtUWFUSUDQ4skiuSYjA6fOnz7f7iFaQ6+Zip3Cc8D8IXbA9g/
	5nU2zW8DrFNPAEdF6XmLeWVb/GOw+TXu/Bk7DkQpRgZ++51kgMNUFsQkWM/Qy8ZIKwb5RyThFXu5n
	Faj8ic4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40284)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8fiO-0005f6-3z; Mon, 12 Jun 2023 12:28:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8fiK-0004vJ-Qy; Mon, 12 Jun 2023 12:28:00 +0100
Date: Mon, 12 Jun 2023 12:28:00 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: Re: [PATCH net-next 6/8] net: ethernet: mtk_eth_soc: convert caps in
 mtk_soc_data struct to u64
Message-ID: <ZIcBQCqeMc424mv6@shell.armlinux.org.uk>
References: <ZIUX1AkjbSHdiMUc@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUX1AkjbSHdiMUc@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 01:39:48AM +0100, Daniel Golle wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> This is a preliminary patch to introduce support for MT7988 SoC.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

At some point, I'd really like to unpick this and see whether there's a
better structure to it - so that mac_config() doesn't have to save the
syscfg0 value, and restore it in mac_finish(). Given that syscfg0 is a
shared register, are we sure the code that updates this register is safe
from races caused by two MACs going through the config progress in two
separate CPUs at the same time?

Is there anything which prevents two or more MACs wanting to mess with
the contents of the SYSCFG0_SGMII_MASK bits? It's difficult to tell with
the current code.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

