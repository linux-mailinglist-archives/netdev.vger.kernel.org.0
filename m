Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384023F2781
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhHTHSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhHTHR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:17:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03584C061575;
        Fri, 20 Aug 2021 00:17:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so6736126pjv.3;
        Fri, 20 Aug 2021 00:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8FQnO8UfRtzR0lfog04xhkJJWyrlxZJ2j/rGU3rdIw=;
        b=jsNpYuKNJMVxJ3rwWtGgyuYzeoJIsyCV1pW6kcT8eV+XJF//TXeOBlmDtKlwmpJv4k
         bA5SSxww+fbUpKGnwmRyaJLWvWNO6Qc9imWTJFSuwu/QpF1K1qPIw3a5R4RVdkaHic9r
         CPJnuie977xdJM7TAwpRUSgmLdECufOyPjwt3YR32D+R+i6fvddl0JYqujI3Fc3KfNu2
         UGZGngFzNU/u/BQ0yBKUPiCWaoimFCXHbUGIoZPDlU0yGSTTVdjnK91Qaoly4QSH6mH9
         Krp1gBglH2Mgx9rllEeaAIXP6GM0n89xpReAfvEDBeF1Fq2TJ+H+xdT8LeubDcPs7rLb
         UieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8FQnO8UfRtzR0lfog04xhkJJWyrlxZJ2j/rGU3rdIw=;
        b=dI0lvrpOCq2MveLFhK9bPGrt04w1hrvIwXUcFiOGbc0Io0J+bj4qikJvCUec9FwnjM
         AgugnHgvQfsLdKK6AQQ2J3Vovdy15VCIFBJuwoBwVjmSM3GNQhcrPOvljeT0JEwSDPfX
         Uwq4bJ//sUzAZb8ZDdYdC8v3GBNsZKDs9gQqAt+DDNiQRhRMc8+DXMs+NaBmAxlIG7mN
         o5NWN2EQFfyGzYguwobX+9zWL5Qi0Mknxf1RFxV1dl4VRJZa1G3OUwlf1XFAE+t31IdW
         VPWzdFA1dYEfc/zfhLBYDxBLktDZBC49n1V0y7WZ4ecp9equgCC/blYsZnVUUyltJ30c
         tGxw==
X-Gm-Message-State: AOAM532O9RPEuqpm7+fsK3RLJ32rCFxB+DbC3yX86h0w3TSEFzbn/NRY
        6laOezp85iuTl6wfm5KsRNA=
X-Google-Smtp-Source: ABdhPJzWOjzXclyesGv788y3fagM+2/3MU0UiuzRtlkV02ZwL0HJsm/f46jIbXWzQNfa6GO3uB3Bvw==
X-Received: by 2002:a17:90b:3007:: with SMTP id hg7mr3220360pjb.66.1629443841497;
        Fri, 20 Aug 2021 00:17:21 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id u21sm5717544pfh.163.2021.08.20.00.17.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Aug 2021 00:17:21 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next 0/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG
Date:   Fri, 20 Aug 2021 15:17:10 +0800
Message-Id: <20210820071712.52852-1-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to be able to identify netns from sk_msg hooks
to accelerate local process communication form different netns.

Xu Liu (2):
  bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG
  selftests/bpf: Test for get_netns_cookie

 net/core/filter.c                             | 14 +++++
 .../selftests/bpf/prog_tests/netns_cookie.c   | 57 ++++++++++++-------
 .../selftests/bpf/progs/netns_cookie_prog.c   | 55 ++++++++++++++++--
 3 files changed, 102 insertions(+), 24 deletions(-)

-- 
2.28.0

