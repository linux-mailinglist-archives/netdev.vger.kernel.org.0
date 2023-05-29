Return-Path: <netdev+bounces-6136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C78E714DD2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E1B280EE5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EA7947D;
	Mon, 29 May 2023 16:05:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DEAA926
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:05:39 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F35BCD
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qJp5EQADBGyYGTdu+eUNtg+njzq8CxtSzLLEmSsyZ5Q=; b=XsITMpoCEMmbwKax2+GBshDvcH
	RGXXA+J0FPwQr8LQ6h2WqqNHti195QT9ZzkM1rRrKHnuvZ7DcrRrweyqd8/MbFQhxWPXKz3KoXNw7
	8T8dD7YkjVWjZhbJcXjPWRJ1zl/2p0aSeG09Y/UOJg1bz+KCGgygXGKdXf1QdizrM5WQjLHeGPvI8
	pTt68yP2fBF+tzr6IkJ7xI7XuzMAxrijTGhX6YJjU8AFFkx/koU18vEom9SacyCDY2WDEX04jlc+r
	5I7ceMlnuEzY0cTOd6E6aHEvdkQNuyErDOn/IQxmwjU5HbiEdZD6Bgj8NiMXJKLlM/3ixjoTI03IS
	LDUPRI1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46654)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q3fN3-0001D9-0B; Mon, 29 May 2023 17:05:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q3fMv-00077k-Eg; Mon, 29 May 2023 17:05:13 +0100
Date: Mon, 29 May 2023 17:05:13 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <ZHTNOepLuMCcDNTu@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USr-008PAU-Kk@rmk-PC.armlinux.org.uk>
 <ab35060f-405d-4aaa-8e84-9f5a77e5eee3@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab35060f-405d-4aaa-8e84-9f5a77e5eee3@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:25:45PM +0200, Andrew Lunn wrote:
> >  void xpcs_destroy(struct dw_xpcs *xpcs)
> >  {
> > +	if (xpcs)
> > +		mdio_device_put(xpcs->mdiodev);
> >  	kfree(xpcs);
> >  }
> 
> Nit:
> 
> Is the if () needed? Can destroy be called if create was not
> successful?

kfree(NULL) is a no-op, so xpcs_destroy() will not oops if passed a NULL
pointer. So it makes sense to preserve this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

