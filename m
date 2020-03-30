Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399A9197D8E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgC3NxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:53:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42247 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgC3NxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585576388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sfr3Wz8gZlZ4mZJliKB/GXqT+ZcydbsQOHciCQAiptI=;
        b=bcxDoIUXizA+dXQqA343i4TpWneI+e7KaLNYAHkrVRgW1vmEGfIrXic/SQgCd+8YPB47ZT
        UVta5SHkg29A7cFz7Tunko9/pIKOEhb7FPNh1lqmf5ZuToIFA57O7e2Dmvt3YysLCfnpPq
        XJ9Rsm1NhNYjYh7TrePWcwGBUTwxrSI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-S-snGJfWO4CC46tJAnwcUQ-1; Mon, 30 Mar 2020 09:53:06 -0400
X-MC-Unique: S-snGJfWO4CC46tJAnwcUQ-1
Received: by mail-lf1-f72.google.com with SMTP id l5so2972280lfg.3
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 06:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=sfr3Wz8gZlZ4mZJliKB/GXqT+ZcydbsQOHciCQAiptI=;
        b=itIA8ny6+qU22BDzHajpGhXQnc9UaPZOv6nwVbS8p6h/edgHFw/Tjjyqv6d67QDvZ7
         gRHd1uNp3UBGTPAoFdNRTfEnbCt/6mnR9roVb3bUH+50zW1tlcE5h75umjQ561LsRdFx
         oELMJXjD6aTIjab2k/HMtZaNkg0I0PvwOgNKz2NaNFFxHDZtJAttLZUK+6ca7ZVAjuUr
         J1GK3YkxPD2rMrpm2ZHIvkb6VBqkIUOQusTISPOYj8A1rL9f6Q/loEwd5/z/RuqgZDlA
         XzMa1idqjCE9Jgv6js6edapD3H76+qB4CrJ34++/VQMYQaGjjI2zTF1XSQqRB5gxSLbw
         gTQQ==
X-Gm-Message-State: AGi0PuY5v4+HupTfOPrwrH6M86M8P0kQiCitpeNOc0hkcUQycaSnR/w9
        G9xfAak/VYcKeZREvCO1iJ7CS5zeN/JVlUAtWz6W5iV4ZGErCVVH3YSvhpAufAmtFz3DBKca5ty
        fX0bidwWQckMh2BOV
X-Received: by 2002:a2e:7c19:: with SMTP id x25mr6730957ljc.253.1585576384897;
        Mon, 30 Mar 2020 06:53:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypK1KlcuJjhO8efN6nW+lV97DOA1p7DFyGNHe4mVWvFV+Fx9stojzIzoLv6oVJ7Y0uSTN3lCJw==
X-Received: by 2002:a2e:7c19:: with SMTP id x25mr6730944ljc.253.1585576384568;
        Mon, 30 Mar 2020 06:53:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o21sm6892952ljg.71.2020.03.30.06.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 06:53:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CA79918158B; Mon, 30 Mar 2020 15:53:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp> <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp> <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp> <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Mar 2020 15:53:01 +0200
Message-ID: <87y2rihruq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Mar 28, 2020 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Sat, Mar 28, 2020 at 02:43:18AM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >>
>> >> No, I was certainly not planning to use that to teach libxdp to just
>> >> nuke any bpf_link it finds attached to an interface. Quite the contra=
ry,
>> >> the point of this series is to allow libxdp to *avoid* replacing
>> >> something on the interface that it didn't put there itself.
>> >
>> > Exactly! "that it didn't put there itself".
>> > How are you going to do that?
>> > I really hope you thought it through and came up with magic.
>> > Because I tried and couldn't figure out how to do that with IFLA_XDP*
>> > Please walk me step by step how do you think it's possible.
>>
>> I'm inspecting the BPF program itself to make sure it's compatible.
>> Specifically, I'm embedding a piece of metadata into the program BTF,
>> using Andrii's encoding trick that we also use for defining maps. So
>> xdp-dispatcher.c contains this[0]:
>>
>> __uint(dispatcher_version, XDP_DISPATCHER_VERSION) SEC(XDP_METADATA_SECT=
ION);
>>
>> and libxdp will refuse to touch any program that it finds loaded on an
>
> But you can't say the same about other XDP applications that do not
> use libxdp. So will your library come with a huge warning, e.g.:
>
> WARNING! ANY XDP APPLICATION YOU INSTALL ON YOUR MACHINE THAT DOESN'T
> USE LIBXDP WILL BREAK YOUR FIREWALLS/ROUTERS/OTHER LIBXDP
> APPLICATIONS. USE AT YOUR OWN RISK.
>
> So you install your libxdp-based firewalls and are happy. Then you
> decide to install this awesome packet analyzer, which doesn't know
> about libxdp yet. Suddenly, you get all packets analyzer, but no more
> firewall, until users somehow notices that it's gone. Or firewall
> periodically checks that it's still runinng. Both not great, IMO, but
> might be acceptable for some users, I guess. But imagine all the
> confusion for user, especially if he doesn't give a damn about XDP and
> other buzzwords, but only needs a reliable firewall :)

Yes, whereas if the firewall is using bpf_link, then the packet analyser
will be locked out and can't do its thing. Either way you end up with a
broken application; it's just moving the breakage. In the case of
firewall vs packet analyser it's probably clear what the right
precedence is, but what if it's firewall vs IDS? Or two different
firewall-type applications?

This is the reason I don't believe the problem bpf_link solves is such a
big deal: Since multi-prog is implemented in userspace it *fundamentally
requires* applications to coordinate. So all the kernel needs to provide,
is a way to help well-behaved applications do this coordination, for
which REPLACE_FD is sufficient.

Now, this picture changes a bit if you have a more-privileged
application managing things - such as the "xdp daemon" I believe you're
using, right? In that case it becomes obvious which application should
have precedence, and the "lock-out" feature makes sense (assuming you
can't just use capabilities to enforce the access restriction). This is
why I keep saying that I understand why you want bpf_link for you use
case, I just don't think it'll help mine much... :)

-Toke

