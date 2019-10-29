Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084C5E8F9E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfJ2S4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:56:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40295 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfJ2S4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:56:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id o49so21791970qta.7;
        Tue, 29 Oct 2019 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MKFB23Bkm+ppiouFk9iltp5ZtIwxBMue7vPQWmQ4M+0=;
        b=QS6wTH3UW3CsAYtOYo6fQ2uskCgaQzlPsWf2MvoPFfRG3EjGdosHfvuwr+6EcahQRW
         GamAtSJbBBbZobFtDifaP+lhf6Sy5kE65rFQVg/wmro4ykq4svn4jN2C0KWm4/UkfxZS
         Hn9c7PIKDvhyDH6SlVtu/0bBu4LPax3s5JXTfZOau7JIFRXISUEKAvhCXnEwCGUkf4pi
         asYQ5AAYeGpcVFIFaIybYKexnH1ivJ5Wd3NbSTz/DeFtqVc9/Q6cJJDgnPS6xtYZbT1j
         RSKVt23y0nAmUej56bCc/8R5FjHsMG66Cvm+Urqn5usObQyHME0qPUJU77MeMQ4/Zs00
         gyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MKFB23Bkm+ppiouFk9iltp5ZtIwxBMue7vPQWmQ4M+0=;
        b=t7zVLun9ZlCUqmQK8jvGQF6uh+5nGnTtqRh2O6IRgFa2mzsVknyLG9cuOWrPUGRquR
         k/TO5+URIrzUcGk59z/qMk6wt+6Uy2eZ3CBgazXJ1+mKMhEArq0SPzxcX3yOSro+w3f+
         ck+rAAqYTC24NVwlJOBOzd+DZ0zeZ6WYUdmIrpNxqQGCRfaq0fU4iCrzUwSQTBW+vFGl
         9L9KMuDCex+75qdfFzcFs2SmC1+D+SN/Kvs0+buufphfp0fzZJ/Zfa0EZAlkjML5SFD4
         7Gbxc87xmDQoyseAUomCSkhuCrcl4nofkWZpdND+Xvpq6AwVe97DN5tOrEJ6L0MhBLG0
         flzQ==
X-Gm-Message-State: APjAAAXEF+PFuiNrVQa8YRi/mblL+r6VXaz/s9PRzcetdCOsvJOCN38o
        XLQfcFKLqIF12eB5Z1gW+A1FzQrlmUVIfb4RuM8=
X-Google-Smtp-Source: APXvYqxN1yjpxi2P9z0duE+mLI3+qZa7dnE3EZsbS1o6UGF35sVhGzOmBnxKyWwqowaEqzwIvI6+8KqCYactHGLpRfQ=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr559190qtj.93.1572375405681;
 Tue, 29 Oct 2019 11:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959873.48922.4763375792594816553.stgit@toke.dk> <CAEf4BzYoEPKNFnzOEAhhE2w=U11cYfTN4o_23kjzY4ByEt5y-g@mail.gmail.com>
 <877e4nsxth.fsf@toke.dk> <CAEf4BzZe6h=0KN+uWdKcGU5VoRDDsvjNzyqh0=aT1u+EvT1x_g@mail.gmail.com>
 <878sp3qtln.fsf@toke.dk>
In-Reply-To: <878sp3qtln.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Oct 2019 11:56:34 -0700
Message-ID: <CAEf4BzYhaCpiP3QZJ9zoKq6CujF-49HsNXfMSYmnWqBTq2z2Nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/4] libbpf: Add auto-pinning of maps when
 loading BPF objects
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 11:44 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Oct 29, 2019 at 2:30 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Sun, Oct 27, 2019 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> This adds support to libbpf for setting map pinning information as =
part of
> >> >> the BTF map declaration, to get automatic map pinning (and reuse) o=
n load.
> >> >> The pinning type currently only supports a single PIN_BY_NAME mode,=
 where
> >> >> each map will be pinned by its name in a path that can be overridde=
n, but
> >> >> defaults to /sys/fs/bpf.
> >> >>
> >> >> Since auto-pinning only does something if any maps actually have a
> >> >> 'pinning' BTF attribute set, we default the new option to enabled, =
on the
> >> >> assumption that seamless pinning is what most callers want.
> >> >>
> >> >> When a map has a pin_path set at load time, libbpf will compare the=
 map
> >> >> pinned at that location (if any), and if the attributes match, will=
 re-use
