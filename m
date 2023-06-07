Return-Path: <netdev+bounces-8987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC2B7267AD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B75072811BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D31738CCA;
	Wed,  7 Jun 2023 17:43:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29C1772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:29 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D296B1BF7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:43:27 -0700 (PDT)
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1D8D13F447
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686159801;
	bh=j90adpv5OKiVekqJ11PzWX+ZuuCToGInj5AleNVe4gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=aEG9nzeqRsjdnYd0u//bDNaVPdmN639egE3lRSdvCcV1ChA+N/i3hZkyr6GEeRqXJ
	 YfU+gV0PbvkD+lgWQuJgms9REtUFs5V9oG0kuv9IRY/CAXXebtS6h5hcgAF61QA+9r
	 fIQ0HDk4MR2kO/FgceNboKRlV7HsSKB6SDDavet12aRny4w5LFp2gcuaD0utLO33Yk
	 v8pgqQKGcs36PYrd4xlX86MYjKt41b2m2KZZWHLAeJa0hejfY+DGnp9nuWZbdFLYFz
	 gNth1RU5MF01YnwredKfjpBP2zuiodv9gQ7IhXlBT3jUPXLQYf4DT61T45AmrIcmfE
	 ObjrNVRg25RVw==
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-19f53031c46so676544fac.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159799; x=1688751799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j90adpv5OKiVekqJ11PzWX+ZuuCToGInj5AleNVe4gc=;
        b=AwXchHg3ncr4xVoj/FpqSihPtcejvnoECmYTGJp6d2O5Z75wBU4zVQl2JVf4qTk5/z
         KG8F2uf1LWNnXhG+alDh+uhWrBQIo8n4JIvRa02Zm1ecusPYs1Z6KcQ95NtJZ7bD45kL
         4zmVe0+n7fkYfKET6mSC8qZCdsXZvQD70G578yi0TiJmoTiSzpLxIyB55OizsH7Zl40l
         qUx2PisHrhU6iAkSwQKdZKJ9XPeg+544TZD+EHR9CRXlfIVBmJ0VOQD+dt8TRJWzR/44
         TjxBgbomHB6ax+fgOOYPDRX8FwT0uORdy374J1uT/e8qoz7iPXxsPtPl+zKRO29bPK9v
         9aGA==
X-Gm-Message-State: AC+VfDyM7DpvWPRCL+obabIlY0K4lHSHHB7R50I1CuSJ85qP7Jnpb5DO
	HjWxtdRLbmjQns4tg0CnwlCEPDLhvJHtw9SWgA496/8Tk1ekWhC44QXv/8FXbY1qDq0j6rLo4ol
	ADQSC6GielZDwUkqUxqGQzgxbilCVAQKKdaeanFgb3zwxWcE=
X-Received: by 2002:a05:6871:8a2:b0:187:f238:3db with SMTP id r34-20020a05687108a200b00187f23803dbmr3957457oaq.19.1686159798816;
        Wed, 07 Jun 2023 10:43:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Q6h6dt4/RiTKf1tR/dQriarGmiD9rFRMH89s6DTR+wZ0SPHzVr2XppuFz/KJ0MZgC6mZZPw==
X-Received: by 2002:a05:6871:8a2:b0:187:f238:3db with SMTP id r34-20020a05687108a200b00187f23803dbmr3957402oaq.19.1686159797103;
        Wed, 07 Jun 2023 10:43:17 -0700 (PDT)
Received: from mingau.. ([2804:7f0:b443:8cea:efdc:2496:54f7:d884])
        by smtp.gmail.com with ESMTPSA id c10-20020a9d75ca000000b006ac75cff491sm2176016otl.3.2023.06.07.10.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:43:16 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	dsahern@gmail.com
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] selftests: net: vrf-xfrm-tests: change authentication and encryption algos
Date: Wed,  7 Jun 2023 14:43:01 -0300
Message-Id: <20230607174302.19542-3-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607174302.19542-1-magali.lemes@canonical.com>
References: <20230607174302.19542-1-magali.lemes@canonical.com>
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
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
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


