Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC49473938
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244379AbhLNACt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244348AbhLNACs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 19:02:48 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE61C061574;
        Mon, 13 Dec 2021 16:02:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x5so16445663pfr.0;
        Mon, 13 Dec 2021 16:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hC7TwJmEGObrCnKcK81iW0fnyel7wfMqp7zKvIm4raI=;
        b=Bl3Boog1F/B9DU1oD9J62kDPWFJT30ka9yPFAXJUOWSYN8WkuA661qnO2MsaTV7/XC
         kX3dsMV+6waQaTroeFuiB/CKWG7dQLTYmlmFTeIYMErJUE5VyGwBnKA0xeX4mzdSNAzk
         CO0HBOhgFW4vn4xH8fVIg4J3ibolg41+D/q6lAlS01/jma9JFkdQ9DZqKFes4sAyUMfc
         ZLRkQPrCzHISPtGazeLkawc2ENqJre0DY3vsUeXaZBHAHWyyp0EmjeljwFD4nLzEiqAp
         4TUZZ9c+oac4JqSesfikaM1DyKJVdlI4Tr4tl18k9D/lj8zoRDpB4rtH7IALLDBzNg96
         sy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hC7TwJmEGObrCnKcK81iW0fnyel7wfMqp7zKvIm4raI=;
        b=e0dUSG+2kqihdPQjqIKHzYzWG0R2AIt83rWI9GPvzDAAplJXgcpaa86FJcGQSAIPpY
         Hi/Gv/GU7A/9zqCKl7buyyDRKwufc7HdikjWwFbBzEEZwZlp/Np4gA9LUm9V6RLkTs7o
         Zd+mlFzLfqo/2Clihm8NauxcUWlT/WqxEDzD+JfJDqB6+jdDZ0Rs/1Vgr379FY9FCZUB
         5Wl8rvqK0+Thbce8CEEndutMqoKM5v7no4G4ZOdlww8gbqC0y8YIDq+0fwiWNRiCjLxz
         /9AgssbspHV7HWFfiQd3cGUS2uD+6F/12WGxAY2g5W5kCssoK6TGWmus+j/QP35HvwfM
         vrbA==
X-Gm-Message-State: AOAM532gLzpAsniNS7pmP7QUxSHbqAg0TxpXHIAicq9g7WbbUwbO/T4K
        dymzG0OeLuXLC1BSKGGyXBj0M8Nrc1qM8F5id4wLc67l
X-Google-Smtp-Source: ABdhPJwst6FoYHHucwupspxLIG2iNzbYH3BbhRsOpekDrmMeG+Vp+uQTPTSDq8pDW4In1jo+ST6nGB/AqA569HPdwDk=
X-Received: by 2002:a05:6a00:1583:b0:49f:dc1c:a0fe with SMTP id
 u3-20020a056a00158300b0049fdc1ca0femr1231313pfk.46.1639440167729; Mon, 13 Dec
 2021 16:02:47 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-7-toke@redhat.com>
 <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com> <87tufceaid.fsf@toke.dk>
In-Reply-To: <87tufceaid.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Dec 2021 16:02:36 -0800
Message-ID: <CAADnVQJunh7KTKJe3F_tO0apqLHtOMFqGAB-V28ORh6o5JUTUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 8:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >> +
> >> +static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
> >> +{
> >> +       struct xdp_mem_info mem =3D {
> >> +               .id =3D t->xdp.pp->xdp_mem_id,
> >> +               .type =3D MEM_TYPE_PAGE_POOL,
> >> +       };
> >
> > pls add a new line.
> >
> >> +       xdp_unreg_mem_model(&mem);
> >> +}
> >> +
> >> +static bool ctx_was_changed(struct xdp_page_head *head)
> >> +{
> >> +       return (head->orig_ctx.data !=3D head->ctx.data ||
> >> +               head->orig_ctx.data_meta !=3D head->ctx.data_meta ||
> >> +               head->orig_ctx.data_end !=3D head->ctx.data_end);
> >
> > redundant ()
> >
> >>         bpf_test_timer_enter(&t);
> >>         old_ctx =3D bpf_set_run_ctx(&run_ctx.run_ctx);
> >>         do {
> >>                 run_ctx.prog_item =3D &item;
> >> -               if (xdp)
> >> +               if (xdp && xdp_redirect) {
> >> +                       ret =3D bpf_test_run_xdp_redirect(&t, prog, ct=
x);
> >> +                       if (unlikely(ret < 0))
> >> +                               break;
> >> +                       *retval =3D ret;
> >> +               } else if (xdp) {
> >>                         *retval =3D bpf_prog_run_xdp(prog, ctx);
> >
> > Can we do this unconditionally without introducing a new uapi flag?
> > I mean "return bpf_redirect()" was a nop under test_run.
> > What kind of tests might break if it stops being a nop?
>
> Well, I view the existing mode of bpf_prog_test_run() with XDP as a way
> to write XDP unit tests: it allows you to submit a packet, run your XDP
> program on it, and check that it returned the right value and did the
> right modifications. This means if you XDP program does 'return
> bpf_redirect()', userspace will still get the XDP_REDIRECT value and so
> it can check correctness of your XDP program.
>
> With this flag the behaviour changes quite drastically, in that it will
> actually put packets on the wire instead of getting back the program
> return. So I think it makes more sense to make it a separate opt-in
> mode; the old behaviour can still be useful for checking XDP program
> behaviour.

Ok that all makes sense.
How about using prog_run to feed the data into proper netdev?
XDP prog may or may not attach to it (this detail is tbd) and
prog_run would use prog_fd and ifindex to trigger RX (yes, receive)
in that netdev. XDP prog will execute and will be able to perform
all actions (not only XDP_REDIRECT).
XDP_PASS would pass the packet to the stack, etc.
