Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C8F52F5EC
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349547AbiETW6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiETW6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:58:43 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5043F17B866;
        Fri, 20 May 2022 15:58:42 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id s6so6415280ilp.9;
        Fri, 20 May 2022 15:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N9x2LwBX85E2Mjpj18Dh8hf8npwVGxRZAuphkaR2cSE=;
        b=U47NEPX2VLDvmpZAMOpXpJr0p/5f/Bi/DtVRnvnfglz7Mh58/MckX2fEoYWw8h1w6z
         7pYYIWs9XeRxvONk32x7nAjR5YRIZWK7qWlUYRCfepSxkh5K2d2OrWoXYmSkuPzq9P1x
         lKbC0YFuJ7zTzUotxzAHVaNpuV6/SmZVDg1bTU/N8BGGXTfj8jt4cdMO+u2pMAdhPBBH
         7fColvu4JMSFldqU05glIvfJnRdEOizSCu/9nQV8zuY+hN6mO8KQZxVRYnZVgq0CzrKJ
         zRNeZntDKVA2EK6PEZ1eaanpmkE8E/OXIwQxY7nvxByIMQEuZh+OkNDUeOOWbvWqK0gd
         /5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N9x2LwBX85E2Mjpj18Dh8hf8npwVGxRZAuphkaR2cSE=;
        b=viamoROg3+55hFY+JGkBHnv1xbJlSKE0s9jZON/tH6oc2MRnc9c/JPd8pYJBUXZBVn
         SlzE3Tg311Q1Leg23BdnhpdG/MMMS8WLbsDHYTkhjQduwHL8r60TcRgQAKtdgSg/vLo0
         UZD33DSk2PwCkkH5/m4vSwlcIPOb1QHPuesGdGabSMqo3I2+GmTJGX6m8pFmrrIXgVHw
         XKaYLM+rBgXVKr16wGvDNBXP4WQJrfl8Zn46ZaQI2zljrKgQ2lYc0IVcVxjwqz8Hp7sN
         ElNW8/QaiDCKJk2hbtKoc0XcrU8sqveWL/CqSl6VJl/kMFTbd2ETWmVZruJZDS7rl1ue
         oRzg==
X-Gm-Message-State: AOAM532NM2p4+NTmJZSlX52S3SPnJKWFuWSAX6EVC4w3G01Q8AOSQsUu
        P6Tx5R6Hce63o6t3/WD5ABatFgmC9W94cyFObvs=
X-Google-Smtp-Source: ABdhPJxIZChVpxkuARh4JKec0MCR962E5mu51190buASmq4sF8bLN+etBh+INT3oHCQ3PGcUdFr8nwConqeXD4UrRdY=
X-Received: by 2002:a05:6e02:1c01:b0:2d1:262e:8d5f with SMTP id
 l1-20020a056e021c0100b002d1262e8d5fmr6347615ilh.98.1653087521686; Fri, 20 May
 2022 15:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220512071819.199873-1-liuhangbin@gmail.com> <20220512071819.199873-2-liuhangbin@gmail.com>
 <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com>
 <YoHKw/at89Wp19F/@Laptop-X1> <CAEf4BzZhKpikBQFCEyRMmUHdTEt6xi+0ntfPswHA5WWK39cFjQ@mail.gmail.com>
 <YoWvFz16SsSG7bH9@Laptop-X1>
In-Reply-To: <YoWvFz16SsSG7bH9@Laptop-X1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 15:58:30 -0700
Message-ID: <CAEf4BzZd_BwPr3UYrF_sXT28oKHfKP-=Ws2KSHDKtSc2AK9dNw@mail.gmail.com>
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

On Wed, May 18, 2022 at 7:44 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, May 18, 2022 at 03:36:53PM -0700, Andrii Nakryiko wrote:
> > > On Fri, May 13, 2022 at 02:58:05PM -0700, Andrii Nakryiko wrote:
> > > > > -TRUNNER_EXTRA_FILES :=3D $(OUTPUT)/urandom_read $(OUTPUT)/bpf_te=
stmod.ko \
> > > > > -                      ima_setup.sh                              =
       \
> > > > > +TRUNNER_EXTRA_BUILD :=3D $(OUTPUT)/urandom_read $(OUTPUT)/bpf_te=
stmod.ko \
> > > > >                        $(wildcard progs/btf_dump_test_case_*.c)
> > > >
> > > >
> > > > note that progs/btf_dump_test_case_*.c are not built, they are just
> > > > copied over (C source files), so I don't think this fix is necessar=
y.
> > > >
> > > > btw, I tried running `OUTPUT=3D"/tmp/bpf" make test_progs` and it d=
idn't
> > > > error out. But tbh, I'd recommend building everything instead of
> > > > building individual targets.
> > >
> > > After update the code to latest bpf-next. It works this time, the ima=
_setup.sh
> > > was copied to target folder correctly.
> > >
> > >   EXT-COPY [test_progs] urandom_read bpf_testmod.ko liburandom_read.s=
o ima_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c=
 btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_te=
st_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
> > >   BINARY   test_progs
> > >
> > > Not sure why the previous kernel doesn't work. But anyway I will drop=
 this patch.
> > >
> > > On the other hand, when I build with latest bpf-next. I got error lik=
e:
> > >
> > > """
> > > # OUTPUT=3D"/tmp/bpf" make test_progs
> > >   BINARY   urandom_read                                              =
                                                                           =
                              gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GEN=
HDR  -I/home/net/tools/testing/selftests/bpf -I/tmp/bpf/tools/include -I/ho=
me/net/include/generated -I/home/net/tools/lib -I/home/net/tools/include -I=
/home/net/tools/include/uapi -I/tmp/bpf  urandom_read.c urandom_read_aux.c =
 \
> > >           liburandom_read.so -lelf -lz -lrt -lpthread   \
> > >           -Wl,-rpath=3D. -Wl,--build-id=3Dsha1 -o /tmp/bpf/urandom_re=
ad
> >
> > we assume liburandom_read.so is going to be under selftests/bpf here,
> > but it's actually under $(OUTPUT)/
> >
> > Can you try $(OUTPUT)/liburandom_read.so? I suspect this might break
> > -rpath=3D., though, but let's try this first?
>
> Sigh.. After rebase to latest bpf-next, to make clean and re-do
> `OUTPUT=3D"/tmp/bpf" make test_progs`, There is no liburandom_read.so bui=
ld
> issue but the ima_setup.sh error come up again...
>
>   LINK     resolve_btfids
>   LIB      liburandom_read.so
>   BINARY   urandom_read
>   MOD      bpf_testmod.ko
>   CC [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.o
>   MODPOST /home/net/tools/testing/selftests/bpf/bpf_testmod/Module.symver=
s
>   CC [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.m=
od.o
>   LD [M]  /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.k=
o
>   BTF [M] /home/net/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.k=
o
> make: *** No rule to make target '/tmp/bpf/ima_setup.sh', needed by 'ima_=
setup.sh'.  Stop.
>
> Not sure if it's a build environment setup issue or others.

I don't use OUTPUT when building selftests and see no issues, so this
must be related. If you care about OUTPUT working please try to debug
and figure this out.

>
> Hangbin
