Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018E659FB8D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiHXNlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiHXNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:41:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8637E306
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/hEf44O5uT0I/vp8P897qbCcMVrv6y/x8AKCXJ5mP/g=;
        b=DjTnd7jzpHUKswEzrmjyflNfHQnwt32+LTyTvg3L3B7xs8vE5NfcRq+vvQySCm71UWfTM0
        6pRb/rW8ixJ93jDeVimlUQ6mIRax6GsbFGgEuWeGyMfO7eFPrOhpaV//fwXNAgn+cLGvMy
        ss/afZ8tz8BrexNSikFCgpZMnxkdZxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-QvaXZXP5MqaT-dLz9Wri5Q-1; Wed, 24 Aug 2022 09:41:03 -0400
X-MC-Unique: QvaXZXP5MqaT-dLz9Wri5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E79F1C0BDE3;
        Wed, 24 Aug 2022 13:41:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C17F18ECC;
        Wed, 24 Aug 2022 13:40:58 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v9 00/23] Introduce eBPF support for HID devices
Date:   Wed, 24 Aug 2022 15:40:30 +0200
Message-Id: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here comes the v9 of the HID-BPF series.

Again, for a full explanation of HID-BPF, please refer to the last patch
in this series (23/23).

This version sees some minor improvements compared to v7 and v8, only
focusing on the reviews I got. (v8 was a single patch update)

- patch 1/24 in v7 was dropped as it is already fixed upstream
- patch 1/23 in v9 is now capable of handling all functions, not just
  kfuncs (tested with the selftests only)
- some minor nits from Greg's review
- a rebase on top of the current bpf-next tree as the kfunc definition
  changed (for the better).

Cheers,
Benjamin


Benjamin Tissoires (23):
  bpf/verifier: allow all functions to read user provided context
  bpf/verifier: do not clear meta in check_mem_size
  selftests/bpf: add test for accessing ctx from syscall program type
  bpf/verifier: allow kfunc to return an allocated mem
  selftests/bpf: Add tests for kfunc returning a memory pointer
  bpf: prepare for more bpf syscall to be used from kernel and user
    space.
  libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
  HID: core: store the unique system identifier in hid_device
  HID: export hid_report_type to uapi
  HID: convert defines of HID class requests into a proper enum
  HID: Kconfig: split HID support and hid-core compilation
  HID: initial BPF implementation
  selftests/bpf: add tests for the HID-bpf initial implementation
  HID: bpf: allocate data memory for device_event BPF programs
  selftests/bpf/hid: add test to change the report size
  HID: bpf: introduce hid_hw_request()
  selftests/bpf: add tests for bpf_hid_hw_request
  HID: bpf: allow to change the report descriptor
  selftests/bpf: add report descriptor fixup tests
  selftests/bpf: Add a test for BPF_F_INSERT_HEAD
  samples/bpf: HID: add new hid_mouse example
  samples/bpf: HID: add Surface Dial example
  Documentation: add HID-BPF docs

 Documentation/hid/hid-bpf.rst                 | 512 +++++++++
 Documentation/hid/index.rst                   |   1 +
 drivers/Makefile                              |   2 +-
 drivers/hid/Kconfig                           |  20 +-
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  17 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  93 ++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 526 ++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
 drivers/hid/hid-core.c                        |  49 +-
 include/linux/bpf.h                           |   9 +-
 include/linux/btf.h                           |  10 +
 include/linux/hid.h                           |  38 +-
 include/linux/hid_bpf.h                       | 148 +++
 include/uapi/linux/hid.h                      |  26 +-
 include/uapi/linux/hid_bpf.h                  |  25 +
 kernel/bpf/btf.c                              | 109 +-
 kernel/bpf/syscall.c                          |  10 +-
 kernel/bpf/verifier.c                         |  64 +-
 net/bpf/test_run.c                            |  21 +
 samples/bpf/.gitignore                        |   2 +
 samples/bpf/Makefile                          |  27 +
 samples/bpf/hid_mouse.bpf.c                   | 134 +++
 samples/bpf/hid_mouse.c                       | 161 +++
 samples/bpf/hid_surface_dial.bpf.c            | 161 +++
 samples/bpf/hid_surface_dial.c                | 232 ++++
 tools/include/uapi/linux/hid.h                |  62 ++
 tools/include/uapi/linux/hid_bpf.h            |  25 +
 tools/lib/bpf/skel_internal.h                 |  23 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |  76 ++
 tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 125 +++
 40 files changed, 5198 insertions(+), 84 deletions(-)
 create mode 100644 Documentation/hid/hid-bpf.rst
 create mode 100644 drivers/hid/bpf/Kconfig
 create mode 100644 drivers/hid/bpf/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/README
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
 create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
 create mode 100644 include/linux/hid_bpf.h
 create mode 100644 include/uapi/linux/hid_bpf.h
 create mode 100644 samples/bpf/hid_mouse.bpf.c
 create mode 100644 samples/bpf/hid_mouse.c
 create mode 100644 samples/bpf/hid_surface_dial.bpf.c
 create mode 100644 samples/bpf/hid_surface_dial.c
 create mode 100644 tools/include/uapi/linux/hid.h
 create mode 100644 tools/include/uapi/linux/hid_bpf.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

-- 
2.36.1

