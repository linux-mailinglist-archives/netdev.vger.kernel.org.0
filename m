Return-Path: <netdev+bounces-6760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57045717D35
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12A1028147A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52F413AED;
	Wed, 31 May 2023 10:28:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6787D52A
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:28:18 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B5B134;
	Wed, 31 May 2023 03:28:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64d61fff78aso1263425b3a.1;
        Wed, 31 May 2023 03:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685528896; x=1688120896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+G6B2FYjYUAyd30KeFTxGI0vcvv6LmGoONehuHedteU=;
        b=EgrxYW1I2j1cKcYj1ot/iR0l7Tnwf9k+Xj5djTC4TgWol557kZDc4c6mpA4gZxoc76
         ikRiArahYxGiGdIqNN+Ck/HlMXLuGk0w5+nFV6JtJ4Ej1PByDwiryM5cXkrsScyE6VMC
         ieirqTnrAcTx0ngOYG4MHdEVWnuqgr2/58EXSODyHBCw8Pd7olJfgMhaq0Q6jYiydAIj
         tWHtRw5Gx0DLB+vb8zPFpZPG2h4vQ94xg6nQixqu6Eq0wl8xKjkRiBBM147MSEeWNMV7
         +qMA+u5Xx5WsB/i0gIBhPLfSV2K7Dm5y4LBmOKwuSkHKRNI7knyMKJa5MDJaCvsrFP41
         MxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685528896; x=1688120896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+G6B2FYjYUAyd30KeFTxGI0vcvv6LmGoONehuHedteU=;
        b=DoWYaV1mkbbJ3bk6V0beaxGln+nBM+BzTZzy7qMqxRWex7JYj1VFeJ8TER0+GY+6Sc
         30bkhHb/wDao1E+t5EFLLU+vk/QEntQp55jDqVuf1j1D0omxnFGPWKQEk9GG4yE32YiA
         xFU2GtRE8JvN9OOvonEl/AgN7CFx1N0dZJvT3UYTiocjFQHbodH+EK3rhkdhY2PBUQXV
         X3ww7u9n6/2sRm+jZPpXtsr0UOpLXXxYz1fgvXXbdQYiZYJvPetGzkaekvjA9U/XAnn3
         Rio/eRSZ6KHJJkR2wyzq8IbdW3WPYIdckat3p2uvxpM3/1p073Q0gpJ5WCo6FgcRkD8N
         Wlgg==
X-Gm-Message-State: AC+VfDyrkZT7ln6KCEmI7BYhJUZanlJfndPVztZ7tigyAGw6xwS9zk5e
	UIPmELFxG1RLTJk92aN6W3Q=
X-Google-Smtp-Source: ACHHUZ6WlcL8E6mzLHjwtN+3nDSeMud1tIsLJBp5q0gWrT9gxDtG+0uymgPafGpM0KdI3Dy22J9KCg==
X-Received: by 2002:a05:6a20:394c:b0:10f:955a:bc86 with SMTP id r12-20020a056a20394c00b0010f955abc86mr2011961pzg.0.1685528896154;
        Wed, 31 May 2023 03:28:16 -0700 (PDT)
Received: from hbh25y.mshome.net ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id i28-20020a63541c000000b0053efb8fae02sm952238pgb.24.2023.05.31.03.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 03:28:15 -0700 (PDT)
From: Hangyu Hua <hbh25y@gmail.com>
To: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	pieter.jansen-van-vuuren@amd.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net v2] net/sched: flower: fix possible OOB write in fl_set_geneve_opt()
Date: Wed, 31 May 2023 18:28:04 +0800
Message-Id: <20230531102805.27090-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
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

If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
size is 252 bytes(key->enc_opts.len = 252) then
key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
bypasses the next bounds check and results in an out-of-bounds.

Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

	v2: add "net" tag to title

 net/sched/cls_flower.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9dbc43388e57..815c3e416bc5 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1153,6 +1153,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	if (option_len > sizeof(struct geneve_opt))
 		data_len = option_len - sizeof(struct geneve_opt);
 
+	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
+		return -ERANGE;
+
 	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
 	memset(opt, 0xff, option_len);
 	opt->length = data_len / 4;
-- 
2.34.1


