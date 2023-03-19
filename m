Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F32D6C022E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjCSNz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCSNz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E67B761
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 06:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679234077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SE+hbc2PpdOm6jFmUnfn7gxJd8fzcxI50vFrTMNLyGw=;
        b=hCMHkqzGmIxg0gcAXnKqWvE5oIj3uvG3Jz/8U+oiNxs7KcCbTmqrp44hGXT2gLPNCyvIew
        EetIAmMeMPYxOap5qdYUa4YwR5aDR3b7eyTzIL3WlKt67vLfV2ZkV3LYdt5cx3SI+319Dy
        kQSV/OyVxKGbHUxub+RpQs90C2U4aJU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-LjRU7Ld-NYyNFi_mWBG3-g-1; Sun, 19 Mar 2023 09:54:35 -0400
X-MC-Unique: LjRU7Ld-NYyNFi_mWBG3-g-1
Received: by mail-qt1-f200.google.com with SMTP id t11-20020a05622a180b00b003dd4050f489so2068745qtc.18
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 06:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679234075;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SE+hbc2PpdOm6jFmUnfn7gxJd8fzcxI50vFrTMNLyGw=;
        b=haNwpoAgDYP8jmedUjhKPv8KzRZZe5quF2pDL7xDIXD5zpNSFabDmvwKHCINiVzYEP
         w/66J1BQdC+dNc1vsl70QJSA5/SlaPbwiK+8rCMVRU/TVFP2TX9QotAEO5rsJuqOgtNb
         IZelx4CkgIJH6H5VvL/LOHkzeKfAonaHFQp7bS9vvwcNV+2MUYY2GSenxqz+9jG7Yopw
         rp8KLSYuhQrXmzxWIZHsQMupg7a2l1pR4Q6HEnTykCDyc1eqvxa2hVOKdMeQ6ALGkGxs
         Jz1HmCSF756Hc5otlbVCOX6dlOJ5VSnsRfpzJKpp5X3p5qaL0zFvZ2UwaTxfW5ydQoGm
         8Qxg==
X-Gm-Message-State: AO0yUKVH0sJvDw4QK36GAmdAdzoNnzVgax65zXdXUJNf1DHzbON45R9Q
        VnKTcIbUshq953nFeXm3gQilPgkcJxMBsLzqnlJZAup46sxIT09uGjJ3BKV8HIyboPbJBOYkEgt
        BVvoJmfLY64CHrNEr
X-Received: by 2002:a05:622a:1387:b0:3bf:daae:7ee6 with SMTP id o7-20020a05622a138700b003bfdaae7ee6mr22103387qtk.18.1679234075268;
        Sun, 19 Mar 2023 06:54:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set/SUf1dS9D3NGgKWgB9272dqTQaCIgVClcOcHUMHiPQbfT/rPxkVqzfjAoOoL29N2AJV31JPQ==
X-Received: by 2002:a05:622a:1387:b0:3bf:daae:7ee6 with SMTP id o7-20020a05622a138700b003bfdaae7ee6mr22103366qtk.18.1679234075026;
        Sun, 19 Mar 2023 06:54:35 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x26-20020ac86b5a000000b003bfa2c512e6sm4859344qts.20.2023.03.19.06.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 06:54:34 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     stas.yakovlev@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ipw2x00: remove unused _ipw_read16 function
Date:   Sun, 19 Mar 2023 09:54:18 -0400
Message-Id: <20230319135418.1703380-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/wireless/intel/ipw2x00/ipw2200.c:381:19: error:
  unused function '_ipw_read16' [-Werror,-Wunused-function]
static inline u16 _ipw_read16(struct ipw_priv *ipw, unsigned long ofs)
                  ^
This function and its wrapping marco are not used, so remove them.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index b91b1a2d0be7..dfe0f74369e6 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -377,19 +377,6 @@ static inline u8 _ipw_read8(struct ipw_priv *ipw, unsigned long ofs)
 	_ipw_read8(ipw, ofs); \
 })
 
-/* 16-bit direct read (low 4K) */
-static inline u16 _ipw_read16(struct ipw_priv *ipw, unsigned long ofs)
-{
-	return readw(ipw->hw_base + ofs);
-}
-
-/* alias to 16-bit direct read (low 4K of SRAM/regs), with debug wrapper */
-#define ipw_read16(ipw, ofs) ({ \
-	IPW_DEBUG_IO("%s %d: read_direct16(0x%08X)\n", __FILE__, __LINE__, \
-			(u32)(ofs)); \
-	_ipw_read16(ipw, ofs); \
-})
-
 /* 32-bit direct read (low 4K) */
 static inline u32 _ipw_read32(struct ipw_priv *ipw, unsigned long ofs)
 {
-- 
2.27.0

