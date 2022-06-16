Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7680054EEDE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 03:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiFQBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 21:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFQBit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 21:38:49 -0400
Received: from mx0b-00256a01.pphosted.com (mx0b-00256a01.pphosted.com [67.231.153.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9B763534
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:38:48 -0700 (PDT)
Received: from pps.filterd (m0119692.ppops.net [127.0.0.1])
        by mx0b-00256a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GMitua037642
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyu.edu; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding;
 s=20180315; bh=GFoMOOEAdqdWnbQOc5swfRziAmYkgmKiyui5M23c4/4=;
 b=bGtCconcTLfck7+tYD2kWk7e+4HORjlLfote+vIhJxGn0azpVcrQXYjy3q6rpfubPhHT
 d+mZjR78SjGemrDA7tthcBTuXchTzQ0OMlpryzBhgRtMz/Yam+31+aNPec21yYwj3msG
 cAPAiAv+nplb1ZhBEI7umFLFX1lluCOntf34VORgqS6Clyx06YWOsGUFV0m12+NsX0dN
 ZWDHno+t0CQsBDUz7UTiU3AoVrUQ+E2pxsllqR81p9Lki2aRy9rg72xlJlbRmQUBvyge
 fxt/QTrm5096zHUf5boeoziagLR012c/J3D64nvVzAD82s6Vk0WaDzNRHvoKcVyrN2VX Qg== 
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        by mx0b-00256a01.pphosted.com (PPS) with ESMTPS id 3grdk7gwqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:57:48 -0400
Received: by mail-qv1-f69.google.com with SMTP id x18-20020a0ce0d2000000b0046458e0e18bso3114924qvk.1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFoMOOEAdqdWnbQOc5swfRziAmYkgmKiyui5M23c4/4=;
        b=c9Bxm7EPZzVlKONapxsNJ0gfkQtJzDjYnb93gHgCx/Ok63vgKozMZvVf3/xXUojfhz
         wkyr+JgtSO9K3kyFEpHlJNJfZe7hf/RJIRIoRCnVHzQOpiPeqIphldZ5hCdV/Ljko0hY
         cFUzTkVQQp6m2sR/Dg9Dz/wKBnzg7uBvTjTz00somktsBnDgh0gUg1gMq+MmCsoRmnNW
         ZoI2tgWEcTnTexJfz+eslKioXQuoXTc5p4BZGx0m/MvgtbbuqMDylzVWwfUxNMMRTXNn
         L7xqDYQwhuYvqy4ZUJN5G3JiEKpE5hb5V+UpkKKid2NPV4Fq26Zygyt54JdqzKk9Az1o
         1H+A==
X-Gm-Message-State: AJIora8mRv2014vzVpoDsBWEYvpFVVumRr0RW68ExyTs6H9l4fL9/i4k
        e64aEgfOAxN1SeiMt9uGJUeT9lljBhgtUc6v7dAKkJ0HsWOeaolvVQ9dqMlbibOSJ1MspeemzYt
        V8GBqMSa1DA0lnjQ=
X-Received: by 2002:a05:620a:cda:b0:6a6:8e47:8901 with SMTP id b26-20020a05620a0cda00b006a68e478901mr5374002qkj.231.1655423867764;
        Thu, 16 Jun 2022 16:57:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKFBKAdCVLRozp6H6gGaFai1//QuOu9bZOZ755Dn1alHCnoSH5b7rSl+5NemYFBmiRk94NAw==
X-Received: by 2002:a05:620a:cda:b0:6a6:8e47:8901 with SMTP id b26-20020a05620a0cda00b006a68e478901mr5373997qkj.231.1655423867562;
        Thu, 16 Jun 2022 16:57:47 -0700 (PDT)
Received: from localhost.localdomain (cpe-66-65-49-54.nyc.res.rr.com. [66.65.49.54])
        by smtp.gmail.com with ESMTPSA id t9-20020ac85889000000b00304e29c9a6asm3108132qta.91.2022.06.16.16.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 16:57:47 -0700 (PDT)
From:   HighW4y2H3ll <huzh@nyu.edu>
To:     netdev@vger.kernel.org
Cc:     HighW4y2H3ll <huzh@nyu.edu>
Subject: [PATCH] Fix buffer overflow in hinic_devlink.c:hinic_flash_fw
Date:   Thu, 16 Jun 2022 19:57:43 -0400
Message-Id: <20220616235743.36564-1-huzh@nyu.edu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: W1XYC_fmNNSXHqGQUCt59_nFX_E1JFX1
X-Proofpoint-GUID: W1XYC_fmNNSXHqGQUCt59_nFX_E1JFX1
X-Orig-IP: 209.85.219.69
X-Proofpoint-Spam-Details: rule=outbound_bp_notspam policy=outbound_bp score=0 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=802 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206160097
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 drivers/net/ethernet/huawei/hinic/hinic_port.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index c9ae3d4dc547..4a50e75a2424 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 
 #include "hinic_dev.h"
+#include "hinic_devlink.h"
 
 #define HINIC_RSS_KEY_SIZE	40
 #define HINIC_RSS_INDIR_SIZE	256
@@ -751,7 +752,7 @@ struct hinic_cmd_update_fw {
 	u32 setion_total_len;
 	u32 fw_section_version;
 	u32 section_offset;
-	u32 data[384];
+	u32 data[MAX_FW_FRAGMENT_LEN];
 };
 
 int hinic_port_add_mac(struct hinic_dev *nic_dev, const u8 *addr,
-- 
2.35.1

