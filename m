Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C21A5BB58B
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 04:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIQC00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 22:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQC0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 22:26:25 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AFABB039;
        Fri, 16 Sep 2022 19:26:24 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j12so22887675pfi.11;
        Fri, 16 Sep 2022 19:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=0610mV5Qn/QIQXXC4A7q9FldcmuQAoRAJWarDr8WD84=;
        b=O4Pf/NaNg0IcqL2uFHUvIynQEvm5ksnM2n8Yp6scIFZmK200mKV3+hwGJtVhyFZWQ8
         Iy6WF6iNpNs31xs7C5BKXg5COoBD4uSfAURYz+WfG4sWklQA3Qi5Rpi9pXhQUi6TKg7P
         0YltvIiRFDJF4YgRunYGFKd/p5uPpKfxKJ2VS5y5J8VmFLoXSxjiOMfE8OraHN4ZfJG2
         qb+OeOv8QnCMU3/C+R6hwUneE2N3uEl6qtVZewjj5Ng5dmdcUNcJGS4gwkiLPRLDC5t9
         n9/OoXFrhiCOZsgAFXpQzWvmuCwLt4PB36P1oIxpzC9JKUfbKP1Y+tqpdzf4whtdfz2X
         GFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=0610mV5Qn/QIQXXC4A7q9FldcmuQAoRAJWarDr8WD84=;
        b=CHBRbX4byr1nf7vtnjXIj8sNSN2ltXqA1rNCbVlkPBCPM7HfLixv3GVUhZivF12xgc
         5NNTKQjV0i1Vp/jR1tGkxgbhgLOrkUTVmqbG9BQApI1jwLnG7UwMmGtQojSarxlao7zV
         SoINqU92rbMgezJxlF+M6vZFdvfFI3F3XCBwvC3syMaraqiAcgMBNnn8xvp0SSheDHsX
         d5CoP80gcUcpGRCXOcNbzlafZSc2bgSJdmX6dsXuC0WOofLZ+lgiwXTcGdsQZ7OAqy5g
         XOvdeGLhpjRNBgUV0w5nLS7I2MA+Zm6AjT4u67nF6UYCkJpG+oFaKSfuOpdLJMayzYQ/
         LD8g==
X-Gm-Message-State: ACrzQf3jkbs795wiOs0KYfPfoxhuZ9vIhkqQQ+3kabGGU8vMvQKGdmgq
        IMre1zIw67e4rq9Y86GNH5/Lo87sT7o6vg==
X-Google-Smtp-Source: AMsMyM57N8A8pRoIvuk65PYWwG/CNYZ5EIO5HZnrdSDxU6Rs+lvddP1Eb1ZzHMV6h0YqgS9jjkz4rA==
X-Received: by 2002:a63:5451:0:b0:438:c2d1:15c3 with SMTP id e17-20020a635451000000b00438c2d115c3mr6884967pgm.207.1663381583798;
        Fri, 16 Sep 2022 19:26:23 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id bb7-20020a170902bc8700b001755ac7dd0asm15417138plb.290.2022.09.16.19.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 19:26:23 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] net/ethtool/tunnels: check the return value of nla_nest_start()
Date:   Fri, 16 Sep 2022 19:26:02 -0700
Message-Id: <20220917022602.3843619-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of nla_nest_start(), which could be NULL on
error.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/ethtool/tunnels.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index efde33536687..90974b625cf6 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -136,6 +136,8 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 			goto err_cancel_table;
 
 		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+		if (!entry)
+			return -EMSGSIZE;
 
 		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
 				 htons(IANA_VXLAN_UDP_PORT)) ||
-- 
2.25.1

