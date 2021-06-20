Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10C3AE11C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 01:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFTXfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhFTXfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:35:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E04C061574;
        Sun, 20 Jun 2021 16:33:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e22so6481679pgv.10;
        Sun, 20 Jun 2021 16:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1lVW3HMvV7PGKEOE4wSYmG/nnlk0/5O4ry2knqqF6jc=;
        b=N92a0qghC+n7kcaKu17vH/+n1v4qj2e4RYQolZ9Zu6awz3mwtWMHrR5NN4XU3L6gwn
         d5AB18E710BWrDI/DBWIyayJ71tj/G6/Cc5yOnhD6y8o9lnBvSzZJPGhKm27qoOpsz0z
         r2LSDZF3mCUKB2Asu/ZZfykrCUlwbBZx55Cs6RdN2k8a0FDqfruNjveF87ZpiWKsJFGW
         a9dlOZoHe0nHhYkGjclTi7+MkvWVw9JrqMjTzU3O4XQyvBS8y58EelnkEY44tVYj2fdY
         AGH8eneBPGX0gD4mbD4xrd0Fy4vqhOvXu7aauekCQtZrLMzNrvcUEUWDfMpkj/YJorIy
         mKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1lVW3HMvV7PGKEOE4wSYmG/nnlk0/5O4ry2knqqF6jc=;
        b=tGOIvXWmjwwWTl0xZgWbehhWDjJUT55utGNExuTNo03Wf5Y20xt9WSJQO/ls+7l+VK
         r5KbrP1I1q6rfZO0AX6XoQ+m0dbuAnHRf4QJPySFl5OfApP+CbCmLXdC9J0siUqL1ld6
         wOOisgH0or4ofHhqB7H3vCtWsP4LMtWTX4ZGBxSM2y6a+Dx3rj4YKl0Tf+YjD/pk61Qn
         K+7BIIqddRTqrRBDAn/fMiWhcuwvdQHYlujZGMzU28z05hum8ZBHMbBQ3yE99x8KT2f7
         frPrrKxGNJqyLRIWXcxg+dqlYjLnsE5jiH9IidyYCBZtkJgcOo8dbeDHxHDPEqOd/IW/
         ZVyw==
X-Gm-Message-State: AOAM532DOQDtkbzP/Pc3ZtclBAAMO69InsmOn+ja7xfD+ksFcNn1tExg
        fr+mXPLBRpbiiCxoM9X8WjUIRWRR+5Y=
X-Google-Smtp-Source: ABdhPJyOkMhRCD6QjbyA0BO8C1A04kPejkFyvtdz4oCDwGGevQmh3ZbnCsEB9dR9g6WbTPznOuRI2g==
X-Received: by 2002:a62:8647:0:b029:302:4642:ae52 with SMTP id x68-20020a6286470000b02903024642ae52mr6139476pfd.7.1624232010753;
        Sun, 20 Jun 2021 16:33:30 -0700 (PDT)
Received: from localhost ([2409:4063:4d19:cf2b:5167:bcec:f927:8a69])
        by smtp.gmail.com with ESMTPSA id e24sm14547102pgi.17.2021.06.20.16.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 16:33:30 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 0/4] Generic XDP improvements
Date:   Mon, 21 Jun 2021 05:01:56 +0530
Message-Id: <20210620233200.855534-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes some improvements to generic XDP mode and brings it
closer to native XDP. Patch 1 splits out generic XDP processing into reusable
parts, patch 2 implements generic cpumap support (details in commit) and patch 3
allows devmap bpf prog execution before generic_xdp_tx is called.

Patch 4 just updates a couple of selftests to adapt to changes in behavior (in
that specifying devmap/cpumap prog fd in generic mode is now allowed).

Kumar Kartikeya Dwivedi (4):
  net: core: split out code to run generic XDP prog
  net: implement generic cpumap
  bpf: devmap: implement devmap prog execution for generic XDP
  bpf: update XDP selftests to not fail with generic XDP

 include/linux/bpf.h                           |   8 +
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  10 +-
 kernel/bpf/cpumap.c                           | 151 ++++++++++++++++--
 kernel/bpf/devmap.c                           |  42 ++++-
 net/core/dev.c                                |  86 ++++++----
 net/core/filter.c                             |   6 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |   4 +-
 .../bpf/prog_tests/xdp_devmap_attach.c        |   4 +-
 9 files changed, 255 insertions(+), 58 deletions(-)

--
2.31.1

