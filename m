Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CA6394941
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhE1XzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE1XzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BE6C061574;
        Fri, 28 May 2021 16:53:37 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id e15so2367086plh.1;
        Fri, 28 May 2021 16:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvJezP1OUC3ZJjNfxMVyeYkO20B51aee8v9MzauGcAE=;
        b=hAUqM8ZuVfv8WFQfZGwl04ptFojMasJOp9ojC6uezHaSgX8JHMwXNao9kDr7NN9IJJ
         Mx/hgwH43dEUZqpuM5aatlVqUpffr47PvU2t5ZxyrYTOFf0IFGD+Xl0K+k341cySY+nf
         eaNdLaB/4lDRgm55sKZcLYqwq9q7n0qSEmPY489PtjYDS/F4eydp3j9qNM7j2QN1AIUU
         zZogQFnJ+c8j8CcEp2jqsRZ4Ovl9TJy8R8MWo3BXfbJnEIhLAajrOSPo1nDzvCi2yLNr
         F9mNyseCM8YJIqJGgbF72jqWe933vg+dViNXTsL9RvUr572XYLgsycbPLkwyxAnp3V2X
         tJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvJezP1OUC3ZJjNfxMVyeYkO20B51aee8v9MzauGcAE=;
        b=YGpbhnFdgPBUxEVQzH5XZgfDz40j3BwxW9FIMH4iI1taEy14IN9ELSILoIUg2IcFt8
         50gpVoLUfqInCmoK+w8UaZ3HpjwXwtv8iqEeu7vlAg46rh/6yL0LXJTrg2YgsXIWPl83
         J8vzdeU+O0ua/1vRNExuV+8s7UwQPkPGDJuguXmYv9BIlNiuHfTQ3JAPOdlKniD4Xm7X
         fvZ/ZKEgLdEJhuV6pxTSwvhDLlBSA9ywEQ1sw7hZkmy/JJhum341T+2sZUbjRF/TaY6D
         8R1iEQ7/4jZLqpIDTTt7W5xNUJoWdi4RobG2uOWktj0BDRVbhNLTjMJVuIcoolytejtJ
         HDjA==
X-Gm-Message-State: AOAM530SK7sXGeA7NLfFLKi18r5D/e+or1qRTGzzWTFAkP9Cv2AlEBdi
        1jp+NOCzNS7HU/7c7YE34X9P/CZv9ZE=
X-Google-Smtp-Source: ABdhPJxyloEHGeMblQS+hSMX2nwuug/9NDd/5HKdTL7m5XlmhsSzxI41w1Rj/b22VraDlhqt0vDzYg==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr7097628pjb.94.1622246015975;
        Fri, 28 May 2021 16:53:35 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id s23sm5101207pjg.15.2021.05.28.16.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:35 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 00/15] Improve XDP samples usability and output
Date:   Sat, 29 May 2021 05:22:35 +0530
Message-Id: <20210528235250.2635167-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This first version is primarily for collecting feedback on the changes being made.

There is currently inconsistency between output of some XDP samples, for
instance xdp_redirect_cpu and xdp_monitor are fairly featureful but the first
misses support for XDP tracepoints, and both miss support for showing the source
of xdp redirection errors.

Some others like xdp_redirect and xdp_redirect_map are even worse in that they only the packet count.

This series consolidates the common core of all these samples into a single
object that can be linked into all these samples, with support for the
following:

* Received packet statistics (counted from the xdp redirect program)
* Redirect success tracepoint statistics (has to be enabled explicitly)
* Redirect error tracepoint statistics (with support to report exact errno that was
  hit in the kernel)
* XDP cpumap enqueue/kthread tp stats (only relevant for xdp_redirect_cpu)
* XDP devmap_xmit tp stats (only relevant in native xdp redirect mode)
* XDP exception tp statistics (with support for per XDP action statistics)
* ... and a fair amount of cleanups everywhere

All tracepoints have also been converted to use raw_tp infrastructure, in an
effort to reduce overhead when they are enabled. A tracepoint is only enabled
when it is required.

For now, the series has only converted xdp_monitor, xdp_redirect_map, and
xdp_redirect_cpu. Once there is general agreement on the approach, it can be
extended to xdp_redirect, xdp_redirect_multi, and xdp_rxq_info in a subsequent
revision.

Explanation of the output:

There is now a terse output mode by default that shows primarily four fields:
  rx/s     Number of packets received per second
  redir/s  Number of packets successfully redirected per second
  error/s  Aggregated count of errors per second (including dropped packets)
  xmit/s   Number of packets transmitted on the output device per second

Some examples:
 ; sudo ./xdp_redirect_map veth0 veth1 -s
Redirecting from veth0 (ifindex 15; driver veth) to veth1 (ifindex 14; driver veth)
veth0->veth1                    0 rx/s                  0 redir/s               0 error/s               0 xmit/s
veth0->veth1            9,998,660 rx/s          9,998,658 redir/s               0 error/s       9,998,654 xmit/s
...

