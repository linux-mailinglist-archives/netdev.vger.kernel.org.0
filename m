Return-Path: <netdev+bounces-1596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 936A86FE75C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DDAC2815FE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA0917FFB;
	Wed, 10 May 2023 22:43:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DFD21CF1
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 22:43:00 +0000 (UTC)
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAE735B8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:42:58 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38dec65ab50so4355294b6e.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683758578; x=1686350578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/bPgwzucnZsg1BXsr8T7n8z+mEO++HRaBu52SxTyuXI=;
        b=Hc8TslqG5fZk7153DWsUClWmTxJp9f5JcXAwTJ9mSZLVMydBjRRQ4WxF/EP46IHGgH
         Acc8DQwWZ6tEIpH1kszqN4Kl7twZyfnhM+CxwPnX0ta3KYhYtv50GhCruRGNRI+DD8UU
         Nb83sgq14cv61mZ2fStfrG0d4dtfmimCmiZDddUl5JJJdMfUWoS1ctWlOtYGksLMtvdP
         zK3aCeOFy5Yrod5JYcLS79OURFQZ0aF2PNGr/b54TzNLhLGyZrxNxW32C6LLGikspvLg
         AcwkvTx8Sn1NqKNFirdPhqXiGb1Yd8vpcOms/L0nxT6I4UbNWFjLMBfg0h02xntUmvfc
         CKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683758578; x=1686350578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bPgwzucnZsg1BXsr8T7n8z+mEO++HRaBu52SxTyuXI=;
        b=RZ8/MjPT20u1SswC7eP9kJorB0JdM/w9sCRtCP1GOgTUj4aemB5XYhXzLr++sq5EMe
         5+RthhHNSKVhnDPDhOE+tPtWUo0fq89a5tprCxVe120lFNZmA2GQ8ncBy8UYbzv+6HZI
         hRDScCsOv3NhsZcmIfaCfUWo+kHi3MWRRES3yHpQc8zxIVfbfzG4KcCxOyIEsewA//oM
         P8W+9CeUSVka+/+iecg5fW1qU1e6N7MlrMYRa7x2HxMemm09Vq+Pk8H0t0op5NgHYw65
         7vMOgPljFtDfQ1msjdp6OT0B6jyIF1u4ckX82HINwH7QMts+cbAwLa5yYj1i6iRJNeic
         k6Og==
X-Gm-Message-State: AC+VfDx5BmmyBJJywgbPOEun46s+7ZM6+SP37DkX+rgmohGnkuEjBvdi
	6ei6Agu3CwV3NHZsGar+nQ0=
X-Google-Smtp-Source: ACHHUZ6NGEulEJTnczN5gf/COau2Y9jdu/Pxc9llUR1tTwlnVw5QpRoYgcBxsM5SBqD0AF4vjcuftg==
X-Received: by 2002:a05:6808:614e:b0:38c:5a32:325b with SMTP id dl14-20020a056808614e00b0038c5a32325bmr4521452oib.41.1683758578156;
        Wed, 10 May 2023 15:42:58 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:8be1:a329:8f7b:38d:7b0a])
        by smtp.gmail.com with ESMTPSA id l22-20020a4ae2d6000000b0054fe8b73314sm932194oot.22.2023.05.10.15.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 15:42:57 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
	id BED82616E26; Wed, 10 May 2023 19:42:54 -0300 (-03)
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: netdev@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	davem@davemloft.net,
	pabeni@redhat.com,
	kuba@kernel.org
Subject: [PATCH net] MAINTAINERS: sctp: move Neil to CREDITS
Date: Wed, 10 May 2023 19:42:43 -0300
Message-Id: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.40.1
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

Neil moved away from SCTP related duties.
Move him to CREDITS then and while at it, update SCTP
project website.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
I'm not sure about other subsystems, but he hasn't been answering for a
while.

 CREDITS     | 4 ++++
 MAINTAINERS | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index 2d9da9a7defa666cbfcd2aab7fcca821f2027066..de7e4dbbc5991194ce9bcaeb94a368e79d79832a 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1706,6 +1706,10 @@ S: Panoramastrasse 18
 S: D-69126 Heidelberg
 S: Germany
 
+N: Neil Horman
+M: nhorman@tuxdriver.com
+D: SCTP protocol maintainer.
+
 N: Simon Horman
 M: horms@verge.net.au
 D: Renesas ARM/ARM64 SoC maintainer
diff --git a/MAINTAINERS b/MAINTAINERS
index 7e0b87d5aa2e571d8a54ea4df45fc27897afeff5..2237dc2bb94585d8615a496e1a55fdf8755c83b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18835,12 +18835,11 @@ F:	drivers/target/
 F:	include/target/
 
 SCTP PROTOCOL
-M:	Neil Horman <nhorman@tuxdriver.com>
 M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
 M:	Xin Long <lucien.xin@gmail.com>
 L:	linux-sctp@vger.kernel.org
 S:	Maintained
-W:	http://lksctp.sourceforge.net
+W:	https://github.com/sctp/lksctp-tools/wiki
 F:	Documentation/networking/sctp.rst
 F:	include/linux/sctp.h
 F:	include/net/sctp/
-- 
2.40.1


