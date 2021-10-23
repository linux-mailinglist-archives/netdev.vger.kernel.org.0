Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F05B43829D
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhJWJ2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJWJ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:28:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25916C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:24 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d3so413824edp.3
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=umoDlPDF0Z9LWOPG1G9yeEVh2KZ9i5XqGYFFYsZfcsI=;
        b=czC6vM3WHq8Fbtt8WeoqB4KnJbBYckPAqs666a8H9BsjUDD7P9kC8EQRb20NXK9G8I
         fs0WONCpBFN3JyK7UxrS7wcZh5YSwQnHpKs1+twZ7CWdKwSmOdPTsw6l1IL6oStnMFuT
         ka08342RmFpy1ZjyT+uvdmb3PlluyI+s7hI/xRgqiO91m3JaSdAExwxrfNEO6cHsc9BG
         GJSDR7nxYBtEBLUxThn8pn0bmQO5t/PaUA0k1J5WDE1PYFI6QebIRUHKbV2DjwMJpOBq
         KP2YXUg/A8D9j7tuVTEyYmBxAEqA9lY5CEmh8mCofjnwlxDKKveq8BBXz+eITYCNspXi
         VA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=umoDlPDF0Z9LWOPG1G9yeEVh2KZ9i5XqGYFFYsZfcsI=;
        b=PjuTZXbrNG9gyPZhuKqbwfbS/VzU9Q8oTVNBiXOl2jyz/CZEDUZt9/0hb363D5VyHe
         pkM4toHK6SCL9OogcoL4eAUTN3P24KYtQPzStgWSEGjvdv5rotpQwR7/2oJ9GZSz1PG7
         iYcf3Bso8o7MwIpDSYNlI8xbUeyHHIkeaQgk1xVB85rafP0gTM/nvMicKa1eUGFBkg/m
         phPklhuanzeIVVrXwBfNo5RYjTrzrafNqGjXOEPCPt5Jcd9PDJr6KeSilLNUqaP8op2y
         GGp6xhfZ0SfUskswq6NACmcwJzigFI5J7UqAu7UPtA5eBsVzMqm7AVud3bSdy2ltI9Xu
         KZ+Q==
X-Gm-Message-State: AOAM530Zw/+dCAgIJTkvIKEJxkwP5yZzvjrwp9XU8TILqqzqumHcWoiK
        ySB4wMyoO83AEioDGlbTCLWzuoIa5Bs=
X-Google-Smtp-Source: ABdhPJxhpzKB3k9KsJslChMVIt9O1ol9SinH6/L+YpzqqV3lLIJfglRnEOFkoNynLXoHsv3OonaDyw==
X-Received: by 2002:a17:906:3ce:: with SMTP id c14mr401867eja.102.1634981182800;
        Sat, 23 Oct 2021 02:26:22 -0700 (PDT)
Received: from localhost ([185.31.175.215])
        by smtp.gmail.com with ESMTPSA id n24sm5756162edb.28.2021.10.23.02.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 02:26:22 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: qed_ptp: fix check of true !rc expression
Date:   Sat, 23 Oct 2021 03:26:14 -0600
Message-Id: <a5d751e7c00036599834abf4dcea16572db0c004.1634974124.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634974124.git.sakiwit@gmail.com>
References: <cover.1634974124.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove the check of !rc in (!rc && !params.b_granted) since it is always
true.

We should also use constant 0 for return.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index 2c62d732e5c2..295ce435a1a4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -63,12 +63,12 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
 		return -EBUSY;
-	} else if (!rc && !params.b_granted) {
+	} else if (!params.b_granted) {
 		DP_INFO(p_hwfn, "Failed to acquire ptp resource lock\n");
 		return -EBUSY;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int qed_ptp_res_unlock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
