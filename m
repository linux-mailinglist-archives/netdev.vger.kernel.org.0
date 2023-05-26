Return-Path: <netdev+bounces-5668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D33D87125F0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DE8E2817C6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBCF154A7;
	Fri, 26 May 2023 11:51:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F51118D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:51:00 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDE6E57;
	Fri, 26 May 2023 04:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GVN+Py+HCNpAyiMZ3YRw5j54FCIO3Kg9KOooO7baA1I=; b=EGqVcNDaLNZxeJZFrjZw0QYiwN
	K6YBJXjSDVXSluLZytlUBBc0J12ySp8ynWdLcuA0xVE/oVoIV37mK8FzwMSy/dqqZ9ReY1+MDnqWg
	m04XCImEYq0i6Tap1FyKYicpqvn7wyDpqPQ6cVPkjuueMsGDgyw9o8DZfq5fdfSLQHrjFoiKbHKcv
	JTnyCDlnahD7ym56r13DVD2XGGpdg0ic4ZMaZqTdUGEVqNnYjW/4k/SkMyu0X0axV0486XcMDmpvw
	DVSOZRlXNOZvDI1VCfxtRUYDokQ2JbXxXDiqkv3UIJLJmDfgRFSX1wqCLOnzgPoFbsetAp1kcV1V+
	+uFAxsHg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43008)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q2Vxp-0005Y6-MG; Fri, 26 May 2023 12:50:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q2Vxn-0003iB-Bw; Fri, 26 May 2023 12:50:31 +0100
Date: Fri, 26 May 2023 12:50:31 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <ZHCdB7upb9NIkUap@shell.armlinux.org.uk>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 02:45:54PM +0300, Dan Carpenter wrote:
> The "val" variable is used to store error codes from phy_read() so
> it needs to be signed for the error handling to work as expected.
> 
> Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")

LGTM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

