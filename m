Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA68251F4A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfFXXyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:54:19 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:33462 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbfFXXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:54:19 -0400
Received: by mail-vk1-f202.google.com with SMTP id 63so3339333vki.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aQiVt1v1ZspQwRYs4b3nRqt7OstkFgTd68CV7/bkhBE=;
        b=XvJQB8hWrOW/SRpeI4tK10iYplodRxP7G102eNBFBqwIMqTgenq6LtYA3UW7T7ITUh
         thRvMJiDtniUB1muyhRW4m0OusgO2K0NXGpZmryrjGn7XtYQmOVnLnrgGwwgyOWfShV8
         xfHcMGtR1GM/LLQqBhE/yjinnKHbkILzy1lRqSNTcUV6NAMQolBDUCJWyNRUMfNrmTQQ
         FiQQQBS7vYwvSmP8HHvCTyDerVit/r1FsvvzcJF4TwX2RPJk35qgc4KBiUp+F8o0SFdp
         XH5fcmKm4j9ciAseV8FHibjrvG6SYiePUrx1fypcNHazdghb88UFwh9fJBOco3mjJypH
         VNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aQiVt1v1ZspQwRYs4b3nRqt7OstkFgTd68CV7/bkhBE=;
        b=A1PVWk1Ftq1S9qyMLruSXLKJuMVk+u0DqUwJ+a3cKGhpO5tyvWODI/3SEysHP6aVfx
         s6IWJD1IQ1NABaz0UyeaP67Gxkdmy8i0mIHkOqFx9wSuE0FKerFrzrwS3W3P+RDAdtB0
         QhPfm16+0A+ZUGGA/27LCg+vPQUu3q+BouVhJlTkqWHOFPNekj5tCLvUZJzm9RNGf4zl
         Y5GDkQwUMeO8TbGSvNcUe6e0suREBU3lVqN6SeVyrk9EVAhNMYRb8E5s97b34j3uxfiG
         g9UIrTIh67+CTN12HBzQdgcdU5C2vPWUNLaMe7b/9aEMwjMD2yWcN0ji7JYZ3mkUE7io
         uIEQ==
X-Gm-Message-State: APjAAAXVN+CvCI2i2Gp7MdTX4PCy8T4PeSB77kMNU0wz1rTKO79gvgAt
        /dXtpgm0vFv8R1od39h2/n2M/uB0fG0pyWiK
X-Google-Smtp-Source: APXvYqyfoVxlgRd5tAjiNz4zlZpLlPBxbOYJd+sVBprlJOt9sCpkadgDf+EMfW+nT+HAQz7dmb4j1cWMKVLw0Nti
X-Received: by 2002:a67:ec8e:: with SMTP id h14mr49850337vsp.17.1561420458245;
 Mon, 24 Jun 2019 16:54:18 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:53:32 -0700
Message-Id: <20190624235334.163625-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v2 0/2] bpf: Allow bpf_skb_event_output for a few prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

*** BLURB HERE ***

allanzhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

