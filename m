Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46EE63DC5B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiK3Rrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiK3Rre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:47:34 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABB2578FF;
        Wed, 30 Nov 2022 09:47:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 4so17446169pli.0;
        Wed, 30 Nov 2022 09:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkA/imn3R47+/xWfnmkBBzHVEaOv5ORTLT0XDNYcHEQ=;
        b=OoP+A/PeBvBzmupXLt/lsvO1apltYMdxEG3OZIhEC56t6KiA/M+UZ48T+l+4UXsWKq
         wNknt8IOx/edAvich+nZPNoTnGFuyINikd9r7gtrl8JC7knnpTbFEouni1nDP7Sr8PfD
         xP+xyRmtblMM1CKchHrJ3zvN45jH5OnL2A+AmL5Dofp4zU9mHOKueyJlgS67DvEn5x7D
         ef2/K5Hle/fHa9BeZ4Ok+Xbe+AgVLiKSxeclQarv36/zpWFKjWhFOOB3Ef1qYwuJRlfc
         oJeR9a/u2canR6akO3wVyWecdbm9X1USCbkOyuwPtQG2w3n51ugiiz5/FGFOtbhyvgvc
         2WLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vkA/imn3R47+/xWfnmkBBzHVEaOv5ORTLT0XDNYcHEQ=;
        b=bUXMyDPKvJ7TL8KZ6d76IiWOFlr5o2l447djpxLPDuKQTwv4YUyOf8rUfEw6Yj3QuN
         IfYF/qjEatB/lGRbMQ5swli0GsOB2YUsuruqB+8prg46IrlgIMaxws3zlqhk5LBkz5su
         PYqEA6gRUNvxeDpA0PYv0z4wPPPPHWZg8yHzKne36/cnJvLzAhIEL7Vbf8RKh4O3u4pX
         VC6MXXzKtnfUINuZIxGbbV7/fbbWJGbaKSpRwyeCMWgibVnf5U7Z6zbEFy5H/dH9DI0p
         6kP0ba4JKz8jYiRx1YTxIYfJbhAe/GuqpdHvB+/LockJ6puKUWhGJ4Hvvd88bm4UDB8c
         Np4Q==
X-Gm-Message-State: ANoB5pnF7ZMY6PB8lxN3kPtNqRoIOo3BcdKtWn7p3kotBcnAI3U72krQ
        tUPAipNAFudbgmvqUDHC4YKGSgJ+KpU8Jg==
X-Google-Smtp-Source: AA0mqf5ZjD8scjcxHQX5lLFN3qZGLAhKhInerb6Ay6XmiXEPENVyaU8oNPs/oR0WXoEzl/BWB8RVdA==
X-Received: by 2002:a17:90b:3c52:b0:219:2b64:cc0e with SMTP id pm18-20020a17090b3c5200b002192b64cc0emr19627097pjb.161.1669830440569;
        Wed, 30 Nov 2022 09:47:20 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:20 -0800 (PST)
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
Subject: [PATCH v5 3/7] USB: core: export usb_cache_string()
Date:   Thu,  1 Dec 2022 02:46:54 +0900
Message-Id: <20221130174658.29282-4-mailhol.vincent@wanadoo.fr>
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

