Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3825E1776F0
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgCCN1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:27:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39802 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgCCN1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:27:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so4332777wrn.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXu20Kie+gqASSxNXY02YrbMQMrpc23X1ygCcIPrCLg=;
        b=TMyOX6xMYC+HqAvhfxsw/cPgCCzGlluUmzdEVdY4I42MMkCG+qLCQWkolTVtT5wn+F
         Qw4U8Ce3O2cfeWkd1IzlNyGeP8J76hqHUyOsnvg/sqpd0VvyLl7UihvLSJT6npdm3odm
         qyB5UjD9TEgI7p7Z4Mb93jnRWw48Dk3BF5RAU6jlwhcDvpGiPS46SzTup6+9PJmLe53a
         vGLr9xH52TTyvD0keMa7BlV8wWQ+WW1D6mDZ083pD22UhwJ18XpwM6dnTY9pqEBuYxlW
         UT/KjBpUVAJ16jkWqUsrRXTCEB2HYALv7T8wOqURVOOiCdeA0pqTIMGaa/DlysYR2k8E
         OmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXu20Kie+gqASSxNXY02YrbMQMrpc23X1ygCcIPrCLg=;
        b=ntU5YItzR4oCaBBi2YG2zjfhNSRRbNR1sOBBvNkjSNoWXpbSEHq+RNnpGJX53dFxzP
         S8xIMDDuziX3KZke9x5WZTbbFPA4SE6e4naQobXVus+6GMT74F/e4o7It2EVot5/IOVs
         ysPQ5QI/ZHu7YTLOO/KCzDWlhYmsxBYl0mHaIWmXtYqayF4+GDIvphNH9VPH6+8D2/Os
         G85kmulmvuPmMPFaZXiggazT53ptRE4kPHBK0W2WQEBtqr6F+WVYDKG8qHXKjbIrUN+H
         933oAYiAiANR2c4E42ntWMxL/+Mdku5vUz/gABnQz0lI5w30OJ+1DW+MO4aqQtuD/Z5a
         KrTg==
X-Gm-Message-State: ANhLgQ0WRvGUhb7mnGCQ4CBNIIFqWKKnCqYuFixOuBQcl2NrZSIPBEiq
        Ato8YcTTgpMb7DWf9n1f5bJRPG24YjI=
X-Google-Smtp-Source: ADFU+vt/ZUn/vyJyUYgOTEon4ILIP172sWx7/ZbBxtncjIsh9M9EqWI4BuF0169uVP+nJWCRLv1EdQ==
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr5819575wro.254.1583242064042;
        Tue, 03 Mar 2020 05:27:44 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id b82sm3838844wmb.16.2020.03.03.05.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:27:43 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2/net-next] devlink: add trap metadata type for flow action cookie
Date:   Tue,  3 Mar 2020 14:27:42 +0100
Message-Id: <20200303132742.13243-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Flow action cookie has been recently added to kernel, print it out.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c            | 2 ++
 include/uapi/linux/devlink.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 6e2115b6c544..eef27c275921 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6932,6 +6932,8 @@ static const char *trap_metadata_name(const struct nlattr *attr)
 	switch (attr->nla_type) {
 	case DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT:
 		return "input_port";
+	case DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE:
+		return "flow_action_cookie";
 	default:
 		return "<unknown metadata type>";
 	}
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3f82dedda28f..a24d3c766d0b 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -252,6 +252,8 @@ enum devlink_trap_type {
 enum {
 	/* Trap can report input port as metadata */
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
+	/* Trap can report flow action cookie as metadata */
+	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
 enum devlink_attr {
-- 
2.21.1

