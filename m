Return-Path: <netdev+bounces-9620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FF172A060
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC9AE1C21110
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9884A19E52;
	Fri,  9 Jun 2023 16:43:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88850A5F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:37 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE263A88
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:43:35 -0700 (PDT)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A36E43F363
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686329013;
	bh=mEe8tT4KqhOTZhya2J7axmklktsnHYFZ6HxQsWtTxWI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=ou3NGZf9RCA2jLfz4wWYT3FCT09AvZYG9sPA+JT7ahh3Mb5P9+rLFTWShIv2HSUet
	 JTIwriz4b6POUGvFJ8E0y7be6gkbAGRdhCst4aekLEOCHk+yJJW73RFJHpxj90jrj0
	 mO/97aWdEIr3Ptkp6wkfgF69DcgSCbNEjPX52Nn89VIR3KSaanvZBxpj5RlUDeWyrf
	 xxl5cr3DCQa/ZyRHHpWqvgl9VLc1rqCcyWiRh3ThCy+JlyphimjEyo6EcCaVcTIoo+
	 kbYskZPA6lLQQoQ8HJQ4LFYxtSWMHfaH0O0TQwJVkvcC4+OnitoEUWv35ZaX7FCEfn
	 k74hWV/DuzsFQ==
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6b29c2da7a3so1065318a34.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686329012; x=1688921012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEe8tT4KqhOTZhya2J7axmklktsnHYFZ6HxQsWtTxWI=;
        b=DPP3etz0CQw7K0iu2XV6FtWUi5Lrop8LKrXxIhBTa+csV0dzzTgGrdfWzC6hgN7wJH
         k9GNPaZTQFlYeaj6liVxNzVlSlXKAyUVrccJBl5LdTm6cW9eJX6hcYWUmtzg7okS/Slr
         5Rdp6aAp8brVQmQPtZtwyvmWiHUra6UMy5w3lLj9WZ/HclK9GeBlLBM/XbIWG6tsJqGD
         7k8aBvYu1Mc5geobltUUO9n4d7IUjPDh17zXLlag5iipIE6EDdIOANDduCtAkdm5Ie5l
         MZ0Ll7h5GzWaKmDJLSE6TsHBAbjsanaiNMz6F7OeGDNvEppqRTZK51WGRQgZRg4ACIft
         0PKg==
X-Gm-Message-State: AC+VfDzPGldKmdZlhQD7tZbF5RIeQd9nG4GudYHlrtC6fM/HjnN8g6Mg
	a+FpOB2AdlsFmgp7CQHofpk1Ew3Q/G/PF1rgNplU8HEUMy43NM+B/PRm+gHYihhPtHr3aPZCPXq
	QPkl2Jn8NJXUa4qumKGYkUw/0oUqMhhwNbQ==
X-Received: by 2002:a05:6870:d304:b0:19f:1c1d:a261 with SMTP id f4-20020a056870d30400b0019f1c1da261mr1618645oag.50.1686329012427;
        Fri, 09 Jun 2023 09:43:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6msC6En9LztMQOX4P6tLcBxh/bpa27eShBUa/87DOTJVqzJmqp5gGZcqL0jdy1UI44JPu0Rg==
X-Received: by 2002:a05:6870:d304:b0:19f:1c1d:a261 with SMTP id f4-20020a056870d30400b0019f1c1da261mr1618629oag.50.1686329012219;
        Fri, 09 Jun 2023 09:43:32 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:db64:8f3b:3c73:e436])
        by smtp.gmail.com with ESMTPSA id g17-20020a056870c39100b001726cfeea97sm2360707oao.29.2023.06.09.09.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:43:31 -0700 (PDT)
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
Subject: [PATCH net v2 0/3] Check if FIPS mode is enabled when running selftests
Date: Fri,  9 Jun 2023 13:43:21 -0300
Message-Id: <20230609164324.497813-1-magali.lemes@canonical.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v2:
 - Add R-b tags.
 - Put fips_non_compliant into the variants.
 - Turn fips_enabled into a static global variable.
 - Read /proc/sys/crypto/fips_enabled only once at main().

v1: https://lore.kernel.org/netdev/20230607174302.19542-1-magali.lemes@canonical.com/

Magali Lemes (3):
  selftests: net: tls: check if FIPS mode is enabled
  selftests: net: vrf-xfrm-tests: change authentication and encryption
    algos
  selftests: net: fcnal-test: check if FIPS mode is enabled

 tools/testing/selftests/net/fcnal-test.sh     |  27 ++-
 tools/testing/selftests/net/tls.c             | 175 +++++++++++++++++-
 tools/testing/selftests/net/vrf-xfrm-tests.sh |  32 ++--
 3 files changed, 209 insertions(+), 25 deletions(-)

-- 
2.34.1


