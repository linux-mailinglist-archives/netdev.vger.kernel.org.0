Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB6648DBB
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLJJEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLJJDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:18 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E46CB7;
        Sat, 10 Dec 2022 01:03:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id fy4so6920491pjb.0;
        Sat, 10 Dec 2022 01:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1fa7mtks0N/WurNaTfmwfwJgDz/Tqfo6okS65bthdQ=;
        b=AQHUYbtOoW5Gne7fhhw+e8Pt4UFlo9+Nu4vpgd5hs5WV7Dg2+6E/HXimOsYcnS/MNa
         bONTYfrBLOjF/6xcYMtEEuBAsng7ZzR0upwS9cCuyiZn6BRedyqNzOMoYjr83bMnmQ8a
         FrOSxWHiy4R5qxakm5/uIYaZoPuGeSHxNxA5gi5rlqUJ84+2i4E3Qn0aFxSuZCfqA0ZJ
         xY2+Tx4JZP11JslSBX0xvsmIvaQFnx2nPnO2fME3mPKelYpnrJ52B90nWUJelDXfTnVY
         olkrMaqbYXOUyyKvS/w9/e6ctCeVVZC3++jZ2IVd69dDJFHv07bQPnhJ7Xj8fOUGAVCz
         GwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/1fa7mtks0N/WurNaTfmwfwJgDz/Tqfo6okS65bthdQ=;
        b=s2SvjQAHsh0LLDSzgS92XJ1nv0mynazQvY3dsyf76rdF9akSRSqO8qPWhWHXIfzhI2
         Shh0hRjxEkRUVWQ7OOxm8jGfQeBqHuknUBQCCmIBE2aWPkjoXMUdI8PxgUsxjE0o7yWE
         IpzbAQsanNVS6kGeVdZbKK0dBaJLoA4iXV4HcrWjkJTgLyQYp5A6lLH2arkJHKwcyBWN
         Yk+cbZHmmnBq2vOafvDlOE1GgHTZkeKX7PvADXaQZmLUtPNl3GfZcS3QQ7Tj0tNimkjG
         1I+RvzEW54svW1PlVoXnk0mIhHBUrMBQHk49TyJUVympNw9ig2pn2WdUjWmpHEvhYnCS
         2Rew==
X-Gm-Message-State: ANoB5pk5G3mzxX3aqNqD2vj04zTrb8KYTWVKsxvWA59Aq2LRNGFo5NAB
        qhyfip0o8gSsEjmd9OanjyA=
X-Google-Smtp-Source: AA0mqf6cwDtpJ2vszh+ZzDEn0dKGGcq/YPifGaOTVRf4SeuJE5E8MJgxMGnS5xVQzz+YG/2s1smO0Q==
X-Received: by 2002:a17:902:ab07:b0:189:529d:a464 with SMTP id ik7-20020a170902ab0700b00189529da464mr8592241plb.17.1670662996607;
        Sat, 10 Dec 2022 01:03:16 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:16 -0800 (PST)
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
Subject: [PATCH v2 4/9] can: kvaser_usb: kvaser_usb_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:52 +0900
Message-Id: <20221210090157.793547-5-mailhol.vincent@wanadoo.fr>
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

kvaser_usb sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after kvaser_usb_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
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