> >> >> that map instead of creating a new one. If no existing map is found=
, the
> >> >> newly created map will instead be pinned at the location.
> >> >>
> >> >> Programs wanting to customise the pinning can override the pinning =
paths
> >> >> using bpf_map__set_pin_path() before calling bpf_object__load() (in=
cluding
> >> >> setting it to NULL to disable pinning of a particular map).
> >> >>
> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> ---
> >> >>  tools/lib/bpf/bpf_helpers.h |    6 ++
> >> >>  tools/lib/bpf/libbpf.c      |  142 +++++++++++++++++++++++++++++++=
+++++++++++-
> >> >>  tools/lib/bpf/libbpf.h      |   11 +++
> >> >>  3 files changed, 154 insertions(+), 5 deletions(-)
> >> >>
> >> >
> >> > [...]
> >> >
> >> >>
> >> >> -static int bpf_object__init_maps(struct bpf_object *obj, bool rela=
xed_maps)
> >> >> +static int bpf_object__build_map_pin_paths(struct bpf_object *obj,
> >> >> +                                          const char *path)
> >> >> +{
> >> >> +       struct bpf_map *map;
> >> >> +
> >> >> +       if (!path)
> >> >> +               path =3D "/sys/fs/bpf";
> >> >> +
> >> >> +       bpf_object__for_each_map(map, obj) {
> >> >> +               char buf[PATH_MAX];
> >> >> +               int err, len;
> >> >> +
> >> >> +               if (map->pinning !=3D LIBBPF_PIN_BY_NAME)
> >> >> +                       continue;
> >> >
> >> > still think it's better be done from map definition parsing code
> >> > instead of a separate path, which will ignore most of maps anyways (=
of
> >> > course by extracting this whole buffer creation logic into a
> >> > function).
> >>
> >> Hmm, okay, can do that. I think we should still store the actual value
> >> of the 'pinning' attribute, though; and even have a getter for it. The
> >> app may want to do something with that information instead of having t=
o
> >> infer it from map->pin_path. Certainly when we add other values of the
> >> pinning attribute, but we may as well add the API to get the value
> >> now...
> >
> > Let's now expose more stuff than what we need to expose. If we really
> > will have a need for that, it's really easy to add. Right now you
> > won't even need to store pinning attribute in bpf_map, because you'll
> > be just setting proper pin_path in init_user_maps(), as suggested
> > above.
>
> While I do think it's a bit weird that there's an attribute you can set
> but can't get at, I will grudgingly admit that it's not strictly needed
> right now... So OK, I'll leave it out :)
>
> >> >> +
> >> >> +               len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_=
map__name(map));
> >> >> +               if (len < 0)
> >> >> +                       return -EINVAL;
> >> >> +               else if (len >=3D PATH_MAX)
> >> >
> >> > [...]
> >> >
> >> >>         return 0;
> >> >>  }
> >> >>
> >> >> +static bool map_is_reuse_compat(const struct bpf_map *map,
> >> >> +                               int map_fd)
> >> >
> >> > nit: this should fit on single line?
> >> >
> >> >> +{
> >> >> +       struct bpf_map_info map_info =3D {};
> >> >> +       char msg[STRERR_BUFSIZE];
> >> >> +       __u32 map_info_len;
> >> >> +
> >> >> +       map_info_len =3D sizeof(map_info);
> >> >> +
> >> >> +       if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len=
)) {
> >> >> +               pr_warn("failed to get map info for map FD %d: %s\n=
",
> >> >> +                       map_fd, libbpf_strerror_r(errno, msg, sizeo=
f(msg)));
> >> >> +               return false;
> >> >> +       }
> >> >> +
> >> >> +       return (map_info.type =3D=3D map->def.type &&
> >> >> +               map_info.key_size =3D=3D map->def.key_size &&
> >> >> +               map_info.value_size =3D=3D map->def.value_size &&
> >> >> +               map_info.max_entries =3D=3D map->def.max_entries &&
> >> >> +               map_info.map_flags =3D=3D map->def.map_flags &&
> >> >> +               map_info.btf_key_type_id =3D=3D map->btf_key_type_i=
d &&
> >> >> +               map_info.btf_value_type_id =3D=3D map->btf_value_ty=
pe_id);
> >> >
> >> > If map was pinned by older version of the same app, key and value ty=
pe
> >> > id are probably gonna be different, even if the type definition itse=
lf
> >> > it correct. We probably shouldn't check that?
> >>
> >> Oh, I thought the type IDs would stay relatively stable. If not then I
> >> agree that we shouldn't be checking them here. Will fix.
> >
> > type IDs are just an ordered index of a type, as generated by Clang.
> > No stability guarantees. Just adding extra typedef somewhere in
> > unrelated type might shift all the type IDs around.
>
> Ah, so it's just numbering types within the same translation unit? I
> thought it was somehow globally (or system-wide) unique (though not sure
> how I imagined that would be achieved, TBH).
>
> >> >> +}
> >> >> +
> >> >> +static int
> >> >> +bpf_object__reuse_map(struct bpf_map *map)
> >> >> +{
> >> >> +       char *cp, errmsg[STRERR_BUFSIZE];
> >> >> +       int err, pin_fd;
> >> >> +
> >> >> +       pin_fd =3D bpf_obj_get(map->pin_path);
> >> >> +       if (pin_fd < 0) {
> >> >> +               if (errno =3D=3D ENOENT) {
> >> >> +                       pr_debug("found no pinned map to reuse at '=
%s'\n",
> >> >> +                                map->pin_path);
> >> >> +                       return 0;
> >> >> +               }
> >> >> +
> >> >> +               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errm=
sg));
> >> >> +               pr_warn("couldn't retrieve pinned map '%s': %s\n",
> >> >> +                       map->pin_path, cp);
> >> >> +               return -errno;
> >> >
> >> > store errno locally
> >>
> >> *shrugs* okay, if you insist...
> >
> > I guess I do insist on correct handling of errno, instead of
> > potentially returning garbage value from some unrelated syscall from
> > inside of pr_warn's user-provided callback.
> >
> > Even libbpf_strerror_r can garble errno (e.g., through its strerror_r
> > call), so make sure you store it before passing into
> > libbpf_strerror_r().
>
> Ohh, right, didn't think about those having side effects; then your
> worry makes more sense. I thought you were just being pedantic, which is
> why I was being grumpy (did change it, though) :)
>
> >>
> >> >> +       }
> >> >> +
> >> >> +       if (!map_is_reuse_compat(map, pin_fd)) {
> >> >> +               pr_warn("couldn't reuse pinned map at '%s': "
> >> >> +                       "parameter mismatch\n", map->pin_path);
> >> >> +               close(pin_fd);
> >> >> +               return -EINVAL;
> >> >> +       }
> >> >> +
> >> >> +       err =3D bpf_map__reuse_fd(map, pin_fd);
> >> >> +       if (err) {
> >> >> +               close(pin_fd);
> >> >> +               return err;
> >> >> +       }
> >> >> +       map->pinned =3D true;
> >> >> +       pr_debug("reused pinned map at '%s'\n", map->pin_path);
> >> >> +
> >> >> +       return 0;
> >> >> +}
> >> >> +
> >> >
> >> > [...]
> >> >
> >> >> +enum libbpf_pin_type {
> >> >> +       LIBBPF_PIN_NONE,
> >> >> +       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default=
) */
> >> >> +       LIBBPF_PIN_BY_NAME,
> >> >> +};
> >> >> +
> >> >>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const =
char *path);
> >> >
> >> > pin_maps should take into account opts->auto_pin_path, shouldn't it?
> >> >
> >> > Which is why I also think that auto_pin_path is bad name, because it=
's
> >> > not only for auto-pinning, it's a pinning root path, so something li=
ke
> >> > pin_root_path or just pin_root is better and less misleading name.
> >>
> >> I view auto_pin_path as something that is used specifically for the
> >> automatic pinning based on the 'pinning' attribute. Any other use of
> >> pinning is for custom use and the user can pass a custom pin path to
> >> those functions.
> >
> > What's the benefit of restricting it to just this use case? If app
> > wants to use something other than /sys/fs/bpf as a default root path,
> > why would that be restricted only to auto-pinned maps? It seems to me
> > that having set this on bpf_object__open() and then calling
> > bpf_object__pin_maps(NULL) should just take this overridden root path
> > into account. Isn't that a logical behavior?
>
> No, I think the logical behaviour is for pin_maps(NULL) to just pin all
> maps at map->pin_path if set (and same for unpin). Already changed it to
> this behaviour, actually.

Sure, I guess that makes sense as well. Can you please add comment to
pin_maps describing this convention?

I still think that auto_pin_path is both too specific and also
imprecise at the same time :) It's not really a pin path, it's a part
of a pin path for any particular map, it's a root of those paths. And
let's not corner us to just auto-pinning use case yet by saying it's
auto_pin_path? So something like pin_root_path or root_pin_path is
generic enough to allow extensions if we need them, but without being
misleading.

>
> -Toke
