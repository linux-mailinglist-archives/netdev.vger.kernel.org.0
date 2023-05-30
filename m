Return-Path: <netdev+bounces-6493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BECC716A6D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C334B1C20C4D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BADE1F92A;
	Tue, 30 May 2023 17:06:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB16125CC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:06:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F57A3;
	Tue, 30 May 2023 10:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=cbJMcgL8sepitxBgymeQdmGvxKO9Hu3xHDhHNL79zPw=; b=U8davLae0KrpS9fw74jt13MTLm
	cMj1grm2I5kceAfXlqsRJ1P/8RYXV+fVKa/52qfJ9CuLQukfGETHOHw6Qd+1ZpZ1N10muniK5YTR8
	Udh6eF4npxxKPAGQXEQ3PfLrrKTuWMIREAicQhIaYAvyYGYacgfra3+2E39CzdAEG0zY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q42nJ-00EMOZ-Tz; Tue, 30 May 2023 19:06:01 +0200
Date: Tue, 30 May 2023 19:06:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <f23ef352-f5d3-4d24-aadf-27600548b7f6@lunn.ch>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
 <20230529215802.70710036@kernel.org>
 <90b1107b-7ea0-4d8f-ad88-ec14fd149582@lunn.ch>
 <fb553ce5-c533-44a2-a134-fbb552f247bb@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb553ce5-c533-44a2-a134-fbb552f247bb@kili.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I don't see these as much as I used.  It's maybe once per month.  I'm
> not sure why, maybe kbuild emails everyone before I see it?  GCC will
> warn about this with -Wtype-limits.  Clang will also trigger a warning.

That is interesting. Maybe we should enable that in driver/net/net and
driver/net/pcs.

	Andrew

