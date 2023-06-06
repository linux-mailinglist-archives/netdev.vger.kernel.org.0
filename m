Return-Path: <netdev+bounces-8249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A416723485
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0138C28148A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4EA438B;
	Tue,  6 Jun 2023 01:32:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F577F;
	Tue,  6 Jun 2023 01:32:12 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B070DC;
	Mon,  5 Jun 2023 18:32:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f624daccd1so2742078e87.0;
        Mon, 05 Jun 2023 18:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686015129; x=1688607129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKXeYLBgNZsLD/+IxPwyyN63h/BVDg7LwOnNrEDBze0=;
        b=seM8DoJuA+l2/qluDMFHOqVY2TU0LJEsce5E3zY3BfHXHqYaAoQIn0CcRJVxEiYkeX
         ueig2x+BcON7b3hxf82SBc6l8PbMtq4dUUcKED2ECulGGEw8YTmbReZY5raJxynbLWYH
         J9JeYjQuOEvrKBuDThQR39KCrrrmOCQSwS492duLcJ/KfwdyKnVK2MqZaLe2qCpWlreh
         ATkJkwBLHbj51yPzGh1iKBuit1jUH4WrNFzJ8d/tHdPVOvbrSvBkuBk5fBD/5hjx7tZB
         hvNmbxkl4kAJgOqDogjNztOz6Dw1NyYjYumFZpe26RxkMpJWsTkFj25n9Bjoa3LU72b6
         okpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686015129; x=1688607129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nKXeYLBgNZsLD/+IxPwyyN63h/BVDg7LwOnNrEDBze0=;
        b=kjLxcs+WiVJ4dyorV4B7lzSHbAoY6fRqHbjjxckuXrK3oQp8eSok6pW0Uz3uGe9mtP
         qjN5+QApp/K+6WPTbmLM7momAYHvtiKgKIfNisiZmjC3Go4BejfiBsdSeiKqV1LLULEM
         Q0c1wzqMr+RZfFHYemargTdqZFNLjK3g8YlGrxoL+MIqTZA+9DEExhrMZicH9rcLaIi7
         bbfd0kAAauhXG9PjKKoCO5TYEAEBTdWDDcobBOWZvkIQswzRZoyHpxc2ESKh8WHnadJ8
         qk1JugnZyhauyKwihYzy5J14WSFmXHwB1bntLqGUJuNLn8+DXgqI9T0uM8CEQ4HrDK21
         +cqg==
X-Gm-Message-State: AC+VfDwj9PTr0O+75yhITU9cfaaaxNeKZUi0mmFGMsUxpdYTpN4DgCyJ
	b8MQskKdrJx69XC502zxX+j2ROPEBbAyCip10b4=
X-Google-Smtp-Source: ACHHUZ4CSyaN+1CA8HNujlJTstB9XfEYJXvLicNt50Ql/A2r+8dDz8Zj9rIXpCiTUQYHEpEA2sDAUBbj+rGoJvM5mI4=
X-Received: by 2002:a2e:7219:0:b0:2b1:c389:c424 with SMTP id
 n25-20020a2e7219000000b002b1c389c424mr648772ljc.12.1686015128552; Mon, 05 Jun
 2023 18:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605164955.GA1977@templeofstupid.com> <CAADnVQK7PQxj5jjfUu9sO524yLMPqE6vmzcipno1WYoeu0q-Gw@mail.gmail.com>
 <20230606004139.GE1977@templeofstupid.com>
