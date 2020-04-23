Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4D1B611E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgDWQkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:40:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729423AbgDWQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587660029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ASYdh1hV1CbjXF0Nl4LK9H8rarQyPhZQjaZFPxMzX0=;
        b=CxZTGqqaa5s4e8o23hWjQY5iPPQt7utbxqwHgRDArJg+ViaiMF/so5Wn6rjhVRT5X/8+AL
        7n0yg6oSbCXsMJ0D5ASLmByRQPbP0UTdsq8atD+btBfLL/Tc1wxV8HMa9Ggd+P5nyQEsc1
        Z6f2WQXAVMmPqDpFDRJWuOamWpIOumE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-UdfYxQe0Nm62aqzuvEi7_A-1; Thu, 23 Apr 2020 12:40:25 -0400
X-MC-Unique: UdfYxQe0Nm62aqzuvEi7_A-1
Received: by mail-lf1-f70.google.com with SMTP id l6so2557307lfk.2
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=5ASYdh1hV1CbjXF0Nl4LK9H8rarQyPhZQjaZFPxMzX0=;
        b=cgdyPfcrmo/71PgFDzAKOMC+0xuSWdDCOjKZP3VhXfymRc206/1ZuMk+6IcuBZudlL
         KhqtijW5PJ4+H4xEIEa73r4exYWZVSbUtjTq3WluGBmlDeFx+sV33nPy66tD9jzlGTOT
         WECQhwv7rXxsphRQuvDw+R8vAtu+rZAN/zSPjZZF0l8lJk6S5ZP10wgig9D1rE0XBgig
         m3FgVZjIHWljA2d/aifwJy734cOeaSqcJa/hh8xa6R7W/AkTzR1b1yMRDbXh3UT2If2U
         vaK+IVvnMWtOjijY0D9WbWy4rUTHvqetPibaJN0e5y+c6jzh9bCwHlwzJ+LRNnSNoT7c
         BCCg==
X-Gm-Message-State: AGi0PubAH0pZ+yNBMPHXtevO2ib7zGu/qYL6D0LoalASPyzQTyxu70ty
        /pw3exL7WQbTVsSB2BKlFpxZKClEetp1JylU9jkKxBIwy2N/zJWsX8DIbnEQ0vaBX7CZHBjckDo
        3TFhG13mMAbNHJxNX
X-Received: by 2002:a2e:2201:: with SMTP id i1mr2875780lji.31.1587660024244;
        Thu, 23 Apr 2020 09:40:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypLJGwBYXlgTdwQg4Gj5JVWLiOhi4jt7Mt94/oC0jCogGT+ixvIA8W4vgVPi/WdCv6VmvaiVPw==
X-Received: by 2002:a2e:2201:: with SMTP id i1mr2875752lji.31.1587660024005;
        Thu, 23 Apr 2020 09:40:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f15sm2171498lfh.76.2020.04.23.09.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 09:40:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A4CAD1814FF; Thu, 23 Apr 2020 18:40:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
References: <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk> <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Apr 2020 18:40:20 +0200
Message-ID: <878sim6tqj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Apr 22, 2020 at 05:51:36PM +0200, Toke H=C3=83=C2=B8iland-J=C3=83=
=C2=B8rgensen wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>=20
>> > On 4/22/20 9:27 AM, Toke H=C3=83=C2=B8iland-J=C3=83=C2=B8rgensen wrote:
>> >> And as I said in the beginning, I'm perfectly happy to be told why I'm
>> >> wrong; but so far you have just been arguing that I'm out of scope ;)
>> >
>> > you are arguing about a suspected bug with existing code that is no way
>> > touched or modified by this patch set, so yes it is out of scope.
>>=20
>> Your patch is relying on the (potentially buggy) behaviour, so I don't
>> think it's out of scope to mention it in this context.
>
> Sorry for slow reply.
> I'm swamped with other things atm.
>
> Looks like there is indeed a bug in prog_type_ext handling code that
> is doing
> env->ops =3D bpf_verifier_ops[tgt_prog->type];
> I'm not sure whether the verifier can simply add:
> prog->expected_attach_type =3D tgt_prog->expected_attach_type;
> and be done with it.
> Likely yes, since expected_attach_type must be zero at that point
> that is enforced by bpf_prog_load_check_attach().
> So I suspect it's a single line fix.

Not quite: the check in bpf_tracing_prog_attach() that enforces
prog->expected_attach_type=3D=3D0 also needs to go. So 5 lines :)

With those two changes, I do seem to get the correct behaviour for XDP
multiprogs in both ingress and egress mode (with David's patch set).

> A selftest to prove or disprove is necessary, of course.

I'll see if I can't hook this into the existing freplace selftest and
send a proper patch. I'm not really sure how to check for any hidden
side effects; in particular I'm a bit twitchy about removing that check
in bpf_tracing_prog_attach() - presumably it is there for a reason? But
I guess I'll send a patch and you can take a look.

> Thanks Toke for bringing it to my attention.

You're quite welcome! And thanks for the hint that the fix was that
simple; I feared something more invasive was needed.

-Toke

