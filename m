Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FAA47EC3D
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 07:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351531AbhLXGs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 01:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhLXGs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 01:48:57 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74353C061401;
        Thu, 23 Dec 2021 22:48:57 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so10798351pjj.2;
        Thu, 23 Dec 2021 22:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0q+XDRfnZXxgq12FkhmCb0ciBJ4BstWZtud1YzQGTo=;
        b=Kn/iAchpftdVczpWSjgc9ps3mXs4dI7cdL9/2qUaQPakfcnjLt2EgPYohgeYtyatZ+
         dhMlqNDkPxfhzK24dYpvrDQJ8PFkP5as0i9VikD3C6rqnrvWTriesAYT4MEvVDIEM7Os
         A1pGE6aV/+4Vm4pnU4ESBe/QUKwcHnYwS3yV9C9W+XfSBuZLvjaMnRZBuQxipCrom0BV
         w2kjvwxN9mL2cSSye6sy7MM+iJphTzc0/LNJORtmBU23nd94gtdUOixdW8zMW/A7Kf9P
         wdoOVzuWpLezqn7+y/Idi0q4WOvbag45naQbqbEy17pLtinPb5BoGIQZNfrMNDV1zDSC
         RR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0q+XDRfnZXxgq12FkhmCb0ciBJ4BstWZtud1YzQGTo=;
        b=MOqcButx7W/LUBA/28RamzNAKQ4hj+/6iYYFQdTprPq8aoaikxVyoYXXXSRFLBwGX/
         sMofJcnnxy8QynOaDAMRUbncfAbXH+t9z/DHDjx21H9VXA9YXNWxi7RaBFE9QPVjlzT8
         ZmlI7k2BDK2tigF7EuL5/rYz38iIt0yC9dOA3sigGqOMTMED3o8RmcB3y2izltZqeUBz
         vdSlBqnTSjrRCUPNJsbcwruI7BToITMr/uTfyhJxy+oz2d/gs0HQ2GHRqiosjoSuyeqi
         fniK0qyC/hgZn+NTlM5t+F0JQE5edpWoDPfyMCDgmGbjHEPGwWJXPP3j1OGoljrrvdkU
         s9Hw==
X-Gm-Message-State: AOAM5336WGahjh7meNlHdbaY1y1SoQlZMgnFkaZyaAsd7IH4xNiPfc6x
        jXQYdYbu/qNiz8nj/nC1yrnJV3xtzx/aSUJ6
X-Google-Smtp-Source: ABdhPJx1Jwh0/c7vIVV9uaa+8rFODIi0ETGFnueus2zFfFrTNmqTpjRelv7AkPp8uuy4CJTL589EPQ==
X-Received: by 2002:a17:90b:3507:: with SMTP id ls7mr6516834pjb.220.1640328537105;
        Thu, 23 Dec 2021 22:48:57 -0800 (PST)
Received: from ruantu-linux-2.. ([174.139.180.74])
        by smtp.gmail.com with ESMTPSA id w7sm8653393pfu.180.2021.12.23.22.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 22:48:56 -0800 (PST)
From:   Yu-Tung Chang <mtwget@gmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu-Tung Chang <mtwget@gmail.com>
Subject: [PATCH] rtw88: add quirk to disable pci caps on HP Slim Desktop S01-pF1000i
Date:   Fri, 24 Dec 2021 14:48:46 +0800
Message-Id: <20211224064846.1171-1-mtwget@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8821CE causes random freezes on HP Slim Desktop S01-pF1000i. Add a quirk
to disable pci ASPM capability.

Signed-off-by: Yu-Tung Chang <mtwget@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203..f8999d7dee61 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1738,6 +1738,15 @@ static const struct dmi_system_id rtw88_pci_quirks[] = {
 		},
 		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
 	},
+	{
+		.callback = disable_pci_caps,
+		.ident = "HP HP Slim Desktop S01-pF1xxx",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Slim Desktop S01-pF1xxx"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
+	},
 	{}
 };
 
-- 
2.34.1

