Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D956F26E453
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIQSpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbgIQSoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600368245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCECRd4lgnaJhz1iERz1/t0h7+gp4yFPcWLx1Dp1rE0=;
        b=JY6+1AFSna3lVztPBCtzowtI6R8pIoVyE/pdURcfv0rMopH4KJVSvQgyKFWY7mefnrpvJ3
        hpygwQrR6cNrdkSoajIoBZXUNLMnhTc2WCqnjeaPWLdkjpGaegk7cD4zIAecnXoLaIjrF3
        +gpjaahrs6wW+av1bRty70GHuzO1GvM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-2JJT72kFPmiGzirjmV7EXw-1; Thu, 17 Sep 2020 14:44:03 -0400
X-MC-Unique: 2JJT72kFPmiGzirjmV7EXw-1
Received: by mail-wm1-f69.google.com with SMTP id l15so1065833wmh.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 11:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pCECRd4lgnaJhz1iERz1/t0h7+gp4yFPcWLx1Dp1rE0=;
        b=HYNQvOc3EzXaR/Di9S7+MvOSrktQ8jNv7nVoPS7j9LA/xwZn9vqy1LIbGWyrMpX7Xg
         3Fei3iB/fNVGyWKzTJ4IzPGII7K2esCKKuIez93kFo0QMOnqhS8jSfYC4DTbwJTXZajF
         b0lj5sZ+14MI0URdz2+sb11wbIDIr6K1vKhgRCj9/iap9kMYce9X9gqG5QtpT2wMa1IJ
         5+IvESPNducTadVq06jP+V6qvT9OCBKzp4OGmlm97MLEWbuVQoCmT3es/7GnSDkODfHj
         mwPSNJmPU5FBHjtZ5Wrf4ES7HqMBMMSqvJzOfSveqcZ9Ov2xyvNAz+q9ibS58h79//rN
         +pnA==
X-Gm-Message-State: AOAM531z22aqHVNc37jeMYtg1iaZkncqt2mN1x0QyudG+yd+oQa6u4SY
        wl8jIehyb7gUMmgSDdZFlDaY9VXAY/Ica7kWLju5mOyljYXjxqUCCHwsynyOff5nE/pk1LNWg3B
        IPNlArk9tKLHVorTX
X-Received: by 2002:a5d:4d01:: with SMTP id z1mr33434314wrt.366.1600368242406;
        Thu, 17 Sep 2020 11:44:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy63uex8dYi+B/9T30ZpHD19gXQ7fN3b8VdW5GsKYcE8aIMdpvCtcYybdCwme+76rvAR3zHgQ==
X-Received: by 2002:a5d:4d01:: with SMTP id z1mr33434290wrt.366.1600368242149;
        Thu, 17 Sep 2020 11:44:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b18sm694611wrn.21.2020.09.17.11.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 11:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E72D4183A90; Thu, 17 Sep 2020 20:44:00 +0200 (CEST)
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
In-Reply-To: <CAEf4BzZkaViCyJnnJtSVjN2q7aD1SgEOqKKmy5m+1icWd3B72Q@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006242.98230.15812695975228745782.stgit@toke.dk>
 <CAEf4Bzafmu5w6wjWT_d0B-JaUnm3KOf0Dgp+552iZii2+=3DWg@mail.gmail.com>
 <CAEf4BzbqW12q_nXvat6=iTvKpy1P+e-r0N+9eY3vgDAZ8rcfLQ@mail.gmail.com>
 <87tuvwmirx.fsf@toke.dk>
 <CAEf4BzZkaViCyJnnJtSVjN2q7aD1SgEOqKKmy5m+1icWd3B72Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Sep 2020 20:44:00 +0200
