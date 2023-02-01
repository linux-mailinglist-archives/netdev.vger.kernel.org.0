Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6730E685C11
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjBAASU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjBAASS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:18:18 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B06199D2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:18:13 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C3F4E442F0
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675210690;
        bh=Bj5TXzK2teQXYpcCK8bVKEjwIEUwVyWarV+TEw7ui6E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=s0nsEicXQKoEzN2wpn4yE7n43fxl8Nm0WVJlJ01aamzWG4ttg3+UgpksmaGzmOKks
         WlkMJAyWx+ZWEn8fkMjl0rDA4GhoLVDsCLBjFJrdDRK4QI2KwbLW15vCLi7o60kfgd
         P0cCZ/CnsJecBLLnSxY43JlNCNhbDfRSpzGbVM7sWVcsw0/DaznmuCkfI0L7w1tdyc
         PUNvpnV42kvTPRfTpyyqklunO9jAaE3PHy1edgU1fSvefcgWhOcewJeZHozRHwB4Fq
         +QzHAYeYqJmJsmfTUZes5rWzAUzQVIbUoVhxEnb/YlILMxVnRrECE+4gTwSEmerHBt
         pDKXEmy1Ppe/w==
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a05600c21ca00b003dc5584b516so159406wmj.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bj5TXzK2teQXYpcCK8bVKEjwIEUwVyWarV+TEw7ui6E=;
        b=XJa7ajR/bgPE+LfePc4W1DEOBC9Xwjy88mFftcqyFV0TFC8CmCcT4u71JkW44PAyde
         KCAyaJhkoeqKMOSzhYATulgleLIcJ1gb1mqj5u7LE4NSqVBSEN0GL4OfRiFWB/+FkWPr
         clbpnU5TzdHUKDnEeOQP6Xw2k5tG/9FuhhEPSls64XQO5knf0RQuYx/up2telrE3unMM
         u2YRIzYIEV9X08lTgh/LaQBlAtWRli9EGL4ianGDKMhw5FWmg/pw/npw5Xs+MS2z2rgq
         1m1ovr76u0JIGnFwePj/3okalk1q8J4LiA3gkbg/wmyB6OI3bDbyYbHF0xTNzJuq+/W7
         ukxA==
X-Gm-Message-State: AO0yUKV6vnnmenrm2cUd+2kpK6RvMbKcg6fsym+gghCwBlVmicQ/oJpP
        aHAR8xSk/eweDDpHGFSAWsh48bKkAo9mhkmsOYHkcN+ZWgoE/l/awN6fY3LwuATsIAi3Nepb5Ae
        XeC/85uGreD2+Ust8YN+K7cD3qmsCp9BuDg==
X-Received: by 2002:a05:600c:35c6:b0:3db:1424:e781 with SMTP id r6-20020a05600c35c600b003db1424e781mr105676wmq.23.1675210690417;
        Tue, 31 Jan 2023 16:18:10 -0800 (PST)
X-Google-Smtp-Source: AK7set+XQk4pdzQFDGvVOmPL9SqfY9L49x/YHtPC7w+utWIpSyef+OB7ZAfsRO24423SWNboFGSvqA==
X-Received: by 2002:a05:600c:35c6:b0:3db:1424:e781 with SMTP id r6-20020a05600c35c600b003db1424e781mr105663wmq.23.1675210690226;
        Tue, 31 Jan 2023 16:18:10 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003d237d60318sm108925wmi.2.2023.01.31.16.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:18:09 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4 2/4] selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
Date:   Wed,  1 Feb 2023 00:16:12 +0000
Message-Id: <20230201001612.515730-2-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201001612.515730-1-andrei.gherzan@canonical.com>
References: <20230201001612.515730-1-andrei.gherzan@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leaving unrecognized arguments buried in the output, can easily hide a
CLI/script typo. Avoid this by exiting when wrong arguments are provided to
the udpgso_bench test programs.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 2 ++
 tools/testing/selftests/net/udpgso_bench_tx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index d0895bd1933f..4058c7451e70 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -336,6 +336,8 @@ static void parse_opts(int argc, char **argv)
 			cfg_verify = true;
 			cfg_read_all = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index f1fdaa270291..b47b5c32039f 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -490,6 +490,8 @@ static void parse_opts(int argc, char **argv)
 		case 'z':
 			cfg_zerocopy = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
-- 
2.34.1

