Return-Path: <netdev+bounces-12026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5E6735BAA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13E2A1C20A57
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1A912B9E;
	Mon, 19 Jun 2023 15:57:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7612B91
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:57:58 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2710EBC
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SWiiHkJdmvlXJZwKMW/S5q0O74lZcYov0QzDSlaOy68=; b=P8ykYVQgqOp2wglsCkTRm6M4Wg
	bQQKgspjDQZU+EOvr2DtHEinls4QgkE79w/hbryiTLz+fNR0P+mTwcaak9BfrWcbgsWSZXC9PIELa
	10C0naEcQFZ7tq79btzznbCIVmahaxOy6rkO2GJM+zE/nUKVOdPCdTIsT6z2XSM6ePeGVWVMHsScR
	NByxjf6+YTGZznIo+MrKteX5MQu5Nr77STn+yqygAwYmbpRyl7cdCG7dwKAYLRTnq8x3v1W/4bqg7
	oD1275LYa/NZAxiMjZYdcWSNpNQxV5apax9IVAP2n3A80YJ+iELxLK2XxP6rRYGKTIeiVhkP+wC+b
	tDMLQVVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54054)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qBHGA-0008UK-TI; Mon, 19 Jun 2023 16:57:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qBHG1-0005mV-SL; Mon, 19 Jun 2023 16:57:33 +0100
Date: Mon, 19 Jun 2023 16:57:33 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mdio: fix the wrong parameters
Message-ID: <ZJB67ZWOt8tw0iFx@shell.armlinux.org.uk>
References: <20230619094948.84452-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619094948.84452-1-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 05:49:48PM +0800, Jiawen Wu wrote:
> PHY address and device address are passed in the wrong order.
> 
> Fixes: 4e4aafcddbbf ("net: mdio: Add dedicated C45 API to MDIO bus drivers")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