In-Reply-To: <20230606004139.GE1977@templeofstupid.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 5 Jun 2023 18:31:57 -0700
Message-ID: <CAADnVQLhqCVRcPuJ8JEZfd5ii+-TsSs4+AsJC0sbjwPMv7LX_Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: search_bpf_extables should search subprogram extables
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	clang-built-linux <llvm@lists.linux.dev>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 5:46=E2=80=AFPM Krister Johansen <kjlx@templeofstupi=
d.com> wrote:
>
> On Mon, Jun 05, 2023 at 04:30:29PM -0700, Alexei Starovoitov wrote:
> > On Mon, Jun 5, 2023 at 9:50=E2=80=AFAM Krister Johansen <kjlx@templeofs=
tupid.com> wrote:
> > > +                       if (!aux->func[i]->aux->num_exentries ||
> > > +                           aux->func[i]->aux->extable =3D=3D NULL)
> > > +                               continue;
> > > +                       e =3D search_extable(aux->func[i]->aux->extab=
le,
> > > +                           aux->func[i]->aux->num_exentries, addr);
> > > +               }
> > > +       }
> >
> > something odd here.
> > We do bpf_prog_kallsyms_add(func[i]); for each subprog.
> > So bpf_prog_ksym_find() in search_bpf_extables()
> > should be finding ksym and extable of the subprog
> > and not the main prog.
> > The bug is probably elsewhere.
>
> I have a kdump (or more) of this bug so if there's additional state
> you'd like me to share, let me know.

Please convert the test into selftest.
Then everyone will be able to reproduce easily
and it will serve us later to make sure we don't regress.

> With your comments in mind, I took
> another look at the ksym fields in the aux structs.  I have this in the
> main program:
>
>   ksym =3D {
>     start =3D 18446744072638420852,
>     end =3D 18446744072638423040,
>     name =3D <...>
>     lnode =3D {
>       next =3D 0xffff88d9c1065168,
>       prev =3D 0xffff88da91609168
>     },
>     tnode =3D {
>       node =3D {{
>           __rb_parent_color =3D 18446613068361611640,
>           rb_right =3D 0xffff88da91609178,
>           rb_left =3D 0xffff88d9f0c5a578
>         }, {
>           __rb_parent_color =3D 18446613068361611664,
>           rb_right =3D 0xffff88da91609190,
>           rb_left =3D 0xffff88d9f0c5a590
>         }}
>     },
>     prog =3D true
>   },
>
> and this in the func[0] subprogram:
>
>   ksym =3D {
>     start =3D 18446744072638420852,
>     end =3D 18446744072638423040,
>     name =3D <...>
>     lnode =3D {
>       next =3D 0xffff88da91609168,
>       prev =3D 0xffffffff981f8990 <bpf_kallsyms>
>     },
>     tnode =3D {
>       node =3D {{
>           __rb_parent_color =3D 18446613068361606520,
>           rb_right =3D 0x0,
>           rb_left =3D 0x0
>         }, {
>           __rb_parent_color =3D 18446613068361606544,
>           rb_right =3D 0x0,
>           rb_left =3D 0x0
>         }}
>     },
>     prog =3D true
>   },
>
> That sure looks like func[0] is a leaf in the rbtree and the main
> program is an intermediate node with leaves.  If that's the case, then
> bpf_prog_ksym_find may have found the main program instead of the
> subprogram.  In that case, do you think it's better to skip the main
> program's call to bpf_prog_ksym_set_addr() if it has subprograms instead
> of searching for subprograms if the main program is found?

I see.
Looks like we're doing double bpf_prog_kallsyms_add().
First in in jit_subprogs():
        for (i =3D 0; i < env->subprog_cnt; i++) {
                bpf_prog_lock_ro(func[i]);
                bpf_prog_kallsyms_add(func[i]);
        }
and then again:
bpf_prog_kallsyms_add(prog);
in bpf_prog_load().

because func[0] is the main prog.

We are also doing double bpf_prog_lock_ro() for main prog,
but that's not causing harm.

The fix is probably just this:

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1e38584d497c..89266dac9c12 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17633,7 +17633,7 @@ static int jit_subprogs(struct bpf_verifier_env *en=
v)
        /* finally lock prog and jit images for all functions and
         * populate kallsysm
         */
-       for (i =3D 0; i < env->subprog_cnt; i++) {
+       for (i =3D 1; i < env->subprog_cnt; i++) {
                bpf_prog_lock_ro(func[i]);
                bpf_prog_kallsyms_add(func[i]);
        }

