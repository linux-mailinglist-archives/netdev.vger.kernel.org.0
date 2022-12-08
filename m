Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9326164751C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiLHRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLHRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:49:06 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5724775BD0;
        Thu,  8 Dec 2022 09:49:05 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id t17so5846859eju.1;
        Thu, 08 Dec 2022 09:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCUy2A8QkoNgKNjTy0YPJIsFUI9pgEyDcRhSPvn8O2o=;
        b=cg2u29RTlmTya3gy6M1iGhv6QB0BoOubx4J/4evpAvd/61UfJx/iG+xSNCkLTsi556
         pcjokwQ1rVw5LoYxaNKwkkEMXUydpKvv5nfbmSg+nye/CaoLn0sG7Ah4nTSoqAgNM97P
         6SmLWbxoyuZOJKPICtf8M8U82s30HZMlT62mvq/PSepW39/wSU6qXU50J6Q6LFbk3JTz
         5MFmRQeUNea/S5uUjENQhCd4kL+JmdAp7wGIq8DmgNHVB+zMdNJq5fZaQVqwzF7MeOpZ
         ZRL7DspFX3tYJ9pP7XRB0+YtxR82Rf2SV18tWCp6jRA057UA6NJNZT01KdvE0kMgWXF1
         Cyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCUy2A8QkoNgKNjTy0YPJIsFUI9pgEyDcRhSPvn8O2o=;
        b=22nvpxzS++GRDgKgxc01NqX7NmNyivt4j+N5l58Gkib6dQXRl74RdvwtrDBhdv1TKa
         /B6OlkfmSn8YMSeCT35EMPkpI0eOnRlE4MI57PSH8T2a4Ami/Mq+AYVqREJxY2QXbuJW
         XL6a5ymvT56eqSAJZh/WY6s692usqESG1v/1f0V8JeJVXPOHUeKMGEKLqKCKCQ2rEMju
         aZpkusxiOCim8GDzb2TnWCwyiwW4vEGm9eD9MaxuqeRapzlbeK4uPPMBnICsfyrcAMiN
         cTi9E/WWxgtkGWxjTcl1+BTM5ifDnpGbmoia8TrdOm0/62omoiohF/c5NeDhyWV73/kC
         oQqA==
X-Gm-Message-State: ANoB5pkzH8SJTfbRpcad0UNwPd215itEdnEdz9DozQip56XxyBatw8/Q
        aS7sxtLX1uGDDM8LHhEazCHYcgk8KVLod1BR1rI=
X-Google-Smtp-Source: AA0mqf7awQKl5+4hcqSd2fB4clEKH9QAibbQcSEDjPR9EyxIhmJvrp39aeGPMIsj6Y3m4eHZOCxa7fT5u8q3/sJIByg=
X-Received: by 2002:a17:906:2ac3:b0:7ad:f2f9:2b49 with SMTP id
 m3-20020a1709062ac300b007adf2f92b49mr65036826eje.94.1670521743673; Thu, 08
 Dec 2022 09:49:03 -0800 (PST)
MIME-Version: 1.0
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava> <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
In-Reply-To: <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 8 Dec 2022 09:48:52 -0800
Message-ID: <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
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

On Wed, Dec 7, 2022 at 11:57 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 6, 2022 at 7:18 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> > > Hao Sun <sunhao.th@gmail.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=BA=8C 11:28=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > Hi,
> > > >
> > > > The following crash can be triggered with the BPF prog provided.
> > > > It seems the verifier passed some invalid progs. I will try to simp=
lify
> > > > the C reproducer, for now, the following can reproduce this:
> > > >
> > > > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-i=
n
> > > > functions in bpf_iter_ksym
> > > > git tree: bpf-next
> > > > console log: https://pastebin.com/raw/87RCSnCs
> > > > kernel config: https://pastebin.com/raw/rZdWLcgK
> > > > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > > > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> > > >
> > >
> > > Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> > >
> > > Only two syscalls are required to reproduce this, seems it's an issue
> > > in XDP test run. Essentially, the reproducer just loads a very simple
> > > prog and tests run repeatedly and concurrently:
> > >
> > > r0 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000640)=3D@base=3D{0x6, 0xb,
> > > &(0x7f0000000500)}, 0x80)
> > > bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)=3D{r0, 0x0, 0x0, 0x0, 0x=
0,
> > > 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> > >
> > > Loaded prog:
> > >    0: (18) r0 =3D 0x0
> > >    2: (18) r6 =3D 0x0
> > >    4: (18) r7 =3D 0x0
> > >    6: (18) r8 =3D 0x0
> > >    8: (18) r9 =3D 0x0
> > >   10: (95) exit
> >
> > hi,
> > I can reproduce with your config.. it seems related to the
> > recent static call change:
> >   c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ft=
race)
> >
> > I can't reproduce when I revert that commit.. Peter, any idea?
>
> Jiri,
>
> I see your tested-by tag on Peter's commit c86df29d11df.
> I assume you're actually tested it, but
> this syzbot oops shows that even empty bpf prog crashes,
> so there is something wrong with that commit.
>
> What is the difference between this new kconfig and old one that
> you've tested?
>
> I'm trying to understand the severity of the issues and
> whether we need to revert that commit asap since the merge window
> is about to start.

Jiri, Peter,

ping.

cc-ing Thorsten, since he's tracking it now.

The config has CONFIG_X86_KERNEL_IBT=3Dy.
Is it related?
