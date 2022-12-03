Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D09641707
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLCNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiLCNdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:33:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7A936C50;
        Sat,  3 Dec 2022 05:33:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id a14so3319458pfa.1;
        Sat, 03 Dec 2022 05:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TT8CxN+zmR4GrrxzUdFUbZUJEcfWOEsYz1q7FCNTvzo=;
        b=DFLXM+OTbYQJOTlqVLpbrXaSeohYWmcJvZ+jS0JNZIMSBtykQFUTRRVJlJKPnbFIGq
         NlHcUNbfSyHsDCrHoG2cvPEUOdyzOMnhl3BSEqOwb7eR7tIuWPEHuSeE8pmTvn54cKdH
         kWa2adMlCuNPrlvsZc6Be8CkGhiQQRcK18MLOTEl2s483kpm2et3ZazQkKYDCoeKRi8j
         a8cfBqYbjMzIfLU7ZfojSCgos5wGeSTVi184RjR2K1Yohs+t+jKD+uMBm6KkzE7/2xC9
         vCk8iqhGoPKaHb4n+QZXwaYk4E3bm3+Y4lqcyMzGCWXXB9r2mQQVT+7tHbDUN63+Rj1f
         XSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TT8CxN+zmR4GrrxzUdFUbZUJEcfWOEsYz1q7FCNTvzo=;
        b=H1o3gthcI3oXdORYKIE/RgwGlVvxXKiT11m3O+ZmWZXD4a9tm6gernthxIpa4Fr+4j
         sBX7MQ1jAu9vHxTTJiW3a4HSvUMQNVNgPnRqROWrLzfKYokaPCrScRXhieTm658yRcUk
         PonkFd40sg9zCTO4OyqWEKb+RpBbULOkNgJe6ktDeJWVxhVWVPFBTgFLnmqhS9s3X3CV
         osmmcDwBY7Qd85gJKxlvEj/mroPDEjhDrhyPk+NP0Cr7esfoB4UcaqFNIS8uSR92DeOO
         RkHCHgC8MSplg0bX0EyHCg9+GJk/K9wYUk+zOokrMZcbLndJmwMbVR919+xpwKvKuRA6
         PIPA==
X-Gm-Message-State: ANoB5pnbxStfsGin2F1lYhNNBw3FAX0G00JVnCD6zqceVkC1Enbm3iXQ
        lRctmvWRg502npRwuemT30g=
X-Google-Smtp-Source: AA0mqf79UzNRO2eymOBMzSHWgk6BjcbIV4dLABYx3/wgG5dQCbuXgduuI0sr7Cbyrj0fhNt9RW4tFw==
X-Received: by 2002:a05:6a00:1696:b0:53e:6656:d829 with SMTP id k22-20020a056a00169600b0053e6656d829mr79016294pfc.63.1670074393805;
        Sat, 03 Dec 2022 05:33:13 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:33:13 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 8/8] can: etas_es58x and peak_usb: remove useless call to usb_set_intfdata()
Date:   Sat,  3 Dec 2022 22:31:59 +0900
Message-Id: <20221203133159.94414-9-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core sets the usb_interface to NULL in [1]. Also setting it to
NULL in usb_driver::disconnect() is useless.

Remove the calls to usb_set_intfdata(intf, NULL) in the disconnect
functions of all drivers under drivers/net/can/usb, namely etas_es58x
and peak_usb.

[1] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c  | 1 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 0c7f7505632c..4924f0be3510 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2257,7 +2257,6 @@ static void es58x_disconnect(struct usb_interface *intf)
 	es58x_free_netdevs(es58x_dev);
 	es58x_free_urbs(es58x_dev);
 	devlink_free(priv_to_devlink(es58x_dev));
-	usb_set_intfdata(intf, NULL);
 }
 
 static struct usb_driver es58x_driver = {
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 1d996d3320fe..c15200aebfb6 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -974,8 +974,6 @@ static void peak_usb_disconnect(struct usb_interface *intf)
 		free_candev(netdev);
 		dev_info(&intf->dev, "%s removed\n", name);
 	}
-
-	usb_set_intfdata(intf, NULL);
 }
 
 /*
-- 
2.37.4

