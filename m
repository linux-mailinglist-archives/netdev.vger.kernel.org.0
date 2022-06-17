Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4CF54F06A
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 07:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380044AbiFQFGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 01:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiFQFGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 01:06:00 -0400
Received: from mx0b-00256a01.pphosted.com (mx0b-00256a01.pphosted.com [67.231.153.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94541666BE
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 22:05:59 -0700 (PDT)
Received: from pps.filterd (m0119691.ppops.net [127.0.0.1])
        by mx0b-00256a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0tORx037581
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyu.edu; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding;
 s=20180315; bh=3kogNl48Igq0sjUSHZ2cHxkX5GFxsC19iw2HB9fEgUg=;
 b=OY/juXmnpHNv/r4NdIN0U6Grcc/7h/Qcne4sUSimbvAbcsruYLErq9FUEdyAP6xlzouK
 QO23OZ2l7daDTbZupxoQctZ8f81pLXGCGAeCSGU/QebV72S/WLAs5+CYUbIaG4atng1W
 YGdLQ1KgTrpnePJHrscHrUOqBMzH9PSWpl8S8PxeYN9dkCjjX0yUgUZ2n4mPr60v+i6+
 7GUnoKDypBEbR720z1cvgikW03dIx0M1fhXObryfN/YCTGDYuhb4/NcsSvSyXJJjFScF
 Rfe5YSgjMHwPAIrBjoqMdAeOE8wuoi9ZbWPd9kOFyznEi0DN6eh6cq6TIw/Y+0Kv3kL6 1A== 
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        by mx0b-00256a01.pphosted.com (PPS) with ESMTPS id 3grbkmecmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:05:58 -0400
Received: by mail-qk1-f200.google.com with SMTP id w22-20020a05620a445600b006a6c18678f2so3948871qkp.4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 22:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3kogNl48Igq0sjUSHZ2cHxkX5GFxsC19iw2HB9fEgUg=;
        b=GvofjgQXp6Mr29JEIXcxZ5RuIXB88qiq1jeRhPmSnH3ZJxG6ayCjQqaYthYEzDT+5e
         2kmbood2FHGUxeqQen9iFwGNpU93XE10BBhBRzE7MUcTbW9jH6Q6bDoVYZh5JD/ZnJ6r
         xqYL17ruSP2U6roJGw0ytxaTta/2776YBEZntpKl8/y9WsvVPZzc5DBAkOHRBoIF2elc
         JeqinYmiEccK5zxPo2Ts7ZLm3tG4LRQAbr3HULAn2oHz0WgrqzQJD16uG03M0L8S2LTP
         6LX8Sb0RSv0zKRWjhVNCcUON4CA/0PvVgZirj63CEpRCPfcz0kF2AUvHRCez4fSAddWD
         vu0Q==
X-Gm-Message-State: AJIora9paN9SOt1uEFHW8BvRyDO+loTBLvLDh3FiEam9ECE1IYK8V+47
        OfB8WR2IXXBe2QJsp0hhq3qNLvqhK0n77lB/8iKn3Je3MLgaRYrGqkNney20f5SlAIZdo+5RlLw
        pzF8cmaMml8JrSYI=
X-Received: by 2002:a05:6214:d0f:b0:46b:af12:e20b with SMTP id 15-20020a0562140d0f00b0046baf12e20bmr7039992qvh.104.1655442358173;
        Thu, 16 Jun 2022 22:05:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sg8jFqi+Qebx+it8uDmKa1ceXVEsfXzuiBZhdtgpT5p68GMEjUwmDg3+v/NFZJQvLREOm+ZA==
X-Received: by 2002:a05:6214:d0f:b0:46b:af12:e20b with SMTP id 15-20020a0562140d0f00b0046baf12e20bmr7039985qvh.104.1655442357941;
        Thu, 16 Jun 2022 22:05:57 -0700 (PDT)
Received: from localhost.localdomain (cpe-66-65-49-54.nyc.res.rr.com. [66.65.49.54])
        by smtp.gmail.com with ESMTPSA id h22-20020ac85856000000b00304e95ec0fbsm3556530qth.89.2022.06.16.22.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 22:05:57 -0700 (PDT)
From:   HighW4y2H3ll <huzh@nyu.edu>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     HighW4y2H3ll <huzh@nyu.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Fix buffer overflow in hinic_devlink.c:hinic_flash_fw
Date:   Fri, 17 Jun 2022 01:01:02 -0400
Message-Id: <20220617050101.37620-1-huzh@nyu.edu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: wFFx8BkhdpsW1saJu2SgzxfnFCVsC8HS
X-Proofpoint-ORIG-GUID: wFFx8BkhdpsW1saJu2SgzxfnFCVsC8HS
X-Orig-IP: 209.85.222.200
X-Proofpoint-Spam-Details: rule=outbound_bp_notspam policy=outbound_bp score=0 mlxscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 clxscore=1015
 mlxlogscore=917 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206170023
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: zhenghao hu <huzh@nyu.edu>
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

