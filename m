Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96C1E8F65
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbfJ2SgR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Oct 2019 14:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbfJ2SgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 14:36:17 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 591575AFE3
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 18:36:16 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id f3so2757266lfa.16
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kd1BOd0Hbp7Czg/dVidOPyIgI3QlB5iTNf2+aaNF89s=;
        b=EVggLVWVvEqeCrKMLVVzzQTKDr0tnGSwUhc+r107jNW1ENmfMhe53AiEwGBGdZGmM+
         JBwdkd0Mgz4truhvInRED9SPxPhkqhupreYqbW3hZOZPH1amQA6oe1EacsqfDAVP2Uo5
         tGtu0RMAQbamnzKkgzvHxqWfLJ9pgmyzAaj/u4C2mF+KNNXv2GLdkH4ZSZ7rM4NQ1RfK
         az7Jw6zUz35Ml6tdhIzD1vprpSeDGBw2X6xkiS49e4u6JZr6u8cRVHHb+QyNA3DpTwzv
         iEiZUFUNtLyON+5nF+oPQeCLuLEYnZPjcRDe9vLhot2Llp9bFDtqusN+VgnpwNCO5qKa
         3b8g==
X-Gm-Message-State: APjAAAWUci/3xv8tJXDarCaF3jDRKKlTpkrLd78cIaqr0/qAhGCT3pR1
        nEUniEWomJvQH0uqs2PeL3OO44339vO9hncIibvfgLTwrJTxO74WWHgQYD0zbCH8XyYWHrWAziU
        hx4YwFRmzP4fOkQHA
X-Received: by 2002:a2e:b013:: with SMTP id y19mr3770540ljk.157.1572374174785;
        Tue, 29 Oct 2019 11:36:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2RMuOXeu2knMg5U4tdFIIFpH9ACr5uIX8glALCJnMSaOZ8rVaRDgaCCQcU9wUWmIdQfQSKQ==
