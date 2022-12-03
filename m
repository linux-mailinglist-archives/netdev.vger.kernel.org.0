Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5C86416EA
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLCNc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLCNc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:32:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424AE1DDE1;
        Sat,  3 Dec 2022 05:32:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k5so7329790pjo.5;
        Sat, 03 Dec 2022 05:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDbQ/ixPZp4MuAgA81AzBaLcxOr0XSMHsSft2Avw78E=;
        b=DAcUroikxVvLn80Gwk/9VcQcseLDD0vWDs8loVwkpuS0FYWw+9DuTDUxxW2w4BI0T0
         +HjWbfZY/qdF5l+mLHbYnQmeOkCzi5lTn31NL4/3GaMnOo6dsB3Wq8VG/9hx4WGi8p2x
         ihSoCi2LAMU6EosEy9PbuUkKhMZ1Y7hFfpTatgNifXzAPVkLgq/n2Ey5CeCX30iirCy4
         aN5DFYm6+Fu+AcEU0sZplzVIknKSAbjTZ4El+SQQUj6Z+6C4aIo3pVoPlc7lIsmy6bwH
         ZjYDcNV0jQO9mK9R9TdhpSiRFF+Ooh+Y3p1uu3FDEvNQZV4vIt1KK5cuLLSXMuK+R6NZ
         uhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LDbQ/ixPZp4MuAgA81AzBaLcxOr0XSMHsSft2Avw78E=;
        b=XM8n9J+WHGDBRTEyaDTdg/tOXKPkEyhP0PXxa8Djmp/8KdbYMEiPq4qRjcd0hJedqr
         5FBNqJCJeOgOXX34RjNX18aAJ+fRJ0rWl9EY8vNlznJ/LTdcouSeunaTQFanXUxc6htF
         iglyDCRmQxtHglzGUrCveC4S9hjXLntlh3LJHnPXJvaw3EvhCTpADzd+MWfATAONtMgG
         JnL/FDD0Pk56Ink/zc4eXZTw/sTAAu/NLuNrXCgnCZkRRDEDj74SYjpC6AfYZmKEVnYh
         AHerIwOziLBe+9G/ZEYKBz5dGCXrb62M1AGTmsbeHtlaJ8pR3KF0HQui2jYoJgDXMgXx
         I3vQ==
X-Gm-Message-State: ANoB5pmlbKT1Y1c/muwDwTjwnCqPKzg0islgFs3pT0s7BMeLo0B2/Ln9
        MAH52/yeAR2jmrO3AU5LT5M=
X-Google-Smtp-Source: AA0mqf5Nc0j1Mx5FIWuxqTHyDKOot9BG829w40CZ4gxqboITEFsJ/QsGCy30VzXpYVRKnhUU4UV+UQ==
X-Received: by 2002:a17:902:7b84:b0:189:6623:4c47 with SMTP id w4-20020a1709027b8400b0018966234c47mr6131538pll.170.1670074344657;
        Sat, 03 Dec 2022 05:32:24 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:24 -0800 (PST)
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
Subject: [PATCH 1/8] can: ems_usb: ems_usb_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:52 +0900
Message-Id: <20221203133159.94414-2-mailhol.vincent@wanadoo.fr>
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

ems_usb sets the usb_interface to NULL before waiting for the
completion of outstanding urbs. This can result in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after ems_usb_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

[2] thread about usb_set_intfdata() on linux-usb mailing.
Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/

[3] function usb_unbind_interface() from drivers/usb/core/driver.c
Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/ems_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 050c0b49938a..c64cb40ac8de 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1062,8 +1062,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 {
 	struct ems_usb *dev = usb_get_intfdata(intf);
 
-	usb_set_intfdata(intf, NULL);
-
 	if (dev) {
 		unregister_netdev(dev->netdev);
 
-- 
2.37.4

