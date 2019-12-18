Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74349124559
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfLRLIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:08:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbfLRLIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9N6bug9fqhjHQqfRWIzS1Bxa22v0COyCASVHwhVdOk=;
        b=CoJPhPdb6svHWPuOW5RxGA8likt+O2zzms89qF9PtQ0sEk1zkAlO5u9GnsnhGj7DsWEAB2
        0OoFRtdU15CssKLCXdS4NQT8Yc23myLlv+E0ixTE/Ix//0lV/H4ObV8+Pjw3QV5zP9f22f
        E6QOyhkOi/L+w41py2EQE7vtyjyF/YU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-gQztRQRAOQ6SQB4asrSk_Q-1; Wed, 18 Dec 2019 06:08:39 -0500
X-MC-Unique: gQztRQRAOQ6SQB4asrSk_Q-1
Received: by mail-lj1-f199.google.com with SMTP id d14so572343ljg.17
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:08:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=t9N6bug9fqhjHQqfRWIzS1Bxa22v0COyCASVHwhVdOk=;
        b=iRkgBxaBTAi9AIii3i/awErsskAuNM+DvcyVl8tCBCkB/JZO0DhMuuVg0Sz9ZyJtqa
         fGHd38wnW9UE0bdcZxok8ISY8ZtXDAsE8c8T+DCYYJyhxyEcIDXGPcRgBLP1u7qHi/c9
         omfqcu2HYuCJrn5aDJ5EtoTINSAdndgL0jBiiXJIgECWjocFEu1C3yzjhhxa/F7dUzii
         IIR1fFN5r3Yy0KCj/9ZwTjm//uBMrC6DZoBbaZb98a3rk+1E5FY9noyYxKzbrLK5NFd/
         TF/4PiYLmCxkixGluKD3seIushibmF/lrMbefq/gwVLzR+90i5an7JsWJRAuilomQabL
         /TkQ==
X-Gm-Message-State: APjAAAWMSq/FYQ7b/GcC05hJTcRLDayxWZauR5SNdIkikxZLuYIwX5cY
        6qNXddC2gJvHYCdWCl9/JcT+K1hSv3k2RLYpUSkf9JohSMXgDNYO7nry29jR2fuWnbE9u8vooIE
        ikuFxjtEMhPRD2DDW
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr1236326ljj.206.1576667317734;
        Wed, 18 Dec 2019 03:08:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvL/f+gpRBh2p4/BeptEEvf2ziXJJxLYL3xp5NKCseiQY2pF7SSqzs9T/8bffLHhb2+PPCEw==
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr1236295ljj.206.1576667317216;
        Wed, 18 Dec 2019 03:08:37 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m15sm951499ljj.16.2019.12.18.03.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:08:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8A764180969; Wed, 18 Dec 2019 12:08:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Yonghong Song <yhs@fb.com>, lkft-triage@lists.linaro.org,
        Leo Yan <leo.yan@linaro.org>,
        Daniel Diaz <daniel.diaz@linaro.org>
Subject: Re: [PATCH bpf-next v2] libbpf: Print hint about ulimit when getting permission denied error
In-Reply-To: <CA+G9fYssgDcBkiNGSV7BmjE4Tj1j1_fa4VTJFv3N=2FHzewQLg@mail.gmail.com>
References: <20191216181204.724953-1-toke@redhat.com> <CA+G9fYssgDcBkiNGSV7BmjE4Tj1j1_fa4VTJFv3N=2FHzewQLg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:08:34 +0100
Message-ID: <878sn97ux9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> On Tue, 17 Dec 2019 at 00:00, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index a2cc7313763a..3fe42d6b0c2f 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -41,6 +41,7 @@
>>  #include <sys/types.h>
>>  #include <sys/vfs.h>
>>  #include <sys/utsname.h>
>> +#include <sys/resource.h>
>>  #include <tools/libc_compat.h>
>>  #include <libelf.h>
>>  #include <gelf.h>
>> @@ -100,6 +101,32 @@ void libbpf_print(enum libbpf_print_level level, co=
nst char *format, ...)
>>         va_end(args);
>>  }
>>
>> +static void pr_perm_msg(int err)
>> +{
>> +       struct rlimit limit;
>> +       char buf[100];
>> +
>> +       if (err !=3D -EPERM || geteuid() !=3D 0)
>> +               return;
>> +
>> +       err =3D getrlimit(RLIMIT_MEMLOCK, &limit);
>> +       if (err)
>> +               return;
>> +
>> +       if (limit.rlim_cur =3D=3D RLIM_INFINITY)
>> +               return;
>> +
>> +       if (limit.rlim_cur < 1024)
>> +               snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
>
>  libbpf.c: In function 'pr_perm_msg':
>  libbpf.c:120:33: error: format '%lu' expects argument of type 'long
> unsigned int', but argument 4 has type 'rlim_t {aka long long unsigned
> int}' [-Werror=3Dformat=3D]
>     snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
>                                 ~~^         ~~~~~~~~~~~~~~
>                                 %llu
>

Ah, guess this needs PRIu64. Will send a follow-up, thanks for the
report :)

-Toke

