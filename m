Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA55648DD0
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLJJGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLJJFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:05:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1B227FCC;
        Sat, 10 Dec 2022 01:03:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so10662153pjp.1;
        Sat, 10 Dec 2022 01:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BAIDUqCFCbste3E2fgCqiNLLF34YAvsqIts/qVZT5VE=;
        b=KMX9ZOUf4MOtPI3r5RMOVeguRIHaPIyxTnjBz3h5KoXtV0Mi4dAhXXID6SvrMZuL0F
         wB1cVuDX5UJgsOCnTM0W1RpO2RQc527nxUWn5/cKwb9Oy30pguJqK/ApNxMtraAdDNK9
         Q0/R3CfADH4p6YRGoY6dRiKxAehFTZaoRIh5+cpQJdU0kQNGjKL4u1332qT5ZebH+AGe
         Sn2Obg7ltato8+uWw6CJ962vqH46u7EkVZ06bb9asTkrl2LOCXnZt6HkxUg6rnaAE1Q1
         JiGQ2iZZlhMei2Ama4LM0PO8yv4M7QC8Ve/dsg00R9OJvptaFnD4T3LM2hCWYGK0XwmQ
         cmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BAIDUqCFCbste3E2fgCqiNLLF34YAvsqIts/qVZT5VE=;
        b=c0KB1LFFEZoj2AuLpcPdNywJnCdzWOi+Xc78FEyoi2tEYTbV4jERRlzddjp5DJEYFP
         0W2pZAzcJcf1q0p76bH2prZcrvCRYuAAQe1UiB0oOL/E/Qcu/3Y5jb+EeuvOUwO3Yq0b
         OJ1184cLNAFJlJ8jemiu+Je1Ss1+SONBEpMo5yD3A6OMwSOwzaL3YmAkapDcs+oTvAZ9
         MTnrO/YSaG1br81lhxXivldIWEFL9B2kafDgl5lh6mEdo+3Q3fpt6HcJjLLoitZPC75H
         dMwvS5+HoEOmIp3hX3hrLl3ZnZvrbEnDvVpgZO2MwbXamaq3HwHeJXYu9z2KgNac2Ggt
         YSqA==
X-Gm-Message-State: ANoB5pmWJkcKciilxaBAr9+jMgUyu+u5zSipO+HoWZG6IoRlL/8CquxN
        SgDRGEnEjBxNoQQhbOryQhc=
X-Google-Smtp-Source: AA0mqf75zMExLL9eNxNluj/yWIbD7LwbEOwAKajUBM3OPlZXX+Jn0XU9ey/Y1CqgCKIJgHGJkinT6w==
X-Received: by 2002:a17:902:be05:b0:186:59e9:a261 with SMTP id r5-20020a170902be0500b0018659e9a261mr8546405pls.43.1670663033101;
        Sat, 10 Dec 2022 01:03:53 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:52 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
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
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 9/9] can: etas_es58x and peak_usb: remove useless call to usb_set_intfdata()
Date:   Sat, 10 Dec 2022 18:01:57 +0900
Message-Id: <20221210090157.793547-10-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

Remove the call to usb_set_intfdata(intf, NULL) in the disconnect
function of all drivers under drivers/net/can/usb.

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

