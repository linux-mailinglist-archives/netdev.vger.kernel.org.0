Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AAD50D8E7
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiDYFoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 01:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiDYFoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 01:44:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B35BCB7;
        Sun, 24 Apr 2022 22:41:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b12so9796334plg.4;
        Sun, 24 Apr 2022 22:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JxYkM6W+dvTeexYmxSuaWBeHj74cng1RGH8kRqDlTvg=;
        b=p3XZOmKAdm8qtiJ6755OBSjAUxfX3a5ZWWVA0b9Y+PGOU4xNxPEFMLS91AxfurvoUc
         JGaA/xYkPEg+JR9ure0hw/htAMzZFEkaondVTyoZZy24HgL9trHATQ62Bf17bF8ItFgf
         E9fhfZufV4h+XhNzq0ZaTMEPocJcYJAP6DINhjmXZysjXVwuDuoGFxHXKGIOMJvZlZ+J
         bDaK5Nj5GNP7G7MDz/X1sxcsX9B+UHgk8OZrV8Sj/vp1sfVa7oxQ9ct4outXCpHDRw7e
         kEGtG6RYwJbH3h6qeROkrcVZLn9i2wKDmplZ61PqeJOLU7Dp5Ztm7nvqIwPFkoSIWX6u
         /wMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JxYkM6W+dvTeexYmxSuaWBeHj74cng1RGH8kRqDlTvg=;
        b=R3LWDj9h0koWk5uRYAbJzb6yCiv0rSfHY9//K4zYS/rHctgqUxyMlu8lFBzOfcLlvL
         t/wUSSvLOuQa5znsRv/wWbh9uk0/4j3hpL7wXFdyxavQ4/xhH/ejGOD7YgfxUJf3XfOd
         lKRoqxuYMLtNYkbTOiB7uM2mikJwx6fFsH6BnUMZHY2JGY9EAg+AnJF+2tzFbrm8klaT
         iNwRqQIvhzjLD12JcDHAhDgI8ZDzoxaNCE3O9mCPHPJvvMFZSkBV/aK9FtPol1DF1kr1
         nCXQ32CeCx9+/tlWPlGhw/vc9MEihyYpssYzRWxvL60YWd+FITS5XN/HaWMWjFA8gIGt
         m3JA==
X-Gm-Message-State: AOAM533px/ofvXcVOpi/b++rDylVJozVP+5sMbZEOwHPl2d9LZgNscXQ
        iy8kbUwJcFpn0eEFf2u5WOc=
X-Google-Smtp-Source: ABdhPJzV/LwlXdEOgRy4/tlj9gigIiBYQIoPSqJUWAkABHmK588wtf87KiGY++Y08CLCdrElXsGeBQ==
X-Received: by 2002:a17:902:768a:b0:159:71e:971e with SMTP id m10-20020a170902768a00b00159071e971emr16382183pll.163.1650865263682;
        Sun, 24 Apr 2022 22:41:03 -0700 (PDT)
Received: from ethan-Latitude-7280.localdomain (125-228-239-174.hinet-ip.hinet.net. [125.228.239.174])
        by smtp.googlemail.com with ESMTPSA id j127-20020a62c585000000b0050d45a85080sm825440pfg.215.2022.04.24.22.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 22:41:03 -0700 (PDT)
From:   ipis.yang@gmail.com
X-Google-Original-From: etyang@sierrawireless.com
To:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gchiang@sierrawireless.com, ipis.yang@gmail.com,
        Ethan Yang <etyang@sierrawireless.com>
Subject: [PATCH v2] net: usb: qmi_wwan: add support for Sierra Wireless EM7590
Date:   Mon, 25 Apr 2022 13:40:28 +0800
Message-Id: <20220425054028.5444-1-etyang@sierrawireless.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <87bkwpkayv.fsf@miraculix.mork.no>
References: <87bkwpkayv.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ethan Yang <etyang@sierrawireless.com>

add support for Sierra Wireless EM7590 0xc081 composition.

Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3353e761016d..fa220a13edb6 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1351,6 +1351,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 8)},	/* Sierra Wireless EM74xx */
 	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 10)},/* Sierra Wireless EM74xx */
 	{QMI_QUIRK_SET_DTR(0x1199, 0x9091, 8)},	/* Sierra Wireless EM7565 */
+	{QMI_QUIRK_SET_DTR(0x1199, 0xc081, 8)},	/* Sierra Wireless EM7590 */
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
-- 
2.17.1

