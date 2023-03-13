Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B924C6B8674
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCMX6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCMX6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:58:51 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8EA7201B;
        Mon, 13 Mar 2023 16:58:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so5093103pjt.5;
        Mon, 13 Mar 2023 16:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678751930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i/QsPiaCSrrnU3mafgB4yVcHZwDtDxqLCJ0JB4KhShc=;
        b=amU9zzVxrNtos0vcEPx5k5QnLDkNOXGRu3p9GgQspXNp9GQWsqDlWCEU00hlGEjm0o
         OkFigIV911MnQbfsplstUhokTElo5bgUQzq3HMinLOe5E8HFTpk+JKH7HcboZXriSWEW
         KLxKEOjX8tFhkE596ZIDu33E92MoI7W7RqACKyVFiM0MdYfUDChtrKVwJ4FnvG9WFlWu
         8nD1mh8ULoiAKtr9tgtNGDGwb68EW22yISVkxcR0HQtU3zaFNcE9o56+zePR+MpaLBjv
         QKXBXRxFOMEMzP3wMK3X/AWZo9M1nfjCrfcu/gykbBkL+tMw/bM7QX5rMiNPlCV+3Nx7
         QHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i/QsPiaCSrrnU3mafgB4yVcHZwDtDxqLCJ0JB4KhShc=;
        b=AtpQNlKnDf3//C1Mv4TOoZyN2ypx6/tSEti2v62DZPrKPDrcZKu/8X6N/oL6ybrKme
         2BJJvnuKPTW+4hZCNDYk3+YqsNawK5BwGYWJ8JEnNNgHToE9CbIUfYJzLKv0/65SGOFI
         FzaajB5bnYMoo+t0OF3WZXzTPSBngiTGy8s46MM10qBM+hxGi77+pX8D9NgdBb6gXq8J
         JBtwymcfHlAfca1I08WrGAjAWJz6nvj8biink81FHJahg9cJ9tM5aBTwGozsIkrv95Fg
         08AuxgrkcSEgyKXtVosNLUYFJ7fuKnwcNF0TKbHHDNNdsUdEFD7RSRiDn09orsh3L5ez
         K18g==
X-Gm-Message-State: AO0yUKXrczbYZXP67l0S+1q/x+pUpJOBzS4eRpVTEsY91u6AMALqw8lI
        0XlKLxCwPlmw8M8adWSGRtw=
X-Google-Smtp-Source: AK7set/J3PZZSrIS6izSAPCdF0sNZlGQmUePrS2QjoGGZ/KX8xM5yDRHobnp2ZEcugc/VNkapaAGqg==
X-Received: by 2002:a05:6a20:144f:b0:d4:de2d:b9d8 with SMTP id a15-20020a056a20144f00b000d4de2db9d8mr3550712pzi.29.1678751930042;
        Mon, 13 Mar 2023 16:58:50 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ad6b])
        by smtp.gmail.com with ESMTPSA id d13-20020aa78e4d000000b0061ddff8c53dsm253734pfr.151.2023.03.13.16.58.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Mar 2023 16:58:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/3] bpf: Allow helpers access ptr_to_btf_id.
Date:   Mon, 13 Mar 2023 16:58:42 -0700
Message-Id: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
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

From: Alexei Starovoitov <ast@kernel.org>

Allow code like:
bpf_strncmp(task->comm, 16, "foo");

Alexei Starovoitov (3):
  bpf: Fix bpf_strncmp proto.
  bpf: Allow helpers access trusted PTR_TO_BTF_ID.
  selftests/bpf: Add various tests to check helper access into
    ptr_to_btf_id.

 kernel/bpf/helpers.c                          |  2 +-
 kernel/bpf/verifier.c                         | 15 ++++++++
 .../selftests/bpf/progs/task_kfunc_failure.c  | 36 +++++++++++++++++++
 .../selftests/bpf/progs/task_kfunc_success.c  |  4 +++
 4 files changed, 56 insertions(+), 1 deletion(-)

-- 
2.34.1

