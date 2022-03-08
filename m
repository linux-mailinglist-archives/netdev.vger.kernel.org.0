Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC6A4D1B22
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbiCHO7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347697AbiCHO7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:59:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D129205E0
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646751491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFqilxT+lSZOOOZ98XwesoXOJ/SGZfcJgQSLbKjZtCg=;
        b=R1NE5ZEIPyFBFggJHkSKFdYCGuxR8ttQVTmRIWSR5OSNxirGiTjvO+2+pRYpcF8NPNXvNx
        +igGn5QDmVR+LwQayCnJ9qhbTr8HF9U3Q0NFDaZ2Op7hywaVxDHn0D//osig6rkKBX99Hw
        g3njikpVj4/pwx5aZ3h9h2RzVxY1SM0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-KVdnHGsmM3CxiRq4Z7OjMQ-1; Tue, 08 Mar 2022 09:58:10 -0500
X-MC-Unique: KVdnHGsmM3CxiRq4Z7OjMQ-1
Received: by mail-ej1-f69.google.com with SMTP id le4-20020a170907170400b006dab546bc40so5558478ejc.15
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 06:58:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFqilxT+lSZOOOZ98XwesoXOJ/SGZfcJgQSLbKjZtCg=;
        b=CiKMmNCIswtVrRFHnDkI6iQwKmwivwzNCKc04ioKZ4FABuJ3TNpFBRYtOYz1OxpQ19
         u7+888z/E9qNFJUxejTquEJI1h97Ody/V5JqL4pSDGVWTK2Se42D/OMuscfrtv8jZRRo
         CNznQbJvcInz9WCs1Aft+sTO+QDyt8yyxtfNDVERcCZlCiTzg33pHUCm7Vmu9ji/hj0T
         gXsqjmDxbNFncqxCMcUoFocV5an9NYruD9CjtaPpLqIQrKeQN3mbq0rbyXT/er73q+vs
         Rdnc+cbEq1s2GtA081Jvl8yOpbQNfyjpgtBKn+HLXAhWirgxsdvxLNq2lw3TAwilwY5h
         Xobg==
X-Gm-Message-State: AOAM533OU94QxaGiHNHOEs/yO46s+aI3TkHX+NEDSsZHCIPs+cduLTLm
        JxEZ92ou5Keyclh7pBotP1YU5kf0TewBh+xOWm2/8QIACzuW/+uc6akg7EEe4Jko+zNH99RKvro
        /39vlcEktvUZfvUCW
X-Received: by 2002:a17:907:961b:b0:6d9:acb0:5403 with SMTP id gb27-20020a170907961b00b006d9acb05403mr13442061ejc.568.1646751488362;
        Tue, 08 Mar 2022 06:58:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyT4bqTkb/KvZ/GIdppGkevRs1F3WAJIZxAs4m3ze4tcXMPUM+DQnZsFpkV+3EoTVc1IkbCw==
X-Received: by 2002:a17:907:961b:b0:6d9:acb0:5403 with SMTP id gb27-20020a170907961b00b006d9acb05403mr13441891ejc.568.1646751485821;
        Tue, 08 Mar 2022 06:58:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y6-20020a056402358600b004166413d27bsm1738953edc.97.2022.03.08.06.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:58:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8AA101928D4; Tue,  8 Mar 2022 15:58:03 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 2/5] Documentation/bpf: Add documentation for BPF_PROG_RUN
Date:   Tue,  8 Mar 2022 15:57:58 +0100
Message-Id: <20220308145801.46256-3-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220308145801.46256-1-toke@redhat.com>
References: <20220308145801.46256-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds documentation for the BPF_PROG_RUN command; a short overview of
the command itself, and a more verbose description of the "live packet"
mode for XDP introduced in the previous commit.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 Documentation/bpf/bpf_prog_run.rst | 117 +++++++++++++++++++++++++++++
 Documentation/bpf/index.rst        |   1 +
 2 files changed, 118 insertions(+)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst

