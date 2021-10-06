Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E572423D32
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhJFLtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbhJFLtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F5BC061760;
        Wed,  6 Oct 2021 04:47:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so8848194edj.1;
        Wed, 06 Oct 2021 04:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vvUDXRfQZSa/sD1uRH4Cu4LlbkozKmdcsriUWZz/OOk=;
        b=HwwJxf46zyePUemdn1L5zDaG+s2+3LcVZyR5YKrzlLuopAh9rPr1XWjHYXV0UfNsYM
         SwbinOo9o2E8ovGpVaFFm0+KNL1olzSz2No1p80h0z9dlsXHzgRoJObhb+eTb9ZrQhFu
         Rg+3O9FWx8nLyWCWVhRg2p2JUhdB0udtivkUmsVBOWDoZqcFf0a2pwA0cWdlE45l5TOx
         aEBMPkl8hh4YX8daRAuQ4EvmX11zWm44khPbu289NUXVuzaYEpsu/4GKdLiBuHZZQw71
         zkSqV/jWihdwOjkfUa62hBLAc4SuQvKUjcSDl5uKDcY0Dkeecn/+Yy2Ois6o0U14dWZJ
         YfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vvUDXRfQZSa/sD1uRH4Cu4LlbkozKmdcsriUWZz/OOk=;
        b=52j+zzaMTYILSt8ujB3/4reLUu1fXRGxfryFVWZHmyGXUWNC8AZ70Ib/ZmHAcY7KIV
         bQ0m+hLk+TJTgcnf6V+gaH1FsoZiQu2gVCfHpVMu32QRdLArFU8A1FPgizIc/QKs7vYK
         n9BSEIL0+RalwxX3OC3pLZH/ZO7hGGLvTGfWHZyf2Iv6fhdE+hoa1HDGadArNStioj58
         FjVROoGrC0eJIgYsjWZ5WNGsYjgLFA8+kyvwX4OwmgIWoeFzO9zbBF2KoZ5onQO90qZC
         uODIKSMbIkCtGBmgRv9H2XgFXllabZmnlrm3plP+VkZeRkOD4R/w8KhKdj6BVwQPGt7B
         2jgg==
X-Gm-Message-State: AOAM532vzjLpt1fIkH/ZbeiMQxA1zGU/jpEP319rAVWTQyttFOok8Buk
        tTN4XgqLaK1QRlV1DXCtwCU=
X-Google-Smtp-Source: ABdhPJzKV7RMnRPFCg1pvbi+bXRv7aY6VNydbcv3wVFCYgohiQzs2RCEJNXY0hhHvcX9CXKk+mJ8nA==
X-Received: by 2002:a50:becf:: with SMTP id e15mr33689336edk.114.1633520874695;
        Wed, 06 Oct 2021 04:47:54 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:54 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] selftests: net/fcnal: Non-zero exit on failures
Date:   Wed,  6 Oct 2021 14:47:19 +0300
Message-Id: <f8479130ce46322d75b0556273c16b45522b5ff4.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test scripts must report 'pass' or 'fail' via exit status, not just
logging.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 43ea5c878a85..9cf05e6e0d9b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4015,5 +4015,6 @@ done
 
 cleanup 2>/dev/null
 
 printf "\nTests passed: %3d\n" ${nsuccess}
 printf "Tests failed: %3d\n"   ${nfail}
+exit $(( nfail != 0 ))
-- 
2.25.1

