Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFE413DCA
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 01:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhIUXCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 19:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhIUXCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 19:02:13 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8BEC061574;
        Tue, 21 Sep 2021 16:00:44 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id a10so2723021qka.12;
        Tue, 21 Sep 2021 16:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N74y+TWjybDoSEmbP8hU+VagKyCqsr1KnsoCyyTIHWI=;
        b=X8/EpRAZ3m37M8NiDfYSazoUQ1aMhLKxSOxuu5qjtE10YkGp/hSmLQYHbGnv5s5HwY
         VaR2/HqwVAgyOmPJcZNwcp2OT5LvzOxlvOKlSS/6LUwmlyEIrc3ZrFvayf0QIce0dGFq
         t3PIDu8S2JFPJEa9HYwzFdA5jRdqWHSna2t5FDnsnhsiVHUPVF3gEsebpit4WXyDPJy0
         8WImhU2PmE8aIu9x22aHBI7vJkvfW0XR9ywn7UymM8iWaAKYFp7Ud4A8+Kxf0/EBbYAe
         2L/iLW4EU5A8ZPD4fn8hKoCyxw4z+7xHmzMjPF1rBB9DqvvdiV+cXK0mscWpj9h8EPAU
         XVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N74y+TWjybDoSEmbP8hU+VagKyCqsr1KnsoCyyTIHWI=;
        b=A/PyNJiJnIxHTvTcQUe+O96y8R1HR4/N/Gv6yXN2lZ97lMGMJMMo6L/MR4eKA1oChG
         uLRlVWmd64ZpWETKXyxK+1Cey/E6ysgxSlwp3R85+Qeo81pZrxOdMKAi7+dCjafi8ewh
         55bc5y6MU/K6ozxTPjgmkS2ixnBE2P0gv6PNZFDKAv6pq8dJRL2Iqs8kREJ9KARsYwJI
         Z95yNRN6g47Lanvjej+u0XV1uRu/Ly/YxmxPqTjWd4O32cnacCmCswbHJD7OUXKW3ZCP
         HI9ScC6mzO7F1mNHWcY30f9G4QZRCvsYgO+M9T9Avxuos7yoTTuu2hNcagU35NY/ENaV
         QRPg==
X-Gm-Message-State: AOAM531sdxPCmq2lPinStcaYfCOKdQMrmT7Xh7RviLIPUwNith6ZGH1P
        iLReKsS7/j9aXlyFmsvmR/fNRiQYe+9y1++cMXFi7NI5sTs=
X-Google-Smtp-Source: ABdhPJxE/jTN2yzWSHiD46iGVP7ZU5in63LDnvQIzIJK8QwxVnKuYuvYoWuqa9HJCYGIKsxLf97HOZ34iy8OpZEDuIQ=
X-Received: by 2002:a25:1bc5:: with SMTP id b188mr40874520ybb.267.1632265243936;
 Tue, 21 Sep 2021 16:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-12-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-12-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 16:00:32 -0700
Message-ID: <CAEf4Bza5GxHb+=PQUOKWQ=BD3kCCEOYjDLKSdsPRZu468KAePg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: selftests: Add selftests for
 module kfunc support
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:16 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds selftests that tests the success and failure path for modules
> kfuncs (in presence of invalid kfunc calls) for both libbpf and
> gen_loader. It also adds a prog_test kfunc_btf_id_list so that we can
> add module BTF ID set from bpf_testmod.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h                           |  2 +
>  kernel/bpf/btf.c                              |  2 +
>  net/bpf/test_run.c                            |  5 +-
>  tools/testing/selftests/bpf/Makefile          |  5 +-
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 26 ++++++-
>  .../selftests/bpf/prog_tests/ksyms_module.c   | 52 ++++++++++----
>  .../bpf/prog_tests/ksyms_module_libbpf.c      | 44 ++++++++++++
>  .../selftests/bpf/progs/test_ksyms_module.c   | 41 ++++++++---
>  .../bpf/progs/test_ksyms_module_fail.c        | 29 ++++++++
>  .../progs/test_ksyms_module_fail_toomany.c    | 19 +++++
>  .../bpf/progs/test_ksyms_module_libbpf.c      | 71 +++++++++++++++++++
>  .../bpf/progs/test_ksyms_module_util.h        | 48 +++++++++++++
>  12 files changed, 317 insertions(+), 27 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
>

[...]

