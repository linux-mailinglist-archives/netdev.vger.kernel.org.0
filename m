Return-Path: <netdev+bounces-1750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3037D6FF0B5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54F772816A7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CFA19BC6;
	Thu, 11 May 2023 11:52:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DE365B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:52:31 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB242680;
	Thu, 11 May 2023 04:52:29 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1px4qR-0008QZ-22;
	Thu, 11 May 2023 11:52:28 +0000
Date: Thu, 11 May 2023 13:50:30 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/8] net: phy: realtek: rtl8221: allow to configure
 SERDES mode
Message-ID: <ZFzWhn7yXazjjmzq@pidgin.makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <302d982c5550f10d589735fc2e46cf27386c39f4.1683756691.git.daniel@makrotopia.org>
 <8fdffc76-4b2f-44ea-9800-1e5d3624d94e@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fdffc76-4b2f-44ea-9800-1e5d3624d94e@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 02:38:19AM +0200, Andrew Lunn wrote:
> > +#define RTL8221B_SERDES_OPTION_MODE_2500BASEX_SGMII	0
> > +#define RTL8221B_SERDES_OPTION_MODE_HISGMII_SGMII	1
> > +#define RTL8221B_SERDES_OPTION_MODE_2500BASEX		2
> 
> So what is 2500BASEX_SGMII? You cannot run SGMII at 2.5G, because
> there is no way to repeat a symbol 2.5 times so that a 1G stream takes
> up 2.5G bandwidth. The SGMII signalling also does not work at 2.5G.

*_MODE_2500BASEX_SGMII means that the PHY will dynamically switch
interface mode between 2500Base-X for 2500M links and SGMII for
everything else.

Setting  *_MODE_2500BASEX in contrast to that enabled rate-adapter mode
and always uses 2500Base-X no matter what the speed of the link on the
TP interface is.

I will add a comment explaining that.


