Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220914F6F0F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 02:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiDGAWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 20:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiDGAWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 20:22:44 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E3E10F6F3;
        Wed,  6 Apr 2022 17:20:45 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id e16so6842644lfc.13;
        Wed, 06 Apr 2022 17:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=meELFVGsIZ7ITOZMel7kaWLUHtDI0l/3uOe9GNIVnpQ=;
        b=M3Ujmkm3lO07wEUxLOvaypCM3bi0KoGurf8CGrTURpjMs0Js87YaR4PvwegVHXdvFs
         2o543gaFqr9/gXPbriC9B92s/gOYaKmMfqOKyJK9kf9hjqRTJj+D5ItJntSOTlRDIlN2
         EYkovAmD5esTvEZXqQyGbHvRImY3lgb2UUkihXGUD1XxZZXmRZQr+rpO1/e/dInQg520
         qSTQXsJ+hyUDC8Ghqv4d0LM1Q7/SZzMaRvdwpKQPI2HifWiC06IlRGomIn4JjCa677xY
         tNf5+Gn3w6kygyMHGvAAAxkdTtLWlwTDI9yhYyJOuSmj5AuwB/wbTO5rrlDQic3gOLag
         7LlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=meELFVGsIZ7ITOZMel7kaWLUHtDI0l/3uOe9GNIVnpQ=;
        b=hTFZ511kgib8x48xS/Lk98XtEPLdA8MKBYNB3Wr5NVJ80xW8MandEw7E6Qx7QrGYfD
         os2zhAT1XF28EUIU3CbLwj8o/lTYHsSRih5pb4oxsY2DiWDQKmDQPy36hqQNpeovWAUU
         sp3Tt78lqJqfzP8qIC8eifMpJcNiLbQKa01aJwKQ1CEjHsv+gr6+hZBOUCvcbi4TwJkk
         JwTKaLvaReFjH2hbkhGwiscvo+s7ydlw9bt/e4/m9xlFv7eVAj5ss18Gnd2DUGVLsSSq
         BKH+ao+6qS9z8TpGXuYO4lxg6IU3/ytoNh1xGJOkvFNBoZvly6pDYiXl2+B3kzcXpw6l
         hNPQ==
X-Gm-Message-State: AOAM533/M6erBSa1KCrjTi3s+kMlZQAiP19dTYG1PiWlV+spka188KNN
        aerFqKAdI2gTNNCT94fzk6tfn2lTKSo=
X-Google-Smtp-Source: ABdhPJz4JLr3WN6abCNhtxhVntWe+IKRxstx3m8m2hABS4qYWUDmgTdyiJTjRYbVabrK9m96ymRWqA==
X-Received: by 2002:a05:6512:3d8e:b0:44a:3ad1:8bae with SMTP id k14-20020a0565123d8e00b0044a3ad18baemr7398233lfv.231.1649290843702;
        Wed, 06 Apr 2022 17:20:43 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id n12-20020a2e86cc000000b0024b121fbb2csm1413879ljj.46.2022.04.06.17.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:20:43 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1/3] cdc_ether: export usbnet_cdc_zte_rx_fixup
Date:   Thu,  7 Apr 2022 02:19:24 +0200
Message-Id: <20220407001926.11252-2-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407001926.11252-1-lech.perczak@gmail.com>
References: <20220407001926.11252-1-lech.perczak@gmail.com>
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
exhibits a second issue fixed already in CDC-ECM,of the device not respecting
configured random MAC address. In order to share the fixup for this with
rndis_host driver, export the workaround function, which will be re-used in
the following commit in rndis_host.

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
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

