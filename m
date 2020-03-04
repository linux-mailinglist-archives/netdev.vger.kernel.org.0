Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49EC179C59
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbgCDXYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:24:52 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46018 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388412AbgCDXYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:24:51 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so1737513pls.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 15:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xCDJEsdEpetrVOPMfXMpvNKqwuCy4QkRdRwox/YgAiU=;
        b=nmCXeLIH3weW+iqsGNcxmeKcsrzfh0PWYfmqCenYycUuoqmA2a033+Cljn53Xkz6lY
         4OzQT5Yp07j7tPRO/FN+V9qvazL4TDSd2l6G4iOhJQBZZvzgdJj9xp5/4eoIqZ8csemz
         hrboLYlTdwueYgqzQGLIN43VJ21lsRDp8l7WmbnG1gcLwlmCBXvPk90RMKvDGK/iHn3v
         k3BfSYmestcfJwfUxm5KEa8dtwJaDDmXQDMaX0t5RwoeqX6tk64qbO6mhtz7s+fVEgpu
         94/xbI0EA5LVfK4Ie1lrE2mspNpfTeJoi8MUbNFvndOCP+SwQNBKN2HNsrEBo8HEwmTu
         wLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xCDJEsdEpetrVOPMfXMpvNKqwuCy4QkRdRwox/YgAiU=;
        b=TpwPunmGLT4/BmDuainXKWGXdiM4fXdN8zLY7TfgKIhzZvf7XZwPHXznw1c6xRqK3H
         +dDXpsSMhsEsTeNteFaBrzba0yjpIz4SsG7eu1zNZwNzxmPqYGf4ldOPkklFWiwJYZeD
         ik9ebt1IJvk9SFRaSEvWU0BsB5QM8VYAapntWrRP45ZkttYHsoikkwreNFNdTiRCrnYu
         0HRRDNVg17hzLSmo9l6iRHYVh/59A2QSnd0exP80gHvceYiYksXfKv8lRSzKMId90ZpZ
         dZAY+jWXIHe61Yn76i+BF+YjMBUaYCQ9esxAY0WF9XT5NPSqezoVGKt186BAbktFCn/X
         nl0A==
X-Gm-Message-State: ANhLgQ30V1bXBI+GcbeYqX0p8mzxG5i3H+wN8L14XztRkJCP7gWfDWqm
        4klM0JbmTUbzznvY4dlNQhM=
X-Google-Smtp-Source: ADFU+vvIjAoxuq/Q6jW/J2IeEkpRMx85Wvg1q58jlsvUMl/j0nXuRl8y7W8zqOL6FMG7u2ALNUZcPw==
X-Received: by 2002:a17:902:b40c:: with SMTP id x12mr5293917plr.70.1583364289612;
        Wed, 04 Mar 2020 15:24:49 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n9sm25784894pfq.160.2020.03.04.15.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 15:24:48 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 1/3] net: rmnet: add missing module alias
Date:   Wed,  4 Mar 2020 23:24:42 +0000
Message-Id: <20200304232442.12335-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current rmnet code, there is no module alias.
So, RTNL couldn't load rmnet module automatically.

Test commands:
    ip link add dummy0 type dummy
    modprobe -rv rmnet
    ip link add rmnet0 link dummy0 type rmnet  mux_id 1

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - This patch is not changed

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fbf4cbcf1a65..d846a0ccea8f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -475,4 +475,5 @@ static void __exit rmnet_exit(void)
 
 module_init(rmnet_init)
 module_exit(rmnet_exit)
+MODULE_ALIAS_RTNL_LINK("rmnet");
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

