Return-Path: <netdev+bounces-9916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B774C72B2BD
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 18:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07E3D1C209D1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 16:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84738C2C2;
	Sun, 11 Jun 2023 16:04:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B3BA57
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 16:04:31 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CDFC7;
	Sun, 11 Jun 2023 09:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=T6CrEyCJEWEjaLFn6LFzF3ByBBDxPmYhcwwQOFSbgLs=; b=GY/NWPB/N6B5liOYRNI2P2Y76+
	GgHVnWtiBdoG67PbMdOZXrBSDTjUbRFsOirk1Oznc02Ebd8Mw+MorznSATUPfTHFejWrRUhyPj9zQ
	0KliyI1gbF6vKWCY9dSipfeXRn26SCw3k8sWHWTuLgthTvKoBOZhY2ry9gWj3xrqBFrhMWVOCb6sw
	Wl167FTeCT07Y29qeg+MnhnNvw6tsEH43pLsn2Mewa81VhKTaacsuE1BOJRk7yOM61QIdH9+iqZ21
	mp3gkLcf17sqyDPZiHb6sGl8KJY79RGzRIBlLJJs4gwi7DkzH5JUIZU8U7YV7+ftCo59PadEPuOCr
	+hjxnE6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60546)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8NY4-0004Yn-CJ; Sun, 11 Jun 2023 17:04:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8NXv-00043w-8q; Sun, 11 Jun 2023 17:04:03 +0100
Date: Sun, 11 Jun 2023 17:04:03 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc9.unal@gmail.com>
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH net v2 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Message-ID: <ZIXwc0V5Ye6xrpmn@shell.armlinux.org.uk>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230611081547.26747-1-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 11:15:41AM +0300, Arınç ÜNAL wrote:
> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
> SoC represents a CPU port to trap frames to. These switches trap frames to
> the CPU port the user port, which the frames are received from, is affine
> to.

I think you need to reword that, because at least I went "err what" -
especially the second sentence!

> Currently, only the bit that corresponds to the first found CPU port is set
> on the bitmap.

Ok.

> When multiple CPU ports are being used, frames from the user
> ports affine to the other CPU port which are set to be trapped will be
> dropped as the affine CPU port is not set on the bitmap.

Hmm. I think this is trying to say:

"When multiple CPU ports are being used, trapped frames from user ports
not affine to the first CPU port will be dropped we do not set these
ports as being affine to the second CPU port."

> Only the MT7531
> switch is affected as there's only one port to be used as a CPU port on the
> switch on the MT7988 SoC.

Erm, hang on. The previous bit indicated there was a problem when there
are multiple CPU ports, but here you're saying that only one switch is
affected - and that switch has only one CPU port. This at the very least
raises eyebrows, because it's just contradicted the first part
explaining when there's a problem.

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 9bc54e1348cb..8ab4718abb06 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	if (priv->id == ID_MT7621)
>  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>  
> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
> +	 * trapped to the CPU port the user port, which the frames are received
> +	 * from, is affine to.

Please reword the second sentence.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

