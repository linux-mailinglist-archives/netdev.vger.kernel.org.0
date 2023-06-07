Return-Path: <netdev+bounces-8984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5FB7267A0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF0CE1C20DC1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B2D38CAE;
	Wed,  7 Jun 2023 17:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7916F1772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:19 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F261FF0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:43:15 -0700 (PDT)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B07A43F15F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686159790;
	bh=WmSHbQvFF5f6oShlSOp6na/vuD5Z3LmWxy6nj8WTjlU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=cF7TKBRCKTxJ3o9GMXhfL85YeUkfyuZ20n/CIJ64VQDz3iYyHa94zaxuO3st+xjM+
	 7WSpwxvs9H7QfUgGDmLS8CCrhYLADMmRM5Mfclo7nY3X8S53kHjvOp3SW6heI7r08Z
	 Z40Z0FhGHCC1OReTrCkXcGX4H0idrN21taei70AkWbUo2pfbrJCFF83KzkdUlAb2rx
	 mA6jyg2Qpo029JuuRIBC4yO1ddMwC5TEEJDd/xmmE8Q9dBF5p+dwNKVfcrVkYF4s1D
	 7tVk2QkmPdBCfjfoOm9vlmeDBu/NbkX4GP8KU7EoALivSEn6N+46bN6N3lC1cg2tjK
	 hVhs+qxegcPfg==
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6b29075c28eso2034777a34.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159789; x=1688751789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WmSHbQvFF5f6oShlSOp6na/vuD5Z3LmWxy6nj8WTjlU=;
        b=FyK/X1G1rQ/Ej/MAyAwtl4UNxTUg9wj3/4MZuuo79+S9iGepjoI8mUI5Hv4YafiCjc
         JzEEjFjgMesWw5dOqijng8Ks+5F64DwZ5UMALcsmMt+VF6JuK7BWOA4lx/gh1uHLQRve
         cNJT8nuCSxvCJJ3WP9MXZLRfkGbm0yEhcYyQM3f3CmiGalJmqBShkSXpDwCq8GF4r+gI
         ICCrBD2WcsY20Oyn4Y8AySJ3WhoGe/S2kysBa8G+GO5BxLj/s+uqsmRPhqn/5a/hilXQ
         gu5HKqR91whU+xonKFJtFCDj8r/qKg0e6Eko8I0bcMwPJYMZAS5hpA2/aJuZIMPR4XVI
         +QJA==
X-Gm-Message-State: AC+VfDzm9hvMpp55WvvCchfmVkH40gkJw0npX1F0uhJkTBTw60LlMM1K
	jWU8ZO2EOJWrT9gTagFdbO3xZZs+KUTcLPNIJ2AVxnNAC3LDzm30+8GdZlAZhe+7GUascqMxy7q
	3b499gYs5QnQsE0Vdys53WZOkPWkP1HX/hQ==
X-Received: by 2002:a9d:754e:0:b0:6b1:6b1b:a430 with SMTP id b14-20020a9d754e000000b006b16b1ba430mr3686141otl.0.1686159789633;
        Wed, 07 Jun 2023 10:43:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7y2UsOcwGV8QAxAbF4lWwz6+dwjcghWUdXBjvMxOKVP6IbDWHVOWJ/CMebFItvu8iyz/QOMg==
X-Received: by 2002:a9d:754e:0:b0:6b1:6b1b:a430 with SMTP id b14-20020a9d754e000000b006b16b1ba430mr3686122otl.0.1686159789399;
        Wed, 07 Jun 2023 10:43:09 -0700 (PDT)
Received: from mingau.. ([2804:7f0:b443:8cea:efdc:2496:54f7:d884])
        by smtp.gmail.com with ESMTPSA id c10-20020a9d75ca000000b006ac75cff491sm2176016otl.3.2023.06.07.10.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:43:09 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	dsahern@gmail.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	tianjia.zhang@linux.alibaba.com,
	vfedorenko@novek.ru
Cc: andrei.gherzan@canonical.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net 0/3] Check if FIPS mode is enabled when running selftests
Date: Wed,  7 Jun 2023 14:42:59 -0300
Message-Id: <20230607174302.19542-1-magali.lemes@canonical.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
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

Magali Lemes (3):
  selftests: net: tls: check if FIPS mode is enabled
  selftests: net: vrf-xfrm-tests: change authentication and encryption
    algos
  selftests: net: fcnal-test: check if FIPS mode is enabled

 tools/testing/selftests/net/fcnal-test.sh     |  27 +-
 tools/testing/selftests/net/tls.c             | 265 +++++++++++++++++-
 tools/testing/selftests/net/vrf-xfrm-tests.sh |  32 +--
 3 files changed, 298 insertions(+), 26 deletions(-)

-- 
2.34.1


