Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6468E017
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjBGScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbjBGScJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:32:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD6EC5A;
        Tue,  7 Feb 2023 10:31:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l14so7353026eds.4;
        Tue, 07 Feb 2023 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRPGNYx4zbkv1vK8uhe4WUCPicC2777gx0KAHFULHZs=;
        b=RtWKXiMTdXXGVxqDHUyLmmVnzRy7u20T0gb5ZlUTdaQiGgRB4H5I0bAb9ZyE0X/eZQ
         6pnweIOvqDggJhafj2YVp921cAi1cY6D2IjSGTXcI3xoM2KPpiozIz+w7QmSbMHwmJNP
         mlTRBCLUPMXrLSxxe3sudEDhLV8VtqAwlUZoyJefvEYht4BXGVc6v2NVsc2hQydVk5Za
         2PxIZ/eHBtK2YcfWCHHtSnPQG7cHgQO3hRIZFS1AWk/FGNPICEsB04gAIl/qk+rx9FBf
         XLPcC4SsYO0fX+L3LwaOzcqTcliP6cTyxuMKxc8BYcOvJUzLPXV8DuF6zjLLxQixFvXT
         xURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRPGNYx4zbkv1vK8uhe4WUCPicC2777gx0KAHFULHZs=;
        b=pLvMyps8ERlTXfswikiq88HSqL9JuBHzwcb/A+jxKKU3MIEGn9u249/MEIj0N/VrqA
         M0RDYtjTM3dyHyT/Wd/7tIs3dbmEgsr/drOlfSgISAFtksuyFvH4AUMA2Xfj9dm0y+zA
         I9FFaOA/Unq3AR3Du2QmHC3Bv0b9SQ8GwLUpbN2hixW3RkSdIgyRzNnVbRBOrTBtoGKm
         Nccr200sY5qS+C+/Zi05KLamaDtIwJWIZfTzsDaWgku2Tn34Mcps+8nmSn8KakF3vKF/
         bJbuImVVOLru2x530+YEWN1wz8FaCqzruTuSn1diMD1Q/cxJH3BgUByOZNT4hnzoPWXO
         92nw==
X-Gm-Message-State: AO0yUKV+JtC9H2JiJTKn0c/X/gBuc8zGpCgCs8PPmTaOpY7fMx6WC6tK
        LkCO0Ub72r+VZDc5H32ZxYK/UCpZzoUx1UF3rhGZGEzK2C8=
X-Google-Smtp-Source: AK7set9uMqQcs3pigv7hrBgOYXeLNRFHwOkt11G6mk0WHPSfaIqWxVBTMZYp0BxWjRNd8yRNlcRViTFklg2hwzYIkBo=
X-Received: by 2002:a50:9ecb:0:b0:49d:ec5d:28b4 with SMTP id
 a69-20020a509ecb000000b0049dec5d28b4mr896586edf.6.1675794708436; Tue, 07 Feb
 2023 10:31:48 -0800 (PST)
MIME-Version: 1.0
References: <d1440852-3a3b-7b46-6ad6-a06cd5a3fb62@uliege.be>
In-Reply-To: <d1440852-3a3b-7b46-6ad6-a06cd5a3fb62@uliege.be>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Feb 2023 10:31:37 -0800
Message-ID: <CAADnVQL87R07UM3prVPwVmz_e2+uuO67QmXJxXqECgjt3S=54w@mail.gmail.com>
Subject: Re: [QUESTION] bpf, iproute2/tc: verifier fails because of a map
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 7, 2023 at 3:09 AM Justin Iurman <justin.iurman@uliege.be> wrot=
e:
>
> Hello,
>
> CC'ing netdev as well, since I initially suspected an issue in iproute2.
> However, after having recompiled iproute2 with libbpf, I'm still stuck
> facing the same problem.
>
> Environment:
>   - OS: Ubuntu 20.04.5 LTS
>   - kernel: 5.4.0-137-generic x86_64 (CONFIG_DEBUG_INFO_BTF=3Dy)
>   - clang version 10.0.0-4ubuntu1
>   - iproute2-6.1.0, libbpf 1.2.0 (iproute2-ss200127 installed by default
> without libbpf)
>
> Note: same result with kernel 6.2.0-rc6+ (net-next), as a test to be
> aligned with latest iproute2 version (just in case).
>
> Long story short: I can't for the life of me make the ebpf program load
> correctly with tc. What's the cause? Well, a map, and the verifier
> doesn't like it. I must definitely be doing something wrong, but can't
> find what. Here is a reproducible and minimal example:
>
> #include "vmlinux.h"
> #include <bpf/bpf_helpers.h>
>
> #define TC_ACT_OK 0
> #define MAX_BYTES 2048
>
> char _license[] SEC("license") =3D "GPL";
>
> struct mystruct_t {
>         __u8 bytes[MAX_BYTES];
> };
>
> struct {
>         __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>         __uint(key_size, sizeof(__u8));
>         __uint(value_size, sizeof(struct mystruct_t));
>         __uint(max_entries, 1);
> } percpu_map SEC(".maps");
>
> SEC("egress")
> int xxx(struct __sk_buff *skb)
> {
>         __u8 idx =3D 0;
>         struct mystruct_t *x =3D bpf_map_lookup_elem(&percpu_map, &idx);
>         return TC_ACT_OK;
> }
>
>
> Here is how I compile the whole thing:
>
> git clone --recursive --depth 1 https://github.com/libbpf/libbpf
> ./deps/libbpf
> make -j -C deps/libbpf/src/ BUILD_STATIC_ONLY=3Dy DESTDIR=3D"build"
> INCLUDEDIR=3D LIBDIR=3D UAPIDIR=3D install
>
> git clone --recursive --depth 1 https://github.com/libbpf/bpftool
> ./deps/bpftool
> make -j -C deps/bpftool/src/
> deps/bpftool/src/bpftool btf dump file /sys/kernel/btf/vmlinux format c
>  > build/vmlinux.h
>
> clang -g -O2 -Wall -Wextra -target bpf -D__TARGET_ARCH_x86_64 -I build/
> -c program.c -o build/program.o
>
>
> I noticed that "clang-bpf-co-re" is OFF when compiling bpftool, don't
> know if it's part of the problem or not. Here is what the "build"
> directory looks like after that:
>
> $ ls -al build
> [...]
> drwxr-xr-x 2 justin justin    4096 f=C3=A9v  6 18:20 bpf
> -rw-rw-r-- 1 justin justin 3936504 f=C3=A9v  6 18:20 libbpf.a
> drwxr-xr-x 2 justin justin    4096 f=C3=A9v  6 18:20 pkgconfig
> -rw-rw-r-- 1 justin justin   10592 f=C3=A9v  7 10:42 program.o
> -rw-rw-r-- 1 justin justin 2467774 f=C3=A9v  7 10:42 vmlinux.h
>
>
> And here is the verifier error I got when loading it with tc (qdisc
> clsact already attached):
>
> $ sudo ../deps/iproute2/tc/tc filter add dev eno2 egress bpf da obj
> program.o sec egress
>
> libbpf: map 'percpu_map': failed to create: Invalid argument(-22)
> libbpf: failed to load object 'program.o'
> Unable to load program

It's likely due to
__uint(key_size, sizeof(__u8));

https://docs.kernel.org/bpf/map_array.html
"The key type is an unsigned 32-bit integer (4 bytes) and the map is
of constant size."
