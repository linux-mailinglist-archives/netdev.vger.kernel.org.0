Return-Path: <netdev+bounces-4705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C16F70DF78
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1AA12813DC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510371F17A;
	Tue, 23 May 2023 14:38:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329C4C7B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:38:19 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A8F121;
	Tue, 23 May 2023 07:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NLFTS+w5hN7WpRmvWgLF3ouUkJg9vy2d77yR3EYCI6E=; b=vQoDp++IV6aKY7+NungSxOllYP
	0VTb4wQNDcsShENSioFKWXCiphToj+oP50h3oGWELjS0Ag/qUVDhX9wRy7/+8zBZGmKCHDn9hWur9
	z988b4Dcsr3vEEASm3F+Cb4TQNm6DrwJ5MfahReo6uptxBpWX41cThDRmpXjsX8fSrZtymq+jYjpk
	5fHmMxw52M6xdRTKsOwAR2bX5ZQCcGiA5TYm4f1I2fnoTi5Ee9+k/zRzsI+ejq8fm+okRWgajVyq6
	9oJwSWgxF0fHKtwOtXO3PeztPI0gum4Xd8Rk2Q7F4n6gFNgVWPY/R4NnxZ4eUV+Vn4jgk6MNfVC91
	X8w+4Kag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45946)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1T9P-0000Yd-QN; Tue, 23 May 2023 15:38:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1T9O-0000eQ-O2; Tue, 23 May 2023 15:38:10 +0100
Date: Tue, 23 May 2023 15:38:10 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] dsa: marvell: Define .set_max_frame_size()
 function for mv88e6250 SoC family
Message-ID: <ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk>
References: <20230523142912.2086985-1-lukma@denx.de>
 <20230523142912.2086985-2-lukma@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523142912.2086985-2-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 04:29:10PM +0200, Lukasz Majewski wrote:
> Switches from mv88e6250 family (the marketing name - "Link Street",
> including mv88e6020 and mv88e6071) need the possibility to setup the
> maximal frame size, as they support frames up to 2048 bytes.
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>

Adding this function doesn't allow the "possibility" for a larger frame
size. Adding it changes the value returned from mv88e6xxx_get_max_mtu()
to be a larger frame size, so all switches that make use of
mv88e6250_ops will be expected to support this larger frame size. Do
we know whether that is true?

There were patches floating about a while ago that specified the
maximum size in struct mv88e6xxx_info, but it seems those died a death.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

