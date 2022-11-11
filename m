Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC18625627
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiKKJFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKKJEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:04:54 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41939E0FF;
        Fri, 11 Nov 2022 01:04:37 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so7232417pjc.3;
        Fri, 11 Nov 2022 01:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fRlLUlsxf2yRq+biVPsvrOIU+jGYg4EFs8dRHlFQCiM=;
        b=eoinuhlfGT04Lfrw+Bt3sB5LfN/Nlj6nZb2kr3L4Xcan1rVgzTV5prYN7dTcoOZwIY
         X6MyJarwFIZsyyl+EkUoD3lOtx0sE27N60MJjdYdrgHBxnlAmzP46+XNReFWoYEtPT4/
         PK+UvsWp3ya4v2vdPri+OzPJGl6u7o7ZIUAqdTEsFfXX7hAmzdRz5kMZZ0E1LoZRsYHk
         L8hxs7Ze1E4DAFFZrla1hIRbFEXs/GOP9wuLfZ1iAOtDVDgc4eaHCgI0umXOtxCQZ8vJ
         pQsG2AvO0IY+XhfdSE4uvFMHdAqOZ7WA3rwWdNeCS3R8PZzI9SyKDsusoBynZKK5DnpY
         LG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRlLUlsxf2yRq+biVPsvrOIU+jGYg4EFs8dRHlFQCiM=;
        b=qRIQOxAaYR7maplTFqJxIAPBm0D4ekRHudJ0E5hYZA2uhWDMyhtFkRE5RBoqn2ntvJ
         0ewjnx21gS3644NXRhuZrJEpgPWQNtlsBBB8r1HaPN/TAh7UW7YE2SfST29yQSdlcKin
         FsO5eMTfe1adMnTTyF/diRsjy/xiugBF572LzaWfmby0W+fzm8qUz5jFsRI53HWbJeIu
         Ls46RfhNYsVKxEm9JxsCQ7tApwswcViEpqwqrD+LnhrXRADh+0vj38V6RJO05U6KwP29
         NO6KtDPniW2eJNETCBFW44w2qr1Cj/ChUZNajTeAgHgqEYDUBS7dbs8xurt6tE0m+rL0
         gkjQ==
X-Gm-Message-State: ANoB5pn9aXbC2yzLwFQ/L0l56TOelU3C7SSy2PIOYjqQ1k5EhPtoE/PZ
        lxiWXvLG9NiJDBS+1qaivgg=
X-Google-Smtp-Source: AA0mqf4GISLugFZ92A2NGOzco/Iv/0Wz0ddZVYZ0XdN90ymQLWDb63J5yN3skgDjx389luc9UfoFgg==
X-Received: by 2002:a17:902:7c0c:b0:188:5681:4dc7 with SMTP id x12-20020a1709027c0c00b0018856814dc7mr1387819pll.97.1668157476750;
        Fri, 11 Nov 2022 01:04:36 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e17-20020a17090301d100b00177f25f8ab3sm1178005plh.89.2022.11.11.01.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 01:04:36 -0800 (PST)
From:   xu.xin.sc@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     edumazet@google.com, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu xin <xu.xin16@zte.com.cn>
Subject: [PATCH linux-next] ipasdv4/tcp_ipv4: remove redundant assignment
Date:   Fri, 11 Nov 2022 09:04:20 +0000
Message-Id: <20221111090419.494633-1-xu.xin16@zte.com.cn>
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

From: xu xin <xu.xin16@zte.com.cn>

The value of 'st->state' has been verified as "TCP_SEQ_STATE_LISTENING",
it's unnecessary to assign TCP_SEQ_STATE_LISTENING to it, so we can remove it.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 net/ipv4/tcp_ipv4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7a250ef9d1b7..0180f3cefa9c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2478,7 +2478,6 @@ static void *tcp_seek_last_pos(struct seq_file *seq)
 	case TCP_SEQ_STATE_LISTENING:
 		if (st->bucket > hinfo->lhash2_mask)
 			break;
-		st->state = TCP_SEQ_STATE_LISTENING;
 		rc = listening_get_first(seq);
 		while (offset-- && rc && bucket == st->bucket)
 			rc = listening_get_next(seq, rc);
-- 
2.25.1

