Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A650469C93B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbjBTLES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjBTLER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:04:17 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54CEF9A
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:04:05 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0DC4A3F71F
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 11:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676891044;
        bh=PQ/e3yix0m9X8IeKW6PjCOf86G2Z7hFs9Ie/f4F1ppE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=jARpOUNcIkLbXx9McVsaMufnktMVBZesAkUzUBOVEN0IMN41a5c58sfuIqthfoMOq
         ZfU1aGNrM3D1vFWejdxmBKq9srfxMt8vLTQrwiBX2MawLUDlGnDC9XP7IfmabQMflC
         hlCieqzZsdETvHLbRhLpsfCWcjXKz/Pwxaeb7ihBHfrrUmNfNR2oOE7uyb95a4qaVE
         TVt0fuJHohthe3S2HkCqYI8R2qq/+OU6uhThyratA6YtIlRNkTtl3WwnNm+K1Wp5gc
         dsDtNujVGPnoKGxc6Cc3FafYz+BkCabw6yFkN7wdOKNdx4ERKxhYdn6tADaur5c/2x
         KU3rlRefGTtyQ==
Received: by mail-ed1-f69.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so1148069edc.9
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:04:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQ/e3yix0m9X8IeKW6PjCOf86G2Z7hFs9Ie/f4F1ppE=;
        b=O3x0iDOm5aMOLdBy9CcRnYU/ur9RVeVJUMC0HlfBT4pM5bryF5Jrm9RJcbB0bhWKt9
         VgI/PYYGRQrmBiU35UxgevsrtWMDjAUbgqwfKXGlujMz3y/F7aKv865TIZDAnk1qro9Q
         uUx4X3f5tch++j4Z+k9vvQnqE60XBFXQtLjYprz6q2rTsJikmEoigFw3ElcEN84pj5xa
         bHDloNT3UIquB+Vq8lEeMl3iW8iSvVx13axCAl103G6a1pvkmv5iecseYJeG9mXEzccx
         dwwToYGsypvBMYHeHG0nPceijVem8Ut665qEAng4HfHlUZfmI7VjhAelNkaVCnuOMg8/
         ri/g==
X-Gm-Message-State: AO0yUKVUPgMporwhV9LQIlz5ukYlUFEvfERp7p5UYDj7a+YnDx98o05h
        RnmmyHd6l2lUeBhiTFkaEGMHbBW4pmOmfr0Z9M84fATlg5N8I+K4UYZ5JBzoxyVf3c1Il9rqgft
        Ovd0PT04vrvKCTWo+55sV7DOuTsTOgmajIg==
X-Received: by 2002:a17:907:6e87:b0:871:dd2:4af0 with SMTP id sh7-20020a1709076e8700b008710dd24af0mr11742890ejc.26.1676891043832;
        Mon, 20 Feb 2023 03:04:03 -0800 (PST)
X-Google-Smtp-Source: AK7set9K9DWYKm6njTRouQU2LGApclEmMni7DIBij60SxRmB3n34Dr/nplqD3hOHz76k2PwAFJ+yyQ==
X-Received: by 2002:a17:907:6e87:b0:871:dd2:4af0 with SMTP id sh7-20020a1709076e8700b008710dd24af0mr11742867ejc.26.1676891043606;
        Mon, 20 Feb 2023 03:04:03 -0800 (PST)
Received: from work.lan (77-169-125-32.fixed.kpn.net. [77.169.125.32])
        by smtp.gmail.com with ESMTPSA id b11-20020a1709062b4b00b008b147ad0ad1sm5582552ejg.200.2023.02.20.03.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 03:04:03 -0800 (PST)
From:   Roxana Nicolescu <roxana.nicolescu@canonical.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] selftest: fib_tests: Always cleanup before exit
Date:   Mon, 20 Feb 2023 12:04:00 +0100
Message-Id: <20230220110400.26737-2-roxana.nicolescu@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220110400.26737-1-roxana.nicolescu@canonical.com>
References: <20230220110400.26737-1-roxana.nicolescu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of `set -e` before executing a command causes immediate exit
on failure, without cleanup up the resources allocated at setup.
This can affect the next tests that use the same resources,
leading to a chain of failures.

A simple fix is to always call cleanup function when the script exists.
This approach is already used by other existing tests.

Fixes: 1056691b2680 ("selftests: fib_tests: Make test results more verbose")
Signed-off-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
---
 tools/testing/selftests/net/fib_tests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 5637b5dadabd..70ea8798b1f6 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -2065,6 +2065,8 @@ EOF
 ################################################################################
 # main
 
+trap cleanup EXIT
+
 while getopts :t:pPhv o
 do
 	case $o in
-- 
2.34.1

