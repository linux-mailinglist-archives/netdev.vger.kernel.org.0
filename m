Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA84277C49
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIXXT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:19:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgIXXT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:19:28 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600989567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNPW4CacsR/3OUSIFotWqGTYpLOGz4JMPt8HrL5jRII=;
        b=U7p/DdFRx77b73PXxVGSuTtcpvDBUcPYTNSaR9+J9lzJ1evDIsUAKfobhDRt/OlIo7xB8f
        HhOJ5XFUvbG0hihFkXecjDLHUEXWo7NqK1XyIr6V3LwYRyiyZhveI76ZcamEt52jqPTLkg
        mJc/famn21OZZNQXc2N5D2iXH24ZwDw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-RpK7Q9KBNk2_NZaA6E8CwA-1; Thu, 24 Sep 2020 19:19:25 -0400
X-MC-Unique: RpK7Q9KBNk2_NZaA6E8CwA-1
Received: by mail-ej1-f69.google.com with SMTP id w10so294601ejq.11
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DNPW4CacsR/3OUSIFotWqGTYpLOGz4JMPt8HrL5jRII=;
        b=k9u97K+GJ8vMHfnavNtxoJ+OBeV97udpKcg/aCmnemreZeJ17gv7zw0onPjYWGFfAc
         1LXp+OToHsUPYRo/rN1gZ0ncum+0a/XPkwhw5WFBb/lCN6Du5RP8u7Q0Nl32CSJT5eGn
         XaD9WGCl6u4tFRFFEuk1HKCnSnKfZY4wWDVvYLV+u0+zfOQiZYFCozxgeZIv42g5UD6a
         d+VGowuopDspC7y/d4al34+c2ESOhvrpOyMuHjQQzu1M/Cf7WM9rlWWDnkq7IadZPefl
         /BET+9OjrWtCjfQI+aPvPlvOi42HFN2TmFZnLzYLtSF40tBiXznhUZ66Qd3rT8w7zpuU
         1WFw==
X-Gm-Message-State: AOAM53296f4PnkqgVeAocBBhN7xa+K0SBikNj0SyBm/EHw0Q7vXR388y
        2U3PLsi1Hu50LOeDLq6FYxRqI3nZ/dmGgEU4PUofijad45HgqymBSijZv8vk+i3CZigGQyK1t7t
        8VjEDLzZElvB6S4IS
X-Received: by 2002:a17:906:d7a2:: with SMTP id pk2mr930378ejb.149.1600989563651;
        Thu, 24 Sep 2020 16:19:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRPzLYZqA3W0RqOUAbJgzs97HZF8iRKMZEHFdm4unyfyEgpyNZoC6GwLfgZLdmBmaJt6Q8QA==
X-Received: by 2002:a17:906:d7a2:: with SMTP id pk2mr930363ejb.149.1600989563459;
        Thu, 24 Sep 2020 16:19:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l26sm589756ejr.78.2020.09.24.16.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 16:19:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6FA91183A90; Fri, 25 Sep 2020 01:19:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH bpf-next v8 11/11] selftests: Remove fmod_ret from
 benchmarks and test_overhead
In-Reply-To: <CAEf4BzZ8f9osvJ3CD7kL4-SmdH9v_EQ73A9c=oGOBgeTziiFzw@mail.gmail.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079992560.8301.11225602391403157558.stgit@toke.dk>
 <20200924010811.kwrkzdzh6za3w3fz@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZ8f9osvJ3CD7kL4-SmdH9v_EQ73A9c=oGOBgeTziiFzw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Sep 2020 01:19:22 +0200
Message-ID: <87k0wibw5h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 23, 2020 at 6:08 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Tue, Sep 22, 2020 at 08:38:45PM +0200, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > -const struct bench bench_trig_fmodret =3D {
>> > -     .name =3D "trig-fmodret",
>> > -     .validate =3D trigger_validate,
>> > -     .setup =3D trigger_fmodret_setup,
>> > -     .producer_thread =3D trigger_producer,
>> > -     .consumer_thread =3D trigger_consumer,
>> > -     .measure =3D trigger_measure,
>> > -     .report_progress =3D hits_drops_report_progress,
>> > -     .report_final =3D hits_drops_report_final,
>> > -};
>> > diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools=
/testing/selftests/bpf/progs/trigger_bench.c
>> > index 9a4d09590b3d..1af23ac0c37c 100644
>> > --- a/tools/testing/selftests/bpf/progs/trigger_bench.c
>> > +++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
>> > @@ -45,10 +45,3 @@ int bench_trigger_fentry_sleep(void *ctx)
>> >       __sync_add_and_fetch(&hits, 1);
>> >       return 0;
>> >  }
>> > -
>> > -SEC("fmod_ret/__x64_sys_getpgid")
>> > -int bench_trigger_fmodret(void *ctx)
>> > -{
>> > -     __sync_add_and_fetch(&hits, 1);
>> > -     return -22;
>> > -}
>>
>> why are you removing this? There is no problem here.
>> All syscalls are error-injectable.
>> I'm surprised Andrii acked this :(
>
> Andrii didn't know that all syscalls are error-injectable, thanks for
> catching :) after fmod_ret/__set_task_comm I just assumed that I've
> been abusing fmod_ret all this time...

I didn't know that either. Shall I just drop your ACK from the next
version so you can take another look?

-Toke

