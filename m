Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAAA505B00
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiDRPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343988AbiDRPaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:30:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D1B101CE;
        Mon, 18 Apr 2022 07:38:02 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u3so18811536wrg.3;
        Mon, 18 Apr 2022 07:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKMRKMm/sIBLOz8aCTIWcqn9AE+2Z7Npd4+53Q2MO/E=;
        b=ieQZ/xTHf2yNXsOs7niwKGoSi4ae0I778/KnW9pYGmAhm2aPLKP2UEzKhvf3YwgxPj
         MIoRHAAeBygRH+D7Z+uMGyRdb9wMvg28RrcCj8XKQPF2DwVRlR0H+97sznOSPHHsfYXx
         5lngNYsQLoSbqhKmMEFSm2YV4A7BTz97KUnvYp3wV+mpfZ7kuMMuQC3BiPWz6ZRbEDW+
         DRiGVRbj/pyUbuuDeoRPfpnsghFm1Vb8u4r1F6v3Gw00AoSy/MdFSbo/DhpFlSsfcfa2
         dxnJ4cVY3RhbBMAa7dED1fgVpU9j+o/+3aIk9dmtofQHGIR91dM45Hm5NNy1iwzhMxm6
         zseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKMRKMm/sIBLOz8aCTIWcqn9AE+2Z7Npd4+53Q2MO/E=;
        b=R5gb3DvdOlak4QJkEgxCmjILRumJWUo5/aU6R0k0f4iGg7ihZnaBL1y4MMMpkwYuW2
         j6BAMS4gwXo2eFikUyYDgIJj9w0xuvhRAqxr7DXciHE2T8HRUme4gcsy+l83mHBUlTSB
         D9sV1XeUb4dca2ZL7agQdLoNB7sIfgVmFNwkWzMZj6xdlE6Y8DTUwYFI10VzD+9CKf3f
         XO8E62ZdmOJ3ZzxO06RZSihNlvT6agCrIfS70GI/llML32lI16Isc7f6f7V0uSzm9jBj
         /icBpYRsl7IcyDro30VmicVpB8yG+rf0Sp8Y6zTBFRQiSulLFOiuBV9jmRpyh03e1tmm
         n+vg==
X-Gm-Message-State: AOAM533gc2bmFyBz8GjI6kkoArRi1TwBib9g0t4dzhQ6UvPEQ21LBF5B
        LAsYzoWgmCltwthYAW+ihgU=
X-Google-Smtp-Source: ABdhPJy8arQjfLhPXxOzk2MFna3FKyuUNwtRi1hY8KmnVvLTcbTFvag1qbahCt5byLneQWsqcxDedw==
X-Received: by 2002:a5d:6e0c:0:b0:1ef:7cbb:a5aa with SMTP id h12-20020a5d6e0c000000b001ef7cbba5aamr8326728wrz.5.1650292680782;
        Mon, 18 Apr 2022 07:38:00 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b00392910b276esm5419573wmq.9.2022.04.18.07.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 07:38:00 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Chris Lee <christopher.lee@cspi.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] myri10ge: remove redundant assignment to variable status
Date:   Mon, 18 Apr 2022 15:37:59 +0100
Message-Id: <20220418143759.85626-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable status is being assigned a value that is never read, it is
being re-assigned again later on. The assignment is redundant and can
be removed.

Cleans up clang scan build warning:
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:582:7: warning: Although
the value stored to 'status' is used in the enclosing expression, the
value is never actually read from 'status' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 21d2645885ce..fe5e77330f5f 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -579,7 +579,7 @@ static int myri10ge_load_hotplug_firmware(struct myri10ge_priv *mgp, u32 * size)
 	int status;
 	unsigned i;
 
-	if ((status = request_firmware(&fw, mgp->fw_name, dev)) < 0) {
+	if (request_firmware(&fw, mgp->fw_name, dev) < 0) {
 		dev_err(dev, "Unable to load %s firmware image via hotplug\n",
 			mgp->fw_name);
 		status = -EINVAL;
-- 
2.35.1

