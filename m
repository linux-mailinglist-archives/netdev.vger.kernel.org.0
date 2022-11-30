Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6602563DC66
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiK3RsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiK3RsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:48:03 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C975F869;
        Wed, 30 Nov 2022 09:47:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so2973702pjj.4;
        Wed, 30 Nov 2022 09:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tj7enRhPuy66CIZyAohvX82mU67j6EK9+WaOtfyvKP0=;
        b=gW7Glxr4GdJ3ncxZPVzkedpvAS3HmjppVo/DWtEB5hmO2I3RVWF6iyP4GnJ6jfwN8U
         /fliXq/vxErXBr8QBZuWgR65ZDILbneZZM0yDdJlj+cWRF8/dL2zCzC2HXfrIUOpVnJW
         KBpIUaOEcb+UPR7PRj7SGZDapCPMwheYM5t5Xjvg+CS2vlCtAN4xA+XijWSah7gYZ1kM
         VVlyctPzd8duvhvOP35k5QG5eqNYzIut5X4gcjAfmAyz7EVgrAbHcUVbRFjcrtVdD1pa
         GAKc5+H8MHwRR8vrNLT7k0Glv/FfGl/OXHwQLMJAnqLaPX56fd0FzWfEpmLgzrqmRlkS
         97XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tj7enRhPuy66CIZyAohvX82mU67j6EK9+WaOtfyvKP0=;
        b=QljJZR8uaO+VW9KWMCNn6GD5zP+PDeqvoHZMwV9DbY23xExTKT686n3e2DpFfRiqkm
         mnXaQWg2dF1qHn+U7iUPFYPD1PLFSKqf6J4WO5cY/CKVrArRIPpsr0tYYDoNROTlJuTj
         tLX04oxVyGti8W+hsWNDd9aovJV8VoViu7sSqARH4GFF6vvq4GH9BMjODMxwt1mUjLAp
         PQEwNo18cEsNkhB4qEmK6mx39Cq0lmZDDuz1QugHq8y8gqbqC/Q9d7pr2HC4VGlTZb/L
         I2urpof1aY/HMtzYZ9cevEtKBtX8XfZ7mrIQMapfC++ovCYzKmOjdC/3rh2d/fgoyI1X
         6ZtA==
X-Gm-Message-State: ANoB5pnczyX/BuxGCKmsqxcRINLzdgwZ7Yi0WomL7l7EShn3X+9bTQrX
        kY1KcImtDNNn+BbHyBYKGyuF7RqmOBaSXg==
X-Google-Smtp-Source: AA0mqf58/ifqweFTnZCTccJrjLQscG1El7eDWQAjQEdpmw7f6x5Fz6HRMWW5bhN8ePn/cMcp6aUX6A==
X-Received: by 2002:a17:902:8604:b0:189:5484:3717 with SMTP id f4-20020a170902860400b0018954843717mr34377645plo.15.1669830448882;
        Wed, 30 Nov 2022 09:47:28 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:28 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 6/7] can: etas_es58x: remove es58x_get_product_info()
Date:   Thu,  1 Dec 2022 02:46:57 +0900
Message-Id: <20221130174658.29282-7-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
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

Now that the product information are available under devlink, no more
need to print them in the kernel log. Remove es58x_get_product_info().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 52 ++-------------------
 1 file changed, 3 insertions(+), 49 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 4d6d5a4ac06e..0c7f7505632c 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2141,48 +2141,6 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 	}
 }
 
-/**
- * es58x_get_product_info() - Get the product information and print them.
- * @es58x_dev: ES58X device.
- *
- * Do a synchronous call to get the product information.
- *
- * Return: zero on success, errno when any error occurs.
- */
-static int es58x_get_product_info(struct es58x_device *es58x_dev)
-{
-	struct usb_device *udev = es58x_dev->udev;
-	const int es58x_prod_info_idx = 6;
-	/* Empirical tests show a prod_info length of maximum 83,
-	 * below should be more than enough.
-	 */
-	const size_t prod_info_len = 127;
-	char *prod_info;
-	int ret;
-
-	prod_info = kmalloc(prod_info_len, GFP_KERNEL);
-	if (!prod_info)
-		return -ENOMEM;
-
-	ret = usb_string(udev, es58x_prod_info_idx, prod_info, prod_info_len);
-	if (ret < 0) {
-		dev_err(es58x_dev->dev,
-			"%s: Could not read the product info: %pe\n",
-			__func__, ERR_PTR(ret));
-		goto out_free;
-	}
-	if (ret >= prod_info_len - 1) {
-		dev_warn(es58x_dev->dev,
-			 "%s: Buffer is too small, result might be truncated\n",
-			 __func__);
-	}
-	dev_info(es58x_dev->dev, "Product info: %s\n", prod_info);
-
- out_free:
-	kfree(prod_info);
-	return ret < 0 ? ret : 0;
-}
-
 /**
  * es58x_init_es58x_dev() - Initialize the ES58X device.
  * @intf: USB interface.
@@ -2261,28 +2219,24 @@ static int es58x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
 	struct es58x_device *es58x_dev;
-	int ch_idx, ret;
+	int ch_idx;
 
 	es58x_dev = es58x_init_es58x_dev(intf, id->driver_info);
 	if (IS_ERR(es58x_dev))
 		return PTR_ERR(es58x_dev);
 
-	ret = es58x_get_product_info(es58x_dev);
-	if (ret)
-		return ret;
-
 	es58x_parse_product_info(es58x_dev);
 	devlink_register(priv_to_devlink(es58x_dev));
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
-		ret = es58x_init_netdev(es58x_dev, ch_idx);
+		int ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
 			es58x_free_netdevs(es58x_dev);
 			return ret;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.37.4

