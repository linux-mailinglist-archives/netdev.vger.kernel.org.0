Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B214BE83B4
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbfJ2JBW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Oct 2019 05:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfJ2JBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 05:01:22 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF77AA89F
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 09:01:20 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id m24so2578574lfh.22
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 02:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BJ76pg2uX4U1ICAWyx8k7OY4MUZ3Ob5wkJjg2vqv5Jw=;
        b=IbUQdvFNpVMLwL00zc/Qvxw8JVJp8O8o3q9gWolkkEL8u5Zq+xWuH4UZPaTcTswiIR
         4KXCz9pXUQ2Unvy/wfkxQEqmIZr3GoQr30oM3qh9zLxjCBul4ql/aX4gWQ8p+qmHLh1k
         3HhbkNA1ZE8ixoR/AQvUMVABZsTSieWDYuZ0ZGMYBb09LQlDaKnJjC9N7leOMGhxL8bQ
         THLMwTjVu/aaj5n8tjplyEt9Kcbyw+7hI2OPY2spLEj8SVVAp488I1t1Huyu3G2L+gVs
         m4ZEU7E5/CMEtP6e1WFaIJUla8RlPn2hqCUBWgh2TmNxnRZfSfAFFaVEXkXB+cLKg0UH
         eyrg==
X-Gm-Message-State: APjAAAWMEYbpKYUep8ZpuHc2F1sDFuzf0m/yQF0Mos9RP2TULU84/Oti
        2gqBItl2umdLDG5/4Ue2ErkGNiDu8ZWr0PlnyTX3kEWoJNyEo8r2Apv49LNhpZxMWSDPBhCZo7r
        NOrdfMM1922piMiaS
X-Received: by 2002:a05:651c:293:: with SMTP id b19mr1660778ljo.176.1572339679284;
        Tue, 29 Oct 2019 02:01:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwfONTDGnD2KLmRKW6P7REsWNp71d0T5NA6iVQBZrxlv6JhrXkBXhHu1GzJ+byyYAkdNee1Pw==
X-Received: by 2002:a05:651c:293:: with SMTP id b19mr1660760ljo.176.1572339679001;
        Tue, 29 Oct 2019 02:01:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g5sm6662983ljk.22.2019.10.29.02.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 02:01:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5ADCE1818B6; Tue, 29 Oct 2019 10:01:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 2/4] libbpf: Store map pin path and status in struct bpf_map
