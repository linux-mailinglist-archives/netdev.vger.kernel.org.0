Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5D4AE861
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406262AbfIJKi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:38:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44442 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406215AbfIJKix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:38:53 -0400
Received: by mail-lj1-f194.google.com with SMTP id u14so15867048ljj.11
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aOBDMFi7PSb0gHyNeqqhWN1bJP3tg81RdsZh4BrKqUw=;
        b=dZCGaEuJIGUCPQEGK33Sn/a9ZXr1W2in9EPfmjnbwJAMCekhG6gPrUKBXtM9dA6Bua
         CO0ROLT22y9S3G5cB0fUS+NwtMDzJr6+L13qfksUvKAEex3h114d1QzyYZ8sZ6IjKuSt
         rkwhMTdhR2vjcycIZ/U4KfP6/DGiUOHzrf1z1Ykp5RNNE8nDy3evu9ck5pH876DEllqg
         sRw/k+zeukJc80NgALQN0hag/HPBhscdR5rSFY7PjS3o0+DYv3vwXnmOn0f1CoV9/JzP
         FG5HBwd3LzjMCIpehQQdiNtCwLoUdPyT7QvAmxLutks5bbQM/+usVCkuxFOtnq0+Q2uv
         9New==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aOBDMFi7PSb0gHyNeqqhWN1bJP3tg81RdsZh4BrKqUw=;
        b=pAS/SgGz/F3Zyq6DyFzp5rMD6+Nr+mkIugWHiBodrIA8pnU7+IMN7+Xmih9oL/HSsq
         yKAzeKfMnsgrszzi0YX8W4SX1Rke5GqspSU0K2aYD3DLBRBRei5qq/EwfLly2ufNau/I
         p5wC0R0/CYxnW33ZsV9J8SXi4zNYSdaDOMjhbYAQu/6MDjaTNgYm9PT+8mpzT72jgtvd
         M0AyU08sz5zizsnoX4gtOIM81YE3YF7FPgQp8c2/TxF+RKu/06WoqkuYv4OTsWFcCxP9
         wqgTHeSHva2yC+nfWK+kZWfcMHHzMiebmKa/Ja1mA6g2CBxIY5yeosRmvI92MndYSxz9
         UPhg==
X-Gm-Message-State: APjAAAWoPT/q1DQGTDXrlfbIbra2YWQvHeLInyf9P9iN4rgcNQnh1Egi
        bQKld0Ex2Z8ek6L9Ca9Odq27yQ==
X-Google-Smtp-Source: APXvYqyAutFjXRPV/VcndllZEPdk69aMXnYST9mSOt78qiRws+YgyCDmh/V5o8V9Ost00AHcM8xVsA==
X-Received: by 2002:a2e:8012:: with SMTP id j18mr19477348ljg.36.1568111930993;
        Tue, 10 Sep 2019 03:38:50 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id g5sm4005563lfh.2.2019.09.10.03.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:38:50 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 11/11] samples: bpf: makefile: add sysroot support
Date:   Tue, 10 Sep 2019 13:38:30 +0300
Message-Id: <20190910103830.20794-12-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically it only enables that was added by previous couple fixes.
For sure, just make tools/include to be included after sysroot
headers.

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make samples/bpf/ SYSROOT="path/to/sysroot"

Sysroot contains correct libs installed and its headers ofc.
Useful when working with NFC or virtual machine.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile   |  5 +++++
 samples/bpf/README.rst | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4edc5232cfc1..68ba78d1dbbe 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -177,6 +177,11 @@ ifeq ($(ARCH), arm)
 CLANG_EXTRA_CFLAGS := $(D_OPTIONS)
 endif
 
+ifdef SYSROOT
+ccflags-y += --sysroot=${SYSROOT}
+PROGS_LDFLAGS := -L${SYSROOT}/usr/lib
+endif
+
 ccflags-y += -I$(objtree)/usr/include
 ccflags-y += -I$(srctree)/tools/lib/bpf/
 ccflags-y += -I$(srctree)/tools/testing/selftests/bpf/
diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index 5f27e4faca50..786d0ab98e8a 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -74,3 +74,13 @@ samples for the cross target.
 export ARCH=arm64
 export CROSS_COMPILE="aarch64-linux-gnu-"
 make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+
+If need to use environment of target board (headers and libs), the SYSROOT
+also can be set, pointing on FS of target board:
+
+export ARCH=arm64
+export CROSS_COMPILE="aarch64-linux-gnu-"
+make samples/bpf/ SYSROOT=~/some_sdk/linux-devkit/sysroots/aarch64-linux-gnu
+
+Setting LLC and CLANG is not necessarily if it's installed on HOST and have
+in its targets appropriate arch triple (usually it has several arches).
-- 
2.17.1

