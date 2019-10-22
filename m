Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078DEE0C15
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbfJVS55 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 14:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfJVS55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 14:57:57 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E5655AFDE
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 18:57:56 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id o9so3585828lfd.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:57:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vY2wjlFlHvZbBFwwal21ar8Mn/XZVYfO8GSFxxLGFII=;
        b=F7Io0gQrkZN/SB/Q0zchD8uXRriseliFrYm/C8z/kPJTckqHjHNcpX2kpMdtnpbAfV
         LTCt4IbgWwZkeTs5qGp1TDEgRcDYFY2pdZFc5B1Md3ty7JkHLmJ85nsAfINBTkWsKrlI
         Zy26L4mu9xC/Ul68+wOYsbaoSVhX4k/WYJC4zE4EjwoENktM6KDBGxmPLB3BpwfKhbcA
         X8C9hqgLedco6VDhBX4M2u9hqbdFl+71gr3EJEiyEZ+HsXyOjDKI+IpiUxWzRZ+Qe3YZ
         jUChJt0nRjHBUXGTd6MTliqxVY71oy2tc2PMawD2WyxXyq7XqyaV7Rk7hNulXxVyPG9K
         CGpQ==
X-Gm-Message-State: APjAAAXCYLvTTM46qItcrnlibOgdfCI+WitB4G6N7eC6swRdkFZ9WqxR
        6bH1tWOXdaOJNuQhCHkBoMoGD4lj1FHbUg3awWfs00H6L96kX/LKVyMjM8/7p2LrtWB/hss8Q4f
        MVzW90mq4lbLWD5FK
X-Received: by 2002:a2e:8310:: with SMTP id a16mr20154795ljh.48.1571770674838;
        Tue, 22 Oct 2019 11:57:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxahd7Udv4ztB/mabRrT3cEJ0W5boMqJrTLdFt6mTfaLOFrW4ZfZmsT8gJWPiLcTGcqiBJ9SQ==
X-Received: by 2002:a2e:8310:: with SMTP id a16mr20154779ljh.48.1571770674368;
        Tue, 22 Oct 2019 11:57:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g5sm8569021ljk.22.2019.10.22.11.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:57:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E3261804B1; Tue, 22 Oct 2019 20:57:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps from BTF annotations
In-Reply-To: <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668991.112621.14204565208520782920.stgit@toke.dk> <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 20:57:52 +0200
Message-ID: <875zkgobf3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 22, 2019 at 9:08 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> This adds support to libbpf for setting map pinning information as part of
>> the BTF map declaration. We introduce a new pair of functions to pin and
>> unpin maps based on this setting, as well as a getter and setter function
>> for the pin information that callers can use after map load.
>>
>> The pin_type supports two modes: LOCAL pinning, which requires the caller
>> to set a pin path using bpf_object_pin_opts, and a global mode, where the
>> path can still be overridden, but defaults to /sys/fs/bpf. This is inspired
>> by the two modes supported by the iproute2 map definitions. In particular,
>> it should be possible to express the current iproute2 operating mode in
>> terms of the options introduced here.
>>
>> The new pin functions will skip any maps that do not have a pinning type
>> set, unless the 'override_type' option is set, in which case all maps will
>> be pinning using the pin type set in that option. This also makes it
>> possible to express the old pin_maps and unpin_maps functions in terms of
>> the new option-based functions.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>
> So few high-level thoughts.
>
> 1. I'd start with just NONE and GLOBAL as two pinning modes. It might
> be worth-while to name GLOBAL something different just to specify that
> it is just pinning, either to default /sys/fs/bpf root or some other
> user-provided root path.
> 1a. LOCAL seems to behave exactly like GLOBAL, just uses separate
> option for a path. So we effectively have two GLOBAL modes, one with
> default (but overrideable) /sys/fs/bpf, another with user-provided
> mandatory path. The distinction seem rather small and arbitrary.
> What's the use case?

Supporting iproute2, mostly :)

