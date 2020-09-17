Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C0B26E1E2
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgIQRLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726869AbgIQRKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600362615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wf8IYfdeEaF78aSM8tBZfvphb1ayyOQx+nDx2abMWek=;
        b=Xl60Xt0XcpKlaCdoUhNttTSZWSHfx/CGEbrVXBHzTs1f/Xfg1hhqqL9FJAJQi5OswzS2Gh
        wGFU90XxcJbrwMciHTyhknhvQQTv9XhOLTwbmsxZbwU5ZnHVd4aoSTmVecD5a0S0X8CrEI
        V4oubnEgJ/aO27Bfo7dqIKQgzoadA4A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-BclDn3j_O0Om9SK3_vVSjQ-1; Thu, 17 Sep 2020 13:10:13 -0400
X-MC-Unique: BclDn3j_O0Om9SK3_vVSjQ-1
Received: by mail-ed1-f70.google.com with SMTP id b12so1173248edw.15
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wf8IYfdeEaF78aSM8tBZfvphb1ayyOQx+nDx2abMWek=;
        b=rpG+GPXMWngmOEn3OJueVXBRUuV5QrLkhLcdYvBoE/Y3YKJz1zAPyer2D5sJyoH8Cr
         MElqWQQ+RYjmO1GS9Qwxoo44RXUdJjbZKNZoZrc2NMY4gjmXWyubjIM/8fcjFS+0GWrP
         55YWjC3IVvxDfdHUj3JX6I5LgtrwY+Pqo+iBa2S/ocjw2x++J/ICMQsJP7WeFPHZUQXK
         MHzVYzb5iIC4MUqbEGRSyfUPiE3ziTzgQFejuKxvG/Zo4FaTHR/wF79sh+OBszZ5xkAX
         PKurM9OprFuhW8Ps72wXBih7HW9JGmxhHeP7HRzBUEZYtq7DxCD4r2+X2j/kitXEraJ9
         vadg==
X-Gm-Message-State: AOAM532HMCYy1WM2c6FPv62YHMGPa8GGrMl6nE2IZJ/YaBrdEzpYsVkL
        T8qmYaxElitBk6yddstHMez+enhHdJLb4eHPwni3ctcOWRoWNXh3QOJnNkaLuQoQNUy/+b1UWl4
        dsbgHs9rd+/8K1BrL
X-Received: by 2002:a17:906:1b15:: with SMTP id o21mr31167737ejg.377.1600362612222;
        Thu, 17 Sep 2020 10:10:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCxAGa1NA+Umya4kwMFXeto8E8QJODFAZIpo+oZIWr2e1Nd5IR/SzvyZ4x0lotesFbC1/E/A==
X-Received: by 2002:a17:906:1b15:: with SMTP id o21mr31167695ejg.377.1600362611814;
        Thu, 17 Sep 2020 10:10:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e25sm203857edj.43.2020.09.17.10.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:10:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A1ACE183A90; Thu, 17 Sep 2020 19:10:10 +0200 (CEST)
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
Date:   Thu, 17 Sep 2020 19:10:10 +0200
Message-ID: <87tuvwmirx.fsf@toke.dk>
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
> addition to BPF_TRACE_FENTRY/FEXIT (and someone more familiar with LSM
> prog type should check if that can cause any problems).

Huh, I thought fmod_ret was supposed to be for kernel functions only?
However, I can't really point to anywhere in the code that ensures this,
other than check_attach_modify_return(), but I think that will allow a
bpf function as long as its name starts with "security_" ?

Is there actually any use case for modify_return being attached to a BPF
function (you could just use freplace instead, couldn't you?). Or should
we just disallow that entirely (if I'm not missing somewhere it's
already blocked)?

-Toke

