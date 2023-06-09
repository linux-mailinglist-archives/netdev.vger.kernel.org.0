Return-Path: <netdev+bounces-9622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0217B72A06F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B27812819C9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C09A19E5D;
	Fri,  9 Jun 2023 16:43:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518CF1B908
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:47 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420103A8B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:43:45 -0700 (PDT)
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C183A3F537
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686329023;
	bh=qqgm58iJEv79RzcN8RR1scUpAZ0NnXsIaGK+gNwjMmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=Zmr3Dec8UEFaMV236J5aPhjJsjrH6hXc/y+B9sqqDWaDWWvGQ6Tytk9ymRda4HoDS
	 hMYsnKDZZ2Sn++AEZLfBCQ2S7948+q1+MScYZZNXDLTCGryzYqyHYDKW4QW2aRoUiq
	 hzamqWNSHXHdFKKCMPK8CXPbsqf5k4lxOqI0b5o4TW8vk/WMuCkE0qhT0Hi5C4WRBQ
	 qWN2BH1Mu7kV2bNofHgjGJvHL11Wn1e38JDeCcYOT53hrmG/0uywOYqsXYQQ2UPNLc
	 DruJkyZPoxzEUx19dVOVtT9VF0vrBpCqs0tR8EktIyvb9aOs+UMuHUknr537b+IZJT
	 d1y+TWdekRi6w==
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1a31a9ddd87so944645fac.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686329021; x=1688921021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqgm58iJEv79RzcN8RR1scUpAZ0NnXsIaGK+gNwjMmw=;
        b=VuiVxj7EmTGPYo9dlxdTxMxHF2zLdCY+6jcNdjZC13Iev1/MPRwQ7hczrLb/aDzXPf
         mExJVsQoxsuMal5UTcN+JyGOTtEwRwgu7zhIRjgxeR2qUG/DUrcOn52ZDfloIB+0+F8t
         dGhSQb5hRa06qrZRwIlzu5t9bvtkwraYITHZbu050lU9EyjACRHyKoB9hhgcKzlUioWd
         qLzTptVH6xofxMTzrR0U2KAatYXI4ZwH5f+AzFhT9TKFaV5RKnaiLrzYGHLfmvWbTR0w
         3dDOMt747X6dxla9lm2HOSLLdjqtl7lB0NSL9JcpK5l+bSqOmsFBgAKPPiTHDex4Bk74
         /teQ==
X-Gm-Message-State: AC+VfDzrO3Tj492I0SA46cqjMwlgyzISZE05uRfjO/JB27SBCMCbSdin
	flYkv0ORLp2v2Nh3bYZI5BPnpbcCX1a/9IVSIjtBFHp23RCSxhkjbrX3yYpZLn4WUsIuX0KcQfO
	sWtFkmlO4Pa0//aNr21rQ8ZNYSj5E4kNSnw==
X-Received: by 2002:a05:6870:87c3:b0:19e:c567:6020 with SMTP id s3-20020a05687087c300b0019ec5676020mr1614048oam.38.1686329021549;
        Fri, 09 Jun 2023 09:43:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4uH6tKIGMNieoUffmzBU5/CNGNHITxys0HB5d3gCp4Uf9lxEL0azP6HQX2WZQNiVSulkbLPQ==
X-Received: by 2002:a05:6870:87c3:b0:19e:c567:6020 with SMTP id s3-20020a05687087c300b0019ec5676020mr1614039oam.38.1686329021320;
        Fri, 09 Jun 2023 09:43:41 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:db64:8f3b:3c73:e436])
        by smtp.gmail.com with ESMTPSA id g17-20020a056870c39100b001726cfeea97sm2360707oao.29.2023.06.09.09.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:43:41 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	dsahern@gmail.com
Cc: andrei.gherzan@canonical.com,
	David Ahern <dsahern@kernel.org>,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] selftests: net: vrf-xfrm-tests: change authentication and encryption algos
Date: Fri,  9 Jun 2023 13:43:23 -0300
Message-Id: <20230609164324.497813-3-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609164324.497813-1-magali.lemes@canonical.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The vrf-xfrm-tests tests use the hmac(md5) and cbc(des3_ede)
algorithms for performing authentication and encryption, respectively.
This causes the tests to fail when fips=1 is set, since these algorithms
are not allowed in FIPS mode. Therefore, switch from hmac(md5) and
cbc(des3_ede) to hmac(sha1) and cbc(aes), which are FIPS compliant.

Fixes: 3f251d741150 ("selftests: Add tests for vrf and xfrms")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
Changes in v2:
 - Add R-b tag.

 tools/testing/selftests/net/vrf-xfrm-tests.sh | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/vrf-xfrm-tests.sh b/tools/testing/selftests/net/vrf-xfrm-tests.sh
index 184da81f554f..452638ae8aed 100755
--- a/tools/testing/selftests/net/vrf-xfrm-tests.sh
+++ b/tools/testing/selftests/net/vrf-xfrm-tests.sh
@@ -264,60 +264,60 @@ setup_xfrm()
 	ip -netns host1 xfrm state add src ${HOST1_4} dst ${HOST2_4} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_4} dst ${h2_4} ${devarg}
 
 	ip -netns host2 xfrm state add src ${HOST1_4} dst ${HOST2_4} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_4} dst ${h2_4}
 
 
 	ip -netns host1 xfrm state add src ${HOST2_4} dst ${HOST1_4} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_4} dst ${h1_4} ${devarg}
 
 	ip -netns host2 xfrm state add src ${HOST2_4} dst ${HOST1_4} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_4} dst ${h1_4}
 
 
 	ip -6 -netns host1 xfrm state add src ${HOST1_6} dst ${HOST2_6} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_6} dst ${h2_6} ${devarg}
 
 	ip -6 -netns host2 xfrm state add src ${HOST1_6} dst ${HOST2_6} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_6} dst ${h2_6}
 
 
 	ip -6 -netns host1 xfrm state add src ${HOST2_6} dst ${HOST1_6} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_6} dst ${h1_6} ${devarg}
 
 	ip -6 -netns host2 xfrm state add src ${HOST2_6} dst ${HOST1_6} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_6} dst ${h1_6}
 }
 
-- 
2.34.1


