Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5046648DC3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiLJJFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLJJDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52371A391;
        Sat, 10 Dec 2022 01:03:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u5so7193909pjy.5;
        Sat, 10 Dec 2022 01:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fbmtr+iu05G8hE8+xl0zyODEJYTrkuIzNhZByD6qtnU=;
        b=UgzLWMXzuwLLSAvD3KHkxw0Bw89627SDEXoKyGTUeeML2rh1RnKO4wDuj3np4KehRh
         gbavZMR6IMWyNrOyBD3I6w3lEqDVKQCG8GUZGBrpuqvYECsIy+ZYEHwU95f0ezAzP5fv
         yF6WOlLlP2kIgwoKQBpKVizodDklO8bZ8GDcyAdIUNYygfxi6Zf+ne7vWUbL00IiDHdE
         5XalkUklF4SWXQ1dBsARtlGDm6i//q1t0YA9kJ6CBNVfS/6UxR2tB4VIXUfFiadNuAMQ
         6A3aPWcixahKkvE5ulLgEXMN89Z7v6dmsKPfg7Nc0xj0bMY7oYa8L6LOsUYf/mqOb0FN
         Nvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fbmtr+iu05G8hE8+xl0zyODEJYTrkuIzNhZByD6qtnU=;
        b=3KQvLBLW0Yarpz1XjvIoxdagUgGkpjzde9mpgvYciB+LItaXHRmCIAA4BZrsq5fsq3
         OPKB2T/sbiBTksyhXDMwXiWzbHY2VjaXicfryub31IRXOtIctYeP9uPQJnX4HZ71R3yp
         3KbQM6nJ7vMWLe6l1T2dURLpJYiyUPXORJNOrLsAH1x1PwgzDwcyCmeGKMRtSiz9BWtH
         4yXCskq+F4TPvL3jACM4YOX1Zojuue69Y6NZ1cIzxPqmL6luWwiOh9SHQnA/n7rWUQq/
         NoSRo2X392mYK7rV8PyfYr3ibssG49cfdzkV7R0xjctJt3cJ4c9rM4GeA7r06fre0aq4
         dXew==
X-Gm-Message-State: ANoB5pk60McBjFvt9qzl+TcW9vFk4ExsN4a/5Zct544nhtZ4QeY/F4BX
        ksWLGLInElZTu9a5aaO+UT8=
X-Google-Smtp-Source: AA0mqf51A0TZNJaaVYc00wBlbOrjqA1IBl3NJL6KTcsIV7XAYX+HxOIZ2l4Pt/lnCZ/U0cgPYIauIg==
X-Received: by 2002:a17:903:41c5:b0:189:cec6:7ac5 with SMTP id u5-20020a17090341c500b00189cec67ac5mr12370330ple.44.1670663011217;
        Sat, 10 Dec 2022 01:03:31 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:30 -0800 (PST)
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
Subject: [PATCH v2 6/9] can: ucan: ucan_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:54 +0900
Message-Id: <20221210090157.793547-7-mailhol.vincent@wanadoo.fr>
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

ucan sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after ucan_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/ucan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index ffa38f533c35..429b3519ee7f 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1579,8 +1579,6 @@ static void ucan_disconnect(struct usb_interface *intf)
 {
 	struct ucan_priv *up = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (up) {
 		unregister_candev(up->netdev);
 		free_candev(up->netdev);
-- 
2.37.4

