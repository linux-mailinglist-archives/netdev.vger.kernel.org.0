Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AE01499BC
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387393AbgAZJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:55 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:40181 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbgAZJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:54 -0500
Received: by mail-pf1-f181.google.com with SMTP id q8so3427079pfh.7
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VgrjMqR8ZwCZ3PkVigo/SBylYoGbTHwJaw7w0KrYs9k=;
        b=XpDuNvPEd5jmbJV/vKZDLk/ThQswXTdRWSpZw8Dxk9NnE4voupvwBkHIO1IRliYzbP
         w8E8BYVLGaKP16b2xbitlQYqOXJEY19yRiX6RXKV10CW1Z7abCg453QEidxZy43MO+N9
         lTQkXIKkY41fjq8hMIDR6fK+IaeBxxOaFGrpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VgrjMqR8ZwCZ3PkVigo/SBylYoGbTHwJaw7w0KrYs9k=;
        b=pe37Hlp4B7hvQ/Tt5fwW/M82OTmnAttDEVeJToY3/ztaRoDtnzpzyBXchb+Tww26WZ
         /34wO9/62Uqkn7CcRGaUZ6tEyTv9V+HlasHGxhU0ATY8EVeYkfr7Cr4h7zsick0WEzeT
         IMXg4JCQmkoQIFzyNAqHQz15oOfegboXboRwK1Ypy4d4e2mDnXK8MUJWnVxzzqEygDVk
         q58HCYH/e948Qu0RNTEo1tXbROg/BVZtbA3uzTI+nZdTNnLZdwlLPTvBs+nrDLEUpxI/
         s2Jjv4mWYQ/ZTjAh0SFJaBETw69YRxwk5jGLvJNN5O6IYWk6vhSknlD9kyOEJ/ZfJGTd
         0STw==
X-Gm-Message-State: APjAAAUMZA/EGM13f8ysVADPz7hZwNtdYm2oau7JrPzH8rNQ4Rm1WFgl
        Wvmw0Jiy1o4jiCiU+F98Vpdgmg==
X-Google-Smtp-Source: APXvYqwS8wmVowUocYF9NCU1XGziXD/fUTQlitgJBvGzIxJvfjsAKC8yW3Y8o+ORwEq1SIwClao0YQ==
X-Received: by 2002:a65:66d7:: with SMTP id c23mr13977000pgw.40.1580029433491;
        Sun, 26 Jan 2020 01:03:53 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:53 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 14/16] devlink: add macros for "fw.roce" and "board.nvm_cfg"
Date:   Sun, 26 Jan 2020 04:03:08 -0500
Message-Id: <1580029390-32760-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add definitions and documentation for 2 new generic info "fw.roce" and
"board.nvm_cfg".

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 11 +++++++++++
 include/net/devlink.h                             |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 0385f15..ab0690e 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -59,6 +59,11 @@ board.manufacture
 
 An identifier of the company or the facility which produced the part.
 
+board.nvm_cfg
+-------------
+
+Non-volatile memory version of the board.
+
 fw
 --
 
@@ -92,3 +97,9 @@ fw.psid
 -------
 
 Unique identifier of the firmware parameter set.
+
+fw.roce
+-------
+
+RoCE firmware version which is responsible for handling roce
+management.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5e46c24..9e168a3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -469,6 +469,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_BOARD_REV	"board.rev"
 /* Maker of the board */
 #define DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE	"board.manufacture"
+/* Non-volatile memory version of the board */
+#define DEVLINK_INFO_VERSION_GENERIC_BOARD_NVM_CFG	"board.nvm_cfg"
 
 /* Part number, identifier of asic design */
 #define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID	"asic.id"
@@ -487,6 +489,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW_NCSI	"fw.ncsi"
 /* FW parameter set id */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_PSID	"fw.psid"
+/* RoCE FW version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
 
 struct devlink_region;
 struct devlink_info_req;
-- 
2.5.1

