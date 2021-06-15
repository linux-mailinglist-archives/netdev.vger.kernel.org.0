Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6333B3A78B3
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFOIIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhFOIID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:08:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA1C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:05:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g4so11344055pjk.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UKcUl+fTc+EEm4xYxI1hc5Z+l6jYDAb7MvPdnrb8RRc=;
        b=jvwHanGsZ0SdTwWQ8CNyp8UqjUd9J7Az87tlBuqQAQL4uKLzdxKVW2uVb0hKVKJDI2
         bBG4LHr/5TdNbC8ULfl6Ol3xvMC0Iy08mB9hjOLHmG89BvtXBYN9dvq0b9qjhz21hmuD
         qCA1sJr0Uw71iJ5wpb1VE7Vw2USaOf3AOv2AEgEACcS50FfY0s0qQ65cxhLPC8YVrsMW
         MHPunnCkw6bCWPu+aYCGQLcYailXFvHTwVgqqiSwlbv5JNJL5L8DivPy+eNv8ixB9Fuo
         ccfasZMXXYL5zznedf11qMCMU1sCOxR1JplAiv3fw9yew+zqA5HKw8vVzI1kWxEhQYhR
         7Z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UKcUl+fTc+EEm4xYxI1hc5Z+l6jYDAb7MvPdnrb8RRc=;
        b=uRkxvgjdI+YtKd2ZYKOSvRGlfQKqFp2ZG/VVuozHLwtXQLOev2ZJGXKK5DvBo3ZWN3
         6lEhtrIe15Ztuwpi2d2F8IQHFPiEUuWFymvD0OLiMHk9MXQhhHq+TzdYI8cZ9Z0+pVwa
         RCpIa9C3Cu3OeAB6BHLH6YWNJoRaHhJDnv84VxzIAvBD1ZJiX0855yiLV203T2knS0UG
         p6029Hj5yn7FcCmH3Qf+CXUPCHWtS1YJY9rloVcd4imdl225YONyIRQsZIGQqz7BpvbY
         3U94nz9YUfuGOoumStL2RGo1D0Jv9zUZnQC4Cvp0znmUrwIzuw82/iOBhDjXuhyyfB30
         f7kg==
X-Gm-Message-State: AOAM532CaBSL9MM/Pg30ffeUUX95b2kEp5udNv/Dyid7SYLdlpVIJFCO
        cmc7eT7KIknHUMfZmaymuuL0hLrskeY=
X-Google-Smtp-Source: ABdhPJxdRHPFLnuiy+1w5/HVv6vusSt+kmMNcdlPWPGjJQ/vuXUC5CPcfxKiTcBMAEhbTNL0I9C+qw==
X-Received: by 2002:a17:90b:1e11:: with SMTP id pg17mr23427195pjb.12.1623744357641;
        Tue, 15 Jun 2021 01:05:57 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:8b2e:9e78:6b9d:a2e0])
        by smtp.gmail.com with ESMTPSA id r11sm14994383pgl.34.2021.06.15.01.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 01:05:56 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] net: cdc_ncm: switch to eth%d interface naming
Date:   Tue, 15 Jun 2021 01:05:49 -0700
Message-Id: <20210615080549.3362337-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is meant to make the host side cdc_ncm interface consistently
named just like the older CDC protocols: cdc_ether & cdc_ecm
(and even rndis_host), which all use 'FLAG_ETHER | FLAG_POINTTOPOINT'.

include/linux/usb/usbnet.h:
  #define FLAG_ETHER	0x0020		/* maybe use "eth%d" names */
  #define FLAG_WLAN	0x0080		/* use "wlan%d" names */
  #define FLAG_WWAN	0x0400		/* use "wwan%d" names */
  #define FLAG_POINTTOPOINT 0x1000	/* possibly use "usb%d" names */

drivers/net/usb/usbnet.c @ line 1711:
  strcpy (net->name, "usb%d");
  ...
  // heuristic:  "usb%d" for links we know are two-host,
  // else "eth%d" when there's reasonable doubt.  userspace
  // can rename the link if it knows better.
  if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
      ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
       (net->dev_addr [0] & 0x02) == 0))
          strcpy (net->name, "eth%d");
  /* WLAN devices should always be named "wlan%d" */
  if ((dev->driver_info->flags & FLAG_WLAN) != 0)
          strcpy(net->name, "wlan%d");
  /* WWAN devices should always be named "wwan%d" */
  if ((dev->driver_info->flags & FLAG_WWAN) != 0)
          strcpy(net->name, "wwan%d");

So by using ETHER | POINTTOPOINT the interface naming is
either usb%d or eth%d based on the global uniqueness of the
mac address of the device.

Without this 2.5gbps ethernet dongles which all seem to use the cdc_ncm
driver end up being called usb%d instead of eth%d even though they're
definitely not two-host.  (All 1gbps & 5gbps ethernet usb dongles I've
tested don't hit this problem due to use of different drivers, primarily
r8152 and aqc111)

Fixes tag is based purely on git blame, and is really just here to make
sure this hits LTS branches newer than v4.5.

Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 4d06dd537f95 ("cdc_ncm: do not call usbnet_link_change from cdc_ncm_bind")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index c67f11e0e9a7..24753a4da7e6 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1892,7 +1892,7 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 static const struct driver_info cdc_ncm_info = {
 	.description = "CDC NCM",
 	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
-			| FLAG_LINK_INTR,
+			| FLAG_LINK_INTR | FLAG_ETHER,
 	.bind = cdc_ncm_bind,
 	.unbind = cdc_ncm_unbind,
 	.manage_power = usbnet_manage_power,
-- 
2.32.0.272.g935e593368-goog

