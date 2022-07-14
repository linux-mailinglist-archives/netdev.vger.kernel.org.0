Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D769757453C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiGNGpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGNGps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:45:48 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC1422515;
        Wed, 13 Jul 2022 23:45:48 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y12so478393ilq.10;
        Wed, 13 Jul 2022 23:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JnN0MXNY1YrroXSy+NnDsu9uThjCiFSPIR69qGOm7Kw=;
        b=eA32wJCaPCnpUcBPphS3vjA55fypgrppfWuh31fwHYjGq18q+2cpyWyGqu6WFcwS18
         4ORaNSS3ckxAeOBn40fjWH3pOAALp6Dgo1sBDv+CrZMmct8u2eWxWCFgNNA6u2MsCkXl
         cotTLTt3eNzyhxLEEzfyi/PZG+2GTIjdrddNuMVUAIVPVABBXwljSlOeSoJAiwpQN6Vn
         l4cES6G5LZCtHx1tGLsHpyJNTri5XQvStvyaupaV4dgO0CuHXve1jQpDxjMa+q5fhvHC
         WuSqnimxyRqmXJA43t422SgfC+NMQ5ZDLk1ahsEO/RdC21hXVUJnf/hi/O41h/U77kXr
         lbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JnN0MXNY1YrroXSy+NnDsu9uThjCiFSPIR69qGOm7Kw=;
        b=O250KTQxINc7id8MRU9/g1C9rwslWV9JYs+CQpQ/spmKxh4Tuu+Hk9qpXZVuJobrlP
         gPllhdXAZ2RuNlaEyYSOXDPfEA7RmQ8lps6t1uOZaHpoiT1/JZ1sSE4uq3mAwDULBmxH
         TOZ6vWlE8aKNjbcCGvM2CNv97RMI5pjHklLM1qpP0HLEBAXn3GRSXGlgt30rBDFO9lo7
         gWQdgpJpFANebbOa7+5bWHv5Bv8VwvHrj11MP52fYRI4lB1kOmIPh67nn6NB5qBzScLU
         4dTYGdbj1GzC707SRezmqy90Vmq2hI7ewtjGjR2Wj0H4xIGU2wKCOQInE9ucVLPMQ26+
         xFhQ==
X-Gm-Message-State: AJIora9RhlxhQkarizOp9fsDBf21X7fD4oCtvj2X0n91u6cfdUsW4IwG
        AMjAgpDa7r+ueoeZdZWqiDhoDeZjEE0lpX+aWgI=
X-Google-Smtp-Source: AGRyM1uYdL4LNeHpaUyBvW3MyWP1jfeoSbt8tVbi9zdezXtBYCfBdBhQbJ36bfiIBecNb8vCcTJCMhTfTUBPMQ0djMA=
X-Received: by 2002:a05:6e02:1d0c:b0:2dc:8919:2768 with SMTP id
 i12-20020a056e021d0c00b002dc89192768mr3990569ila.164.1657781147624; Wed, 13
 Jul 2022 23:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-16-toke@redhat.com>
 <CAEf4BzYUbwqKit9QY6zyq8Pkxa8+8SOiejGzuTGARVyXr8KdcA@mail.gmail.com>
In-Reply-To: <CAEf4BzYUbwqKit9QY6zyq8Pkxa8+8SOiejGzuTGARVyXr8KdcA@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 14 Jul 2022 08:45:11 +0200
Message-ID: <CAP01T760my2iTzM5qsYvsZb6wvJP02k7BGOEOP-pHPPHEbH5Rg@mail.gmail.com>
Subject: Re: [RFC PATCH 15/17] selftests/bpf: Add verifier tests for dequeue prog
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Shuah Khan <shuah@kernel.org>
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

On Thu, 14 Jul 2022 at 07:38, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > Test various cases of direct packet access (proper range propagation,
> > comparison of packet pointers pointing into separate xdp_frames, and
> > correct invalidation on packet drop (so that multiple packet pointers
> > are usable safely in a dequeue program)).
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
>
> Consider writing these tests as plain C BPF code and put them in
> test_progs, is there anything you can't express in C and thus requires
> test_verifier?

Not really, but in general I like test_verifier because it stays
immune to compiler shenanigans.
So going forward should test_verifier tests be avoided, and normal C
tests (using SEC("?...")) be preferred for these cases?

>
> >  tools/testing/selftests/bpf/test_verifier.c   |  29 +++-
> >  .../testing/selftests/bpf/verifier/dequeue.c  | 160 ++++++++++++++++++
> >  2 files changed, 180 insertions(+), 9 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c
> >
>
> [...]
