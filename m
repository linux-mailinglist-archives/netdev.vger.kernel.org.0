Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1B4EF287
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349300AbiDAOzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352557AbiDAOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417322B3D55;
        Fri,  1 Apr 2022 07:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F2BB82505;
        Fri,  1 Apr 2022 14:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00517C34112;
        Fri,  1 Apr 2022 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824060;
        bh=/9RyJR/Q5Gaje1DvMBdIgZsbMi+DILHwOCail3i1sDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P546oGTThBy1FZT9pgM8JvIo0/kFAsrBwNaud/xATp3psqtFF3vthaysd4sHuyUxT
         6SmT8eoh/WC6rYMLW1RFDN2jABa8obuGU8ZnIwU2heU7t6kxZkKWEgTIkESqgXKX1X
         JDs8eTMOj0u4fIZ7FVHgn9wePM1UVkfs/9hGGUYkaI0DQGDiLnCosVvDfdmPNZntl4
         ntlfETSrB74J+TngpVOE1LphDY3UoLzp9kTgkUwb9u/x19NSWdyicKejqtB/ogJnFc
         wgFQoElQhkpiOwwdeXfaQeLfVo3WlcUWa/3y4j7veHHnit++jFcI4vZNuLMKLsVG0G
         6Inss7jHeP84w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 71/98] Bluetooth: use memset avoid memory leaks
Date:   Fri,  1 Apr 2022 10:37:15 -0400
Message-Id: <20220401143742.1952163-71-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

[ Upstream commit d3715b2333e9a21692ba16ef8645eda584a9515d ]

Use memset to initialize structs to prevent memory leaks
in l2cap_ecred_connect

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 77ba68209dbd..c57a45df7a26 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1436,6 +1436,7 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
 
 	l2cap_ecred_init(chan, 0);
 
+	memset(&data, 0, sizeof(data));
 	data.pdu.req.psm     = chan->psm;
 	data.pdu.req.mtu     = cpu_to_le16(chan->imtu);
 	data.pdu.req.mps     = cpu_to_le16(chan->mps);
-- 
2.34.1

