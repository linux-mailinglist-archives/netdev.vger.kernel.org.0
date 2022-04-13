Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B604FEC71
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiDMBqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiDMBqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:46:48 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854CC527E2;
        Tue, 12 Apr 2022 18:44:28 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q189so428172ljb.13;
        Tue, 12 Apr 2022 18:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zkubLbvnObY1baOgGYmcIpfvZWKIYrnrnDJvJRuO99c=;
        b=iP93ud5TGE1YXlVZxo16VEX7ef3imfx8ywXN4s6m0f95U7LrxG/0A0UNt34YZfCHd8
         BHV3TJtLZSAnmc5YenRY84WjAeieG2j91NufqIzea5D+MFM54xGtLTkfs6s+fX/LBKpY
         IiYT406K0PmS0Ng4LZOeEGqprFU7akPLK3DPFNOkyz0U72cQyI+V+1zXptcR0U1yLJH1
         x6yOjp0aF+WPv3KaZUpw54CdZIBVlq0DnyJshf6vPdeGNB3vjTWd0n7TNtS0z9KyksZY
         3L44j9dz3/R5jXHUS4hzCvUcBgbd2e7j8mTTSvkzv+iajqf9IAUkY3JOSkhGEe90Ddz0
         9hdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zkubLbvnObY1baOgGYmcIpfvZWKIYrnrnDJvJRuO99c=;
        b=AeOtzbFibQlY0LWxS9yJgsT5yFZW+jycN8otZkkF/w2BZi6d+GaxFQ6HX82kKeaVox
         xq7Kf7Z7RiZqiJGAVskutjj8ltKarytOPvBlfnOVxmy6lZt/U4Yq9Gfz2d7rJQXp8ga8
         XER48vH34rAO3tognie/hSOO1KA3P6eeLi40rmrnNzHcP4V0SN9QmZ1gfMTcjC8CgIyK
         8a57C44YoddnwF3oW3sF6tRGyJL4LNw7kTWPrJQ+KJWk0zWqIyH2C0JkyWvSwgL47OeV
         cyxPnFdEwbaikYMQoGcAcPJ/D75F10/fGrlm0OlD0Xt7aRfoo3Vh3RlOX9i2lbBhqzwo
         qW0Q==
X-Gm-Message-State: AOAM530c45WyRmdfUPxDEiSzKygz7zGoXc9+UN+z5Ykddu/hKNM+hhRG
        SAwzbc7TipKKSlIOj8ey7cDLQxsWSO2fsw==
X-Google-Smtp-Source: ABdhPJxbeeffhjT+tXkpQ5yF4Z7pt/Sb7K6WC1Lfyw4Z9bU8MJyB5c7IioBvS+24k6w1MnBTQbeMAQ==
X-Received: by 2002:a05:651c:a0e:b0:249:90c8:453d with SMTP id k14-20020a05651c0a0e00b0024990c8453dmr24574366ljq.399.1649814266813;
        Tue, 12 Apr 2022 18:44:26 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id u3-20020a197903000000b00464f4c76ebbsm1915574lfc.94.2022.04.12.18.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 18:44:26 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v3 1/3] cdc_ether: export usbnet_cdc_zte_rx_fixup
Date:   Wed, 13 Apr 2022 03:44:14 +0200
Message-Id: <20220413014416.2306843-2-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413014416.2306843-1-lech.perczak@gmail.com>
References: <20220413014416.2306843-1-lech.perczak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bfe9b9d2df66 ("cdc_ether: Improve ZTE MF823/831/910 handling")
introduces a workaround for certain ZTE modems reporting invalid MAC
addresses over CDC-ECM.
The same issue was present on their RNDIS interface,which was fixed in
commit a5a18bdf7453 ("rndis_host: Set valid random MAC on buggy devices").

However, internal modem of ZTE MF286R router, on its RNDIS interface, also
exhibits a second issue fixed already in CDC-ECM, of the device not
respecting configured random MAC address. In order to share the fixup for
this with rndis_host driver, export the workaround function, which will
be re-used in the following commit in rndis_host.

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---

v3: No changes to the patch.

v2:
- Updated line wrapping in commit description.
  No changes to patch contents.

 drivers/net/usb/cdc_ether.c | 3 ++-
 include/linux/usb/usbnet.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 9b4dfa3001d6..2de09ad5bac0 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -479,7 +479,7 @@ static int usbnet_cdc_zte_bind(struct usbnet *dev, struct usb_interface *intf)
  * device MAC address has been updated). Always set MAC address to that of the
  * device.
  */
-static int usbnet_cdc_zte_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+int usbnet_cdc_zte_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	if (skb->len < ETH_HLEN || !(skb->data[0] & 0x02))
 		return 1;
@@ -489,6 +489,7 @@ static int usbnet_cdc_zte_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(usbnet_cdc_zte_rx_fixup);
 
 /* Ensure correct link state
  *
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 8336e86ce606..1b4d72d5e891 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -214,6 +214,7 @@ extern int usbnet_ether_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 extern int usbnet_cdc_bind(struct usbnet *, struct usb_interface *);
 extern void usbnet_cdc_unbind(struct usbnet *, struct usb_interface *);
 extern void usbnet_cdc_status(struct usbnet *, struct urb *);
+extern int usbnet_cdc_zte_rx_fixup(struct usbnet *dev, struct sk_buff *skb);
 
 /* CDC and RNDIS support the same host-chosen packet filters for IN transfers */
 #define	DEFAULT_FILTER	(USB_CDC_PACKET_TYPE_BROADCAST \
-- 
2.30.2

