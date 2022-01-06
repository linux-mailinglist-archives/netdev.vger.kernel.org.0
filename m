Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9927A486ABA
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243504AbiAFT7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243500AbiAFT7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641499184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+UT7ahSyEvqF0vyXZzW9uwguimJumnfjaEwsrTCo3Bs=;
        b=XTPnC5UrIq+eNozZlyU+PmUA3pX0Sid61UuLzipgrdLln9mzDulDcc3nCZWAn8PWonxt/v
        /nOUsQcoTB9s7NbjVBLcWP6r/3JwVB68W9jOjxi1g2zpp5cJq3OC95Lrqj8B6k5Py7qPd2
        ygkWE2FDf4nPNDH5eWsU0mP9Wh8xZLw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-QIxNCToqMJKwAqXQqnuY4g-1; Thu, 06 Jan 2022 14:59:42 -0500
X-MC-Unique: QIxNCToqMJKwAqXQqnuY4g-1
Received: by mail-ed1-f72.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so2760576edc.18
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 11:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+UT7ahSyEvqF0vyXZzW9uwguimJumnfjaEwsrTCo3Bs=;
        b=k61NU5UBL17M0wRajhKvnnO9eaZ1fVHhlu1f7eElvLwcpPjJV+7HRmZstAw+jsHiJV
         i7BE1LSD2Q6YD+BrYp0H6FXjo7YMOiGl99i4Ij91gb/hKMwWP0yAWQrOFcZ3sxYpAMZO
         mplJ3s3rhtZsbxMmhWnWVVTr6d6uFyHMuqlFuNl16gdEys46yHCTx8mICl9uhKi7Nhtb
         rB3Vv8rmqWFx1wi4CZw9hL+17SJjwFYPwhYJq4dCgr+QSC3a+48LpELopiqe8Id9OI9n
         0ZfMxpT/YDPTqFkeqy5ndsCSb4teB34eiMegZOflDTJ1e+TK+6k6xj3QZX3xmGbc4In5
         qrZA==
X-Gm-Message-State: AOAM530eGWS7YMm/79RpSJRktiKYyjajL7TRrhM2XU5YE8L1djd08G7V
        UHSMxBQgKCVIiW89BOxc6Wiiwa2U//V5PHEaJ8G7EMVkmD5iZqDQeQo7iUxy8LXiSvcFubIMI9/
        0O7+JW0RV0nsae43Z
X-Received: by 2002:a17:906:c111:: with SMTP id do17mr45492389ejc.270.1641499181332;
        Thu, 06 Jan 2022 11:59:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3luHYq5Qxcet+Tu4cqsJmhAiNuDJ0Jxafs3mO7aeXC8GfLhnfjGJJmg4iFSOJ+QRgdkm4bw==
X-Received: by 2002:a17:906:c111:: with SMTP id do17mr45492370ejc.270.1641499180881;
        Thu, 06 Jan 2022 11:59:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 16sm755814ejx.149.2022.01.06.11.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 11:59:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B326181F2A; Thu,  6 Jan 2022 20:59:39 +0100 (CET)
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
Subject: [PATCH bpf-next v6 0/3] Add support for transmitting packets using XDP in bpf_prog_run()
Date:   Thu,  6 Jan 2022 20:59:35 +0100
Message-Id: <20220106195938.261184-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
moved to xdp-tools, transmits up to 11.5 Mpps/core on my test machine.

To transmit the frames, the new mode instantiates a page_pool structure in
bpf_prog_run() and initialises the pages to contain XDP frames with the
data passed in by userspace. These frames can then be handled as though
they came from the hardware XDP path, and the existing page_pool code takes
care of returning and recycling them. The setup is optimised for high
performance with a high number of repetitions to support stress testing and
the traffic generator use case; see patch 1 for details.

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

Toke Høiland-Jørgensen (3):
  bpf: Add "live packet" mode for XDP in bpf_prog_run()
  selftests/bpf: Move open_netns() and close_netns() into
    network_helpers.c
  selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()

 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/Kconfig                            |   1 +
 net/bpf/test_run.c                            | 290 +++++++++++++++++-
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/testing/selftests/bpf/network_helpers.c |  86 ++++++
 tools/testing/selftests/bpf/network_helpers.h |   9 +
 .../selftests/bpf/prog_tests/tc_redirect.c    |  87 ------
 .../bpf/prog_tests/xdp_do_redirect.c          | 151 +++++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  78 +++++
 9 files changed, 611 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

-- 
2.34.1

