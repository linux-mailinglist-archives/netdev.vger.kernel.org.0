Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3839657015
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 22:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiL0Vpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 16:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiL0Vpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 16:45:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAD66374
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 13:45:38 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlF-00054A-NN; Tue, 27 Dec 2022 22:45:25 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlE-0029RI-0V; Tue, 27 Dec 2022 22:45:24 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pAHlC-008Nmf-VF; Tue, 27 Dec 2022 22:45:22 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 0/2] net: ethernet: Drop empty platform remove function
Date:   Tue, 27 Dec 2022 22:45:06 +0100
Message-Id: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=619; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=e60ZYcfSMDmUSWHra/CMy0Pw6mpymG4FwBvEQqfdmy0=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjq2dOLSU589LwjsAOGKoeW077mMKk++3kE6sK1lkV zRzoFFSJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY6tnTgAKCRDB/BR4rcrsCWP8B/ 4mnco1wWYAbTQjWVSH3jYQ/eIlkvcnL5glAUQTgg25lhdhOT1HzBhNasDpNq3l4G8lRiNU3gyVV1+O cv6vKvQj3vP/mnELpa5B9avcYXWAy2wRpbfHPBO7+TNPLAwN4eqkfFD7yd1C4QoVgKI/TbEx/vJBA/ Qxl/SD4D1jTmKv4sIYe1ZO6TM0iT3ZimksDaDxvg2nwxF/9+3wqm2T437XI3K11rpVjo9vo6L/P7dJ F7iUmEOsuMn+B5Gcn1CYaB39beVvvZTMRxPK6zD5uXs2l0dzvENRTUZ/EGfuIU5vWNFBCHbdMh9q8R oklwMqqC0pkHW0U0+t8J3sfmDJXVSC
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series drops all empty remove callbacks from platform drivers. A
callback that only returns zero is equivalent to no callback at all, so
use this simpler approach.

Best regards
Uwe

Uwe Kleine-König (2):
  net: ethernet: broadcom: bcm63xx_enet: Drop empty platform remove
    function
  net: ethernet: freescale: enetc: Drop empty platform remove function

 drivers/net/ethernet/broadcom/bcm63xx_enet.c      | 6 ------
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c | 6 ------
 2 files changed, 12 deletions(-)


base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
-- 
2.38.1

