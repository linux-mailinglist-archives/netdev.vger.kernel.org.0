Return-Path: <netdev+bounces-12087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 296CB735F6E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7ACB280FB9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8550615483;
	Mon, 19 Jun 2023 21:57:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C0A14ABF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:57:21 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F3F1BB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=Efr0d1wx9LuSotDOugefogwloCPWrx/oNbiurfaJvok=; b=L1DZymIN0FgZza8CLu4zlVQkb0
	fct/Fif0gRkhsbK/oy7IdQ6MSGBD4tO/UgdK4kOvbiISPfQ2t/GHNbP0WFG4NcDyZIOTBpfrJ8Rh1
	nD0TOla7rnIvJ+U7Enzddiu6oWamDNEt5OLNLUS1i7RctV1al7co9L9jsx6BFyO1098k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBMs9-00GwdC-Gq; Mon, 19 Jun 2023 23:57:17 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 0/3] Support offload LED blinking to PHY.
Date: Mon, 19 Jun 2023 23:57:00 +0200
Message-Id: <20230619215703.4038619-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow offloading of the LED trigger netdev to PHY drivers and
implement it for the Marvell PHY driver. Additionally, correct the
handling of when the initial state of the LED cannot be represented by
the trigger, and so an error is returned.

Since v0:

Make comments in struct phy_driver look more like kerneldoc
Add cover letter

Andrew Lunn (3):
  led: trig: netdev: Fix requesting offload device
  net: phy: phy_device: Call into the PHY driver to set LED offload
  net: phy: marvell: Add support for offloading LED blinking

 drivers/leds/trigger/ledtrig-netdev.c |   8 +-
 drivers/net/phy/marvell.c             | 243 ++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c          |  68 +++++++
 include/linux/phy.h                   |  18 ++
 4 files changed, 334 insertions(+), 3 deletions(-)

-- 
2.40.1