diff --git a/Documentation/bpf/bpf_prog_run.rst b/Documentation/bpf/bpf_prog_run.rst
new file mode 100644
index 000000000000..4868c909df5c
--- /dev/null
+++ b/Documentation/bpf/bpf_prog_run.rst
@@ -0,0 +1,117 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Running BPF programs from userspace
+===================================
+
+This document describes the ``BPF_PROG_RUN`` facility for running BPF programs
+from userspace.
+
+.. contents::
+    :local:
+    :depth: 2
+
+
+Overview
+--------
+
+The ``BPF_PROG_RUN`` command can be used through the ``bpf()`` syscall to
+execute a BPF program in the kernel and return the results to userspace. This
+can be used to unit test BPF programs against user-supplied context objects, and
+as way to explicitly execute programs in the kernel for their side effects. The
+command was previously named ``BPF_PROG_TEST_RUN``, and both constants continue
+to be defined in the UAPI header, aliased to the same value.
+
+The ``BPF_PROG_RUN`` command can be used to execute BPF programs of the
+following types:
+
+- ``BPF_PROG_TYPE_SOCKET_FILTER``
+- ``BPF_PROG_TYPE_SCHED_CLS``
+- ``BPF_PROG_TYPE_SCHED_ACT``
+- ``BPF_PROG_TYPE_XDP``
+- ``BPF_PROG_TYPE_SK_LOOKUP``
+- ``BPF_PROG_TYPE_CGROUP_SKB``
+- ``BPF_PROG_TYPE_LWT_IN``
+- ``BPF_PROG_TYPE_LWT_OUT``
+- ``BPF_PROG_TYPE_LWT_XMIT``
+- ``BPF_PROG_TYPE_LWT_SEG6LOCAL``
+- ``BPF_PROG_TYPE_FLOW_DISSECTOR``
+- ``BPF_PROG_TYPE_STRUCT_OPS``
+- ``BPF_PROG_TYPE_RAW_TRACEPOINT``
+- ``BPF_PROG_TYPE_SYSCALL``
+
+When using the ``BPF_PROG_RUN`` command, userspace supplies an input context
+object and (for program types operating on network packets) a buffer containing
+the packet data that the BPF program will operate on. The kernel will then
+execute the program and return the results to userspace. Note that programs will
+not have any side effects while being run in this mode; in particular, packets
+will not actually be redirected or dropped, the program return code will just be
+returned to userspace. A separate mode for live execution of XDP programs is
+provided, documented separately below.
+
+Running XDP programs in "live frame mode"
+-----------------------------------------
+
+The ``BPF_PROG_RUN`` command has a separate mode for running live XDP programs,
+which can be used to execute XDP programs in a way where packets will actually
+be processed by the kernel after the execution of the XDP program as if they
+arrived on a physical interface. This mode is activated by setting the
+``BPF_F_TEST_XDP_LIVE_FRAMES`` flag when supplying an XDP program to
+``BPF_PROG_RUN``.
+
+The live packet mode is optimised for high performance execution of the supplied
+XDP program many times (suitable for, e.g., running as a traffic generator),
+which means the semantics are not quite as straight-forward as the regular test
+run mode. Specifically:
+
+- When executing an XDP program in live frame mode, the result of the execution
+  will not be returned to userspace; instead, the kernel will perform the
+  operation indicated by the program's return code (drop the packet, redirect
+  it, etc). For this reason, setting the ``data_out`` or ``ctx_out`` attributes
+  in the syscall parameters when running in this mode will be rejected. In
+  addition, not all failures will be reported back to userspace directly;
+  specifically, only fatal errors in setup or during execution (like memory
+  allocation errors) will halt execution and return an error. If an error occurs
+  in packet processing, like a failure to redirect to a given interface,
+  execution will continue with the next repetition; these errors can be detected
+  via the same trace points as for regular XDP programs.
+
+- Userspace can supply an ifindex as part of the context object, just like in
+  the regular (non-live) mode. The XDP program will be executed as though the
+  packet arrived on this interface; i.e., the ``ingress_ifindex`` of the context
+  object will point to that interface. Furthermore, if the XDP program returns
+  ``XDP_PASS``, the packet will be injected into the kernel networking stack as
+  though it arrived on that ifindex, and if it returns ``XDP_TX``, the packet
+  will be transmitted *out* of that same interface. Do note, though, that
+  because the program execution is not happening in driver context, an
+  ``XDP_TX`` is actually turned into the same action as an ``XDP_REDIRECT`` to
+  that same interface (i.e., it will only work if the driver has support for the
+  ``ndo_xdp_xmit`` driver op).
+
+- When running the program with multiple repetitions, the execution will happen
+  in batches. The batch size defaults to 64 packets (which is same as the
+  maximum NAPI receive batch size), but can be specified by userspace through
+  the ``batch_size`` parameter, up to a maximum of 256 packets. For each batch,
+  the kernel executes the XDP program repeatedly, each invocation getting a
+  separate copy of the packet data. For each repetition, if the program drops
+  the packet, the data page is immediately recycled (see below). Otherwise, the
+  packet is buffered until the end of the batch, at which point all packets
+  buffered this way during the batch are transmitted at once.
+
+- When setting up the test run, the kernel will initialise a pool of memory
+  pages of the same size as the batch size. Each memory page will be initialised
+  with the initial packet data supplied by userspace at ``BPF_PROG_RUN``
+  invocation. When possible, the pages will be recycled on future program
+  invocations, to improve performance. Pages will generally be recycled a full
+  batch at a time, except when a packet is dropped (by return code or because
+  of, say, a redirection error), in which case that page will be recycled
+  immediately. If a packet ends up being passed to the regular networking stack
+  (because the XDP program returns ``XDP_PASS``, or because it ends up being
+  redirected to an interface that injects it into the stack), the page will be
+  released and a new one will be allocated when the pool is empty.
+
+  When recycling, the page content is not rewritten; only the packet boundary
+  pointers (``data``, ``data_end`` and ``data_meta``) in the context object will
+  be reset to the original values. This means that if a program rewrites the
+  packet contents, it has to be prepared to see either the original content or
+  the modified version on subsequent invocations.
diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index ef5c996547ec..96056a7447c7 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -21,6 +21,7 @@ that goes into great technical depth about the BPF Architecture.
    helpers
    programs
    maps
+   bpf_prog_run
    classic_vs_extended.rst
    bpf_licensing
    test_debug
-- 
2.35.1

