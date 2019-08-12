Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599738AA09
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfHLVxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:53:14 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39617 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfHLVxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:53:12 -0400
Received: by mail-pf1-f202.google.com with SMTP id 6so67098482pfi.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bLIn7GLHipF5J2aM8u4yisb20ADo6gvdLQjWA3nqqto=;
        b=oZgJljpXQ94rk2zW18vXcsZCcgjkqaEK0PFChQqFNUt9eJvRqpG4FjIx2VGo1ax+1W
         9LkZEFvnvQf02vEHwbNRr57CpoAZW18go0riE7ej7s/xKszlrapE+MB3qeBOdD41evqx
         DU/YJ3BMfUdNEQOHFc1G7SKXOnpMfO94pUpF3H4pDLqDZ0XeWgLwLDyFySqSY/dQVASg
         J0uwn4XLMvLP/6jEpQwjOMjhtDAFTa8TRYsI2q22JG9aSl4NCpQnF6uaDWBntIPKGNnk
         s7TFZyujRoUAZr7YPCUNvKLYOIrCxj6HqiLrCocg+2h8u1GCXmYVb8HRMIDn3qr+bKHb
         9SHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bLIn7GLHipF5J2aM8u4yisb20ADo6gvdLQjWA3nqqto=;
        b=rrVTAqQVJXPVLtWMdjMmjshNdKqwQe2RUl2DdxDkXXTyQJmbMs+In3ugxJ8LFSmiU9
         jUIh5cvLOhqH/EYBhUjahMjb1Q+aYchEOyaPhGmtYbzNwEFgAp2IwJ+Y7in1xPIPmlez
         JCR3++uXbtsN9888eb3GXFSrbISTF9PILBXQfMocdVrB7HSilPQm2JJP/m9g2kYmO0yI
         dqDxehbYbrFVD7XxXcG2x9L4ug/plGhDFCb2s1rOkW00QLQjY8NCw0Jb4RJ+qndvNyQv
         vTZXiusAqELF/MTVSuAS2OZrjohEo5OhGwfX3ZlBkE8zpVKKRhxz0daJxTzsYRDnS1NK
         qQrQ==
X-Gm-Message-State: APjAAAX+eKvdrO+t17bhttEvqFutcmzccIM3Ygm+zzhyVo0lKL5x3cGd
        qOFJsU0nEJDc+nDNNj7dmGfd9sFDzhxLPOL6DOE=
X-Google-Smtp-Source: APXvYqw4GsYyT7mhjnCkdsxNxaVETRuyF5MdPuiPgtTE/mHJhvlyJgo0ZkJMKWtagGQzpcMCTnaLpGCyUdZCqpaIfbg=
X-Received: by 2002:a65:6093:: with SMTP id t19mr981443pgu.79.1565646790802;
 Mon, 12 Aug 2019 14:53:10 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:49 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-16-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 16/16] compiler_attributes.h: add note about __section
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The antipattern described can be found with:
$ grep -e __section\(\" -r -e __section__\(\"

Link: https://bugs.llvm.org/show_bug.cgi?id=42950
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/linux/compiler_attributes.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 6b318efd8a74..f8c008d7f616 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -225,6 +225,16 @@
 #define __pure                          __attribute__((__pure__))
 
 /*
+ *  Note: Since this macro makes use of the "stringification operator" `#`, a
+ *        quoted string literal should not be passed to it. eg.
+ *        prefer:
+ *        __section(.foo)
+ *        to:
+ *        __section(".foo")
+ *        unless the section name is dynamically built up, in which case the
+ *        verbose __attribute__((__section__(".foo" x))) should be preferred.
+ *        See also: https://bugs.llvm.org/show_bug.cgi?id=42950
+ *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-section-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-section-variable-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#section-declspec-allocate
-- 
2.23.0.rc1.153.gdeed80330f-goog

