Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FC12EAD9F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbhAEOqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:46:19 -0500
Received: from gofer.mess.org ([88.97.38.141]:54255 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbhAEOqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:46:17 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 7A5CEC637E; Tue,  5 Jan 2021 14:45:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1609857934; bh=iJ86QbxBrhi/nSJypbCAMvYcDP4l2HigQ2w1KwuFLoQ=;
        h=From:To:Subject:Date:From;
        b=RKRuRNaOSqpGKmLkT3YE+xHyCRSzR4zz81sZRfyaVxK8mA2RFPOzlnFQrROGo21BW
         pu8RJr1qccWhZAOhhjmsOxfnYeE/yGxQlLsQAQCe/DDkQXutEIT755yNGygMOy+Jsr
         bH1UaIJR1DatoIcPI47IOOrWbpNEGXgn9IuNEdPE0IdTCkcgm2FTGF4+WZQnalWrgn
         V8lvjotfbWfpMf5APdQYlpsHoe5IFvh8EiKq7K9MvmLJs4Av/wYlMF4m43RCZv0La5
         KQihe77WRKfe8bjxFINZWq2NY83gEgljwPtsHl7r4ENBW7xTZvvXqXvkxYOFe1/OMa
         46qe4HK4rP3Xg==
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v3 0/4] btf: support ints larger than 128 bits
Date:   Tue,  5 Jan 2021 14:45:30 +0000
Message-Id: <cover.1609855479.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang supports arbitrary length ints using the _ExtInt extension. This
can be useful to hold very large values, e.g. 256 bit or 512 bit types.

Larger types (e.g. 1024 bits) are possible but I am unaware of a use
case for these.

This requires the _ExtInt extension enabled in clang, which is under
review.

Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
Link: https://reviews.llvm.org/D93103

Signed-off-by: Sean Young <sean@mess.org>

changes since v2:
 - split patches into 4 distinct patches

changes since v1:
 - added tests as suggested by Yonghong Song
 - added kernel pretty-printer


Sean Young (4):
  btf: add support for ints larger than 128 bits
  libbpf: add support for ints larger than 128 bits
  bpftool: add support for ints larger than 128 bits
  bpf: add tests for ints larger than 128 bits

 Documentation/bpf/btf.rst                     |   4 +-
 include/uapi/linux/btf.h                      |   2 +-
 kernel/bpf/btf.c                              |  54 +-
 tools/bpf/bpftool/btf_dumper.c                |  40 ++
 tools/include/uapi/linux/btf.h                |   2 +-
 tools/lib/bpf/btf.c                           |   2 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  |   3 +-
 .../selftests/bpf/progs/test_btf_extint.c     |  50 ++
 tools/testing/selftests/bpf/test_extint.py    | 535 ++++++++++++++++++
 10 files changed, 679 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_extint.c
 create mode 100755 tools/testing/selftests/bpf/test_extint.py

-- 
2.29.2

