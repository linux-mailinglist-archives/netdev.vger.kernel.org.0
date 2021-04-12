Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76B35D135
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhDLTkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhDLTki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:40:38 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E83C061574;
        Mon, 12 Apr 2021 12:40:18 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id h7so10900875qtx.3;
        Mon, 12 Apr 2021 12:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AejPjhsHd0YI0MrjTxvC6alCH6cYbS+O/IVWNwQC52Y=;
        b=dQRAMB2MLNab3KT3Zr1FvYs2vktv0pqd+leX97cPUMRc74VTuCPDoBqymtb9FYz6lM
         Dkav/M0wqTAQvNYaNmKeSmrJEd/0YAzPOGv9kx0pQ4j21CYgkFikwVhQ78RxAoTJGxHL
         HJv2MkZB6GDfC5YHsW5VHhrA0WZnvJJluz+/GARa254x6UGJJyO33ndSMtcOXpOHe+WN
         RnEFH/MWZkInjvOYmJbD6ZjKZWGn9GuM3lf21SOqtZsV++E8C6gPEj3YnIiE5EoJCtLx
         KubgNgqw5XLc9zOfJJJ9bQ7YX+wYdbxKsgZisOEbu5xD6rEUQGUkcH6y5XXIyn/w2B0F
         Xdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AejPjhsHd0YI0MrjTxvC6alCH6cYbS+O/IVWNwQC52Y=;
        b=XNZbEqZuX8BIn4RbnB/1JLXoRV/hD1CEogaXO7gA3kTm28SmyO8JP+qq4SXvM4eIU0
         4UktsUC3EuAnQaUNlkylg1OOdjmN492INWtr77FJpf9FmSuYAiQCGgMVumQLaqc31gF8
         wvALva9qgOT1P2lXE7Sv1+NPOwvqni4xybPg+2CKghkW+Hk57EfDnP+Kiz0LIQPrMch8
         AWSmRU0lK92AMauHdzQZScES3orPsyeRe7zEunRLsKwFhast1aabZII5iPrBdjaLkSg8
         Z2y/OMjZTJTvs8S9m7nOyT9G2jXmN9i0HscFEpbDY3wlnFxjmd8cbmdeCioTC8Kp5TuW
         oSZA==
X-Gm-Message-State: AOAM531djWQZHEsf/RZe8tibpMDg6hAboAJTbtNpAFhSkIq0uHslRBKT
        bwKaOghdyBB0kKZ+19Eh0r0=
X-Google-Smtp-Source: ABdhPJx0Zz3O9Xoxm/2TLm1HoYTUBcMlWd7T4zM6t1HqVhuw31+cQzPVzPvMaIRT/TAXCiAAUQ4SvA==
X-Received: by 2002:ac8:dc3:: with SMTP id t3mr27647070qti.221.1618256417489;
        Mon, 12 Apr 2021 12:40:17 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id j30sm8407911qka.57.2021.04.12.12.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 12:40:17 -0700 (PDT)
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
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v3 0/3] add batched ops for percpu array
Date:   Mon, 12 Apr 2021 16:39:58 -0300
Message-Id: <20210412194001.946213-1-pctammela@mojatatu.com>
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
 .../bpf/map_tests/array_map_batch_ops.c       | 110 +++++++++++++-----
 .../bpf/map_tests/htab_map_batch_ops.c        |  71 ++++++-----
 .../selftests/bpf/prog_tests/map_init.c       |   9 +-
 tools/testing/selftests/bpf/test_maps.c       |  84 +++++++------
 6 files changed, 171 insertions(+), 112 deletions(-)

-- 
2.25.1

