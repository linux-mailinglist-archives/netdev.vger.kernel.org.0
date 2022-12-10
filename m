Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F995648DC0
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLJJEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiLJJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:30 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B53F17597;
        Sat, 10 Dec 2022 01:03:24 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jn7so7291323plb.13;
        Sat, 10 Dec 2022 01:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iy6XntU3ziYyOfLWnkl9Fuz5o2kWJR8AuXRUOe4t654=;
        b=FswO23llZrXl/OXDY6zvuq2w9p3gmOC4Sz++bcYGUMjhRqXguI2Uh2d+ycRX5eN9JN
         nZWSJEiOgoTX4JANFZsLCmrwQpeEEt1jHFXFY2u8iPP+jVt3MmJVYCSAdB5xxoHnjvOv
         skgbJ/q8w8kr3ojxEQGGvngEuNt3HjOa2la+cqek1EHHxpRsyLKHtI9x8P4Sec7+IaX8
         feGqDEHzwX5CExoACRG8upkGbxTnDs5vBwjW627Xtr/1S++7r+z7G4a397otKMzC9erF
         RO4qO2gBke7CMHYFa1ntZkYJYWsrCJ9NKmDdLTsGl28XuN5M6NwK3T5HO8WfJ1VlQLII
         DIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iy6XntU3ziYyOfLWnkl9Fuz5o2kWJR8AuXRUOe4t654=;
        b=rpY7gehy7Dx4vABA7Zb8qV+AlkWXipxlqqcYDTWVP0WnO+BMDjfhEerGPeuSXTTzkT
         XWG1K5TkT1nWdo5Rk+FmijzgvbIkm26xoYrD0JpyQF0hocfUi5YQYefZDDru2/vdg2Om
         U0uwoWWGQUoreFhVSUbGWIqBs4phANPsJhmqXNwnfnuN+w3b4CqR66/AyZs8V8geWUOy
         rHbPHJRa9BaigLDM/CXSOvHPWzTmvTAoPzqBpW7lfDzTTRXvVge2JICBpdpkNGdKfZmo
         7boVYxECWyJBWXC3FfpWnYCpVnf/1ZQpw4Tx8IsUlJINjjA+aYh9r2YUFriID+UsGKYk
         5wkA==
X-Gm-Message-State: ANoB5plyejyzzDVS/absyEdKYHh4xcICR4N3BoVpmV0+NvLoTYeGsCWU
        tyKkU5YiT2aaJbPiCjo8Azw=
X-Google-Smtp-Source: AA0mqf4wuYfD+g9BmttjzHl9v1j3+bmN1XNA7uESR0IOMZUaeWaCfrMuwOIEhX/CgeVrPbt/vNZgBg==
X-Received: by 2002:a17:903:2446:b0:189:a50d:2a40 with SMTP id l6-20020a170903244600b00189a50d2a40mr11552395pls.45.1670663003927;
        Sat, 10 Dec 2022 01:03:23 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:23 -0800 (PST)
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
Subject: [PATCH v2 5/9] can: mcba_usb: mcba_usb_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:53 +0900
Message-Id: <20221210090157.793547-6-mailhol.vincent@wanadoo.fr>
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

mcba_usb sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after mcba_usb_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/mcba_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 47619e9cb005..a21c1ad4894f 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -890,8 +890,6 @@ static void mcba_usb_disconnect(struct usb_interface *intf)
 {
 	struct mcba_priv *priv = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	netdev_info(priv->netdev, "device disconnected\n");
 
 	unregister_candev(priv->netdev);
-- 
2.37.4

