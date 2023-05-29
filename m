Return-Path: <netdev+bounces-5984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FFDE714370
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE0BE1C20949
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 04:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AB662C;
	Mon, 29 May 2023 04:38:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3C7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:38:36 +0000 (UTC)
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7194C26AD;
	Sun, 28 May 2023 21:38:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 41be03b00d2f7-52c84543902so284502a12.0;
        Sun, 28 May 2023 21:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685334999; x=1687926999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ljDXSZhLI5ptYG5XAswsWjP1Fj7Tcbc8VedPFNYBYoQ=;
        b=m40D0lUwbnh9qpzZq3YJVGsio+MYTwloUDfNmu8pg9f2x53WC6W8FVyfJWwiBMbEEt
         C3qF3N8Je6GWNLGU750Ia3qbTDJzvIlxFh1mGK4KCCxyxFZ0nKP1MHWzaDDSrZ10ubZS
         sAFfo5cSSfIqHV2Maynd1DSDdOZuSGhrAtB3+ChTAFuSjLS8U5wCr2PNbmdLP8CQu6z+
         tA1gBcyGMLo8RGPwKl9slQOREzwKgDWyEgk7yyKXLoRgSHHOKkN3rBYS8yI+zfdKt8iO
         4FGossrGqXq5UFOY1XupyAg+QcheZUHmT2Ia5PvqiILDl2nZlwXJSfTOPjwTN4TqNC2s
         Wgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685334999; x=1687926999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ljDXSZhLI5ptYG5XAswsWjP1Fj7Tcbc8VedPFNYBYoQ=;
        b=QqlNhH8Pe9OKBKTSVuD8wz8D/ZmUjIJJaQ5+5hZcSPEMCnrtN9aP6ZJl4etK8booOI
         lru3Hu9cPDGk3Vz6jcJscX9KR8r8b1lY8eTiwOKEclWQUWHqe8BjbGZRY2E/F32HEdRN
         mBcxbb8UlEdHu9bSzWGIUWnUCEpMK1TQuCYXrxoQHf2uFqYDMN0PhNi4CQbLQTaS5sjh
         oyPdh1Ymx9Ek3wrf4wmdXE3bieMBNE9Gb/ishxb2uxTHeKLOj+jxHIxOpog/zJgMmQ/M
         DnlgsZivn/4DgTSWhznJBg34b9rO1efprPU+qTBvxfyL4I9AHqYxLSf53cZbmYZQgeYK
         YaMA==
X-Gm-Message-State: AC+VfDzG+kQQE50YBts12XcayiBm/8nKV4InZQQDSpFALBOkAl45aTUG
	I7NyMfZQxcqVRRhTZ3+X3cU=
X-Google-Smtp-Source: ACHHUZ4lTguLq8y8jj9KX9ucZq9zIctmBGh7gxd9yKo8+2IUU5w7rbqQFarEa3Iv4T5h9YkfClS6NQ==
X-Received: by 2002:a05:6a00:1f0e:b0:64a:ed6d:53ac with SMTP id be14-20020a056a001f0e00b0064aed6d53acmr10772452pfb.2.1685334998968;
        Sun, 28 May 2023 21:36:38 -0700 (PDT)
Received: from hbh25y.. ([114.254.32.145])
        by smtp.gmail.com with ESMTPSA id i3-20020aa78b43000000b0064f95bb8255sm5096984pfd.53.2023.05.28.21.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 21:36:38 -0700 (PDT)
From: Hangyu Hua <hbh25y@gmail.com>
To: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	simon.horman@netronome.com,
	pieter.jansenvanvuuren@netronome.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Date: Mon, 29 May 2023 12:36:15 +0800
Message-Id: <20230529043615.4761-1-hbh25y@gmail.com>
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
 net/sched/cls_flower.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index e960a46b0520..a326fbfe4339 100644
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


