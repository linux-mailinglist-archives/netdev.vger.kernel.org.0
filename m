Return-Path: <netdev+bounces-10113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA1572C504
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61C5F281174
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CCD1951B;
	Mon, 12 Jun 2023 12:51:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3F618C30
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:26 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56B4195
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:23 -0700 (PDT)
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1A8693F207
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686574277;
	bh=nsdnueWG4qts2MX2wFeyUr3O+Edx/8ph3DP4zrxQHVk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=St8FHfnzOBM2lZo+fEmw9/6niJC2BY4vEv1m6Geu6UFbmhiaBKBbcxgvuF6SnGGhI
	 W5GHSEop2PpH78j8WgG3M+GEvyPDAfgWPDatAk7ACJ23YLHiu3TtxcsdHrlzhV7tIF
	 4ZmvFBwE+f7BKET2kToEPvN5hmwTuR8cnA7dPOlDs6CSRc3/j80yaLGbf1GVkCWMuW
	 mthkfE3gEOobnW3hpOSa28U7KlI+dtqKITWT0VfgC6aqfkB6D7MEFdeBRm1WW7sJNm
	 1+R/lMC5JoOBtWT6BrsTdKSE8UIdGh/tem4DIJObC6BaAqZX/l1/cIXEqvU2aK88aT
	 xsADPt7y3zBnw==
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6b2b879c07dso3275501a34.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686574275; x=1689166275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsdnueWG4qts2MX2wFeyUr3O+Edx/8ph3DP4zrxQHVk=;
        b=kAjmweXAgRXmux/nMePpmFCIphb/QIlLx0SalrcVr4fVDsmVM6g/ZmfpGArvxKU129
         vr7mGUMt4ISORxujwQaNVopOj/YXGHqnSLSCAXltJAER0h7vXsMEffxJY2LJ5Mz9ml26
         3Tu6+DUiV9/MF4jflOx4Y3FpFgb4DdWcTOMZNKnOkJODnspfCNjytYLJP0RFaTH2UHzY
         6xXiVnGDEAbGNdT9dh1onzD50ipvy3bSDOF+GwoPqWLQrFtXY1im8XcMdrQ2bNf0cvIU
         s1TJh+y0pM85+eDthEeI3RoB0+eRPQsbtm3LxwiPTLAlqWf7yVQ2B34xxCdw5z0Z3U82
         xW2A==
X-Gm-Message-State: AC+VfDykBJ3AvjDOg1GxQJ+89/6Kg0XmO99bHkm+wlfoY25o1Mh5LbuL
	QrNqx1Ym4pCdppJlAHo8XaoT7p2D9xeVtr17u2VE4I3Jx6MtAUJT62sJmHpw3T2nviUUCjwP2yX
	c53ApxV3oT40ylN2Y1+9LC4lRANd1QJpsOA==
X-Received: by 2002:a05:6830:1e2d:b0:6b2:9c2c:5eb4 with SMTP id t13-20020a0568301e2d00b006b29c2c5eb4mr6684883otr.1.1686574275275;
        Mon, 12 Jun 2023 05:51:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61vhe7IGv21iHd9QSMCXvMkwaDpF47c3oFSaeAkvqG7WCHf95PG3sRmD0BJwaW/yWoBQD19g==
X-Received: by 2002:a05:6830:1e2d:b0:6b2:9c2c:5eb4 with SMTP id t13-20020a0568301e2d00b006b29c2c5eb4mr6684866otr.1.1686574275026;
        Mon, 12 Jun 2023 05:51:15 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:d612:b95d:6bdc:8f6d])
        by smtp.gmail.com with ESMTPSA id j22-20020a4ad196000000b00529cc3986c8sm3157193oor.40.2023.06.12.05.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 05:51:14 -0700 (PDT)
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
Subject: [PATCH v3 0/4] Check if FIPS mode is enabled when running selftests
Date: Mon, 12 Jun 2023 09:51:03 -0300
Message-Id: <20230612125107.73795-1-magali.lemes@canonical.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
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

Magali Lemes (4):
  selftests/harness: allow tests to be skipped during setup
  selftests: net: tls: check if FIPS mode is enabled
  selftests: net: vrf-xfrm-tests: change authentication and encryption
    algos
  selftests: net: fcnal-test: check if FIPS mode is enabled

 tools/testing/selftests/kselftest_harness.h   |  6 ++--
 tools/testing/selftests/net/fcnal-test.sh     | 27 +++++++++++-----
 tools/testing/selftests/net/tls.c             | 25 ++++++++++++++-
 tools/testing/selftests/net/vrf-xfrm-tests.sh | 32 +++++++++----------
 4 files changed, 62 insertions(+), 28 deletions(-)

-- 
2.34.1


