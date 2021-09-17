Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2472740F4B9
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbhIQJZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:25:41 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48710
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240758AbhIQJXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:23:11 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5D10740268
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631870508;
        bh=o7vBhR0EpCJ0RBAVx7tRojMJZmGtoI7hI2etAgBdAnA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=LzLZlHt+ACbfnQcE8DbTwo40+/rxRFJ250ENwtgsoMVY3IUpakGi2eMqBMP5Jvzp0
         /VuGB3SQAFoTxe9bjpMj93vZj0zetH49tfPuo7UVN1qVG7fTUm3+BiQF8nAA5Kqmix
         BGXI0S+/dRUXZBb0v1PBRYE2OdKD5HCHeV0tiyvbuyj/Ch+N1BCWkhTuKrK1ZLkBKa
         /mCgwEPoc8DW6pK6FDrpwre47EXZ3ubdmkSkHJU0DYVONu2YUZJ3aTq0YzWt9cqJQk
         NOuMRaQBMCAAmNQuEw5tPqCOe57/zopifYiw7tLepxTdahH9S1sp4aJRSFo/k3Rixp
         z2YEMg10KDNWA==
Received: by mail-wm1-f72.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so4370226wma.4
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 02:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o7vBhR0EpCJ0RBAVx7tRojMJZmGtoI7hI2etAgBdAnA=;
        b=HdC1F5vTDpUjHwRmPfI43GCvLBAkFb++7nYX1Fd/0NPdhLsOdCZmqxQurKV+/flQRf
         lfH+qN0nxT/ddd9NK/AcQKmn24c/xguY4RV70K8AAdTTkWwK9rwhtEIOIl/OB+/OVPNu
         T7X50qi5GRj8bKlWIPjSdlkVF9xPr7PPK4t5D9BtU8eKNveUAgzpTmjcjbPrKDh7kPxR
         9YQ9tJmms1WRDQqgpN+QQNXUSJMA/B47ZSBNXP/nPHWZmqyeclpyW74LDjkR0BoYkFVZ
         OvSS5nxhac2EL8BuUnN4D4Lsg9Lvc53ThtVwpYcA7hxItKiVA/a531fsuQsXWZGaG6o6
         uPNg==
X-Gm-Message-State: AOAM530XvyIs6HfzGE8rLBhgKafR5P2eQ0Z39EzEbbWWkD8YJSbj/9rO
        u5N5mE2eBaKUa61FLyCHKv8kBlMq10SY0P6oxKNbgz58EqqRtONe26M9oT10CvGANmsRC44RCRM
        m1GfUMBKD+mCcm1Pdieytjl3cYosKat3bXQ==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr14328398wmc.3.1631870508060;
        Fri, 17 Sep 2021 02:21:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSh7nZCh0xloMemj03rh/x1IOY4KIeubxmM6VRIwneWeSzjscQX4mH7jZn/VoYdck4c9qCIw==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr14328373wmc.3.1631870507862;
        Fri, 17 Sep 2021 02:21:47 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm5921163wmi.0.2021.09.17.02.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 02:21:47 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 1/3] zd1211rw: remove duplicate USB device ID
Date:   Fri, 17 Sep 2021 11:21:06 +0200
Message-Id: <20210917092108.19497-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device 0x07b8,0x6001 is already on the list as zd1211 chip. Wiki
https://wireless.wiki.kernel.org/en/users/Drivers/zd1211rw/devices
confirms it is also zd1211, not the zd1211b.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index a7ceef10bf6a..850c26bc9524 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -65,7 +65,6 @@ static const struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3413), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0xe501), .driver_info = DEVICE_ZD1211B },
-- 
2.30.2

