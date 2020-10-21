Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862FB2954C0
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 00:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506626AbgJUWVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 18:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506524AbgJUWVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 18:21:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8156BC0613CE;
        Wed, 21 Oct 2020 15:21:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dt13so5439227ejb.12;
        Wed, 21 Oct 2020 15:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HOPS17MnD2/ADZ5OZQOcxNaeJKtI2OvGMQBZPZXupKU=;
        b=PJKi5TCa5LnXALDoyfymwRXzWRRK5QXjxFPMxyg0qNRCrJPZdQlI+x8BmfSAUNFVzs
         XTgaL4sDYJBnrRKENaPxM175pW0LJRNVmYu6BdtdJUnFIE5nkDUNzReResXiPKBrCwal
         KXIHryZSgPsTcUFpn3O32RU9UAGsd/Ho+JbX9r07FiVSuXPbCafHP6RQsjE+XzRlZz6F
         LEsorRNkDHq7ecH5lsHccIWPXiWjRzs+lDBdbNGFZRcxHUz1Ton4GYzVWALUZRECT0MD
         8Jl5g0C/yncAVNwXWPG5bk1Qv1831VCGOUd+/wVg7GAP1k643Rl4jmK+WkGSnjojeWA/
         Ch1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HOPS17MnD2/ADZ5OZQOcxNaeJKtI2OvGMQBZPZXupKU=;
        b=Jpv0E+0Jd4jGQHj106eofiXxFfm6gBEx8Trh3U8ki54W/yrmNjqHbHhEFeJ1LBxu+9
         9OyA4Vifx4PrbqTc8YjC3JH2n0Rat150nQ8UYkBCIkNFKvOpt4IBotbNEdnwAlCyrgVZ
         yJpEJnVRl8Acto2/1hR0A8sY31H8EB0za+XRlbtSDxHEnsa3UeT/LV0Rd84+tdKAS+4Z
         q70zi42zYWzaALun8Ec0H5fE/vDdKAJBQEcRO/5YJPxfhlHKfYZzAuOvjX1PWI+QpqZf
         EaA3fo5ZlGWuO9BLgSCj3wPMuAFQa1n7RaPVwum590iNHD7u+0G1RSr/5yfDmleH+Zo1
         /50A==
X-Gm-Message-State: AOAM530QhU3F+5h0bGW1EyMQjl5aYCLGLRkDJfOwQQv04ZPP+o11xNy1
        fHrXSooCMbuYfPcA6rsE0Oc23pnyFrJe3x0jyRs=
X-Google-Smtp-Source: ABdhPJyWzkeLPY87fCx3fRwITK49pK1YZk0Ebalg2n1PN2KH0tiPEcKsXCB7cd56i2oYh/BuB1xfn9TCHEsfwqjAsL0=
X-Received: by 2002:a17:906:1418:: with SMTP id p24mr5635256ejc.46.1603318867155;
 Wed, 21 Oct 2020 15:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201021203257.26223-1-daniel@iogearbox.net>
In-Reply-To: <20201021203257.26223-1-daniel@iogearbox.net>
From:   Yaniv Agman <yanivagman@gmail.com>
Date:   Thu, 22 Oct 2020 01:20:56 +0300
Message-ID: <CAMy7=ZVJS8xB-6Hq_StfBnrK7jBmrn1OSmHHzQk2_mOb=G+pfQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, libbpf: guard bpf inline asm from bpf_tail_call_static
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     alexei.starovoitov@gmail.com, bpf <bpf@vger.kernel.org>,
        netdev@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=AB=D7=91=D7=AA=D7=90=D7=A8=D7=99=D7=9A =D7=99=D7=95=D7=9D =D7=93=D7=
=B3, 21 =D7=91=D7=90=D7=95=D7=A7=D7=B3 2020 =D7=91-23:33 =D7=9E=D7=90=D7=AA=
 =E2=80=AADaniel Borkmann=E2=80=AC=E2=80=8F
<=E2=80=AAdaniel@iogearbox.net=E2=80=AC=E2=80=8F>:=E2=80=AC
>
> Yaniv reported a compilation error after pulling latest libbpf:
>
>   [...]
>   ../libbpf/src/root/usr/include/bpf/bpf_helpers.h:99:10: error:
>   unknown register name 'r0' in asm
>                      : "r0", "r1", "r2", "r3", "r4", "r5");
>   [...]
>
> The issue got triggered given Yaniv was compiling tracing programs with n=
ative
> target (e.g. x86) instead of BPF target, hence no BTF generated vmlinux.h=
 nor
> CO-RE used, and later llc with -march=3Dbpf was invoked to compile from L=
LVM IR
> to BPF object file. Given that clang was expecting x86 inline asm and not=
 BPF
> one the error complained that these regs don't exist on the former.
>
> Guard bpf_tail_call_static() with defined(__bpf__) where BPF inline asm i=
s valid
> to use. BPF tracing programs on more modern kernels use BPF target anyway=
 and
> thus the bpf_tail_call_static() function will be available for them. BPF =
inline
> asm is supported since clang 7 (clang <=3D 6 otherwise throws same above =
error),
> and __bpf_unreachable() since clang 8, therefore include the latter condi=
tion
> in order to prevent compilation errors for older clang versions. Given ev=
en an
> old Ubuntu 18.04 LTS has official LLVM packages all the way up to llvm-10=
, I did
> not bother to special case the __bpf_unreachable() inside bpf_tail_call_s=
tatic()
> further.
>
> Fixes: 0e9f6841f664 ("bpf, libbpf: Add bpf_tail_call_static helper for bp=
f programs")
> Reported-by: Yaniv Agman <yanivagman@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://lore.kernel.org/bpf/CAMy7=3DZUk08w5Gc2Z-EKi4JFtuUCaZYmE4yzh=
JjrExXpYKR4L8w@mail.gmail.com
> ---
>  tools/lib/bpf/bpf_helpers.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 2bdb7d6dbad2..72b251110c4d 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -72,6 +72,7 @@
>  /*
>   * Helper function to perform a tail call with a constant/immediate map =
slot.
>   */
> +#if __clang_major__ >=3D 8 && defined(__bpf__)
>  static __always_inline void
>  bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
>  {
> @@ -98,6 +99,7 @@ bpf_tail_call_static(void *ctx, const void *map, const =
__u32 slot)
>                      :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
>                      : "r0", "r1", "r2", "r3", "r4", "r5");
>  }
> +#endif
>
>  /*
>   * Helper structure used by eBPF C program
> --
> 2.17.1
>

Tested-by: Yaniv Agman <yanivagman@gmail.com>
