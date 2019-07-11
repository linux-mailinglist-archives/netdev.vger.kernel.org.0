Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACAD265401
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGKJkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:40:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42729 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKJkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:40:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id j8so1425513wrj.9;
        Thu, 11 Jul 2019 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l4bEEAxzGIGnFBD/3jElNFp34ehWwPy0iGMb60Ja/qM=;
        b=d6BNv87zRY3i+XzLaswys7tRTYW7MoMR2OhrioCn/iReboXP8KFai0xrXVUf2Ao/3Y
         80UN6DRbT8LL4l8/yUTFBC/8P4nkDIaPdZMboVQWJ/oarvJwi2M5UYINOHiVAoAzYNn3
         Z3TmDSX2ytLvcAizZIwS9th3odZVwv3uhB4BiYnCfZZE5k48KqvUAG9v2njrSrYXpybl
         kHzpsr1fDxeXHIe9Oz+pDW0jOPwBqqM4dhhFFDBxA6CGNpeRS+iPeo1Wdr+SSZR4AzOQ
         wJ1RaI1YB7UJB+yvESI5nkkPkOid+zc76ux5hubnI/6D4FmFzwdvgOFw5cvU7Ys60NI/
         3eHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l4bEEAxzGIGnFBD/3jElNFp34ehWwPy0iGMb60Ja/qM=;
        b=tMG5FfY2KEWZvmDJC+fJkyYnhQ8z3n9KFI9iE2+1bamRHhJS1Ie/wodBxgiyziX3M2
         GAVZQ5tv2mVympuxW/aeU6UaB6/2WzXqg3uMhWZuiXi6s2C0et+HPTLokUviCJQt9fsP
         nyINpQqmFIdjfchzHCq6+Njt5FWbRPR+ZAZ71ZhlZj3uglj9K+8nf7LWn+7EVhnnjMK2
         6iOul4i7Vlru4K8ReSdSqXS4Iqk5KJkxGtvG7EK9rilwsh2qCmBFREtMvovlSZzZ4UQR
         /H87fLG+BjYQwCM0yZ09ioOJUkkTk16GVLY6dpoGmZAwsCqpoWp/bDUfwZJTZBLNIiMC
         Hl+Q==
X-Gm-Message-State: APjAAAVHZfw2uGetNOQtZil0fejl2fz2T2grKegM0XEz82riUe3BTfww
        BHLvg5NoRxY8P34jdIrv1mo=
X-Google-Smtp-Source: APXvYqxC7+cVWxZdR3+Vy3RrmNxvDsFaJdw6K3b3W7bdZl6srTlThCnxeHt/iJSFU1gBnow4qbNMNg==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr4032230wrn.165.1562838038725;
        Thu, 11 Jul 2019 02:40:38 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id v124sm5087104wmf.23.2019.07.11.02.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:40:38 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --to=Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] [RESEND] Fold checksum at the end of bpf_csum_diff and fix
Date:   Thu, 11 Jul 2019 11:40:35 +0200
Message-Id: <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190710231439.GD32439@tassilo.jf.intel.com>
References: <20190710231439.GD32439@tassilo.jf.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

After applying patch 0001, all checksum implementations i could test (x86-64, arm64 and
arm), now agree on the return value.

Patch 0002 fix the expected return value for test #13: i did the calculation manually,
and it correspond.

Unfortunately, after applying patch 0001, other test cases now fail in
test_verifier:

$ sudo ./tools/testing/selftests/bpf/test_verifier
...
#417/p helper access to variable memory: size = 0 allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
#419/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
#423/p helper access to variable memory: size possible = 0 allowed on != NULL packet pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
...
Summary: 1500 PASSED, 0 SKIPPED, 3 FAILED

And there are probably other fallouts in other selftests - someone familiar
should take a look before applying these patches.

Paolo Pisati (2):
  bpf: bpf_csum_diff: fold the checksum before returning the
    value
  bpf, selftest: fix checksum value for test #13

 net/core/filter.c                                   | 2 +-
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

