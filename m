Return-Path: <netdev+bounces-12254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EED84736E35
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6646A1C20D29
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF8E16433;
	Tue, 20 Jun 2023 14:00:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF671640F
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:00:10 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CF4E65;
	Tue, 20 Jun 2023 07:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=GdFs+TWfdnzasotJ75VrXISngbpJZNZxemLtPJOd8gU=; b=57fPC07sOHvE7GaZutM9buZcIw
	17JX9CXplffxiFW6K1Otm+XMhoTpqkN2ey0Wmo5SPQC8/hiQ/1rvQQGlourKMOxHzz1ABZOLnjWPu
	QcYxxQbgl7TQS9U0MPre8qZWrPSyX8bMW6B/xHDSS9J+TeS5GIcNNrE4h/6PqJnRgqr8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBbth-00H0FV-Tw; Tue, 20 Jun 2023 15:59:53 +0200
Date: Tue, 20 Jun 2023 15:59:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lee Jones <lee@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
Message-ID: <0462a658-8908-4b8c-9859-8d188f794283@lunn.ch>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
 <20230619104030.GB1472962@google.com>
 <dd82d1bd-a225-4452-a9a6-fb447bdb070e@lunn.ch>
 <20230620102629.GD1472962@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620102629.GD1472962@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > If you do decided to wait, you are going to need to create another
> > stable branch to pull into netdev. I know it is not a huge overhead,
> > but it is still work, coordination etc.
> 
> Can you clarify you last point for me please?

This patchset extends the conditions on which the trigger blinks the
LED. It adds a couple more values to enum led_trigger_netdev_modes in
include/linux/leds.h. Once it gets merged, i will have a followup
patch extending the Marvell PHY driver to make us of them. It will
need these additional enum values. I also expect other PHY drivers to
gain support for them. Probably the dp83867.c driver since Alexander
Stein already has a patch merged adding support for what the current
API supports.

If we merge this patchset now via netdev, -rc1 should have everything
we need for this continuing development work. If we wait to merge
these patches until -rc1, only the LED tree has the needed patches, so
these network drivers will need a stable branch we can pull into
netdev.

Both ways work, we can do either. But it is probably easier for
everybody to merge now via netdev.

	  Andrew

