Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38CB4E4517
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 18:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiCVRZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 13:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbiCVRZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 13:25:41 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B06838BF8;
        Tue, 22 Mar 2022 10:24:12 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e22so20947342ioe.11;
        Tue, 22 Mar 2022 10:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sMpwi18GQpzQlKw469v7fr57J4E3h65fgaUUKT7zin4=;
        b=ljD7kbpMswCm2Qb+bg0Qr1HdRpEZ36qP9KEwmnyAn7nlKXSffNc29nqPWr2uo7+RJM
         s+WHT20fNuAO9882Pf8VC2Qq0sFvRQBD6VgE7blgcMpMycPjckxEuIgnoDzE4KuuEPlb
         L5fWxlxZ0v+zf/f1JrOzld82zuSehoOY8mNP584wqTLF6PmoPdkmJj3Nee7/XdxNPMpw
         SoNeQDZVBDTsYE0fbJSOp7W2JViMaG+81Y01migOmtNjaAbT4O0CJWAQUGMbegRRUhAK
         /oy2Q+M009QKJpIr8uGy5J5JiJF1AuZjoL9Kr3qDHKAU29+/j1F5hS7ZCG787tYt+5nc
         N3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sMpwi18GQpzQlKw469v7fr57J4E3h65fgaUUKT7zin4=;
        b=VANIR6y1Kq/hVwlKUmQi0E9uPG7JiFK7Xsd46pKLfpgQVKh2ayVSefaNektezU9dSi
         CK1Zf7wbI7x5uYL89sgAZMauBwDjybgwOzUkqQZ8pL0uyTJ43cmTWOuxfFy0bDN0+eKJ
         n7EVMEOY39d/+vNDPtVX5vjYq8dmga5x07RlkF6xsROA/doiCThjpvMWrs4LyGWdHOje
         9hNeZNFsLXO7uNHOU61tcNwgA/7gsblfrEWQbdUgV4ImIYb6nmK8foKAWqEseM5Yed1s
         hrY/miSbbC2mLhDfRzH5eyoGHeeUUPh9Ra+XIxhld1o5Rxv7e0ilFcfe4fjf1UP2WoU4
         7D/Q==
X-Gm-Message-State: AOAM533P+vebXGzR97/w1/Xx2bnJ07FQ4XJCZoSaCQGpLEzUGczrmjZA
        hbcKl9B5q7mMvh1VHNEp7GZdTFB9a1dTvop0yC09CQoj
X-Google-Smtp-Source: ABdhPJxUHQxNtvpTaMeqPBEdvbdlkELMmVIMbcKZRf7OadqWOIQgmIH+LXwGtb3A8DovjPAJJQKbLLKjlM1K8GomtSc=
X-Received: by 2002:a6b:e915:0:b0:649:d744:97c0 with SMTP id
 u21-20020a6be915000000b00649d74497c0mr416217iof.63.1647969851463; Tue, 22 Mar
 2022 10:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
 <F7652433-EED5-4F56-A062-06AFE4B08576@linux.dev>
In-Reply-To: <F7652433-EED5-4F56-A062-06AFE4B08576@linux.dev>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Mar 2022 10:24:00 -0700
Message-ID: <CAEf4BzY_T8jaiVRuTA3rRyv+5t8SoMD7sReO2=uMeFK2Q4ai1Q@mail.gmail.com>
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

On Mon, Mar 21, 2022 at 7:15 PM Roman Gushchin <roman.gushchin@linux.dev> w=
rote:
>
>
> > On Mar 21, 2022, at 5:13 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
> >
> > =EF=BB=BFOn Sun, Mar 20, 2022 at 9:58 AM Roman Gushchin <roman.gushchin=
@linux.dev> wrote:
> >>
> >>
> >>>> On Mar 19, 2022, at 11:08 PM, Yafang Shao <laoar.shao@gmail.com> wro=
te:
> >>>
> >>> =EF=BB=BFSince we have alread switched to memcg-based memory accoutin=
g and control,
> >>> we don't need RLIMIT_MEMLOCK any more.
> >>>
> >>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> >>>
> >>> ---
> >>> RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be use=
ful
> >>> for backward compatibility, so I don't cleanup them.
> >>
> >> Hi Yafang!
> >>
> >> As I remember, we haven=E2=80=99t cleaned selftests up with the same l=
ogic: it=E2=80=99s nice to be able to run the same version of tests on olde=
r kernels.
> >>
> >
> > It should be fine, at least for test_progs and test_progs-no_alu32.
> > Libbpf now does this automatically if running in "libbpf 1.0" mode.
>
> Didn=E2=80=99t know this, thanks! Do we link all tests with it?

Yep, every selftest inevitably relies on libbpf. We just need to make
sure to enable that 1.0 mode with libbpf_set_strict_mode() call.

>
> >
> > Yafang, please make sure that all the test binaries you are cleaning
> > up have libbpf_set_strict_mode(LIBBPF_STRICT_ALL) (test_progs does
> > already). You might need to clean up some SEC() definitions, in case
> > we still missed some non-conforming ones, though.
>
> If so, no objections to the patch from my side.
>
> Thank you!
