Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5650C196FD5
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgC2UJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:09:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42260 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbgC2UJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:09:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id 139so7011454qkd.9;
        Sun, 29 Mar 2020 13:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0wS5vVK0/wgOWt8ftdbJDzCC7SN+nfLkyWNBYlWxHLU=;
        b=VSw4fshS9NEK4YVCz8n/kto917rDZivCWA4aWCrEydP3JMZJZyHm+mXd3OkmW1Fgye
         qY0SoxDCOdVey/UV5cMxwHn0LmdOFEaiU8sIeyngtw4f5OeydCluzgFC6jo8UkEPI3ab
         RtNnhuViT/3r/VAdGfaKsNdQ0oz9kFJtMxrqUj1P+o+lte8E+T9uayLhHUs9DbNFm71G
         +NR2zipEAEiTkSRn1a3L8WnPeay1hY4v4P4fSzfEDHXXlYyBbzZNPoCv54aUHkAuPD7D
         aOKXhnkzsn4cD4+ORYPiN2ruXZUSfHRabbWXiNT3kC3AkC7RS0Bw5tRP5Uu0KJ6qoaWm
         Uo1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0wS5vVK0/wgOWt8ftdbJDzCC7SN+nfLkyWNBYlWxHLU=;
        b=jbFIcMY3JHA+l9rdYILHUx8upxGgT4sWESyjJjUPcIqH31t+7DePgJmTErFLhK6WxM
         AnG4h5YbwyXsZj/se//fAxdGFWRwNz5+45JJeq5Oahym4LImRYzh26GiDXLhOY2com9L
         1RamvPswKy3sUyWtQautDtQovA28CEjcVDeeciWnF82hDEJMoNDaEqtEsL/HmrDhx9rF
         Q7sl5krB2W0mogHD/mm+p7pIOuDg6sJVH+h6yJDQYwso1qtEd6Zy/bcv+TzO4CkzTG84
         2My+Akj13SXz5RR+Sew9hK6HKKC91/SxyYD2cybRIUynMi7uEKNUVGoZwPM5N5j286jD
         YurA==
X-Gm-Message-State: ANhLgQ0CobKaHU/+mstk8tg7wlE14JXNToDrnVZOZQwUpkQuQg6PeCSH
        KCUJQyTj80YhyAPIedThX7XFEcj2b/agrhXLDgU=
X-Google-Smtp-Source: ADFU+vu6hgGy2DpWA8c0U8cbjAPwkOInJ8JvJvcFVTRDdIwZj94+hzQWAyZZ6iIq/6nGupOgEzyPoBvzVzM53Md0RFA=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr9309359qka.449.1585512540043;
 Sun, 29 Mar 2020 13:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200327125818.155522-1-toke@redhat.com> <20200328182834.196578-2-toke@redhat.com>
 <CAEf4BzZPd0-unT7ChKNFCYRVU2NHfdp8kKuEFSZgaDxm9ndC8w@mail.gmail.com> <87tv27joh4.fsf@toke.dk>
