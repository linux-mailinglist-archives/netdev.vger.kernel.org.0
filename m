Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF861444CF2
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhKDBU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhKDBU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:20:28 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01388C061714;
        Wed,  3 Nov 2021 18:17:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s24so4618607plp.0;
        Wed, 03 Nov 2021 18:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmA21mHyFdYSw373PIKJ4QpBwIAdl96sctRKyK3O104=;
        b=clO2FbsSVZOGTpPipOOowutBHDWGuFWq3X87fcgK/HJuSGExPgn989j+C96vvnISeJ
         u3JT73cVHN9dg85X3JZ2/nRd5ecy0WOcjbelEQCSszqq9f8yJHyKP9mniy5m6BtFNijb
         a1nSeDJOawQ/0ziT3Lj+7F+6W/u095vTWE5kKGdfRkMPjFkhp/XqXIht//rD/8/5mQY1
         ZAVfX5Y/wvGyP7P7x0YxN1K7ueiTgsA+HbIGQ+4Oeod1I7Y5oGrqiBYf7hkr0L+k/9Gw
         yNzpGA6mZ8jAX+FgkWtWPFQUW47+/J88iC5VBEOJ0/qp7vjsb/IK81uLuCxVSMgHGbi5
         Kqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OmA21mHyFdYSw373PIKJ4QpBwIAdl96sctRKyK3O104=;
        b=3RdYIVQrOHVZasdoGlGrI/Og1i0K38WZAyGNznjEtwNGDeb9lLb6fyi0SBSM6/zQ90
         h+r2fOzjCI2i8i0M7/EPa84k+kNumbEY+sjr1F2XN0zUKe1kwUyi0qDkkQ2W5cODM0FP
         /neZ6Z6RB1EDEQoqUu3tjd8z/9p7B07ZoVO7Pa+cb5VbJRsAXi5RQhId5T6fe0Z0EJ36
         YVMoONXE3Em0P4RZkv6ucDJqGJ5bU9pbHOyM5rzyKK85+xZRsZQJmmQN7/OKYThiP3VW
         eGOz2eDrnOokoUhr/M98Vzj11ZH4JXJRwkQ2SZOsgyUiIZhAti8ltrYDp//FSqvacrA9
         RsQA==
X-Gm-Message-State: AOAM533L5Ww2WFmw2hgLw3WKJPGpsEoV7xJwrrUqLwKjTEkTC7kIkb8f
        79su+K1Ta78lkHhiIBw3P5s=
X-Google-Smtp-Source: ABdhPJylmo1Ce8AIhOdV+4x/dEVx2aU18ITwGRJooPlOLHVIbQ4iIlAywX3RszS5aGBkvHGdkzG0tw==
X-Received: by 2002:a17:90b:1e0e:: with SMTP id pg14mr18357219pjb.143.1635988670631;
        Wed, 03 Nov 2021 18:17:50 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id g12sm176520pfv.124.2021.11.03.18.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 18:17:50 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     saeedm@nvidia.com
Cc:     davidcomponentone@gmail.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, roid@nvidia.com, paulb@nvidia.com,
        ozsh@nvidia.com, vladbu@nvidia.com, cmi@nvidia.com,
        lariel@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/mlx5: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 09:17:37 +0800
Message-Id: <20211104011737.1028163-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index c1c6e74c79c4..8ce4b6112169 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -907,12 +907,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_tuple rev_tuple = entry->tuple;
 	struct mlx5_ct_counter *shared_counter;
 	struct mlx5_ct_entry *rev_entry;
-	__be16 tmp_port;
 
 	/* get the reversed tuple */
-	tmp_port = rev_tuple.port.src;
-	rev_tuple.port.src = rev_tuple.port.dst;
-	rev_tuple.port.dst = tmp_port;
+	swap(rev_tuple.port.src, rev_tuple.port.dst);
 
 	if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
 		__be32 tmp_addr = rev_tuple.ip.src_v4;
-- 
2.30.2