X-Received: by 2002:a2e:b013:: with SMTP id y19mr3770531ljk.157.1572374174521;
        Tue, 29 Oct 2019 11:36:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id u11sm4796731lfq.54.2019.10.29.11.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 11:36:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5798C1818B6; Tue, 29 Oct 2019 19:36:12 +0100 (CET)
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
In-Reply-To: <CAEf4Bzb_FdXRo-LcgpjDqPe78hZoUkQsKZZET3HM-vZWc5SYZg@mail.gmail.com>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk> <157220959765.48922.14916417301812812065.stgit@toke.dk> <CAEf4Bzb-CewiZhsGEmSNSCGHLKQiXFO3gS+cJgD1Tx_L_gpiMg@mail.gmail.com> <87a79krkma.fsf@toke.dk> <CAEf4Bzb_FdXRo-LcgpjDqPe78hZoUkQsKZZET3HM-vZWc5SYZg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Oct 2019 19:36:12 +0100
Message-ID: <87bltzqu03.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 29, 2019 at 2:01 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Sun, Oct 27, 2019 at 1:53 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >>
>> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >>
>> >> Support storing and setting a pin path in struct bpf_map, which can be used
>> >> for automatic pinning. Also store the pin status so we can avoid attempts
>> >> to re-pin a map that has already been pinned (or reused from a previous
>> >> pinning).
>> >>
>> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> ---
>> >>  tools/lib/bpf/libbpf.c   |  115 ++++++++++++++++++++++++++++++++++++----------
>> >>  tools/lib/bpf/libbpf.h   |    3 +
>> >>  tools/lib/bpf/libbpf.map |    3 +
>> >>  3 files changed, 97 insertions(+), 24 deletions(-)
>> >>
>> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> >> index ce5ef3ddd263..eb1c5e6ad4a3 100644
>> >> --- a/tools/lib/bpf/libbpf.c
>> >> +++ b/tools/lib/bpf/libbpf.c
>> >> @@ -226,6 +226,8 @@ struct bpf_map {
>> >>         void *priv;
>> >>         bpf_map_clear_priv_t clear_priv;
>> >>         enum libbpf_map_type libbpf_type;
>> >> +       char *pin_path;
>> >> +       bool pinned;
>> >>  };
>> >>
>> >>  struct bpf_secdata {
>> >> @@ -4025,47 +4027,118 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
>> >>         char *cp, errmsg[STRERR_BUFSIZE];
>> >>         int err;
>> >>
>> >> -       err = check_path(path);
>> >> -       if (err)
>> >> -               return err;
>> >> -
>> >>         if (map == NULL) {
>> >>                 pr_warn("invalid map pointer\n");
>> >>                 return -EINVAL;
>> >>         }
>> >>
>> >> -       if (bpf_obj_pin(map->fd, path)) {
>> >> -               cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>> >> -               pr_warn("failed to pin map: %s\n", cp);
>> >> -               return -errno;
>> >> +       if (map->pinned) {
>> >> +               pr_warn("map already pinned\n");
>> >
>> > it would be helpful to print the name of the map, otherwise user will
>> > have to guess
>>
>> Well, the existing error message didn't include the map name, so I was
>> just being consistent. But sure I can change it (and the old message as
>> well).
>>
>> >> +               return -EEXIST;
>> >> +       }
>> >> +
>> >> +       if (path && map->pin_path && strcmp(path, map->pin_path)) {
>> >> +               pr_warn("map already has pin path '%s' different from '%s'\n",
>> >> +                       map->pin_path, path);
>> >
>> > here pin_path probably would be unique enough, but for consistency we
>> > might want to print map name as well
>> >
>> >> +               return -EINVAL;
>> >> +       }
>> >> +
>> >> +       if (!map->pin_path && !path) {
>> >> +               pr_warn("missing pin path\n");
>> >
>> > and here?
>> >
>> >> +               return -EINVAL;
>> >>         }
>> >>
>> >> -       pr_debug("pinned map '%s'\n", path);
>> >> +       if (!map->pin_path) {
>> >> +               map->pin_path = strdup(path);
>> >> +               if (!map->pin_path) {
>> >> +                       err = -errno;
>> >> +                       goto out_err;
>> >> +               }
>> >> +       }
>> >
>> > There is a bit of repetition of if conditions, based on whether we
>> > have map->pin_path set (which is the most critical piece we care
>> > about), so that makes it a bit harder to follow what's going on. How
>> > about this structure, would it make a bit clearer what the error
>> > conditions are? Not insisting, though.
>> >
>> > if (map->pin_path) {
>> >   if (path && strcmp(...))
>> >     bad, exit
>> > else { /* no pin_path */
>> >   if (!path)
>> >     very bad, exit
>> >   map->pin_path = strdup(..)
>> >   if (!map->pin_path)
>> >     also bad, exit
>> > }
>>
>> Hmm, yeah, this may be better...
>>
>> >> +
>> >> +       err = check_path(map->pin_path);
>> >> +       if (err)
>> >> +               return err;
>> >> +
>> >
>> > [...]
>> >
>> >>
>> >> +int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
>> >> +{
>> >> +       char *old = map->pin_path, *new;
>> >> +
>> >> +       if (path) {
>> >> +               new = strdup(path);
>> >> +               if (!new)
>> >> +                       return -errno;
>> >> +       } else {
>> >> +               new = NULL;
>> >> +       }
>> >> +
>> >> +       map->pin_path = new;
>> >> +       if (old)
>> >> +               free(old);
>> >
>> > you don't really need old, just free map->pin_path before setting it
>> > to new. Also assigning new = NULL will simplify if above.
>>
>> Right, will fix.
>>
>> >> +
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +const char *bpf_map__get_pin_path(struct bpf_map *map)
>> >> +{
>> >> +       return map->pin_path;
>> >> +}
>> >> +
>> >> +bool bpf_map__is_pinned(struct bpf_map *map)
>> >> +{
>> >> +       return map->pinned;
>> >> +}
>> >> +
>> >>  int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>> >>  {
>> >>         struct bpf_map *map;
>> >> @@ -4106,17 +4179,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>> >
>> > I might have missed something the change in some other patch, but
>> > shouldn't pin_maps ignore already pinned maps? Otherwise we'll be
>> > generating unnecessary warnings?
>>
>> Well, in the previous version this was in one of the options you didn't
>> like. If I just change pin_maps() unconditionally, that will be a change
>> in behaviour in an existing API. So I figured it would be better to
>> leave this as-is. I don't think this function is really useful along
>> with the auto-pinning anyway. If you're pinning all maps, why use
>> auto-pinning? And if you want to do something custom to all the
>> non-pinned maps you'd probably iterate through them yourself anyway and
>> can react appropriately?
>
> Auto-pinned maps didn't exist before, so interaction between
> auto-pinned and explicitly pinned maps is a new behavior.
>
> With current code using explicit pin_maps and auto-pinned maps is
> impossible, or am I missing something? While admittedly scenarios in
> which you'll have to use explicit bpf_object__pin_maps() while you
> have auto-pinned maps and bpf_map__set_pin_path() are quite exotic
> (e.g., auto-pin some maps at default path and pin all the rest at some
> other custom root), I think we should still try to make existing APIs
> combinable in some sane way.

Sure, I'm not objecting to making things play nicely with each other to
the largest extent possible. I'm just vary of changing existing
behaviour.

> The only downside of ignoring already pinned maps is that while
> previously calling pin_maps() twice in a row would fail fails second
> time, now the second pin_maps() will be a noop. I think that's benign
> and acceptable change in behavior? WDYT?

Changing something that would previously fail to just silently succeed
does make me a bit twitchy. However, I suppose that as long as we try to
make sure it really is a no-op (i.e., re-pinning a map *in the same
path* can "succeed" silently). Will try something to that effect...

-Toke
