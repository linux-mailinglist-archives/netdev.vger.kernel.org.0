Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C6C2CEE7A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbgLDM4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbgLDM4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:56:49 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4C1C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 04:56:09 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id jx16so8502385ejb.10
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 04:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3PKbhMmX31UNKFx+mQo7yG9hTCvxT2ibG15QLhRTrvE=;
        b=DoaQbH5qFFJaz8uiqcd28cbX4EctFb0yk0q19x7A9FzeayZ9Q8OkK7K69ybK1s8ohU
         BBm6aUn5oxjlNTp1V7JaGI+CMQDjAXIq3+aTJM68pN0gbNf/aws6eOeNtM77tPRyr2Qm
         9+ySBR20S8Cb5b9Oa5a3TIn6Ljb4AEysfwGPiXxlcnT9wP9heWGxo7i5Pqvck73C43Bn
         ERi4lynyovRLm0eeTy5i85cfJTO1/e2rmOMAW82vaiYCU7HhFXzA3iMmLg+1fIuqMLEc
         a9nky+S4cqQJAn2LU9ttVxGBbuETgm9SlSfQ/hGTXz2H4maWcVV/U2c297BLriFebh6z
         oBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3PKbhMmX31UNKFx+mQo7yG9hTCvxT2ibG15QLhRTrvE=;
        b=kwaMk6k0YczIcO+T2dgVaPtg4WY5eWzP/tG+sLdZnnJiPwexDiErZQa3yTF29yvE/4
         7SCoxiWyp1m9YCO715SAdSm1nCCZmmylwGKVEHGur0fKIOP+PKBoM2wAtTiBt+z7aIv3
         y2Ppl1gsL6trVu9GzOWjp3tsY5rspqKMN3wbAErgj1FXxK2YOE2f1Qq+CxbjmxwSOqSk
         ocCmN9piVcygEfItyQLdFNJXv2DoHSu2oYBVy/hMZv9haFg99Cbl9vFEKNvp561+po4S
         zNHUROHw0Mw8rjKxQYaLg1moPewXSKjF4WRcNhTK4oulxdH+NsEKYq33jdYRV63jBLtA
         FYhw==
X-Gm-Message-State: AOAM532cfoptuQXMGNnsiiSc03cV25gpovfzJ6dYbNyd5LliQFJPTHve
        uHRDm+kiRlcTGA4DbpuKfQqydA==
X-Google-Smtp-Source: ABdhPJwRRGfDRDJ0oIcApwMQIYFIjkudeFzCiEci9tYLMvwZfUMx4b+edKRxrFXsuijC3rqCLAeZ2g==
X-Received: by 2002:a17:906:2e55:: with SMTP id r21mr7055173eji.46.1607086567760;
        Fri, 04 Dec 2020 04:56:07 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id i8sm3382934eds.72.2020.12.04.04.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 04:56:06 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH] nfp: Replace zero-length array with flexible-array member
Date:   Fri,  4 Dec 2020 13:56:01 +0100
Message-Id: <20201204125601.24876-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use "flexible array members"[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays

Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/crypto/fw.h       | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/fw.h b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
index 8d1458896bcb..dcb67c2b5e5e 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/fw.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
@@ -40,7 +40,7 @@ struct nfp_crypto_req_add_front {
 	__be16 ipver_vlan __packed;
 	u8 l4_proto;
 #define NFP_NET_TLS_NON_ADDR_KEY_LEN	8
-	u8 l3_addrs[0];
+	u8 l3_addrs[];
 };
 
 struct nfp_crypto_req_add_back {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index f18e787fa9ad..10e7d8b21c46 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -1070,7 +1070,7 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 		__le16 offset;
 		__le16 readlen;
 		u8 eth_index;
-		u8 data[0];
+		u8 data[];
 	} __packed *buf;
 	int bufsz, ret;
 
-- 
2.20.1

