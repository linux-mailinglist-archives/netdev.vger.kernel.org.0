Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B822F1888DA
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgCQPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55715 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgCQPQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id 6so21883164wmi.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NfoB1t2C4BAPvB/1bTfKn+UKelSInSDZtHZTYehd4Gc=;
        b=BdXPL36SDjf1EkLsjMEJZjFckiyf3VQoLFiTng0CXM9v77ddD1P3GQ0f3iFYKE+unb
         ppTOSZNwLLP6fOy5RfK2kMfWGUPOtSc6I0NxKRGsJe4k52mwXs0MS2kMXXidhypl6bn7
         NSnKPvOmJNNfCUuOeHXazyPvxREPpJQmBqb44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NfoB1t2C4BAPvB/1bTfKn+UKelSInSDZtHZTYehd4Gc=;
        b=fUxAWTCxsJJ8ZVL/JnbkAytILw8+jeYe7d6LxEPZjiGcwOmZIxWKwsnPkB48cormv5
         wsNdkazmtM8pZ1yTpxGZ2DeOAeA8Z/WMQUCTF8k11JAq5Bv8jHYZ8pLOOMStVTFNWWfx
         UlJZarhnGsrzPInHdtLPN71R7rlvBdM6+un2PWKBwoWIZLA/yCwGI0D17P6rXUYP6CP+
         I5i+dyuTcei4bAELTAfKYxgJuCWzR3b2RKg3nV2L3P+N1RPXUM2eOCD8ppm9pqVetXyk
         IV3RSG9TWUt0pP+IuLDFRDY+pBjjhbG5m3myHFCRKqogzxJsvGr97fSQS400Rkagzov2
         TV8A==
X-Gm-Message-State: ANhLgQ093/8wok+46p+ILvQ2FY1x0J4OGQxlWruSzJ2og7nui5x6qm5L
        pLzIDTtAZi9mlAid4ymmr5DJcA==
X-Google-Smtp-Source: ADFU+vvOBYZ+l0z/sri2NcR4Haio3HzI2EsXAAEY+bEyuHX2sDgD2IDvkqO+ngeSfD6KxY2FnreuCQ==
X-Received: by 2002:a1c:41d4:: with SMTP id o203mr5622531wma.1.1584458205658;
        Tue, 17 Mar 2020 08:16:45 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:45 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
Date:   Tue, 17 Mar 2020 20:44:38 +0530
Message-Id: <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info "drv.spec".
"drv.spec" specifies the version of the software interfaces between
driver and firmware.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 6 ++++++
 include/net/devlink.h                             | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 70981dd..0765a48 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -59,6 +59,12 @@ board.manufacture
 
 An identifier of the company or the facility which produced the part.
 
+drv.spec
+--------
+
+Firmware interface specification version of the software interfaces between
+driver and firmware. This tag displays spec version implemented by driver.
+
 fw
 --
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index c9ca86b..9c4d889 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
 /* Revision of asic design */
 #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
 
+/* FW interface specification version implemented by driver */
+#define DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC	"drv.spec"
+
 /* Overall FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Control processor FW version */
-- 
1.8.3.1

