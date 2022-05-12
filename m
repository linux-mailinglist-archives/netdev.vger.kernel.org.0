Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687715246B3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350841AbiELHSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350867AbiELHSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:18:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000C3C5E49;
        Thu, 12 May 2022 00:18:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so7024152pjv.4;
        Thu, 12 May 2022 00:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YqL59rzxP0fh+c0fKof/dLxLHqK1R9ma1QBj8NcLs8=;
        b=aM824g1aACZvUDuPjCiOX9ARKher4z+J3jR3RDNtvFOoInrIhv9A81aqJQdyIFExaM
         s7RdOioEH3CoW/iBMXaP7g4HefFYq3Hsaj6GTMEe3gAqnG6KuwMWAS19lWeGgO7FZRkZ
         D+H8zVHuJRmJKZKsxElUJ+YqV6/R3LvnFbyCW75KYyjhthA65+ccq4vpy09gWiIero5S
         JJYZecmsrQWvCzyeu9WBqqalN54j2KEAHWH2FpjVWgQJqVln+FbTT74B+szx2mxOcx3H
         edPRyO+M29j8J6oVrprE8YzJld9zo7rKXPjIU4LI3C1jevmnxkYs0PLYPStryJEiv54s
         uXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+YqL59rzxP0fh+c0fKof/dLxLHqK1R9ma1QBj8NcLs8=;
        b=f1LZ+lzglw6r/Wu4fB8JrEpI/e7wVKQ98DOjrMi/8TXEI+ZWpYNIr+N8KLpYqyl2S8
         ZxQYiogzNneJfJQgq4z3nytXIZnClsjk+MY5+mJNdp0NhD+LpuOfVT4gMpkcSTSr6/qu
         4ngKV8kFX4jVQ2yyA3S2ZKvzerFyk1kadc9ApAp1BNqn2S5itEmjgCjogULF+qxcN8Fk
         fAZXFczThRNijf5Fwvb9yvmR4u7HZ3TpIBFtsKCoKcBp9kUsEi69JshrlEaG552g1lJ3
         spKKFzpAhxUqgha4c0E+DDwXl96g5i4QldnFdchjmTw+BOpziLhOq2RnM3WYL3hIxb5z
         Hz+A==
X-Gm-Message-State: AOAM533C4UMzj1V/lSeZMEgG5zBlrD0CuLmLsbY7KVTQrytW5MI2diUV
        FRNnJ073DpQCPCMe5EKge/1QJhUWKUHHMA==
X-Google-Smtp-Source: ABdhPJy0rKSurVB1S2Cr1R94iidYdqK3iUB7yatK+UMZ/amjXXS9MrAzz3XxdqrSeFlUB3KG5b41Xw==
X-Received: by 2002:a17:90a:170c:b0:1dc:20c4:6354 with SMTP id z12-20020a17090a170c00b001dc20c46354mr9420563pjd.113.1652339910208;
        Thu, 12 May 2022 00:18:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b0015e8d4eb2b4sm3244533plg.254.2022.05.12.00.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:18:28 -0700 (PDT)
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
Subject: [PATCH net 0/2] selftests/bpf: fix ima_setup.sh missing issue
Date:   Thu, 12 May 2022 15:18:17 +0800
Message-Id: <20220512071819.199873-1-liuhangbin@gmail.com>
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

Hangbin Liu (2):
  selftests/bpf: Fix build error with ima_setup.sh
  selftests/bpf: add missed ima_setup.sh in Makefile

 tools/testing/selftests/bpf/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.35.1

