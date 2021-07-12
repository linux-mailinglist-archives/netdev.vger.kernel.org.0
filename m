Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9767E3C6214
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhGLRlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbhGLRlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:41:03 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89B7C0613DD;
        Mon, 12 Jul 2021 10:38:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d12so18997726pgd.9;
        Mon, 12 Jul 2021 10:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZD1hOKzyikLBWTW4ZoPnyvY2gKEeXNcSLsw+d9zA4VQ=;
        b=nKHhlhdRHNxftODTOCIkDlgaV6FA5fmf8BPcGt8VoG1sHRp41AUiaAqZrTKrN+wDc2
         dFPejf1KWPe1YoKioeEl+c+1INkftKkWi2TlhUw79cATJS4+HP+ysPWQmEpGLCtpSVs3
         bbfEzys5m6DB/I0V6hCsrNqcq0gDk3LkMDI68WrJEWKg6kTjDytOKdUh+syYbamI0JLE
         6Q7Msh3m0WLkXVKJc5W3HVgPi0cHp4nZ7iTd24jbTEsR8dveHkCx7GgBkta51kUqYuOY
         zdsi3yzFFNyIyOQ3CYmNIDAWygopvUPwHljJ5OT7D6617USMbYpY+iCHHDHvcZMIc7bm
         1JQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZD1hOKzyikLBWTW4ZoPnyvY2gKEeXNcSLsw+d9zA4VQ=;
        b=qKGciI9RC7gtFpTbtKLDf9P+eDP2WrmNwgMG29sYgbKPP770J3oamCPk1ztsKdnOVJ
         v6AYsSccj6ZLbb3o+JVbbHVojtN/e+a/wQRjx9QzBX+8ZTSCjDjrRKidqFwtoj4o9q9Y
         LIUgrZII9XODZWDHXiPzLgF4WgAJkxECnYlMfshUyqtpeNHQ59R8WOmlLFgkmG+0lgOj
         yzys9kC1/ccZQWVBZRqA3jJ3AkWicDxBK0mh+jRRVOnIEGxZEP6boCvd1+pPwILEb6vQ
         OjexRf5Qj53DNrp4WkTkMcwh1E27JYuv+2yjV247ePLikzQvQndNCHhfZavb2r+UIHYK
         Ryyw==
X-Gm-Message-State: AOAM5326cByj6SndWNDbD8uET/VQ74Jp0ODMqP8eB00u8bgAW6IVOcjZ
        klfmCaB5lsi0xAWmPSooikI=
X-Google-Smtp-Source: ABdhPJx00ULwX/fYl6jygcwepHAx93W0Ysg94pOdMnslRbsL1k1j52m8HHuZUZMkisXl8sJIgfaw4A==
X-Received: by 2002:aa7:8707:0:b029:306:7e78:ee7a with SMTP id b7-20020aa787070000b02903067e78ee7amr169703pfo.29.1626111493506;
        Mon, 12 Jul 2021 10:38:13 -0700 (PDT)
Received: from BALT-UROY.maxlinear.com ([115.187.60.212])
        by smtp.gmail.com with ESMTPSA id z26sm16851491pfr.31.2021.07.12.10.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:38:13 -0700 (PDT)
From:   "Roy, UjjaL" <royujjal@gmail.com>
To:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Networking <netdev@vger.kernel.org>, BPF <bpf@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: [PATCH v2 bpf-nxt] Documentation/bpf: Add heading and example for extensions in filter.rst
Date:   Mon, 12 Jul 2021 23:07:23 +0530
Message-Id: <20210712173723.1597-1-royujjal@gmail.com>
X-Mailer: git-send-email 2.31.1.windows.1
In-Reply-To: "Roy, UjjaL" <royujjal@gmail.com>
References: "Roy, UjjaL" <royujjal@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[1] https://www.kernel.org/doc/html/latest/bpf/

Add new heading for extensions to make it more readable. Also, add one
more example of filtering interface index for better understanding.

Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 Documentation/networking/filter.rst | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index 3e2221f4abe4..5f13905b12e0 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -320,13 +320,6 @@ Examples for low-level BPF:
   ret #-1
   drop: ret #0
 
-**(Accelerated) VLAN w/ id 10**::
-
-  ld vlan_tci
-  jneq #10, drop
-  ret #-1
-  drop: ret #0
-
 **icmp random packet sampling, 1 in 4**::
 
   ldh [12]
@@ -358,6 +351,22 @@ Examples for low-level BPF:
   bad: ret #0             /* SECCOMP_RET_KILL_THREAD */
   good: ret #0x7fff0000   /* SECCOMP_RET_ALLOW */
 
+Examples for low-level BPF extension:
+
+**Packet for interface index 13**::
+
+  ld ifidx
+  jneq #13, drop
+  ret #-1
+  drop: ret #0
+
+**(Accelerated) VLAN w/ id 10**::
+
+  ld vlan_tci
+  jneq #10, drop
+  ret #-1
+  drop: ret #0
+
 The above example code can be placed into a file (here called "foo"), and
 then be passed to the bpf_asm tool for generating opcodes, output that xt_bpf
 and cls_bpf understands and can directly be loaded with. Example with above
-- 
2.17.1

