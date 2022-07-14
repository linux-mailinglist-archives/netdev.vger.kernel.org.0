Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9139F575577
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbiGNSzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiGNSyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:54:53 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C000D4A824;
        Thu, 14 Jul 2022 11:54:52 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id mf4so5053737ejc.3;
        Thu, 14 Jul 2022 11:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=deTtm47MXsECJaZBIB67QDLBauF0Vt4wm5KsLb4SAgk=;
        b=qvN2AOcLfChB5JEP4ANrN58jEyVcbsMB/01Epc7MIT0ywZG4Gc/wvpEVW4V8QFHRKQ
         C3zYG+tnsqzC3IS9ZMhr0MA3uedWZ72okdF8kqtrIepzBQXp1+gPRWxLyoTLyz/95ybh
         fz85Sow/8BT+L253EgvTwRzQ09z50up6RYzpcz3FAEwOGlVE9jx9o/SKXRQS18UJu+t9
         MdMC0Q0xJxQEseH0Fbz3yGUbPPCeT/NtmD3jRDTFSqpUvIM+faaK0iyckdpmnalyHU+Z
         OM8CHnVIDqwaEXtjJR/zrX4ZHFP50IV4zYrmq6ymcMv7OyVa7mIupkAekqnj+buPVkKT
         Vq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=deTtm47MXsECJaZBIB67QDLBauF0Vt4wm5KsLb4SAgk=;
        b=QiqYn+yAnd7S06U0CI9p7WvsHL24P5vVXdGL6vxAlYOEIjqJPMRY9Tm3a5eGv3zGJt
         ZYeoCO11iJQ0jLuS+Q8xWvRLPmQtNaFIaOv4jB2k207ubi0XRhbYyuoT9vf+rlKfjSXM
         mt8CaRDQ73klWbTfWgRKuNSAB4eyV/7reJ5SdSBdeB0MqlZmxun9O4atl2qXsvzAJtV6
         jwLmV2CBoIpG+1dTbiLmK3+nMLUI4+J/SC0ImwGRg9nUx81wYPXr3Yy9njne3YfzwfaX
         t8bLHQGBCcvkHog42mawTBBcjpijLi6iJQzA+OENi6aTnRLvsjkX6jpA0+8D9o3WhYsh
         f3lQ==
X-Gm-Message-State: AJIora+vSL4hF9vTtAlbOl5bXWoOGr5lHeo+wYuNXchDRqJU9IGrgBzI
        LAfnCnybMXzMG9af3x49kJjIrWgPJk0OFC0K9qg=
X-Google-Smtp-Source: AGRyM1sm/L4yzm9IZYrbSeZxKhG8BeVp8VCzAgsq8aJ2D/l/5JisnnjLDovgH9CBLUwAAdIVqjql8baolBmXgIJ1XLE=
X-Received: by 2002:a17:907:6e05:b0:72a:a141:962 with SMTP id
 sd5-20020a1709076e0500b0072aa1410962mr9969077ejc.545.1657824891349; Thu, 14
 Jul 2022 11:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-16-toke@redhat.com>
 <CAEf4BzYUbwqKit9QY6zyq8Pkxa8+8SOiejGzuTGARVyXr8KdcA@mail.gmail.com> <CAP01T760my2iTzM5qsYvsZb6wvJP02k7BGOEOP-pHPPHEbH5Rg@mail.gmail.com>
In-Reply-To: <CAP01T760my2iTzM5qsYvsZb6wvJP02k7BGOEOP-pHPPHEbH5Rg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Jul 2022 11:54:39 -0700
Message-ID: <CAEf4BzZJvr+vcO57TK94GM7B5=k2wPgAub4BBJf1Uz0xNpCPVg@mail.gmail.com>
Subject: Re: [RFC PATCH 15/17] selftests/bpf: Add verifier tests for dequeue prog
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Wed, Jul 13, 2022 at 11:45 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, 14 Jul 2022 at 07:38, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
> >
> > On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > >
> > > Test various cases of direct packet access (proper range propagation,
> > > comparison of packet pointers pointing into separate xdp_frames, and
> > > correct invalidation on packet drop (so that multiple packet pointers
> > > are usable safely in a dequeue program)).
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > ---
> >
> > Consider writing these tests as plain C BPF code and put them in
> > test_progs, is there anything you can't express in C and thus requires
> > test_verifier?
>
> Not really, but in general I like test_verifier because it stays
> immune to compiler shenanigans.

In general I dislike them because they are almost incomprehensible. So
unless there is a very particular sequence of low-level BPF assembly
instructions one needs to test, I'd always opt for test_progs as more
maintainable solution.

Things like making sure that verifier rejects invalid use of
particular objects or helpers doesn't seem to rely much on particular
assembly sequence and can and should be expressed with plain C.


> So going forward should test_verifier tests be avoided, and normal C
> tests (using SEC("?...")) be preferred for these cases?

In my opinion, yes, unless absolutely requiring low-level assembly to
express conditions which are otherwise hard to express reliably in C.

>
> >
> > >  tools/testing/selftests/bpf/test_verifier.c   |  29 +++-
> > >  .../testing/selftests/bpf/verifier/dequeue.c  | 160 ++++++++++++++++=
++
> > >  2 files changed, 180 insertions(+), 9 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c
> > >
> >
> > [...]
