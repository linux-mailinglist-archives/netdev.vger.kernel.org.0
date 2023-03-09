Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A736B2C3A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCIRoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCIRoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:44:13 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A097A6591;
        Thu,  9 Mar 2023 09:44:10 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id f18so3326288lfa.3;
        Thu, 09 Mar 2023 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678383849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1XQk2zEiV+dJ+pQWsXM/szRvf3lCRM8FE84GMsL/aVY=;
        b=CXbIn7ashUb6ON6IfSbY7/ivlL+O/FblWeeJz85sQhf0LACl7RGCkPf9/twaXPOl+N
         +haJpqrpy3p0njsJbRPwGMiQ2TU2ymk6BYlI2OT11yLoEDP1y0C2hIBP7kG3G+0Ruwy9
         OlUWsDEfAOR8qU2Su1iEyTKB5MWo+Kx3+4KAB2vg9rbs1iTrqe5AYxOiPGnKwEBPx5wT
         JwK+/OV7CCBpQyHrF/6J7SSJvzQfDk43pI8vGLfS46FT3Jwz+ty+FbHx2CyoOLTAjTnw
         K3gKhNk5nBv88d85yIWoDU4k5VNJTe9u+XN6YQ3ho+M+dwHt7CrHOGxnQlGn+R9Hg0Vo
         E2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678383849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XQk2zEiV+dJ+pQWsXM/szRvf3lCRM8FE84GMsL/aVY=;
        b=A/+QLsbHyjQ04IijC7SqA0mrLPjrqT2Z0e8C2VW3r+PXT5o4ir/AjPuvoMgP4Jy4Qp
         oNKzXcEZXDUqmxX1EGk/0HMF3fQgiJYubIQIc8xgcHf2JziLuTKA/6dZVjj6kqUgNdw9
         OP8uXFp80H6tlHP7TJvBJ9jQI/Oeb4ZcGduFpCwlBCpJnlvsmhSkPkrg3pWC62lmOjWQ
         tbabLCdKe6OjZhyIygkwcnI4cTDgU78IVUmimox4nG3z7R/1s3/tFBr711YDlISe20Hi
         d7aZX6EeyG28lmi4NfEpSjmmYEUEQHO9ZjFmD7H2kC7lxvEiMDnfoiW0B9EZunzswYEf
         m6vg==
X-Gm-Message-State: AO0yUKU9kORRH3F5GssxWQYCIb7LYPuEg2Fg/+FZ1LjArZTPSSdktBrJ
        y/CFg7r20qSb6tKYvakVGZM=
X-Google-Smtp-Source: AK7set/4Xvqs/R0Z5NIIED+QrfKNsaa6Kj7Dfd8EDvWTohliwgsPiz5WBbSMsoenbJfX/j7exD1iwQ==
X-Received: by 2002:ac2:4255:0:b0:4cb:2aa:9e58 with SMTP id m21-20020ac24255000000b004cb02aa9e58mr6564361lfl.13.1678383848793;
        Thu, 09 Mar 2023 09:44:08 -0800 (PST)
Received: from mkor.. (89-109-45-204.dynamic.mts-nn.ru. [89.109.45.204])
        by smtp.gmail.com with ESMTPSA id y27-20020ac255bb000000b004b59067142bsm2718619lfg.8.2023.03.09.09.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 09:44:08 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH next-next] bnxt: avoid overflow in bnxt_get_nvram_directory()
Date:   Thu,  9 Mar 2023 20:43:47 +0300
Message-Id: <20230309174347.3515-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of an arithmetic expression is subject
of possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---

 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ec573127b707..696f32dfe41f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2862,7 +2862,7 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc)
 		return rc;
 
-	buflen = dir_entries * entry_length;
+	buflen = mul_u32_u32(dir_entries, entry_length);
 	buf = hwrm_req_dma_slice(bp, req, buflen, &dma_handle);
 	if (!buf) {
 		hwrm_req_drop(bp, req);
-- 
2.37.2

