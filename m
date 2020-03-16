Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2328818735B
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732469AbgCPTb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42383 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732468AbgCPTbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id t3so8450143plz.9
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jcs/0s3CZSPtzbiw1HbYF9/yaS+V0LYheoQxKQVUgmI=;
        b=4DG6wS0JeSLFdQ46V62qLOkcPHmWMu5B3CFnxUDNfsfj7QxmM8MD+RMHl7SQMqcjyJ
         CfWnD9OLMfJ7FcPaGbr3aJ2iNRq3em1pFxYW59aLl9B+ApSFdHfrIyeZULw3Tb+pDh9J
         2eCV49GQuhK0oAu58YXkZFPbhCsOwZE/vgCQBXRZ3ryFQNDDir7nIEm1dIj3kseYL0Ba
         3VLqClJsXn6A63AwdYsInW5HQfOCspnI0eK/k6AXYjchHdvdbxqqamhDZWpsRG4rLhcz
         4ivR99vBSlSjIbNa/rCDIqaRER0ZwlzUYtUQPmuBWWjzZyTH8shyZ9oCUKuuS7XPvYTU
         D6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jcs/0s3CZSPtzbiw1HbYF9/yaS+V0LYheoQxKQVUgmI=;
        b=EEDNKRUM7uxdQgH1KO6fYQRyy7fEQt0jWXrTYV7q1ozjxPVKxxezSRrkLzGt938me0
         DM4XSZF2c0ikIcQAxg6j/YBfgJZA8S0sifDemMTfw8ifPoI7GGNfvtQKhCgAWB5833Vh
         PMizRUR7Tz7rF0mg4yuftoJkpA5zD3J2mYK6cyLzR7oVBf0/kHTcPGQr4MCTcNWZ6b3D
         17vts4ELb1vkCDkgC4sOhUFkPFT6XSpfDZ+VmxIWEnp/6+fJ7u6DJDYlKHTeO30y+szi
         u3vpLVlMGrT8GWdRbpEDxq08Bsplc0cEolcg/iZgNHWzb+i34UlaxCBPW549sbKEvlIj
         Sxgw==
X-Gm-Message-State: ANhLgQ2Txqk/67gduR6R226RN7Xu4knbqlZtatSuKuqeoQ2wp2O+9dJm
        MfWUEJtPjcbXB5pwmfbf3vehBM+mu/o=
X-Google-Smtp-Source: ADFU+vtphku7mRGI+eDsdJbb8wmZuCGYrfJxteGPE1TYJjX9yY1m1FVlZKj2/MSSBqAtTCl718+3Iw==
X-Received: by 2002:a17:902:904c:: with SMTP id w12mr720409plz.35.1584387113326;
        Mon, 16 Mar 2020 12:31:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/5] ionic: add decode for IONIC_RC_ENOSUPP
Date:   Mon, 16 Mar 2020 12:31:34 -0700
Message-Id: <20200316193134.56820-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316193134.56820-1-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add decoding for a new firmware error code.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index e4a76e66f542..c5e3d7639f7e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -58,6 +58,8 @@ static const char *ionic_error_to_str(enum ionic_status_code code)
 		return "IONIC_RC_BAD_ADDR";
 	case IONIC_RC_DEV_CMD:
 		return "IONIC_RC_DEV_CMD";
+	case IONIC_RC_ENOSUPP:
+		return "IONIC_RC_ENOSUPP";
 	case IONIC_RC_ERROR:
 		return "IONIC_RC_ERROR";
 	case IONIC_RC_ERDMA:
@@ -76,6 +78,7 @@ static int ionic_error_to_errno(enum ionic_status_code code)
 	case IONIC_RC_EQTYPE:
 	case IONIC_RC_EQID:
 	case IONIC_RC_EINVAL:
+	case IONIC_RC_ENOSUPP:
 		return -EINVAL;
 	case IONIC_RC_EPERM:
 		return -EPERM;
-- 
2.17.1

