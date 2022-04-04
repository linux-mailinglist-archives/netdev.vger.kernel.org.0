Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61F14F136A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358661AbiDDK4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358571AbiDDK4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:56:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD402C131;
        Mon,  4 Apr 2022 03:54:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qh7so9025670ejb.11;
        Mon, 04 Apr 2022 03:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rS2vrUQCqgIxoLaF1HFbbKKb3g/Rll3Hg3bNlGXWWFU=;
        b=ZAx3AW9FCKPXQ+1FGU6mGDUl1IVpQ4wMwtwj6DSs2ypTFDomv2BzAG6MBG/NPa6TtU
         DmoF7im1yJipBSKOiduBGIq0o1/KoWntvkA7iw32NZBl9+PvWnTQusrJR//uhPAzRUMV
         FQ87WHbcQfvTVBjuaNiwTZvhzrpkXV9U7zNuvWAXppDNRh5hIsWlanX0Gq9TlQH0vYhx
         o91pOje2KRe5ez/u2e44jjsEL2+PX0q9+qvJzA3z0zr/Ph2Uqvlaf3QpKhoSueGn/6C8
         dQlqZTZ3zTwaPaWKjPaACF1Dk4Q5zgnaQEfs5W8ibPsXfIN62CATcO9emI3VftyTBlmx
         OPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rS2vrUQCqgIxoLaF1HFbbKKb3g/Rll3Hg3bNlGXWWFU=;
        b=0/p8W216QqplCNWTzUk6UENGUb26S+bkGvcrwBmrwtArt+hnO4FFs7R7Zmtze9GwAr
         WdqapkS9LJ5L0viJzCmro+ZbJ8CXI4+B6M4QJHrdG+Yr0ZkbQ1Q+eV8cBXLvsR26bEI5
         dE8FUazcfA9sfuSeDcaoKcqVkAXlS/IUsspyFFPfqDXzRgIhCpyA2kxcVoiVOeCciFG1
         vbqY7o+eKBXSYsclMMA1B1ItSY8p+F02FF0NDY6BQgq+1jK89g7xHoW/l69ipIwWDo4M
         HXlysg0lbv7e9zPe+kCj0I8eGo+e0iVWefWYlAx81E9ZqQLAcsb8wAn2oQd/NNpH5bRk
         HQTQ==
X-Gm-Message-State: AOAM530hyuqr5uPQqHm1SP92HLdK7/KkaFuFrXup+xEG/KTtiOJ56J+W
        nrJMt3sCkZKcXMT8AqlmDzQ=
X-Google-Smtp-Source: ABdhPJy6OPm3Dpjp6lG1jC2bFmA2drnES4LgmLg6gDlTOw3cssB9sithUubMN20eC2fLccxnrfb0Ew==
X-Received: by 2002:a17:907:8687:b0:6da:824e:c8b8 with SMTP id qa7-20020a170907868700b006da824ec8b8mr10315919ejc.428.1649069656910;
        Mon, 04 Apr 2022 03:54:16 -0700 (PDT)
Received: from localhost.localdomain (ip5f5abb55.dynamic.kabel-deutschland.de. [95.90.187.85])
        by smtp.gmail.com with ESMTPSA id qa30-20020a170907869e00b006df9ff41154sm4273210ejc.141.2022.04.04.03.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 03:54:16 -0700 (PDT)
From:   Michael Straube <straube.linux@gmail.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH] ath11k: do not return random value
Date:   Mon,  4 Apr 2022 12:53:24 +0200
Message-Id: <20220404105324.13810-1-straube.linux@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ath11k_qmi_assign_target_mem_chunk() returns a random value
if of_parse_phandle() fails because the return variable ret is not
initialized before calling of_parse_phandle(). Return -EINVAL to avoid
possibly returning 0, which would be wrong here.

Issue found by smatch.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 65d3c6ba35ae..81b2304b1fde 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1932,7 +1932,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 			if (!hremote_node) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,
 					   "qmi fail to get hremote_node\n");
-				return ret;
+				return -EINVAL;
 			}
 
 			ret = of_address_to_resource(hremote_node, 0, &res);
-- 
2.35.1

