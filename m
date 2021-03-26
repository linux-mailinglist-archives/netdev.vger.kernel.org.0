Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4F34A4CD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCZJnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:43:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhCZJnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616751819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yaPxAtTlYxw0i9BFM/qU8qS7O6tnfcWIERywcqe7zaM=;
        b=GNIVnXQjsxMexLnOcNiXeDYfp8Hs2gs1AKhIf0hEd2SEhD88esesBmIXhN8yok0vxWHuAl
        vzWCWQaTGsWjB+kVYthXY9XOm2AR249IRHh+z0ip9CUT0rYDd81movWowgLI4VKNSM2Sh2
        nEF9eE/OH60yM+NlFMBxKQ4QsIktOX4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-mYLy8v3sNVO9MuVqVVUfXA-1; Fri, 26 Mar 2021 05:43:37 -0400
X-MC-Unique: mYLy8v3sNVO9MuVqVVUfXA-1
Received: by mail-ed1-f71.google.com with SMTP id n20so4140852edr.8
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 02:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=yaPxAtTlYxw0i9BFM/qU8qS7O6tnfcWIERywcqe7zaM=;
        b=YAxHh0FY/zrU41a85hEfGUAz9oSR28TYXKzX2DK3Zvy9bxiJkXIHLwdHKKJTUppiYz
         09Ja6fh2wKG3I/nk+3mC/eMdMYaiEB7ZYaa6FdcVyeckAlTUIzGupOHoHWgGmL9Oh1fu
         Xk+92mXQ61BU6lOHb86VVWW8EE6lt5a7AT1MSAi3PyJqXXgodtS+tEq98scxKHXIRr0x
         y6/Kq5FDkGAidDcfw8vKYYFKAtKnHpV85ayw9rLDWu30dnzYofhKyNF72Yr5au8gQzQP
         JaW/3oGZKT437TnCfVBXHVCqKISMb93bm3wXKyFdFLa0fe51zxQwze+DS5TB8HH+ZeYF
         pbrg==
X-Gm-Message-State: AOAM532kWsWw7fEmU0YNN90rj11LZ3D9VRKUobdP6gTXcdxtG7h5cme8
        EwI1EdA9eNvSlsg7Wjt5DNbtuCxRHQPyJ0HX9+Win38xHZEnYju4XX37LIxEVlLyvEGQRv0p85Q
        DdaxyQe7Uea+A+9PN
X-Received: by 2002:aa7:c941:: with SMTP id h1mr13739171edt.85.1616751815563;
        Fri, 26 Mar 2021 02:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyW0egnm8sR6kaqK8lS5WUkeH6ar+nWajJS0DKxKFG/qcb37iNSYyisVn6OH1H2dwMXIserfQ==
X-Received: by 2002:aa7:c941:: with SMTP id h1mr13739140edt.85.1616751815208;
        Fri, 26 Mar 2021 02:43:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j1sm3600230ejt.18.2021.03.26.02.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 02:43:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1C1521801A3; Fri, 26 Mar 2021 10:43:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 2/2] bpf/selftests: test that kernel rejects a
 TCP CC with an invalid license
In-Reply-To: <CAEf4BzaxmrWFBJ1mzzWzu0yb_iFX528cAFVbXrncPEaJBXrd2A@mail.gmail.com>
References: <20210325211122.98620-1-toke@redhat.com>
 <20210325211122.98620-2-toke@redhat.com>
 <CAEf4BzaxmrWFBJ1mzzWzu0yb_iFX528cAFVbXrncPEaJBXrd2A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Mar 2021 10:43:34 +0100
Message-ID: <87lfaacks9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Mar 25, 2021 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> This adds a selftest to check that the verifier rejects a TCP CC struct_=
ops
>> with a non-GPL license.
>>
>> v2:
>> - Use a minimal struct_ops BPF program instead of rewriting bpf_dctcp's
>>   license in memory.
>> - Check for the verifier reject message instead of just the return code.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 44 +++++++++++++++++++
>>  .../selftests/bpf/progs/bpf_nogpltcp.c        | 19 ++++++++
>>  2 files changed, 63 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_nogpltcp.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools=
/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> index 37c5494a0381..a09c716528e1 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>> @@ -6,6 +6,7 @@
>>  #include <test_progs.h>
>>  #include "bpf_dctcp.skel.h"
>>  #include "bpf_cubic.skel.h"
>> +#include "bpf_nogpltcp.skel.h"
>
> total nit, but my eyes can't read "nogpltcp"... wouldn't
> "bpf_tcp_nogpl" be a bit easier?

Haha, yeah, good point - my eyes also just lump it into a blob...

>>
>>  #define min(a, b) ((a) < (b) ? (a) : (b))
>>
>> @@ -227,10 +228,53 @@ static void test_dctcp(void)
>>         bpf_dctcp__destroy(dctcp_skel);
>>  }
>>
>> +static char *err_str =3D NULL;
>> +static bool found =3D false;
>> +
>> +static int libbpf_debug_print(enum libbpf_print_level level,
>> +                             const char *format, va_list args)
>> +{
>> +       char *log_buf;
>> +
>> +       if (level !=3D LIBBPF_WARN ||
>> +           strcmp(format, "libbpf: \n%s\n")) {
>> +               vprintf(format, args);
>> +               return 0;
>> +       }
>> +
>> +       log_buf =3D va_arg(args, char *);
>> +       if (!log_buf)
>> +               goto out;
>> +       if (err_str && strstr(log_buf, err_str) !=3D NULL)
>> +               found =3D true;
>> +out:
>> +       printf(format, log_buf);
>> +       return 0;
>> +}
>> +
>> +static void test_invalid_license(void)
>> +{
>> +       libbpf_print_fn_t old_print_fn =3D NULL;
>> +       struct bpf_nogpltcp *skel;
>> +
>> +       err_str =3D "struct ops programs must have a GPL compatible lice=
nse";
>> +       old_print_fn =3D libbpf_set_print(libbpf_debug_print);
>> +
>> +       skel =3D bpf_nogpltcp__open_and_load();
>> +       if (CHECK(skel, "bpf_nogplgtcp__open_and_load()", "didn't fail\n=
"))
>
> ASSERT_OK_PTR()
>
>> +               bpf_nogpltcp__destroy(skel);
>
> you should destroy unconditionally
>
>> +
>> +       CHECK(!found, "errmsg check", "expected string '%s'", err_str);
>
> ASSERT_EQ(found, true, "expected_err_msg");
>
> I can never be sure which way CHECK() is checking

Ah, thanks! I always get confused about CHECK() as well! Maybe it should
be renamed to ASSERT()? But that would require flipping all the if()
statements around them as well :/

-Toke

