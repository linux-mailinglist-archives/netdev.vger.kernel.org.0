Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B24526965
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383358AbiEMSeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383350AbiEMSeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DCC5FF36
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c11so8717190plg.13
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lrd0QdmWCuE5cUzTbZW3dR17bFYo49SZzd0aI9yNq04=;
        b=nOeMqyzWh6c01Kdaib0vo7s1aPSEKOn3c8Y391Pll2Ets24ahre9cMnmpqgDUdoOeq
         0bZLJ04xErE6FEbTLCnnbFrHLZZKrwwb0dP0YTojENITuC1GbmJIelI2p4AnloE8lNHR
         mx5UzlhnXuUgQDUqrCUHDRr6xW72qAF72TJx4P5LOwBpK8hgcWs/3u/yP9Fd8GXwUm2I
         JIVQH+Y8YbV20dn4LQ8+ZDFGO/AHRrPVIJ7hWMO7IhTV87IYZTe2arFar+u4YudO0XUF
         I4/gghB/zf8qFLZLKTr5PMMpLI8uHGbpG5sFipOACQHW8/kN5sF0bjdvfx0WgCt7JBvv
         jdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lrd0QdmWCuE5cUzTbZW3dR17bFYo49SZzd0aI9yNq04=;
        b=7M+I33ZD/HGvv93hh4ZaZYhgHxZR4HP3MuH/tcy1J6zRPGVupq2vkt8AWEiuCGvqIm
         mtMy/0chWUrCvkZFbSe1Qb57QfVAytzYAMN40UqCLZNZFpNjHI99yXpmLY9MfQRg0hDy
         dekex2hJuRCcnEEcLHWZxxSLVFl7SaS1eUX0piyE+hpDjCF24XtNOZ3Twgl45S7mNnZY
         hbR7PqktCq6jnNPc0ljo/xwlKBquNyX0nVUqPL5ml6Q73SKfjXnyYjSIRSGOxzsdy5Ag
         IJ0ALEwRux3Qh689Mc7E1A7iVEYZkzk1f+4aS+RMToPdvkyJ9422zfnqlojMWiLzQVFX
         fd9g==
X-Gm-Message-State: AOAM531VsfNzQXZTNu8Rx9qljsAjqrvEe9cZ1eSwSRk57sZePAT7Wix4
        rRZ8J36i00vF4kyxuXCkZDY=
X-Google-Smtp-Source: ABdhPJz9q3HW5rfHZci/vhnqDTQ2nT5KAbyF0ns7Cg9hqXBa3wyRXYgwcPMOGXRlO1Co9WD/mKMypQ==
X-Received: by 2002:a17:902:f710:b0:15f:165f:b50b with SMTP id h16-20020a170902f71000b0015f165fb50bmr6309429plo.158.1652466862721;
        Fri, 13 May 2022 11:34:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 05/13] ipv6: add struct hop_jumbo_hdr definition
Date:   Fri, 13 May 2022 11:34:00 -0700
Message-Id: <20220513183408.686447-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Following patches will need to add and remove local IPv6 jumbogram
options to enable BIG TCP.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 include/net/ipv6.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..63d019953c47ea03d3b723a58c25e83c249489a9 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -151,6 +151,17 @@ struct frag_hdr {
 	__be32	identification;
 };
 
+/*
+ * Jumbo payload option, as described in RFC 2675 2.
+ */
+struct hop_jumbo_hdr {
+	u8	nexthdr;
+	u8	hdrlen;
+	u8	tlv_type;	/* IPV6_TLV_JUMBO, 0xC2 */
+	u8	tlv_len;	/* 4 */
+	__be32	jumbo_payload_len;
+};
+
 #define	IP6_MF		0x0001
 #define	IP6_OFFSET	0xFFF8
 
-- 
2.36.0.550.gb090851708-goog

