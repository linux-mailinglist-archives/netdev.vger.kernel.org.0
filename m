Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278477F692
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392539AbfHBMKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:10:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34360 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733171AbfHBMKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:10:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so33606059plt.1;
        Fri, 02 Aug 2019 05:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ezit0zivs2hU6JolSKQzorQ7Fhqac+qHOk4CCMI0rVQ=;
        b=StFL1GedVXXDwK1qbQRE+3pvjNbcfcCnEH1Rr+utBs8JNzOFpOHNfadfzqlntk4trt
         oyoExDgkTXKLbsWX8mn9VKjkYduaLriNLmlYHA7OvoUEKTDDafnGnQmJeeEsictN2hLf
         /UNYef0CcM9CKGxofEQp6eqMJPvGuabxVS99TFbHi3SC9+rtLUYBvO1S3KAc4O64QOaY
         FBCkV03lBBAsEPCj6wAbo0u86FnNMVAaJ0eFbwZuYaoemxeVyt8nEXw4CFAK5AwKMjoM
         rllncduIT86z2CZkW9gE8+zrtDfB1GiEPw11UEo6FhuCoqey6+fGb8BPmLO+FIa3Zx5y
         eraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ezit0zivs2hU6JolSKQzorQ7Fhqac+qHOk4CCMI0rVQ=;
        b=YXYuNl+g8Oo/vde5uWFGMsB05KqxorcbAB93Qbqov6zCPBDdqw5igkj40LMoBkhq5y
         5q1XEcbMn/ks+nH/gax/GfCWXbOTppIVC20tffl7teoDcd4nluCr4eZ4xogqp407w+fm
         AIT2R9NJASV7J3s5hzsBpDyxMv5/ROw20WituPmF7+yWEozLMB0bHWRkjvBhadVvP+aF
         qaHa+ITGYcq8c0au24t43f672kYTMyw/VO/G879R/SvGhi3vtHWekR8DHh44PTavCyTK
         B6gYi21kDamx/ecTAVbJN1Bhvu8hiEi0sLdmXMoW946WBjZr70OBei54PWKg6ri5pxTK
         3wIg==
X-Gm-Message-State: APjAAAWYVtSOTnnvMc0pZcaiHAltaTv2lvHhSjJdTG3PggX/SdaRuFMJ
        R6vw/ALFdGbb7Quo3mPTh+4=
X-Google-Smtp-Source: APXvYqyM1pO3L0Jfb/au6rk68wveYXb6XkOhvw7/dpZQH/VUbOa4MbfkS4VLhmz/bmROyJH4l3FLRQ==
X-Received: by 2002:a17:902:b285:: with SMTP id u5mr42160042plr.329.1564747849710;
        Fri, 02 Aug 2019 05:10:49 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id p20sm92882318pgi.81.2019.08.02.05.10.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:10:49 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 1/3] mlx5: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:10:44 +0800
Message-Id: <20190802121044.1375-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 include/linux/mlx5/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e6da1840c7d..ec8fb382d426 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -398,7 +398,7 @@ enum mlx5_res_type {
 
 struct mlx5_core_rsc_common {
 	enum mlx5_res_type	res;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
-- 
2.20.1

