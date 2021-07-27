Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418543D746F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhG0Ljl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhG0Lji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 07:39:38 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB6BC061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 04:39:30 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id p5so9719425wro.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 04:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h2m8MDNRUeecSVOD85AOxrv5mxE54jWuAS006+0+LsA=;
        b=SozljIC5zKcUuv56DIesOYSDJixp4GmrIaq4adqtdlCgI+a1Wo6IFZ5/eiDGk7u5jq
         dVv43z+Q3pSdD+JaCAlbH+T+MJRpKgPRHY+vLtHZVK1l2prK6Rg5FGUMLKrzX+xlKEIH
         cmNezPWC7h2SQULE7XE4QE79RO1oh6VWGciHScGB7T3TlS+lJl9xDDw4gaAjddaDN3zC
         n5AQa7A9LX/WJriHRav/yFhnBrHYSyc9Ba3WzkU8swQTNK6S6+7oXeFrpr6AKQDVBVs1
         PpTVTqxKFes8OnrMZa68ior1YtVvx5zeHvqH/EfV54lkFrs6iiwgUJn9/wv7+eGudTTN
         sMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h2m8MDNRUeecSVOD85AOxrv5mxE54jWuAS006+0+LsA=;
        b=iu+cCxaZm0bwBHNnI6kitOiotIqD4m9tkZmDxEkJ8UUFn+IjgsSYvHysTuXOMsVkHz
         AsRh5LnO88GWwBcFq4EoqUI9NJUcRoB8XgolqKLlTi1AyUzd8bx1yvV5leElHrFN468z
         RPOHSndy0USojJoSOVGr2ote7/Cw/fW1N99m5Bs6ga+ZYN4ShPSt5Kky89cHMEmsWo/p
         vT3bttgFeNYSG9g7kAY72FlCMfAzvizhUcWU+a9os3DySUO9ztr59BLbL3FhP+7tMFlf
         wsfTYBToSQOMFV5t2Ur1FhHjGgIgMet2bv1Cwry88mfrU0E0nr2tF3Q2YUZ7fItLHUrZ
         Hn2A==
X-Gm-Message-State: AOAM530tNy8BoreHpLLRAaiCjSRKe8bUn4iUK5etnMdqKIKcBFkIzP6u
        sC0a63OXvTWcRrtZP51XqkFw2Q==
X-Google-Smtp-Source: ABdhPJzOOIn5jRuwokNkhxUndOgzFs86Nej7c9EIpALDA/yA8fINtaoAKbYy/BgwmFpYSQ7rhnh5KQ==
X-Received: by 2002:a5d:5685:: with SMTP id f5mr9343743wrv.369.1627385968948;
        Tue, 27 Jul 2021 04:39:28 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.74.3])
        by smtp.gmail.com with ESMTPSA id h15sm2804807wrq.88.2021.07.27.04.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 04:39:28 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210721153808.6902-1-quentin@isovalent.com>
 <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
 <CAEf4BzZZXx28w1y_6xfsue91c_7whvHzMhKvbSnsQRU4yA+RwA@mail.gmail.com>
 <82e61e60-e2e9-f42d-8e49-bbe416b7513d@isovalent.com>
 <CAEf4BzYpCr=Vdfc3moaapQqBxYV3SKfD72s0F=FAh_zLzSqxqA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <bb0d3640-c6da-a802-4794-50cd033119ac@isovalent.com>
Date:   Tue, 27 Jul 2021 12:39:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYpCr=Vdfc3moaapQqBxYV3SKfD72s0F=FAh_zLzSqxqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-23 08:51 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, Jul 23, 2021 at 2:58 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2021-07-22 19:45 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> On Thu, Jul 22, 2021 at 5:58 PM Andrii Nakryiko
>>> <andrii.nakryiko@gmail.com> wrote:
>>>>
>>>> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>
>>>>> As part of the effort to move towards a v1.0 for libbpf [0], this set
>>>>> improves some confusing function names related to BTF loading from and to
>>>>> the kernel:
>>>>>
>>>>> - btf__load() becomes btf__load_into_kernel().
>>>>> - btf__get_from_id becomes btf__load_from_kernel_by_id().
>>>>> - A new version btf__load_from_kernel_by_id_split() extends the former to
>>>>>   add support for split BTF.
>>>>>
>>>>> The old functions are not removed or marked as deprecated yet, there
>>>>> should be in a future libbpf version.
>>>>
>>>> Oh, and I was thinking about this whole deprecation having to be done
>>>> in two steps. It's super annoying to keep track of that. Ideally, we'd
>>>> have some macro that can mark API deprecated "in the future", when
>>>> actual libbpf version is >= to defined version. So something like
>>>> this:
>>>>
>>>> LIBBPF_DEPRECATED_AFTER(V(0,5), "API that will be marked deprecated in v0.6")
>>>
>>> Better:
>>>
>>> LIBBPF_DEPRECATED_SINCE(0, 6, "API that will be marked deprecated in v0.6")

