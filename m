Return-Path: <netdev+bounces-6391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD0271615F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E71B71C20C63
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579BE1EA95;
	Tue, 30 May 2023 13:17:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2891DDD7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:17:55 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18ACB0;
	Tue, 30 May 2023 06:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2+FWL9/dJsfwq9Dw9GMVMyftmb9srBkeDarzGucYdi8=; b=SrxWoo+iONfV/YLw1wmEmLwyWw
	mNS1uzXFMZ1kD0qaMqksBmn/Adw/2PhQz+4iZmptUW06VydzB44n5oDdjFbsK6O8VOsVK5ghpqHE9
	6/HSaJ26KVZjrxkjGFmJKd3j5j2mzcXa1BPMS3Wtc4wfxnNJzuJVFsWyL6QCkCWrgWQk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3zES-00EKUx-NP; Tue, 30 May 2023 15:17:48 +0200
Date: Tue, 30 May 2023 15:17:48 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: Russell King <linux@armlinux.org.uk>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <32aa2c0f-e284-4c5e-ba13-a2ea7783c202@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530122621.2142192-1-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> One can disable in device tree advertising of EEE capabilities of PHY
> when 'eee-broken-100tx' property is present in DTS.
> 
> With DSA switch it also may happen that one would need to disable EEE due
> to some network issues.

Is EEE actually broken in the MAC/PHY combination?

You should not be using this DT option for configuration. It is there
because there is some hardware which is truly broken, and needs EEE
turned off.

If EEE does work, but you need to turn it off because of latency etc,
then please use ethtool.

     Andrew,

