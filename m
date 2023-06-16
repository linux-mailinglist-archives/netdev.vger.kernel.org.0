Return-Path: <netdev+bounces-11380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EDA732D4A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 522842816AD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD7A18012;
	Fri, 16 Jun 2023 10:18:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92221174CB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:18:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8B3A9E;
	Fri, 16 Jun 2023 03:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ldYgwDt7voxDOksHBbsKUYFGw63dx52D9aj9AQa3YSg=; b=0+liBd742WkgK8Mdlp4lP6ky1Z
	mwbmgUC+sDSAA7CM8Q8EOPIq7cF39x1/cbeQ73mLiZDnQIpbgu3Z2r1CL4tQnZFIcwWO03mecTh5A
	JfAl5V3Is1NfjAMg8g0SkaR0cFzU4FlpVpuAqA+t4fMJX3XQhWm/Wsl/1LIe4Hp/b0ZKP/8rV3A0X
	Ma2Kfi1bcRhi5e72QP1sBwwuHs4QVoKP+lMacig1m+3pups2ggSs7WlYcWMgusypgbOgL9aCzwy6/
	C3SjPly7/QQokDFuVgR8vx0224Jswndt21p0I+loXubSlc1MD/jbfRMcBFdEjL3BV/A41g6y6pPIA
	wqkcWFJg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33540)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA6Wk-0004lz-BV; Fri, 16 Jun 2023 11:17:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA6Wg-0002QQ-6G; Fri, 16 Jun 2023 11:17:54 +0100
Date: Fri, 16 Jun 2023 11:17:54 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: arinc9.unal@gmail.com,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 2/6] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <ZIw20jmqI1d/W+YY@shell.armlinux.org.uk>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-3-arinc.unal@arinc9.com>
 <20230616100314.x2qak6t7uxo2qnja@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616100314.x2qak6t7uxo2qnja@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:03:14PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 16, 2023 at 05:53:23AM +0300, arinc9.unal@gmail.com wrote:
> > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > 
> > The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> > MT7530 switch variants to trap frames. Expand the check to include them.
> > 
> > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > ---
> 
> why do you say non-MT7621 when the change specifically includes MT7621?
> What is the affected SoC then?

Thanks for falling into one of the issues that makes reviewing these
patches difficult. :/

> > -	if (priv->id == ID_MT7621)
> > +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
> >  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));

I *think* what the commit message should be saying is that the setup
for the CPU port(*) is necessary not only for MT7621, but also for
MT7530 variants as well.

That can be construed from the commit message, but it doesn't easily
read that way.

* - in this case, it's the CPU port field and the CPU enable bit.
Note that CPU_MASK only covers CPU_PORT() and not CPU_EN, but this
doesn't matter for mt7530_rmw().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

