Return-Path: <netdev+bounces-5385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA0A710FF6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06AF91C20EF3
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEBA19E7B;
	Thu, 25 May 2023 15:50:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F119E74
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:50:40 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F90AC0
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso1841944b3a.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685029838; x=1687621838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=X6yq9tOUJmu5wdCuhpN4hKHIFwvO2zunfmwp6Tp8Hq1DD0ovLIAwITRbOCj6vgDfFD
         N9km+va69xNGxVQA4HBSHfNW/qiuul4scdBAuYeMjZgqZ+12g8oGRlfpgiFj8Gg7jc0O
         6pRsB5o4k5lZQDKvhqMXnf+qxM23WTInfSyOsdmbpOFRem4D6yfpr1Bz4NEnibdf5JMm
         TDI9EF9U3xAd66cXECr5XPkFsFEmR55/0qpUrobM7BexwfKP1EEZ7BP3LiMV5ksbA+FN
         GDn5nPRfbGfLKnCCfRku+7eGZde91AqVZqvA8qpYVbw6C5inW2MO71fW98VSvqQAuh2D
         LMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685029838; x=1687621838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=Ywt0q+CjTma4m9gQkILyS0XV09dVJg8CGylSAP1k+vQ/cWqi5tVpqnWW9/51yh9fKK
         UGQjCX/ZCKpvjXEpyGpRm2k3E7HmEnjGj06RiETb/aB2eF2IRentW7lueXIoVtocsqbr
         Fa+MilJXe7pQ99nBbj5G5FI889/5XEmeXNvABVun/3ScaV1H8SRXg5K3dLP3t1rodEnk
         /SLaamg6F/SoXnKqQh0XRgKHhAXxzM4yI4Jqk8MpGeIfYIVchPwZE6rO8tc84Ue/Cv3q
         7HzkRMc8nnB+abVIg8AVWHxMYLGScUfCBZQOcU+8LNWsLu/RCERFtBHTFPl7SJK+XaAp
         tfgw==
X-Gm-Message-State: AC+VfDzYrtNTVSL4ugTsFtD05xZsaS5jIZnWMa3b31JAhmAb6n8g2IU1
	kGWiH/n/16KlOktfN2VeVRmIu5swEM7teN8km3jtFg==
X-Google-Smtp-Source: ACHHUZ4wqx12dzVDnzZ/tRwjdAVQKMhDjkPTKGIQe/dBXM1uqGR1nzqRR4blvQ6bApWijSksfzDwGQ==
X-Received: by 2002:a17:902:7b84:b0:1ac:82bb:ebdf with SMTP id w4-20020a1709027b8400b001ac82bbebdfmr1924616pll.58.1685029838530;
        Thu, 25 May 2023 08:50:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902e84100b001a9a8983a15sm1586547plg.231.2023.05.25.08.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:50:38 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v2 1/2] vxlan: use print_nll for gbp and gpe
Date: Thu, 25 May 2023 08:50:34 -0700
Message-Id: <20230525155035.7471-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525155035.7471-1-stephen@networkplumber.org>
References: <20230525155035.7471-1-stephen@networkplumber.org>
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

The Gbp and Gpe are presence, not booleans so use print_null()
for them

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c47606..cb6745c74507 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -650,9 +650,9 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_bool(PRINT_ANY, "remcsum_rx", "remcsumrx ", true);
 
 	if (tb[IFLA_VXLAN_GBP])
-		print_bool(PRINT_ANY, "gbp", "gbp ", true);
+		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
-		print_bool(PRINT_ANY, "gpe", "gpe ", true);
+		print_null(PRINT_ANY, "gpe", "gpe ", NULL);
 }
 
 static void vxlan_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.39.2


