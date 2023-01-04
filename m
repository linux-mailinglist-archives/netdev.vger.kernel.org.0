Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF965DF5C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbjADVzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjADVzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:55:05 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD651EAC5;
        Wed,  4 Jan 2023 13:55:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jn22so37293465plb.13;
        Wed, 04 Jan 2023 13:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+4XcGOA8JPfi4O46hWv8UShHUmr3QGV4uMMWD5MmT8A=;
        b=XcFVhv1gAH3JdjPX7gDGD9q4GzbmjwOdkiRLSo3gywgJjKuIIUc+/f7NOFPJqEVygI
         dPb0ORknjrvejVoKo76y6Htr+6D+N2B8kYtRgIjSgReL/GMWvXv7yTMpAVuH+57BrATf
         jA2hIHNXfTx6mrOBL8FOU4fOlVOj2cfTxJGPhvWDaM8mcB0OUcSnXiAreBfcvqD5xPv8
         SA5e82oEKzNYUjaerksLDfHcSDGODTbyqr/EcouGhLyd361R6glQtIuh1BtfLg4alv+G
         JjHqP9SQubQsRoUscsZVAy3OouesCShZloc6zave9cucCaI+4zc9RsacepV+hz04jo9X
         bOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+4XcGOA8JPfi4O46hWv8UShHUmr3QGV4uMMWD5MmT8A=;
        b=jAWk3mi75tfGU+pFhhDf2SBEdvqlHbwTVP9YOTGmpaOHmI9huOd+3yEy6bVkwVQeA+
         3Cy7d6e/zXmEIbe+Xlh/hpbOJARs0mC9V+tl+XwbEg1TIAoKfrHAk2TT2qDdvYbMLLnO
         adt5GEibEwFdYpNfQ21yKxuzRKYWQklxbw6Jz+p6vDgX/RMbVV2jKTL2l+bMrPQnh7dN
         +AsdvbIyFJHyoFw9E44I9SI+bhXZOhvxygbnF7HSoOI5+e1iiHj6H20H3o5t/ExYTAIL
         nuym01qiUioLLCtGXZe7gAmxv9wBAWl3LH+HXn8b9LabggQOeRTIV5TLoQ7sAIvJNYw/
         gWJw==
X-Gm-Message-State: AFqh2kqx+7LXJUBhoSOkBIjuoaBxK/7hf6PCULjq5X/mRJyewhfzGOJC
        h5Gq2Vmd1mk3s0dYT9xw8CiAstB7VnY=
X-Google-Smtp-Source: AMrXdXs/pnFTks8n7T0pMDbs7LVUlMpVN+ilLbCKFvGBYyH2EumnNoT5/TBAr4b1UfjBpxV30RCw1g==
X-Received: by 2002:a17:90a:7283:b0:225:be73:312 with SMTP id e3-20020a17090a728300b00225be730312mr45237818pjg.49.1672869304092;
        Wed, 04 Jan 2023 13:55:04 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:1385])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090a1f4b00b00225d1756f60sm25118pjy.33.2023.01.04.13.55.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Jan 2023 13:55:03 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        martin.lau@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: pull-request: bpf 2023-01-04
Date:   Wed,  4 Jan 2023 13:55:00 -0800
Message-Id: <20230104215500.79435-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 8 day(s) which contain
a total of 5 files changed, 112 insertions(+), 18 deletions(-).

The main changes are:

1) Always use maximal size for copy_array in the verifier to fix KASAN tracking, from Kees.

2) Fix bpf task iterator walking through dead tasks, from Kui-Feng.

3) Make sure livepatch and bpf fexit can coexist, from Chuang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Hyunwoo Kim, Jiri Olsa, Nathan Slingerland, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 40cab44b9089a41f71bbd0eff753eb91d5dafd68:

  net/sched: fix retpoline wrapper compilation on configs without tc filters (2022-12-28 12:11:32 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 45435d8da71f9f3e6860e6e6ea9667b6ec17ec64:

  bpf: Always use maximal size for copy_array() (2022-12-28 14:54:53 -0800)

----------------------------------------------------------------
Alexei Starovoitov (2):
      selftests/bpf: Temporarily disable part of btf_dump:var_data test.
      Merge branch 'bpf: fix the crash caused by task iterators over vma'

Chuang Wang (1):
      bpf: Fix panic due to wrong pageattr of im->image

Kees Cook (1):
      bpf: Always use maximal size for copy_array()

Kui-Feng Lee (2):
      bpf: keep a reference to the mm, in case the task is dead.
      selftests/bpf: add a test for iter/task_vma for short-lived processes

 kernel/bpf/task_iter.c                            | 39 ++++++++----
 kernel/bpf/trampoline.c                           |  4 ++
 kernel/bpf/verifier.c                             | 12 ++--
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 73 +++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/btf_dump.c |  2 +-
 5 files changed, 112 insertions(+), 18 deletions(-)
