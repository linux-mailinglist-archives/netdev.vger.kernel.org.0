Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28603471545
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhLKSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:07:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhLKSH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639246077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxsp9HMeNtoKt/pFNzallH86Zw4trkvvgTKYXFAZ8jg=;
        b=ODSdNLT2scP2MjK2e/nOXfPcJDDvY6uWsupdHrYDdAsMzPolZT7YxMYGNBhiw7x7wXVIsR
        c+e4lgBu3E9Tl+adF3+aFF333Cvw28Ye7YQT8+bAurzp4bAokb9ywkiBYWzlT5dx4xlDuj
        rlku7GxIYq5kEr+/yN73NbyWag/RAvo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-EGo6WKT1N8O7gCXPmIyK1w-1; Sat, 11 Dec 2021 13:07:56 -0500
X-MC-Unique: EGo6WKT1N8O7gCXPmIyK1w-1
Received: by mail-ed1-f70.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso10773191edb.11
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fxsp9HMeNtoKt/pFNzallH86Zw4trkvvgTKYXFAZ8jg=;
        b=LfwDbesYhmNYtNJQA/vI7LDREWRftXmOfB4h+KL3KNJhZMwrcJKkye09SZW/0UgzRF
         N2JbYJF1ocsr7ty2yOc7l1IX3dmg/c+QZILiijsqW+dMxNp2g2nRwgIkGFV9xzi6E/WT
         3veuvOHjQMPKb+ocdhJwUOqW4S0vl6/KaaplM7dIJrqZPqaO6mO5TxYy0geqQYEPtsB+
         m4gsobqE8tR9DolH/4hthlsgH1bJuW31JB/Ju3UpvL7N0VuAxdonUz95FhdirbzEshwW
         tGGNgqk1EHTsVr+4QW5+gRuV26GTW0dbL49JgKL4Vq//5V5gfCYHJRlXywTOTkS7hrKK
         WQHA==
X-Gm-Message-State: AOAM530dsy/gfEtUuD/6I81qCCR7ET9qpp//NV7WStjLFI8f3xFh2d1f
        Au/9pb/bUI7KSdD+8DEMveR8oF/9uCI6FMGOP6450t8l5vQDxAn723f2rwpAsekSDe0LY5zB3dn
        w5W5tyki0viblx9pr
X-Received: by 2002:a05:6402:42d5:: with SMTP id i21mr48825314edc.373.1639246074180;
        Sat, 11 Dec 2021 10:07:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmtuRu9IIGsJRm7VLPbqM73bHk2TxaMBH4XL764mJtXwub90GMZUqJA6TwherwcvopC10EVA==
X-Received: by 2002:a05:6402:42d5:: with SMTP id i21mr48825147edc.373.1639246072480;
        Sat, 11 Dec 2021 10:07:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id go10sm3302346ejc.115.2021.12.11.10.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:07:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 266C3180471; Sat, 11 Dec 2021 19:07:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yihao Han <hanyihao@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
Subject: Re: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
In-Reply-To: <CAEf4Bza3a88pdhFEQdR-FnT_gBPqBh+KL-OP-1P3bVfXv=Gbaw@mail.gmail.com>
References: <20211209092250.56430-1-hanyihao@vivo.com>
 <877dccwn6x.fsf@toke.dk>
 <CAEf4Bza3a88pdhFEQdR-FnT_gBPqBh+KL-OP-1P3bVfXv=Gbaw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 11 Dec 2021 19:07:48 +0100
Message-ID: <87sfuzuia3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Dec 10, 2021 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Yihao Han <hanyihao@vivo.com> writes:
>>
>> > Fix following swap.cocci warning:
>> > ./samples/bpf/xdpsock_user.c:528:22-23:
>> > WARNING opportunity for swap()
>> >
>> > Signed-off-by: Yihao Han <hanyihao@vivo.com>
>>
>> Erm, did this get applied without anyone actually trying to compile
>> samples? I'm getting build errors as:
>
> Good news: I actually do build samples/bpf nowadays after fixing a
> bunch of compilation issues recently.

Awesome!

> Bad news: seems like I didn't pay too much attention after building
> samples/bpf for this particular patch, sorry about that. I've dropped
> this patch, samples/bpf builds for me. We should be good now.

Yup, looks good, thanks!

>>   CC  /home/build/linux/samples/bpf/xsk_fwd.o
>> /home/build/linux/samples/bpf/xsk_fwd.c: In function =E2=80=98swap_mac_a=
ddresses=E2=80=99:
>> /home/build/linux/samples/bpf/xsk_fwd.c:658:9: warning: implicit declara=
tion of function =E2=80=98swap=E2=80=99; did you mean =E2=80=98swab=E2=80=
=99? [-Wimplicit-function-declaration]
>>   658 |         swap(*src_addr, *dst_addr);
>>       |         ^~~~
>>       |         swab
>>
>> /usr/bin/ld: /home/build/linux/samples/bpf/xsk_fwd.o: in function `threa=
d_func':
>> xsk_fwd.c:(.text+0x440): undefined reference to `swap'
>> collect2: error: ld returned 1 exit status
>>
>>
>> Could we maybe get samples/bpf added to the BPF CI builds? :)
>
> Maybe we could, if someone dedicated their effort towards making this
> happen.

Is it documented anywhere what that would entail? Is it just a matter of
submitting a change to https://github.com/kernel-patches/vmtest ?

-Toke

