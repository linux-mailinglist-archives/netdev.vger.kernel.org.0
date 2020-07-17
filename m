Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655E82239C5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgGQKwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:52:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55897 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgGQKwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594983139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=16V5pZxosMoRpIebeUEyRPYvMH0eT20D9HNI4XJmraA=;
        b=RXmp07NnD72PV6MuI/bmpDTj2qNLc01xrpbL+LW5M7pK0+pY3CPrxgiBXqrQJi74FAfzV7
        1xTo/zrM9j00dANFTHndg8MP7jOs3HhboVo0H4KP1w6ctHmHX6kCYBjqwt8+231h+8EW90
        +gZ05vzegPSAZPLng+zvbnfrpYEfeJE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-WGpwTsSNOXm1d287pXGF7w-1; Fri, 17 Jul 2020 06:52:17 -0400
X-MC-Unique: WGpwTsSNOXm1d287pXGF7w-1
Received: by mail-pf1-f198.google.com with SMTP id r12so6613303pfr.16
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=16V5pZxosMoRpIebeUEyRPYvMH0eT20D9HNI4XJmraA=;
        b=Z530vDd3Ly/3OkEp3tI2AK5AUOWkAuydx+dnTWL1IpCxOxKsPkL+JZwrfk7A46RUqL
         ik+2a3PRDaufnbyKhlDIT+K0Xa1R6eSHzEL47dzOZXI1xUOQqtSky3RGflsrPCk5wGjm
         H0H9UryRWMettGZIE54P2QKLP/JZ5ClZmYPq8EsudXRtVQ/XeY6DLvm9mR1HlbfU1/p6
         WHs5Oo7vxtLP9HEVsJFqGAeW8Rx6BDztsKGyDGzIkZ80cy106I0CvV1lw9U6ia0Tzg89
         GjZTUdMD0KFKjhZcSRKtySg7XhW1C48wE89lHywaFZDqB76D/nvNpDCbPC1DF6OiTzfF
         KBrA==
X-Gm-Message-State: AOAM5307OwHA/+wO9nKwIxO97kbhUifdEC7AnWYlgFmSSP93JOUcI1vU
        jioKQt0oI4aZ8EIBpj846ddnrtP3MG62ewis2//whPTQso7BeP/qowZRa07DlJBuplwvOhJ2NYv
        lnLpKLOIym5cq6IAL
X-Received: by 2002:a62:192:: with SMTP id 140mr7198213pfb.53.1594983136803;
        Fri, 17 Jul 2020 03:52:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMNBLksGWOFuqtvhb1wh4/OHOEr/22oo8ePdVCsHNAmsFpR5amjVqNHDPQc5W1uRpQiJNTwg==
X-Received: by 2002:a62:192:: with SMTP id 140mr7198194pfb.53.1594983136268;
        Fri, 17 Jul 2020 03:52:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w1sm7351225pfc.55.2020.07.17.03.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:52:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 65BFA181719; Fri, 17 Jul 2020 12:52:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs to multiple attach points
In-Reply-To: <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk> <159481854255.454654.15065796817034016611.stgit@toke.dk> <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com> <87mu3zentu.fsf@toke.dk> <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Jul 2020 12:52:10 +0200
Message-ID: <87imemct2d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jul 16, 2020 at 12:50:05PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> > On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> >>=20=20
>> >> +	if (tgt_prog_fd) {
>> >> +		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
>> >> +		if (prog->type !=3D BPF_PROG_TYPE_EXT ||
>> >> +		    !btf_id) {
>> >> +			err =3D -EINVAL;
>> >> +			goto out_put_prog;
>> >> +		}
>> >> +		tgt_prog =3D bpf_prog_get(tgt_prog_fd);
>> >> +		if (IS_ERR(tgt_prog)) {
>> >> +			err =3D PTR_ERR(tgt_prog);
>> >> +			tgt_prog =3D NULL;
>> >> +			goto out_put_prog;
>> >> +		}
>> >> +
>> >> +	} else if (btf_id) {
>> >> +		err =3D -EINVAL;
>> >> +		goto out_put_prog;
>> >> +	} else {
>> >> +		btf_id =3D prog->aux->attach_btf_id;
>> >> +		tgt_prog =3D prog->aux->linked_prog;
>> >> +		if (tgt_prog)
>> >> +			bpf_prog_inc(tgt_prog); /* we call bpf_prog_put() on link release=
 */
>> >
>> > so the first prog_load cmd will beholding the first target prog?
>> > This is complete non starter.
>> > You didn't mention such decision anywhere.
>> > The first ext prog will attach to the first dispatcher xdp prog,
>> > then that ext prog will multi attach to second dispatcher xdp prog and
>> > the first dispatcher prog will live in the kernel forever.
>>=20
>> Huh, yeah, you're right that's no good. Missing that was a think-o on my
>> part, sorry about that :/
>>=20
>> > That's not what we discussed back in April.
>>=20
>> No, you mentioned turning aux->linked_prog into a list. However once I
>> started looking at it I figured it was better to actually have all this
>> (the trampoline and ref) as part of the bpf_link structure, since
>> logically they're related.
>>=20
>> But as you pointed out, the original reference sticks. So either that
>> needs to be removed, or I need to go back to the 'aux->linked_progs as a
>> list' idea. Any preference?
>
> Good question. Back then I was thinking about converting linked_prog into=
 link
> list, since standalone single linked_prog is quite odd, because attaching=
 ext
> prog to multiple tgt progs should have equivalent properties across all
> attachments.
> Back then bpf_link wasn't quite developed.
> Now I feel moving into bpf_tracing_link is better.
> I guess a link list of bpf_tracing_link-s from 'struct bpf_prog' might wo=
rk.
> At prog load time we can do bpf_link_init() only (without doing bpf_link_=
prime)
> and keep this pre-populated bpf_link with target bpf prog and trampoline
> in a link list accessed from 'struct bpf_prog'.
> Then bpf_tracing_prog_attach() without extra tgt_prog_fd/btf_id would com=
plete
> that bpf_tracing_link by calling bpf_link_prime() and bpf_link_settle()
> without allocating new one.
> Something like:
> struct bpf_tracing_link {
>         struct bpf_link link;  /* ext prog pointer is hidding in there */
>         enum bpf_attach_type attach_type;
>         struct bpf_trampoline *tr;
>         struct bpf_prog *tgt_prog; /* old aux->linked_prog */
> };
>
> ext prog -> aux -> link list of above bpf_tracing_link-s

Yeah, I thought along these lines as well (was thinking a new struct
referenced from bpf_tracing_link, but sure, why not just stick the whole
thing into aux?).

> It's a circular reference, obviously.
> Need to think through the complications and locking.

Yup, will do so when I get back to this. One other implication of this
change: If we make the linked_prog completely dynamic you can no longer
do:

link_fd =3D bpf_raw_tracepoint_open(prog);
close(link_fd);
link_fd =3D bpf_raw_tracepoint_open(prog):

since after that close(), the original linked_prog will be gone. Unless
we always leave at least one linked_prog alive? But then we can't
guarantee that it's the target that was supplied on program load if it
was reattached. Is that acceptable?

>> I don't think you are. I'll admit to them being a bit raw, but this was
>> as far as I got and since I'll be away for three weeks I figured it was
>> better to post them in case anyone else was interested in playing with
>> it.
>
> Since it was v2 I figured you want it to land and it's ready.
> Next time please mention the state of patches.
> It's absolutely fine to post raw patches. It's fine to post stuff
> that doesn't compile. But please explain the state in commit logs or cove=
r.

Right, sorry that was not clear; will make sure to spell it out next
time.

-Toke

