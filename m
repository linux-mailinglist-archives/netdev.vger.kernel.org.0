Return-Path: <netdev+bounces-3313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 242A670664F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 194F81C20929
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81AD1EA83;
	Wed, 17 May 2023 11:06:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5201DDDF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:06:25 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A1C3AA2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:06:01 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-62382e86f81so2647686d6.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321558; x=1686913558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F359foBVI4KeTkwCPYpfU3IQkrtdQV05u9sCGLSOEpE=;
        b=XB/2snwuApR+43tpojuto8RTZ41a3zEUHypcAYUpO04MtDNNRdD13Vr5qpbMf4lghP
         EtVGblvbQhhZF6cktlrg2+WHKWlDZ3a2LOsmxXNW2crsPafKq0cB+93zY/+9L07GeyNq
         xeT1d5I6x/cJalzYD8ZtPZ2z+Gk9gl5c202SYmk48qdlFww+zmwFtturxXJFz5gvZUUj
         yItxMEfDQ0md+QbQ/nOyTC2pJbEMKM8V8g01tM6VQyz71EVmLTUU1rWFKBTLv8irX1yJ
         dSn+pwrjiHRCqul6wH/TBdIArh1wRstEl8MUf76LAQNGmhZZiPsrT3FVedWxBHfHkcMN
         tx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321558; x=1686913558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F359foBVI4KeTkwCPYpfU3IQkrtdQV05u9sCGLSOEpE=;
        b=MrZDjYgCA8Jd/9XqvxbxSeALmZLocyAxsfJ8BjXYd+yEXq7ff966UU/dgX+CRoz8xI
         Dhp1TiQbYfMs49uaw8qDeV3fLw9xMh28emImx/Z8vEMZLMVULIgsRvrqEx+ShVVxhbb+
         6HfdqL7fbrZS7onuM1n0Nqt9W92B6a0cryKuMNjPVMLfcT66HAYHnMQWnaBIPUHhSRew
         db1+ubmmsVjK8yHrwGA4MeBRXTfdaWkRvPoe68vPWCR5xWyBj4xp6V3Jr9OHSFg35QpF
         GPpc94kK7mrtAm0GdNulw6KesSQf8ZVq1+XsihfkvFGwhL++QZ++4I5hw1yOramiOjXB
         uCqg==
X-Gm-Message-State: AC+VfDxpZRTqjZk0KrROftSMZspks9LtxEE2K7Mmn4+M5gaL6qDPRG5Z
	1kNHZ0rknUiTxmaaHrwNodmv1Wepl2Qc2qq2BuQ=
X-Google-Smtp-Source: ACHHUZ4e2SOL+4l/Q5s/3EsLDiBkv/PPn1pTT58JPwEuU4zHqcPoqwRLpj87nBJRZ/vVj7dEAd3FGA==
X-Received: by 2002:a05:6214:c43:b0:621:23f3:5815 with SMTP id r3-20020a0562140c4300b0062123f35815mr53675368qvj.45.1684321557109;
        Wed, 17 May 2023 04:05:57 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id m24-20020aed27d8000000b003f364778b2bsm7060305qtg.4.2023.05.17.04.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:56 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 28/28] MAINTAINERS: add p4tc entry
Date: Wed, 17 May 2023 07:02:32 -0400
Message-Id: <20230517110232.29349-28-jhs@mojatatu.com>
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

P4TC is currently maintained by Mojatatu Networks.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebd26b3ca90e..32f6cd30a855 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15782,6 +15782,20 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 F:	Documentation/filesystems/overlayfs.rst
 F:	fs/overlayfs/
 
+P4TC
+M:	Victor Nogueira <victor@mojatatu.com>
+M:	Jamal Hadi Salim <jhs@mojatatu.com>
+M:	Pedro Tammela <pctammela@mojatatu.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	include/net/p4tc.h
+F:	include/net/p4tc_types.h
+F:	include/net/tc_act/p4tc.h
+F:	include/uapi/linux/p4tc.h
+F:	net/sched/cls_p4.c
+F:	net/sched/p4tc/
+F:	tools/testing/selftests/tc-testing/tc-tests/p4tc/
+
 P54 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
-- 
2.25.1


