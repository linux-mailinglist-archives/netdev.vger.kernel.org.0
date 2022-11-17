Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EBD62D5C1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiKQJEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiKQJEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:04:08 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94C656EFD
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:04:07 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p141so899326iod.6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFbHHqhyDIjVW1NX7EMMrqzGcWcL3YBAWVCvlJhqqR8=;
        b=tdsQXbmcLAGssIgEhaPNAsav/5IBmS7ya2SxLXOAKEiG7BKen4mDbmPx/5H4pwSLQs
         vqzpdAqXIJmAz0rnnyhK5XjH5ekIduVJNv6AU+kPIZj6ttkCSC/l0ZMP/eCPPB3aDCJR
         mupDsiowO2+yEDVLA5ly8B6360Zjpta106lRsoEoHETOjqNEumLJYkXjXs6jrmiHW1Tw
         6L8PUhTDZJ3QTd6zbDFIitAeBkVccT+XuWn4Yo5FT8VezAarz91p4lSO8tVlZIxVC1Ze
         iHKb383VxwvWyVIdnI3emXEqEho5TbEjbstYjr8DLXg1Z+bOEnpCKwqD7HFbrEb3VNWk
         TYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFbHHqhyDIjVW1NX7EMMrqzGcWcL3YBAWVCvlJhqqR8=;
        b=xZvOSGiG/x431j4Gi7PPYu9jPrF3cQAcpKVIEnAbXXyS12Pgiowu4zM6ryWvU5ixn1
         YmSpoQpRmanQlv6jpjRaOqIxkOEzQFErsWO4xEhmwbr3L92qSgxdTQbbxBOH7Aa2dM56
         GcjOgke7Fsa96GrW5P+wsel5f+ZbVysuzhuNYRMMG2GGCZuFC/3cw5mBKHcUg16CkOJ6
         nc5YnpGbcDckGrDB/pIEdlJg494m1YI8fDoorWKvfaGtUORT6WoB8jkJ2ydW+NK+IW4m
         uuVFzT6Z+lSPQbzA5QI/fq0O8je/LKpkU13JtgCpV6pxGj2mzZhtg9AMPQ5mAngrIFb0
         W7ng==
X-Gm-Message-State: ANoB5pnRm6zL0v15rOtAbRaMtiadJUCcMJuo6l3Q26RJNJCbTr6Kvttv
        BxUFJ02xkFXnq5Axb44LRWRpb4OmEWkYBHYYem3V7g==
X-Google-Smtp-Source: AA0mqf7jAIntsV6CY9bgvSv+dHzPWh/bZTRjwWi9SqnNtZ6/VE8nUsYH3ZtQHo8Hv5HzGIOmenpyUiPHTP5oFVioaW0=
X-Received: by 2002:a02:cc4d:0:b0:373:2fc2:96d7 with SMTP id
 i13-20020a02cc4d000000b003732fc296d7mr614253jaq.177.1668675847000; Thu, 17
 Nov 2022 01:04:07 -0800 (PST)
MIME-Version: 1.0
References: <20221115182051.582962-1-bjorn@kernel.org> <20221115182051.582962-2-bjorn@kernel.org>
In-Reply-To: <20221115182051.582962-2-bjorn@kernel.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 17 Nov 2022 10:03:56 +0100
Message-ID: <CADYN=9J-Uno-CftASGsguaKuqyHdX3+=7bfD5vDvRNnbpgP7aw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Pass target triple to
 get_sys_includes macro
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        Mykola Lysenko <mykolal@fb.com>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 at 19:21, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>
> When cross-compiling [1], the get_sys_includes make macro should use
> the target system include path, and not the build hosts system include
> path.
>
> Make clang honor the CROSS_COMPILE triple.
>
> [1] e.g. "ARCH=3Driscv CROSS_COMPILE=3Driscv64-linux-gnu- make"
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>

For both patches.
Tested-by: Anders Roxell <anders.roxell@linaro.org>

> ---
>  tools/testing/selftests/bpf/Makefile | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 8f8ede30e94e..a2a1eae75820 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -309,9 +309,9 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)=
/resolve_btfids        \
>  # Use '-idirafter': Don't interfere with include mechanics except where =
the
>  # build would have failed anyways.
>  define get_sys_includes
> -$(shell $(1) -v -E - </dev/null 2>&1 \
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
>         | sed -n '/<...> search starts here:/,/End of search list./{ s| \=
(/.*\)|-idirafter \1|p }') \
> -$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("=
-D__riscv_xlen=3D%d -D__BITS_PER_LONG=3D%d", $$3, $$3)}')
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{pri=
ntf("-D__riscv_xlen=3D%d -D__BITS_PER_LONG=3D%d", $$3, $$3)}')
>  endef
>
>  # Determine target endianness.
> @@ -319,7 +319,11 @@ IS_LITTLE_ENDIAN =3D $(shell $(CC) -dM -E - </dev/nu=
ll | \
>                         grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN=
__')
>  MENDIAN=3D$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>
> -CLANG_SYS_INCLUDES =3D $(call get_sys_includes,$(CLANG))
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH =3D --target=3D$(notdir $(CROSS_COMPILE:%-=3D%))
> +endif
> +
> +CLANG_SYS_INCLUDES =3D $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_A=
RCH))

Maybe it would make sense to move this trick into selftests/lib.mk
since there are more Makefiles that
would benefit from this, like tc-testing or net/bpf to name a few.

Cheers,
Anders

>  BPF_CFLAGS =3D -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)         =
 \
>              -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
>              -I$(abspath $(OUTPUT)/../usr/include)
> @@ -539,7 +543,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs,no_alu32)=
)
>  # Define test_progs BPF-GCC-flavored test runner.
>  ifneq ($(BPF_GCC),)
>  TRUNNER_BPF_BUILD_RULE :=3D GCC_BPF_BUILD_RULE
> -TRUNNER_BPF_CFLAGS :=3D $(BPF_CFLAGS) $(call get_sys_includes,gcc)
> +TRUNNER_BPF_CFLAGS :=3D $(BPF_CFLAGS) $(call get_sys_includes,gcc,)
>  $(eval $(call DEFINE_TEST_RUNNER,test_progs,bpf_gcc))
>  endif
>
> --
> 2.37.2
>
