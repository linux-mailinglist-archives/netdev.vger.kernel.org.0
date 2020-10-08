Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC628786B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgJHPyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbgJHPyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54697C0613D6;
        Thu,  8 Oct 2020 08:53:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so4640649pgb.10;
        Thu, 08 Oct 2020 08:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bB+1MXsxDZAN9gzNUWCR5+heJ/Oe78Bel06flJGFtNY=;
        b=V4s+5OTBPIf1OyMNjaAFgK3GOh2dRJaE4BN4GrM+GKyMKxyo+hJVkh88LJFHSZ/mYu
         S00TDvyTeat2yKY8YIFfVM5YOB54Csynlnud//6VXiTP5w2jet65s2r4PqmNNf92ZJ9r
         +kGtkRtVr0W8OhQxuRB+J55BXeX35zHsB/HqgSKULvb9eTPxKGJa/h5ETMxZwL1tcGHY
         CZV9IhNIUCEvr1WiZs9COnvfJPgI+G5ubxkLLtLf219XzujtVeTNuGDpWcc1Fdl27lzn
         aiPqi5XNz6j+lxK3nDrGO8S3sm7DSu5sPhwoADjLWQljzEbSb+oNKjQ06Ia4NSoeDWeq
         mhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bB+1MXsxDZAN9gzNUWCR5+heJ/Oe78Bel06flJGFtNY=;
        b=WBXlW+QFOhAbJd/7mEAK1h74kc6LAP6M3ElWtc9hUxrDLkXWC0TiCFgL4f3DZT8Ahs
         beYRCWPUSY7TWankndHEllbePq9WOtt8VKYPFVwfXbeY7JYz3JHzd2KyKKk9rjfgX55M
         TDRbZD0KYbR4Sr4lFDvadHkwdssY/QHGoWXuvaXWiu+h7InSLvZwdN59Yvg7vR1bGXTy
         XJwD0Cs968gAlqJjiufEZOx25hUbHkeLA0/nw3LVMOJ79GsIPsxGjF201+KhITCw1W5u
         oHJWbO1Y+EOvrOwtKNburuVF8/iujrHzTjQPvJz1Za3h1GMl2/67a+rRoO/ihMRIlklM
         +82w==
X-Gm-Message-State: AOAM530Oed/RPC2Qmr8Zyz9AUAJDUpAD8t48+KvtRq8mU0+i7q9x4ebJ
        W42i9emuUJWIvuLMM58t2ho=
X-Google-Smtp-Source: ABdhPJxHlto/JEPkuzSQGItC+3Wl+aSVcm7IstwCxAkZK0lCP8LPfmgscVaiK1aG51zwX7rbq3Ktog==
X-Received: by 2002:a63:f015:: with SMTP id k21mr8053455pgh.422.1602172437868;
        Thu, 08 Oct 2020 08:53:57 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 031/117] dpaa2-eth: set dpaa2_dbg_ch_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:43 +0000
Message-Id: <20201008155209.18025-31-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 091a19ea6e34 ("dpaa2-eth: add debugfs statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index df84324efb50..af76cb9387bd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -170,6 +170,7 @@ static const struct file_operations dpaa2_dbg_ch_ops = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
-- 
2.17.1

