Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2566416FB
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiLCNdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLCNdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:33:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE551EAF7;
        Sat,  3 Dec 2022 05:32:53 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r18so6599632pgr.12;
        Sat, 03 Dec 2022 05:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eF9XShE5TJVkfnfRnJlkYlYYSsfKbTDmFNqULVnSW+E=;
        b=qCVa8HcyTJPvaxUsBydSGsuhXbxjTWPrYKA/b2wF5kUy0UWg5wRLqjNL6rZRlwxX8e
         v0EZNF6FPAzyLIMGqfxKiVhMlIjtKA5LNEq7y2/kdNto4pklx7bsgbRVf9F3FAjBAXgQ
         eq/B5hKXAxVkyzE0m44vtQEfgxYszsH4bVXJS+QP5DP6gJqLX0HTUVqUviOJcIOUCTO4
         8F4hn39Oe+zSWsV+DDxiA0+1lQcyjlviSXn2Rz0NSjy9R8SyQCTts6Xmzwx9qhHsBLFX
         mG7EVUWVSTbZ+xVrmhSmXkZnqJaUnD5P0LquuSB0pMDnsSG0W6ovLs93/B3JxWWPFAWN
         LUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eF9XShE5TJVkfnfRnJlkYlYYSsfKbTDmFNqULVnSW+E=;
        b=V7P0EsyiFwO2YIuHHgOJysa8OO8qRnKJ7gtgRQEXBkiqBcNM9WX1InJxteNgmjpfYR
         +42I7YlKz3CDm+xS2VfkX+nBFdm/BhruQhGPiSvjSboqNlwJ1wMdH7JUFJvD2d1Quicw
         6wUoewTTmlfdI+1wY/RJNJ9E8ekNq4Y17w/IK+MkyfXumUaPCLHYLaHE/RC8YtEoMdz4
         lhZZ3G7nKYqt+ilqDgq+KZJbS89bfZs4AOPJOOI+gGfGir505/QRgbg8tT47lMH+hhl1
         XyBETm2dxcGcqwpzbP4ReL47+PD2XsMwvSaXskCzJIovoRuckizyaTDxmeBOYGhZj9u3
         dQbg==
X-Gm-Message-State: ANoB5plhTviFBVQ/g53llBT1zCis5xgIVUgFP10/R2NU0N7WN6Sy7mE1
        +j50FEsNwPkgvB2H6512dbM=
X-Google-Smtp-Source: AA0mqf6yBRx7vd+hKPw5cCnOi+O438dLHdlH19SDLTH0Wupse3Q+/hj/PAxljBNAtn/pnWlxhiJwXg==
X-Received: by 2002:a05:6a00:1624:b0:573:993b:ea6d with SMTP id e4-20020a056a00162400b00573993bea6dmr58237780pfc.10.1670074372733;
        Sat, 03 Dec 2022 05:32:52 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:52 -0800 (PST)
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
Subject: [PATCH 5/8] can: mcba_usb: mcba_usb_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:56 +0900
Message-Id: <20221203133159.94414-6-mailhol.vincent@wanadoo.fr>
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

mcba_usb sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after mcba_usb_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
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

