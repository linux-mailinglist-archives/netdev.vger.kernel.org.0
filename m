Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62BF59EA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731127AbfKHVcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:32:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730009AbfKHVcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573248735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAF6j0a+V/9BFfwv/2EgMhHlMLkaM6wfXE6fGRZ+mgs=;
        b=FeXLI/IkvCIc/ELbzEZKebtqfrhw01sHCyCZb17l5+tefv1K3uCzubiwZihAt9MZzZXXB7
        MdyXkMnPoeP9Ym2iaP4B16cgDQqMOIcoHT2S+p3KDjzWPsfwILywsBtSPtg3P95gVvqvjX
        eInw5evDKhLdEoWQFxIl2qc19gS/pBc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-FsxUppBoML2Gqi3ih-089g-1; Fri, 08 Nov 2019 16:32:14 -0500
Received: by mail-lf1-f71.google.com with SMTP id i25so8763lfo.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:32:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hAF6j0a+V/9BFfwv/2EgMhHlMLkaM6wfXE6fGRZ+mgs=;
        b=L3b5H2bimrFn5sBiURpqTHC0qVgAaFizfDA8kRxGCjpWDKZcE5eMe+qMwqx50REWs8
         zIUda+c+NCjBcQukhqrN5+ejxkZAqVPWEb0SPGMSqbwWbBcOhjKr5oQTyqjmhKr83ppP
         KMq81S+ExDMqKKBr+nBuKR4KIMscwO/M8K1w6LN2pClRhJ4G+Ma2P6giKezOdmQxWNsX
         0UsMr/gb+t3KQza6fP9I8z6wY7by+qbZe3TD97K542mw6k06gK8Ko/hRgnO66YoPqtqX
         VWHACr9sHuR/P3rjTiAuFjfjmGTfpCl6HUKkQ6Yh5f5lh5uTJnWIXoauYboMMt0tuW1D
         /PnQ==
X-Gm-Message-State: APjAAAVWZdAnzdNycDF5PjqNt3H2x30GMsIY451IngdvvnD1iN3wysa4
        kwQz8Z/T8eP5hsB7NOJadmWWKbB9jrZApyEalQiD7JhenhidjvwUrjSpVTzD/NGhO3GeNPcDHfZ
        6TsGmQ/lG3E9F9lFk
X-Received: by 2002:ac2:5236:: with SMTP id i22mr311473lfl.19.1573248732809;
        Fri, 08 Nov 2019 13:32:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfDxNQc/NKvD3Zy3CPyWE6esJ1059V8jFnFmTBhucKpQzRjpt8AY+n1tvyZ3aT1YoZ/wahEQ==
X-Received: by 2002:ac2:5236:: with SMTP id i22mr311462lfl.19.1573248732596;
        Fri, 08 Nov 2019 13:32:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a8sm3391806ljf.47.2019.11.08.13.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:32:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9174A1800BD; Fri,  8 Nov 2019 22:32:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF program to other BPF programs
In-Reply-To: <20191108211400.m6kuuyvkp2p56gmo@ast-mbp.dhcp.thefacebook.com>
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-16-ast@kernel.org> <87pni2ced3.fsf@toke.dk> <20191108211400.m6kuuyvkp2p56gmo@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 08 Nov 2019 22:32:10 +0100
Message-ID: <87mud6caw5.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: FsxUppBoML2Gqi3ih-089g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Nov 08, 2019 at 09:17:12PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <ast@kernel.org> writes:
>>=20
>> > Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any=
 type
>> > including their subprograms. This feature allows snooping on input and=
 output
>> > packets in XDP, TC programs including their return values. In order to=
 do that
>> > the verifier needs to track types not only of vmlinux, but types of ot=
her BPF
>> > programs as well. The verifier also needs to translate uapi/linux/bpf.=
h types
>> > used by networking programs into kernel internal BTF types used by FEN=
TRY/FEXIT
>> > BPF programs. In some cases LLVM optimizations can remove arguments fr=
om BPF
>> > subprograms without adjusting BTF info that LLVM backend knows. When B=
TF info
>> > disagrees with actual types that the verifiers sees the BPF trampoline=
 has to
>> > fallback to conservative and treat all arguments as u64. The FENTRY/FE=
XIT
>> > program can still attach to such subprograms, but won't be able to rec=
ognize
>> > pointer types like 'struct sk_buff *' into won't be able to pass them =
to
>> > bpf_skb_output() for dumping to user space.
>> >
>> > The BPF_PROG_LOAD command is extended with attach_prog_fd field. When =
it's set
>> > to zero the attach_btf_id is one vmlinux BTF type ids. When attach_pro=
g_fd
>> > points to previously loaded BPF program the attach_btf_id is BTF type =
id of
>> > main function or one of its subprograms.
>> >
>> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>=20
>> This is cool! Certainly solves the xdpdump use case; thanks!
>>=20
>> I do have a few questions (thinking about whether it can also be used
>> for running multiple XDP programs):
>
> excellent questions.
>
>> - Can a FEXIT function loaded this way only *observe* the return code of
>>   the BPF program it attaches to, or can it also change it?
>
> yes. the verifier can be taught to support that for certain class of prog=
rams.
> That needs careful thinking to make sure it's safe.

OK. I think this could potentially be useful to have for XDP (for
instance, to have xdpdump "steal" any packets it is observing by
changing the return code to XDP_DROP).

>> - Is it possible to attach multiple FENTRY/FEXIT programs to the same
>>   XDP program=20
>
> Yes. Already possible. See fexit_stress.c that attaches 40 progs to the s=
ame
> kernel function. Same thing when attaching fexit BPF to any XDP program.
> Since all of them are read only tracing prog all progs have access to skb=
 on
> input and ouput along with unmodified return value.

Right, cool.

>> and/or to recursively attach FENTRY/FEXIT programs to each
>>   other?
>
> Not right now to avoid complex logic of detecting cycles. See simple bit:
>    if (tgt_prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
>            /* prevent cycles */
>            verbose(env, "Cannot recursively attach\n");

OK, that is probably a reasonable tradeoff.

>> - Could it be possible for an FENTRY/FEXIT program to call into another
>>   XDP program (i.e., one that has the regular XDP program type)?
>
> It's possible to teach verifier to do that, but we probably shouldn't tak=
e that
> route. Instead I've started exploring the idea of dynamic linking. The
> trampoline logic will be used to replace existing BPF program or subprogr=
am
> instead of attaching read-only to it. If types match the new program can
> replace existing one. The concept allows to build any kind of callchain
> programmatically. Pretty much what Ed proposed with static linking, but d=
oing
> it dynamically. I'll start a separate email thread explaining details.

SGTM; will wait for the sequel, then :)

-Toke