Don't terribly mind dropping LOCAL, though; I don't have any particular
use case in mind for it myself.

> 2. When is pin type override useful? Either specify it once
> declaratively in map definition, or just do pinning programmatically?

Dunno if it's really useful, actually. 

> 3. I think we should make pinning path override into
> bpf_object_open_opts and keep bpf_object__pin_maps simple. We are
> probably going to make map pinning/sharing automatic anyway, so that
> will need to happen as part of either open or load operation.

I actually started with just writing automatic map pinning logic for
open(), but found myself re-implementing most of the logic in map_pin().
So figured I might as well expose it to that as well.

For open/load I think the logic should be that we parse the pinning
attribute on open and set map->pin_path from that. Then load() looks at
pin_path and does the reuse/create dance. That way, an application can
set its own pin_paths between open and load to support legacy formats
(like iproute2 needs to).

> 4. Once pinned, map knows its pinned path, just use that, I don't see
> any reasonable use case where you'd want to override path just for
> unpinning.

Well, unpinning may need to re-construct the pin path. E.g.,
applications that exit after loading and are re-run after unloading,
such as iproute2, probably want to be able to unpin maps. Unfortunately
I don't think there is a way to get the pin path(s) of an object from
the kernel, though, is there? That would be kinda neat for implementing
something like `ip link set dev eth0 xdp off unpin`.

