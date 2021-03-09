Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB793322BE
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhCIKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhCIKNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 05:13:43 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CE9C06174A;
        Tue,  9 Mar 2021 02:13:43 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x7so5718992pfi.7;
        Tue, 09 Mar 2021 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riT0phGYjGUHW/YLJihzIjgFeb+VWCaERoM8ePBRDOA=;
        b=AhkO/Lrmv79j6kKjkY/uNgSZLAss9RRQ5IiYWFc7VB1yeVbGURdPfW1DzzllZVQMpj
         wKV1qhkhWLenzKNvux5tBDG5ynUpl7jhdmQgvq4qiyIURY7jK0KzAnqsp5kvVAe+OPM5
         l/u8wEYNkSq+YFZT0ZgsP9x+ysQvgpuzYSeY7Hfn4LuknU2NUj2yr8jGCFyQV0OZuoll
         2f/UnL0dD+CJstPUNcGTayUzpcVKdMKudF/w+0e+yRM5FC60o1wxdCobe9kcudeWr9tR
         Uyy9kYPYnqEhXUlQ/LkQ9ZFVa6lFhmfinrz8Y237GoM/+Qo7nMexfOOLcHUMy08dbFrX
         nx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riT0phGYjGUHW/YLJihzIjgFeb+VWCaERoM8ePBRDOA=;
        b=Ps4PhznamJcjPs7BWi9jrh+IaoswdqKvzZFDwUXQUHWYoTqfmKAXWPy/zyUigRQqQ2
         5hWV5PaBsyMEQrdPuHF7wuTyfb3R4qFkMuobAa1ghWIdB4nLzbwQBRNs1QAmeILiWFb9
         SXvuugWUtDcBKfspEA26EeXCEz9ieLmMZj6zLbO5dwqaA4gb7iHmJuonvp2+EBm6ezMc
         o9MmJsggn9BoxE5akAPBGqPoWzxXn+0KB+gHx8c79p5dR5xIN6NYcuNZt7Uh8K4TKTkd
         pYWAPronW64BFw41xQid3J4dl9IjJllqkIcK4caQOFVCPVvXxTjZFYgZ+wS2E8EPSwPP
         E3Nw==
X-Gm-Message-State: AOAM532u4zJ2EA7Vb0XF2dzT99Rrb+5/tIxbzbWbmA4F43aqbLwkHMzb
        wJzxaMoZR5U+w7IAAw+5Va/tzCEUYeY=
X-Google-Smtp-Source: ABdhPJzFKRtBQZ6ctRdIN8GdZrHRF/alzecWMXUs7GTh5yO/6vGbIugNDbb1a7iyGxsmdnNZmPoVMQ==
X-Received: by 2002:a65:5a4a:: with SMTP id z10mr7153788pgs.240.1615284822589;
        Tue, 09 Mar 2021 02:13:42 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 35sm12060426pgr.14.2021.03.09.02.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 02:13:42 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Tue,  9 Mar 2021 18:13:17 +0800
Message-Id: <20210309101321.2138655-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous patches[1]. The reason is that Daniel think the exclude map
implementation is missing proper bond support in XDP context. And there
is a plan to add native XDP bonding support. Adding a exclude map in the
helper also increase the complex of verifier and has draw back of performace.

So I was suggested to just extend xdp_redirect_map with broadcast support,
which should be more easier and clear. Sorry to make you take a long time
on previous patches review and need to help review this one again.

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com

v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  16 +
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/devmap.c                           | 253 +++++++++++----
 net/core/filter.c                             |  74 ++++-
 net/core/xdp.c                                |  29 ++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  96 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 187 +++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 14 files changed, 1253 insertions(+), 68 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.2