In-Reply-To: <87tv27joh4.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Mar 2020 13:08:49 -0700
Message-ID: <CAEf4BzYxTHoJRFut9NN3gx0QxpUnE7wRK-wyMwAjb4K=2T8-Mw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: Add test for overriding global data
 value before load
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 6:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Mar 28, 2020 at 11:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> This extends the global_data test to also exercise the new
> >> bpf_map__set_initial_value() function. The test simply overrides the g=
lobal
> >> data section with all zeroes, and checks that the new value makes it i=
nto
> >> the kernel map on load.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  .../selftests/bpf/prog_tests/global_data.c    | 61 ++++++++++++++++++=
+
> >>  1 file changed, 61 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/to=
ols/testing/selftests/bpf/prog_tests/global_data.c
> >> index c680926fce73..f018ce53a8d1 100644
> >> --- a/tools/testing/selftests/bpf/prog_tests/global_data.c
> >> +++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
> >> @@ -121,6 +121,65 @@ static void test_global_data_rdonly(struct bpf_ob=
ject *obj, __u32 duration)
> >>               "err %d errno %d\n", err, errno);
> >>  }
> >>
> >> +static void test_global_data_set_rdonly(__u32 duration)
> >> +{
> >> +       const char *file =3D "./test_global_data.o";
> >> +       int err =3D -ENOMEM, map_fd, zero =3D 0;
> >> +       __u8 *buff =3D NULL, *newval =3D NULL;
> >> +       struct bpf_program *prog;
> >> +       struct bpf_object *obj;
> >> +       struct bpf_map *map;
> >> +       size_t sz;
> >> +
> >> +       obj =3D bpf_object__open_file(file, NULL);
> >
> > Try using skeleton open and load .o file, it will cut this code almost
> > in half.
>
> Doesn't work, though:

Right, because test_global_data uses BPF-only struct definitions. In
real life those types should be shared in a common header file.

For this feature, I'd suggest to create a separate trivial BPF program
with a simple trivial BPF program and single global variable. There is
nothing you really need from test_global_data setup.

>
> In file included from /home/build/linux/tools/testing/selftests/bpf/prog_=
tests/global_data_init.c:3:
> /home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:31:=
14: error: field =E2=80=98struct1=E2=80=99 has incomplete type
>    31 |   struct foo struct1;
>       |              ^~~~~~~
> /home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:37:=
14: error: field =E2=80=98struct3=E2=80=99 has incomplete type
>    37 |   struct foo struct3;
>       |              ^~~~~~~
> /home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:45:=
14: error: field =E2=80=98struct0=E2=80=99 has incomplete type
>    45 |   struct foo struct0;
>       |              ^~~~~~~
> /home/build/linux/tools/testing/selftests/bpf/test_global_data.skel.h:46:=
14: error: field =E2=80=98struct2=E2=80=99 has incomplete type
>    46 |   struct foo struct2;
>       |              ^~~~~~~
> make: *** [Makefile:361: /home/build/linux/tools/testing/selftests/bpf/gl=
obal_data_init.test.o] Error 1
>
> Just fixing the program SEC name as you suggested below already gets rid
> of half the setup code, though, so doesn't really make much difference
> anyway :)
>
> >> +       if (CHECK_FAIL(!obj))
> >> +               return;
> >> +       prog =3D bpf_program__next(NULL, obj);
> >> +       if (CHECK_FAIL(!prog))
> >> +               goto out;
> >> +       err =3D bpf_program__set_sched_cls(prog);
> >
> > Please fix SEC() name for that program instead of setting type explicit=
ly.
>
> Yeah, that helps, thanks!
>
> >> +       if (CHECK_FAIL(err))
> >> +               goto out;
> >> +
> >> +       map =3D bpf_object__find_map_by_name(obj, "test_glo.rodata");
> >> +       if (CHECK_FAIL(!map || !bpf_map__is_internal(map)))
> >> +               goto out;
> >> +
> >> +       sz =3D bpf_map__def(map)->value_size;
> >> +       newval =3D malloc(sz);
> >> +       if (CHECK_FAIL(!newval))
> >> +               goto out;
> >> +       memset(newval, 0, sz);
> >> +
> >> +       /* wrong size, should fail */
> >> +       err =3D bpf_map__set_initial_value(map, newval, sz - 1);
> >> +       if (CHECK(!err, "reject set initial value wrong size", "err %d=
\n", err))
> >> +               goto out;
> >> +
> >> +       err =3D bpf_map__set_initial_value(map, newval, sz);
> >> +       if (CHECK_FAIL(err))
> >> +               goto out;
> >> +
> >> +       err =3D bpf_object__load(obj);
> >> +       if (CHECK_FAIL(err))
> >> +               goto out;
> >> +
> >> +       map_fd =3D bpf_map__fd(map);
> >> +       if (CHECK_FAIL(map_fd < 0))
> >> +               goto out;
> >> +
> >> +       buff =3D malloc(sz);
> >> +       if (buff)
> >> +               err =3D bpf_map_lookup_elem(map_fd, &zero, buff);
> >> +       CHECK(!buff || err || memcmp(buff, newval, sz),
> >> +             "compare .rodata map data override",
> >> +             "err %d errno %d\n", err, errno);
> >> +out:
> >> +       free(buff);
> >> +       free(newval);
> >> +       bpf_object__close(obj);
> >> +}
> >> +
> >>  void test_global_data(void)
> >>  {
> >>         const char *file =3D "./test_global_data.o";
> >> @@ -144,4 +203,6 @@ void test_global_data(void)
> >>         test_global_data_rdonly(obj, duration);
> >>
> >>         bpf_object__close(obj);
> >> +
> >> +       test_global_data_set_rdonly(duration);
> >
> > This should either be a sub-test or better yet a separate test
> > altogether.
>
> Sure, will move it to its own file.
>
> -Toke
>