> Does it make sense?
>
>>  tools/lib/bpf/bpf_helpers.h |    8 +++
>>  tools/lib/bpf/libbpf.c      |  123 ++++++++++++++++++++++++++++++++++++-------
>>  tools/lib/bpf/libbpf.h      |   33 ++++++++++++
>>  tools/lib/bpf/libbpf.map    |    4 +
>>  4 files changed, 148 insertions(+), 20 deletions(-)
>>
>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>> index 2203595f38c3..a23cf55d41b1 100644
>> --- a/tools/lib/bpf/bpf_helpers.h
>> +++ b/tools/lib/bpf/bpf_helpers.h
>> @@ -38,4 +38,12 @@ struct bpf_map_def {
>>         unsigned int map_flags;
>>  };
>>
>> +enum libbpf_pin_type {
>> +       LIBBPF_PIN_NONE,
>> +       /* PIN_LOCAL: pin maps by name in path specified by caller */
>> +       LIBBPF_PIN_LOCAL,
>
> Daniel mentioned in previous discussions that LOCAL mode is never
> used. I'd like to avoid supporting unnecessary stuff. Is it really
> useful?

Oh, he did? In that case, let's definitely get rid of it :)

>> +       /* PIN_GLOBAL: pin maps by name in global path (/sys/fs/bpf by default) */
>> +       LIBBPF_PIN_GLOBAL,
>> +};
>> +
>>  #endif
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index b4fdd8ee3bbd..aea3916de341 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -226,6 +226,7 @@ struct bpf_map {
>>         void *priv;
>>         bpf_map_clear_priv_t clear_priv;
>>         enum libbpf_map_type libbpf_type;
>> +       enum libbpf_pin_type pinning;
>>         char *pin_path;
>>  };
>>
>> @@ -1270,6 +1271,22 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>>                         }
>>                         map->def.value_size = sz;
>>                         map->btf_value_type_id = t->type;
>> +               } else if (strcmp(name, "pinning") == 0) {
>> +                       __u32 val;
>> +
>> +                       if (!get_map_field_int(map_name, obj->btf, def, m,
>> +                                              &val))
>> +                               return -EINVAL;
>> +                       pr_debug("map '%s': found pinning = %u.\n",
>> +                                map_name, val);
>> +
>> +                       if (val && val != LIBBPF_PIN_LOCAL &&
>> +                           val != LIBBPF_PIN_GLOBAL) {
>
> let's write out LIBBPF_PIN_NONE explicitly, instead of just `val`?

OK.

>> +                               pr_warning("map '%s': invalid pinning value %u.\n",
>> +                                          map_name, val);
>> +                               return -EINVAL;
>> +                       }
>> +                       map->pinning = val;
>>                 } else {
>>                         if (strict) {
>>                                 pr_warning("map '%s': unknown field '%s'.\n",
>> @@ -4055,10 +4072,51 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
>>         return 0;
>>  }
>>
>> -int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>> +static int get_pin_path(char *buf, size_t buf_len,
>> +                       struct bpf_map *map, struct bpf_object_pin_opts *opts,
>> +                       bool mkdir)
>> +{
>> +       enum libbpf_pin_type type;
>> +       const char *path;
>> +       int err, len;
>> +
>> +       type = OPTS_GET(opts, override_type, 0) ?: map->pinning;
>> +
>> +       if (type == LIBBPF_PIN_GLOBAL) {
>> +               path = OPTS_GET(opts, path_global, NULL);
>> +               if (!path)
>> +                       path = "/sys/fs/bpf";
>> +       } else if (type == LIBBPF_PIN_LOCAL) {
>> +               path = OPTS_GET(opts, path_local, NULL);
>> +               if (!path) {
>> +                       pr_warning("map '%s' set pinning to PIN_LOCAL, "
>> +                                  "but no local path provided. Skipping.\n",
>> +                                  bpf_map__name(map));
>> +                       return 0;
>> +               }
>> +       } else {
>> +               return 0;
>> +       }
>> +
>> +       if (mkdir) {
>> +               err = make_dir(path);
>> +               if (err)
>> +                       return err;
>> +       }
>> +
>> +       len = snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(map));
>> +       if (len < 0)
>> +               return -EINVAL;
>> +       else if (len >= buf_len)
>> +               return -ENAMETOOLONG;
>> +       return len;
>> +}
>> +
>> +int bpf_object__pin_maps_opts(struct bpf_object *obj,
>> +                             struct bpf_object_pin_opts *opts)
>>  {
>>         struct bpf_map *map;
>> -       int err;
>> +       int err, len;
>>
>>         if (!obj)
>>                 return -ENOENT;
>> @@ -4068,21 +4126,17 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>>                 return -ENOENT;
>>         }
>>
>> -       err = make_dir(path);
>> -       if (err)
>> -               return err;
>> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
>> +               return -EINVAL;
>>
>>         bpf_object__for_each_map(map, obj) {
>>                 char buf[PATH_MAX];
>> -               int len;
>>
>> -               len = snprintf(buf, PATH_MAX, "%s/%s", path,
>> -                              bpf_map__name(map));
>> -               if (len < 0) {
>> -                       err = -EINVAL;
>> -                       goto err_unpin_maps;
>> -               } else if (len >= PATH_MAX) {
>> -                       err = -ENAMETOOLONG;
>> +               len = get_pin_path(buf, PATH_MAX, map, opts, true);
>> +               if (len == 0) {
>> +                       continue;
>> +               } else if (len < 0) {
>> +                       err = len;
>>                         goto err_unpin_maps;
>>                 }
>>
>> @@ -4104,7 +4158,16 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>>         return err;
>>  }
>>
>> -int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>> +int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>> +{
>> +       LIBBPF_OPTS(bpf_object_pin_opts, opts,
>> +                   .path_global = path,
>> +                   .override_type = LIBBPF_PIN_GLOBAL);
>
> style nit: extra line between declaration and statements
>
>> +       return bpf_object__pin_maps_opts(obj, &opts);
>> +}
>> +
>> +int bpf_object__unpin_maps_opts(struct bpf_object *obj,
>> +                             struct bpf_object_pin_opts *opts)
>>  {
>>         struct bpf_map *map;
>>         int err;
>> @@ -4112,16 +4175,18 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>>         if (!obj)
>>                 return -ENOENT;
>>
>> +       if (!OPTS_VALID(opts, bpf_object_pin_opts))
>> +               return -EINVAL;
>
> specifying pin options for unpin operation looks cumbersome. We know
> the pinned path, just use that and keep unpinning simple?

You are right, but see above re: recreating pin paths on re-run.

-Toke
