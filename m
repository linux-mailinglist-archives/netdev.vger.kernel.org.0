Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A24BBEBE
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiBRRu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:50:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiBRRux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92CEA673FB
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645206634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=acG6+AYaxGoDPafCW04B6BX/LCAy7bjHKHpBFvZcZZE=;
        b=f6KJlZXSpTWGRczkGAeg3FjOBc5jCeOeQoMhrncoA4U2RlpGMDlu5GhroHHFGafG8znOXn
        86ryfpcaYTLG7H/pj32GwVVwXDhQ6u4w9KDfrBXTQ/kXNGQZyLJ2+XMuZUwH4p27g7QK14
        OEE3+dBGbvxnU6SG1GZi5WeWCae/s7M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-cQ9RNN0FPlqflKLtZS0BAg-1; Fri, 18 Feb 2022 12:50:33 -0500
X-MC-Unique: cQ9RNN0FPlqflKLtZS0BAg-1
Received: by mail-ed1-f69.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so5882139edh.9
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=acG6+AYaxGoDPafCW04B6BX/LCAy7bjHKHpBFvZcZZE=;
        b=CCgpE/axI0FSCCGYncsRDXxZmY5W5OHgsVktJ1QU4ckc9ig4jqvl6+PjKLq4ua9ddG
         swLL/KwHSQPtOETUOZEs68pK1+6Z2vL3nVRMChpUPRiVWmVxDllcSmaOajamVkP65s/M
         4czZFDTcyk61jmCeTdITK/KbGTHtNVftGUUOghFUYKj7EQr/Z1Vvj6dy5VtAr6De5K9V
         eHM7xYuKvdF3XA+dml815sgQzqIedOKD/7SRolzmBhJoP83DNTdRDL5kA7Tk1GhiT3cZ
         yQ17yJYDL0a3jwB/N8P5SM20RK+KoYGR0ehPAcPQDafpF+EPMrKAW7VTGm50ocQ3pyB2
         JzvQ==
X-Gm-Message-State: AOAM531W3J7Lb5+72OZoAfX2Pt19ysYsxBLkf0o8Lp3WM4BtDr96sC6T
        0BIQAjO3xP/Hk1E0p4w5BIY2fhgtTWYFwSv+FBOaL2IQjhXkGz93M6Fh8Vh6b/5UMkf3w1m+pIo
        Ims1VujYD48h2BqQf
X-Received: by 2002:a05:6402:2298:b0:410:a419:997 with SMTP id cw24-20020a056402229800b00410a4190997mr9481291edb.271.1645206631948;
        Fri, 18 Feb 2022 09:50:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyx6mBTkMgt64GuG7YKmyHNL/+wByCdNpV2sgBCl2Kg0UUtJiyiA/tUouzg6HEM9MJSxUskRg==
X-Received: by 2002:a05:6402:2298:b0:410:a419:997 with SMTP id cw24-20020a056402229800b00410a4190997mr9481252edb.271.1645206631540;
        Fri, 18 Feb 2022 09:50:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r8sm4781541edt.65.2022.02.18.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:50:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6338113023A; Fri, 18 Feb 2022 18:50:30 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v8 0/5] Add support for transmitting packets using XDP in bpf_prog_run()
Date:   Fri, 18 Feb 2022 18:50:24 +0100
Message-Id: <20220218175029.330224-1-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for transmitting packets using XDP in
bpf_prog_run(), by enabling a new mode "live packet" mode which will handle
the XDP program return codes and redirect the packets to the stack or other
devices.

The primary use case for this is testing the redirect map types and the
ndo_xdp_xmit driver operation without an external traffic generator. But it
turns out to also be useful for creating a programmable traffic generator
in XDP, as well as injecting frames into the stack. A sample traffic
generator, which was included in previous versions of the series, but now
moved to xdp-tools, transmits up to 9 Mpps/core on my test machine.

To transmit the frames, the new mode instantiates a page_pool structure in
bpf_prog_run() and initialises the pages to contain XDP frames with the
data passed in by userspace. These frames can then be handled as though
they came from the hardware XDP path, and the existing page_pool code takes
care of returning and recycling them. The setup is optimised for high
performance with a high number of repetitions to support stress testing and
the traffic generator use case; see patch 1 for details.

v8:
- Make the batch size configurable from userspace
- Don't interrupt the packet loop on errors in do_redirect (this can be
  caught from the tracepoint)
- Add documentation of the feature
- Add reserved flag userspace can use to probe for support (kernel didn't
  check flags previously)
- Rebase to newest bpf-next, disallow live mode for jumbo frames

v7:
- Extend the local_bh_disable() to cover the full test run loop, to prevent
  running concurrently with the softirq. Fixes a deadlock with veth xmit.
- Reinstate the forwarding sysctl setting in the selftest, and bump up the
  number of packets being transmitted to trigger the above bug.
- Update commit message to make it clear that user space can select the
  ingress interface.

v6:
- Fix meta vs data pointer setting and add a selftest for it
- Add local_bh_disable() around code passing packets up the stack
- Create a new netns for the selftest and use a TC program instead of the
  forwarding hack to count packets being XDP_PASS'ed from the test prog.
- Check for the correct ingress ifindex in the selftest
- Rebase and drop patches 1-5 that were already merged

v5:
- Rebase to current bpf-next

v4:
- Fix a few code style issues (Alexei)
- Also handle the other return codes: XDP_PASS builds skbs and injects them
  into the stack, and XDP_TX is turned into a redirect out the same
  interface (Alexei).
- Drop the last patch adding an xdp_trafficgen program to samples/bpf; this
  will live in xdp-tools instead (Alexei).
- Add a separate bpf_test_run_xdp_live() function to test_run.c instead of
  entangling the new mode in the existing bpf_test_run().

v3:
- Reorder patches to make sure they all build individually (Patchwork)
- Remove a couple of unused variables (Patchwork)
- Remove unlikely() annotation in slow path and add back John's ACK that I
  accidentally dropped for v2 (John)

v2:
- Split up up __xdp_do_redirect to avoid passing two pointers to it (John)
- Always reset context pointers before each test run (John)
- Use get_mac_addr() from xdp_sample_user.h instead of rolling our own (Kumar)
- Fix wrong offset for metadata pointer

Toke Høiland-Jørgensen (5):
  bpf: Add "live packet" mode for XDP in BPF_PROG_RUN
  Documentation/bpf: Add documentation for BPF_PROG_RUN
  libbpf: Support batch_size option to bpf_prog_test_run
  selftests/bpf: Move open_netns() and close_netns() into
    network_helpers.c
  selftests/bpf: Add selftest for XDP_REDIRECT in BPF_PROG_RUN

 Documentation/bpf/bpf_prog_run.rst            | 120 +++++++
 Documentation/bpf/index.rst                   |   1 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/Kconfig                            |   1 +
 kernel/bpf/syscall.c                          |   2 +-
 net/bpf/test_run.c                            | 323 +++++++++++++++++-
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/testing/selftests/bpf/network_helpers.c |  86 +++++
 tools/testing/selftests/bpf/network_helpers.h |   9 +
 .../selftests/bpf/prog_tests/tc_redirect.c    |  87 -----
 .../bpf/prog_tests/xdp_do_redirect.c          | 176 ++++++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  85 +++++
 14 files changed, 807 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

-- 
2.35.1

