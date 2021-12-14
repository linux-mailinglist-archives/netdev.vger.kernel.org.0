Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA94741CA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhLNLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:48:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233701AbhLNLsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 06:48:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639482481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3RvtHCVmlMZy9Ar2QfnJIpooqhdOg1Edmr9vHxfSUd0=;
        b=ThMhs4HGkvQsrZOR9KBa0zMqP9IfoeGRUdZgC8d1fm9PSdHnZzro4uSN6dXeDwjYQ3kTUh
        owgWIcDYs8mgYb7+PdKx7e5YZUf4JkQoQlYoeUcdtiqlr6gS0ou9zp7xHBDOUC5uqkKT7w
        +J18QO94BGL7tPoo3jyNNtsRj/pySUQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-p1wbhLJcMsqstES02VI-DA-1; Tue, 14 Dec 2021 06:47:00 -0500
X-MC-Unique: p1wbhLJcMsqstES02VI-DA-1
Received: by mail-ed1-f71.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so16716911eds.23
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 03:46:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3RvtHCVmlMZy9Ar2QfnJIpooqhdOg1Edmr9vHxfSUd0=;
        b=2MIvIMAhyuzRbzn1L9b81+Lvt7WcC7MkN34rQ6MqquDFfLYNVe+qQbRGWoDIv5yP02
         qWJ3Lm4L0dq48gJLWgoZXXTGXtQEu1upqLlX5XURiBvMMwVD198qMduFFpS74P7L7Z6L
         VggOCSaSXBKvAh1P0BIBmfb3V8xoiOyhXH9kr4dlkc1TSnW13ioy3AJOC/uZxL22SVyK
         ty5RpfASzJwF8HuVGlfSK4UGFMSVJJAvQ9nCUe6X8nsa4MOgLb4mvxmPNl5AooOBgNaJ
         T3jW3AsoOJDj6wsZNDzqoRTqUEhecJfXert4KPsUkGCw0jJReDpROJEU1JeqCEhn0BIU
         tm1Q==
X-Gm-Message-State: AOAM532/zvpmb1HXBja2E3hRSYg92TYXWGb8WsOr6JgH38SxCEY4l6DT
        ImcrWvZCO9uJbjSBV+H1ZuQMh0h2AmlrbBniqbOK+rNAKUD5qAyTfTT3EtSg0Ke/LWoKlReJMSz
        Me17ynl1fMjadnXKj
X-Received: by 2002:aa7:cd8a:: with SMTP id x10mr7162149edv.3.1639482417853;
        Tue, 14 Dec 2021 03:46:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZNEPABW3x0WzZIWAhn1kMS0hIUA1n/NxBrALSeJRp+RasyTPS9tjpja95XnCjrc8hhifFSA==
X-Received: by 2002:aa7:cd8a:: with SMTP id x10mr7162031edv.3.1639482416907;
        Tue, 14 Dec 2021 03:46:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 26sm1291854ejk.138.2021.12.14.03.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:46:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B3A83183566; Tue, 14 Dec 2021 12:46:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP
 for bpf_prog_run()
In-Reply-To: <CAADnVQKRAFCqUj9J8B5cM4u=wS-0Kh9YZYR=QqT6GiiX3ZXXDQ@mail.gmail.com>
References: <20211211184143.142003-1-toke@redhat.com>
 <20211211184143.142003-7-toke@redhat.com>
 <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com>
 <87tufceaid.fsf@toke.dk>
 <CAADnVQJunh7KTKJe3F_tO0apqLHtOMFqGAB-V28ORh6o5JUTUQ@mail.gmail.com>
 <87fsqwyqdf.fsf@toke.dk>
 <CAADnVQKRAFCqUj9J8B5cM4u=wS-0Kh9YZYR=QqT6GiiX3ZXXDQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Dec 2021 12:46:55 +0100
