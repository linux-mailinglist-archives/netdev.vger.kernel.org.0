Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825BF608447
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJVE1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJVE1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:27:22 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58F12A5699;
        Fri, 21 Oct 2022 21:27:21 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id h10so3160931qvq.7;
        Fri, 21 Oct 2022 21:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IHBmQcvSONp1skndlop+2zNlLfEhZ9bZQFsTspZ9/YM=;
        b=dsuAqmmKrNx2KZNnpyKAM2O3haJys8sggQelTM8E66lsLPDTL15aJpuLat3P9yA9ib
         7tzTAOkTBi6L8dz4CLbm21v8Ne2z6czqj4P0sZM1xrvPNaLJFMHpylL+xe6za33Pc+JP
         I5kcinzg2BeVMClilZ04I+bts32JnAsjipup6AOQpe6hMQ9yWB3fnaWW8DwX/pmU2Q+p
         ZlmAArD0HoRPy0J0fxIOvmrjsCRIMQLicSc+ugcqsT0cI5VAgMcTBGOAQdRtgM2d0zJZ
         +wsdRRK0wcsRs0u6OgqDPV0Depg8D8XGhGW1oAxQ2PtePhR9ZiEnGeAGI+mbjLdhDIai
         LnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHBmQcvSONp1skndlop+2zNlLfEhZ9bZQFsTspZ9/YM=;
        b=eoGGKn8FSMTAYjaoewpmIaUSm72hGXKZHQ1pMb0l9aWTp+tIjaIia7xU8EGIeNmKtf
         q8Z8LeehOaScXFr1FlYuGWLAk86x0B2D+Q+sIQT9b58tQoy74vIe6sJt9wtyCreNfVk7
         DXrUUnUXzJxAERQnlUNfU06rbnUoXx6aPj7b10fMRxw39RL+PuXGBIxUQK6/Li+pnrvT
         NzJmZWj6Kkbxp8e1cKpRblbi4Z3oBIZPNfWLnQt0L6a50gD1yxihD7gVtfJ/TQi7G/1r
         F8sqrVN/+wBLQDs893Fa7BOTQbL7v2bMWcVn+PXuYiYiItFRaYvuiduRkF3AmlPn4P5X
         9h9A==
X-Gm-Message-State: ACrzQf0F4jgHB+h6oORmdSqQD6TdV3esMqbM8yaiYJh1vn79SYS2JqW9
        Ii0kwSN23xzbQyr9+gKjjkU=
X-Google-Smtp-Source: AMsMyM47/wrt+mpOghumH6l58S+MyIEdVkmrP+cqy4Oyr5XtY3JcbauDeH4fb0CuhlVVOHmJpcQ4ug==
X-Received: by 2002:a0c:b295:0:b0:4ba:b9b4:5159 with SMTP id r21-20020a0cb295000000b004bab9b45159mr6290441qve.19.1666412840868;
        Fri, 21 Oct 2022 21:27:20 -0700 (PDT)
Received: from luigi.ops.stachecki.net (pool-98-113-41-201.nycmny.fios.verizon.net. [98.113.41.201])
        by smtp.gmail.com with ESMTPSA id s3-20020a05620a29c300b006d1d8fdea8asm11234988qkp.85.2022.10.21.21.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 21:27:20 -0700 (PDT)
From:   "Tyler J. Stachecki" <stachecki.tyler@gmail.com>
Cc:     "Tyler J. Stachecki" <stachecki.tyler@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath11k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ath11k: Fix QCN9074 firmware boot on x86
Date:   Sat, 22 Oct 2022 00:27:28 -0400
Message-Id: <20221022042728.43015-1-stachecki.tyler@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2.7.0 series of QCN9074's firmware requests 5 segments
of memory instead of 3 (as in the 2.5.0 series).

The first segment (11M) is too large to be kalloc'd in one
go on x86 and requires piecemeal 1MB allocations, as was
the case with the prior public firmware (2.5.0, 15M).

Since f6f92968e1e5, ath11k will break the memory requests,
but only if there were fewer than 3 segments requested by
the firmware. It seems that 5 segments works fine and
allows QCN9074 to boot on x86 with firmware 2.7.0, so
change things accordingly.

Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
---
 drivers/net/wireless/ath/ath11k/qmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index 2ec56a34fa81..0909d53cefeb 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -27,7 +27,7 @@
 #define ATH11K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01	52
 #define ATH11K_QMI_CALDB_SIZE			0x480000
 #define ATH11K_QMI_BDF_EXT_STR_LENGTH		0x20
-#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	3
+#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	5
 
 #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
 #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
-- 
2.30.2

