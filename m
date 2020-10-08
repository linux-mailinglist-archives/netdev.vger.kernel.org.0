Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE782878F8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbgJHP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgJHP5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BD8C0613D5;
        Thu,  8 Oct 2020 08:57:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b193so3766017pga.6;
        Thu, 08 Oct 2020 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tfp/qncVNy+GdVuYJXUXyCykG6PITl3LD9dt3WR8h68=;
        b=qlcvLZqguCbYKNDwPvqdcN8P7sE/S2uSqq+LY/gx6UY0gSLxO/5ZUEBwBvLGur+/2j
         TDhWqkrnuOby6EhTwbeusSt/IRnChGr3b3k/vtda7L7A0jHf0tFSQIDSSwk5TFDxeXfk
         yiyGxNOpf1Cm6zSUiotyq5Y4YC9JEdJ+/mE6TXTuDutxsVh5yt5kEDDFK/koaszygAg6
         CKDI1ZsjtSBeWMznUq7TJ2n+UIXLrk2vjmELBoS4eiSJJ8GhXnGobTFdHIC0fdEPke95
         D1F4QxfTepjHDIizR99LetQN8pO3hjrXSsywd9gkXDHpnS+k71MA9NSFa3d8ClmXOVyx
         tZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Tfp/qncVNy+GdVuYJXUXyCykG6PITl3LD9dt3WR8h68=;
        b=jbjlpNOjWGAsWCXB8fpJH870paIdRWkgCfA/jpmZHhtlCniP1DwAfB2R6zqDdg5cB0
         aXZX0eh0K2L3VxL7su8ItTBesjLEcEURFjrzkfeOD09J62FQ/thQtVfj/LsB29q9rFMo
         gl1SYKB5lUd20RFdm5sbA/wb6Np1NOfnqWvACQH36eYHFbQFEN875hCNTDpkDm5FgcbW
         X2LKDW5zsDWw3fL4ypYUyQZ/GqlOXB9LNjxs71TfDaW9AsizacalHC/yZA8dgNXnnXOR
         y5jtxaIzvrUVMlkCQMeKms/fjOtnuttUKewEiBuRNqs/2rp1QKDpvgn+CiNUVb3UEAe2
         mVBg==
X-Gm-Message-State: AOAM531RurYui32gSLP1bvAw/YGoE2U1cfaEBLxKD/IEa5AcJU/q667H
        +5ycRvMB4azyWw8DPm8hUGc=
X-Google-Smtp-Source: ABdhPJwdXOqEQIPmHdcTEm0vKPQ5deM+0dEYb+F5Limcyd5lWy9/cecBMRpQz8DhnC6BqFSa8wWCPw==
X-Received: by 2002:a17:90a:1ce:: with SMTP id 14mr8984314pjd.209.1602172626800;
        Thu, 08 Oct 2020 08:57:06 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 092/117] wil6210: set fops_suspend_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:44 +0000
Message-Id: <20201008155209.18025-92-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: fe9ee51e6a43 ("wil6210: add support for PCIe D3hot in system suspend")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index c1a43de9a630..4ac558f95586 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2292,6 +2292,7 @@ static const struct file_operations fops_suspend_stats = {
 	.read = wil_read_suspend_stats,
 	.write = wil_write_suspend_stats,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------compressed_rx_status---------*/
-- 
2.17.1

