Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23355648DB8
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLJJES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLJJDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:03:18 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E660EB4A8;
        Sat, 10 Dec 2022 01:03:09 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso7400920pjh.1;
        Sat, 10 Dec 2022 01:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Z10lP26tLNF8l9gnqOlj3ECah9AEf8DusZ0dGN4b5k=;
        b=Le5Q1XRol57xXCFL5WsRZ+jh7djRMnNzZOh2uKS+gOEhZGfEksKmYMClZz3KdAgIlc
         d6FJUW4xsKRXzt127nL1rcZi6QHP3CPekN242s3ws6X2YcCpSqLfoTNYvmRsAf49VkTb
         vU1FvvVuPgqsAjti76/YProtW23B4agrbhwvygQ8DFlaCO0eoWRv1Qk2t0bG+rZCKqQJ
         v61r1BmJN2x3oWYDE1SsiTkj165h+MhLtCbzNZMiDD4E84NvPjHns521xKXxT49oVEMi
         zX4WqILrI6rfiIpdKnWMmeew8xlBkhMfJl8F3TGbKqg5fEe6bmmZgy+eAsS/jhh6D3b+
         4Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Z10lP26tLNF8l9gnqOlj3ECah9AEf8DusZ0dGN4b5k=;
        b=ua8vovFHv4EVGSGPaPJjo9ZiF/CJiXlA3xFu0/bstkFvLkWmYq3jSY0dcSDoYHBsNO
         Q4POd1nsdcbpsqr4vtYgSXrZf1jvIlKdFZdJZKJXXw82Ig/v3ALYyv/5yhbp1CFpY1rS
         B9LSy1JVKYf6nI2g6ZLFtkQwC+Rr9m65L48sgfqegDUmaj6l39UQKcF0mbYOa96b7HZf
         2PdSpdHj4w55ZHeZG3yT+PsmAfHFfF+FY1KOLgef7rZDfeGG5ElPb5VKQpmk7BR1f9pb
         NExpz6DeAmwtbWd2yunfjNFqMogTI7sYPj7YTX7nPblKEuRG9fG79YF/esRTxXJPrFcY
         H2xA==
X-Gm-Message-State: ANoB5pmxBnV7iKG9YFftNcVh+xbUMG/l9WTgFCf2zqetuEptkAKvgZI+
        GeABUUskMyyKPGGmR1m68jM=
X-Google-Smtp-Source: AA0mqf4b/LYnyg5qiFgH4xNHuQRlbshDKybh0+Th43y2MZQoCtFnsGzgcGN0jnhMPttQ+VG+ahTRQg==
X-Received: by 2002:a17:902:e5cd:b0:188:f547:c0ed with SMTP id u13-20020a170902e5cd00b00188f547c0edmr12401925plf.38.1670662989326;
        Sat, 10 Dec 2022 01:03:09 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:09 -0800 (PST)
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
Subject: [PATCH v2 3/9] can: gs_usb: gs_usb_disconnect(): fix NULL pointer dereference
Date:   Sat, 10 Dec 2022 18:01:51 +0900
Message-Id: <20221210090157.793547-4-mailhol.vincent@wanadoo.fr>
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

gs_usb sets the driver's priv data to NULL before waiting for the
completion of outsdanding urbs. This can results in NULL pointer
dereference, c.f. [1] and [2].

Remove the call to usb_set_intfdata(intf, NULL). The core will take
care of setting it to NULL after gs_usb_disconnect() at [3].

[1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
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

