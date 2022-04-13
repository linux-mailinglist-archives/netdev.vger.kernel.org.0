Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56824FEBD5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiDMAOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiDMAOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:14:41 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F1DE84;
        Tue, 12 Apr 2022 17:12:22 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bi26so678403lfb.2;
        Tue, 12 Apr 2022 17:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRrbnmbi6PLV47sa0wXWaXpUxYCwVkoKfHYPxyzT24o=;
        b=KhezTrzImoPzACJ/uhT/aQOn7itVV/txet90+iwFlkwH/51tupC7aVVzD8AzsHFDE/
         PTQnuWiR/uUBUivP9O7+sXhmfHdLy5v8kRcRiCgzRlEuMFf/SmEo77vpuRsc/I82rOK+
         Fd1L+96dDZCqV0dZYNcLYq1j9N8wpy03l3LfPF9LHJxe57ZJKSNQ2Hfe8MHdQxIQIoOI
         a4BPnjOY3uAVaWiqRn/rb7e7RMEdFlVlEoSO3e6L+ZQaq217eKIOqVyx5awIfA5mrLZM
         LF0BIEAELmzxEFZWCkq3kerSPthav8+QaPbYXoONDa02lYynJNNur4yAWh37nyp387BZ
         Tr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRrbnmbi6PLV47sa0wXWaXpUxYCwVkoKfHYPxyzT24o=;
        b=uZlEhePDAoLKpXlV58kfS3VL8TJ9LrhAjNLd4+K01XBBCZcV8lIixPQILKiQ1vR2bs
         79LUQGKMtOmjLUTWtqWdRRt/83uoJ0PGdEHUqR/LU3vaQ5PTCkmIf6UbJswWooL59cT0
         tzZ4AYHKLGb0r/lZ4r0dY3X2YBr5u4H+DA5o3Ac1GwNa/L1avP/IflL8I585MX9I91dY
         UTjKcJKEsknlzWGf3ZySY22+hAmf/BoYI7PIVylJViYmEdfGn1WpT16GQQa8xPpp1m0O
         yfamzH75SmuZERk+a5Q41zfX6bKC7Nbe0qFwjHC8guFs1bq1jA7bly83Y17/vsNG5sEn
         FfyQ==
X-Gm-Message-State: AOAM530I8zEBe3pypwcc1xihczGkzrV6DN7u3pmFRvO+6KBhzvlaZ9Mk
        AHy1nfhrlzcbc7gl2NUzojx4jpV2NslPNQ==
X-Google-Smtp-Source: ABdhPJzaPvKB56n2wU6hLHEFHxBf/vqUXTJRIJmEWFJaf9ETQ/u2lDCe0jHSZDzbG4PVOPOb9gSaMg==
X-Received: by 2002:a05:6512:68e:b0:44a:6594:3b9e with SMTP id t14-20020a056512068e00b0044a65943b9emr26364627lfe.623.1649808740411;
        Tue, 12 Apr 2022 17:12:20 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id d6-20020a2e96c6000000b0024b4cd1b611sm1611731ljj.91.2022.04.12.17.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:12:20 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v2 1/3] cdc_ether: export usbnet_cdc_zte_rx_fixup
Date:   Wed, 13 Apr 2022 02:11:56 +0200
Message-Id: <20220413001158.1202194-2-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413001158.1202194-1-lech.perczak@gmail.com>
References: <20220413001158.1202194-1-lech.perczak@gmail.com>
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

