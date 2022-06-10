Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D03D546584
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 13:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349273AbiFJL1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 07:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiFJL1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 07:27:00 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C8122ABF4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 04:26:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id e5so6911712wma.0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 04:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgMVPv4VK0tMFupouOR7uFX4/hpxEtAvDXH2/9FsBwY=;
        b=VRwNzRnZNNDqEJWT0WNUxcec+1dBvFFOpMn1ev098avOe/rXR/UKX2GcYU7WP1Mkio
         188zy633tizv/3ptZBGyBOk41aOpSVpCL6wgNt/B/op2vgDsLbVltBkGnAo8e0DxSCqj
         sWfMwT+7wKooGFUEPq67YahL4ugjLFjr/gR2ayexvVyZcgc12w+oVwqeQlEptyxwA2sR
         UsHc9TsWCeUr9yA+mXXNIS67WbNvwyo/epeugwvKTaJ3Vtiygf4NO8H1Mi/KYHvLbrKe
         VT/1JByxjeYBONFiE+04jW5jGI/Qur9fQGtL/9Ibu7B3DXfnBy7j6twBwmGyh4ECr6AN
         VQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgMVPv4VK0tMFupouOR7uFX4/hpxEtAvDXH2/9FsBwY=;
        b=WaI3DJFqTqCtHEeq94x7hW2sJWiBRzIPqH0RDSBcLXNsA6ke8InRzTjBmU0+GdkbTr
         DeZcI1hIJ8jgRgDSew/5EYNl66ZA4NodN2s2sLiLGFX0QuvUvVyeuDTqnW7FA+Y8Vbfo
         7dng3ckXKG0PVRr8BdgzOn2G5YgSK+e9FhhI6zPThbInQuPEPpr6GigqrxRtKaG9aC7T
         L4WjQwb0Rf7jvpcIou2fp/nyHSu5agt9q3NJhmLKwL7lXvQHY8H5DjB3HDDXaVfQskkV
         HDDmANMd3yvmVH9A/qSK214zzAknk2cIj52jchz+mb3RRm2kZW5tiCtrVyscPuAGzQax
         Mk6w==
X-Gm-Message-State: AOAM531CEfz/rryIuVOjPNj2TZjKF/eRT4JcNqiDQrHL7iwfNnbpxKD6
        ePhLugT/AvTW40lSdLPB3/Z3Bg==
X-Google-Smtp-Source: ABdhPJwKNg6mj97pA5W7lvkQdXVMIAZgOoWLgb7TwqgIRMKXfpIEuOwN55GiWHpIu10YnLoLBm8HiA==
X-Received: by 2002:a05:600c:4f90:b0:394:970a:71bd with SMTP id n16-20020a05600c4f9000b00394970a71bdmr8379354wmq.158.1654860412420;
        Fri, 10 Jun 2022 04:26:52 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id z2-20020adff1c2000000b0020c5253d8dcsm25893202wro.40.2022.06.10.04.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 04:26:51 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/2] bpftool: Restore memlock rlimit bump
Date:   Fri, 10 Jun 2022 12:26:46 +0100
Message-Id: <20220610112648.29695-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently removed the uncondtional rlimit bump from bpftool, deferring it
to libbpf to probe the system for memcg-based memory accounting and to
raise the rlimit if necessary.

This probing is based on the availability of a given BPF helper, and his
known to fail on some environments where the helper, but not the memcg
memory accounting, has been backported.

To work around this, this set restores the memlock rlimit bump in bpftool.
Please see the description of the first patch for more details.

Quentin Monnet (2):
  Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"
  bpftool: Do not check return value from libbpf_set_strict_mode()

 tools/bpf/bpftool/common.c     | 8 ++++++++
 tools/bpf/bpftool/feature.c    | 2 ++
 tools/bpf/bpftool/main.c       | 2 --
 tools/bpf/bpftool/main.h       | 2 ++
 tools/bpf/bpftool/map.c        | 2 ++
 tools/bpf/bpftool/pids.c       | 1 +
 tools/bpf/bpftool/prog.c       | 3 +++
 tools/bpf/bpftool/struct_ops.c | 2 ++
 8 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.34.1