So I've been looking into this, and it's not _that_ simple to do. Unless
I missed something about preprocessing macros, I cannot bake a "#if" in
a "#define", to have the attribute printed if and only if the current
version is >= 0.6 in this example.

I've come up with something, but it is not optimal because I have to
write a check and macros for each version number used with the
LIBBPF_DEPRECATED_SINCE macro. If we really wanted to automate that part
I guess we could generate a header with those macros from the Makefile
and include it in libbpf_common.h, but that does not really look much
cleaner to me.

Here's my current code, below - does it correspond to what you had in
mind? Or did you think of something else?

------

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index ec14aa725bb0..095d5dc30d50 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -8,6 +8,7 @@ LIBBPF_VERSION := $(shell \
 	grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
 	sort -rV | head -n1 | cut -d'_' -f2)
 LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
+LIBBPF_MINOR_VERSION := $(firstword $(subst ., ,$(subst $(LIBBPF_MAJOR_VERSION)., ,$(LIBBPF_VERSION))))
 
 MAKEFLAGS += --no-print-directory
 
@@ -86,6 +87,8 @@ override CFLAGS += -Werror -Wall
 override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
 override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+override CFLAGS += -DLIBBPF_MAJOR_VERSION=$(LIBBPF_MAJOR_VERSION)
+override CFLAGS += -DLIBBPF_MINOR_VERSION=$(LIBBPF_MINOR_VERSION)
 
 # flags specific for shared library
 SHLIB_FLAGS := -DSHARED -fPIC
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index cf8490f95641..8b6b5442dbd8 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -45,7 +45,8 @@ LIBBPF_API struct btf *btf__parse_raw(const char *path);
 LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
 LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
 LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id, struct btf *base_btf);
-LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
+LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")
+int btf__get_from_id(__u32 id, struct btf **btf);
 
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
diff --git a/tools/lib/bpf/libbpf_common.h b/tools/lib/bpf/libbpf_common.h
index 947d8bd8a7bb..9ba9f8135dc8 100644
--- a/tools/lib/bpf/libbpf_common.h
+++ b/tools/lib/bpf/libbpf_common.h
@@ -17,6 +17,28 @@
 
 #define LIBBPF_DEPRECATED(msg) __attribute__((deprecated(msg)))
 
+#ifndef LIBBPF_DEPRECATED_SINCE
+#define __LIBBPF_VERSION_CHECK(major, minor) \
+	LIBBPF_MAJOR_VERSION > major || \
+		(LIBBPF_MAJOR_VERSION == major && LIBBPF_MINOR_VERSION >= minor)
+
+/* Add checks for other versions below when planning deprecation of API symbols
+ * with the LIBBPF_DEPRECATED_SINCE macro.
+ */
+#if __LIBBPF_VERSION_CHECK(0, 6)
+#define __LIBBPF_MARK_DEPRECATED_0_6(X) X
+#else
+#define __LIBBPF_MARK_DEPRECATED_0_6(X)
+#endif
+
+#define __LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
+	__LIBBPF_MARK_DEPRECATED_ ## major ## _ ## minor (LIBBPF_DEPRECATED("v" # major "." # minor "+, " msg))
+
+/* Mark a symbol as deprecated when libbpf version is >= {major}.{minor} */
+#define LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
+	__LIBBPF_DEPRECATED_SINCE(major, minor, msg)
+#endif /* LIBBPF_DEPRECATED_SINCE */
+
 /* Helper macro to declare and initialize libbpf options struct
  *
  * This dance with uninitialized declaration, followed by memset to zero,
