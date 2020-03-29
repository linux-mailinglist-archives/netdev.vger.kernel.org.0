Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F07196D93
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 15:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgC2NKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 09:10:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:52659 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728215AbgC2NKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 09:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585487453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E31LT0I4tJZB6oZQ8d2w38DHMS7tgwHGLKjR6dj+XoI=;
        b=VEpSBajsuTma5VWHG0WAjb9wKegPY93YoCclqlwb4IwYF99UCMXYBuLVzKalL+kTnlX7tf
        AXTNTccsX7nLSceakUiM96teNwQ4OZuZm9eRlVzstVZzNI1fIwmmwWM9J1LECZf+JLQu4h
        0gQJ9Qc6IWkbSIL/sXFBN4dIIX3y3sc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-kWN88WBTNMuCYz-6MtUZPQ-1; Sun, 29 Mar 2020 09:10:51 -0400
X-MC-Unique: kWN88WBTNMuCYz-6MtUZPQ-1
Received: by mail-lf1-f69.google.com with SMTP id b25so6105729lfi.21
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 06:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=E31LT0I4tJZB6oZQ8d2w38DHMS7tgwHGLKjR6dj+XoI=;
        b=rrQj5hI5EEoA8riTCbHjB0GFpPxIgwRSU2hGeH4ezAEV4Ru6wZJYf2OlgCpZ88jFAx
         UPLlBAYI/kNpo5pRvyVP8FJF1u3TyMscFjfsYS/u4vV7PMUfOCtH+01QEyo9yKw7GLDq
         yFpRK124Pde8NZeiBUGaH6sYXOIfdprQxmIkPQUbuyUiIGHua+6d9Fy19dYazuClLubF
         RZHH12GFpY5iYxE5/75SGPrjnioK+9lw8+ntDd6GvAHEbYEgIYAZXEBa3qTXVUonRmMk
         /49UaZGI6/PI/1iZrbCh1WXJb3slYd9xaEvVgYZbHz5rciPfUKTxbQh2P/TKMh1/4f6d
         NIMA==
X-Gm-Message-State: AGi0Puady3mTXFlaCXSr4eLEFN9EM7UK+5GUvxiyX25B+3bqws405/ft
        0vDiCu+VCqK9pUam7SjWQY43h77uOt/OPQ6sXBLW27dmRfrj2Ffm8I9atrT3FG9JZMQ6GFENMfE
        yB2BBoNli8S4aFlBF
X-Received: by 2002:a19:4ad4:: with SMTP id x203mr5295673lfa.64.1585487450085;
        Sun, 29 Mar 2020 06:10:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypLrmfctLlPcyhEWmKswZVHKGARfDMjJBJrSn3i4RaC67/kNsUTYfVLlIPhGVgRBMr+jInREeQ==
X-Received: by 2002:a19:4ad4:: with SMTP id x203mr5295659lfa.64.1585487449785;
        Sun, 29 Mar 2020 06:10:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 9sm6212501ljf.0.2020.03.29.06.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 06:10:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 18E7018158B; Sun, 29 Mar 2020 15:10:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] selftests: Add test for overriding global data value before load
