Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33F052C65C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiERWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiERWhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:37:06 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FA56D1BE;
        Wed, 18 May 2022 15:37:05 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id a10so3938881ioe.9;
        Wed, 18 May 2022 15:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0UsOrN8L2jk9f8YbUqb1h5IfPLIvfbGbF/K8sUgKLa8=;
        b=pfQVWJSaI650YZeOaa35tgCa5V78lxkK9XS2gIkwjXKHVtvZ425s0Y1UzT4Kg9zhQU
         ki5XTi7DxF06BVh+i3mn+ChDmsAzAG80tP47vzheLmohV7k22GhmgOzR4qZTl5MrEwsT
         lsjqDC0SOna7dZX3qdL6euvQOOCGNeRytsprrHOngAdN1jLqx3AY+M3wFKZXigQxERcD
         bVV7qUGrLZtzdMTfjq1SBUNZsChlitJdbgPWmhwvQw024OzPCIevC+Sci5VrYY0mvEcf
         wCf55pTaiE4cHk/bixrljcgx7fAVp7ORcRA0chPK6Vx2CDwUoqxEl1wGzJy3+BqZoA79
         17mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0UsOrN8L2jk9f8YbUqb1h5IfPLIvfbGbF/K8sUgKLa8=;
        b=o0EG/Dn0L80UZkjRhQXbRVPhWUMpLsuj7OQdgDVoxUtGiKz60ZXhDBJPXPdO2lJyjP
         6GWJe4I82ZhG2rzwuhfxFz85dxnUj0V9BbwqKtcwctOqcaYWy+KrUoQ5z6fVPyJkuoma
         lZDNwFD40kgwvmkzhSMlMYG8NHiNuJFaYboe2mO4JYWal0L1J/p8vquKBV7c9B3PL2LR
         ngXRcfmDjRreM+jWB6e2FqJV/ngp7V5kIuwqIkKihFdMa2Rk2q4yuI2qdSKfzMdHT8ST
         UEYLCwYStwiHQR5G8nLgKP9fYkUitb8ypEOV20EwYlIIpYpKaElL0S1GZzKkPMX+6b3K
         9Z+A==
X-Gm-Message-State: AOAM531qECYA9ViU1c2eKtxU+UbOccRuxybk4yDQ4LTCWPXhnfNh26AX
        ft7UEQ8bBoj2dFO3T2GhuokfcBrRf7F74ETGS40=
X-Google-Smtp-Source: ABdhPJxoC2STA3TBSyALtE6G83AWgatXTc29FjZdK2oqtrZtEGtnxLST3voiVz6FPJJI267q/Z0++69FQ1rcgr1tb60=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr1037971jab.234.1652913424002; Wed, 18
 May 2022 15:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220512071819.199873-1-liuhangbin@gmail.com> <20220512071819.199873-2-liuhangbin@gmail.com>
 <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com> <YoHKw/at89Wp19F/@Laptop-X1>
In-Reply-To: <YoHKw/at89Wp19F/@Laptop-X1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 15:36:53 -0700
Message-ID: <CAEf4BzZhKpikBQFCEyRMmUHdTEt6xi+0ntfPswHA5WWK39cFjQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] selftests/bpf: Fix build error with ima_setup.sh
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 8:53 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Fri, May 13, 2022 at 02:58:05PM -0700, Andrii Nakryiko wrote:
> > > -TRUNNER_EXTRA_FILES :=3D $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmo=
d.ko \
> > > -                      ima_setup.sh                                  =
   \
> > > +TRUNNER_EXTRA_BUILD :=3D $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmo=
d.ko \
> > >                        $(wildcard progs/btf_dump_test_case_*.c)
> >
> >
> > note that progs/btf_dump_test_case_*.c are not built, they are just
> > copied over (C source files), so I don't think this fix is necessary.
> >
> > btw, I tried running `OUTPUT=3D"/tmp/bpf" make test_progs` and it didn'=
t
> > error out. But tbh, I'd recommend building everything instead of
> > building individual targets.
>
> After update the code to latest bpf-next. It works this time, the ima_set=
up.sh
> was copied to target folder correctly.
>
>   EXT-COPY [test_progs] urandom_read bpf_testmod.ko liburandom_read.so im=
a_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf=
_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_c=
ase_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
>   BINARY   test_progs
>
> Not sure why the previous kernel doesn't work. But anyway I will drop thi=
s patch.
>
> On the other hand, when I build with latest bpf-next. I got error like:
>
> """
> # OUTPUT=3D"/tmp/bpf" make test_progs
>   BINARY   urandom_read                                                  =
                                                                           =
                          gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR =
 -I/home/net/tools/testing/selftests/bpf -I/tmp/bpf/tools/include -I/home/n=
et/include/generated -I/home/net/tools/lib -I/home/net/tools/include -I/hom=
e/net/tools/include/uapi -I/tmp/bpf  urandom_read.c urandom_read_aux.c  \
>           liburandom_read.so -lelf -lz -lrt -lpthread   \
>           -Wl,-rpath=3D. -Wl,--build-id=3Dsha1 -o /tmp/bpf/urandom_read

we assume liburandom_read.so is going to be under selftests/bpf here,
but it's actually under $(OUTPUT)/

Can you try $(OUTPUT)/liburandom_read.so? I suspect this might break
-rpath=3D., though, but let's try this first?


> /usr/bin/ld: cannot find liburandom_read.so: No such file or directory   =
                                                                           =
                          collect2: error: ld returned 1 exit status
> make: *** [Makefile:177: /tmp/bpf/urandom_read] Error 1
>
> # ls /tmp/bpf/liburandom_read.so
> /tmp/bpf/liburandom_read.so
> """
>
> after I copy to liburandom_read.so back to tools/testing/selftests/bpf th=
e build
> success.
>
> """
> # cp /tmp/bpf/liburandom_read.so /home/net/tools/testing/selftests/bpf/
> # gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR -I/home/net/tools/test=
ing/selftests/bpf -I/tmp/bpf/tools/include -I/home/net/include/generated -I=
/home/net/tools/lib -I/home/net/tools/include -I/home/net/tools/include/uap=
i -I/tmp/bpf  urandom_read.c urandom_read_aux.c liburandom_read.so -lelf -l=
z -lrt -lpthread -Wl,-rpath=3D. -Wl,--build-id=3Dsha1 -o /tmp/bpf/urandom_r=
ead
> # echo $?
> 0
> """
>
> Do you know why this happens?
>
> Thanks
> Hangbin
