Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319E6CDC58
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfJGH2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:28:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55269 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJGH2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 03:28:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so11361996wmp.4
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 00:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oNHjDKXVpMfPBy8esRdnI0f9HgdtFJR5+WHuIBHlOXI=;
        b=Q75kS7RYiQ90AWqRid32kmqSrJgTDkEwOWpqh7LduwnsAk2rFTudISX2TljauMIgj0
         CqDT4DJ55bDr8jRYVUWM7GC1M3XX+aHjVPgK0tw6nH6K5CiNpBd9rv0JiCff7Tq+qDHs
         L9vOW+13OVc/5+MfeH05Co0dTm+SUb3HWckz+nELbrMmRT0rsuGT9kyBOEPDPy1dsmp5
         Zhc0dBLS+aDCSU484pv+xr8ELmkY+m06/ZGPf8Pr+e/f9SQcrYdqlNXPKk1hIW+0joq+
         HdEar/RpQ0J4coPmX3vo7r+5UAdP48WKwmM5wRhBeAe1IqJXXsv1SE54mtWXgfq1BvQL
         GdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oNHjDKXVpMfPBy8esRdnI0f9HgdtFJR5+WHuIBHlOXI=;
        b=IdTUHkIiSAuUCMWJcsR/b1u4KSFSdOo9T7G2+4DKkTDqlCOWRybYRBlsjaRqd2MyEF
         dvTWYTLCh0B84+YE+K3QQTiJ4E5sy6S8ABzszvRG/PYzcUSMVz6PHsBZSnMNUbCmstkx
         oM00E1PM6IxTFz2x9t4EynxWh1F6JY6lLeR6tsEGKUCF1gLrYnY87RZg1/97BGve98tq
         BvqQ/CfZ+wySKG4hJJadUJWVoBY5EePzaXH8TD0XTeK9bPp2gFq5NlVL7AlKD/FW41Vw
         JYWL31LhCq9xMrIh4QiwaAzUhGXn8Yr9Mv68tBT4/X6EVND+XQ5wSE/ypw7t9mzFGD2V
         4ULg==
X-Gm-Message-State: APjAAAUWf+okITLbojA8VAFm/XJx69Bp6NT3qrWrdWaVBW+4XDxIeoHa
        kyKe6Rys8V4kkuJxnv+8FpBZKStTAoM=
X-Google-Smtp-Source: APXvYqzvgFNexawapQ1jYH1ZOUh/7WLZOH6bMIlRV2jSgbvIG5jmhwerjDw9GJP+GYX7qUCsPyOAjg==
X-Received: by 2002:a1c:a697:: with SMTP id p145mr17751910wme.24.1570433313039;
        Mon, 07 Oct 2019 00:28:33 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id w5sm14648066wrs.34.2019.10.07.00.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 00:28:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net-next] net: devlink: fix reporter dump dumpit
Date:   Mon,  7 Oct 2019 09:28:31 +0200
Message-Id: <20191007072831.11932-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In order for attrs to be prepared for reporter dump dumpit callback,
set GENL_DONT_VALIDATE_DUMP_STRICT instead of GENL_DONT_VALIDATE_DUMP.

Fixes: ee85da535fe3 ("devlink: have genetlink code to parse the attrs during dumpit"
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 22f59461b0c1..eb0a22f05887 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6176,7 +6176,8 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_health_reporter_dump_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-- 
2.21.0

