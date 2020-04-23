Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B671B6189
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgDWRFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:05:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30873 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729673AbgDWRFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587661549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBg76D7WNNczaCw5afubhAJ9jQW+qoa3p2n9Nwj1R+0=;
        b=i1vMOn/PbpWchS1qMaEnglmNu9IK0OiTM5i+Gb31mV43u2GXATscCg4Svn1chwZ3ks7diw
        ehZnly3X9jHDtUPMIzHKbZykalFCf2IMVXfuDrvHXE5rcwjDnatETYza7EAi4d+moZtUt1
        liaXoeGlKaw7cHbvFM8X59CES1p+caY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-7JmythJiOLiF0ODs8IR4xQ-1; Thu, 23 Apr 2020 13:05:48 -0400
X-MC-Unique: 7JmythJiOLiF0ODs8IR4xQ-1
Received: by mail-lf1-f69.google.com with SMTP id m3so2573079lfp.21
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YBg76D7WNNczaCw5afubhAJ9jQW+qoa3p2n9Nwj1R+0=;
        b=U9ls2o1Y3jNxokpE1Ig93pEFcF+DGWdlsOPOhAsZxnUXNfPX55uLy87/f2EqPTG7YR
         NtVMX+eZdiiAG+VjlpXcD29RbYRvq3L/kb/+WI8p7W8O16s3Bnf2QZNev4eSyyZ1J8f2
         1PG56+5AVJGphD6Ovyt01UX1m9HyYDKL94q/8CoKJXlDBxxteK7OJ1PIZreOKDCU/6uu
         HQ9Zh1qXPdsJfOE7FzvKrilDO1fMkxEebkbAD5/46fSUq81/MuDkJ7XbNbnodgPdcjGL
         U7bxWIMtYnio5+wMv0w8dr/xUV6NBZkdYKYH87nx5HOcyPDOCRYdUCf4iYmENhX5HLFB
         6u6Q==
X-Gm-Message-State: AGi0PuZZ8PUbEspQgRxcLgXOG56Xw4bbyqSi+BF2irK4CkwzsBtP3yqE
        aBEMoZJWPuc16fKka2Nc9e/67lE5jc37fLraivJTvaLt2T0i2pXZovpj0y4mEGT/tPAQ8hk6bDP
        rXSyuVl8Niia0xwVa
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr2745148lji.77.1587661545571;
        Thu, 23 Apr 2020 10:05:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLISdNs1Tin6l01v8rQS8qx2IcIvjCjfuVOWkNNy08zC1SmbzsDPPQbj4Ef7DJRGL+tQOLuqA==
X-Received: by 2002:a2e:9a93:: with SMTP id p19mr2745080lji.77.1587661544376;
        Thu, 23 Apr 2020 10:05:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p23sm2211687lfc.95.2020.04.23.10.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 10:05:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B99B71814FF; Thu, 23 Apr 2020 19:05:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
References: <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk> <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com> <878sim6tqj.fsf@toke.dk> <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Apr 2020 19:05:42 +0200
Message-ID: <874kta6sk9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Apr 23, 2020 at 9:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Wed, Apr 22, 2020 at 05:51:36PM +0200, Toke H=C3=83=C2=B8iland-J=C3=
=83=C2=B8rgensen wrote:
>> >> David Ahern <dsahern@gmail.com> writes:
>> >>
>> >> > On 4/22/20 9:27 AM, Toke H=C3=83=C2=B8iland-J=C3=83=C2=B8rgensen wr=
ote:
>> >> >> And as I said in the beginning, I'm perfectly happy to be told why=
 I'm
>> >> >> wrong; but so far you have just been arguing that I'm out of scope=
 ;)
>> >> >
>> >> > you are arguing about a suspected bug with existing code that is no=
 way
>> >> > touched or modified by this patch set, so yes it is out of scope.
>> >>
>> >> Your patch is relying on the (potentially buggy) behaviour, so I don't
>> >> think it's out of scope to mention it in this context.
>> >
>> > Sorry for slow reply.
>> > I'm swamped with other things atm.
>> >
>> > Looks like there is indeed a bug in prog_type_ext handling code that
>> > is doing
>> > env->ops =3D bpf_verifier_ops[tgt_prog->type];
>> > I'm not sure whether the verifier can simply add:
>> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
>> > and be done with it.
>> > Likely yes, since expected_attach_type must be zero at that point
>> > that is enforced by bpf_prog_load_check_attach().
>> > So I suspect it's a single line fix.
>>
>> Not quite: the check in bpf_tracing_prog_attach() that enforces
>> prog->expected_attach_type=3D=3D0 also needs to go. So 5 lines :)
>
> prog_ext's expected_attach_type needs to stay zero.
> It needs to be inherited from tgt prog. Hence one line:
> prog->expected_attach_type =3D tgt_prog->expected_attach_type;

Not sure I follow you here? I ended up with the patch below - without
the first hunk I can't attach freplace funcs to an xdp egress prog
(since the expected_attach_type will have been propagated from
verification time), and so that check will fail. Or am I missing
something?

-Toke



diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d85f37239540..40c3103c7233 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2381,10 +2381,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *=
prog)
                }
                break;
        case BPF_PROG_TYPE_EXT:
-               if (prog->expected_attach_type !=3D 0) {
-                       err =3D -EINVAL;
-                       goto out_put_prog;
-               }
                break;
        case BPF_PROG_TYPE_LSM:
                if (prog->expected_attach_type !=3D BPF_LSM_MAC) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 513d9c545176..41c31773a3c4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10485,6 +10485,7 @@ static int check_attach_btf_id(struct bpf_verifier_=
env *env)
                                return -EINVAL;
                        }
                        env->ops =3D bpf_verifier_ops[tgt_prog->type];
+                       prog->expected_attach_type =3D tgt_prog->expected_a=
ttach_type;
                }
                if (!tgt_prog->jited) {
                        verbose(env, "Can attach to only JITed progs\n");

