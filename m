Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA77C6C91D2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 01:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCZAS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 20:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjCZAS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 20:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D3EAF1A
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 17:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679789859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D61zQjRsLuXz/56PVuTWbWV80IKbwWyVMu0ddKqCreo=;
        b=O/UnIWP09eHEzjHZsD5vg/2g2uWNe1tIzX8GloL1yvlbDWX0McTeBmIR8WEww6LOyOB4UE
        9pyXW4JPOI6xRVehPpGJs0+6BTX4O/ZTMiRHibg3mef0HK+GH1d84/FfyfLgrORFuDQ4me
        4sqztHlu81QUrIc8mFiuXeZxN7teTX4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-UPmBzh5aMs2DI5UJVsxyKw-1; Sat, 25 Mar 2023 20:17:38 -0400
X-MC-Unique: UPmBzh5aMs2DI5UJVsxyKw-1
Received: by mail-qt1-f199.google.com with SMTP id x5-20020a05622a000500b003e259c363f9so3445682qtw.22
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 17:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679789858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D61zQjRsLuXz/56PVuTWbWV80IKbwWyVMu0ddKqCreo=;
        b=RaGTDgQHusRSXEs6mSCZJ5oPsS3PZm/KusRd319zcnmpK3lSF/u6nd8X6cM3xnRHgu
         WQfILhZHZF/OvJ3u6O3lACXbubOm6ctfmJsUr8fGcUWu8Fo8UBzMum/jniSUYQWFaPBl
         RynTdbxviEoQ5fMKtS4AA7Ub2aJhHuXALQcCciK6FdA5WnJznFysNTrWZPJU2TNcIeR3
         HycpNt50PMUqeJC2FQR6rzGJ8YeUHxk+0Mn/3wMUspMKj4x2fXSzZjM2G1smdiyyNZRL
         Khn+seEddzwOWk+LQdNKRkfF1sj9u6/Qpu9jh78+p7gZUU0vs51fsp3kREO5QTpqr3x3
         Z4YA==
X-Gm-Message-State: AAQBX9dolB/2VvfIx3DjcSHiVfIY87k6fibS6QOr+kCKs4tWuaD4lmLj
        F50w2BlUQBXXNVU0jQgalNS6e6WUPT6+15oTcLwTg59hgHpeGfmcFSdCP9WxisiV66SudODDtXG
        3fP2R6qEgcwbNrfoN
X-Received: by 2002:a05:6214:2506:b0:5a5:d286:c706 with SMTP id gf6-20020a056214250600b005a5d286c706mr15063798qvb.17.1679789857893;
        Sat, 25 Mar 2023 17:17:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZugfWYhwn2fNmL9rQUMhOV2wtNFMMLNcZ9o3qv7OoE+LRL/5md/0aJyAMSsIMeQNzQQ+l9MA==
X-Received: by 2002:a05:6214:2506:b0:5a5:d286:c706 with SMTP id gf6-20020a056214250600b005a5d286c706mr15063781qvb.17.1679789857620;
        Sat, 25 Mar 2023 17:17:37 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 204-20020a3708d5000000b007485a383921sm528719qki.116.2023.03.25.17.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 17:17:37 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] qed: remove unused num_ooo_add_to_peninsula variable
Date:   Sat, 25 Mar 2023 20:17:33 -0400
Message-Id: <20230326001733.1343274-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/ethernet/qlogic/qed/qed_ll2.c:649:6: error: variable
  'num_ooo_add_to_peninsula' set but not used [-Werror,-Wunused-but-set-variable]
        u32 num_ooo_add_to_peninsula = 0, cid;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index e5116a86cfbc..717a0b3f89bd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -646,13 +646,13 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 	struct qed_ll2_rx_queue *p_rx = &p_ll2_conn->rx_queue;
 	u16 packet_length = 0, parse_flags = 0, vlan = 0;
 	struct qed_ll2_rx_packet *p_pkt = NULL;
-	u32 num_ooo_add_to_peninsula = 0, cid;
 	union core_rx_cqe_union *cqe = NULL;
 	u16 cq_new_idx = 0, cq_old_idx = 0;
 	struct qed_ooo_buffer *p_buffer;
 	struct ooo_opaque *ooo_opq;
 	u8 placement_offset = 0;
 	u8 cqe_type;
+	u32 cid;
 
 	cq_new_idx = le16_to_cpu(*p_rx->p_fw_cons);
 	cq_old_idx = qed_chain_get_cons_idx(&p_rx->rcq_chain);
@@ -762,7 +762,6 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn *p_hwfn,
 						   cid, ooo_opq->ooo_isle);
 				break;
 			case TCP_EVENT_ADD_PEN:
-				num_ooo_add_to_peninsula++;
 				qed_ooo_put_ready_buffer(p_hwfn,
 							 p_hwfn->p_ooo_info,
 							 p_buffer, true);
-- 
2.27.0

