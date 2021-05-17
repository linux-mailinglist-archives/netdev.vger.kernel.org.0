Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A093824E2
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 08:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhEQHAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 03:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhEQHAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 03:00:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D067CC061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:58:46 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id y14so3057339wrm.13
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jcKjaQL7Xk1JC6gCVJOO90s6BpRlnB3wzK8G5jRc6ow=;
        b=Efd2Al4EurIOnkzeoAQPx4KJ7itBiosdBz2m+OSPFYbP0m6XCNTgn6ZDx1YIG9QhSM
         2N7n3oo88gfNzeanZzyqaAbnqC0gE9KEbdJFtn6qvpiet/Kmh8Y1Nsh6GPKACtaoS/bF
         w+dNKDKuBTiBq75F9ce+5ldzZtfHUt/mWkCOngXy0IFgEjsKJKIaZ1NXEhN6ViLJ52/l
         prQzXGnZhINA79lf/4K9/swNmooUvs1xsjO1AZUYqbrK1R41jvwJbtp4ev0MEqy8PgdC
         48srSzrQzCbBEb0p6YH9zcoYL14Z6+y/bqOrrXJRz5lso0cf/Xq5TnqcvhB7Ai2XxWgH
         43MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jcKjaQL7Xk1JC6gCVJOO90s6BpRlnB3wzK8G5jRc6ow=;
        b=mJ+qc/voFLGjaWoLNf4PTa95uH77OAo3zCW9f063UfTNOSXUV773fau0Xn+l4t0xrq
         yvS1fe9SRVYa8wIKJ4B0JYPolLJwp34OOyUcRLi2jvHetXy2Qh0ogqCFjrKg/EiMELR1
         mU2l3RA/TGMRS0Fp1m3VFQjUpOwGTOk47m5GHt7YXBs6vhIcAjG9UTv7BJlNF3eac42/
         y6gqnpTBokNlbMwhe6WyBmlOaQH5Rw5rgQpxuA45OHy0DHTttOdgKRzFlgqOtDdugW1q
         a0EuhK3fMJ/ajPwskTPhEHkoLBLjGF3cW0L7PNpOJrKHJCFSUne58w4dfLG9l3RtBTea
         6+4Q==
X-Gm-Message-State: AOAM531hMlVg6TBoNYpH7ebgMWK76pyKbEmYfXiSKH9o01lGYkSb0HUh
        HmjZbdYCjq00G+O3PIfGS241N2FyLbzJPA==
X-Google-Smtp-Source: ABdhPJzWmBcmJUEVCnrRzJptK8vMxnyA4OnJ7VvRNXPz3366v+5ryc0ZK7CRqTtiDHzXSf1KEZHndg==
X-Received: by 2002:adf:e3c8:: with SMTP id k8mr21660456wrm.212.1621234725357;
        Sun, 16 May 2021 23:58:45 -0700 (PDT)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id p14sm15931877wrm.70.2021.05.16.23.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 23:58:44 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2] Fix warning due to format mismatch for field width argument to fprintf()
Date:   Mon, 17 May 2021 08:58:31 +0200
Message-Id: <20210517065830.3477-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt.c:66:54: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘unsigned int’ [-Wformat=]
   66 |   fprintf(stdout, "Length is too short, expected 0x%lx\n",
      |                                                    ~~^
      |                                                      |
      |                                                      long unsigned int
      |                                                    %x

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
v2:
  - use '%zx' since the value is converted to size_t (thanks to Ben)

 bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bnxt.c b/bnxt.c
index b46db72..2b0ac76 100644
--- a/bnxt.c
+++ b/bnxt.c
@@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_r
 		return 0;
 
 	if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
-		fprintf(stdout, "Length is too short, expected 0x%lx\n",
+		fprintf(stdout, "Length is too short, expected 0x%zx\n",
 			BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
 		return -1;
 	}
-- 
2.30.0

