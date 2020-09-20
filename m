Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD4271273
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 07:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgITFBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 01:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITFBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 01:01:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276E0C061755;
        Sat, 19 Sep 2020 22:01:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c3so5185901plz.5;
        Sat, 19 Sep 2020 22:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FysHceV0Ezu2zKbdfFpCvmEsXP+3W86Aob75ez9De2Y=;
        b=eAttXr5HM6Y3IHVJRfEzk6O0TEjZmgHXTnvg2i+6zTzKYmjgxv52SGG+7ZH1sZEvMA
         KLBrICH1gO+PjAUB+RynzFQWR9OyTg0TrygruHG9mNY3CSxaVYHzDCy/4s6pjf4mdrMx
         3inPrENqOslqstNH6a9A3YS45ye5Z1XOoRAOAavfOfNOZzpjCFhr1RblxXB0qs/LOmPW
         f0CzmCGYsqBw2yQFyJPM9k17dQ8gjSeTjs0N+1tlSnfuKU2vok7nwCtpa5OsEavFNjU5
         RWAgIl3LKe0QRjRi+21OyDCyk5CMxR07ysnzJ0EqDNCna2GhMiSsAsSc8cIavQkkOjg5
         O/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FysHceV0Ezu2zKbdfFpCvmEsXP+3W86Aob75ez9De2Y=;
        b=tFr4EHG4djgCOEevA/VIsHiaKnivtqte08MW3Ta2narvEWMtg8VwtONYlFw/kF/0tN
         NMqxm5Eqz+ha09A8Yb9CD+DKfsQi8ZyESQsBq6FdFmVWmuJIJMfx2hlI+YSbosNU3cF3
         7xaKBTzsAGlrw/uFJt+Tpi+eLaqJiVDYQU3XaXlZx28jN+u1eY7PYwM3aeFgHWdJWNfY
         PMfTPlLr95aSsIG2g8WZ4IgAoY3dfLX0tWh3cCqXcKREpZbbjVWLLru2uchS1yjSGSXF
         rIQMqFypEXo5VXApNhPcVh/VIo22esLw1rlHGt255TFZdU+qViuTaGsrRIgz1AFYxbdC
         YrbQ==
X-Gm-Message-State: AOAM532AapIqVJKA/zAbUbLpJOEbxBgoQRNyC899UiYBxnNmEf6p6xzO
        UYUvl0qH6z5rRxZIMzXyl1k=
X-Google-Smtp-Source: ABdhPJzu7gwR+TqMjibgfF+A/imswO4mYl45q2C2gr0anScvdd9IMOXMxnEF6Q6y6lDjE1a/+gKWLQ==
X-Received: by 2002:a17:90a:ca03:: with SMTP id x3mr19894716pjt.92.1600578114532;
        Sat, 19 Sep 2020 22:01:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:d88d:3b4f:9cac:cf18])
        by smtp.gmail.com with ESMTPSA id w19sm8432556pfq.60.2020.09.19.22.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 22:01:53 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH bpf v1 0/3] fix BTF usage on embedded systems
Date:   Sat, 19 Sep 2020 22:01:32 -0700
Message-Id: <cover.1600417359.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've been experimenting with BPF and BTF on small, emebedded platforms
requiring cross-compilation to varying archs, word-sizes, and endianness.
These environments are not the most common for the majority of eBPF users,
and have exposed multiple problems with basic functionality. This patch
series addresses some of these issues.

Enabling BTF support in the kernel can sometimes result in sysfs export
of /sys/kernel/btf/vmlinux as a zero-length file, which is still readable
and seen to leak non-zero kernel data. Patch #1 adds a sanity-check to
avoid this situation.

Small systems commonly enable LD_DEAD_CODE_DATA_ELIMINATION, which causes
the .BTF section data to be incorrectly removed and can trigger the problem
above. Patch #2 preserves the BTF data.

Even if BTF data is generated and embedded in the kernel, it may be encoded
as non-native endianness due to another bug [1] currently being worked on.
Patch #3 lets bpftool recognize the wrong BTF endianness rather than output
a confusing/misleading ELF header error message.

Patches #1 and #2 were first developed for Linux 5.4.x and should be
backported if possible. Feedback and suggestions for improvement are
welcome!

Thanks,
Tony

[1] https://lore.kernel.org/bpf/CAPGftE8ipAacAnm9xMHFabXCL-XrCXGmOsX-Nsjvz9wnh3Zx-w@mail.gmail.com/

Tony Ambardar (3):
  bpf: fix sysfs export of empty BTF section
  bpf: prevent .BTF section elimination
  libbpf: fix native endian assumption when parsing BTF

 include/asm-generic/vmlinux.lds.h | 2 +-
 kernel/bpf/sysfs_btf.c            | 6 +++---
 tools/lib/bpf/btf.c               | 6 ++++++
 3 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.25.1

