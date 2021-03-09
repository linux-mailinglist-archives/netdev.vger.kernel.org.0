Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CE0331FD1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 08:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCIHal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 02:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCIHa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 02:30:26 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52329C06174A;
        Mon,  8 Mar 2021 23:30:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o10so8184201pgg.4;
        Mon, 08 Mar 2021 23:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNy1ToCtx/RANSPHDekwcnEbT8sMQUUwZ1/unY2fT4k=;
        b=GyD4+gKQRNyL0WtftiqTlJZxs+YNxdPynwewodmRlvdwLCjvXTYy5q1EzUDvSW+JE0
         sdcyjaOGkfasuWk8XyKT7NJK5k3pdwlrU745Z9s7pO9MdNCBnUb8X/aTpC4bWfLIgi08
         J0m6NkqlfqkYOyYrSVA8SWj3bIox3TnZR1/1nGjFyhq4OOSW0/G6jhthvrp6sAANy8Xb
         O7NKkvg1nitO/3kvRkHA1h4D4FYmPH56hcZ7JetNjB9h2zLGIhaDFVXiMGyVZOPFK8U0
         Yc9NmGD8Y60m6d2KRwtcNaWiDgT2k8C1R+75l9I/mE5VsPKSM5Jlis2evQU7j39zf0KK
         arRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNy1ToCtx/RANSPHDekwcnEbT8sMQUUwZ1/unY2fT4k=;
        b=PAjViAVt97FTjxC9UYLRiuIPRpYgEapOlbwRYjoAJSYzBOb3Yhwm0d5TIKKqo0Kbwk
         orIagFj6uEN0BjI3yevaLQX4uDK4w030yCguzil3rqzy0awjCCaDx4UgyMcWEZWFbrT3
         8kFclvDck4+Qj7GLjY1IPifKC8Kbd4yCYZjQN1KrGAfkxaV4hhxl8I15C6jBWxfqQf07
         rsmtgnvrfgsu9uJ5RvGhXbd72MS9hGqiQtXZ/GSMSbXKO37fjGrke/mb+PpAmBKE/6f8
         X6OJM9Nn5s1GDrppnBfi/JDbcEtvdDUla5Z7S6h96cr/lYOo3s7nBWLPMnzVWw/ucsGg
         WRrg==
X-Gm-Message-State: AOAM532+0JacmbLjTDnriRnvGkB27irvyzqmzhC0EIER55xQdsRKwxEF
        0SDLcPusgF8VY/0fgav8BCaQzn1Gny8=
X-Google-Smtp-Source: ABdhPJxgrtEglzsrNQIWifw7URPEeGkn0Vhr2NNppsHo9ydxFzeHS4WsM80psLq5McmVxgkGeGuhSg==
X-Received: by 2002:a05:6a00:47:b029:1f7:ff05:c771 with SMTP id i7-20020a056a000047b02901f7ff05c771mr5997322pfk.29.1615275025642;
        Mon, 08 Mar 2021 23:30:25 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j3sm11521007pgk.24.2021.03.08.23.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 23:30:25 -0800 (PST)
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
Subject: [PATCH bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Tue,  9 Mar 2021 15:29:44 +0800
Message-Id: <20210309072948.2127710-1-liuhangbin@gmail.com>
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

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  16 +
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  16 +-
 kernel/bpf/devmap.c                           | 253 +++++++++++----
 net/core/filter.c                             |  74 ++++-
 net/core/xdp.c                                |  29 ++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  16 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  96 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 187 +++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 14 files changed, 1251 insertions(+), 68 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.2

