Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FA66AFF9B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 08:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCHHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 02:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCHHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 02:22:46 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95120A6494;
        Tue,  7 Mar 2023 23:22:42 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v13so13779254ybu.0;
        Tue, 07 Mar 2023 23:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678260162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSTs7z8U4OKzKxKPcluZMUlf8OLeP+ZzGBZVTGs9IG8=;
        b=ezycUTXAPczeGsa54dMiW5i9YpAp7Erendap2oQrGiPKz9aeDSjPolT606A3nImWR9
         hfhG1501E2uOlAr/qmNo0Xt8FXou4/8JGqy+3GnUOn5xnyKlqjyhgQs1xVuraZusPRmK
         TKa0IGh9sQBEvadisWhrss0JB4Lq/rzNGbz7wtWRD06LFX4Alrh0nDgEe8cYxE4EIVef
         usAV1GSk2kqgvkhE7DZbmdtErb3RmrGrzrBZk3GBilxUafnHrqRG8Bg8WL9Gce3j14/X
         s5ySCp6szKYl/pLPe0abrM8b9M8KE7gQn5nvhZcmd1eE53XgC7njLrIkALObS8Z1lvSn
         OFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678260162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSTs7z8U4OKzKxKPcluZMUlf8OLeP+ZzGBZVTGs9IG8=;
        b=i0qmEGY5Ima0xlEZQQbuQBwC2ksiu4nhcJ5LWcHKW93agOYGETQRyZOkx6G2KCM3VU
         auXGFzZhbcnxupIw5PepeBueRZ8TzVmwGn3BQ11g+xitjhMkyOakOGYX73O8lPmMFzis
         Wja6HC9/p/j0GhREVrdPhRbuUL+T04t90l+sKxOKRlgEkCxsov/2rHlmcqWC8OB3NuRF
         lfarZ4RNsWrfSctLMqe88urXZgdLrViFbKG05cdO4HZxNp6g37WJuSkV7yNmhmqkB8Ah
         3WO9EEQOwaQ8Ans97T9Me0bHTPDbuAcT3EmkgMx/ehI49sLNt+Vlfn5PolW1q1O3G+/H
         Qnjw==
X-Gm-Message-State: AO0yUKUOkeYbnlF2dbpy+uMSMVQSmk1yUdNZse+AdUy5q9W3UI9mLXF7
        V98CkYeWAYrS63EhtTZewzRtuB4L1l0TvSAVIe+V64z6g9U=
X-Google-Smtp-Source: AK7set8T0Kl6lvoi7bA6Bw0daXJU1J8FlrvrJ0Sk0AzSPsxy0oRyawv66Te0sLez10LpvSEEZBpt4My+bhP+uPNl3Ns=
X-Received: by 2002:a25:8b03:0:b0:ad2:3839:f49 with SMTP id
 i3-20020a258b03000000b00ad238390f49mr10572847ybl.5.1678260161813; Tue, 07 Mar
 2023 23:22:41 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-11-joannelkoong@gmail.com> <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
 <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com> <20230308015500.6pycr5i4nynyu22n@heavy>
In-Reply-To: <20230308015500.6pycr5i4nynyu22n@heavy>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 7 Mar 2023 23:22:30 -0800
Message-ID: <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
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

On Tue, Mar 7, 2023 at 5:55=E2=80=AFPM Ilya Leoshkevich <iii@linux.ibm.com>=
 wrote:
>
> On Wed, Mar 01, 2023 at 08:28:40PM -0800, Joanne Koong wrote:
> > On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > 5) progs/dynptr_success.c
> > > >    * Add test case "test_skb_readonly" for testing attempts at writ=
es
> > > >      on a prog type with read-only skb ctx.
> > > >    * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data is=
n't
> > > >      supported for skb progs.
> > >
> > > I added
> > > +dynptr/test_dynptr_skb_data
> > > +dynptr/test_skb_readonly
> > > to DENYLIST.s390x and applied.
> >
> > Thanks, I'm still not sure why s390x cannot load these programs. It is
> > being loaded in the same way as other tests like
> > test_parse_tcp_hdr_opt() are loading programs. I will keep looking
> > some more into this
>
> Hi,
>
> I believe the culprit is:
>
>     insn->imm =3D BPF_CALL_IMM(bpf_dynptr_from_skb_rdonly);
>
> s390x needs to know the kfunc model in order to emit the call (like
> i386), but after this assignment it's no longer possible to look it
> up in kfunc_tab by insn->imm. x86_64 does not need this, because its
> ABI is exactly the same as BPF ABI.
>
> The simplest solution seems to be adding an artificial kfunc_desc
> like this:
>
>     {
>         .func_model =3D desc->func_model,  /* model must be compatible */
>         .func_id =3D 0,                    /* unused at this point */
>         .imm =3D insn->imm,                /* new target */
>         .offset =3D 0,                     /* unused at this point */
>     }
>
> here and also after this assignment:
>
>     insn->imm =3D BPF_CALL_IMM(xdp_kfunc);
>
> What do you think?

Ohh interesting! This makes sense to me. In particular, you're
referring to the bpf_jit_find_kfunc_model() call in bpf_jit_insn() (in
arch/s390/net/bpf_jit_comp.c) as the one that fails out whenever
insn->imm gets set, correct?

I like your proposed solution, I agree that this looks like the
simplest, though maybe we should replace the existing kfunc_desc
instead of adding it so we don't have to deal with the edge case of
reaching MAX_KFUNC_DESCS? To get the func model of the new insn->imm,
it seems pretty straightforward, it looks like we can just use
btf_distill_func_proto(). or call add_kfunc_call() directly, which
would do everything needed, but adds an additional unnecessary sort
and more overhead for replacing (eg we'd need to first swap the old
kfunc_desc with the last tab->descs[tab->nr_descs] entry and then
delete the old kfunc_desc before adding the new one). What are your
thoughts?

>
> [...]
>
> Best regards,
> Ilya
