Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E95312B29
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBHHiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:38:01 -0500
Received: from antares.kleine-koenig.org ([94.130.110.236]:45668 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhBHHh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:37:58 -0500
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id 6B826AF36FD; Mon,  8 Feb 2021 08:37:15 +0100 (CET)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2 0/2] mei: bus: Some cleanups
Date:   Mon,  8 Feb 2021 08:37:03 +0100
Message-Id: <20210208073705.428185-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

changes since v1:
 - Added a missing ; found by kernel test robot, thanks
 - Added an Ack for Guenter

rangediff can be found below.

Uwe Kleine-König (2):
  mei: bus: simplify mei_cl_device_remove()
  mei: bus: change remove callback to return void

 drivers/misc/mei/bus.c           | 11 +++--------
 drivers/misc/mei/hdcp/mei_hdcp.c |  7 +++++--
 drivers/nfc/microread/mei.c      |  4 +---
 drivers/nfc/pn544/mei.c          |  4 +---
 drivers/watchdog/mei_wdt.c       |  4 +---
 include/linux/mei_cl_bus.h       |  2 +-
 6 files changed, 12 insertions(+), 20 deletions(-)

Range-diff against v1:
-:  ------------ > 1:  86b2bf521a84 mei: bus: simplify mei_cl_device_remove()
1:  10a3dfb49d4f ! 2:  807117116ccb mei: bus: change remove callback to return void
    @@ Commit message
         return an error value is modified to emit an explicit warning in the error
         case.
     
    +    Acked-by: Guenter Roeck <linux@roeck-us.net>
         Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
     
      ## drivers/misc/mei/bus.c ##
    @@ drivers/misc/mei/hdcp/mei_hdcp.c: static int mei_hdcp_probe(struct mei_cl_device
     -	return mei_cldev_disable(cldev);
     +	ret = mei_cldev_disable(cldev);
     +	if (ret)
    -+		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n")
    ++		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n");
      }
      
      #define MEI_UUID_HDCP GUID_INIT(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \

base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.29.2

