Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1661F6416FF
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiLCNeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiLCNdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:33:42 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4B322511;
        Sat,  3 Dec 2022 05:33:00 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 82so6668813pgc.0;
        Sat, 03 Dec 2022 05:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUGXSmp1ZJ/eYw9KYmVeYUew9c/fKsHy+JMyV+9A5gU=;
        b=p88mR7C9zUmDCLuVxmPNdnLSBxBsfuHJ2Vb1NG7ek7qBN0HXp+UAqMreKcwbhBX6Nr
         BVxcl1WzQykRnSBa+xQxpLnFmpBhcyFJtf40/FFweBzbhzTFYwGfW4YjNzpEfdMUwoBb
         AZ17g+qUNP58/IG6Kiqf3hoHCYNJbf+qRCx2IsDAqWkksqBYLgUAQPQq5E0JqLlOB4Ua
         0gEgoX0kuhc/x8MwM6d/59mPQw4pEGF028F7x+4i6zLEenehjJe2yiVLP0mmo1uq75Qh
         2Ctv1dGEm/IIyfZNRTwX0wbsT4SNVQgj45ixLLbhA/SsZtxBZqISLv5oc4R4C1PSUDe5
         I57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AUGXSmp1ZJ/eYw9KYmVeYUew9c/fKsHy+JMyV+9A5gU=;
        b=BMjp0RcUk6zqZHwUGIJVa6b3Sc0QSH7mxFK5ckKFz1YfXLgyZ5QC7C04CyNRzmNgfK
         Xp80IiJrMWJw9sVT4kAGZzagcQSeL44/LhflSAUjdGdUmrD618ekouxZgOV7GgFWxoW8
         hEZnzyOAWirK/b/4Qw8Vf27n/sW+rBqZ/NvTv1w/T4+A9cZxmuTLLK4wsTo6rD0ddDA4
         o11tPbgsHnKmbSrAzPV2jmwD5Lzf15aqxZnNeX8+YiRAFM1FyHtbDuRQgGUvy5ZrekXn
         72PZLqT1ekK+BUVlnL1XRp/YPXLJqqyjDBAGepEMdfUZ+WrN4XcevgSk28lUbeklPC0h
         VYMA==
X-Gm-Message-State: ANoB5pk3gIv3GWCnqYrm3lnd3NWQiUd36/MRtcAa/XzaPVg97ViuBi+c
        X/0ZrZDRBFM8POS8Whb/RBM=
X-Google-Smtp-Source: AA0mqf7UqEufAxToFJc9AlhYIYdD6c5zlMOTYkrBADevjz6aVVsggEY3ROUFVVTJY/LM8yEooT6cOA==
X-Received: by 2002:a63:fc14:0:b0:477:86c1:640c with SMTP id j20-20020a63fc14000000b0047786c1640cmr48540634pgi.226.1670074379752;
        Sat, 03 Dec 2022 05:32:59 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00185402cfedesm7414472plx.246.2022.12.03.05.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 05:32:59 -0800 (PST)
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
Subject: [PATCH 6/8] can: ucan: ucan_disconnect(): fix NULL pointer dereference
Date:   Sat,  3 Dec 2022 22:31:57 +0900
Message-Id: <20221203133159.94414-7-mailhol.vincent@wanadoo.fr>
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

ucan sets the usb_interface to NULL before waiting for the completion
of outstanding urbs. This can result in NULL pointer dereference,
c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after ucan_disconnect() at [3].

[1] commit 27ef17849779 ("usb: add usb_set_intfdata() documentation")
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

