Return-Path: <netdev+bounces-10375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7262972E30F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 623091C20CAD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AEE915A5;
	Tue, 13 Jun 2023 12:32:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B35689
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:32:35 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6BF10F9
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:32:34 -0700 (PDT)
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 61C0A3F26C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686659552;
	bh=4Cl9VWUxsTMXwPPmsKYIpp+y5A1Gig+mMIFIzxHEGrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=DiRrVMZqPHGJXH1bHgtis6pTlqscWUI01amTpq5v1Y+lHW7avH7dDnQmgNPr6BSfG
	 q5tQPFWtsm9hkl2zSLZ2JLve/lZoXf56+RowEc3ukeWesjLtUfcUd2d/REffcfC6ar
	 NE07SuFt5myPEatfpwJ2X9AGbguleY278aqBCIpNcLT3f1tPbkIjXH0xhtCiPYmcR1
	 KP8m5d7/txmmIjE9G4GebvGCKJXTIdk7va3mOiQhxC1ucfTlhCEv3FH1x2pp4mCbve
	 GyToEmjnl7JkIiN36hjRTTp0Imh1cDGjF0bLS0C1gBt6QXxQTugI+S9ui3Etc04kRc
	 TAalJ74ZoWzTQ==
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-39ceb9a76b1so1282972b6e.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686659551; x=1689251551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Cl9VWUxsTMXwPPmsKYIpp+y5A1Gig+mMIFIzxHEGrw=;
        b=H49qa+hqotu0p1T1AbqDaotSaEcUQuBONTDoXUFF/ozUvM1+FrUccKfqn38X6LpShS
         /UyXKO+2le+Y9HPQhTlR4mU4CEBQGtcpIYgeHVzIoYquj80s6/ON7bAokIpMv3fR0kpR
         qswUfzT8/r69Mbl2Z+B0V6Na0PapwlCwDn+uNQi83q0tnanEyJDgmiQastgHWhDNSM7+
         hCCpl3DI92/bjxGwPPqtn7JRJ02q20Fz9YWkOKKfkRBEIGNyrjXu1vVUc5OgcrBc7YS5
         r5vYSDybsmo1AgU8YaHUq2KPp9+R+u7LkxrErgSuZzixUB4MsWm6XlQmjO6vNAAvRfra
         Nupw==
X-Gm-Message-State: AC+VfDy/RCs3aM4R+frs/BY4MaI8e9ODQZGmQx6ZJcldCUotz8VRZDSN
	r1bIhk8vIQy2F6QPVJtaKrIgBAtIp+cmqi78g9YaUox88rAQ/AlnTzfMCx3jR4SAT1X9Mp6/W+P
	erXHfBDC1joQVRFUSQNqfYr6GG2Iqp0U5CA==
X-Received: by 2002:a05:6808:1b06:b0:39a:be57:964b with SMTP id bx6-20020a0568081b0600b0039abe57964bmr8825628oib.13.1686659550788;
        Tue, 13 Jun 2023 05:32:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4JQJTAQ2NTad3LIh15eMndn6uBTwp05kyoejhWNzvWLQ3pSHSq3WyIrued9k1ZJLfgR4nV1A==
X-Received: by 2002:a05:6808:1b06:b0:39a:be57:964b with SMTP id bx6-20020a0568081b0600b0039abe57964bmr8825601oib.13.1686659550505;
        Tue, 13 Jun 2023 05:32:30 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:ac1a:e505:990c:70e9])
        by smtp.gmail.com with ESMTPSA id z26-20020a056808049a00b0039c532c9ae1sm4838116oid.55.2023.06.13.05.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:32:30 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	dsahern@gmail.com,
	edumazet@google.com,
	keescook@chromium.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	tianjia.zhang@linux.alibaba.com,
	vfedorenko@novek.ru
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 0/4] Check if FIPS mode is enabled when running selftests
Date: Tue, 13 Jun 2023 09:32:18 -0300
Message-Id: <20230613123222.631897-1-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some test cases from net/tls, net/fcnal-test and net/vrf-xfrm-tests
that rely on cryptographic functions to work and use non-compliant FIPS
algorithms fail in FIPS mode.

In order to allow these tests to pass in a wider set of kernels,
 - for net/tls, skip the test variants that use the ChaCha20-Poly1305
and SM4 algorithms, when FIPS mode is enabled;
 - for net/fcnal-test, skip the MD5 tests, when FIPS mode is enabled;
 - for net/vrf-xfrm-tests, replace the algorithms that are not
FIPS-compliant with compliant ones.

Changes in v4:
 - Remove extra newline.
 - Add R-b tag.

Changes in v3:
 - Add new commit to allow skipping test directly from test setup.
 - No need to initialize static variable to zero.
 - Skip tests during test setup only.
 - Use the constructor attribute to set fips_enabled before entering
 main().

Changes in v2:
 - Add R-b tags.
 - Put fips_non_compliant into the variants.
 - Turn fips_enabled into a static global variable.
 - Read /proc/sys/crypto/fips_enabled only once at main().

v1: https://lore.kernel.org/netdev/20230607174302.19542-1-magali.lemes@canonical.com/
v2: https://lore.kernel.org/netdev/20230609164324.497813-1-magali.lemes@canonical.com/
v3: https://lore.kernel.org/netdev/20230612125107.73795-1-magali.lemes@canonical.com/

Magali Lemes (4):
  selftests/harness: allow tests to be skipped during setup
  selftests: net: tls: check if FIPS mode is enabled
  selftests: net: vrf-xfrm-tests: change authentication and encryption
    algos
  selftests: net: fcnal-test: check if FIPS mode is enabled

 tools/testing/selftests/kselftest_harness.h   |  6 ++--
 tools/testing/selftests/net/fcnal-test.sh     | 27 +++++++++++-----
 tools/testing/selftests/net/tls.c             | 24 +++++++++++++-
 tools/testing/selftests/net/vrf-xfrm-tests.sh | 32 +++++++++----------
 4 files changed, 61 insertions(+), 28 deletions(-)

-- 
2.34.1


