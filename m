Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0232C4BF2E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:22 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50277 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbfFSRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:20 -0400
Received: by mail-pf1-f201.google.com with SMTP id h27so5601536pfq.17
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PScmwSK+K9IB8yZqW06OWrhD6812WTEkgOnr9yWmmf4=;
        b=uoeCvod6FOweAnFCi8uKAsSqTqMOVKMo480pMqs1UqsAuBqt1yBMI2foIIN8yGtprh
         Jaii1U0guT2dGKDzdSgDqjAyHhahHyr+3k1TJ7sYRWSItqYBi7yzp9rDM0v5Q+hrolV1
         fImDskWlMiKb5wK2oUCM+AaZCRQfQi5BAU3BX65fdV0XnOlrnIl7zcrcDIz4UC/Y9lzQ
         4SOwM+GF4NXLHod3kBCFk9oObybuNgQ2bxQGvU/JQehNxRd1OTPBETwN6HLYvCvIf8kS
         f8VRxrxodbGBgv8A9GwNgTs3Q8ckKnkMEwaGGSTswudA2xtAS+pnwI5i/YYlvzDWqGml
         m3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PScmwSK+K9IB8yZqW06OWrhD6812WTEkgOnr9yWmmf4=;
        b=XcMp5GX/mERxUoJ6NnMCYIwukMnWQncs8xcZIdoYKRyG3SIBsDlajtXrgqAmbdtQmL
         JfnSG7kZ5it/mTknsbIriABTGLtpea/vIHZsY/PKpj0CkuIPYOPAdQXAbRy88ohj7pcJ
         ObKMj2VuQFrSEwDPsjmWz33/y5nK2uTpj59G8ZuKbcNnRQeBGd+ChZLgOdgjE8W4klX0
         3R7RZghz7p+dmnTbmJHZzRCq8pAAz+UiqsurqP9UV0sGlZI+nnRfX6uSwloHgTZRP/qQ
         EqSBiZg7xc0oXD2MJAEyYmMk17fDFGE9JGE+/oMesS1pzPzDQwpw2lPIf80Pfo3qWY8A
         nqcQ==
X-Gm-Message-State: APjAAAVSrw2gCJEMn3bpD1xjQFq/8lm8lxItAJBArUQk1fKXQgOeR3F5
        EBQBaDZMwtThPmjC8y42E0sKqrqnX35zoZkqp3sBCt3XF3buyLYt/qKuMQiUXQA3PBo2buZFFj9
        vCOuKu6bfKR4toHQhzBcNDynubYfdbXj+ExEx9S+XuKsVDpA4MSI8FQ==
X-Google-Smtp-Source: APXvYqzX6v9kNbUYsz9kAlRSqtMbKJlqZ9rQv0wSGGLfvBinv+8HnUGcJxdcvG2AbF9Mkgl+3IqOX7o=
X-Received: by 2002:a63:1303:: with SMTP id i3mr8677226pgl.202.1560963619380;
 Wed, 19 Jun 2019 10:00:19 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:56 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-9-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 8/9] bpf: add sockopt documentation
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide user documentation about sockopt prog type and cgroup hooks.

v7:
* add description for retval=0 and optlen=-1

v6:
* describe cgroup chaining, add example

v2:
* use return code 2 for kernel bypass

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/index.rst               |  1 +
 Documentation/bpf/prog_cgroup_sockopt.rst | 82 +++++++++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index d3fe4cac0c90..801a6ed3f2e5 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -42,6 +42,7 @@ Program types
 .. toctree::
    :maxdepth: 1
 
+   prog_cgroup_sockopt
    prog_cgroup_sysctl
    prog_flow_dissector
 
diff --git a/Documentation/bpf/prog_cgroup_sockopt.rst b/Documentation/bpf/prog_cgroup_sockopt.rst
new file mode 100644
index 000000000000..24985740711a
--- /dev/null
+++ b/Documentation/bpf/prog_cgroup_sockopt.rst
@@ -0,0 +1,82 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================
+BPF_PROG_TYPE_CGROUP_SOCKOPT
+============================
+
+``BPF_PROG_TYPE_CGROUP_SOCKOPT`` program type can be attached to two
+cgroup hooks:
+
+* ``BPF_CGROUP_GETSOCKOPT`` - called every time process executes ``getsockopt``
+  system call.
+* ``BPF_CGROUP_SETSOCKOPT`` - called every time process executes ``setsockopt``
+  system call.
+
+The context (``struct bpf_sockopt``) has associated socket (``sk``) and
+all input arguments: ``level``, ``optname``, ``optval`` and ``optlen``.
+
+BPF_CGROUP_SETSOCKOPT
+=====================
+
+``BPF_CGROUP_SETSOCKOPT`` is triggered *before* the kernel handling of
+sockopt and it has mostly read-only context (it can modify only ``optlen``).
+This hook has access to cgroup and socket local storage.
+
+If BPF program sets ``optlen`` to -1, the control will be returned
+back to the userspace after all other BPF programs in the cgroup
+chain finish (i.e. kernel ``setsockopt`` handling will *not* be executed).
+
+Note, that the only acceptable value to set to ``optlen`` is -1. Any
+other value will trigger ``EFAULT``.
+
+Return Type
+-----------
+
+* ``0`` - reject the syscall, ``EPERM`` will be returned to the userspace.
+* ``1`` - success, continue with next BPF program in the cgroup chain.
+
+BPF_CGROUP_GETSOCKOPT
+=====================
+
+``BPF_CGROUP_GETSOCKOPT`` is triggered *after* the kernel handing of
+sockopt. The BPF hook can observe ``optval``, ``optlen`` and ``retval``
+if it's interested in whatever kernel has returned. BPF hook can override
+the values above, adjust ``optlen`` and reset ``retval`` to 0. If ``optlen``
+has been increased above initial ``setsockopt`` value (i.e. userspace
+buffer is too small), ``EFAULT`` is returned.
+
+Note, that the only acceptable value to set to ``retval`` is 0 and the
+original value that the kernel returned. Any other value will trigger
+``EFAULT``.
+
+Return Type
+-----------
+
+* ``0`` - reject the syscall, ``EPERM`` will be returned to the userspace.
+* ``1`` - success: copy ``optval`` and ``optlen`` to userspace, return
+  ``retval`` from the syscall (note that this can be overwritten by
+  the BPF program from the parent cgroup).
+
+Cgroup Inheritance
+==================
+
+Suppose, there is the following cgroup hierarchy where each cgroup
+has ``BPF_CGROUP_GETSOCKOPT`` attached at each level with
+``BPF_F_ALLOW_MULTI`` flag::
+
+  A (root, parent)
+   \
+    B (child)
+
+When the application calls ``getsockopt`` syscall from the cgroup B,
+the programs are executed from the bottom up: B, A. First program
+(B) sees the result of kernel's ``getsockopt``. It can optionally
+adjust ``optval``, ``optlen`` and reset ``retval`` to 0. After that
+control will be passed to the second (A) program which will see the
+same context as B including any potential modifications.
+
+Example
+=======
+
+See ``tools/testing/selftests/bpf/progs/sockopt_sk.c`` for an example
+of BPF program that handles socket options.
-- 
2.22.0.410.gd8fdbe21b5-goog

