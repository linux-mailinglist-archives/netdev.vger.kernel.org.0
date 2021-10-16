Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A9543006E
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 07:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbhJPFoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 01:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhJPFoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 01:44:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36FBC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:41:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w14so46240426edv.11
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lMvcUb0T02209f5pJydbauUDAAhob9vjG7UsNSiJn7k=;
        b=PK+bJXfOyIWZTIDps+rHBN2iWtlR5GGVOBAECToVQzNdIj16Fiq6paoPGtoC2G76FA
         yFgN1/s8YJRO5fnIIgLOevpw8rHpCjNTrYNBi9E9nsnL08IeAofStoSqPn6+3IkBovaW
         BQnmjt5W6HJOhBKG4+XzVqrR17s77sfGtlRZurIy/WNAPXYJc+KxdF5XY/b7mqgXjUEl
         hghIZD8tJthGdcLXxyaINvjSdug9aM6VAdeQp2tMbsuxVKn5/nhM0wadQIPZColLePd0
         n5j/IIZaNV1WL0Uu3rHvayBnWpAnyGecIK9yxYcphFZvUH1X36USXjiqDojgSt7+qW5F
         L6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lMvcUb0T02209f5pJydbauUDAAhob9vjG7UsNSiJn7k=;
        b=jnsOTO43vgvQiS8EJ03UW+autVIV1IgZbwH7rLbUOzICKurkHN+Qw7yV2PaSBfAUOd
         fT+3jadUE6HLE29XyKpvfhIee4onRnhLwI0MZsLt1mUbXNs9XQR9SHwMN+mMTeVLtqZ6
         Q7jHA0sTBpT86VbUk3BwQA9gb+olFnqcLgXSOCOXZlZ4aQnRybtsDE3Pte0lrwPvI9gi
         P9sQQg4hFvSihY5+qP6uxLHN3SMdRwPAY8c4WcfK8cyFgO0u3GI4B/jxbEp0EJRHCvRN
         zSLi+2FfTSFzYCTqjuJH/jp/MnazeyXPxc3wXne11UoDuaMvAs1XIhyn69NJLsAsFjf2
         RplA==
X-Gm-Message-State: AOAM531g+hsqdcRZhKV6u4w9/bGLZ/KTvDuN5LP3DW3UaV8sW/SdEzKH
        gYD10/plUlgGOKYN1iNoetjMsUeDVlW1Kw==
X-Google-Smtp-Source: ABdhPJwB8ZssZtcu20jVLMq/OK/ehkAMM9Gwr9SOoYBNeAbsjzPkgZhBhEWXD7zT1z60cm0Vt2J47w==
X-Received: by 2002:a17:906:68d6:: with SMTP id y22mr12115745ejr.274.1634362912530;
        Fri, 15 Oct 2021 22:41:52 -0700 (PDT)
Received: from localhost (tor-exit-relay-8.anonymizing-proxy.digitalcourage.de. [185.220.102.254])
        by smtp.gmail.com with ESMTPSA id m15sm5989314edv.45.2021.10.15.22.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 22:41:52 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: macvtap: fix template string argument of device_create() call
Date:   Fri, 15 Oct 2021 23:41:34 -0600
Message-Id: <20211016054136.13286-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

The last argument of device_create() call should be a template string.
The tap_name variable should be the argument to the string, but not the
argument of the call itself.  We should add the template string and turn
tap_name into its argument.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/macvtap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 694e2f5dbbe5..6b12902a803f 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -169,7 +169,7 @@ static int macvtap_device_event(struct notifier_block *unused,
 
 		devt = MKDEV(MAJOR(macvtap_major), vlantap->tap.minor);
 		classdev = device_create(&macvtap_class, &dev->dev, devt,
-					 dev, tap_name);
+					 dev, "%s", tap_name);
 		if (IS_ERR(classdev)) {
 			tap_free_minor(macvtap_major, &vlantap->tap);
 			return notifier_from_errno(PTR_ERR(classdev));
