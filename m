Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22BF4CEE2C
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 23:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiCFWfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 17:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiCFWfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 17:35:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD24E45AC9
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 14:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646606053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SFcooIJMNSZhjz2RF+BtHlD8ObO3jjC6jsSuw6E5nbc=;
        b=YFnBfnTyR+wez8gtQdH2I51Jx1PjZf7FvUnYnLjTb2R0mpH9kcPkpdcqDvcLctcmjgyswm
        jwBknl6EViFINZVWpt6X+lbB49sWJUtWWersalPuqDlcnd46e1kL/hayBtmLVQ/IC5WJdN
        SwmKORZfVRunTxtQC+P8GrniCH9LAYY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-y1CB89xcOtCs1JZyudUR-g-1; Sun, 06 Mar 2022 17:34:12 -0500
X-MC-Unique: y1CB89xcOtCs1JZyudUR-g-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402358a00b00410deddea4cso7431895edc.16
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 14:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SFcooIJMNSZhjz2RF+BtHlD8ObO3jjC6jsSuw6E5nbc=;
        b=EewlekhFaJnBMHgLlztBtOiyXaiFSLVZqfBo4Te1i1djD+SBJW/uMBXrz5IgDnMsxh
         8o+7Qs1pcU3V7RDne+TcpfTj3TCeo3KUk45Kma1f7m7X9phHD1wLaP7s0RmL1qrCySe4
         I3gS4ulJt97b7APop25+voW0FZEdawZ2zN9HLwbr1MuYZLPrVYbGgBx3opIHucidu1Wc
         AJnBeBD76c07kAD99hEosSlAdFy5rX0H4osqtzroFdGAE44eKBegOOfjvtr0/akIoSN0
         s0bJl3TIqLFwsURB5OCCbhghUDF/ftM0WpN0O+yiAHXkS9S3DCAAhwEnq6EaDHZ4LZq2
         aG4A==
X-Gm-Message-State: AOAM532dfc1p4tXFo+Xg7sVKdgp+BLGOohwwmsJIKE1OPjWzEvW7yHrW
        LmuVWQnLkQFNLNF3pyvdKly5g8BLwK9jyvTMIhA1mWGdpxXFMWGDsC0kbW+u/tZDxGpp+AcMldL
        Qdihb3bnSb9PETXwi
X-Received: by 2002:a17:907:3f17:b0:6da:68b6:7876 with SMTP id hq23-20020a1709073f1700b006da68b67876mr7099710ejc.740.1646606049885;
        Sun, 06 Mar 2022 14:34:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYmovXwm2igRP7MG09zCxUQ3vPJqqmy3LIAlZeW36aeikypDu5mSUKO4nY+OytNVKQGI9Q8g==
X-Received: by 2002:a17:907:3f17:b0:6da:68b6:7876 with SMTP id hq23-20020a1709073f1700b006da68b67876mr7099649ejc.740.1646606048402;
        Sun, 06 Mar 2022 14:34:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709063e0900b0069f263a80fesm4210651eji.171.2022.03.06.14.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 14:34:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A4465131DEB; Sun,  6 Mar 2022 23:34:06 +0100 (CET)
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
Subject: [PATCH bpf-next v9 0/5] Add support for transmitting packets using XDP in bpf_prog_run()
Date:   Sun,  6 Mar 2022 23:33:59 +0100
Message-Id: <20220306223404.60170-1-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

v9:
- XDP_DROP packets in the selftest to ensure pages are recycled
- Fix a few issues reported by the kernel test robot
- Rewrite the documentation of the batch size to make it a bit clearer
- Rebase to newest bpf-next

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

 Documentation/bpf/bpf_prog_run.rst            | 121 +++++++
 Documentation/bpf/index.rst                   |   1 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/Kconfig                            |   1 +
 kernel/bpf/syscall.c                          |   2 +-
 net/bpf/test_run.c                            | 321 +++++++++++++++++-
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/testing/selftests/bpf/network_helpers.c |  86 +++++
 tools/testing/selftests/bpf/network_helpers.h |   9 +
 .../selftests/bpf/prog_tests/tc_redirect.c    |  86 -----
 .../bpf/prog_tests/xdp_do_redirect.c          | 176 ++++++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  92 +++++
 14 files changed, 813 insertions(+), 96 deletions(-)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

-- 
2.35.1