In-Reply-To: <CAEf4BzZPd0-unT7ChKNFCYRVU2NHfdp8kKuEFSZgaDxm9ndC8w@mail.gmail.com>
References: <20200327125818.155522-1-toke@redhat.com> <20200328182834.196578-2-toke@redhat.com> <CAEf4BzZPd0-unT7ChKNFCYRVU2NHfdp8kKuEFSZgaDxm9ndC8w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 29 Mar 2020 15:10:47 +0200
Message-ID: <87tv27joh4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Mar 28, 2020 at 11:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> This extends the global_data test to also exercise the new
>> bpf_map__set_initial_value() function. The test simply overrides the glo=
bal
>> data section with all zeroes, and checks that the new value makes it into
>> the kernel map on load.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/global_data.c    | 61 +++++++++++++++++++
>>  1 file changed, 61 insertions(+)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tool=
s/testing/selftests/bpf/prog_tests/global_data.c
>> index c680926fce73..f018ce53a8d1 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/global_data.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
>> @@ -121,6 +121,65 @@ static void test_global_data_rdonly(struct bpf_obje=
ct *obj, __u32 duration)
>>               "err %d errno %d\n", err, errno);
>>  }
>>
>> +static void test_global_data_set_rdonly(__u32 duration)
>> +{
>> +       const char *file =3D "./test_global_data.o";
>> +       int err =3D -ENOMEM, map_fd, zero =3D 0;
>> +       __u8 *buff =3D NULL, *newval =3D NULL;
>> +       struct bpf_program *prog;
>> +       struct bpf_object *obj;
>> +       struct bpf_map *map;
>> +       size_t sz;
>> +
>> +       obj =3D bpf_object__open_file(file, NULL);
>
> Try using skeleton open and load .o file, it will cut this code almost
> in half.

Doesn't work, though:

In file included from /home/build/linux/tools/testing/selftests/bpf/prog_te=
sts/global_data_init.c:3:
/home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:31:14=
: error: field =E2=80=98struct1=E2=80=99 has incomplete type
   31 |   struct foo struct1;
      |              ^~~~~~~
/home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:37:14=
: error: field =E2=80=98struct3=E2=80=99 has incomplete type
   37 |   struct foo struct3;
      |              ^~~~~~~
/home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:45:14=
: error: field =E2=80=98struct0=E2=80=99 has incomplete type
   45 |   struct foo struct0;
      |              ^~~~~~~
/home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:46:14=
: error: field =E2=80=98struct2=E2=80=99 has incomplete type
   46 |   struct foo struct2;
      |              ^~~~~~~
make: *** [Makefile:361: /home/build/linux/tools/testing/selftests/bpf/glob=
al_data_init.test.o] Error 1

Just fixing the program SEC name as you suggested below already gets rid
of half the setup code, though, so doesn't really make much difference
anyway :)

>> +       if (CHECK_FAIL(!obj))
>> +               return;
>> +       prog =3D bpf_program__next(NULL, obj);
>> +       if (CHECK_FAIL(!prog))
>> +               goto out;
>> +       err =3D bpf_program__set_sched_cls(prog);
>
> Please fix SEC() name for that program instead of setting type explicitly.

Yeah, that helps, thanks!

>> +       if (CHECK_FAIL(err))
>> +               goto out;
>> +
>> +       map =3D bpf_object__find_map_by_name(obj, "test_glo.rodata");
>> +       if (CHECK_FAIL(!map || !bpf_map__is_internal(map)))
>> +               goto out;
>> +
>> +       sz =3D bpf_map__def(map)->value_size;
>> +       newval =3D malloc(sz);
>> +       if (CHECK_FAIL(!newval))
>> +               goto out;
>> +       memset(newval, 0, sz);
>> +
>> +       /* wrong size, should fail */
>> +       err =3D bpf_map__set_initial_value(map, newval, sz - 1);
>> +       if (CHECK(!err, "reject set initial value wrong size", "err %d\n=
", err))
>> +               goto out;
>> +
>> +       err =3D bpf_map__set_initial_value(map, newval, sz);
>> +       if (CHECK_FAIL(err))
>> +               goto out;
>> +
>> +       err =3D bpf_object__load(obj);
>> +       if (CHECK_FAIL(err))
>> +               goto out;
>> +
>> +       map_fd =3D bpf_map__fd(map);
>> +       if (CHECK_FAIL(map_fd < 0))
>> +               goto out;
>> +
>> +       buff =3D malloc(sz);
>> +       if (buff)
>> +               err =3D bpf_map_lookup_elem(map_fd, &zero, buff);
>> +       CHECK(!buff || err || memcmp(buff, newval, sz),
>> +             "compare .rodata map data override",
>> +             "err %d errno %d\n", err, errno);
>> +out:
>> +       free(buff);
>> +       free(newval);
>> +       bpf_object__close(obj);
>> +}
>> +
>>  void test_global_data(void)
>>  {
>>         const char *file =3D "./test_global_data.o";
>> @@ -144,4 +203,6 @@ void test_global_data(void)
>>         test_global_data_rdonly(obj, duration);
>>
>>         bpf_object__close(obj);
>> +
>> +       test_global_data_set_rdonly(duration);
>
> This should either be a sub-test or better yet a separate test
> altogether.

Sure, will move it to its own file.

-Toke