Message-ID: <87o8m4fdlb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Sep 17, 2020 at 10:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Wed, Sep 16, 2020 at 12:59 PM Andrii Nakryiko
>> > <andrii.nakryiko@gmail.com> wrote:
>> >>
>> >> On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >> >
>> >> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >
>> >> > Eelco reported we can't properly access arguments if the tracing
>> >> > program is attached to extension program.
>> >> >
>> >> > Having following program:
>> >> >
>> >> >   SEC("classifier/test_pkt_md_access")
>> >> >   int test_pkt_md_access(struct __sk_buff *skb)
>> >> >
>> >> > with its extension:
>> >> >
>> >> >   SEC("freplace/test_pkt_md_access")
>> >> >   int test_pkt_md_access_new(struct __sk_buff *skb)
>> >> >
>> >> > and tracing that extension with:
>> >> >
>> >> >   SEC("fentry/test_pkt_md_access_new")
>> >> >   int BPF_PROG(fentry, struct sk_buff *skb)
>> >> >
>> >> > It's not possible to access skb argument in the fentry program,
>> >> > with following error from verifier:
>> >> >
>> >> >   ; int BPF_PROG(fentry, struct sk_buff *skb)
>> >> >   0: (79) r1 =3D *(u64 *)(r1 +0)
>> >> >   invalid bpf_context access off=3D0 size=3D8
>> >> >
>> >> > The problem is that btf_ctx_access gets the context type for the
>> >> > traced program, which is in this case the extension.
>> >> >
>> >> > But when we trace extension program, we want to get the context
>> >> > type of the program that the extension is attached to, so we can
>> >> > access the argument properly in the trace program.
>> >> >
>> >> > This version of the patch is tweaked slightly from Jiri's original =
one,
>> >> > since the refactoring in the previous patches means we have to get =
the
>> >> > target prog type from the new variable in prog->aux instead of dire=
ctly
>> >> > from the target prog.
>> >> >
>> >> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
>> >> > Suggested-by: Jiri Olsa <jolsa@kernel.org>
>> >> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> > ---
>> >> >  kernel/bpf/btf.c |    9 ++++++++-
>> >> >  1 file changed, 8 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> >> > index 9228af9917a8..55f7b2ba1cbd 100644
>> >> > --- a/kernel/bpf/btf.c
>> >> > +++ b/kernel/bpf/btf.c
>> >> > @@ -3860,7 +3860,14 @@ bool btf_ctx_access(int off, int size, enum =
bpf_access_type type,
>> >> >
>> >> >         info->reg_type =3D PTR_TO_BTF_ID;
>> >> >         if (tgt_prog) {
>> >> > -               ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_p=
rog->type, arg);
>> >> > +               enum bpf_prog_type tgt_type;
>> >> > +
>> >> > +               if (tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
>> >> > +                       tgt_type =3D tgt_prog->aux->tgt_prog_type;
>> >>
>> >> what if tgt_prog->aux->tgt_prog_type is also BPF_PROG_TYPE_EXT? Should
>> >> this be a loop?
>> >
>> > ok, never mind this specifically. there is an explicit check
>> >
>> > if (tgt_prog->type =3D=3D prog->type) {
>> >     verbose(env, "Cannot recursively attach\n");
>> >     return -EINVAL;
>> > }
>> >
>> > that will prevent this.
>> >
>> > But, I think we still will be able to construct a long chain of
>> > fmod_ret -> freplace -> fmod_ret -> freplace -> and so on ad
>> > infinitum. Can you please construct such a selftest? And then we
>> > should probably fix those checks to also disallow FMOD_RET, in
>> > addition to BPF_TRACE_FENTRY/FEXIT (and someone more familiar with LSM
>> > prog type should check if that can cause any problems).
>>
>> Huh, I thought fmod_ret was supposed to be for kernel functions only?
>
> Yeah, I realized that afterwards, but didn't want to ramble on forever :)
>
>> However, I can't really point to anywhere in the code that ensures this,
>> other than check_attach_modify_return(), but I think that will allow a
>> bpf function as long as its name starts with "security_" ?
>
> I think error_injection_list check will disallow anything that's not a
> specially marked kernel function. So we are probably safe as is, even
> though a bit implicitly.

Got a selftest working now, and no, it seems not. At least attachment
will succeed if the freplace program has a security_ prefix in its
function name. So will add a new patch to fix that, and the selftest :)

-Toke