There is also a verbose mode, that can also be enabled by default using -v (--verbose).
The output mode can be switched dynamically at runtime using Ctrl + \ (SIGQUIT).

To make the terse output more useful, the errors that occur are expanded inline
(as if verbose mode was enabled) to let the user pin down the source of the
problem without having to clutter output (or possibly miss it).

For instance, let's consider a case where the output device link state is set to
down while redirection is happening:

[...]
veth0->veth1           24,503,376 rx/s                  0 error/s      24,503,372 xmit/s
veth0->veth1           25,044,775 rx/s                  0 error/s      25,044,783 xmit/s
veth0->veth1           25,263,046 rx/s                  4 error/s      25,263,028 xmit/s
  redirect_err                  4 error/s
    ENETDOWN                    4 error/s
[...]

This is how the error is expanded when it occurs. If there is more than one
errno (say when watching using xdp_monitor), all of them will be expanded
inline. The sample holds for xdp_exception.

Even when we expand errors in terse mode, we don't show the per-CPU stats. This
is only meant to be displayed in verbose mode.

Another usability improvement is letting the user jump from the tracepoint field
(the text that displays the name of the tracepoint event) directly to points in
the kernel where the tracepoint is triggered. This is done by means of making
the text a hyperlink on capable terminals. The tool is also smart enough to add
the running kernel's major version in the link.

An example of how a complete xdp_redirect_map session would look:

Redirecting from veth0 (ifindex 15; driver veth) to veth1 (ifindex 14; driver veth)
veth0->veth1                    0 rx/s                  0 error/s               0 xmit/s
veth0->veth1           11,626,046 rx/s                  0 error/s      11,626,059 xmit/s
^\
veth0->veth1           13,621,785 rx/s                  0 error/s      13,621,782 xmit/s
  receive total        13,621,785 pkt/s                 0 drop/s                0 error/s
          cpu:3        13,621,785 pkt/s                 0 drop/s                0 error/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  devmap_xmit total    13,621,782 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg
              cpu:3    13,621,782 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg

veth0->veth1           13,168,898 rx/s                  0 error/s      13,168,901 xmit/s
  receive total        13,168,898 pkt/s                 0 drop/s                0 error/s
          cpu:3        13,168,898 pkt/s                 0 drop/s                0 error/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  devmap_xmit total    13,168,901 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg
              cpu:3    13,168,901 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg

veth0->veth1           13,427,862 rx/s                  0 error/s      13,427,860 xmit/s
  receive total        13,427,862 pkt/s                 0 drop/s                0 error/s
          cpu:3        13,427,862 pkt/s                 0 drop/s                0 error/s
  redirect_err                  0 error/s
  xdp_exception                 0 hit/s
  devmap_xmit total    13,427,860 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg
              cpu:3    13,427,860 xmit/s                0 drop/s                0 drv_err/s          2.00 bulk_avg

^C
Totals
  Packets received    : 51,844,591
  Average packets/s   : 5,184,459
  Packets dropped     : 0
  Errors recorded     : 0
  Packets transmitted : 51,844,602
  Average transmit/s  : 5,184,460

The xdp_redirect tracepoint (for success stats) needs to be enabled explicitly using --stats/-s.

Kumar Kartikeya Dwivedi (15):
  samples: bpf: fix a couple of NULL dereferences
  samples: bpf: fix a couple of warnings
  samples: bpf: split out common bpf progs to its own file
  samples: bpf: refactor generic parts out of xdp_redirect_cpu_user
  samples: bpf: convert xdp_redirect_map to use xdp_samples
  samples: bpf: prepare devmap_xmit support in xdp_sample
  samples: bpf: add extended reporting for xdp redirect error
  samples: bpf: add per exception reporting for xdp_exception
  samples: bpf: convert xdp_monitor to use xdp_samples
  samples: bpf: implement terse output mode and make it default
  samples: bpf: print summary of session on exit
  samples: bpf: subtract time spent in collection from polling interval
  samples: bpf: add new options for xdp samples
  samples: bpf: add documentation
  samples: bpf: convert xdp_samples to use raw_tracepoints

 samples/bpf/Makefile                    |    8 +-
 samples/bpf/cookie_uid_helper_example.c |   12 +-
 samples/bpf/tracex4_user.c              |    2 +-
 samples/bpf/xdp_monitor_kern.c          |  253 +-----
 samples/bpf/xdp_monitor_user.c          |  645 +-------------
 samples/bpf/xdp_redirect_cpu_kern.c     |  213 +----
 samples/bpf/xdp_redirect_cpu_user.c     |  608 ++-----------
 samples/bpf/xdp_redirect_map_kern.c     |   23 +-
 samples/bpf/xdp_redirect_map_user.c     |  170 ++--
 samples/bpf/xdp_redirect_user.c         |    4 +-
 samples/bpf/xdp_sample_kern.h           |  263 ++++++
 samples/bpf/xdp_sample_user.c           | 1089 +++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h           |  185 ++++
 13 files changed, 1764 insertions(+), 1711 deletions(-)
 create mode 100644 samples/bpf/xdp_sample_kern.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

-- 
2.31.1

