Return-Path: <netdev+bounces-7233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC13271F315
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11E9E2818E3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC0721CC1;
	Thu,  1 Jun 2023 19:37:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCBB209A4
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 19:37:58 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA99C186;
	Thu,  1 Jun 2023 12:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=u7bCjsVvBfHBSKBZixwNn+EH8tQNK9xBNDhiRR0ol6k=; b=PzZJA9eA5HjrgMlzs4S+NaFK+R
	zJu0xtCCNmvh9hKUrWdWBO0l5VcByEHvORcH98acmxE6QxZKDPQI2NaW69MSn+dxGBq+cYp3CxvCQ
	IFiWXU3mjpkqr73pS2/Z4t/g+jDbaqtmJ/pk1LwWZTg5mj+Gi5SWAFUvCJYoa/+Mknag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4o7B-00EbLe-If; Thu, 01 Jun 2023 21:37:41 +0200
Date: Thu, 1 Jun 2023 21:37:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] net: phy: realtek: Add optional external PHY clock
Message-ID: <7bde15a1-08fe-4036-9256-b13280340b6b@lunn.ch>
References: <20230531150340.522994-1-detlev.casanova@collabora.com>
 <20230531150340.522994-2-detlev.casanova@collabora.com>
 <4a6c413c-8791-fd00-a73e-7a12413693e3@gmail.com>
 <5682492.DvuYhMxLoT@arisu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5682492.DvuYhMxLoT@arisu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I'm not sure about this. Isn't the clock still necessary when suspended for 
> things like wake on lan ?

Yes, but the PHY should know if its a WoL source, and not disable its
own clock. There is some support for this in phylib, and Florian has
also reworked it recently for Broadcom PHYs.

     Andrew

