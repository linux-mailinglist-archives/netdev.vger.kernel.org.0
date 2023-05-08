Return-Path: <netdev+bounces-777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5C76F9E44
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FA821C2091C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C0C125D8;
	Mon,  8 May 2023 03:33:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B40E3C22
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:33:30 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CB644B0
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 20:33:27 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2ac80da3443so45953141fa.0
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 20:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683516805; x=1686108805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zHdBLTz6PLdezvt4jgD2hDhjAfq9nKK/lZcQIpglPrY=;
        b=hU8+pHx6H0yDrlyyoL9IYf1cfaENHY3Hw5rmaw6VKdxdInKniTPvxP/r2pQYdmnjQI
         u8rGB8Ab7ufhvycFeBDbFofbNiBkcGntG9jAO51tXWqvrHhqOPX8Ow96lF3u3O9YjOLu
         W3VZKO93GLGr39lB0TBoolETPFPTrDoo2qqmZQLAYoJV003nkK/hFVkqle8ru3MQ+HN9
         X5T5PqJTvtDOgiey/r4vB/bTsHNykO6UuR4ldcF3x6xEE9ipEyHeV/v/2TgT3Iz3sWL7
         DxRbcD78FauyAUbBPqhQPBapYjk3T6tVvO/oUte+Q7BzYpwowZtYq3Nsbq8CKEEosEjO
         7BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683516805; x=1686108805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zHdBLTz6PLdezvt4jgD2hDhjAfq9nKK/lZcQIpglPrY=;
        b=JimDGmouq1nWYA0xyN/enCVaI45911mP6HtCzwKgDLVSOldqnMokTODc/EjkN7e+4J
         u1QyXji4LWpCnMpJTs6miOsdEAH2PnLCGaMVxAUoUTXeLJAklpcRCKdid6n6UEIBpaHa
         I7pt+ZvMC5ybrPFe19Pv64XewG+wNYq165Reop6GfNjTwCmLEcgGk1N2WriQfYk/LIr2
         NWESGwh8Ix6yo0WaYyE4uKSCw9XaJ2U5PErxYWXveoLaKxWx9lhqHazlwB++XeiYZqXX
         sYWoD6sBrlG2nNJU8VImYj8JyfNpcJ/FvNj5U2MmdpCMeXa0wEJuOz3b9cSTRmhqpwhS
         O1tg==
X-Gm-Message-State: AC+VfDwHezr9+XPNyIaBUDqWSJED271otvf1QIEdt2+43dNDqnPCp3qd
	nnp99fjT/wE54fRn3PFLBWfla+H+1A==
X-Google-Smtp-Source: ACHHUZ6/fmgh/MNfDjzbpRdvy/X2OF9O+aaqNhl0nyQ4/drPu4eCEggpQUc7s2ffudyD+8m0SnBnIQ==
X-Received: by 2002:a2e:8752:0:b0:2a8:d1cd:a04 with SMTP id q18-20020a2e8752000000b002a8d1cd0a04mr2236894ljj.48.1683516805104;
        Sun, 07 May 2023 20:33:25 -0700 (PDT)
Received: from localhost.localdomain (77-254-67-144.adsl.inetia.pl. [77.254.67.144])
        by smtp.gmail.com with ESMTPSA id r26-20020a2e80da000000b002a8d915f30asm1028571ljg.77.2023.05.07.20.33.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 May 2023 20:33:24 -0700 (PDT)
From: Patryk Sondej <patryk.sondej@gmail.com>
To: netdev@vger.kernel.org
Cc: Patryk Sondej <patryk.sondej@gmail.com>
Subject: [PATCH net] inet_diag: fix inet_diag_msg_attrs_fill() for net_cls cgroup
Date: Mon,  8 May 2023 05:32:33 +0200
Message-Id: <20230508033232.69793-1-patryk.sondej@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

This commit fixes inet_diag_msg_attrs_fill() function in the ipv4/inet_diag.c file.
The problem was that the function was using CONFIG_SOCK_CGROUP_DATA to check for the net_cls cgroup.
However, the net_cls cgroup is defined by CONFIG_CGROUP_NET_CLASSID instead.

Therefore, this commit updates the #ifdef statement to CONFIG_CGROUP_NET_CLASSID,
and uses the sock_cgroup_classid() function to retrieve the classid from the socket cgroup.

This change ensures that the function correctly retrieves the classid for the net_cls cgroup
and fixes any issues related to the use of the function in this context.

Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
---
 net/ipv4/inet_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index b812eb36f0e3..7017f88911a6 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -157,7 +157,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
 		u32 classid = 0;
 
-#ifdef CONFIG_SOCK_CGROUP_DATA
+#ifdef CONFIG_CGROUP_NET_CLASSID
 		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
 #endif
 		/* Fallback to socket priority if class id isn't set.
-- 
2.37.1 (Apple Git-137.1)


