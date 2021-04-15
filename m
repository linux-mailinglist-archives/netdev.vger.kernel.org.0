Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9C361153
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhDORrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhDORrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:47:19 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED45EC061574;
        Thu, 15 Apr 2021 10:46:55 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b139so20677136qkc.10;
        Thu, 15 Apr 2021 10:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mhXBXYwoCRAXpMsd3KaS7b2rQuZgED58JI4YZLlaHjw=;
        b=rFS3f0P/A0txl5h5r1SSUvafPyq4dTlHtA+rjP92XjkbqprSJLz69eaMWg9GXXXQAG
         cO5K5EC+jt30W/aVIaA7zC+9TnGdNTfEwjNmKcRA4lw6Jtx7w/a5/cQMtZ2zD4zPfTwA
         b+ACdSdWyzL8MZLaMwFbQiynXjC9oCvUDhR/PW+Y/fC8f5pPU5Nl/4rB4ynkqRstXtcd
         KWqC0sqA+bfIHgjoXBp1wQdUUQ7pkYrPhwd3xfFENzQKgfr5B9cCiCKjWf0COOvweT65
         PeuRhTZk7/TBglV6mRw1VvGGetQRKc7NWCZu0A79Oe4uS4jyb3OGqIJRk8l56YGKH0Mm
         pUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mhXBXYwoCRAXpMsd3KaS7b2rQuZgED58JI4YZLlaHjw=;
        b=BXVvHtR6gYlJmWQZo/R4jm0MOb9EWGGyf6X3qczVKNTYgmV44xsxbDvH2ZwsIBbFaa
         ztQV/N0/9XvMhrHe50JSvclKbAT2ALUfuXyjd+i0EaubrjdNqTmvQJWoykFwfH0aSNgc
         7ofj9uTXwQR38hsb2/vNq4nctwKtLbEzp7f/6rpO8Nt0R+6v7n+3K7Vt7SkB7eaM0E68
         wBVGcZzdALboBfXnHMtRdLf8lWqzQde6aqzYXXk2VvYD1eRnEiq4RpDNL3vIAkrCmJlF
         kRtwiOqpjSAFdPEKmOIdLDAYKNrC7HQGDmZ6IRv0cYvQGlkVXO4OuyKxNwEhY11/NCez
         nvSA==
X-Gm-Message-State: AOAM530/j03Rz5y+A0DjxUqtDhfqPnfsC1W3ECnSucY5t581zI3ld69i
        zyJ2fs/VNchSnZesQYw+DkGoHTIHlIQMmTo8
X-Google-Smtp-Source: ABdhPJyVgOIXBRedpUSEoh8jnOu2UZd0zxOSbA0PXgO0dLeByA86vxn6yHTQ6HV5oA4jiBl/KlMzMQ==
X-Received: by 2002:a05:620a:1093:: with SMTP id g19mr4782578qkk.112.1618508815178;
        Thu, 15 Apr 2021 10:46:55 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a4sm2186800qta.19.2021.04.15.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:46:54 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v4 0/3] add batched ops for percpu array
Date:   Thu, 15 Apr 2021 14:46:16 -0300
Message-Id: <20210415174619.51229-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces batched operations for the per-cpu variant of
the array map.

It also removes the percpu macros from 'bpf_util.h'. This change was
suggested by Andrii in a earlier iteration of this patchset.

The tests were updated to reflect all the new changes.

v3 -> v4:
- Prefer 'calloc()' over 'malloc()' on batch ops tests
- Add missing static keyword in a couple of test functions
- 'offset' to 'cpu_offset' as suggested by Martin

v2 -> v3:
- Remove percpu macros as suggested by Andrii
- Update tests that used the per cpu macros

v1 -> v2:
- Amended a more descriptive commit message

Pedro Tammela (3):
  bpf: add batched ops support for percpu array
  bpf: selftests: remove percpu macros from bpf_util.h
  bpf: selftests: update array map tests for per-cpu batched ops

 kernel/bpf/arraymap.c                         |   2 +
 tools/testing/selftests/bpf/bpf_util.h        |   7 --
 .../bpf/map_tests/array_map_batch_ops.c       | 104 +++++++++++++-----
 .../bpf/map_tests/htab_map_batch_ops.c        |  87 +++++++--------
 .../selftests/bpf/prog_tests/map_init.c       |   9 +-
 tools/testing/selftests/bpf/test_maps.c       |  84 ++++++++------
 6 files changed, 173 insertions(+), 120 deletions(-)

-- 
2.25.1

