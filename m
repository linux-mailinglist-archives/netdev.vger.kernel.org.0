Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3200E5AEF82
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiIFPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiIFPzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:55:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E097FF87
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662477194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rSMhvfIyusO2m5Ftz3A0TdMajIqOhGV3ENODeHiCzw4=;
        b=gmW0aC6bH/zPEPTalfwTMEMOCLCCqlvMDEfrFksUtjZR6Snvr4gd88sPm49CCrUPed17eK
        I/GLXhn4jzIdH3lWc0cnM0uw842998yYWMULS0PatelpynjF91niTVpNlX0EtZNolTczID
        jNOUpY8oSlC60TpuQFYtxfxYzgPRbEE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-BrTXZ5JsO-uTWW_xymhi_w-1; Tue, 06 Sep 2022 11:13:13 -0400
X-MC-Unique: BrTXZ5JsO-uTWW_xymhi_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34AF42999B20;
        Tue,  6 Sep 2022 15:13:13 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2DBD40D296C;
        Tue,  6 Sep 2022 15:13:10 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v11 0/7] bpf-core changes for preparation of
Date:   Tue,  6 Sep 2022 17:12:56 +0200
Message-Id: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

well, given that the HID changes haven't moved a lot in the past
revisions and that I am cc-ing a bunch of people, I have dropped them
while we focus on the last 2 requirements in bpf-core changes.

I'll submit a HID targeted series when we get these in tree, which
would make things a lore more independent.

For reference, the whole reasons for these 2 main changes are at
https://lore.kernel.org/bpf/20220902132938.2409206-1-benjamin.tissoires@redhat.com/

Compared to v10 (in addition of dropping the HID changes), I have
changed the selftests so we can test both light skeletons and libbbpf
calls.

Cheers,
Benjamin

Benjamin Tissoires (7):
  selftests/bpf: regroup and declare similar kfuncs selftests in an
    array
  bpf: split btf_check_subprog_arg_match in two
  bpf/verifier: allow all functions to read user provided context
  selftests/bpf: add test for accessing ctx from syscall program type
  bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
  bpf/verifier: allow kfunc to return an allocated mem
  selftests/bpf: Add tests for kfunc returning a memory pointer

 include/linux/bpf.h                           |  11 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/btf.h                           |  10 +
 kernel/bpf/btf.c                              | 149 ++++++++++--
 kernel/bpf/verifier.c                         |  66 +++--
 net/bpf/test_run.c                            |  37 +++
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 227 ++++++++++++++++--
 .../selftests/bpf/progs/kfunc_call_fail.c     | 160 ++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     |  71 ++++++
 10 files changed, 678 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c

-- 
2.36.1

