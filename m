Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DDC520334
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbiEIRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239566AbiEIRIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD912D5711
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E9BB81811
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E17EC385AC;
        Mon,  9 May 2022 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652115855;
        bh=FbyO+N2IfsPVhFhXGjaNQ+lybRlH9gMMaTYHlTu/o6A=;
        h=From:To:Cc:Subject:Date:From;
        b=j/Dw8dZjTKFfVzir7ZnyIzowBfWYXlI0Ger9A7Avs9803QSlxmjVD8gOLAwPhDkcJ
         xBechrNSgzA0480VQVzol+WaQqG1xXp9bHbsLIQUcxO7Iuzq2eQcOkWm8X7RsmzeVL
         zKYVIvnns15UGUBy/nYYMoItAHD2ZddMYYM2mQWfGI6Vo9unhSqDfiZlgdxGxuNlYq
         zixw7D0ZLnDLIwwLdtCHxKdE7akqZbrsQnj2gYF8iKrdzKJb4IFvfDPgbRIdEcN84m
         +V1KnQDQAnFKT1CwTH0LolyPpSI4uldygTUMjXI63j/zdBg8tnQcR3KS6dEN5CoxhG
         gYXwr3zy0ScsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        asml.silence@gmail.com, Akira Yokosawa <akiyks@gmail.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH net-next] net: fix kdoc on __dev_queue_xmit()
Date:   Mon,  9 May 2022 10:04:12 -0700
Message-Id: <20220509170412.1069190-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()") exported
__dev_queue_xmit(), now it's being rendered in html docs, triggering:

Documentation/networking/kapi:92: net/core/dev.c:4101: WARNING: Missing matching underline for section title overline.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: asml.silence@gmail.com
CC: Akira Yokosawa <akiyks@gmail.com>
CC: Bagas Sanjaya <bagasdotme@gmail.com>
CC: Ben Greear <greearb@candelatech.com>
---
 net/core/dev.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4..186c6b07c60c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4131,30 +4131,25 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 }
 
 /**
- *	__dev_queue_xmit - transmit a buffer
- *	@skb: buffer to transmit
- *	@sb_dev: suboordinate device used for L2 forwarding offload
- *
- *	Queue a buffer for transmission to a network device. The caller must
- *	have set the device and priority and built the buffer before calling
- *	this function. The function can be called from an interrupt.
+ * __dev_queue_xmit() - transmit a buffer
+ * @skb:	buffer to transmit
+ * @sb_dev:	suboordinate device used for L2 forwarding offload
  *
- *	A negative errno code is returned on a failure. A success does not
- *	guarantee the frame will be transmitted as it may be dropped due
- *	to congestion or traffic shaping.
+ * Queue a buffer for transmission to a network device. The caller must
+ * have set the device and priority and built the buffer before calling
+ * this function. The function can be called from an interrupt.
  *
- * -----------------------------------------------------------------------------------
- *      I notice this method can also return errors from the queue disciplines,
- *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
- *      be positive.
+ * When calling this method, interrupts MUST be enabled. This is because
+ * the BH enable code must have IRQs enabled so that it will not deadlock.
  *
- *      Regardless of the return value, the skb is consumed, so it is currently
- *      difficult to retry a send to this method.  (You can bump the ref count
- *      before sending to hold a reference for retry if you are careful.)
+ * Regardless of the return value, the skb is consumed, so it is currently
+ * difficult to retry a send to this method. (You can bump the ref count
+ * before sending to hold a reference for retry if you are careful.)
  *
- *      When calling this method, interrupts MUST be enabled.  This is because
- *      the BH enable code must have IRQs enabled so that it will not deadlock.
- *          --BLG
+ * Return:
+ * * 0				- buffer successfully transmitted
+ * * positive qdisc return code	- NET_XMIT_DROP etc.
+ * * negative errno		- other errors
  */
 int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
-- 
2.34.3

