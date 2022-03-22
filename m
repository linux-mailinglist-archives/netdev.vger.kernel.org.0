Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4E24E3562
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiCVARj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiCVARi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:17:38 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7817D2DE794;
        Mon, 21 Mar 2022 17:15:05 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id l18so18620656ioj.2;
        Mon, 21 Mar 2022 17:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C8V0ICZ2MM8fBPT/GcG935f784ooAUiEoHS2Z1Rzmno=;
        b=l55a/icvfAmgvATWM55qjOxhGU1sZ+w7ES+Sop6T0Vd/UvopXVed/2Me8t9XPwXX5/
         AuqdVKiXjXABXxqx1vIFioP+EdnQW1ntwvZMvOKBYKCDO7t1mUucwxhSAtpO6J1wchwZ
         9v6hjPP3XVj5x+4x8+S2uAoReUI0TVVBasV/g9Ln3LAG4y9+NVFAXXvgAIsHgPQgpMBW
         2OBY/dOnNr4O6VQGOuyD+7JMQC81efqzAdMCfhC9m2KnNXoaAylH7xzPVvP98TDAuR4E
         8R2q8I6rMY8aT9dkMC6/vK3NRi2Hj9okATb2jp6pBXe9Ey2DeectDOhyKpNewk7LbcBb
         RjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C8V0ICZ2MM8fBPT/GcG935f784ooAUiEoHS2Z1Rzmno=;
        b=XMAcbDWZxJw77IEwdAX6dPYZoZpYYhPQkJGG0gLR6c5Ym14kU9nTxHl7zrLxVDabrw
         Q4Ii3Jy5mxMY4tW2j4kSo7npG8LZGGtmwgb9rTUKx2fHnMO6uOk7FqE/v1Gq7TTZ6iGf
         8MSGQNGg/3ffZ3ExnTzfWs9BWOmBDjVSizpvvx/G5Kho3vMxYwdv248e45OZWlsUua2M
         bdM1k0XnvTNB88NodyoVt7o97LN22Kvn8mIrECymNVethR2jXhD+17iuWvUeMRTyNszJ
         q0FAtksmkhaXrdLd4jPrjYxW+saqypQpT51s1MpMBoteMul3w5ZAtNUbRvLJYszPCRTC
         Ez/g==
X-Gm-Message-State: AOAM530EpZm/4fhkvC9v1sOFvR1vPl2MqBqoawHWMJfQrYku8M27Mtbr
        IrZd7pvcVKn6/48O5yhl2Z5zgcnEjZTMCr2RZHM=
X-Google-Smtp-Source: ABdhPJxlJMmggp7K1/hN6vMAK2bHm0saTyKRdxPvqEcmmnD8Fj9sc8EH3JwGeXNDxnZF3/6mfEZm5OEDkYlCyBxVHMY=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr11193640iov.144.1647908008659; Mon, 21
 Mar 2022 17:13:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220320060815.7716-2-laoar.shao@gmail.com> <0D674EA5-3626-4885-9ADC-5B7847CC967D@linux.dev>
In-Reply-To: <0D674EA5-3626-4885-9ADC-5B7847CC967D@linux.dev>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Mar 2022 17:13:17 -0700
Message-ID: <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
Subject: Re: [PATCH] bpf: selftests: cleanup RLIMIT_MEMLOCK
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sun, Mar 20, 2022 at 9:58 AM Roman Gushchin <roman.gushchin@linux.dev> w=
rote:
>
>
> > On Mar 19, 2022, at 11:08 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > =EF=BB=BFSince we have alread switched to memcg-based memory accouting =
and control,
> > we don't need RLIMIT_MEMLOCK any more.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> >
> > ---
> > RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be usefu=
l
> > for backward compatibility, so I don't cleanup them.
>
> Hi Yafang!
>
> As I remember, we haven=E2=80=99t cleaned selftests up with the same logi=
c: it=E2=80=99s nice to be able to run the same version of tests on older k=
ernels.
>

It should be fine, at least for test_progs and test_progs-no_alu32.
Libbpf now does this automatically if running in "libbpf 1.0" mode.

Yafang, please make sure that all the test binaries you are cleaning
up have libbpf_set_strict_mode(LIBBPF_STRICT_ALL) (test_progs does
already). You might need to clean up some SEC() definitions, in case
we still missed some non-conforming ones, though.

> Thanks!
