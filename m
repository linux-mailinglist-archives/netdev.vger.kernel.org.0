Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA360AE35
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiJXOwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 10:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiJXOwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 10:52:16 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645A9356E2;
        Mon, 24 Oct 2022 06:29:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v11so6587121wmd.1;
        Mon, 24 Oct 2022 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xC70jAVieGTzMnfL7IzZSmpj/LnjOjc/7R5G039BdH4=;
        b=cxwnRuee9VdpxGyeEmF8k/HuqMe2jOY2jNiCnas50PQCqNiw1TVLQwe1WX0v/MXQfo
         GR5sQ0qfyKRsqghWwvF8Ly/JgwWsYP8dishLvgkaS9S986ocrhWh7uxI9ReKikKJmtAv
         SRbJ9L7b2EmcTxOQ3dsCQk6rOSECeS4oGtbzvh74BY0KwYAh2NsJoO9km72lQ6DFkgFe
         +8XkcNlii2xPTTxe9ni3ooxJeYRZE1Ez4YIyhJZoqE9CZm24C7IURcwz26RVQIyluF0U
         kMibKNSnkn7u9VqdCOqq4ye/dBo3Iu/Sz4tbZA9rbJk1kRv5GAr/al/5vM0c2z7MNGcD
         WJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xC70jAVieGTzMnfL7IzZSmpj/LnjOjc/7R5G039BdH4=;
        b=IWH6jsJ6zjM2g/WQfZoq8fphvR91YgJiIbPQugS76zy9CYwIcMPGQ1sSoY8h4PFbla
         afg9gKDENnp56XnbA294p5pu5SxcUfZO9Wi8pOimaswU2sfKWdj3DxxxFkuorHg1wOHr
         4TxF00lMDkYPnSQJaG0aw/fqDDSswjjFep22fqOSxpEPmXjacb/Dnmj57R74EvFUyibL
         OEEmas2I8qImm775j+AZbn1gKZ7U1i8Cbr9z2ce/la7c8PcQGBWtBQ2zb2qS00+MjiXc
         GO0ZrkiNTPozCCVJwaX19pVoH3X3i8EdS81X83LLFYrdSO3BFCID34vqPFq4TRod+zc+
         UHOQ==
X-Gm-Message-State: ACrzQf0BDwwH6OqbSrTVfg9YKzgIpIpclvBP4QrCM8bQAXfdLKwVY1dP
        sAz2bCXpeDPkP8TtyaDbIUozj1cysLtWQQ==
X-Google-Smtp-Source: AMsMyM6DcAgzKC/cIzaK2ZMOgz1RyVjsweCP0E7jveVudP7Itkbi3YwYgpS97bkg0E0rGV4eu1qfNg==
X-Received: by 2002:a05:600c:4e06:b0:3c6:ce02:ece4 with SMTP id b6-20020a05600c4e0600b003c6ce02ece4mr21217981wmq.58.1666616393256;
        Mon, 24 Oct 2022 05:59:53 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id h42-20020a05600c49aa00b003a5537bb2besm10734058wmp.25.2022.10.24.05.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:59:52 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bna: remove variable num_entries
Date:   Mon, 24 Oct 2022 13:59:51 +0100
Message-Id: <20221024125951.2155434-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable num_entries is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/brocade/bna/bfa_msgq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bfa_msgq.c b/drivers/net/ethernet/brocade/bna/bfa_msgq.c
index 47125f419530..fa40d5ec6f1c 100644
--- a/drivers/net/ethernet/brocade/bna/bfa_msgq.c
+++ b/drivers/net/ethernet/brocade/bna/bfa_msgq.c
@@ -202,7 +202,6 @@ static void
 __cmd_copy(struct bfa_msgq_cmdq *cmdq, struct bfa_msgq_cmd_entry *cmd)
 {
 	size_t len = cmd->msg_size;
-	int num_entries = 0;
 	size_t to_copy;
 	u8 *src, *dst;
 
@@ -219,7 +218,6 @@ __cmd_copy(struct bfa_msgq_cmdq *cmdq, struct bfa_msgq_cmd_entry *cmd)
 		BFA_MSGQ_INDX_ADD(cmdq->producer_index, 1, cmdq->depth);
 		dst = (u8 *)cmdq->addr.kva;
 		dst += (cmdq->producer_index * BFI_MSGQ_CMD_ENTRY_SIZE);
-		num_entries++;
 	}
 
 }
-- 
2.37.3

