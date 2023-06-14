Return-Path: <netdev+bounces-10563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8851C72F127
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA0281C2087C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E3737A;
	Wed, 14 Jun 2023 00:52:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C67F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:52:06 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11AF198D;
	Tue, 13 Jun 2023 17:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=m81/mtRzPNxBmTZ8Ug6NdeknJttcACMBx0HZCk1Hkgo=; b=p5G2THXg3xa8nntRnhKlwoMbZX
	Mv87KPbErYJueTmkXbxD2FGYcxY+G6PXZnN4rjSu3CkN1ZU6qV1Wtv6jyPaiVRSP4ipqR5WioPwWG
	DoLsSpkorqejlBT8+UlvdrZ5MlNkO/9W/wBJjG/NhSfUYNGkG6Cx73q/PwXNZsQ4bivc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q9Ejv-00Fsaa-5j; Wed, 14 Jun 2023 02:51:59 +0200
Date: Wed, 14 Jun 2023 02:51:59 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	linux-leds@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 led] leds: trigger: netdev: uninitialized variable in
 netdev_trig_activate()
Message-ID: <83344fe7-6d95-44d8-8ce7-13409c7a8d87@lunn.ch>
References: <6fbb3819-a348-4cc3-a1d0-951ca1c380d6@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fbb3819-a348-4cc3-a1d0-951ca1c380d6@moroto.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 09:46:53AM +0300, Dan Carpenter wrote:
> The qca8k_cled_hw_control_get() function which implements ->hw_control_get
> sets the appropriate bits but does not clear them.  This leads to an
> uninitialized variable bug.  Fix this by setting mode to zero at the
> start.
> 
> Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> v2: In the original patch I fixed qca8k_cled_hw_control_get() instead
> so that patch went to netdev instead of to the led subsystem.

I think his actually needs to be merged via netdev.  e0256648c831
("net: dsa: qca8k: implement hw_control ops") is in net-next/main.  I
don't see it in leds/master, leds/for-leds-next. Also, git blame shows
mode was added by 0316cc5629d1 ("leds: trigger: netdev: init mode if
hw control already active") which also appears only to be in
net-next/main.

A lot of these LED patches were merged via netdev because they are
cross subsystem.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

