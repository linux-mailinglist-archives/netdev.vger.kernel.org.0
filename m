Return-Path: <netdev+bounces-5398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2C971117E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:59:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 394101C209AB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148101D2A3;
	Thu, 25 May 2023 16:59:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087A81D2A2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:59:27 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C5135
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5289ce6be53so919463a12.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685033966; x=1687625966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=hVzCPPJRzOgdTY3YNfnhVyoG9L/G+lJ4S6MgCiZekNv6olo84/fGKM+tfEJM1poQV0
         hcTZDx+UjHBpe0lHodLk4zTsxorGu/QrRgu5tywVK2ej75dFEv0utNm+UuZDMtbMBpji
         2nshCmTqwYO+phhTCfm8o+E4SSEZCW2cB8nS/iEwjRIlCj/y4sfkCIY6vK/Mwc1Ri0Xl
         MJPOk7pWwTIifNfvS3CA4PjDTeVISUF7fbwmOBi22NKzXurFyS9Yn97R8nA1fUe89prB
         QEeeRnIaNjY7Kjh3WNVDAeahuOLaTlx65Yn3D5RXA/QuKhjFIeO1ALlVY960/KDS0oNm
         vycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685033966; x=1687625966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=UFIolU2yyKkmSpP/vMMXf0rS04En70nxnZQjLT4WcXA1nssDpjEkdbVkaPyHWhokqA
         px86zNFvB22KGO3S+eCHi1vIhZELLOFOIk9QmcEu5dahOC3hxZmZMta1/afgyr0B+nnB
         WQp7s07DW0zphEpzcOt89nPDpB7hfZaDdcuNezFJ0C+lOKKXaC1GdbQ5ASBIH8uYF0Xy
         G5DnTVcQQZEaaAVTkOiMBo1RN5fPWpduaKI/Q61Z+G3v9xhWKYRXvILQbGtWapxcSWBx
         LjENpsnh9qzDbKEQ2FEjxSCpmrr7LSt9G78DrIuSIY83xHuh58RkgxoT2z1AEvrJG4Aq
         1aNA==
X-Gm-Message-State: AC+VfDy+sBVT7D26zjO0iVUXjKFWnhc9JifpzTTM7YLTS3Nslkrt7tTZ
	z1HtclnkmTVrpSRbc2IHxKE+AecG/4yRg7coxyjkog==
X-Google-Smtp-Source: ACHHUZ6TX7LiQ9dsGf8FykMMngZQ8zn5rFgbrkYNCjGgVrpOMFMCylF2Kx+iVVeYkNgm405A4zLRxw==
X-Received: by 2002:a17:902:d483:b0:1ac:788c:872a with SMTP id c3-20020a170902d48300b001ac788c872amr3143235plg.1.1685033966123;
        Thu, 25 May 2023 09:59:26 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b00194d14d8e54sm1662111plg.96.2023.05.25.09.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:59:25 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v3 1/2] vxlan: use print_nll for gbp and gpe
Date: Thu, 25 May 2023 09:59:21 -0700
Message-Id: <20230525165922.9711-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525165922.9711-1-stephen@networkplumber.org>
References: <20230525165922.9711-1-stephen@networkplumber.org>
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


