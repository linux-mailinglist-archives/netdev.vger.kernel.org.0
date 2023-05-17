Return-Path: <netdev+bounces-3304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B0B706638
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3BB1C20EBD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D7E1B903;
	Wed, 17 May 2023 11:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B2171A0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:05:12 +0000 (UTC)
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6243213B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:50 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-77e80c37af1so241852241.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321489; x=1686913489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/xQ01outo04/1fIt9zKHqBnAyMG2ZmwEftsOLnlJU0=;
        b=j91w53a+ZaMupL+IE5TSJWqSoDVNcpXmFe8pTxFjex20YMCHnLWryDPo2SaCt+W+oF
         1MaqQWR0K0tpbCzVF8CqQc0ACqV94C1yxT0xl9gjLHM9y3+d34BblzSQ2uSluEQccIMj
         0ISyY4ll5NF/bW1CTnnEbzQ3R+4PoGRUkpO+idZsfH7scg8r1uRRzL6/9B2/w6AQoMBC
         fITIwo3KL7ILY6D5TGxxYKqLy6quk+NQ1QEvPZb3LwrGcG8M4UR45LcDh4CTItJU2TgN
         l2IfzqtTJAojqoTjxji9ZBEJLtzS/AO/rmeNaCzAMinO1DPo5ajNCYP+iFVhekNad7Vu
         s5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321489; x=1686913489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/xQ01outo04/1fIt9zKHqBnAyMG2ZmwEftsOLnlJU0=;
        b=WayDL3ev1PVKP5p6n8+JiMRhZB/NrCGVuOZ3J1qMQZSu4sH3SQnVcazivFN2rCJjHZ
         qgrVTKZn2dxoKT+wGg6ZaOX958EF93Vzq0oIDDjFEsgtVPNl00V18NMV6OeRJc240HyA
         FQOE90jURK38TC/gMzLt8W3eG2A2RYEO/IzfOs9yHQQAaZ9cH28z2C+L7xm/fGcm9rRr
         /0fe1nCPQ9F1n+p9BP+/U8oaIxYrmR0/6Z+/5OArMVUPhdQ+2plkLPS0ea16kAMAmFn6
         9EJTLjieioTOFuueKlGv+isc+wzunPqeshoCYw78kUR2R+C5r7eHe2EJmHhjRwv4Mrml
         71PQ==
X-Gm-Message-State: AC+VfDytEpvDzbqaBEH8ubCOMPwpiL8aZe4thegkEzajc+OUXb8rUvx1
	P9I8LbZC2qoJRHhv/VSj6Lxpg/9n1INmUQhP4NU=
X-Google-Smtp-Source: ACHHUZ6xtJgugvYt8741MvqzZ0vVDmjrbgWzp5Q2yhzyI55Y51vZWsyIttcZYpKPLkExM38bX/dymg==
X-Received: by 2002:a67:f943:0:b0:434:9028:275 with SMTP id u3-20020a67f943000000b0043490280275mr14875258vsq.7.1684321489610;
        Wed, 17 May 2023 04:04:49 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id n19-20020a05620a153300b007595010d3bbsm522587qkk.92.2023.05.17.04.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:04:49 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 19/28] selftests: tc-testing: add JSON introspection file directory for P4TC
Date: Wed, 17 May 2023 07:02:23 -0400
Message-Id: <20230517110232.29349-19-jhs@mojatatu.com>
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

Add JSON introspection directory where we'll store the introspection
files necessary when adding table entries in P4TC.

Also add a sample JSON introspection file (ptables.json) which will be
needed by the P4TC table entries test.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../introspection-examples/example_pipe.json  | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/introspection-examples/example_pipe.json

diff --git a/tools/testing/selftests/tc-testing/introspection-examples/example_pipe.json b/tools/testing/selftests/tc-testing/introspection-examples/example_pipe.json
new file mode 100644
index 000000000000..9f216ab06d70
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/introspection-examples/example_pipe.json
@@ -0,0 +1,92 @@
+{
+    "schema_version" : "1.0.0",
+    "pipeline_name" : "example_pipe",
+    "id" : 22,
+    "tables" : [
+        {
+            "name" : "cb/tname",
+            "id" : 1,
+            "tentries" : 2048,
+            "nummask" : 8,
+            "keysize" : 64,
+            "keyid" : 1,
+            "keyfields" : [
+                {
+                    "id" : 1,
+                    "name" : "srcAddr",
+                    "type" : "ipv4",
+                    "match_type" : "exact",
+                    "bitwidth" : 32
+                },
+                {
+                    "id" : 2,
+                    "name" : "dstAddr",
+                    "type" : "ipv4",
+                    "match_type" : "exact",
+                    "bitwidth" : 32
+                }
+            ],
+            "actions" : [
+            ]
+        },
+        {
+            "name" : "cb/tname2",
+            "id" : 2,
+            "tentries" : 2048,
+            "nummask" : 8,
+            "keysize" : 32,
+            "keyid" : 1,
+            "keyfields" : [
+                {
+                    "id" : 1,
+                    "name" : "srcPort",
+                    "type" : "bit16",
+                    "match_type" : "exact",
+                    "bitwidth" : 16
+                },
+                {
+                    "id" : 2,
+                    "name" : "dstPort",
+                    "type" : "bit16",
+                    "match_type" : "exact",
+                    "bitwidth" : 16
+                }
+            ],
+            "actions" : [
+            ]
+        },
+        {
+            "name" : "cb/tname3",
+            "id" : 3,
+            "tentries" : 2048,
+            "nummask" : 8,
+            "keysize" : 104,
+            "keyid" : 1,
+            "keyfields" : [
+                {
+                    "id" : 1,
+                    "name" : "randomKey1",
+                    "type" : "bit8",
+                    "match_type" : "exact",
+                    "bitwidth" : 8
+                },
+                {
+                    "id" : 2,
+                    "name" : "randomKey2",
+                    "type" : "bit32",
+                    "match_type" : "exact",
+                    "bitwidth" : 32
+                },
+                {
+                    "id" : 3,
+                    "name" : "randomKey3",
+                    "type" : "bit64",
+                    "match_type" : "exact",
+                    "bitwidth" : 64
+                }
+            ],
+            "actions" : [
+            ]
+        }
+    ]
+}
-- 
2.25.1


