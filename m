Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157E36416F2
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLCNdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLCNcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:32:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5F360F0;
        Sat,  3 Dec 2022 05:32:39 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f9so6619432pgf.7;
        Sat, 03 Dec 2022 05:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NN1lPw0dT0r0dxpD5i+4n4JI5HSJYWUCgSgnFm00Ec=;
        b=ZfPzGX3AXqYfFvV73ykrZYYM8mbxAMDbiDekjrzIc4KU+ynXH+cVvEvFvyn7/xmZp/
         Jlx10WWXTpfUCTeisyAhpcRYWAzE3uYPWOp1ojHYe39e55k37rF2E+nG5ED82moCuxV9
         ub16LINdqz1+JNuTxuOLHhx1M1dsTdh9+J6tNGAmC7lZI1osmsMx4iRB02xnMztlwsD/
         Y3G1m2YDOFtdOjKqXgVx56NbLshBBs1M77nB6A4f+3QIW2rVQGwnOVDInP2yhVCZ4s/D
         Cs6PRWsXXzuL4G7GMFuX0OxQGlCQhvXlk4ITlG9G9ryW4Y3stbV+0F/ZhKPJ3MDK7SRg
         kB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0NN1lPw0dT0r0dxpD5i+4n4JI5HSJYWUCgSgnFm00Ec=;
        b=BjFalEmNH9XxMWGlgUNfIfbx0HWWxv9l99zhy2MOxDY+0OBxawip8yHmAhlSKq0kzg
         voX3MBSnw7nkguWpWsTIkftOIVN3C+MGeyanXuq3up++apYMX1jBBkuod8v4BSLEB2ko
         O8nHDAGLxdD0dw6G9hTOZPGI2WGKjBqCG9aDBkxWG4Vpg43OlUJinLZ7F339uqayGakt
         4hbCx+ed/YdDk3H63g65Zi8WnTW/5Q4bAMrGVUGfIvSS3/VnIDDpOJQd9LOipSTyOPC4
         /6qghEPL44uSJvIldtjh3JY5t80cUl1zzCQ3cEqz2EzkedLfUKa+fIr23tjILVCEF3o+
         VWCQ==
X-Gm-Message-State: ANoB5pmpX45upeTTGLbg6+CPt6+VZIgNGTwb3sR/PUmbsUs5IyOvZTaj
        HMb5JGajFFV9lohtgM0PH1E=
X-Google-Smtp-Source: AA0mqf7qlKU9WPRgbC7P2r8+RQaPTX5TAimrYHz2O6sRXQ0T3jvnmcB6Vffda7JOwBIiB3myqxjB4g==
X-Received: by 2002:a63:ea15:0:b0:457:7285:fd2d with SMTP id c21-20020a63ea15000000b004577285fd2dmr49887486pgi.580.1670074358721;
        Sat, 03 Dec 2022 05:32:38 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:38 -0800 (PST)
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
Subject: [PATCH 3/8] can: gs_usb: gs_usb_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:54 +0900
Message-Id: <20221203133159.94414-4-mailhol.vincent@wanadoo.fr>
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

gs_usb sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after gs_usb_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/gs_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 838744d2ce34..97b1da8fd19f 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1458,8 +1458,6 @@ static void gs_usb_disconnect(struct usb_interface *intf)
 	struct gs_usb *dev = usb_get_intfdata(intf);
 	unsigned int i;
 
-	usb_set_intfdata(intf, NULL);
-
 	if (!dev) {
 		dev_err(&intf->dev, "Disconnect (nodata)\n");
 		return;
-- 
2.37.4

