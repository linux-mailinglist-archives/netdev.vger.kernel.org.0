Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF32642CA
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgIJJtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:49:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730257AbgIJJtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599731351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKQHNRVAjod8FAmstbFxZbVVfzJzd7Y851DUDRfyK8c=;
        b=b2c9XPK5F05kgu7bE2wGnDlgSMGgSUWMSGSef96WvTE1Hs0jK8vSgp4toSMvo7sJonec/h
        jewyZN5jvbzKWxGLcQ03JtKurSOwvpR08Yocq7H/nYavFpGM6lnbaV9IRzG50QFyydhQXT
        xw5ybT8aVUcAJ3zhzXfS521AYigW6eA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-fCehowCHOzibgANLYSFoaQ-1; Thu, 10 Sep 2020 05:49:10 -0400
X-MC-Unique: fCehowCHOzibgANLYSFoaQ-1
Received: by mail-wr1-f69.google.com with SMTP id k13so2053152wrw.16
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=OKQHNRVAjod8FAmstbFxZbVVfzJzd7Y851DUDRfyK8c=;
        b=gwu+gB0PHiOlChmzZbagqFIFbiPJcWUKDLLBhC55M5ErgUn5lqjm638ygOWTKGijpf
         7tpug39VT4SBb4wRCFx4+5kiRMtvnYg9HxMscOkFeQsTl46yn8KWHr0Lw6FfOxqOr+y+
         CA+HYzUeIjIfuuTq99KiwDPBVO63pCrS39qLCYfhf/yG1/Sqd1bToL95iw8vDhuunCKE
         X2AKPtI+mVKgFhDou5wlWTO8k43q1wDE91cB9sy5JEmgH9SGhlg/IHpsefMBHrgrZyai
         apDPw+ooRcgfkpLD3EoxeXgwP2BVE/fjtgv400FZa7pqsgOiByUIpdmY7PDHYbgFfaMQ
         loRQ==
X-Gm-Message-State: AOAM531gRW6hbWgKdgBkJi4er/nDzzdaDnhy6SLHs5fjuYoIEZrra/2I
        uV/tekOVodwY2Pcxa0I7JvGTqrAptCDZZpjdHbWB5JlxLoh+RUwg1FdEDm/CnZaI5kPxOKg7XMw
        s1tH6orvHVnqlXfxS
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr8813312wrm.150.1599731348349;
        Thu, 10 Sep 2020 02:49:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/ddMSw0janJm0VrprHFTkacj6bB82Qe392M/4DlfoMJ+HO/6ag9O+IC6S3iyHuiRtFJkJEw==
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr8813265wrm.150.1599731347835;
        Thu, 10 Sep 2020 02:49:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y1sm2886870wmd.22.2020.09.10.02.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 02:49:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BB0C21829D4; Thu, 10 Sep 2020 11:49:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Fix context type resolving for
 extension programs
In-Reply-To: <20200909185838.GG1498025@krava>
References: <20200909151115.1559418-1-jolsa@kernel.org>
 <871rjbc5d9.fsf@toke.dk> <20200909185838.GG1498025@krava>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Sep 2020 11:49:06 +0200
Message-ID: <87lfhiarn1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> On Wed, Sep 09, 2020 at 05:54:58PM +0200, Toke H=C3=83=C2=B8iland-J=C3=83=
=C2=B8rgensen wrote:
>> Jiri Olsa <jolsa@kernel.org> writes:
>>=20
>> > Eelco reported we can't properly access arguments if the tracing
>> > program is attached to extension program.
>> >
>> > Having following program:
>> >
>> >   SEC("classifier/test_pkt_md_access")
>> >   int test_pkt_md_access(struct __sk_buff *skb)
>> >
>> > with its extension:
>> >
>> >   SEC("freplace/test_pkt_md_access")
>> >   int test_pkt_md_access_new(struct __sk_buff *skb)
>> >
>> > and tracing that extension with:
>> >
>> >   SEC("fentry/test_pkt_md_access_new")
>> >   int BPF_PROG(fentry, struct sk_buff *skb)
>> >
>> > It's not possible to access skb argument in the fentry program,
>> > with following error from verifier:
>> >
>> >   ; int BPF_PROG(fentry, struct sk_buff *skb)
>> >   0: (79) r1 =3D *(u64 *)(r1 +0)
>> >   invalid bpf_context access off=3D0 size=3D8
>> >
>> > The problem is that btf_ctx_access gets the context type for the
>> > traced program, which is in this case the extension.
>> >
>> > But when we trace extension program, we want to get the context
>> > type of the program that the extension is attached to, so we can
>> > access the argument properly in the trace program.
>> >
>> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
>> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> > ---
>> >  kernel/bpf/btf.c | 8 ++++++++
>> >  1 file changed, 8 insertions(+)
>> >
>> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> > index f9ac6935ab3c..37ad01c32e5a 100644
>> > --- a/kernel/bpf/btf.c
>> > +++ b/kernel/bpf/btf.c
>> > @@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf=
_access_type type,
>> >  	}
>> >=20=20
>> >  	info->reg_type =3D PTR_TO_BTF_ID;
>> > +
>> > +	/* When we trace extension program, we want to get the context
>> > +	 * type of the program that the extension is attached to, so
>> > +	 * we can access the argument properly in the trace program.
>> > +	 */
>> > +	if (tgt_prog && tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
>> > +		tgt_prog =3D tgt_prog->aux->linked_prog;
>> > +
>>=20
>> In the discussion about multi-attach for freplace we kinda concluded[0]
>> that this linked_prog pointer was going away after attach. I have this
>> basically working, but need to test a bit more before posting it (see
>> [1] for current status).
>
> ok, feel free to use the test case from patch 2 ;-)
>
>>=20
>> But with this I guess we'll need to either do something different? Maybe
>> go chase down the target via the bpf_link or something?
>
> I'll check, could you please CC me on your next post?

Sure, will do!

-Toke

