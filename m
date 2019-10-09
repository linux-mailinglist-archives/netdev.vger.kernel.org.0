Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA16D19E1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbfJIUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:42:01 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45145 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732170AbfJIUmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:42:00 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so3848538ljb.12
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZSbYJ+tLtfDuMSVqb7LwJbRD3u314/MfD3p1keHf2Mw=;
        b=pzdPyL78q/gbChT77HCP7gSmJXWVdEWKYJQzr4nN7gdvvWnYwHoI8e+zFj+6pgj6yb
         K8kXXGGo9S629wH2TsCb/WtRqZmXgJJ70q3HTxWrCTT/7iMCwuiKj7zudoSmlfGB+PAI
         /45wQ4KP7k11v6we53lk8hhEeehY1QX9SjVDv/VQv1jaHINDd6U4g/QtWhYfubjHDXgp
         XTVVibyKnEQzXFUc37axnMinQOpbyw7ku8dOxYuTW/BDJAeS00IL5E1xmBcZliiAeCXU
         ntHfGa4HfaPvseNHg7XszDFS0voyh5uMx9tMPpL6EIkU9r4TMaGMpMFzfb6wZW5PrWf4
         cALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZSbYJ+tLtfDuMSVqb7LwJbRD3u314/MfD3p1keHf2Mw=;
        b=kunbN/HQtZbKteno6iog/52X0ZrUqjwdx7PKjXXapvAwN4BxrJdcaVV3XzP4nQ+RPD
         5PK66zQxwmzxKceXQ0Mh7Saq9TGdgij57/C8m3mv6YhrYK05C/2VD1KL/JToa3dEh7xW
         mN+l/YHopFyP5J9XsFmQSwJ9GOYkseSbAxRuDdmFcgGQSokPKs91BrElLH04eNhwxMUy
         JdcZ0ZyAfKlX17GFk11txpnI0MObAucr4aFEect699mu0sVmiMukn0Q2hLYz4TjY428E
         z6g3tNmooBOdMJTpgAOnNLNC6FmL6iwRUBgp6tNuZi+VTBF1FXm6/mjqu+lmxJzIrGdo
         JMGg==
X-Gm-Message-State: APjAAAUhVO5PAQS37a/IjoPaN2Yc1ipz+LNLbI6F3/mJ+Ey7J2vTaoNK
        P5+kxCnU9gz8agHoVzQ6YDwkYg==
X-Google-Smtp-Source: APXvYqw28C/ieWvRsyR1+UMEt2bz2E5FWkQj5sxBQdPyN7lcnh1XII6n052wtVOlBKbSfxiLGW1YSg==
X-Received: by 2002:a2e:86cd:: with SMTP id n13mr3689328ljj.252.1570653718918;
        Wed, 09 Oct 2019 13:41:58 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:58 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 14/15] samples/bpf: add sysroot support
Date:   Wed,  9 Oct 2019 23:41:33 +0300
Message-Id: <20191009204134.26960-15-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically it only enables that was added by previous couple fixes.
Sysroot contains correct libs installed and its headers. Useful when
working with NFC or virtual machine.

Usage example:

clean (on demand)
    make ARCH=arm -C samples/bpf clean
    make ARCH=arm -C tools clean
    make ARCH=arm clean

configure and install headers:

    make ARCH=arm defconfig
    make ARCH=arm headers_install

build samples/bpf:
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- samples/bpf/ \
    SYSROOT="path/to/sysroot"

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 6b161326ac67..4df11ddb9c75 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -187,6 +187,11 @@ TPROGS_CFLAGS += -I$(srctree)/tools/lib/
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 TPROGS_CFLAGS += -I$(srctree)/tools/perf
 
+ifdef SYSROOT
+TPROGS_CFLAGS += --sysroot=$(SYSROOT)
+TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
+endif
+
 TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
 
 TPROGS_LDLIBS			+= $(LIBBPF) -lelf
-- 
2.17.1

