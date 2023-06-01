Return-Path: <netdev+bounces-7196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F2D71F0B2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16C251C2106B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7555048237;
	Thu,  1 Jun 2023 17:22:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5C542501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:06 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97749194
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:22:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b024e29657so5816965ad.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640121; x=1688232121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xhxu59+g2xdBYdCqkBzRHbNxdDSdgN+pLU+lskMvwP8=;
        b=03CSQEalSJLBvaVa2qsswCs67vujP19SY8jJWmHj5iKEstvc60bBLPkAsNUsOT/kC5
         Vvf80OIi45VhsAvyXi7te4wJfGSmbAVVCuvLaPjpgVgAATrHbfIKOAa0URXGNjQTDcDh
         nsarZE64dvVxKfiIZ0ZpiGyDCU0UGePUnvWEsJL1/LgJV1WG06KmZDricT80TehhK3j6
         4fOkTZPFrW4KU9BwY1+PQyi+7meMANchtDEaqpdn53Hh31mUU2p+OsXTNO0ZskJzdtTJ
         BXk1/6kMQMiQ09TINh3w5+yjfj59D06zQmvlRps8z3qT6eTl6JZFL38syMRHzE1AfYwk
         Rr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640121; x=1688232121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xhxu59+g2xdBYdCqkBzRHbNxdDSdgN+pLU+lskMvwP8=;
        b=hLkB1/zvYDA9qlu+FIPK7Oh5IbMfoFOwioRTBJcCS6+1day+tTHrdNgwBwVqD4m1oj
         rgcVH7/ZjIjL5ikRHAm87W4Y6kcS8Jvt8L3PisEVpYvsl5pABnvkjSnHsZo/WPJPP6z5
         +fr/JOXG+bMTAFzGlUIosDEzeh3syTCAXYQgfTqmFDtuDx1/WdoXZmEIVx2hNRCyqQpB
         L4qwVo+MHT7yBjged8U2CKin95flSTx4XqaeluiIXUJ8WHfx1hfIszXUUhQCse3vurj+
         oeQt19XXuQ+rifaioPqWglmCtVF07W+8gCkIGrr7STjW5dIrSh/rlSXomjgaxIlo92gn
         YBMg==
X-Gm-Message-State: AC+VfDwTY33rlnDWFkf/K8BaNOT9H/YkrpQBww3i15hP7879Q17knTMO
	ZZ8DlqOFQWaI51cDJfI/PCxurQWRcy25vfbJoYLfpg==
X-Google-Smtp-Source: ACHHUZ49k5ls7shHIhvg16TbFhRFvgsx9yNlKVVjnz5yxUwuGVOirGRCtvmIlW377hRyPwQ6e5kZWw==
X-Received: by 2002:a17:903:1105:b0:1ab:675:3e31 with SMTP id n5-20020a170903110500b001ab06753e31mr24124plh.37.1685640120792;
        Thu, 01 Jun 2023 10:22:00 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:22:00 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2 7/7] rdma: make rd_attr_check static
Date: Thu,  1 Jun 2023 10:21:45 -0700
Message-Id: <20230601172145.51357-8-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601172145.51357-1-stephen@networkplumber.org>
References: <20230601172145.51357-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Function defined and used in only one file.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 rdma/rdma.h  | 1 -
 rdma/utils.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index 8b421db807a6..0bf77f4dcf9e 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -131,7 +131,6 @@ int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
 void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
 int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
 int rd_attr_cb(const struct nlattr *attr, void *data);
-int rd_attr_check(const struct nlattr *attr, int *typep);
 
 /*
  * Print helpers
diff --git a/rdma/utils.c b/rdma/utils.c
index a33ff420f8cb..8a091c05e0a2 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -475,7 +475,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_RAW] = MNL_TYPE_BINARY,
 };
 
-int rd_attr_check(const struct nlattr *attr, int *typep)
+static int rd_attr_check(const struct nlattr *attr, int *typep)
 {
 	int type;
 
-- 
2.39.2


