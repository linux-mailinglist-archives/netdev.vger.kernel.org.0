Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A7C423FC2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbhJFOFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:05:11 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:39970
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhJFOFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:05:10 -0400
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 79C6D3F32D
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633528997;
        bh=ibn5Z26Pr65te2VbiLuW3pAaYOxdHH6AdO7mMM/2Eiw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Gt5S355VXGxsHgOUnw2osBPnM9+Xo6NKNF5waY9aD/YKPmta2UhAztYR7NSaEUc3T
         utzYPg5EjuooZCP1ejOcPi548kXUs7eFbiziNcrWKeA74jrPAzZ+SzR3fdk2aAp3cS
         +Dd5c2jbuKYUSKscGKYhN8qZEwAs73ejjLLcoOxVv8IbRNbwSzglcPX3pckwZEkBUJ
         glSQb/zt9U9EU60hBzkac3X91e7nDet+fdTKi3rKVky6aex9S/RQVSQh3HjN+iu4JJ
         99e/c5db62R8ZgAzzNWe4urHDqQMbcgMrlSpLZS7E1+FBaoiYtafRGpjQv+36UsiPq
         c+o8869k2Uk/g==
Received: by mail-pj1-f69.google.com with SMTP id v19-20020a17090ac91300b0019fb4310e88so1590178pjt.4
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 07:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ibn5Z26Pr65te2VbiLuW3pAaYOxdHH6AdO7mMM/2Eiw=;
        b=4ZsM9dijw1cCXDsd+d+hYSt1SrJvMRbwMl+k9mxViV4C3oAPlPhyhJPjVz84nUpxJo
         IZqYMtulkvpHb/7q66bZWbMmHQHnWkPxu8AvdWW2gxBaY1LABYh9kBQ/3rBX7kgJ0Cbl
         zqRzQrRWi7HvSv2DfuoYzkTpyc0/BhY40jdO0irSAoohRRMGROLifjT+zq1jdLCy8fNZ
         iyuyZsX/wfTDUlF4fDKRvBiBJLWCGTIwzeBH8cXNieI5vRzVU4ytoD6yO5N9pD/Tsv+s
         RWGNLa4PfsRmnzmLY7MdtV8BkpR8tMVkM4y4ELlsfsCoKLrMiYYB+M3RwKebBKTRzup5
         hKtg==
X-Gm-Message-State: AOAM531rOZrT6bd2rPkviint+voEo+8wtaw40lMhKHI+YHjUEG6P+PWr
        JVdLCMDMofVc96bbsoODO1lm7R+lhLsZxZS6jQoDAPUhkcgFzTMmfmGS7oCuhkNa2c8C7BWm7GD
        rkUKT2p7ynzXqV7qOqWCkj4R0sTmDV4uq0g==
X-Received: by 2002:a63:530e:: with SMTP id h14mr20578592pgb.279.1633528994057;
        Wed, 06 Oct 2021 07:03:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKBRbnsaBXi8Wo3tc4fwij7fOUyYDsU281VcBiDVS2nS7CeoWGyPlnwDIvWDYDAhlfLpnrRg==
X-Received: by 2002:a63:530e:: with SMTP id h14mr20578337pgb.279.1633528991535;
        Wed, 06 Oct 2021 07:03:11 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id h74sm13448222pfe.196.2021.10.06.07.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:03:10 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     aelior@marvell.com
Cc:     tim.gardner@canonical.com, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][RFC] qed: Initialize debug string array
Date:   Wed,  6 Oct 2021 08:02:59 -0600
Message-Id: <20211006140259.12689-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains of an uninitialized variable.

CID 120847 (#1 of 1): Uninitialized scalar variable (UNINIT)
3. uninit_use_in_call: Using uninitialized value *sw_platform_str when calling qed_dump_str_param. [show details]
1344        offset += qed_dump_str_param(dump_buf + offset,
1345                                     dump, "sw-platform", sw_platform_str);

Fix this by initializing the string array with '\0'.

Fixes: 6c95dd8f0aa1d ("qed: Update debug related changes")

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shai Malin <smalin@marvell.com>
Cc: Omkar Kulkarni <okulkarni@marvell.com>
Cc: Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

I'm not sure what the value of sw_platform_str should be, but this patch is
clearly a bandaid and not a proper solution.

---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 6d693ee380f1..a393b786c5dc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1319,6 +1319,8 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 	u32 offset = 0;
 	u8 num_params;
 
+	sw_platform_str[0] = '\0';
+
 	/* Dump global params section header */
 	num_params = NUM_COMMON_GLOBAL_PARAMS + num_specific_global_params +
 		(dev_data->chip_id == CHIP_BB ? 1 : 0);
-- 
2.33.0

