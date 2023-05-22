Return-Path: <netdev+bounces-4290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1669F70BE84
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF2951C20911
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E12D53B;
	Mon, 22 May 2023 12:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90FB12B70
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:38:55 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A58CE41;
	Mon, 22 May 2023 05:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=hPu/AazTv/w0F2gJ1g4NuU0UDYvLNu6oyiHlrR50Mkk=; b=qe6mf5vUlwVjFJV9D5vtSUnTk1
	nca5JvSV1SUqZ18V0lTp3xbqGrmpElOUrzTJZ2ypwc+n0BKpF0PWI9/MV/lvm22Aed5w0sHpYiAgV
	u68YGunI90U+Oyjr5S94dnx5a7WSzNSG3jygwcqanIs4Mqb7g7yCo1f4looQ8cu/n5h8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q14Vm-00DXQ1-MQ; Mon, 22 May 2023 14:19:38 +0200
Date: Mon, 22 May 2023 14:19:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <237dbb7f-8979-4435-a099-95bb5d093910@lunn.ch>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-8-alexis.lothore@bootlin.com>
 <ZGeLEbcCHzOASasC@shell.armlinux.org.uk>
 <1c104034-b61f-5242-40fa-339de59ac9c9@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c104034-b61f-5242-40fa-339de59ac9c9@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Not exactly related to this patch, but please do not rely on this "max
> > speed mode" - please always ensure that you specify the phy-mode and
> > fixed-link settings for CPU and DSA ports in firmware. Thanks.
> 
> I would like to make sure to fully understand your point:
> - when telling so specify phy-mode and fixed-link in firmware, you mean
> device-tree, right ?
> - when checking for code and execution flow, I observe that port_max_speed is
> always called and its output is always used to configure shared ports mode in
> mv88e6xxx driver. Are you telling that eventually, the whole mv88e6xxx driver
> should stop relying on port_max_speed_mode for shared ports ?

Yes, the concept of port_max_speed_mode causes problems for PHYLINK,
and we want to remove it. Russell and i have been updating DT
descriptions adding fixed-link and phy-mode properties to all
mv88e6xxx systems so that it is not needed. Either at the end of this
cycle, or the beginning of the next we will change the code to
actually enforce this.

	 Andrew

