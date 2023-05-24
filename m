Return-Path: <netdev+bounces-5129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0588E70FBF5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C00721C20CF9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11E419517;
	Wed, 24 May 2023 16:51:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E182633CA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:51:52 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859ACE9;
	Wed, 24 May 2023 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=APP2+LvV9dsJCiI5Crw6XhMxSBE3SecsM7KpgAzc5iM=; b=BTmwMqpHKnE874p4u3eckP903A
	xTKM6uHhgAkfn/qNlCkE44zJKBYuXrWDQ8lOGZDex6cgSrjekezc9CqpZU5K14EYGTRXZ0NSf/SuK
	QWkAM7jzB29ckwZfi0kgrcAbZkq7/PMFysUsJbJpj+iYRgXA+PO4/Ls4uAOb9YS7T7to=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1ri5-00DoYB-Q5; Wed, 24 May 2023 18:51:37 +0200
Date: Wed, 24 May 2023 18:51:37 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 3/5] net: dsa: microchip: remove ksz_port:on
 variable
Message-ID: <1dd9c529-ca03-4024-bc08-ee516f28b8f6@lunn.ch>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-4-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524123220.2481565-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:32:18PM +0200, Oleksij Rempel wrote:
> The only place where this variable would be set to false is the
> ksz8_config_cpu_port() function. But it is done in a bogus way:
> 
>  	for (i = 0; i < dev->phy_port_cnt; i++) {
> 		if (i == dev->phy_port_cnt) <--- will be never executed.
> 			break;
> 		p->on = 1;
> 
> So, we never have a situation where p->on = 0. In this case, we can just
> remove it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

