Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A317755FCCF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiF2KDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiF2KDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:03:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42CF3D1FA
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:03:43 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e63so14853641pgc.5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+1Kh9yXYSF/SSlAxUUF7lfd7AbotnJ6XEUP9Y2jqwE=;
        b=bT696kWD335zwtQvW47vd4+mT5xdlttfcuP/cfCSLGtb7YgSROS2L7ffdCL6lmeT9X
         hLO4kCeKrh9RhaoNZxg6Eb6G+AeKxnOiLYRUTEAnkTGswpNC6vnrXR6z0mf+a5G3eiBo
         qz29lWEkYZ+jCGe3KfM0543mgg0fJH1DNS32yfChg36ESaebBkp+5PiUj4TLvqXaNtAB
         hFiO0kxoSePedtkr8Bj6ref1wJrQW2YrtDSKlp8QvVVMHgn0EQdjXFyD+DRBJhVULj3G
         3PMAGlJ4zKL0SJ3SmGf40soyRQiN8+kQzPniaDWJ4WGCcVg5SX+5l2znBCumkn7e5N/I
         ggLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+1Kh9yXYSF/SSlAxUUF7lfd7AbotnJ6XEUP9Y2jqwE=;
        b=Z/gKHwDQRyLan627xcVo+ZlhuYiPO5Py8Smx9SEfbuQaG07Dan3P9B67nRSfOqNgzp
         FJN74hp2rTCK+8nHc5d7LkGXh+9USsNiNGDBuzSYOz5GJuvWkmdd1MZ1DdoH9GA8wpHj
         s+5UvL+k58JKE3KLQPL7qtjtmYwLZW9Qg/ByGz0f++fW/Y1NE4uXvcxWdX9e3D5zVg1Q
         iBLq8KiiOwljGei2nf8cSsK+hJbbO2aVmUOwmBRAqaQKIuHASdwlcvxzW642gINpR3PP
         ZJt2ucVnr0SUCFJIn7CKT01nx6Bfd+gq7P1TXQQeZKCd5uAkrDUIkwmqxVfwqemwr3o6
         /ldA==
X-Gm-Message-State: AJIora9rvM9eAChf4mqlv1USYAfKxXAAEYy91JjJ44b3LLe4XEWpMGZr
        kt0qBLR5awtvnK4IJ8yPIzcpdQ==
X-Google-Smtp-Source: AGRyM1sTw4UxgBgSUAtM/Ce+HiXo5qoS5Rt9oKfdvJ/YFT4je9ZLNVgxqIQyVnyMl/m9dosjMIfh0g==
X-Received: by 2002:a62:7b95:0:b0:525:8304:2f16 with SMTP id w143-20020a627b95000000b0052583042f16mr8194428pfc.33.1656497023394;
        Wed, 29 Jun 2022 03:03:43 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a1f0500b001ed1444df67sm1696872pja.6.2022.06.29.03.03.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 03:03:42 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhuo Chen <chenzhuo.1@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Sen Wang <wangsen.harry@bytedance.com>,
        Wenliang Wang <wangwenliang.1995@bytedance.com>
Subject: [PATCH] ice: Remove pci_aer_clear_nonfatal_status() call
Date:   Wed, 29 Jun 2022 18:03:34 +0800
Message-Id: <20220629100334.60710-1-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After 62b36c3 ("PCI/AER: Remove pci_cleanup_aer_uncorrect_error_status()
calls"), Calls to pci_cleanup_aer_uncorrect_error_status() have already
been removed. But in 5995b6d pci_cleanup_aer_uncorrect_error_status was
used again, so remove it in this patch.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sen Wang <wangsen.harry@bytedance.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..6bf6d8b5a967 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5313,12 +5313,6 @@ static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
 			result = PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	err = pci_aer_clear_nonfatal_status(pdev);
-	if (err)
-		dev_dbg(&pdev->dev, "pci_aer_clear_nonfatal_status() failed, error %d\n",
-			err);
-		/* non-fatal, continue */
-
 	return result;
 }
 
-- 
2.20.1

