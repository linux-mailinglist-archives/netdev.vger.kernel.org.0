Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A14626DA0
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 05:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiKMECp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 23:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiKMECm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 23:02:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904DFDFA0;
        Sat, 12 Nov 2022 20:02:41 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so10975100pjs.4;
        Sat, 12 Nov 2022 20:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6xstQC+oWBeL9AwJF0jL3DBXjH1eGPpeBG49uXCkMc=;
        b=VgkwktM/HL3nCI90zl2uv8vS1vPSCpE5RtTlaAa9072v6Br7A5muUYlZmRYvFr1ZbM
         UmFAugafSFGTbmHX/aNEDJu6Npq1ZZrx9QtyoE/j8UEpCnhA/HBoa55UcPd/iG1ymtV+
         iTK9I5qHx+/x4+ymEcu2pwtZpdmDLsCE9AiyNrSx9pMfGm0/+j106qIxT1eOx5zULt/Y
         ugj/ucdtLOvgEJFwAHe6oueW6FaJFukayeCEc/7dOU3WY888vl2yteOVMqqJbC6waPMG
         aAwIYvOabahX2x7+tieJk2p2Y0YR52uXZZTVhEU4miXux8SNkjGJhzX7PasWPZqn3XpM
         XHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c6xstQC+oWBeL9AwJF0jL3DBXjH1eGPpeBG49uXCkMc=;
        b=PUqreZkv5MjIEQlgopQ/DucsmQrAJPJaxJrad5udkhXSWilOUwrEZBKtDyl2jilGon
         KFZ8nJeI1ZqrFaH+2kB8KzqEBG6rNfNa45Al0yUaa9BDSZ9NdtZzsHLR9qoTgUPPCLGn
         5gyvKpfnpDUDYPKfsU7HosMd0G2sBKYgfcJE30+1CbY+GOD1qoHY3tmH2n5EpOXXFvSS
         UzsZDeKVelkKnc296bfgu05uaP9ErITc4FuZe8GbJjcFPfJV0EB9RkV7+ckhJNULHKeE
         2GpAJZwlSSPkSe61yJfRb3TYoup+WDZ0w6OuJ0VkHepHZsm0j58PqeSU2BAA72XU3fAt
         DK7w==
X-Gm-Message-State: ANoB5plWYgNcUmzZX0JBED+cp1d2XmliPxyNaTPc+xiRG6goINKZh4pQ
        QE2lgm4ywU33BWPHQmbDmAw=
X-Google-Smtp-Source: AA0mqf5paTOxQOWiF4XUNC0+gFvm+JFkmjt0YP+KEpQw+D32KTSaVvSuqMHDuJTU6AA7rB9wHvZypQ==
X-Received: by 2002:a17:902:b717:b0:186:6019:d49d with SMTP id d23-20020a170902b71700b001866019d49dmr8766697pls.140.1668312160993;
        Sat, 12 Nov 2022 20:02:40 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm7122686pji.11.2022.11.12.20.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 20:02:40 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 1/3] USB: core: export usb_cache_string()
Date:   Sun, 13 Nov 2022 13:01:06 +0900
Message-Id: <20221113040108.68249-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
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

usb_cache_string() can also be useful for the drivers so export it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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

