Return-Path: <netdev+bounces-3305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E17FD70663D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B5A281B5C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CDA182A5;
	Wed, 17 May 2023 11:05:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE440171A0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:05:16 +0000 (UTC)
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55C01FE3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:59 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-452f0e27a86so249901e0c.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321497; x=1686913497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=up3sS5TyWBcT2wo5acNSH7hWr8OYTcv0pS8HnefN92w=;
        b=hvcS+Np80pWtb+5/D4o+7H044DZNHMduU8b4fOh+6yw883IYcYg5sjy+s7GeqeUpy6
         KGKXw92FNcSZv+/PdvN4pPz4mSeoD5fLt5US54hi3U51N2mw2iVUJeAJiCBg4VnqrXMt
         qh2fehp3xEE8T2j3+6zmPCa34CBA6IQrs6ptrg+HekmScSpiDv9DoxeC1NIwwHiJNYHd
         3rWBpZW8rTIYH0EpxmpRDHpAns02gcq6O7RpTWWit/cbm1PqFVnZ4fPfsxQfScr7qQHb
         4TQSU7/B3DRCoIC+1YB1lK0X/Q+PIoi58fqpESFzI57bV5ZXF2n/FxT2KvmqWkQGxS8C
         k5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321497; x=1686913497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=up3sS5TyWBcT2wo5acNSH7hWr8OYTcv0pS8HnefN92w=;
        b=JKw7fD4YfsTaDuBTNL9hsK+2xLCZQBICprxPTR60zRmBS2H/X4IJqZKNe01I+SfeYf
         l1TUkz88bVvESjZFFeAuNtIKRG8lSN46wa4YmpPvOXA+fTHXg+OVQr9xqlKKp7CDsT4R
         23ivVeD36M+BeSEJmUc4rSIOeaKGWHegrcHA458xeYcRwh+r77ebCR6KBFS6BwygFhxA
         lDExiIm++oiLwb5Uaqnzsco+gg+N/j2Y7MbvF0EDNKonu7VLyr82Cs8HZ8Yh2ssx8fSp
         z5Lwmb32jKZZ3oeCnBM/tFusYx2gzxt5ItyXVSgUGU0eHrevyeKDBLNB7XNKBFksGOoB
         r+gQ==
X-Gm-Message-State: AC+VfDxKjQPi4T6gYP2XyTtWFIOm5fs4cOsjOVRttQgTyEcfNNmrnPrp
	X9nGXHoRxixFL8aQz9Cwxip/oPfWrHR7h/wISEk=
X-Google-Smtp-Source: ACHHUZ5t10jwt2FxmpZyFTE9cYLws9gDHF2WrYxFZ6SGIc7/x7ZImlmppj7CUDhdn49ZSgFEjnQEtw==
X-Received: by 2002:a1f:c112:0:b0:439:bd5c:630 with SMTP id r18-20020a1fc112000000b00439bd5c0630mr13654233vkf.6.1684321497131;
        Wed, 17 May 2023 04:04:57 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id t8-20020a05620a034800b00759495bb52fsm536320qkm.39.2023.05.17.04.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:04:56 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 20/28] selftests: tc-testing: Don't assume ENVIR is declared in local config
Date: Wed, 17 May 2023 07:02:24 -0400
Message-Id: <20230517110232.29349-20-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Don't assume that the user's tdc_config_local.py declares ENVIR
variable.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 tools/testing/selftests/tc-testing/tdc_config.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index ccb0f06ef9e3..60f74011b62f 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -28,12 +28,14 @@ NAMES = {
           'EBPFDIR': './'
         }
 
+ENVIR= {}
 
 ENVIR = { }
 
 # put customizations in tdc_config_local.py
 try:
     from tdc_config_local import *
+
 except ImportError as ie:
     pass
 
-- 
2.25.1


