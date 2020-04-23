Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A71B6A1D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDWXtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 19:49:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23822 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727065AbgDWXtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 19:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587685755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGNYPrsKE2QzIZTAtX5CBdu4BgbJymSRQ/Hbqy1rmro=;
        b=QC4TCMMU6FhM6cUQyGk5xPLFATzHTcZQaaTbLXcU6ZPyWcwOsVVMkY1NrzxambK+i/VRpw
        jyMOuqvwxjFaiUBerxBPrQYhO+T98JfsaUycYr1ickNK1ZvColDVKUQMd4bg88xafnS8k1
        OcHy/oT5PbmFohZiHEvY9bVTP+RMz18=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-_tvk9hmwMU2dbNINIBtxPQ-1; Thu, 23 Apr 2020 19:49:13 -0400
X-MC-Unique: _tvk9hmwMU2dbNINIBtxPQ-1
Received: by mail-lj1-f200.google.com with SMTP id z1so1507578ljk.9
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 16:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EGNYPrsKE2QzIZTAtX5CBdu4BgbJymSRQ/Hbqy1rmro=;
        b=TzOJwqh/WnVIOK5906mbth0/8VbWcDKVSbs58KPVxRY23CHamh/V9dcubDdHh4j4w6
         OZAtg+iPtbrJaeSXDp+ptjXhDWK03Zp25Oko1DEKI+VrJDbYBwQJ0f/hWMvu5GPuM0KQ
         1AaO8+IlT/RmaZpwyjV0YZg/1Of6hcThzzYl8gEHhsx9XyM/wWTB3QxYinlFwxT9Kt4I
         Lls56IzvjISiWeSSrVAUlT6Gh7LQebC0UbNkG0M/9qd7StTX3wItxppoqXinZy41/B4M
         TehsUmBPGs6oVesWc3JzNtotVNbpa2ehQ9rur5Nkcdm2Dn+RhZFzMDfY6ZE9PBliiTFJ
         LkQA==
X-Gm-Message-State: AGi0PubtezWDcyScoAfwMvzRrp1d32Q0y0/r219ePJgg9qh6J+01FjuB
        WxR1gTLMvaUGb4peT2nu8excr9VOP5nLHkRaGgT2wA04GT8faREgxSfePWaeAGzwRBTqhEwgYSh
        e1VughJfN/ZOUjTWC
X-Received: by 2002:a2e:860a:: with SMTP id a10mr4200500lji.20.1587685750032;
        Thu, 23 Apr 2020 16:49:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypKtneE/cD3e+H6P2tBXAjlHTK7Kp0vkn//2F1IA/EKA7QMDJRgS497+B39VT17COMuM1sGKkw==
X-Received: by 2002:a2e:860a:: with SMTP id a10mr4200474lji.20.1587685749722;
        Thu, 23 Apr 2020 16:49:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u7sm1891947ljk.32.2020.04.23.16.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 16:49:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C3DF31814FF; Fri, 24 Apr 2020 01:49:03 +0200 (CEST)
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
In-Reply-To: <20200423224451.rkvfnv5cbnjpepgo@ast-mbp>
References: <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk> <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com> <878sim6tqj.fsf@toke.dk> <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com> <874kta6sk9.fsf@toke.dk> <20200423224451.rkvfnv5cbnjpepgo@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 01:49:03 +0200
Message-ID: <87lfml69w0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Apr 23, 2020 at 07:05:42PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> >> >
>> >> > Looks like there is indeed a bug in prog_type_ext handling code that
>> >> > is doing
>> >> > env->ops =3D bpf_verifier_ops[tgt_prog->type];
>> >> > I'm not sure whether the verifier can simply add:
>> >> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
>> >> > and be done with it.
>> >> > Likely yes, since expected_attach_type must be zero at that point
>> >> > that is enforced by bpf_prog_load_check_attach().
>> >> > So I suspect it's a single line fix.
>> >>
>> >> Not quite: the check in bpf_tracing_prog_attach() that enforces
>> >> prog->expected_attach_type=3D=3D0 also needs to go. So 5 lines :)
>> >
>> > prog_ext's expected_attach_type needs to stay zero.
>> > It needs to be inherited from tgt prog. Hence one line:
>> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
>>=20
>> Not sure I follow you here? I ended up with the patch below - without
>> the first hunk I can't attach freplace funcs to an xdp egress prog
>> (since the expected_attach_type will have been propagated from
>> verification time), and so that check will fail. Or am I missing
>> something?
>>=20
>> -Toke
>>=20
>>=20
>>=20
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index d85f37239540..40c3103c7233 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2381,10 +2381,6 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>>                 }
>>                 break;
>>         case BPF_PROG_TYPE_EXT:
>> -               if (prog->expected_attach_type !=3D 0) {
>> -                       err =3D -EINVAL;
>> -                       goto out_put_prog;
>> -               }
>>                 break;
>
> ahh. that extra check.
> I think it's better to keep it for extra safety.
> Here all expected_attach_type have clear checks depending on prog_type.
> There is no other place where it's that obvious.
> The verifier does similar thing earlier, but it's not that clear.
> I think the better fix would to set expected_attach_type =3D 0 for PROG_T=
YPE_EXT
> at the end of do_check, since we're overriding this field temporarily
> during verification.

OK, sure, can do. I do agree it's better to keep the check. I'll send a
proper patch tomorrow, then.

As far as a adding a selftest for this, I think the most natural thing
would be to add it on top of David's tests for xdp_egress, since that's
what hit this - would you be OK with that? And if so, should I send the
main patch straight away and hold off on the selftest, or should I split
them, or hold off on the whole thing?

-Toke

