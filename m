Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414D5E0C38
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbfJVTGh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 15:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732548AbfJVTGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 15:06:37 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C627C0495A3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 19:06:36 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id m8so3180645ljb.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 12:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gkCyI7c3Dm5vCpaFLFMxereqM0ZHi4Z6K/iP/5+eRD0=;
        b=KP4RTAch9SGqbf+93iKuwwpkhsWiFLJdV5ojMXXqwRsGgNUlLQ+2GZyFb2RH62VGSL
         fQ+qiJchBdq376rbDuUMm9fuzTueb3T6Dn6JCSPcK5Bu3e/t/TgT8edWjO1/QbR9bTVH
         qJc6A3ZhEBCFZpCd72AUd+uwIqRRiAj9gV807DUsORxnOO7o2MgqClORBY4FJT0Asa7i
         QjzNjuLBzpBePwitQk6PW/NW5Rh4wGD5XptEc5aLOSwdXg/8VHQ6WKQR0C3jikIkrHBz
         aOEmfppGNladCLnublxlYj025lx95D4jQym8Jwe6sCMVpmsOy3uddikoRnKU293dRWs8
         hjEw==
X-Gm-Message-State: APjAAAX/8XxU5uQtY9vsZpMyjkxoYmnlkeJCorESRNzNbpIsJESv3SAp
        u2Sta5Z89pf3yS15gx6Zxfr2yIpD98cbKvjpsXBq+5BoILjP8izOVu6i4/uTT6LhQxVQC7YcRGI
        aukM9c+I+X2aXyZe2
X-Received: by 2002:ac2:5dc1:: with SMTP id x1mr9187238lfq.115.1571771193929;
        Tue, 22 Oct 2019 12:06:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQuxDvXa8qbbbkJAInb2pCS0/Oy5vYL6FcobK1vR7Ysaj1jwe3j1+sEmybP1r5XfITi5BUbA==
X-Received: by 2002:ac2:5dc1:: with SMTP id x1mr9187229lfq.115.1571771193679;
        Tue, 22 Oct 2019 12:06:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id s7sm7912892ljs.16.2019.10.22.12.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:06:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4C5321804B1; Tue, 22 Oct 2019 21:06:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: Store map pin path in struct bpf_map
In-Reply-To: <CAEf4BzboV_84iZNf8HnAOOU=jDnC8+5pYaPDsQUAfV-oGc_4fg@mail.gmail.com>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668879.112621.10917994557478417780.stgit@toke.dk> <CAEf4BzatAgkOiS2+EpauWsUWymmjM4YRBJcSqYj15Ywk8aP6Lw@mail.gmail.com> <87blu8odhf.fsf@toke.dk> <CAEf4BzapbVb=u_GPLSv-KEctwZz=K3FUb_B6p2HmWnqz06n4Rg@mail.gmail.com> <878spcoc0i.fsf@toke.dk> <CAEf4BzboV_84iZNf8HnAOOU=jDnC8+5pYaPDsQUAfV-oGc_4fg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 21:06:32 +0200
Message-ID: <87zhhsmwg7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 22, 2019 at 11:45 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Tue, Oct 22, 2019 at 11:13 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Tue, Oct 22, 2019 at 9:08 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >> >>
>> >> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> >>
>> >> >> When pinning a map, store the pin path in struct bpf_map so it can be
>> >> >> re-used later for un-pinning. This simplifies the later addition of per-map
>> >> >> pin paths.
>> >> >>
>> >> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> >> ---
>> >> >>  tools/lib/bpf/libbpf.c |   19 ++++++++++---------
>> >> >>  1 file changed, 10 insertions(+), 9 deletions(-)
>> >> >>
>> >> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> >> >> index cccfd9355134..b4fdd8ee3bbd 100644
>> >> >> --- a/tools/lib/bpf/libbpf.c
>> >> >> +++ b/tools/lib/bpf/libbpf.c
>> >> >> @@ -226,6 +226,7 @@ struct bpf_map {
>> >> >>         void *priv;
>> >> >>         bpf_map_clear_priv_t clear_priv;
>> >> >>         enum libbpf_map_type libbpf_type;
>> >> >> +       char *pin_path;
>> >> >>  };
>> >> >>
>> >> >>  struct bpf_secdata {
>> >> >> @@ -1929,6 +1930,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
>> >> >>         if (err)
>> >> >>                 goto err_close_new_fd;
>> >> >>         free(map->name);
>> >> >> +       zfree(&map->pin_path);
>> >> >>
>> >> >
>> >> > While you are touching this function, can you please also fix error
>> >> > handling in it? We should store -errno locally on error, before we
>> >> > call close() which might change errno.
>> >>
>> >> Didn't actually look much at the surrounding function, TBH. I do expect
>> >> that I will need to go poke into this for the follow-on "automatic reuse
>> >> of pinned maps" series anyway. But sure, I can do a bit of cleanup in a
>> >> standalone patch first :)
>> >>
>> >> >>         map->fd = new_fd;
>> >> >>         map->name = new_name;
>> >> >> @@ -4022,6 +4024,7 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
>> >> >>                 return -errno;
>> >> >>         }
>> >> >>
>> >> >> +       map->pin_path = strdup(path);
>> >> >
>> >> > if (!map->pin_path) {
>> >> >     err = -errno;
>> >> >     goto err_close_new_fd;
>> >> > }
>> >>
>> >> Right.
>> >>
>> >> >>         pr_debug("pinned map '%s'\n", path);
>> >> >>
>> >> >>         return 0;
>> >> >> @@ -4031,6 +4034,9 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
>> >> >>  {
>> >> >>         int err;
>> >> >>
>> >> >> +       if (!path)
>> >> >> +               path = map->pin_path;
>> >> >
>> >> > This semantics is kind of weird. Given we now remember pin_path,
>> >> > should we instead check that user-provided path is actually correct
>> >> > and matches what we stored? Alternatively, bpf_map__unpin() w/o path
>> >> > argument looks like a cleaner API.
>> >>
>> >> Yeah, I guess the function without a path argument would make the most
>> >> sense. However, we can't really change the API of bpf_map__unpin()
>> >> (unless you're proposing a symbol-versioned new version?). Dunno if it's
>> >> worth it to include a new, somewhat oddly-named, function to achieve
>> >> this? For the internal libbpf uses at least it's easy enough for the
>> >> caller to just go bpf_map__unpin(map, map->pin_path), so I could also
>> >> just drop this change? WDYT?
>> >
>> > I'd probably do strcmp(map->pin_path, path), if path is specified.
>> > This will support existing use cases, will allow NULL if we don't want
>> > to bother remembering pin_path, will prevent weird use case of pinning
>> > to one path, but unpinning another one.
>>
>> So something like
>>
>> if (path && map->pin_path && strcmp(path, map->pin_path))
>
> can we unpin not pinned map? sounds like an error condition?

See my other comment about programs exiting. For an example, see the XDP
tutorial (just pretend for a moment that that TODO comment was actually
there :)):

https://github.com/xdp-project/xdp-tutorial/blob/master/basic04-pinning-maps/xdp_loader.c#L135

-Toke
