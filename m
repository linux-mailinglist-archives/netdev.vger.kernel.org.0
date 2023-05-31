Return-Path: <netdev+bounces-6855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 436497186F5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C377E1C20E41
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F0D17741;
	Wed, 31 May 2023 16:01:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF83D1772C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:01:56 +0000 (UTC)
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5CB2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:49 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-75b14216386so386884685a.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685548908; x=1688140908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hlEU0XF/2Mqn0G2krh1FGSwitk86scNBgWmnM1kvyw=;
        b=Dgi4HiC/yCjCq8qNbpWUG8kLzvvyey4pTnalGnW6v6t+pZ47I5jJ8Ntvo2ILzBX71m
         oVfYn9ucL31etM7yXnLL00Tft5hN1BlV6QzGALalq6zaeQQXZP6GkaXKsauHu6+pA+V4
         rGEQariq/JP+sNDxR8FGD99tyUdDOhzk/Po26ELCQ5QH9il4aePgFcqTsFuuorGWTufw
         hDWSqp2too0j3AZKq1yEZFvedwug+pVtfDzIySeO6495+aksVoRpMWHos40Z12eykOdS
         Z55DOC26bOdm+rOp/igq9LBtkEOJ0DBGvr3mhTDxiuZt5TlvL5uEmYgP3esn0Th/SIQ4
         DukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685548908; x=1688140908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hlEU0XF/2Mqn0G2krh1FGSwitk86scNBgWmnM1kvyw=;
        b=FbUUZghKV4tCjx3gCYBZ6QnhXkWKIbqEN8AOxvroTEFlV0LuEFNgducoCKJI7xpD9c
         VB9x96umVmSBXuZqSiX/OyjXR2FzmL5YHEuwMYBVri6fGDlfjJ46IvIxI84pYL/TAP/E
         eHKYEsvIHi/a+TI/yPOHgMhUzT84yp5ZbPcZ/IvbX1JDdhrTC+rHp+1ttm6zglii3EKz
         VBJY4h/bwb1b45+sjmYAQpusMdZcAiARMC/V/weGziyj/Zvikso1YWfB68nH4ACEAQky
         6X98E7/80FgxSw1LMDAy4FEne6VP11+DB8A8dHHC5Hh3jrul6Oz+OJNou9SQzycHYRTd
         Zj7A==
X-Gm-Message-State: AC+VfDx2O1nTH5hqlKoRYm2CmHjECNcR5ZMVPw2c9BCwxSwewlLMCK6v
	KWO+FdbYUXRoStmzTElFThGNIgwjuE5C9Q==
X-Google-Smtp-Source: ACHHUZ6AokcW6w70RBX1XOIszqaWYujAZWUdfJHHsgiI1Ifk2uXIPjhnfzC89gHI42zwTR/eGWbt7w==
X-Received: by 2002:a05:620a:26a2:b0:75b:23a0:e7c4 with SMTP id c34-20020a05620a26a200b0075b23a0e7c4mr6444239qkp.37.1685548907964;
        Wed, 31 May 2023 09:01:47 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s11-20020ae9f70b000000b007594a7aedb2sm5261050qkg.105.2023.05.31.09.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:01:47 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 net 1/3] rtnetlink: call validate_linkmsg in rtnl_create_link
Date: Wed, 31 May 2023 12:01:42 -0400
Message-Id: <88aed7f9225eee76e6bf46dc573c7a0d917d5143.1685548598.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1685548598.git.lucien.xin@gmail.com>
References: <cover.1685548598.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]:
Validate hardware and broadcast address attribute for RTM_NEWLINK")
to validate tb[IFLA_ADDRESS/BROADCAST] for existing links. The same
check should also be done for newly created links.

This patch adds validate_linkmsg() call in rtnl_create_link(), to
avoid the invalid address set when creating some devices like:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name mac0 address 01:02 type macsec

Fixes: 0e06877c6fdb ("[RTNETLINK]: rtnl_link: allow specifying initial device address")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/core/rtnetlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 653901a1bf75..824688edb722 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3285,6 +3285,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	struct net_device *dev;
 	unsigned int num_tx_queues = 1;
 	unsigned int num_rx_queues = 1;
+	int err;
 
 	if (tb[IFLA_NUM_TX_QUEUES])
 		num_tx_queues = nla_get_u32(tb[IFLA_NUM_TX_QUEUES]);
@@ -3320,13 +3321,18 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	err = validate_linkmsg(dev, tb, extack);
+	if (err < 0) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
+
 	dev_net_set(dev, net);
 	dev->rtnl_link_ops = ops;
 	dev->rtnl_link_state = RTNL_LINK_INITIALIZING;
 
 	if (tb[IFLA_MTU]) {
 		u32 mtu = nla_get_u32(tb[IFLA_MTU]);
-		int err;
 
 		err = dev_validate_mtu(dev, mtu, extack);
 		if (err) {
-- 
2.39.1