Message-ID: <874k7bz9w0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Dec 13, 2021 at 4:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Mon, Dec 13, 2021 at 8:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >>
>> >> > On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
>> >> >> +
>> >> >> +static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
>> >> >> +{
>> >> >> +       struct xdp_mem_info mem =3D {
>> >> >> +               .id =3D t->xdp.pp->xdp_mem_id,
>> >> >> +               .type =3D MEM_TYPE_PAGE_POOL,
>> >> >> +       };
>> >> >
>> >> > pls add a new line.
>> >> >
>> >> >> +       xdp_unreg_mem_model(&mem);
>> >> >> +}
>> >> >> +
>> >> >> +static bool ctx_was_changed(struct xdp_page_head *head)
>> >> >> +{
>> >> >> +       return (head->orig_ctx.data !=3D head->ctx.data ||
>> >> >> +               head->orig_ctx.data_meta !=3D head->ctx.data_meta =
||
>> >> >> +               head->orig_ctx.data_end !=3D head->ctx.data_end);
>> >> >
>> >> > redundant ()
>> >> >
>> >> >>         bpf_test_timer_enter(&t);
>> >> >>         old_ctx =3D bpf_set_run_ctx(&run_ctx.run_ctx);
>> >> >>         do {
>> >> >>                 run_ctx.prog_item =3D &item;
>> >> >> -               if (xdp)
>> >> >> +               if (xdp && xdp_redirect) {
>> >> >> +                       ret =3D bpf_test_run_xdp_redirect(&t, prog=
, ctx);
>> >> >> +                       if (unlikely(ret < 0))
>> >> >> +                               break;
>> >> >> +                       *retval =3D ret;
>> >> >> +               } else if (xdp) {
>> >> >>                         *retval =3D bpf_prog_run_xdp(prog, ctx);
>> >> >
>> >> > Can we do this unconditionally without introducing a new uapi flag?
>> >> > I mean "return bpf_redirect()" was a nop under test_run.
>> >> > What kind of tests might break if it stops being a nop?
>> >>
>> >> Well, I view the existing mode of bpf_prog_test_run() with XDP as a w=
ay
>> >> to write XDP unit tests: it allows you to submit a packet, run your X=
DP
>> >> program on it, and check that it returned the right value and did the
>> >> right modifications. This means if you XDP program does 'return
>> >> bpf_redirect()', userspace will still get the XDP_REDIRECT value and =
so
>> >> it can check correctness of your XDP program.
>> >>
>> >> With this flag the behaviour changes quite drastically, in that it wi=
ll
>> >> actually put packets on the wire instead of getting back the program
>> >> return. So I think it makes more sense to make it a separate opt-in
>> >> mode; the old behaviour can still be useful for checking XDP program
>> >> behaviour.
>> >
>> > Ok that all makes sense.
>>
>> Great!
>>
>> > How about using prog_run to feed the data into proper netdev?
>> > XDP prog may or may not attach to it (this detail is tbd) and
>> > prog_run would use prog_fd and ifindex to trigger RX (yes, receive)
>> > in that netdev. XDP prog will execute and will be able to perform
>> > all actions (not only XDP_REDIRECT).
>> > XDP_PASS would pass the packet to the stack, etc.
>>
>> Hmm, that's certainly an interesting idea! I don't think we can actually
>> run the XDP hook on the netdev itself (since that is deep in the
>> driver), but we can emulate it: we just need to do what this version of
>> the patch is doing, but add handling of the other return codes.
>>
>> XDP_PASS could be supported by basically copying what cpumap is doing
>> (turn the frames into skbs and call netif_receive_skb_list()), but
>> XDP_TX would have to be implemented via ndo_xdp_xmit(), so it becomes
>> equivalent to a REDIRECT back to the same interface. That's probably OK,
>> though, right?
>
> Yep. Something like this.
> imo the individual BPF_F_TEST_XDP_DO_REDIRECT knob doesn't look right.
> It's tweaking the prog run from no side effects execution model
> to partial side effects.
> If we want to run xdp prog with side effects it probably should
> behave like normal execution on the netdev when it receives the packet.
> We might not even need to create a new netdev for that.
> I can imagine a bpf_prog_run operating on eth0 with a packet prepared
> by the user space.
> Like injecting a packet right into the driver and xdp part of it.
> If prog says XDP_PASS the packet will go up the stack like normal.
> So this mechanism could be used to inject packets into the stack.
> Obviously buffer management is an issue in the traditional NIC
> when a packet doesn't come from the wire.
> Also doing this in every driver would be a pain.
> So we need some common infra to inject the user packet into a netdev
> like it was received by this netdev. It could be a change for tuntap
> or for veth or not related to netdev at all.

What you're describing is basically what the cpumap code does; except it
doesn't handle XDP_TX, and it doesn't do buffer management. But I
already implemented the latter, and the former is straight-forward to do
as a special-case XDP_REDIRECT. So my plan is to try this out and see
what that looks like :)

> After XDP_PASS it doesn't need to be fast. skb will get allocated
> and the stack might see it as it arrived from ifindex=3DN regardless
> of the HW of that netdev.
> XDP_TX would xmit right out of that ifindex=3Dnetdev.
> and XDP_REDIRECT would redirect to a different netdev.
> At the end there will be less special cases and page_pool tweaks.
> Thought the patches 1-5 look fine, it still feels a bit custom
> just for this particular BPF_F_TEST_XDP_DO_REDIRECT use case.
> With more generic bpf_run_prog(xdp_prog_fd, ifindex_of_netdev)
> it might reduce custom handling.

Yup, totally makes sense!

-Toke

