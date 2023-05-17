Return-Path: <netdev+bounces-3248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BEA8706385
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFD45281481
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6676DA953;
	Wed, 17 May 2023 09:04:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BF9883C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:04:26 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CFCFA;
	Wed, 17 May 2023 02:04:24 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ae51b07338so2833305ad.0;
        Wed, 17 May 2023 02:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684314264; x=1686906264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkLNdeDn6hMP5F0r+T8wUttQQ19WSpWtWoPCipbjjYk=;
        b=sX2TRVtxCyE37VlJebGv4kakRzuCKnk3cbla80jLNjqRzQ9Dmq/vrKfyM2u9wYBaNm
         krCeicswnpCeF/b/D4RvPc9WrnRbsfNQBOtRnOty0qm+W1/iYui1O1E1jEok05OCqb0l
         jsxWscfC9NjE3Jt8jPeK8W08rXRTQvWOgr9QK7kRwKS4xrAq4JVIHWzdUpi0wOKxTcuT
         XRRI10XMq81MihVWqlTncEwPq9jrWLBB3MYI2y2tGKxekumTtmh2U5RENiuarO1i2XJW
         6S7iV2MdKqGD02v8XOkc4jI7kOPPKRIZxah1wHyZt3z4Szh9pM6asOw92neAOL5ENjXn
         dWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684314264; x=1686906264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkLNdeDn6hMP5F0r+T8wUttQQ19WSpWtWoPCipbjjYk=;
        b=LOjpV5V7KgyYm7qwelL8GTTQ9ZPOYp5lR7FG35HtPxo3ehtKs9YDI8Dr/26jxRD15f
         6M4FkLYnbeTBB0/QtU18fA3gT5wy9cCDuK2Y65aAJIAbYL65GTgouAdd/MgBARt6og2p
         JBBw1L1ZCh4lcGpBQH8Mq1Uiij7vBwavvnuHesTi3Wh88xGrkX9HY2Sfy/u6HPc2PYQQ
         KoWZiYsodAjxl5w/bTCdaTyQIiDVkNDG3zWJXGguy6Ubzu591XcjV9QHA4h1d3xPGxu8
         mXkGBErDf/+n3h3NLdAw/VWZFcWLvRtSUm4Pwsgl9+PpNNIzYtot7YssT/W0Nun6T5aJ
         +gmA==
X-Gm-Message-State: AC+VfDxR8D7OuN+ClZJZ/6VsrwhtJAwWnAoe/YPHesJyHQi7Luuhv+gV
	3mIrx0ID9f5G5o5MgUEIwQjUjXjnWAY/Iw==
X-Google-Smtp-Source: ACHHUZ7hwMokgWaISpXvantDtiRSpqKfnHJ9i0Gs+2Wu7pm5FTQkz7gbL6AErGtCa461zrTPNdbvuA==
X-Received: by 2002:a17:902:e5c3:b0:1ad:fa2e:17fc with SMTP id u3-20020a170902e5c300b001adfa2e17fcmr19927781plf.2.1684314264094;
        Wed, 17 May 2023 02:04:24 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-22.three.co.id. [180.214.233.22])
        by smtp.gmail.com with ESMTPSA id jf20-20020a170903269400b001ac69bdc9d1sm1750069plb.156.2023.05.17.02.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 02:04:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id EE78910627D; Wed, 17 May 2023 16:04:20 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>
Cc: David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Deepak R Varma <drv@mailo.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Archana <craechal@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v3 1/4] agp/amd64: Remove GPL distribution notice
Date: Wed, 17 May 2023 16:04:15 +0700
Message-Id: <20230517090418.1093091-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517090418.1093091-1-bagasdotme@gmail.com>
References: <20230517090418.1093091-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=865; i=bagasdotme@gmail.com; h=from:subject; bh=BnhAyHqAAXZPpElC1S7AamhQL42pHpYqVocWHPx47Os=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkpMyZuW/hnt7XbkVcl5v/vLZfM4N4W5XKzeuqjne90W S8sN5Y/3FHKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJzGhgZHhft/DsEsHrZ0qf W27sj6pb+Jzhf2lfTkPflzSb4k2T+nkYfjEb8zg/2/q4qq3k+OaprZ8e3ug/6V7Z5n2+boZ8myf TFh4A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is already SPDX tag which does the job, so remove the redundant
notice.

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/char/agp/amd64-agp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index ce8651436609fc..b93b0f836e52ba 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright 2001-2003 SuSE Labs.
- * Distributed under the GNU public license, v2.
  *
  * This is a GART driver for the AMD Opteron/Athlon64 on-CPU northbridge.
  * It also includes support for the AMD 8151 AGP bridge,
-- 
An old man doll... just what I always wanted! - Clara


