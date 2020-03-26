Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE86219389A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCZGaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:30:02 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:41821 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZGaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:30:02 -0400
Received: by mail-wr1-f45.google.com with SMTP id h9so6300958wrc.8
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2huTS4rG7uMC3KslIS2zhFGoF0McQRbFsPLFtRCMtLw=;
        b=DlU/27zD+fTU0gEZqIIw7h5I8TuqGn+JfBIIvSYwhvWAT+ZRL9lRFVNj8p45CWhbwD
         JYrIaHi4t823ZNv7/3m7WbA73cm/FNeulfc0pJ9yK2K09hA4nVXFg8CfAMFCIo8MAnEA
         w5VZ50sBLaGR8DFmmaEWrJxG4MLiUr8AcCKZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2huTS4rG7uMC3KslIS2zhFGoF0McQRbFsPLFtRCMtLw=;
        b=cGn5FoBgENw9+OUINZStTJIR1P8FoiXjU5bdrk7ipjjf2lwWfYuSNV3kLFkpFXVzfb
         KULCxAMEQMJw4p2kEz8BP8vC6rPM3byG7EWGTkFNYxEbwQZu2iPfjdM5OrFBOEMPkFJ/
         DLWIwgURGbqCUID+t5fwptOnvAF+Nr1jEkGvOihpkaUIprq4Ztkkl+7vKKtQWDnyTgES
         nNpNMvne/NxbuCFyXY5va4cvtq1Z2fZABR16EdLToNgj5n8AyemdKcMGoqEAd/J/VpWz
         IkKaCUUDJ8APdk0gVeTJ4yWn5j6EzC+BFhG/Dqnk/uzzS4yvhxIzIjKdYze4wlf0fQHw
         hZdw==
X-Gm-Message-State: ANhLgQ2rc17A8LBRLzzsfFWxjGYRaDp2j2PqoOtMfF2HEZvWPdt/pPhW
        Dm/9Y8PmAFnbOhtsbd9gG5P/7A==
X-Google-Smtp-Source: ADFU+vsIYqLyH5nLJADRBtxkP+YNUSinTyo6bPI01iSD1w0KLqTtC7U5ZVuisU5tPa0K+fS5hAG7JQ==
X-Received: by 2002:a5d:460e:: with SMTP id t14mr4703879wrq.421.1585204200338;
        Wed, 25 Mar 2020 23:30:00 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y200sm2106768wmc.20.2020.03.25.23.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:29:59 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 3/7] devlink: Add macro for "hw.addr" to info_get cb.
Date:   Thu, 26 Mar 2020 11:57:00 +0530
Message-Id: <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info "hw.addr".
"hw.addr" displays the hardware address of the interface.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 5 +++++
 include/net/devlink.h                             | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 650e2c0e3..56d13c5 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -144,6 +144,11 @@ board.manufacture
 
 An identifier of the company or the facility which produced the part.
 
+hw.addr
+-------
+
+Hardware address of the interface.
+
 fw
 --
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index d51482f..c9383f4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
 /* Revision of asic design */
 #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
 
+/* Hardware address */
+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR	"hw.addr"
+
 /* Overall FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Overall FW interface specification version */
-- 
1.8.3.1