In-Reply-To: <CAEf4Bzb-CewiZhsGEmSNSCGHLKQiXFO3gS+cJgD1Tx_L_gpiMg@mail.gmail.com>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959765.48922.14916417301812812065.stgit@toke.dk> <CAEf4Bzb-CewiZhsGEmSNSCGHLKQiXFO3gS+cJgD1Tx_L_gpiMg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Oct 2019 10:01:17 +0100
Message-ID: <87a79krkma.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, Oct 27, 2019 at 1:53 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> Support storing and setting a pin path in struct bpf_map, which can be used
>> for automatic pinning. Also store the pin status so we can avoid attempts
>> to re-pin a map that has already been pinned (or reused from a previous
>> pinning).
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----------
>>  tools/lib/bpf/libbpf.h   |    3 +
>>  tools/lib/bpf/libbpf.map |    3 +
>>  3 files changed, 97 insertions(+), 24 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index ce5ef3ddd263..eb1c5e6ad4a3 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -226,6 +226,8 @@ struct bpf_map {
>>         void *priv;
>>         bpf_map_clear_priv_t clear_priv;
>>         enum libbpf_map_type libbpf_type;
>> +       char *pin_path;
>> +       bool pinned;
>>  };
>>
>>  struct bpf_secdata {
>> @@ -4025,47 +4027,118 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
>>         char *cp, errmsg[STRERR_BUFSIZE];
>>         int err;
>>
>> -       err = check_path(path);
>> -       if (err)
>> -               return err;
>> -
>>         if (map == NULL) {
>>                 pr_warn("invalid map pointer\n");
>>                 return -EINVAL;
>>         }
>>
>> -       if (bpf_obj_pin(map->fd, path)) {
>> -               cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>> -               pr_warn("failed to pin map: %s\n", cp);
>> -               return -errno;
>> +       if (map->pinned) {
>> +               pr_warn("map already pinned\n");
>
> it would be helpful to print the name of the map, otherwise user will
> have to guess

Well, the existing error message didn't include the map name, so I was
just being consistent. But sure I can change it (and the old message as
well).

>> +               return -EEXIST;
>> +       }
>> +
>> +       if (path && map->pin_path && strcmp(path, map->pin_path)) {
>> +               pr_warn("map already has pin path '%s' different from '%s'\n",
>> +                       map->pin_path, path);
>
> here pin_path probably would be unique enough, but for consistency we
> might want to print map name as well
>
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!map->pin_path && !path) {
>> +               pr_warn("missing pin path\n");
>
> and here?
>
>> +               return -EINVAL;
>>         }
>>
>> -       pr_debug("pinned map '%s'\n", path);
>> +       if (!map->pin_path) {
>> +               map->pin_path = strdup(path);
>> +               if (!map->pin_path) {
>> +                       err = -errno;
>> +                       goto out_err;
>> +               }
>> +       }
>
> There is a bit of repetition of if conditions, based on whether we
> have map->pin_path set (which is the most critical piece we care
> about), so that makes it a bit harder to follow what's going on. How
> about this structure, would it make a bit clearer what the error
> conditions are? Not insisting, though.
>
> if (map->pin_path) {
>   if (path && strcmp(...))
>     bad, exit
> else { /* no pin_path */
>   if (!path)
>     very bad, exit
>   map->pin_path = strdup(..)
>   if (!map->pin_path)
>     also bad, exit
> }

Hmm, yeah, this may be better...

>> +
>> +       err = check_path(map->pin_path);
>> +       if (err)
>> +               return err;
>> +
>
> [...]
>
>>
>> +int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
>> +{
>> +       char *old = map->pin_path, *new;
>> +
>> +       if (path) {
>> +               new = strdup(path);
>> +               if (!new)
>> +                       return -errno;
>> +       } else {
>> +               new = NULL;
>> +       }
>> +
>> +       map->pin_path = new;
>> +       if (old)
>> +               free(old);
>
> you don't really need old, just free map->pin_path before setting it
> to new. Also assigning new = NULL will simplify if above.

Right, will fix.

>> +
>> +       return 0;
>> +}
>> +
>> +const char *bpf_map__get_pin_path(struct bpf_map *map)
>> +{
>> +       return map->pin_path;
>> +}
>> +
>> +bool bpf_map__is_pinned(struct bpf_map *map)
>> +{
>> +       return map->pinned;
>> +}
>> +
>>  int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>>  {
>>         struct bpf_map *map;
>> @@ -4106,17 +4179,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>
> I might have missed something the change in some other patch, but
> shouldn't pin_maps ignore already pinned maps? Otherwise we'll be
> generating unnecessary warnings?

Well, in the previous version this was in one of the options you didn't
like. If I just change pin_maps() unconditionally, that will be a change
in behaviour in an existing API. So I figured it would be better to
leave this as-is. I don't think this function is really useful along
with the auto-pinning anyway. If you're pinning all maps, why use
auto-pinning? And if you want to do something custom to all the
non-pinned maps you'd probably iterate through them yourself anyway and
can react appropriately?

>>
>>  err_unpin_maps:
>>         while ((map = bpf_map__prev(map, obj))) {
>> -               char buf[PATH_MAX];
>> -               int len;
>> -
>> -               len = snprintf(buf, PATH_MAX, "%s/%s", path,
>> -                              bpf_map__name(map));
>> -               if (len < 0)
>> -                       continue;
>> -               else if (len >= PATH_MAX)
>> +               if (!map->pin_path)
>>                         continue;
>>
>> -               bpf_map__unpin(map, buf);
>> +               bpf_map__unpin(map, NULL);
>
> so this will unpin auto-pinned maps (from BTF-defined maps). Is that
> the desired behavior? I guess it might be ok (if you can't pin all of
> your maps, you should probably clean all of them up?), but just
> bringing it up.

Yeah, I realise that. Not entirely sure it's the right thing to do, but
there not really any way to disambiguate how the map was pinned; unless
we want to add another state field just for that? So I guess it's either
"don't do any cleanup" or just "unpin everything". And since I don't
think it'll be terribly useful to combine the use of this function with
auto-pinning anyway, I think it's probably fine to just unpin everything
here?

-Toke
