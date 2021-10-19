Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE6433BC6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhJSQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhJSQM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634659846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XmXGGi2dblSuJkjJokwS1Y/EYujNuYOQOkVrKKsVabA=;
        b=hBAweZw4UZ5tjjHjd5tTturoQbAXLm6fQ4cAM43khhHF7fxdW0dXL4Fu7d3OJbHP5H3OHz
        HtAGddCqub7NmkVSf7xmy2lYL6r2cLNKF0UyUxcviXIPKizlYB36sSgGPOlhWm5loo+eQa
        QtHN/weNrcvtLRSM9ISYcAWivAyMhAY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-LZhX2bu_M4qrGs44lnhHVg-1; Tue, 19 Oct 2021 12:10:43 -0400
X-MC-Unique: LZhX2bu_M4qrGs44lnhHVg-1
Received: by mail-ed1-f72.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so18070546edi.12
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 09:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XmXGGi2dblSuJkjJokwS1Y/EYujNuYOQOkVrKKsVabA=;
        b=FFtmKRsctB3p1J4bI7ZWj7JDiPGizYZGKmBUmbGpYR3P2mAMaEfZT/HoeD7D+Dh4P+
         263/5FWSHNn3OpqD8CVO+nK0gXUPXvq4ka5gkN7rudkMqoVCfHNSI0dzi/mB8ojA1+Sh
         J3KjoqK6MYqke2WbhrpfYAWDj3iicpGBsUuVZTwMCHP/tOFttvtbW93UbCh1r6WbyYi9
         IByZG55VTnnVT8HLEuZG6v6F3DFtkReMmREiDOKKxixKKtbftdEPexxTYAdU3Thhp5bg
         aMbAsxltnWXq8wWN3kNtO8CaLpm6F6+pCyrw9HN7D8ru/u1WKwtmNN/y4bZ5uaiqlqP5
         tRxw==
X-Gm-Message-State: AOAM531+8IQaHo5qcoY64joIdRRnMbwL1EFLitFp6y193+kLis4RN0UF
        l1fQHiNq9wU0RX7G8JafrcxiYjDz+MgvKKloFo3K7MtQvUVsSsw03ZPC1I71+Rzoshk7RyTp9VR
        Od0F+5LeTcEbZY6hN
X-Received: by 2002:a17:907:7f90:: with SMTP id qk16mr38753312ejc.26.1634659840632;
        Tue, 19 Oct 2021 09:10:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj2FeE2PnPSLojUuhOUcg5qb3HCcVNk2diu76Eq9w1NoHUozFEEMk8dIb2oEcZMW0nJR+Tzw==
X-Received: by 2002:a17:907:7f90:: with SMTP id qk16mr38753138ejc.26.1634659838938;
        Tue, 19 Oct 2021 09:10:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a4sm2541626edk.71.2021.10.19.09.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 09:10:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DA50B180263; Tue, 19 Oct 2021 18:10:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannekoong@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
In-Reply-To: <20211019000058.ghklvg4saybzqk3o@ast-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp> <87lf33jh04.fsf@toke.dk>
 <20211019000058.ghklvg4saybzqk3o@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Oct 2021 18:10:37 +0200
Message-ID: <874k9dgflu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>>=20
>> So if we can't fix the verifier, maybe we could come up with a more
>> general helper for packet parsing? Something like:
>>=20
>> bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
>> {
>>   ptr =3D ctx->data + offset;
>>   while (ptr < ctx->data_end) {
>>     offset =3D callback_fn(ptr, ctx->data_end, callback_arg);
>>     if (offset =3D=3D 0)
>>       return 0;
>>     ptr +=3D offset;
>>   }
>>=20=20=20
>>   // out of bounds before callback was done
>>   return -EINVAL;
>> }
>
> We're starting to work on this since it will be useful not only for
> packet parsing, TLV parsing, but potentially any kind of 'for' loop itera=
tion.

Awesome! :)

>> This would work for parsing any kind of packet header or TLV-style data
>> without having to teach the kernel about each header type. It'll have
>> quite a bit of overhead if all the callbacks happen via indirect calls,
>> but maybe the verifier can inline the calls (or at least turn them into
>> direct CALL instructions)?
>
> Right. That's the main downside.
> If the bpf_for_each*() helper is simple enough the verifier can inline it
> similar to map_gen_lookup. In such case the indirect call will be a direc=
t call,
> so the overhead won't be that bad, but it's still a function call and
> static function will have full prologue+epilogue.
> Converting static function into direct jump would be really challenging
> for the verifier and won't provide much benefit, since r6-r9 save/restore
> would need to happen anyway even for such 'inlined' static func, since
> llvm will be freely using r6-r9 for insns inside function body
> assuming that it's a normal function.

I reckon it could be acceptable to have the overhead of a regular
function call per iteration, but obviously it would be better to avoid
it.

> May be there is a way to avoid call overhead with with clang extensions.
> If we want to do:
> int mem_eq(char *p1, char *p2, int size)
> {
>   int i;
>   for (i =3D 0; i < size; i++)
>     if (p1[i] !=3D p2[i])
>       return 0;
>   return 1;
> }
>
> With clang extension we might write it as:
> int bpf_mem_eq(char *p1, char *p2, int size)
> {
>   int i =3D 0;
>   int iter;
>
>   iter =3D __builtin_for_until(i, size, ({
>       if (p1[i] !=3D p2[i])
>         goto out;
>   }));
>   out:
>   if (iter !=3D size)
>     return 0;
>   return 1;
> }
>
> The llvm will generate pseudo insns for this __builtin_for.
> The verifier will analyze the loop body for the range [0, size)
> and replace pseudo insns with normal branches after the verification.

That seems like an interesting approach! The __builtin_for thing is a
little awkward, but not more than turning the loop into a separate
function + callback.

What about backwards compatibility? Would you have to ensure your kernel
understands the loop instructions before you put them into your code, or
could libbpf be taught to rewrite them if the kernel doesn't understand
them (say, to a separate function that is called in a regular bounded
loop)?

> We might even keep the normal C syntax for loops and use
> llvm HardwareLoops pass to add pseudo insns.

Now *this* would be cool!

> It's more or less the same ideas for loops we discussed before
> bounded loops were introduced.

Why was it rejected at the time?

> The main problem with bounded loops is that the loop body will
> typically be verified the number of times equal to the number of iteratio=
ns.
> So for any non-trivial loop such iteration count is not much more
> than 100. The verifier can do scalar evolution analysis, but
> it's likely won't work for many cases and user experience
> will suffer. With __builtin_for the scalar evolution is not necessary,
> since induction variable is one and explicit and its range is explicit to=
o.
> That enables single pass over loop body.
> One might argue that for (i =3D 0; i < 10000; i +=3D 10) loops are
> necessary too, but instead of complicating the verifier with sparse
> ranges it's better to put that on users that can do:
>   iter =3D __builtin_for_until(i, 10000 / 10, ({
>       j =3D i * 10;
>       use j;
>   }));
> Single explicit induction variable makes the verification practical.
> The loop body won't be as heavily optimized as normal loop,
> but it's a good thing.

Agreed, limiting things to single-step loops would be acceptable.

-Toke

