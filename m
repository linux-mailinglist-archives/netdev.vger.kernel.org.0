Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017136A5F36
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 20:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjB1TGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 14:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjB1TGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 14:06:35 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA7F30EA2
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 11:06:12 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id m4so7624772qvq.3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 11:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1677611171;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G9Ysv1tcjH+fhyGoDw4XqDTEVUICL5OL1IO4ayklgzk=;
        b=VLMYWLCpyG9X4gzuFdYxiV7f5THqkMJe6fuOSnQkoaLl47ZtPzYQwNe322VqQi9qSL
         ac1KuE9C4Yz+vJX2XOsacZQjL65w0x9s5YhYFkZ0Wjx0zXH2Uhw2I1n55TOopxHI4oWN
         qLeVGZHI9lesKsDSOkIpmPNyqqMHd8EB1PYeJur7qll/+GNK8XFqeJMRzs4laWxx8hVF
         wPf/UZ0QmJw7RuuCWx8EFH6V1DcmDct7kU6v4WM8slo0+foMGlKuWm94jLvh1SYUntxK
         hC2PQucXDwGGmu9v3nkfGeRVqJVycknzqFJUwHV0Awu3OzVFrGVYGb6uMn7ifz/zixCE
         9wMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677611171;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9Ysv1tcjH+fhyGoDw4XqDTEVUICL5OL1IO4ayklgzk=;
        b=vQYoA++Hk4wvvhlGwgz0go0HDeu7hfRdxPPD0Isy66w6AoU94ahzT3xQmWc3c0X7o4
         L6q5fwxtMt6CKHaw6Av1GAP81prp/TMQ6FOqdAeq+9DRbmS3LG844E7BvDDXgU5Y9AMi
         TCo949omIQSBOFWm7p2TE46ahEb1CQhqTsZNlsjoOKeGYiGCNwHI6KVbMNUshUr1nwFs
         TIbAK+Xvrt2pG0kdRgc5tkMYrWkP7e5ZXhxa2zpJCzUs5Ln7vn4nv1BzJ+T2VgOQe2gv
         uHREkrMgSiRvkkx1k3XreGQJz8FglAHr+lz4w/SSItDHoEJqPClHpio/hXPRoUu42/XR
         4OTg==
X-Gm-Message-State: AO0yUKUib75xHDQ4sAEpgJ/GGULo7nF6HZyZhfpmLZSijMfEmM2RU+Zq
        tonkhWLUo1eldWzvZC440UfyfA==
X-Google-Smtp-Source: AK7set+1iX5Pp01ukBiqs5o3vFibeVRDzz2icAPzV4Mj5is2kveC5JCqCPAItpISdAhjboJeK+MonQ==
X-Received: by 2002:a05:6214:3014:b0:56e:ff20:57c2 with SMTP id ke20-20020a056214301400b0056eff2057c2mr6277955qvb.10.1677611171233;
        Tue, 28 Feb 2023 11:06:11 -0800 (PST)
Received: from n217-072-012.byted.org ([130.44.212.123])
        by smtp.gmail.com with ESMTPSA id p13-20020a05620a15ed00b006fed58fc1a3sm7242810qkm.119.2023.02.28.11.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:06:10 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [PATCH net-next v3 0/3] vsock: add support for sockmap
Date:   Tue, 28 Feb 2023 19:04:33 +0000
Message-Id: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEFQ/mMC/12OTQrCMBSEryJv7ZM2Wq2uvIe4SJOJDZofklgU8
 e6mbgQ3A8Mw882LMpJFpsPiRQmTzTb4atbLBalR+gvY6upJNGLdCLHjKQd15VmcjHyPuSRIx3u
 97VS/aXcbKaiWB5nBQ5JejXNdY8ItRAdf5jQmGPv4Yk/kUdjjUehcE5OC4zLWzR+2bXvO9xhDK
 n94FbyHKna4gSfBDXe9MdJoNPttdxyeBbo+wEoFR+/3B7fELkPtAAAA
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for sockmap to vsock.

We're testing usage of vsock as a way to redirect guest-local UDS
requests to the host and this patch series greatly improves the
performance of such a setup.

Compared to copying packets via userspace, this improves throughput by
121% in basic testing.

Tested as follows.

Setup: guest unix dgram sender -> guest vsock redirector -> host vsock
       server
