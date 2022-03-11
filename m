Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFCD4D5803
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 03:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345596AbiCKCTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 21:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242459AbiCKCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 21:19:09 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5C4BD7E9;
        Thu, 10 Mar 2022 18:18:07 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id p9so10813424wra.12;
        Thu, 10 Mar 2022 18:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=PX/KGIdfGQHH5ldFS8iIB3LqUgO+QPeZQxewHTPzYMw=;
        b=hsd1qrW9yrTIvHK+FHlSXsG+017zFOyzmDU9b8XyJNgEZcteoosqx3ISzA2Qq92FSU
         33I9tXnX7IQhcMjB0zTX2CeErae1P7RY7imXXAvZOlayiLPmkzUW4Wn9Nnzk4FCDnsJC
         pHlJn4ndQYsXweP3TBCADkijSqu47vTxazCkXTypDrtlf0g3KNCCld+0A2oHL4fN1DHa
         ZVjsnqWz22BYsTSOl6HRdbm8Sc4VpYa3m9EF23WQqkaYNTaBOHd1sXJYCevdbMeYPIEx
         8lb7vXiGUMzc/h5R2egrwqpcQAW9TVquDHcnOkZS2VgMLMezAbLz5mGl0l+fUk5UzAzx
         dzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PX/KGIdfGQHH5ldFS8iIB3LqUgO+QPeZQxewHTPzYMw=;
        b=cxy9R9TlLHCbIHky+x1SmAeW8bUMidf3cmKXAMIiCw2UQBUOx+SJ431LNJlcBu00bF
         evbflzBneYCo4IOta1Ms+xCKoDcIKZfylkNytDcJPsIrWgMH+PW3Q90q4X+MqtT0JrA7
         7rt7B3TZyhx9+Or1yx+1p+p8ZNZ9g8d1vTGUvb1myL9wIv+pTP4Fcd6BV+HbnAXq2Jdv
         AF/fPOThtAB8pjHVNb00exlob/9cXMlMT2A0gQW4/i+ZxW6KcKwMrXyx6XVA8wTaEdq9
         /DlnWGMkSyNt4JkTUu7RJqXMrZSDZtgjxrpP/S3wkvKZBNuRybtLJFQ1gpxWOa22vxuB
         2ozQ==
X-Gm-Message-State: AOAM530e0aRgGyvLgpRLSN60AwArHE+4GxJG3cATyYnDdD9AM17HTzrd
        EBZtuRoHF6jcaqIF1wTnkMQ=
X-Google-Smtp-Source: ABdhPJwFnP9wVvB5oBMVjH/u+1R+8wTh2wU4wqIIyPZn07t+bJVt0Fw6fZRtDc2N81fQ4POxTgBhMw==
X-Received: by 2002:a05:6000:2a8:b0:203:7a50:5dfe with SMTP id l8-20020a05600002a800b002037a505dfemr5606437wry.260.1646965086031;
        Thu, 10 Mar 2022 18:18:06 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.47])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b00389cc36a3bfsm7945862wmp.6.2022.03.10.18.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 18:18:05 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        len.baker@gmx.com, gustavoars@kernel.org, shawn.guo@linaro.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] brcmfmac: check the return value of devm_kzalloc() in brcmf_of_probe()
Date:   Thu, 10 Mar 2022 18:17:51 -0800
Message-Id: <20220311021751.29958-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function devm_kzalloc() in brcmf_of_probe() can fail, so its return
value should be checked.

Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Add of_node_put() in error handling path.
  Thank Kalle for good advice.

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 513c7e6421b2..15eb96e288af 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -80,6 +80,10 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		/* get rid of '/' in the compatible string to be able to find the FW */
 		len = strlen(tmp) + 1;
 		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
+		if (!board_type) {
+			of_node_put(root);
+			return;
+		}
 		strscpy(board_type, tmp, len);
 		for (i = 0; i < board_type[i]; i++) {
 			if (board_type[i] == '/')
-- 
2.17.1

