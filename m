Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608FE6F1F86
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbjD1Ugk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346698AbjD1Ugd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:36:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9447A3595
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682714130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QTPz7eQjXeuR2VgVi4hv9A45H01RIqdRghA7/gA//1E=;
        b=hvCEM2yRKSgwNyssEPZKS1vrnwme7mSXdXF3UuXjeFdSn+4+9hh+5jqOT7CSC+ap0bAAxO
        AKy/gnA47HaX5PwAYi7IXwL7zOsrUk3+gCdZR4c6onQlsUQzYhlLouit73/RjUU7Xsyan9
        6sGTVRU+8tpdnrxdONkAScnriGZSr8I=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-oJ2mJJ_EPt6C_uSU8AQu8Q-1; Fri, 28 Apr 2023 16:35:29 -0400
X-MC-Unique: oJ2mJJ_EPt6C_uSU8AQu8Q-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74a9043b68bso15621585a.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682714128; x=1685306128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QTPz7eQjXeuR2VgVi4hv9A45H01RIqdRghA7/gA//1E=;
        b=aIDcaCUY+xAnupGw2zDA0sgeIlJbitJtnkcS4mOU4U+BQHlLcP/uxZ+o9Yt7yAok9O
         PAjuIP5qgrOzgFFLuMJFCqEYgcOPvlXwO4zFjtZttulJmNZYjZVRdBXkyafYn4zz4jUn
         HeEIuOHTdvS9OvX+O37jEM33OTb1DBnoxO22MppqInLDYFFK+/O76sSPd8LJap+ajKeU
         zb7umAJXdLqlgzTKqqMBcRKU/E5PRBI+Y7S/0gqGmlPYPg1Q55B5toy4hKY5efc3bHyW
         vfeq5t72hD2hswJm884rdF79kXuZi4+PDQ7ujdDIPshgQrVypSLbC8P1eGYYCoQShRml
         N3pw==
X-Gm-Message-State: AC+VfDxiJVru0/gNe7IzGwMTvZEiSxF1UCI+OBuDRNhEFYiLxJgWfzUO
        t2mCfOIL5qNd6OG9Wj7BLI8Zqw2LZXkG4WqVR80fwj22VDtjz07cA8C6jVj/ZbrndJBT7//zWhK
        c5CddA+5TxS/Ue1Ky
X-Received: by 2002:a05:622a:394:b0:3ef:3dac:44e7 with SMTP id j20-20020a05622a039400b003ef3dac44e7mr9906866qtx.2.1682714128580;
        Fri, 28 Apr 2023 13:35:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5XGP3FpKHgGxVj6RqKSawttiSiOXczzRy5FAhiPQUMuftmadSZcMvSRWAY2z0hjSDX5E7ACQ==
X-Received: by 2002:a05:622a:394:b0:3ef:3dac:44e7 with SMTP id j20-20020a05622a039400b003ef3dac44e7mr9906842qtx.2.1682714128334;
        Fri, 28 Apr 2023 13:35:28 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a145-20020ae9e897000000b0074de7b1fe1csm7044947qkg.17.2023.04.28.13.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 13:35:27 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] igb: Define igb_pm_ops conditionally on CONFIG_PM
Date:   Fri, 28 Apr 2023 16:00:09 -0400
Message-Id: <20230428200009.2224348-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For s390, gcc with W=1 reports
drivers/net/ethernet/intel/igb/igb_main.c:186:32: error:
  'igb_pm_ops' defined but not used [-Werror=unused-const-variable=]
  186 | static const struct dev_pm_ops igb_pm_ops = {
      |                                ^~~~~~~~~~

The only use of igb_pm_ops is conditional on CONFIG_PM.
The definition of igb_pm_ops should also be conditional on CONFIG_PM

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2540..c5cdb880774d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -183,11 +183,13 @@ static int igb_resume(struct device *);
 static int igb_runtime_suspend(struct device *dev);
 static int igb_runtime_resume(struct device *dev);
 static int igb_runtime_idle(struct device *dev);
+#ifdef CONFIG_PM
 static const struct dev_pm_ops igb_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(igb_suspend, igb_resume)
 	SET_RUNTIME_PM_OPS(igb_runtime_suspend, igb_runtime_resume,
 			igb_runtime_idle)
 };
+#endif
 static void igb_shutdown(struct pci_dev *);
 static int igb_pci_sriov_configure(struct pci_dev *dev, int num_vfs);
 #ifdef CONFIG_IGB_DCA
-- 
2.27.0

