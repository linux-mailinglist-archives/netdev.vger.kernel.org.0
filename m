Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD74F3D70E9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhG0IKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbhG0IKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:10:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413C7C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 01:10:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I92-0006l5-74; Tue, 27 Jul 2021 10:08:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I8u-0005sq-D8; Tue, 27 Jul 2021 10:08:48 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m8I8u-0004Ek-Be; Tue, 27 Jul 2021 10:08:48 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Finn Thain <fthain@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
        <siglesias@igalia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        linux-sh@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/5] Some cleanups after making bus_type::remove return void
Date:   Tue, 27 Jul 2021 10:08:35 +0200
Message-Id: <20210727080840.3550927-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

while working on the patch set that made bus_type::remove return void I
noticed a few things that could be improved. This series addresses
these. Apart from a simple conflict between the two zorro patches there
are no interdependencies between these patches. I created them on top of
Greg's bus_remove_return_void-5.15 tag[1]. There might be further
(probably simple) conflicts if they are applied based on an earlier
commit.

So it should be easily possible to let these patches go in through their
usual maintainer trees. So please if you're a maintainer state if you
prefer to take the patches yourself or if you prefer that Greg takes
them together.

Best regards
Uwe

[1] available at

	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git tags/bus_remove_return_void-5.15

    see https://lore.kernel.org/lkml/YPkwQwf0dUKnGA7L@kroah.com

Uwe Kleine-König (5):
  nubus: Simplify check in remove callback
  nubus: Make struct nubus_driver::remove return void
  sh: superhyway: Simplify check in remove callback
  zorro: Simplify remove callback
  zorro: Drop useless (and hardly used) .driver member in struct
    zorro_dev

 drivers/net/ethernet/8390/mac8390.c     |  3 +--
 drivers/net/ethernet/natsemi/macsonic.c |  4 +---
 drivers/nubus/bus.c                     |  2 +-
 drivers/sh/superhyway/superhyway.c      |  2 +-
 drivers/zorro/zorro-driver.c            | 13 ++++---------
 include/linux/nubus.h                   |  2 +-
 include/linux/zorro.h                   |  1 -
 7 files changed, 9 insertions(+), 18 deletions(-)


base-commit: fc7a6209d5710618eb4f72a77cd81b8d694ecf89
-- 
2.30.2

