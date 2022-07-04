Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423BA565122
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiGDJnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiGDJnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:43:14 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CD1274;
        Mon,  4 Jul 2022 02:43:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a15so2068465pjs.0;
        Mon, 04 Jul 2022 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=hKgjx9DTA4sYKnsHBwKLUX4DuztN/OuyL/Afqsp2oRY=;
        b=EEexCfMEMhPxoyKTed+YwlHO4mvP/qBEUEFVMG1/Vu/nVj75fw5vfVgQeaMxDTmEGL
         rHDLi8xO2BIppyi+Rku6QiAwOF0Y6NuxM2zX6jOsOPmYMPFYTZNMqnrt35bmthgDGthf
         hbHjMr14/WlC1CG1ZxSXwSlJpYcKxzLpLgE15blqVQkO6Zt0qZwJFsDboNOFidif8ucg
         CEaISMQi/oFrnEx0x5/dNXq8nPwl9Qnw55Q2JOr9B4ibhbx9lWsBJC+6vpeco+B5qOE3
         DB6sjvFtnpQppQFwkRKQEOpcCsv9q5pLvyZyNFesXEsbOWtKQCJ8vl1ROH/HTg0Vy32P
         bOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hKgjx9DTA4sYKnsHBwKLUX4DuztN/OuyL/Afqsp2oRY=;
        b=PnlWV60kHCucEj6DvmPONr+m0OnJuFk8tF0gXEreslI+w/wlFCweMMuLYVGk1Iw1io
         39WVVHqFYiAqOQmJS3SRnOIGSVNamm9Dktq7YLF+AEtdWFMix1OaPWxJMHCc0XeZQOHh
         8pPHAJ9lXROnL5aXPmTag2tDM8kPjKQqequMi+h5r4Fg5+f+w1jyGyzubqH9D7aShFcr
         2Or7rANsAefx7foZlH6kwAAaqBwfgu9j2ECu/V3qprtQlFIQKRz6eBBcdPYGtQ8mK/aD
         AHV5dh3If6Ivk7PbJhZQRcPpXBf1ap1llHFqv+b2u8jhrmjfypnmlqgwHP+k8wzhQTZ8
         rwNQ==
X-Gm-Message-State: AJIora9RqXNnKJW7pBSvkwVjiHpvr3TpdEUr3Bq+WckQ0A0tZ4uapWhn
        5X/ZsUXySC4MKx+VCmiWV5ehvDRt5TQ=
X-Google-Smtp-Source: AGRyM1smyMXPyXZkqsK7FpB9lcpllwGbzay6MfCpaVTbbwEEuRU5h1E0kU/23ZPifl7kAWC38f+rTQ==
X-Received: by 2002:a17:903:41c1:b0:16a:55ef:3688 with SMTP id u1-20020a17090341c100b0016a55ef3688mr34932557ple.161.1656927792596;
        Mon, 04 Jul 2022 02:43:12 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id bb3-20020a170902bc8300b0015e8d4eb1c8sm20714602plb.18.2022.07.04.02.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 02:43:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v2 0/3] crypto: Introduce ARIA symmetric cipher algorithm
Date:   Mon,  4 Jul 2022 09:42:47 +0000
Message-Id: <20220704094250.4265-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.

Like SEED, the ARIA is a standard cipher algorithm in South Korea.
Especially Government and Banking industry have been using this algorithm.
So the implementation of ARIA will be useful for them and network vendors.

Usecases of this algorithm are TLS[1], and IPSec.

It is tested in x86 and MIPS with the tcrypt module.

The first patch is an implementation of ARIA algorithm.
The second patch adds tests for ARIA.
The third patch adds ARIA-kTLS feature.

ARIA128-kTLS Benchmark results:
openssl-3.0-dev and iperf-ssl are used.
  TLS
[  3]  0.0- 1.0 sec   185 MBytes  1.55 Gbits/sec
[  3]  1.0- 2.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  2.0- 3.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  3.0- 4.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  4.0- 5.0 sec   186 MBytes  1.56 Gbits/sec
[  3]  0.0- 5.0 sec   927 MBytes  1.56 Gbits/sec
  kTLS
[  3]  0.0- 1.0 sec   198 MBytes  1.66 Gbits/sec
[  3]  1.0- 2.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  2.0- 3.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  3.0- 4.0 sec   194 MBytes  1.63 Gbits/sec
[  3]  4.0- 5.0 sec   194 MBytes  1.62 Gbits/sec
[  3]  0.0- 5.0 sec   974 MBytes  1.63 Gbits/sec

The previous patch version[2].

[1] https://datatracker.ietf.org/doc/html/rfc6209
[2] https://www.spinics.net/lists/linux-crypto/msg64704.html

v2:
 - Add ARIA-kTLS feature.

Taehee Yoo (3):
  crypto: Implement ARIA symmetric cipher algorithm
  crypto: add ARIA testmgr tests
  net: tls: Add ARIA-GCM algorithm

 crypto/Kconfig           |   15 +
 crypto/Makefile          |    1 +
 crypto/aria.c            |  288 ++++
 crypto/tcrypt.c          |   38 +-
 crypto/testmgr.c         |   31 +
 crypto/testmgr.h         | 2860 ++++++++++++++++++++++++++++++++++++++
 include/crypto/aria.h    |  461 ++++++
 include/uapi/linux/tls.h |   30 +
 net/tls/tls_main.c       |   62 +
 net/tls/tls_sw.c         |   34 +
 10 files changed, 3819 insertions(+), 1 deletion(-)
 create mode 100644 crypto/aria.c
 create mode 100644 include/crypto/aria.h

-- 
2.17.1

