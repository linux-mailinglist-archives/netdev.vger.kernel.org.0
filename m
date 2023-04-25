Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039826ED96F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 02:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjDYA44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 20:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDYA4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 20:56:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDD093E6;
        Mon, 24 Apr 2023 17:56:53 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a68d61579bso40353345ad.1;
        Mon, 24 Apr 2023 17:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384212; x=1684976212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=78zWz/KC0FCPe2qtqqD+OW8qMX2mw8v6vhXxial7wKs=;
        b=cdT/4/czT3DaBdNk9JxvkZSbsgAqrSAIKh+gB04r0QpKndnkk2xEbOmpWRsBFnQwRi
         pbOxnlJdtYqrdi8iQK0ljU6y8g1377eVyEJ7M2NBBK0rLiVngVAWCtp+5y2+DBsJpDnc
         /LJqhV/sbefKxzpIBSfw/cyqmvqtZ1ZjTEs5BtUdD1A9UfkEvJ85OnyOwxUF63JVIIuM
         ZXzlWdAW3og+gJ3doNZpCMOKdI2i62c90WC9KIsfWOloFSMqrGHq080/MpMcTSspjJtb
         Q/pvD6qS4XnoAjAmqvKZBbrEtq0qwGWhMxTtdtNCPr6ypoLtxCjTQNguRb/7vdIG6Kcy
         A+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384212; x=1684976212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78zWz/KC0FCPe2qtqqD+OW8qMX2mw8v6vhXxial7wKs=;
        b=d+tbR7o6luDCe/klIqEVZdSOzPdxMhiGBh3ll+BqePLXy3z8uXSmr185QP2+lpFHW6
         ytqKRXi78Wc/aNuLf3CP2JXLQOkLLiOZNncsEn/6CyClDtpgU5KiS5L7YMwwkYmo2jHG
         aV/qb+5GvYGKgPi+EDgYlwC0IHyQAAubU9Q9dxv1MENIQ2cltLhml9kikyjCMLxDS2IA
         fnWVvTkxpasskptl4xs1Wt/2MmbLlHz2XYjy14Pje09kaP8bNw7IN5kr4aINSqP6m65L
         gY+zhMjMnoJs2cjgTxtZJd6RuOQBP99wW9Gkko9Ttul81WQKcz00k36nN69fnhBvxxeE
         CJxw==
X-Gm-Message-State: AAQBX9dOMOaFI05N0WRLAn/z1ybwHD3vcLYPc1eHwQaChrFJ71nISFvm
        w0CDB+7UKR0EUuxS8/F6evI=
X-Google-Smtp-Source: AKy350ZPpWs9v4C7cfbLEXBRqD/ibA3L4JXDcNy8oxuE+wAvUTlTT9SwJdQyxbEVBwYUESVvtgkd4A==
X-Received: by 2002:a17:903:230d:b0:1a8:5083:21ed with SMTP id d13-20020a170903230d00b001a8508321edmr19536559plh.51.1682384212344;
        Mon, 24 Apr 2023 17:56:52 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ef5e])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709026b8400b001a6e5c2ebfesm7116950plk.152.2023.04.24.17.56.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 24 Apr 2023 17:56:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, andrii@kernel.org, martin.lau@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf-next 2023-04-24
Date:   Mon, 24 Apr 2023 17:56:48 -0700
Message-Id: <20230425005648.86714-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
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

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 5 non-merge commits during the last 3 day(s) which contain
a total of 7 files changed, 87 insertions(+), 44 deletions(-).

The main changes are:

1) Workaround for bpf iter selftest due to lack of subprog support in precision tracking, from Andrii.

2) Disable bpf_refcount_acquire kfunc until races are fixed, from Dave.

3) One more test_verifier test converted from asm macro to asm in C, from Eduard.

4) Fix build with NETFILTER=y INET=n config, from Florian.

5) Add __rcu_read_{lock,unlock} into deny list, from Yafang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

kernel test robot, Kumar Kartikeya Dwivedi

----------------------------------------------------------------

The following changes since commit fbc1449d385d65be49a8d164dfd3772f2cb049ae:

  Merge tag 'mlx5-updates-2023-04-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-04-21 20:47:05 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to be7dbd275dc6b911a5b9a22c4f9cb71b2c7fd847:

  selftests/bpf: avoid mark_all_scalars_precise() trigger in one of iter tests (2023-04-24 17:46:44 -0700)

----------------------------------------------------------------
for-netdev

----------------------------------------------------------------
Andrii Nakryiko (1):
      selftests/bpf: avoid mark_all_scalars_precise() trigger in one of iter tests

Dave Marchevsky (1):
      bpf: Disable bpf_refcount_acquire kfunc calls until race conditions are fixed

Eduard Zingerman (1):
      selftests/bpf: verifier/prevent_map_lookup converted to inline assembly

Florian Westphal (1):
      bpf: fix link failure with NETFILTER=y INET=n

Yafang Shao (1):
      bpf: Add __rcu_read_{lock,unlock} into btf id deny list

 include/linux/bpf_types.h                          |  2 +-
 kernel/bpf/verifier.c                              |  9 +++-
 .../selftests/bpf/prog_tests/refcounted_kptr.c     |  2 -
 tools/testing/selftests/bpf/prog_tests/verifier.c  |  2 +
 tools/testing/selftests/bpf/progs/iters.c          | 26 +++++----
 .../bpf/progs/verifier_prevent_map_lookup.c        | 61 ++++++++++++++++++++++
 .../selftests/bpf/verifier/prevent_map_lookup.c    | 29 ----------
 7 files changed, 87 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_prevent_map_lookup.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
