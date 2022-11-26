Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDCF639714
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiKZQWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiKZQWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251F5E02C;
        Sat, 26 Nov 2022 08:22:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f9so6266574pgf.7;
        Sat, 26 Nov 2022 08:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkA/imn3R47+/xWfnmkBBzHVEaOv5ORTLT0XDNYcHEQ=;
        b=ON/gRuzSyPH7S6hT2zLZ5P/N1rDVq2AAs/J1IG1Q4wK//8xSZJmYCo3ea9cghVmONi
         AkbwjnPARZ+CkiUZ1LcufjhMuu5TCWGFytab6j4pCw09Pe+EsD0sklq1HTHm7PBws6Iz
         +ugY8jxmIC6aMemQ0OQnE0iQaY7+iFXo8633ASE+Oq3HJ2I88uE+/E05poH811GWXP1P
         TPO56OLkdAIcW1kRz/IcXL4WtzrQrIzs1NTFxpiXF/m1QfGdHdMrDmTGW2vtdskJx4WF
         bFEM0wwUHW5zPbQ24ozWVwi8RORyqG2XoP6tWmb7GLESbClu5TvNTvz4EV0fnivfvbJ7
         wyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vkA/imn3R47+/xWfnmkBBzHVEaOv5ORTLT0XDNYcHEQ=;
        b=QizfY/Mr4EAamKhov6itfyASzG37bg+1l4kBJ6BxM+xljSuuRSxf2/TefHgc4evp+9
         iJSwS46q6U8+N1hA0A2mlrGybZbOGmc79inHlyf24VHRsHbZqK+RJ7LopgKaIXxi03Qv
         /AH4sOgDGOg47scG4A1wyZtpD4oWi6nkkq3bbtioWIyMHLq70qTi743C1ovsGTRa8KzW
         7oo7JHkFr603ZBMwwDIsEU1BDNqCG8okDrXCHQJg/X+EQ26uJQ7Wi0yT/RHiZx4qxtuV
         fWGbVEm9tUD6qYKxyabdb/NYJQoSQ5Ss5sGCGnz+vEVANOfE67tPzIPxDL8+xHvWfxqQ
         US9Q==
X-Gm-Message-State: ANoB5pkjOJ8/B8lFlostNkH8kjbqr7Gn06K1uQ6a4r8T8meJ+RPBmJlO
        mZE7fc81KCp1ce5iflJxG2xooIiNb6QfRA==
X-Google-Smtp-Source: AA0mqf7fmuTWhI65nOvLLpZtsmkmtKCw1vpCYxAHCFZqF3ekFRZw15D0ehZglhBEjFK5l6ObgCydrg==
X-Received: by 2002:a65:4948:0:b0:46e:be03:d9b5 with SMTP id q8-20020a654948000000b0046ebe03d9b5mr19928275pgs.495.1669479756374;
        Sat, 26 Nov 2022 08:22:36 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:36 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 1/6] USB: core: export usb_cache_string()
Date:   Sun, 27 Nov 2022 01:22:06 +0900
Message-Id: <20221126162211.93322-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

usb_cache_string() can also be useful for the drivers so export it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
For reference, acked by Greg here:
https://lore.kernel.org/linux-usb/Y3zyCz5HbGdsxmRT@kroah.com/
---
 drivers/usb/core/message.c | 1 +
 drivers/usb/core/usb.h     | 1 -
 include/linux/usb.h        | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 4d59d927ae3e..127fac1af676 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1037,6 +1037,7 @@ char *usb_cache_string(struct usb_device *udev, int index)
 	}
 	return smallbuf;
 }
+EXPORT_SYMBOL_GPL(usb_cache_string);
 
 /*
  * usb_get_device_descriptor - (re)reads the device descriptor (usbcore)
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 82538daac8b8..0eac7d4285d1 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -47,7 +47,6 @@ extern int usb_get_device_descriptor(struct usb_device *dev,
 extern int usb_set_isoch_delay(struct usb_device *dev);
 extern int usb_get_bos_descriptor(struct usb_device *dev);
 extern void usb_release_bos_descriptor(struct usb_device *dev);
-extern char *usb_cache_string(struct usb_device *udev, int index);
 extern int usb_set_configuration(struct usb_device *dev, int configuration);
 extern int usb_choose_configuration(struct usb_device *udev);
 extern int usb_generic_driver_probe(struct usb_device *udev);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 9ff1ad4dfad1..d2d2f41052c0 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1829,6 +1829,7 @@ static inline int usb_get_ptm_status(struct usb_device *dev, void *data)
 
 extern int usb_string(struct usb_device *dev, int index,
 	char *buf, size_t size);
+extern char *usb_cache_string(struct usb_device *udev, int index);
 
 /* wrappers that also update important state inside usbcore */
 extern int usb_clear_halt(struct usb_device *dev, int pipe);
-- 
2.37.4

