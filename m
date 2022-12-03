Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955576416EE
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLCNcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLCNcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:32:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473FF194;
        Sat,  3 Dec 2022 05:32:32 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 124so7405212pfy.0;
        Sat, 03 Dec 2022 05:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pjs45ntgNRASTRoyX7CM51YIxmh03yjLfxCM0EIb/0=;
        b=EnT1MsiDYta+wJlbS88GSMxblBGgTicp99DzVINXPA5Fp9QTb0bHsvWQKwe5CDhQqd
         R7TYERtUDrk0ODhRWv1WYAVnJgbOQXV+OdbaA4E3lsPFlM0h2LqVZT6KkSFfjR6zFlRp
         ahlPVSpN1FfKLTtTXMaxNfQhLCR6mpG6WW1pSvZEGvrrNQlYk+7bayx9CzTAy+40i8oA
         KvbxjQtKU9tiGAIJX0/7qqTfX7SMBN398G9ZMrR6Hy2oQP00C5rtuyPrzMNcZ+Ni/tc7
         P0zkvUPiVIJz+64PhAgxzmZ1xYCMiL7GuFO8n/HvRYZN4emxwjXySzMCkFF+CXlfY0bU
         2pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7pjs45ntgNRASTRoyX7CM51YIxmh03yjLfxCM0EIb/0=;
        b=t2tdo1l6s/3Otw92vKVo87xm/cMUHTzVPJK+aRrXlcsUu3h53KZhDoznZuN3yzzV3Z
         yBsBq45Vx9y9jnO7EKXeFQBPTqVkmfXWHh5gMSIR6FacbKAyfuXGJrb4Irt4N7jLuD4k
         lvv8ra5AW5xACgw8h7Z98DVIDoUo/iDJhKmipGhAJYmwggV2ax+2SpQjWOgcVLr5UyeD
         fol4l2uVQrQcTowUTSrOsXiJ29XDVSIl3+riGGqEyxLBGG9pZm2yuP7wkdGHSg+vHSJz
         i+h8SxapbJmC8JsgbphOoY93CguRSqp75LUTABgviK5wuqnSke/T70o6m9NXvn2kitmd
         qolg==
X-Gm-Message-State: ANoB5pk/sawkQyvoytumMklxLCMvhquM8QtkR7z8+exZ9edhqL2GJF0L
        HYqwThSwQuPjob5SZ+5AyPo=
X-Google-Smtp-Source: AA0mqf4GkQUNg2GaE5p5tEfPeqZfPvmhzgJDNXwdrYhpro3y4sDVD1ZxeDRJKmpwOKCIRfU8UL2kAw==
X-Received: by 2002:a05:6a02:118:b0:477:8106:b518 with SMTP id bg24-20020a056a02011800b004778106b518mr52640160pgb.106.1670074351718;
        Sat, 03 Dec 2022 05:32:31 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:31 -0800 (PST)
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
Subject: [PATCH 2/8] can: esd_usb: esd_usb_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:53 +0900
Message-Id: <20221203133159.94414-3-mailhol.vincent@wanadoo.fr>
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

esd_usb sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after esd_usb_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
@stable team: the file was renamed from esd_usb2.c to esd_usb.c in [4].

[4] 5e910bdedc84 ("can/esd_usb2: Rename esd_usb2.c to esd_usb.c")
---
 drivers/net/can/usb/esd_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 81b88e9e5bdc..f3006c6dc5d6 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1127,8 +1127,6 @@ static void esd_usb_disconnect(struct usb_interface *intf)
 	device_remove_file(&intf->dev, &dev_attr_hardware);
 	device_remove_file(&intf->dev, &dev_attr_nets);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (dev) {
 		for (i = 0; i < dev->net_count; i++) {
 			if (dev->nets[i]) {
-- 
2.37.4

