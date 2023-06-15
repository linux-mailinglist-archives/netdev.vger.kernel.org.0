Return-Path: <netdev+bounces-10955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5878E730C82
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B90F6281605
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA4437B;
	Thu, 15 Jun 2023 01:07:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D1379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:07:06 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A61E26A6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:07:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3110ab7110aso1192115f8f.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686791223; x=1689383223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vgs6l8BhYBzeTOgjfO75FvzjRIt1j8TF5yGTTe0cGl8=;
        b=c9uvQ22a2OQ347plDW0ED7BCMa2v3Et3DmY/m4F10p4vrN/RX/rTYYCgF6cI9eg3dW
         /nGWzMyXUGoEfyUVjA18OOnKgqFZZ7LM6UgbwgNauhDMBKL+sShq+QgwV9j6L0wkXSdv
         CF71ogHkAduZtAPT0xk9HKGmv4Zrg2Q2RSl6Fcg663MP+1HmiFDkrsDHLEC1dosqLJQX
         ERSrfwEQ+R4+7FNM6f5+PZd5wU3afklIZDtW/B7jUAJHmdg3AGT1tuv1kGFduW1tpvW7
         bAAIXm+qisMZyoNAm1Z2NMRWpZGZ3c6HVluxipbm0Hqccr1+I1gX9V+SZmVaUhYtXrtS
         kj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686791223; x=1689383223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vgs6l8BhYBzeTOgjfO75FvzjRIt1j8TF5yGTTe0cGl8=;
        b=IHZna+439tMMyKtVl2KbPQecs+i2xSU+X6/LDpySVXKLwitWL1jR7pdEKfccCmmfQO
         MbYcrK4v08cPa0ngQ7DH2t9EiWndlXXFdDkgODUT5Ec44+K17w2gILVDxVt0gbwuoXD1
         QC2K3WQbUHQoX8bt5Of3bJyuFH4ak0UU2poAxs6e2p8t93aOdXxVLGpu6qrDkWMzuHif
         ZSVb34MIYwzubXpmUHn9V6bI/z3UHeFXgsUiAurd4JeH9d/vIhOYfVFs9grMpfn5WCyT
         m8LXkPOuHHBlFT8x/4ylFrYGzSPiEllCCRHCmZkNKAnpfHk3wY/j5n2EoEvIX7S8Fh72
         1iDQ==
X-Gm-Message-State: AC+VfDwJmiKcIcDrqjIV4cDb+NI39OABe4nmuhdLeqMVfFUfAOE37Bo/
	FrooeuAJqpNDdzg4Tm9xdCmedTQAdAWtgA==
X-Google-Smtp-Source: ACHHUZ6DXn8G/6rTh7J60hGCq8QJc0Z3x/Es+qpdMsrkkWmw1ek3RIIMGIh/gDypXYT1nE8+NtqmfA==
X-Received: by 2002:adf:f68c:0:b0:2f6:bf04:c8cc with SMTP id v12-20020adff68c000000b002f6bf04c8ccmr10767971wrp.55.1686791223418;
        Wed, 14 Jun 2023 18:07:03 -0700 (PDT)
Received: from localhost ([2a01:4b00:d307:1000:f1d3:eb5e:11f4:a7d9])
        by smtp.gmail.com with ESMTPSA id v16-20020adfe4d0000000b00307a83ea722sm19606273wrm.58.2023.06.14.18.07.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:07:02 -0700 (PDT)
From: luca.boccassi@gmail.com
To: netdev@vger.kernel.org
Subject: [PATCH iproute2] man: fix typos found by Lintian
Date: Thu, 15 Jun 2023 02:06:59 +0100
Message-Id: <20230615010659.1435955-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.39.2
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

From: Luca Boccassi <bluca@debian.org>

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 man/man8/dcb-apptrust.8 | 2 +-
 man/man8/tc-netem.8     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/dcb-apptrust.8 b/man/man8/dcb-apptrust.8
index c9948403..d43e97ba 100644
--- a/man/man8/dcb-apptrust.8
+++ b/man/man8/dcb-apptrust.8
@@ -40,7 +40,7 @@ for details on how to configure app table entries.
 
 Selector trust can be used by the
 software stack, or drivers (most likely the latter), when querying the APP
-table, to determine if an APP entry should take effect, or not. Additionaly, the
+table, to determine if an APP entry should take effect, or not. Additionally, the
 order of the trusted selectors will dictate which selector should take
 precedence, in the case of multiple different APP table selectors being present.
 
diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
index 51cf081e..bc7947da 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -366,7 +366,7 @@ It is possible to selectively apply impairment using traffic classification.
    match ip dst 65.172.181.4/32 flowid 1:3
 .EE
 .RS 4
-This eample uses a priority queueing discipline;
+This example uses a priority queueing discipline;
 a TBF is added to do rate control; and a simple netem delay.
 A filter classifies all packets going to 65.172.181.4 as being priority 3.
 .PP
-- 
2.39.2


