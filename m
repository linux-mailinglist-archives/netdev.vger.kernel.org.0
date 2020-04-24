Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003731B7018
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDXIzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:55:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726347AbgDXIzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587718548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JyUM84ioj11lvqFNOHlzoIYIB4cjIxmtNBkngOHJI8Y=;
        b=QxAPPEsTvDs966e1befSZbqijufIg/F8iipwiA0jX9AUCP6CSy8cIdJh0pkldUxNJQmT9L
        dlEYOiU30nD0g7O1qVrRFF0ZVvXEE03GPjS9ho1/O0WRGxSrWVs1rPk0A1YGvo0mzDd2Uf
        2ZTFm4OqFqBCridARoxyQ0ZcZb1zJn8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-RxiknxP2N6OKtUS7gMfbIA-1; Fri, 24 Apr 2020 04:55:46 -0400
X-MC-Unique: RxiknxP2N6OKtUS7gMfbIA-1
Received: by mail-lf1-f71.google.com with SMTP id b22so3639976lfa.18
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 01:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JyUM84ioj11lvqFNOHlzoIYIB4cjIxmtNBkngOHJI8Y=;
        b=ekeZNcDvqYTIMZbFz/4LQp6+ZAaruAqEk+V78h5LysgTSy3fzIMwV7LNViPTCgW/0z
         /S0urIf8f4BqbjcumwUEzZY+WgVx8XFTh5KwSIaYWMo+fv0H9aCxH6AeuSr6qkEflzR5
         DXrL2Rxt2YnNj3mMPl1eu0tesKnXegQ533Ds/4tHVS4mhrLmxKgsxWq1E6h078lN5ynP
         mygALwSQsSAX5cKpcuJ5aWh/Dr1O/Szh2FMELSja4HESzHYkehy/growBfOA3fipdwd6
         b/sK8VdARom6f2OxTocPhVdVaYjj78aCf56f7uJ1AVyphO8ZoqjG5MBzi5ztBYpfyoyH
         z6mg==
X-Gm-Message-State: AGi0PuZtp2LL3n1tzHXxnb5AlVZn84mXXn34wZ5JwXsVx2ddgqsVpT4b
        sGZp3OcPJ6cacdMKh7TRU7zN+3C/3wIJAyBZectuKxI3d35hdFmc8+Hq6zIV7fGINVdbzf3T5qH
        NI5mPo5yPBJ0D6IfI
X-Received: by 2002:ac2:46e5:: with SMTP id q5mr5614884lfo.11.1587718544908;
        Fri, 24 Apr 2020 01:55:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypI2xEQ5HfdX8o3bcSiZJXl8qIU/lk9zXkMlSt8FA4Ib0HzPEeDXwkKbmgIF/yhdAWtUFlK5Lw==
X-Received: by 2002:ac2:46e5:: with SMTP id q5mr5614867lfo.11.1587718544629;
        Fri, 24 Apr 2020 01:55:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j14sm4067196lfm.73.2020.04.24.01.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 01:55:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B44A51814FF; Fri, 24 Apr 2020 10:55:42 +0200 (CEST)
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
In-Reply-To: <20200424005308.kguqn53qti26uvp6@ast-mbp.dhcp.thefacebook.com>
References: <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk> <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com> <878sim6tqj.fsf@toke.dk> <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com> <874kta6sk9.fsf@toke.dk> <20200423224451.rkvfnv5cbnjpepgo@ast-mbp> <87lfml69w0.fsf@toke.dk> <20200424005308.kguqn53qti26uvp6@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 10:55:42 +0200
Message-ID: <87a7315kkx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Apr 24, 2020 at 01:49:03AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> > On Thu, Apr 23, 2020 at 07:05:42PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> >> >
>> >> >> > Looks like there is indeed a bug in prog_type_ext handling code =
that
>> >> >> > is doing
>> >> >> > env->ops =3D bpf_verifier_ops[tgt_prog->type];
>> >> >> > I'm not sure whether the verifier can simply add:
>> >> >> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
>> >> >> > and be done with it.
>> >> >> > Likely yes, since expected_attach_type must be zero at that point
>> >> >> > that is enforced by bpf_prog_load_check_attach().
>> >> >> > So I suspect it's a single line fix.
>> >> >>
>> >> >> Not quite: the check in bpf_tracing_prog_attach() that enforces
>> >> >> prog->expected_attach_type=3D=3D0 also needs to go. So 5 lines :)
>> >> >
>> >> > prog_ext's expected_attach_type needs to stay zero.
>> >> > It needs to be inherited from tgt prog. Hence one line:
>> >> > prog->expected_attach_type =3D tgt_prog->expected_attach_type;
>> >>=20
>> >> Not sure I follow you here? I ended up with the patch below - without
>> >> the first hunk I can't attach freplace funcs to an xdp egress prog
>> >> (since the expected_attach_type will have been propagated from
>> >> verification time), and so that check will fail. Or am I missing
>> >> something?
>> >>=20
>> >> -Toke
>> >>=20
>> >>=20
>> >>=20
>> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> >> index d85f37239540..40c3103c7233 100644
>> >> --- a/kernel/bpf/syscall.c
>> >> +++ b/kernel/bpf/syscall.c
>> >> @@ -2381,10 +2381,6 @@ static int bpf_tracing_prog_attach(struct bpf_=
prog *prog)
>> >>                 }
>> >>                 break;
>> >>         case BPF_PROG_TYPE_EXT:
>> >> -               if (prog->expected_attach_type !=3D 0) {
>> >> -                       err =3D -EINVAL;
>> >> -                       goto out_put_prog;
>> >> -               }
>> >>                 break;
>> >
>> > ahh. that extra check.
>> > I think it's better to keep it for extra safety.
>> > Here all expected_attach_type have clear checks depending on prog_type.
>> > There is no other place where it's that obvious.
>> > The verifier does similar thing earlier, but it's not that clear.
>> > I think the better fix would to set expected_attach_type =3D 0 for PRO=
G_TYPE_EXT
>> > at the end of do_check, since we're overriding this field temporarily
>> > during verification.
>>=20
>> OK, sure, can do. I do agree it's better to keep the check. I'll send a
>> proper patch tomorrow, then.
>>=20
>> As far as a adding a selftest for this, I think the most natural thing
>> would be to add it on top of David's tests for xdp_egress, since that's
>> what hit this - would you be OK with that? And if so, should I send the
>> main patch straight away and hold off on the selftest, or should I split
>> them, or hold off on the whole thing?
>
> I think the issue is not related to xdp egress.
> Hence I'd like to push the fix along with selftest into bpf tree.
> The selftest can be:
> void noinline do_bind((struct bpf_sock_addr *ctx)
> {
>   struct sockaddr_in sa =3D {};
>
>   bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa));
>   return 0;
> }
> SEC("cgroup/connect4")
> int connect_v4_prog(struct bpf_sock_addr *ctx)
> {
>   return do_bind(ctx);
> }
>
> and freplace would replace do_bind() with do_new_bind()
> that also calls bpf_bind().
> I think without the fix freplace will fail to load, because
> availability of bpf_bind() depends on correct
> prog->expected_attach_type.

Right, I'll give this a shot, thanks :)

> I haven't looked at the crash you mentioned in the other email related
> to xdp egress set. That could be different issue. I hope it's the same
> thing :)

Yeah, it is.

-Toke