Threads: 1
Payload: 64k
No sockmap:
- 76.3 MB/s
- The guest vsock redirector was
  "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
Using sockmap (this patch):
- 168.8 MB/s (+121%)
- The guest redirector was a simple sockmap echo server,
  redirecting unix ingress to vsock 2:1234 egress.
- Same sender and server programs

*Note: these numbers are from RFC v1

Only the virtio transport has been tested. The loopback transport was
used in writing bpf/selftests, but not thoroughly tested otherwise.

This series requires the skb patch.

Changes in v3:
- vsock/bpf: Refactor wait logic in vsock_bpf_recvmsg() to avoid
  backwards goto
- vsock/bpf: Check psock before acquiring slock
- vsock/bpf: Return bool instead of int of 0 or 1
- vsock/bpf: Wrap macro args __sk/__psock in parens
- vsock/bpf: Place comment trailer */ on separate line

Changes in v2:
- vsock/bpf: rename vsock_dgram_* -> vsock_*
- vsock/bpf: change sk_psock_{get,put} and {lock,release}_sock() order
  to minimize slock hold time
- vsock/bpf: use "new style" wait
- vsock/bpf: fix bug in wait log
- vsock/bpf: add check that recvmsg sk_type is one dgram, seqpacket, or
  stream.  Return error if not one of the three.
- virtio/vsock: comment __skb_recv_datagram() usage
- virtio/vsock: do not init copied in read_skb()
- vsock/bpf: add ifdef guard around struct proto in dgram_recvmsg()
- selftests/bpf: add vsock loopback config for aarch64
- selftests/bpf: add vsock loopback config for s390x
- selftests/bpf: remove vsock device from vmtest.sh qemu machine
- selftests/bpf: remove CONFIG_VIRTIO_VSOCKETS=y from config.x86_64
- vsock/bpf: move transport-related (e.g., if (!vsk->transport)) checks
  out of fast path

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
Bobby Eshleman (3):
      vsock: support sockmap
      selftests/bpf: add vsock to vmtest.sh
      selftests/bpf: Add a test case for vsock sockmap

 drivers/vhost/vsock.c                              |   1 +
 include/linux/virtio_vsock.h                       |   1 +
 include/net/af_vsock.h                             |  17 ++
 net/vmw_vsock/Makefile                             |   1 +
 net/vmw_vsock/af_vsock.c                           |  55 ++++++-
 net/vmw_vsock/virtio_transport.c                   |   2 +
 net/vmw_vsock/virtio_transport_common.c            |  24 +++
 net/vmw_vsock/vsock_bpf.c                          | 175 +++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c                     |   2 +
 tools/testing/selftests/bpf/config.aarch64         |   2 +
 tools/testing/selftests/bpf/config.s390x           |   3 +
 tools/testing/selftests/bpf/config.x86_64          |   3 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
 13 files changed, 443 insertions(+), 6 deletions(-)
---
base-commit: d83115ce337a632f996e44c9f9e18cadfcf5a094
change-id: 20230118-support-vsock-sockmap-connectible-2e1297d2111a

Best regards,
--
Bobby Eshleman <bobby.eshleman@bytedance.com>

---
Bobby Eshleman (3):
      vsock: support sockmap
      selftests/bpf: add vsock to vmtest.sh
      selftests/bpf: add a test case for vsock sockmap

 drivers/vhost/vsock.c                              |   1 +
 include/linux/virtio_vsock.h                       |   1 +
 include/net/af_vsock.h                             |  17 ++
 net/vmw_vsock/Makefile                             |   1 +
 net/vmw_vsock/af_vsock.c                           |  55 ++++++-
 net/vmw_vsock/virtio_transport.c                   |   2 +
 net/vmw_vsock/virtio_transport_common.c            |  25 +++
 net/vmw_vsock/vsock_bpf.c                          | 174 +++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c                     |   2 +
 tools/testing/selftests/bpf/config.aarch64         |   2 +
 tools/testing/selftests/bpf/config.s390x           |   3 +
 tools/testing/selftests/bpf/config.x86_64          |   3 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
 13 files changed, 443 insertions(+), 6 deletions(-)
---
base-commit: c2ea552065e43d05bce240f53c3185fd3a066204
change-id: 20230227-vsock-sockmap-upstream-9d65c84174a2

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

