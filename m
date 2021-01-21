Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5892FF6D2
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 22:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbhAUVJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbhAUU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:58:15 -0500
X-Greylist: delayed 485 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jan 2021 12:57:22 PST
Received: from antares.kleine-koenig.org (antares.kleine-koenig.org [IPv6:2a01:4f8:c0c:3a97::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD63EC06174A;
        Thu, 21 Jan 2021 12:57:22 -0800 (PST)
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id 4F281AD8EB0; Thu, 21 Jan 2021 21:48:22 +0100 (CET)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v1 0/2] isa: Make the remove callback for isa drivers return void
Date:   Thu, 21 Jan 2021 21:48:10 +0100
Message-Id: <20210121204812.402589-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

as described in the commit log of the 2nd patch returning an error code
from a bus' remove callback doesn't make any difference as the driver
core ignores it and still considers the device removed.

So change the remove callback to return void to not give driver authors
an incentive to believe they could return an error.

There is only a single isa driver in the tree (assuming I didn't miss
any) that has a remove callback that can return a non zero return code.
This is "fixed" in the first patch, to make the second patch more
obviously correct.

Best regards
Uwe

Uwe Kleine-König (2):
  watchdog: pcwd: drop always-false if from remove callback
  isa: Make the remove callback for isa drivers return void

 drivers/base/isa.c                   | 2 +-
 drivers/i2c/busses/i2c-elektor.c     | 4 +---
 drivers/i2c/busses/i2c-pca-isa.c     | 4 +---
 drivers/input/touchscreen/htcpen.c   | 4 +---
 drivers/media/radio/radio-sf16fmr2.c | 4 +---
 drivers/net/can/sja1000/tscan1.c     | 4 +---
 drivers/net/ethernet/3com/3c509.c    | 3 +--
 drivers/scsi/advansys.c              | 3 +--
 drivers/scsi/aha1542.c               | 3 +--
 drivers/scsi/fdomain_isa.c           | 3 +--
 drivers/scsi/g_NCR5380.c             | 3 +--
 drivers/watchdog/pcwd.c              | 7 +------
 include/linux/isa.h                  | 2 +-
 sound/isa/ad1848/ad1848.c            | 3 +--
 sound/isa/adlib.c                    | 3 +--
 sound/isa/cmi8328.c                  | 3 +--
 sound/isa/cmi8330.c                  | 3 +--
 sound/isa/cs423x/cs4231.c            | 3 +--
 sound/isa/cs423x/cs4236.c            | 3 +--
 sound/isa/es1688/es1688.c            | 3 +--
 sound/isa/es18xx.c                   | 3 +--
 sound/isa/galaxy/galaxy.c            | 3 +--
 sound/isa/gus/gusclassic.c           | 3 +--
 sound/isa/gus/gusextreme.c           | 3 +--
 sound/isa/gus/gusmax.c               | 3 +--
 sound/isa/gus/interwave.c            | 3 +--
 sound/isa/msnd/msnd_pinnacle.c       | 3 +--
 sound/isa/opl3sa2.c                  | 3 +--
 sound/isa/opti9xx/miro.c             | 3 +--
 sound/isa/opti9xx/opti92x-ad1848.c   | 3 +--
 sound/isa/sb/jazz16.c                | 3 +--
 sound/isa/sb/sb16.c                  | 3 +--
 sound/isa/sb/sb8.c                   | 3 +--
 sound/isa/sc6000.c                   | 3 +--
 sound/isa/sscape.c                   | 3 +--
 sound/isa/wavefront/wavefront.c      | 3 +--
 36 files changed, 36 insertions(+), 79 deletions(-)


base-commit: 5a158981aafa7f29709034b17bd007b15cb29983
-- 
2.29.2
