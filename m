Return-Path: <netdev+bounces-7262-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAACF71F62C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 494A81C21170
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD90924135;
	Thu,  1 Jun 2023 22:43:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF35310FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:43:02 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBA412C;
	Thu,  1 Jun 2023 15:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mShMM3p8SqII3lbXMxoUKDpBZz5yb8liVkn0PUSzrRY=; b=o/cvisFLXDZkg1pALu/qjJ9cyZ
	jM/EQfwdJM7dEd0ynEU+4NsAxrrykHFGlfhZy4l2YxAuGQx+W5YxjvngbvCmuU+zc0ftAUVCu/UIe
	uJxGnUg9gt7s6OHHkO95KJfYqe5JyRixt09EbdVcOtHbderosT9MzRnRSw9r07JK5/WAVZ64bKqDB
	Tpow4BY/SLiVw/Igr/haq3CGfn2finRrg5SCP4Z5eKLGl6/IbPs4gqRSL30MUOrwLJ40olhD/0KOy
	B+Qb9lna9okjadvmmczGMH5mckcVUi9+c4O53zCMbJ4JTIXKYKBD4QTmm56d/8umfat16a2MFO49z
	6qOxB2ag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51104)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q4r0N-00078r-Q8; Thu, 01 Jun 2023 23:42:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q4r0K-0002If-5v; Thu, 01 Jun 2023 23:42:48 +0100
Date: Thu, 1 Jun 2023 23:42:48 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: msmulski2@gmail.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <ZHke6JqvcWZsOdX5@shell.armlinux.org.uk>
References: <20230601215251.3529-1-msmulski2@gmail.com>
 <20230601215251.3529-2-msmulski2@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601215251.3529-2-msmulski2@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 02:52:51PM -0700, msmulski2@gmail.com wrote:
> +/* USXGMII */
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_MASK	GENMASK(11, 9)
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_5000	0xa00
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_2500	0x800
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10000	0x600
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_1000	0x400
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_100	0x200
> +#define MV88E6390_USXGMII_PHY_STATUS_SPEED_10	0x000
> +#define MV88E6390_USXGMII_PHY_STATUS_DUPLEX_FULL	BIT(12)
> +#define MV88E6390_USXGMII_PHY_STATUS_LINK		BIT(15)

How is this different from the definitions in include/uapi/linux/mdio.h
(see MDIO_USXGMII_*). Have you considered using
phylink_decode_usxgmii_word() to decode these instead of reinventing the
wheel?

It would be nice to wait until we've converted 88e6xxx to phylink PCS
before adding this support, which is something that's been blocked for
a few years but should be unblocked either at the end of this cycle,
or certainly by 6.5-rc1. Andrew, would you agree?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

