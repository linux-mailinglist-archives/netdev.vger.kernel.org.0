Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27920EB69C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfJaSGO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 31 Oct 2019 14:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53973 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaSGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 14:06:14 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EDDE83F3B
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 18:06:13 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id z8so1118142lji.12
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 11:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8K+AdVmeJn+9rY+lnSBr4s+RdzckTIT3WsorhwfNiFs=;
        b=F2+f6EZOJ4SGEQ2d3JkokvZbGCXMRUjvMnP77zrulgiswjIcwnW3BUl4PTqKmmfJSc
         yLXZ6mNUMHlZGu10bx6NkGr0gJMGQg9MXxxliLQXw4GNRD4+jF/6Jtyn8E1ooEj9+4ia
         VeGUwEI/weomuyPZ6wE5l4xv2R0oRTaUTwQ/nOYipgR7AN/QdrOCvSz+KBQdrl1MCDmB
         jg+073uryXhgmIlL2Iyh0Ju309R8CjWFnQm/qFocxDnMPf4ZAHxqnMIhOEnQVX9pRcqi
         QKw5OoL3vKJsLdVcnYeHEersb7qNywRBYGqkDRE1LOqJjypnjY7vMZTUzlZNoMxRxpXr
         JnQQ==
X-Gm-Message-State: APjAAAXCyFcBzMlTvG9nJUwE+THeREpGv/MtT+2LCgiSdKbk67ucGyri
        c/PcQgUh9tt97V0fTrle3bqi+f7ZCc3/Nv5wQL6LwZB8mo7hFmkT+Lhpw/QGQfHMVFhy26jKWfP
        lqqgVx7JJ/Ve4tYap
X-Received: by 2002:a2e:96c9:: with SMTP id d9mr4900955ljj.247.1572545172129;
        Thu, 31 Oct 2019 11:06:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqywmnGbiNWZ1sEz0T75OQo8IUWR5zj7qXk4U4xGfQ+tWNbKpgFaIVcVLpF5hCwVO+XPmlgiVg==
X-Received: by 2002:a2e:96c9:: with SMTP id d9mr4900931ljj.247.1572545171736;
        Thu, 31 Oct 2019 11:06:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id s28sm2010423lfp.92.2019.10.31.11.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 11:06:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4FAFF1818B5; Thu, 31 Oct 2019 19:06:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 4/5] libbpf: Add auto-pinning of maps when loading BPF objects
In-Reply-To: <CAEf4BzZ3Yf4fvM2bo0ES9_NzBgVdhXBkV-u4wbPGrSej+uB4Xw@mail.gmail.com>
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796671.169521.11697832576102917566.stgit@toke.dk> <CAEf4BzYsFGm4BzFxcN37KVtjS0Zw0Zgw8on9OsP4_=Stew72Nw@mail.gmail.com> <CAEf4BzZ3Yf4fvM2bo0ES9_NzBgVdhXBkV-u4wbPGrSej+uB4Xw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 19:06:10 +0100
Message-ID: <87zhhgn625.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Oct 31, 2019 at 10:37 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Tue, Oct 29, 2019 at 12:39 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >
>> > From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >
>> > This adds support to libbpf for setting map pinning information as part of
>> > the BTF map declaration, to get automatic map pinning (and reuse) on load.
>> > The pinning type currently only supports a single PIN_BY_NAME mode, where
>> > each map will be pinned by its name in a path that can be overridden, but
>> > defaults to /sys/fs/bpf.
>> >
>> > Since auto-pinning only does something if any maps actually have a
>> > 'pinning' BTF attribute set, we default the new option to enabled, on the
>> > assumption that seamless pinning is what most callers want.
>> >
>> > When a map has a pin_path set at load time, libbpf will compare the map
>> > pinned at that location (if any), and if the attributes match, will re-use
>> > that map instead of creating a new one. If no existing map is found, the
>> > newly created map will instead be pinned at the location.
>> >
>> > Programs wanting to customise the pinning can override the pinning paths
>> > using bpf_map__set_pin_path() before calling bpf_object__load() (including
>> > setting it to NULL to disable pinning of a particular map).
>> >
>> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> > ---
>>
>> Please fix unconditional pin_path setting, with that:
>>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>
>> >  tools/lib/bpf/bpf_helpers.h |    6 ++
>> >  tools/lib/bpf/libbpf.c      |  144 +++++++++++++++++++++++++++++++++++++++++--
>> >  tools/lib/bpf/libbpf.h      |   13 ++++
>> >  3 files changed, 154 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>> > index 2203595f38c3..0c7d28292898 100644
>> > --- a/tools/lib/bpf/bpf_helpers.h
>> > +++ b/tools/lib/bpf/bpf_helpers.h
>> > @@ -38,4 +38,10 @@ struct bpf_map_def {
>> >         unsigned int map_flags;
>> >  };
>> >
>>
>> [...]
>>
>> > @@ -1270,6 +1292,28 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>> >                         }
>> >                         map->def.value_size = sz;
>> >                         map->btf_value_type_id = t->type;
>> > +               } else if (strcmp(name, "pinning") == 0) {
>> > +                       __u32 val;
>> > +                       int err;
>> > +
>> > +                       if (!get_map_field_int(map_name, obj->btf, def, m,
>> > +                                              &val))
>> > +                               return -EINVAL;
>> > +                       pr_debug("map '%s': found pinning = %u.\n",
>> > +                                map_name, val);
>> > +
>> > +                       if (val != LIBBPF_PIN_NONE &&
>> > +                           val != LIBBPF_PIN_BY_NAME) {
>> > +                               pr_warn("map '%s': invalid pinning value %u.\n",
>> > +                                       map_name, val);
>> > +                               return -EINVAL;
>> > +                       }
>> > +                       err = build_map_pin_path(map, pin_root_path);
>>
>> uhm... only if (val == LIBBPF_PIN_BY_NAME)?.. maybe extend tests with
>> a mix if auto-pinned and never pinned map to catch issue like this?
>
> I was wondering why your selftest didn't catch this, got puzzled for a
> bit. It's because this code path will be executed only when map
> defintion has __uint(pinning, LIBBPF_PIN_NONE), can you please add
> that to selftest as well?

Can do :)

-Toke
