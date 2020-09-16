Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE826CE79
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIPWQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:16:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54736 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726201AbgIPWQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600294570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKyQHtllfjl38VuqidhNRrCZLUb1C7B5tIlC3LIp3Bs=;
        b=ZokNfHrpk15gE25cNWBAW1s00PMHRjaNmd4a2KyOQR98LraUkW6wQB3Hs6o+AEy3kFQSRt
        l5tjGNXt2ltT0aBSHGoTt4lWCMqKbeSWRSejztrjmo+LvJ0KwGE5ASxC2fm7hsLdAsMPP5
        l6sXFG1zAqZcXoB2BSwizGtc3kPKyS0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-hpeklCK3Nlitbyl-ecNhYg-1; Wed, 16 Sep 2020 17:15:04 -0400
X-MC-Unique: hpeklCK3Nlitbyl-ecNhYg-1
Received: by mail-ed1-f72.google.com with SMTP id n25so25228edr.13
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SKyQHtllfjl38VuqidhNRrCZLUb1C7B5tIlC3LIp3Bs=;
        b=pRAD8ZXKhw2/Xqog5iXwqjQDFJOtwonxlFid1lErzd678YU7VLbtGVlP2fEu0jCDNq
         zkUATw75MhuSnHkdUbNRBKl50L3iByXvsVnaOBDCkVUWJpMXD8nFX+LAv4pLHlSFLHxi
         Za23NTwOxdwTa7wqY9pdEuz326gtRfpl54CulcXvSepph1ICSo8hiqxQ+fD/zhfBALdG
         ii/OLxWyBhHkL8+qLRniZNShqSq3TUjoJIwWGkjWf4HUVb30WRUTr1Uqg/UfVyIs1mTs
         jMjCMm45KxlC4DPk28AICbU6c9ckGfmDiyNTPtYyFkszhg6Zbu5faS80KNleVEUE8Vam
         0UOQ==
X-Gm-Message-State: AOAM531yTnW3oHvabtEPBGqcLYBaoSsKRd/uVB4ImP10K7kI5SerEcFB
        kopG5oJZ4jqc8b497HMZzZtNfo9l7S463lAD9pJz3bg48O0lV2tABYkO5Vw6Yebsc63YOBXTo7N
        VCujVEAZAkiOrS3gZ
X-Received: by 2002:aa7:d382:: with SMTP id x2mr30236917edq.108.1600290902690;
        Wed, 16 Sep 2020 14:15:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdDCN1mVaK4AF9F/pdAtrwvaMvUWUni3Tb49vBJZH0flcjLobuEcz5ptmQiaTr7lywT7x4Pw==
X-Received: by 2002:aa7:d382:: with SMTP id x2mr30236903edq.108.1600290902380;
        Wed, 16 Sep 2020 14:15:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f10sm15330497edk.34.2020.09.16.14.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:15:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 70419183A90; Wed, 16 Sep 2020 23:15:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 5/8] bpf: Fix context type resolving for
 extension programs
In-Reply-To: <CAEf4BzbqW12q_nXvat6=iTvKpy1P+e-r0N+9eY3vgDAZ8rcfLQ@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006242.98230.15812695975228745782.stgit@toke.dk>
 <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
 <CAEf4BzbqW12q_nXvat6=iTvKpy1P+e-r0N+9eY3vgDAZ8rcfLQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:15:01 +0200
Message-ID: <87o8m5pgoa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 16, 2020 at 12:59 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
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
>> > This version of the patch is tweaked slightly from Jiri's original one,
>> > since the refactoring in the previous patches means we have to get the
>> > target prog type from the new variable in prog->aux instead of directly
>> > from the target prog.
>> >
>> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
>> > Suggested-by: Jiri Olsa <jolsa@kernel.org>
>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > ---
>> >  kernel/bpf/btf.c |    9 ++++++++-
>> >  1 file changed, 8 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> > index 9228af9917a8..55f7b2ba1cbd 100644
>> > --- a/kernel/bpf/btf.c
>> > +++ b/kernel/bpf/btf.c
>> > @@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum bpf=
_access_type type,
>> >
>> >         info->reg_type =3D PTR_TO_BTF_ID;
>> >         if (tgt_prog) {
>> > -               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog=
->type, arg);
>> > +               enum bpf_prog_type tgt_type;
>> > +
>> > +               if (tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
>> > +                       tgt_type =3D tgt_prog->aux->tgt_prog_type;
>>
>> what if tgt_prog->aux->tgt_prog_type is also BPF_PROG_TYPE_EXT? Should
>> this be a loop?
>
> ok, never mind this specifically. there is an explicit check
>
> if (tgt_prog->type =3D=3D prog->type) {
>     verbose(env, "Cannot recursively attach\n");
>     return -EINVAL;
> }
>
> that will prevent this.
>
> But, I think we still will be able to construct a long chain of
> fmod_ret -> freplace -> fmod_ret -> freplace -> and so on ad
> infinitum. Can you please construct such a selftest? And then we
> should probably fix those checks to also disallow FMOD_RET, in
> addition to BPF_TRACE_FENTRY/FEXIT

Sure, can do!

-Toke

