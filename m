Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A39472BFC
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhLMMJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:09:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230370AbhLMMJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639397382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1a/bd6+FuUOJG/H4wd0T2lOdNMz9aPxRtEUk/VcsT3Y=;
        b=ZhJU0Pc8VLMiSNIrHUcmVuIxyj8UPhYtON5X0u65dECNJfNPUDcmzisoRu4NVw1RljmSSL
        zp8PmktZMBywD2PEX6it/YF1TKYy1bjHkSZ8c5oNf3aOC8dJTO6zhassSbp957JUoIYx+T
        JksyEXPgYha4lUGUKJ0H3zf0gkyDGQQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-559-RvOx69aRNuuxLYhFwS1Puw-1; Mon, 13 Dec 2021 07:09:41 -0500
X-MC-Unique: RvOx69aRNuuxLYhFwS1Puw-1
Received: by mail-qv1-f71.google.com with SMTP id jn10-20020ad45dea000000b003bd74c93df4so23553950qvb.15
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1a/bd6+FuUOJG/H4wd0T2lOdNMz9aPxRtEUk/VcsT3Y=;
        b=b8sOQw9pZlpzBh7ntDQWjc5enZcpv6xvnYTIG4VW9D3r/KfVct0pDX/L7/NF5eDKAz
         ZS4XoxMrYx/N9B+Pjp7z/Yq14MzYIXDKrxY9d2okv0cCnSFcWMOV9AFOQ4yOLY7SzmNP
         jStLS/mpw/LovQ8flXz/E7ug7btXVIuA9/Dffz5FW8TM2dpBX/hUWyZNhwbqLUuyby7H
         wwzaG1Ib9jTdWXRY3YrGjMdlO+xUilnsMnDBS0IIDpXx6W+jMJyKceCKiseLFCEv7kUy
         17+sOzV9zPtesZAXvXKN8coPmsJkWmiNbGfYxRem6c0pxHqUKsbGe7qGbFdJY0MBJ9bv
         ob6w==
X-Gm-Message-State: AOAM531ZwlkT54S1I0Y1H8NF0lSZgfK8ZTh1sf/H2uodt7we1tUj2k47
        horVeY7lbtK9c3+FPKaSvBxKaYN7ipY4wgpoTu5XcYD/UfIaze5M/S5jFzmady6p5W0L60QxcfW
        swkL/H6rLkrDPaHa/
X-Received: by 2002:a05:620a:1904:: with SMTP id bj4mr32164875qkb.536.1639397380551;
        Mon, 13 Dec 2021 04:09:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUMjea4dS/GuZs2NBiHsvdQKAl1msbX4jKzb27GUcYuJ0+s3SA6OeCnzyR+/7myLc0P/iXYw==
X-Received: by 2002:a05:620a:1904:: with SMTP id bj4mr32164837qkb.536.1639397380127;
        Mon, 13 Dec 2021 04:09:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n13sm6194857qkp.19.2021.12.13.04.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 04:09:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 845DC180496; Mon, 13 Dec 2021 13:09:35 +0100 (CET)
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
In-Reply-To: <CAEf4BzYv3ONhy-JnQUtknzgBSK0gpm9GBJYtbAiJQe50_eX7Uw@mail.gmail.com>
References: <20211209092250.56430-1-hanyihao@vivo.com>
 <877dccwn6x.fsf@toke.dk>
 <CAEf4Bza3a88pdhFEQdR-FnT_gBPqBh+KL-OP-1P3bVfXv=Gbaw@mail.gmail.com>
 <87sfuzuia3.fsf@toke.dk>
 <CAEf4BzYv3ONhy-JnQUtknzgBSK0gpm9GBJYtbAiJQe50_eX7Uw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 13 Dec 2021 13:09:35 +0100
Message-ID: <87fsqwg0zk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Dec 11, 2021 at 10:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Dec 10, 2021 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Yihao Han <hanyihao@vivo.com> writes:
>> >>
>> >> > Fix following swap.cocci warning:
>> >> > ./samples/bpf/xdpsock_user.c:528:22-23:
>> >> > WARNING opportunity for swap()
>> >> >
>> >> > Signed-off-by: Yihao Han <hanyihao@vivo.com>
>> >>
>> >> Erm, did this get applied without anyone actually trying to compile
>> >> samples? I'm getting build errors as:
>> >
>> > Good news: I actually do build samples/bpf nowadays after fixing a
>> > bunch of compilation issues recently.
>>
>> Awesome!
>>
>> > Bad news: seems like I didn't pay too much attention after building
>> > samples/bpf for this particular patch, sorry about that. I've dropped
>> > this patch, samples/bpf builds for me. We should be good now.
>>
>> Yup, looks good, thanks!
>>
>> >>   CC  /home/build/linux/samples/bpf/xsk_fwd.o
>> >> /home/build/linux/samples/bpf/xsk_fwd.c: In function =E2=80=98swap_ma=
c_addresses=E2=80=99:
>> >> /home/build/linux/samples/bpf/xsk_fwd.c:658:9: warning: implicit decl=
aration of function =E2=80=98swap=E2=80=99; did you mean =E2=80=98swab=E2=
=80=99? [-Wimplicit-function-declaration]
>> >>   658 |         swap(*src_addr, *dst_addr);
>> >>       |         ^~~~
>> >>       |         swab
>> >>
>> >> /usr/bin/ld: /home/build/linux/samples/bpf/xsk_fwd.o: in function `th=
read_func':
>> >> xsk_fwd.c:(.text+0x440): undefined reference to `swap'
>> >> collect2: error: ld returned 1 exit status
>> >>
>> >>
>> >> Could we maybe get samples/bpf added to the BPF CI builds? :)
>> >
>> > Maybe we could, if someone dedicated their effort towards making this
>> > happen.
>>
>> Is it documented anywhere what that would entail? Is it just a matter of
>> submitting a change to https://github.com/kernel-patches/vmtest ?
>
> I think the right way would be to build samples/bpf from
> selftests/bpf's Makefile. At the very least we should not require make
> headers_install (I never understood that with samples/bpf, all those
> up-to-date UAPI headers are right there in the same repo). Once that
> is done, at the very least we'll build tests samples/bpf during CI
> runs.

Alright, sounds fair. I'll look into that, but probably before the
holidays :)

-Toke

