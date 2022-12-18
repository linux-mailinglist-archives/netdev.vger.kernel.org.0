Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD464FD29
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLRAIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLRAH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:07:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0553AE53;
        Sat, 17 Dec 2022 16:07:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso9679607pjt.0;
        Sat, 17 Dec 2022 16:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8F6Uzn3qPKjW7Pu2TCTFXqCvGwILHe72RxqksnsVPog=;
        b=foC9eFpeLiQU0CZM+xYWE4qgkadktQxQC2tDTw0fVu4oO0Zkr6hNg3schdixANV9Ld
         jFL5Cyh5+BIX5gMceD6BlIaaWS0KnXNNmxISv7IbhpA6auKsvFJ9FT8hUj2w1IdXF3V8
         NcH/n88sq4RtiA34ilsfBxG6fhNFWHuNjVc5tnbQKK1qTmEeR3tjpH2sXsjCLjiKuwyd
         mZKIsRx+Y+pdBEiXXgHfzpT9FSynIVksxj4l7jzTP8V4NnuRXHZS2/IB3sUgFJD1qJ68
         W+4rJQrxIY+ryEnRFc/VAMZovPdPg5txAvGGTYVvUkS8/C3g4Oaz12knI6HSyXIIbwlu
         wQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8F6Uzn3qPKjW7Pu2TCTFXqCvGwILHe72RxqksnsVPog=;
        b=ywUtyniCHZRohp6/g1e2LjIXE+xk4VFVTtnalVi/B2y7+IvF9a+u/T+zfo3QsxPQsQ
         pwL7KCLu+RWIcfvUHJ78Z3ssrY9HkUstQlbcrzw6n7d1qG8JSweMxdZZ77I7i9oSv7EO
         Y1eCldrCbJBOEHYsA/4xHl1+IBqkRx6nOY7qzch+iH+RkrtQPGFzasT/LVZ8nG7TijB7
         LTdCC7CCgYDXFBAsID3z2W2A3HxcEPqjvWPZvoBRcJ0nkDCml5zjuO8BVGWzrU0W6LxR
         uRAqxdvHCPciyuObvBJeff7rgHieuFGvzh4Z1K1zOpJHjQuQRtLNYd6KgcnuhbyUlmQj
         PBfw==
X-Gm-Message-State: AFqh2kpwhhxHwC9nlAugaYmNz+XPnYWULaFABgs4wcJGEBMdBCPz9PvS
        WSBGvunHWiC1tk6qIGI3kQ==
X-Google-Smtp-Source: AMrXdXuwS9fBXDVNhvZYhzLqlKL1DAN09f55FDStkvg4NxqIVUSHP3/BmYi3UpaQ7aOuWztzB+reQg==
X-Received: by 2002:a05:6a20:5488:b0:af:b771:1d01 with SMTP id i8-20020a056a20548800b000afb7711d01mr15073627pzk.49.1671322077967;
        Sat, 17 Dec 2022 16:07:57 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r7-20020a63b107000000b00478bd458bdfsm3554330pgf.88.2022.12.17.16.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:07:57 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 0/3] samples/bpf: fix LLVM compilation warning with samples
Date:   Sun, 18 Dec 2022 09:07:50 +0900
Message-Id: <20221218000753.4519-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Currently, compiling samples/bpf with LLVM emits several warning. They
are only small details, but they do not appear when compiled with GCC.
Detailed compilation command and warning logs can be found from bpf CI.

Daniel T. Lee (3):
  samples/bpf: remove unused function with test_lru_dist
  samples/bpf: replace meaningless counter with tracex4
  samples/bpf: fix uninitialized warning with
    test_current_task_under_cgroup

 samples/bpf/test_current_task_under_cgroup_user.c | 6 ++++--
 samples/bpf/test_lru_dist.c                       | 5 -----
 samples/bpf/tracex4_user.c                        | 4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

-- 
2.34.1

Changes in V2: 
- Change the cover letter subject

