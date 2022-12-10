Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0F6648DC8
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLJJFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiLJJEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:04:15 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116C125EF;
        Sat, 10 Dec 2022 01:03:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so10654086pjj.2;
        Sat, 10 Dec 2022 01:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pa3DAHwWDelaMryXafO6tGBc9UO2GhBo2ljQmz+7iQs=;
        b=M4QXAhvAH2eGt1ylyB64bOaFHwiFc+CBiEpoLnv4v1iGZPuAkFClsRom7OrmYnWnMG
         wZSKDciH8kf2sSAyO6QAoSUWsulapheuNTWfnUWBpx7ozuE7iolVMdqD178hdqtH6+qL
         fuKBbxroyOvt+Cpf268JUbrF3nOGNsI7YTTux0KSyf2aFyCobckTe5CtJrHGHGwr9HcH
         fZjCCjklWCoz6sZen8INjEYsOqRnU1J67OkyJdytUGhd5L2HOlKPd00UKQUe9bf3hwXE
         jQMR0jq9hI66lwRdhy/zsHxBqrcDfz+5s9gy3lAPiio3YYWGAbhMCFadZppsQTt+/Jng
         XxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pa3DAHwWDelaMryXafO6tGBc9UO2GhBo2ljQmz+7iQs=;
        b=MuxTGDOCmg4feQKMC7QEpM9yeMqer8QJiZyuy65SyTXo053B5IyMd/5AyJZm+VsO2V
         RuiBv/MvzjSZ0yjkg4aVrY1+XilP63bNnoNBt7higFYQmTsH7zgVZ2TikwKqJW3UUORU
         yNltwiPf1XE+npL8Soqy2jyofstu+ZI6EaTug7oblMz9A1fdsAQ+iI38A9TBahGIHma/
         6az7+kVE9WZWw6Ig+7fMXm44Yu8GPWw+jCF6PMGJd3EqhdbbNKKQaj1UBjXTIA8uxOWc
         EciBixy6NkKboSYw8rW6S8X3GQ6des535UYCbpOPwIVGoSzt8WEfZf091aZEwsk1PT6D
         Odgg==
X-Gm-Message-State: ANoB5pmaYnjRT6uM3TabeMx3upQ9gC/VBVkGaCaBP03P4N4jz0EhN0y5
        aKZf9DQgtE+do0nr+RQjNfk=
X-Google-Smtp-Source: AA0mqf7l6aaijQskDg/TUOxXIjLEe6zhoOOWBTpDEVkBrAma51dtyvuZYcEN85pbRkJ2fJDd1QLY2Q==
X-Received: by 2002:a17:903:4094:b0:189:7548:20a7 with SMTP id z20-20020a170903409400b00189754820a7mr7429526plc.56.1670663018501;
        Sat, 10 Dec 2022 01:03:38 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:38 -0800 (PST)
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
Subject: [PATCH v2 7/9] can: usb_8dev: usb_8dev_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:55 +0900
Message-Id: <20221210090157.793547-8-mailhol.vincent@wanadoo.fr>
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

usb_8dev sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after usb_8dev_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/usb_8dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 8a5596ce4e46..ae618809fc05 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -990,8 +990,6 @@ static void usb_8dev_disconnect(struct usb_interface *intf)
 {
 	struct usb_8dev_priv *priv = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (priv) {
 		netdev_info(priv->netdev, "device disconnected\n");
 
-- 
2.37.4