> @@ -243,7 +244,9 @@ BTF_SET_END(test_sk_kfunc_ids)
>
>  bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
>  {
> -       return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
> +       if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
> +               return true;
> +       return __bpf_check_prog_test_kfunc_call(kfunc_id, owner);
>  }
>
>  static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 326ea75ce99e..d20ff0563120 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
>         $(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
>         $(Q)$(MAKE) $(submake_extras) -C bpf_testmod
>         $(Q)cp bpf_testmod/bpf_testmod.ko $@
> +       $(Q)$(RESOLVE_BTFIDS) -s ../../../../vmlinux bpf_testmod.ko

$(VMLINUX_BTF) instead of "../../../../vmlinux", it will break

>
>  $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
>         $(call msg,CC,,$@)
> @@ -315,8 +316,8 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
>                 linked_vars.skel.h linked_maps.skel.h
>
>  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> -       test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
> -       trace_vprintk.c
> +       test_ksyms_module.c test_ksyms_module_fail.c test_ksyms_module_fail_toomany.c \
> +       test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
>  SKEL_BLACKLIST += $$(LSKELS)
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h b/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
> new file mode 100644
> index 000000000000..3afa74841ae0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef __KSYMS_MODULE_UTIL_H__
> +#define __KSYMS_MODULE_UTIL_H__
> +
> +#define __KFUNC_NR_EXP(Y)                                                      \
> +Y(0) Y(1) Y(2) Y(3) Y(4) Y(5) Y(6) Y(7) Y(8) Y(9) Y(10) Y(11) Y(12)            \
> +Y(13) Y(14) Y(15) Y(16) Y(17) Y(18) Y(19) Y(20) Y(21) Y(22) Y(23)              \
> +Y(24) Y(25) Y(26) Y(27) Y(28) Y(29) Y(30) Y(31) Y(32) Y(33) Y(34)              \
> +Y(35) Y(36) Y(37) Y(38) Y(39) Y(40) Y(41) Y(42) Y(43) Y(44) Y(45)              \
> +Y(46) Y(47) Y(48) Y(49) Y(50) Y(51) Y(52) Y(53) Y(54) Y(55) Y(56)              \
> +Y(57) Y(58) Y(59) Y(60) Y(61) Y(62) Y(63) Y(64) Y(65) Y(66) Y(67)              \
> +Y(68) Y(69) Y(70) Y(71) Y(72) Y(73) Y(74) Y(75) Y(76) Y(77) Y(78)              \
> +Y(79) Y(80) Y(81) Y(82) Y(83) Y(84) Y(85) Y(86) Y(87) Y(88) Y(89)              \
> +Y(90) Y(91) Y(92) Y(93) Y(94) Y(95) Y(96) Y(97) Y(98) Y(99) Y(100)             \
> +Y(101) Y(102) Y(103) Y(104) Y(105) Y(106) Y(107) Y(108) Y(109) Y(110)          \
> +Y(111) Y(112) Y(113) Y(114) Y(115) Y(116) Y(117) Y(118) Y(119) Y(120)          \
> +Y(121) Y(122) Y(123) Y(124) Y(125) Y(126) Y(127) Y(128) Y(129) Y(130)          \
> +Y(131) Y(132) Y(133) Y(134) Y(135) Y(136) Y(137) Y(138) Y(139) Y(140)          \
> +Y(141) Y(142) Y(143) Y(144) Y(145) Y(146) Y(147) Y(148) Y(149) Y(150)          \
> +Y(151) Y(152) Y(153) Y(154) Y(155) Y(156) Y(157) Y(158) Y(159) Y(160)          \
> +Y(161) Y(162) Y(163) Y(164) Y(165) Y(166) Y(167) Y(168) Y(169) Y(170)          \
> +Y(171) Y(172) Y(173) Y(174) Y(175) Y(176) Y(177) Y(178) Y(179) Y(180)          \
> +Y(181) Y(182) Y(183) Y(184) Y(185) Y(186) Y(187) Y(188) Y(189) Y(190)          \
> +Y(191) Y(192) Y(193) Y(194) Y(195) Y(196) Y(197) Y(198) Y(199) Y(200)          \
> +Y(201) Y(202) Y(203) Y(204) Y(205) Y(206) Y(207) Y(208) Y(209) Y(210)          \
> +Y(211) Y(212) Y(213) Y(214) Y(215) Y(216) Y(217) Y(218) Y(219) Y(220)          \
> +Y(221) Y(222) Y(223) Y(224) Y(225) Y(226) Y(227) Y(228) Y(229) Y(230)          \
> +Y(231) Y(232) Y(233) Y(234) Y(235) Y(236) Y(237) Y(238) Y(239) Y(240)          \
> +Y(241) Y(242) Y(243) Y(244) Y(245) Y(246) Y(247) Y(248) Y(249) Y(250)          \
> +Y(251) Y(252) Y(253) Y(254) Y(255)
> +
> +#define __KFUNC_A(nr) bpf_testmod_test_mod_kfunc_##nr();
> +#define KFUNC_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_A)
> +
> +#define __KFUNC_B(nr) extern void bpf_testmod_test_mod_kfunc_##nr(void) __ksym;
> +#define KFUNC_KSYM_DECLARE_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_B)
> +
> +#define __KFUNC_C(nr) noinline void bpf_testmod_test_mod_kfunc_##nr(void) {};
> +#define KFUNC_DEFINE_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_C)
> +
> +#define __KFUNC_D(nr) BTF_ID(func, bpf_testmod_test_mod_kfunc_##nr)
> +#define KFUNC_BTF_ID_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_D)
> +
> +#define __KFUNC_E(nr) bpf_testmod_test_mod_kfunc(nr);
> +#define KFUNC_VALID_SAME_ONE __KFUNC_E(0)
> +#define KFUNC_VALID_SAME_256 __KFUNC_NR_EXP(__KFUNC_E)
> +

This is pretty horrible... Wouldn't it be better to test limits like
this using the test_verifier approach, where we can craft a *short*
sequence of instructions that will test all these limits?...


> +#endif
> --
> 2.33.0
>
