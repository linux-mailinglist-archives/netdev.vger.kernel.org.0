Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186DD67B815
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbjAYRL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbjAYRLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:11:10 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EC05A83E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:10:20 -0800 (PST)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 39B253F2D8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674666590;
        bh=ThPASxkQPa8akyDheX0+gKydQu/0488KOg7wyMg90UM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hT54/oVR4sx1/JEoPzHe/GKgFzSOzc621BHTGTariYD1zDF/kAX/b+WWjMeP3NGCO
         bUYZfjFWpaj6aj0LAKY24Uqy+tDED8WkIqeV6NZmX9GJSrh7GmGpxewcOrh1Pjk9r/
         qHtxqP1dtTQmCaZNb0BjmvI6OEY43e7aEPfQwo+Y53ywdH7w13Smk6acjnt/CexPuu
         6s5eJZEeiybE1PLb2ZzcosxqBie1ouBvzjprAJiNCYNd0SoxZpLErATWbJYRemvO2m
         HTsMtkMIJ2dlD/U1bVr/9QOJemDK5GfACbZWqME+i3uZ+moJgo6IcJgQnPXDBJPgLo
         YcduOaqwK+Zag==
Received: by mail-wm1-f71.google.com with SMTP id z22-20020a05600c0a1600b003db00dc4b69so1388928wmp.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThPASxkQPa8akyDheX0+gKydQu/0488KOg7wyMg90UM=;
        b=vm+J9pL3YwDoYXWDjpdS/zM42sNRIV2NlvOl2BcahvmVp/sBpls120rg8Kl9/vq1BX
         sl5F8Pafx6GuxVXhsaYvW4zq0zj/oowazOIt5Fgs8ACPl1R1y9SNHAEsWgBRGa16PgHt
         M6wwX6TKHuWX+2zc4adW/pr+Mp8ZjRpJPDgNUlDoAjNUGfHXFpyfo8h9WdtmsKmdULp+
         8ohjOrn9HSJloY5T0oU6/LQCFvTRY8146/lIe/QIdMc6TqYSRVJOCeMqiruN+7vrohlT
         9SEN7SsAnXEi208/8z5G/YfsNBselHZXjp98wf/V0K4CMl58grzGEQpYJvj4C6pp0SKI
         DU9g==
X-Gm-Message-State: AFqh2kofWXqkCZ8KLXxtrBMvmaPzqTMZM1zijbCEssbpCaYbvcG8QMan
        jGIMCUbGPIfeEwYySRi4Aq7oUMYJoQZqXAQF4MtdYjWVZT3sZgK2WAMET7/GGwNDCZSdDj5Z72B
        GRzryUiWwXJPIvSkT76M6OGhFXPjxDa5yGA==
X-Received: by 2002:a05:600c:540d:b0:3d9:fb59:c16b with SMTP id he13-20020a05600c540d00b003d9fb59c16bmr29501090wmb.36.1674666588825;
        Wed, 25 Jan 2023 09:09:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXttpC9n/HLYXg7sMnJ5cCNz0V3VuvEsRb/sRdznLMTLa9UoYawtcdp3z0yJ9R5hGsEyyqW5hQ==
X-Received: by 2002:a05:600c:540d:b0:3d9:fb59:c16b with SMTP id he13-20020a05600c540d00b003d9fb59c16bmr29501071wmb.36.1674666588596;
        Wed, 25 Jan 2023 09:09:48 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id a3-20020adff7c3000000b002bdc3f5945dsm4793280wrq.89.2023.01.25.09.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:09:48 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 2/2] selftests: net: .gitignore the scratch directory of bpf
Date:   Wed, 25 Jan 2023 17:08:46 +0000
Message-Id: <20230125170845.85237-2-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125170845.85237-1-andrei.gherzan@canonical.com>
References: <20230125170845.85237-1-andrei.gherzan@canonical.com>
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

The net/bpf Makefile uses a similar build infrastructure to BPF[1] while
building libbpf as a dependency of nat6to4. This change adds a .gitignore
entry for SCRATCH_DIR where libbpf and its headers end up built/installed.

[1] Introduced in commit 837a3d66d698 ("selftests: net: Add
cross-compilation support for BPF programs")

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a6911cae368c..0d07dd13c973 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -40,6 +40,7 @@ test_unix_oob
 timestamping
 tls
 toeplitz
+/tools
 tun
 txring_overwrite
 txtimestamp
-- 
2.34.1

