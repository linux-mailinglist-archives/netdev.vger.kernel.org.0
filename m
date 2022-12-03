Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8386416F7
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLCNd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiLCNdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:33:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FBA17880;
        Sat,  3 Dec 2022 05:32:46 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h193so6605285pgc.10;
        Sat, 03 Dec 2022 05:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOfYV6CW+avnaQrtamVGsJG2bps7tCEFlf1CMaOsNsw=;
        b=oR3qU0yGIU6iOVxIuVEsaLNO1sG7NxQvlVqOJ80orEIdFjBHtPWRt6o4v19aDO7z6N
         1dhba3k9yINO1pkZIQ0NiR+H32RiclgG3wohPdPhJzgd8d18WAnsOqIDo/Y+EwAsKfvX
         FmC1co2ixcRv9pPMVaA9BnghXnetjra3pLc3powVIXsXnkO4TshoPLjrZgtkcUYWYrZP
         evduuq2dw704I8aR87KM7UoKzlXt80CXgrmOUAMrXAN/Sw65D1m761T+HkR4pO874yrk
         nXuVpgrAUqUVnqpvw88qNcHpETQB5yoRX0mW+Xs5UgfrE2eRCOX+EjU3IZ2UXUkPG7Ez
         FvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dOfYV6CW+avnaQrtamVGsJG2bps7tCEFlf1CMaOsNsw=;
        b=ryq7PeECd42kSnTifxKgG4mhg4HpCHp0WIGIcm6LzECFUK6oT2rRkaX0J45PFfGCG7
         XK75f3wFwYNRtkEgYDx9Hpb5F/llJU6rApE2CO8bWD/5tP4uD1Oj94TNvZl/n1kmPH3K
         JowlrEUqv2VFTyWVVLcyooBu7YLmwTqpXszhkBMzxXVkitUpyR9AB11Q+bK11FD9C/JR
         7vjJ1o+aqSV12uhTfvLy6P9weI8Jan/nVdlCDBdtN+YqqBjlZu8DAC5W1WgRUwcJXEDl
         jNcj2wwoItIU0902vqens/xJSR4vubVkYYZVuyRYGIJxVhUA7XgXeCg8eBAyjdC5+Fq3
         bf4g==
X-Gm-Message-State: ANoB5pmOA4HnSd+R5r4cFpOJnpUHkNETi7ll3ayeOS0/kMS16LZO9Ag+
        IRTBSEpRUhgb4UdqnkC63GY=
X-Google-Smtp-Source: AA0mqf5U0iuXdFWuufaxrcdaK69EB+htl31ZfowQde7TbTbB64N+6tZpe49HZfw+UoKEoP/K5vFGHQ==
X-Received: by 2002:a63:f40f:0:b0:478:1c89:5c9a with SMTP id g15-20020a63f40f000000b004781c895c9amr25227135pgi.384.1670074365730;
        Sat, 03 Dec 2022 05:32:45 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:45 -0800 (PST)
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
Subject: [PATCH 4/8] can: kvaser_usb: kvaser_usb_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:55 +0900
Message-Id: <20221203133159.94414-5-mailhol.vincent@wanadoo.fr>
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

kvaser_usb sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after kvaser_usb_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
@stable team: the function was moved from kvaser_usb.c to
kvaser_usb_core.c in:

  7259124eac7d1 ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 3a2bfaad1406..dad916b3288e 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -981,8 +981,6 @@ static void kvaser_usb_disconnect(struct usb_interface *intf)
 {
 	struct kvaser_usb *dev = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (!dev)
 		return;
 
-- 
2.37.4

