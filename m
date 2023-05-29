Return-Path: <netdev+bounces-6094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 639BB714CF3
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97A481C20A0D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099EE8C19;
	Mon, 29 May 2023 15:26:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC803FD4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:26:02 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74131D8
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=k7LB3pHsX6KTp3tnjHW7yXqYjJ/pNTLH/cGpCKRjup0=; b=k3obklb9BPVWGATG48GMkYu27D
	QoyOUWsjTRcWTo1mTW2aHeKQuIRYkTcBl+QDEp8iActJfb90wkPsgEx2bcQVpcho1/4osLplU4TTQ
	e1Xjf4o88AHeAc9H+UhWACzhQkGaIfqhOn/mpA8CEn63VCB1U0tTfx3Eq2VyhMIkchVU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3ekj-00EEs9-E8; Mon, 29 May 2023 17:25:45 +0200
Date: Mon, 29 May 2023 17:25:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: pcs: xpcs: add xpcs_create_mdiodev()
Message-ID: <ab35060f-405d-4aaa-8e84-9f5a77e5eee3@lunn.ch>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USr-008PAU-Kk@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2USr-008PAU-Kk@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>  void xpcs_destroy(struct dw_xpcs *xpcs)
>  {
> +	if (xpcs)
> +		mdio_device_put(xpcs->mdiodev);
>  	kfree(xpcs);
>  }

Nit:

Is the if () needed? Can destroy be called if create was not
successful?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

