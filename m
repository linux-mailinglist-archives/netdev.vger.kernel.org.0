Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F35288DA4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgJIQEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388882AbgJIQEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:04:08 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21251C0613D2;
        Fri,  9 Oct 2020 09:04:08 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so7495410pgo.13;
        Fri, 09 Oct 2020 09:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8lTa99iWO0a2K9Iybyyb+FKhgVizHVBCh27esTtc2JU=;
        b=skevwq49SIl7oBdoiTuWPTlwSQrbHMu/54O3986/CqOWkjqSl+FTLNofcQNrshw5tT
         GHg+gViYgO8WeshQgMnYK0A84iHWX2AvRpIzmkz6P/2allQ/4QGHQdOiR40gPcqfXdU+
         U5OqOxISvmfGikMDG5tm5ExOgaohIhmcJY1FBqn7WkvTp0TG4f4g4Jj0L5VJuaX+GAzS
         SUpgDac988t4/4IFGfIgyYIRfHq3ih+vVGjyWfGtjUO9H4EvXwgqhGJ3tJhdrXNzHuvs
         3BY5HXIO6vXh1jTB2FdNktpCj5NbY+J+ZTeYUTLfMb8uXMZWh5HMXUr4ZjnrSYohR5nZ
         S9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8lTa99iWO0a2K9Iybyyb+FKhgVizHVBCh27esTtc2JU=;
        b=uQrfxpo6Ub7rWqwb/aMlqHMGxN32RCl2JYyJjNqH+19Dtr4hsUAEziGhB0laK/fj1G
         pGuI+BTLxkz1gNkOjQvHzpS+x7S1bk5HKSTec5T/3Fzpxgd5qPvpWI9ucLkRm0tmO3Mt
         ZiBysZMrfNWaIfZKO9eIXcdogvwqmuQII8RcY1ywL99mjX+m+uqiD21tRrPLJtVG52RT
         PAOmD4IJ7r239kiA5cm6sOJQ4iSSsizMxiyBAIEi/HEmmOztlMwhewC9pMKKsTu8pJR4
         fQcX+VSFjJYEHYVzoJEViulSCXK85S80VI16SLoZlOvMCgCrIkB8Qn7jZ+54T8r3Z+EV
         ek3w==
X-Gm-Message-State: AOAM533OVPXoMsplBc5fHJXRHayO9PQyYYy9fOTgxIu/nKWbhxQQSXY7
        yAkKP6DBcqx3rSttmU9aFdzJmryYR3hb
X-Google-Smtp-Source: ABdhPJzfTNwC8j2uylfZGKLGVWF1L8w6rRgoCVCz3NIpcvXx7KtjgaCFDxqnCjj9AtCCccf8+kWdug==
X-Received: by 2002:a17:90b:3882:: with SMTP id mu2mr5533643pjb.29.1602259447565;
        Fri, 09 Oct 2020 09:04:07 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id y19sm11287435pfp.52.2020.10.09.09.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 09:04:07 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 0/3] samples: bpf: Refactor XDP programs with libbpf
Date:   Sat, 10 Oct 2020 01:03:50 +0900
Message-Id: <20201009160353.1529-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid confusion caused by the increasing fragmentation of the BPF
Loader program, this commit would like to convert the previous bpf_load
loader with the libbpf loader.

Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
program is much easier. bpf_program__attach_tracepoint manages the
enable of tracepoint event and attach of BPF programs to it with a
single interface bpf_link, so there is no need to manage event_fd and
prog_fd separately.

And due to addition of generic bpf_program__attach() to libbpf, it is
now possible to attach BPF programs with __attach() instead of
explicitly calling __attach_<type>().

This patchset refactors xdp_monitor with using this libbpf API, and the
bpf_load is removed and migrated to libbpf. Also, attach_tracepoint()
is replaced with the generic __attach() method in xdp_redirect_cpu.
Moreover, maps in kern program have been converted to BTF-defined map.

Daniel T. Lee (3):
  samples: bpf: Refactor xdp_monitor with libbpf
  samples: bpf: Replace attach_tracepoint() to attach() in
    xdp_redirect_cpu
  samples: bpf: refactor XDP kern program maps with BTF-defined map

 samples/bpf/Makefile                |   4 +-
 samples/bpf/xdp_monitor_kern.c      |  60 ++++++------
 samples/bpf/xdp_monitor_user.c      | 144 +++++++++++++++++++++-------
 samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++-------------
 samples/bpf/xdp_sample_pkts_kern.c  |  14 ++-
 samples/bpf/xdp_sample_pkts_user.c  |   1 -
 6 files changed, 211 insertions(+), 150 deletions(-)

-- 
2.25.1

