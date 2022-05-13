Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0DE525934
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359840AbiEMBBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376307AbiEMBBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:01:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89D42B26D;
        Thu, 12 May 2022 18:01:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o69so6703895pjo.3;
        Thu, 12 May 2022 18:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0aZiPrZA3Uw9Q6Q/H9pg4lyNcgm4eCcoGPtiM6CNiVw=;
        b=KmoNLjFENSLuVegp3EcfVJP8lCgGIF5k9HWirGThj24bteaKHESuu+U/0P26DDeIGA
         aZw5VnIqDjFrXnZ/uUWc05hy8KLiXQ6EXKldh2x1lW7XOWKHlW1u4QaBfgIR5siNDoZy
         jBLt88YgEred/e+VfrZRk5FtnEQOAYHJeltqltlMCZSMsl66vWbnCFKC8rockPoDTU8o
         DmWR0ZhJs9g0aeGIosMiscMFeodgY3GbSJ1uKxqmXr8p37Xy18qNBACRK8ZuD9YhpyAd
         yS0UXqyP3sg0HVUrBJceP8eqVy+6ixBisHIYDGIOD7H5kj2HpljCcQYHJibtq1dCW7M7
         56cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0aZiPrZA3Uw9Q6Q/H9pg4lyNcgm4eCcoGPtiM6CNiVw=;
        b=nJWflP8bx907496P7Rj6fndFw/7rlP5OTkD71JHyWj/4e44BZgE4SuoNbCsk3o5Nd+
         aO5VZFTHLDyPmY6ZYYrEzq1XmWFdnvexM5DSywlSJF6z3aMkA8bShtyNrD8kWy/qzQBC
         kOcJ6vlKQ0rC/Hl/PWd6wGGG9DZVDbPAIZo3MX33UzJHTqb5kmCmDN4D0xoeWPgjD3bx
         YYCFfCOfFI4zxUkLPP5NvOiR4VMKe6OVZgDtodmUACRvt8B9YG6kLoDdKKzRAbr7PT+X
         oGs3HOH5c3hUO9eVxs5CwTAUVJHT0odXzcERQgwMMsYXCS0HqzZ8BGe84rVs9L7OIa/4
         IueA==
X-Gm-Message-State: AOAM531kU6i0+HhaH/H/rsruHn0DPMy1McSZOThyfoYPCOMUwA6nnuC8
        KvPNKNXnDs47st45oSp9AMnVKFBq2dhtaw==
X-Google-Smtp-Source: ABdhPJxqMfdjVGYqKlO0op5wRtefWcftX9jjMjALe4s/fBRKlDEFwjbWUr93BC88o45oT/GjWv41pQ==
X-Received: by 2002:a17:902:7fc9:b0:15f:2afd:82f3 with SMTP id t9-20020a1709027fc900b0015f2afd82f3mr2198496plb.91.1652403681920;
        Thu, 12 May 2022 18:01:21 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i7-20020a63cd07000000b003c14af5063esm323149pgg.86.2022.05.12.18.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:01:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next 0/2] selftests/bpf: fix ima_setup.sh missing issue
Date:   Fri, 13 May 2022 09:01:08 +0800
Message-Id: <20220513010110.319061-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ima_setup.sh is needed by test_progs test_ima. But the file is
missed if we build test_progs separately or installed bpf test to
another folder. This patch set fixed the issue in 2 different
scenarios.

v2: no code update, just repost to bpf-next

Hangbin Liu (2):
  selftests/bpf: Fix build error with ima_setup.sh
  selftests/bpf: add missed ima_setup.sh in Makefile

 tools/testing/selftests/bpf/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.35.1

