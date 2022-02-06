Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5D74AADAE
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 05:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiBFEbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 23:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBFEbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 23:31:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94726C06173B;
        Sat,  5 Feb 2022 20:31:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id on2so1216516pjb.4;
        Sat, 05 Feb 2022 20:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUijhOjd1nWaq8bBd+e7fKkRlf3hDD9ZgGUieQmhTZU=;
        b=pt4/pOwtjeXG0CPKhFPxYdGyVQLwfXNl9IXVzCcLMJDGGNtDEWyOix9CkXWiVx+KO7
         vSbexJBrgH7pjJPuwC3YVdSAKMtGDyUjaaZsXwM1NoN0JEPWUbHi2zdkEtzu6OBqidG7
         0529B54xARy9WsceWxyVfrR2JKL2EtjlZAxz5at47knBErldO7g7dx4otZJ8YQTApv4c
         jrMOlN8YChzSjj5sQatsVTmlf7W+Obch1LckrBCwLrgpR7UScJ7aywscPjTFNSUcbsQy
         btbd9SJ5ox4lWT0BJ+yRNQUr6q+1m+3aiRd07eOW/qtrOHj+zzvx3TwVw9sye0YqOe/T
         ixsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUijhOjd1nWaq8bBd+e7fKkRlf3hDD9ZgGUieQmhTZU=;
        b=JnfFWPxMhNka8e0z4LqfQH1k03JUp49cz3X3gD5CRCKbYUPrkP63fqycClynO3AkOB
         lxn1TqZ284TEd8OzmJzvPHAOx4Q/cb9g5tf0Q6ilNb3GNL4Np6kYEYygWNXcvKPBfDun
         /vKSLD7G5d10R60hUYorcWLzTu/WqyCtxZUkhQKVOebgRi73+0RRjLutfqwiV+qMNobO
         dXk9LpLzUbEfWMRRWVOYAs2gh/niCRzl3bEHIhI78Ai7c0HZIz0Tzz/xKRxevDWPiL3F
         Kma+TT/o+Ls+2722CcRtbp/YriT8/5mKwNA7aSuYdOx+bwU0wS1yGI+fFK8lsk7cv/My
         EbSQ==
X-Gm-Message-State: AOAM531eQaJrz1XscYMi+4q7eGzD2TZnC/NnykPVia3G5DxOszfc+Gcn
        bQyzETB8nW+NtRebx1Ln2w0=
X-Google-Smtp-Source: ABdhPJygy475aNP1rsPQmWj5YvFmJGACNExCwpOYKIIQgl7KYaHVyGpIhT5pKbD0Eoi7cpj8K1NW6A==
X-Received: by 2002:a17:90a:6a0a:: with SMTP id t10mr7179411pjj.227.1644121877128;
        Sat, 05 Feb 2022 20:31:17 -0800 (PST)
Received: from localhost (61-224-163-139.dynamic-ip.hinet.net. [61.224.163.139])
        by smtp.gmail.com with ESMTPSA id mr7sm4134871pjb.32.2022.02.05.20.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 20:31:16 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v4 0/2] selftests: add test for kfunc call
Date:   Sun,  6 Feb 2022 12:31:05 +0800
Message-Id: <20220206043107.18549-1-houtao1@huawei.com>
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

Hi,

The patchset add a test for kfunc call to ensure s32 is sufficient for
kfunc offset. Patch #1 unexports the subtests in ksyms_module.c to fix
the confusion in test output and patch #2 adds a test in ksyms_module.c
to ensure s32 is sufficient for kfunc offset.

Change Log:
v4:
 * remove merged patch "bpf, arm64: enable kfunc call"
 * rebased on bpf-next

v3: https://lore.kernel.org/bpf/20220130092917.14544-1-hotforest@gmail.com
  * patch #2: newly-addded to unexport unnecessary subtests
  * patch #3: use kallsyms_find() instead of reimplementing it.
  * patch #3: ensure kfunc call is supported before checking
              whether s32 will be overflowed or not.

v2: https://lore.kernel.org/bpf/20220127071532.384888-1-houtao1@huawei.com
  * add a test to check whether imm will be overflowed for kfunc call

v1: https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com

Hou Tao (2):
  selftests/bpf: do not export subtest as standalone test
  selftests/bpf: check whether s32 is sufficient for kfunc offset

 .../selftests/bpf/prog_tests/ksyms_module.c   | 46 ++++++++++++++++++-
 .../bpf/prog_tests/xdp_adjust_frags.c         |  6 ---
 .../bpf/prog_tests/xdp_adjust_tail.c          |  4 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  4 +-
 .../bpf/prog_tests/xdp_devmap_attach.c        |  2 +-
 5 files changed, 49 insertions(+), 13 deletions(-)

-- 
2.35.1

