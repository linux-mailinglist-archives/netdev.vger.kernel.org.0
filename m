Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33AF2878D7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgJHP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbgJHP4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E91C0613D2;
        Thu,  8 Oct 2020 08:56:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so2968658pld.5;
        Thu, 08 Oct 2020 08:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dYJORymmDlFcXkjE4Ia7fkXZnmkR7HLg5YNzzTA934w=;
        b=cOtiwfbOxO7Oyely0GgElaNABAJKVnJK9XnhmeyrqLhv83hJh19qCj4NmSMQi17ppi
         kZchgM/Rhk8M9Uh9HOjmVU37mMXBGrRDLvCLETZ8BKmi3IcGjv6Piat4yVgpLSYtVIEI
         MLlyN4LV//PKCzrqHNcFNRen4HOEe9zVwua97d7xTiKAOl305Prin2iEYDley+OizXm3
         0XTPnvHKbl8Rtwi997z3O7HAOZBwqvtYd09p8/h/T2i2qVLeKDioqKiOvKVKr1eNtVGC
         YW3poNTjve7QmEPBq8qZopzQEuFGIZ3cUsoUTujjBcJX0yvj8SXoQ8U0cJhWoY6J7k8f
         LktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dYJORymmDlFcXkjE4Ia7fkXZnmkR7HLg5YNzzTA934w=;
        b=t47OUZV8OLxm7tqIZXoFW4eLNi2rIgeWCW/3inLlYWAgdJJj25aOO9W210MUl3TAZE
         jw7tGLDR5/JyILzPSy7NIGPUzNjRyL2UslyFMH/VPdL96h2XyFmNf+WiNpNAcYesHRX/
         eNiOZ3GOtVyn5sWEcJs8Sa67pCX8CWmsNGQGxbA7qUZ0oYCKid8h9kWWBTJouQQrvXO3
         lrE16tvfLBULlzxyeGIeitJQ63wJpSSzbr5d6f1T7O+S0YebgzOGjw/irax9mFrCsMXv
         dShm8FUNqoyu5h9UVVzqXvzNx69td9rrG2R+8eaBmprQtiajVzgXI44i4kKOg2DTIpGE
         GhMw==
X-Gm-Message-State: AOAM530x+YmYDBnZIQiH5c1Gq+AD0nuofeBYQ6sJfittOF5cbr4bPIDE
        CSoXxYBAmlaS0osfXBU5Qmk=
X-Google-Smtp-Source: ABdhPJwTTwvCtZew/i9zvWa7BQ/E5Yrc1Sx99MY483IaTtm5D4amY/w/UrUag96XMzvZ7TvLVCvAGw==
X-Received: by 2002:a17:902:24d:b029:d2:564c:654b with SMTP id 71-20020a170902024db02900d2564c654bmr7682235plc.8.1602172574594;
        Thu, 08 Oct 2020 08:56:14 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:13 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 075/117] wireless: set fops_ioblob.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:27 +0000
Message-Id: <20201008155209.18025-75-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2be7d22f0625 ("wireless: add new wil6210 802.11ad 60GHz driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 11d0c79e9056..c155baa3655f 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -678,6 +678,7 @@ static const struct file_operations fops_ioblob = {
 	.read =		wil_read_file_ioblob,
 	.open =		simple_open,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 static
-- 
2.17.1

