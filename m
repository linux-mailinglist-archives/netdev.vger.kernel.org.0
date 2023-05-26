Return-Path: <netdev+bounces-5790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA60712BFA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDE0B28178C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA734290E4;
	Fri, 26 May 2023 17:42:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF6D290E1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:42:05 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524B10D3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b00f9c4699so7319625ad.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685122904; x=1687714904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=H9QzBlrc5ukY9DpgTcT5uVxfxGn8U7NG6Vb8r64Wuf8B22+yKtUwGXtwNAMxx8BQ6T
         svNDIHqgUbsbhK+i99Il8gwR0jpuN9HPO4zlWI0/TQHpm94RgVQ4uU9uF4A51pjsnkDC
         XlXp0PTcaNuUuGe+IPh6NRG15iDkZsS+lOWppSo4rU1+r60QDGNMgaBLmESvreqkAlPg
         7JD8O8NdNsJTTTrEMl7FMP4QX7sVl9wdniFmecI3r1lZXZCgWg2fJUfJsAtwiy1i1dc5
         brmIBOL6qhPw5TeDa4wI+xoyArWwmfNNyb50mPVNsiBqEWtgLKThLEdFcTcUsZaGZn3d
         eotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122904; x=1687714904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=IFDGHYHgs/hBXuz/f03/lEYWyHIgX1txN4bXOaqeSshRXM2VJQjMlan5WpjNfurhNI
         kw9tAT3kMFSGor4/paooBCAXIxv57DrcMg6lIoRuvywrm18KSZ2kK6NQRl+scM7ko7s0
         TVNEavg0jaicG9WYrEgDPACJsIRkHMRsUmANaFdy8YE648aNjWVViRF4qJ17gawKxTd7
         nwyloHVN5YQCYS/TuCw3E0KcoKCIo5oka9Z3W34pRfyQVsTjI4WcCDwRVSSwiE/4Rf1U
         xqTzOrpFiXnwBU159dRNd5ryUxr45f9tZ1WXdrmahGMaOqPwOJ5zbseQm90k78WkC1+y
         q4Nw==
X-Gm-Message-State: AC+VfDzVMIVlNbbgdbtrvfJJ5k4lMtIYr2MKIzlqlTqTqCfxEikiLVRp
	qWYIJe9aBiM2EZVOR4tC9KtaAcVI1d9ORUbI40U+QQ==
X-Google-Smtp-Source: ACHHUZ4KTHX7eBhsDIFzgL5pAsLyYTsYwBljWwVvRuxha2QYzAz8jRwKsaCQtov8/AWZCnCJrztMRA==
X-Received: by 2002:a17:902:c44b:b0:1ac:712d:2032 with SMTP id m11-20020a170902c44b00b001ac712d2032mr2945055plm.50.1685122904647;
        Fri, 26 May 2023 10:41:44 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001ab2b4105ddsm3528754plh.60.2023.05.26.10.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:41:44 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v4 1/2] vxlan: use print_nll for gbp and gpe
Date: Fri, 26 May 2023 10:41:40 -0700
Message-Id: <20230526174141.5972-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526174141.5972-1-stephen@networkplumber.org>
References: <20230526174141.5972-1-stephen@networkplumber.org>
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


