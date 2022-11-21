Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400AA631EA9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKUKp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUKpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:45:51 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1295F9059A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:45:46 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n20so27668448ejh.0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PES5KmT8V4mZsBqkcHDpiFZMsMOq6o0C0cxaE+yQVIk=;
        b=StsBVHJL2WDK8lZEh6PmHV7EvhajZA0QqKgcEwD0aC2QRgAh0InlOefbcdZnUxavyJ
         mn4x4hCTPIMp/CMckKX4Qizel06lXhpzmeOd9HHgo7qUW+xa/+JUdyhmWCCJdj6dBvnn
         30qR/A1RiveF7tlib7Dan/JEt5HwEIDjzlXDzOLWdj2tT/MHw1QR+74ZRIjr2uqvbmaA
         rBI5MCd82rNswtcUCkjYBdCx9sigfRNKXj4Ep40Z2ZH7J//S2/SrpyJlRs8TAoZtXt0G
         CwejFpkBpSq/vC3h6dBeFW5C4Geb5I3nL2yYE9zhbiIp5fewXRaa07o3eW0WdlRjMHmG
         x0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PES5KmT8V4mZsBqkcHDpiFZMsMOq6o0C0cxaE+yQVIk=;
        b=Mla77y7qrG+7XuaLQpXTBtN2ZFd7Pus+Rn+e/xlb20rQpu7xYam3hGkcN33iuFL2HN
         ovf0mD1lQLdXbiJgxFWjOx/JRBRxfw+LcWKuB7V2qb2pXCptc4lxRwdymXew1+h1/D8W
         pJmBPLEpDIlHBHqSiNLe1fiuIQQPFSBgcxhhqjF9PRD4DP8wX5zTuBMMk4yry/TbUx74
         xSKeFsa1L70Ct6MlLWAzqMUIOaJq+t0rECqtWFpqiBOBx7Dd/NfaY2YL7u7CXR1g4qh7
         lsI4HQkOyHegfQFHHH/RL1edagRKm+Gxp5vwqEl7nqtxZAV77N9iQROTbEO1nS1Ww2Aw
         AyhQ==
X-Gm-Message-State: ANoB5pkffPdVCnC0LB56gQaGW28tLm/hkwDT+ztE5j1rjYxgHzOv5qfG
        Bmqh9m5J/kFjwfLykUEzJhNemdhZVCcfURzA1m473Q==
X-Google-Smtp-Source: AA0mqf6XeeMB2kMtmTFiNdRQEPgfXhTJc8JSVqxypcPG71JfSPy7GXnrcg9mIxxmw7zCsPOQVjxOjZ97kfmHtlekXb4=
X-Received: by 2002:a17:906:77db:b0:7b2:8a6c:162f with SMTP id
 m27-20020a17090677db00b007b28a6c162fmr14465418ejn.693.1669027544577; Mon, 21
 Nov 2022 02:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20221119171841.2014936-1-bjorn@kernel.org>
In-Reply-To: <20221119171841.2014936-1-bjorn@kernel.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Mon, 21 Nov 2022 11:45:33 +0100
Message-ID: <CADYN=9LxMhccyx6wncjO99am7z+8wNWoMzV3DCSyCdJYktGevg@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests: net: Add cross-compilation support
 for BPF programs
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Lina Wang <lina.wang@mediatek.com>,
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

On Sat, 19 Nov 2022 at 18:19, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>
> The selftests/net does not have proper cross-compilation support, and
> does not properly state libbpf as a dependency. Mimic/copy the BPF
> build from selftests/bpf, which has the nice side-effect that libbpf
> is built as well.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
> ---
> Now that BPF builds are starting to show up in more places
> (selftests/net, and soon selftests/hid), maybe it would be cleaner to
> move parts of the BPF builds to lib.mk?

Yes, since its in tc-testing too.
Maybe thats what we should do already now?

Cheers,
Anders

>
> Bj=C3=B6rn
> ---
>  tools/testing/selftests/net/bpf/Makefile | 45 +++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/sel=
ftests/net/bpf/Makefile
> index 8ccaf8732eb2..a26cb94354f6 100644
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ b/tools/testing/selftests/net/bpf/Makefile
> @@ -1,14 +1,51 @@
>  # SPDX-License-Identifier: GPL-2.0
>
>  CLANG ?=3D clang
> +SCRATCH_DIR :=3D $(OUTPUT)/tools
> +BUILD_DIR :=3D $(SCRATCH_DIR)/build
> +BPFDIR :=3D $(abspath ../../../lib/bpf)
> +APIDIR :=3D $(abspath ../../../include/uapi)
> +
>  CCINCLUDE +=3D -I../../bpf
> -CCINCLUDE +=3D -I../../../../lib
>  CCINCLUDE +=3D -I../../../../../usr/include/
> +CCINCLUDE +=3D -I$(SCRATCH_DIR)/include
> +
> +BPFOBJ :=3D $(BUILD_DIR)/libbpf/libbpf.a
> +
> +MAKE_DIRS :=3D $(BUILD_DIR)/libbpf
> +$(MAKE_DIRS):
> +       mkdir -p $@
>
>  TEST_CUSTOM_PROGS =3D $(OUTPUT)/bpf/nat6to4.o
>  all: $(TEST_CUSTOM_PROGS)
>
> -$(OUTPUT)/%.o: %.c
> -       $(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
> +# Get Clang's default includes on this system, as opposed to those seen =
by
> +# '-target bpf'. This fixes "missing" files on some architectures/distro=
s,
> +# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> +#
> +# Use '-idirafter': Don't interfere with include mechanics except where =
the
> +# build would have failed anyways.
> +define get_sys_includes
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> +       | sed -n '/<...> search starts here:/,/End of search list./{ s| \=
(/.*\)|-idirafter \1|p }') \
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{pri=
ntf("-D__riscv_xlen=3D%d -D__BITS_PER_LONG=3D%d", $$3, $$3)}')
> +endef
> +
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH =3D --target=3D$(notdir $(CROSS_COMPILE:%-=3D%))
> +endif
> +
> +CLANG_SYS_INCLUDES =3D $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_A=
RCH))
> +
> +$(TEST_CUSTOM_PROGS): $(BPFOBJ)
> +       $(CLANG) -O2 -target bpf -c $(@:.o=3D.c) $(CCINCLUDE) $(CLANG_SYS=
_INCLUDES) -o $@
> +
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)              =
      \
> +          $(APIDIR)/linux/bpf.h                                         =
      \
> +          | $(BUILD_DIR)/libbpf
> +       $(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=3D$(BUILD_DIR)/libb=
pf/     \
> +                   EXTRA_CFLAGS=3D'-g -O0'                              =
        \
> +                   DESTDIR=3D$(SCRATCH_DIR) prefix=3D all install_header=
s
> +
> +EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)
>
> -EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS)
>
> base-commit: 8bd8dcc5e47f0f9dc40187c3b8b42d992181eee1
> --
> 2.37.2
>
