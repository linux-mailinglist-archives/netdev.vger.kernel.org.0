Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989F8261938
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgIHSLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731734AbgIHSKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:10:53 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6AEC061573;
        Tue,  8 Sep 2020 11:10:52 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p81so37140ybc.12;
        Tue, 08 Sep 2020 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wk35TRg0KarJCkBorT18pPV0KW1IK21mPUdma5sS7zA=;
        b=sjC5cL15c0YwdTtbJkcnmitN0NKT4Y8Cm++eqUlJuNf72GwLxOZvGOcSiMBNlrcvBM
         JNfsd0Cwk8wM+cwVWpGCqzGwdLelpMPhPq9mw1Hb67gA+ULvW/edCuPX7CdOhm/+2xiv
         6sgz1qC9YhHzV/vnDZkx6OQ8FEF0W6ZjXtDm4NyrPUllWUXf0JeXW620SfRvV1H7D+3W
         5955ka2sW7r7F8ztDiX57HEWzN6PZMWGLfNgTG/pN766n0zo0HTLqEuaL1pGtGdyQ6QU
         qkleTky8k84yR3PTqciBEyFgWWtEPz4+W6N58ER22/1gOSRfmuybq1ZjvHremawf+ndR
         u00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wk35TRg0KarJCkBorT18pPV0KW1IK21mPUdma5sS7zA=;
        b=ITqWKRjljOpzZge/8SLl4iaBYdTKGe/EFVwlq6xLoteIVJWSF1bhtbfRveVbvyamdq
         gXol+oWmkngi+APHIlvFx9+JTo22d4a53ipe7hC5fyd6ipEW51g4bpXKAckd0fy61FrV
         6KWthHrLnEb2Tzf/bL5Vra15HB74hzQLRbPdvBQVWoFlBwPPhlUcDdWjgTsyHXxSsvYu
         qBXUFYi3z7jhiQ6B5eIP6yIgb5j7UEZFOxO99DB8qRw5/rY13RGmoTNS1cmOdF0VkY4k
         PP8oT2oBaVgwPG788mW3qNe4QdCI2psd8A2R50p5xW76QDGYSuau/6hzxfKVXffcGy5y
         IUKQ==
X-Gm-Message-State: AOAM533LNyr1l+R/PhyJPSLZRYkTVaNBGhhDCuJuuJ3SH3bxfInKEktS
        yl+moLxJgqlZ0pRUe+XWpAd3/z2na/4Iqp3EMKM=
X-Google-Smtp-Source: ABdhPJxt3fKeoMPdw/BJfj+oqrvydTt1wNmzyDDQSOSa5L2V4KlUFx7zqXe/pCxFyyOB6j70A2oM2Vz/0W57w0b6OGY=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr140392ybe.510.1599588651271;
 Tue, 08 Sep 2020 11:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com> <87mu22ottv.fsf@toke.dk>
In-Reply-To: <87mu22ottv.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 11:10:40 -0700
Message-ID: <CAEf4BzbywFBSW+KypeWkG7CF8rNSu5XxS8HZz7BFuUsC9kZ1ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 1:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >> May be we should talk about problem statement and goals.
> >> Do we actually need metadata per program or metadata per single .o
> >> or metadata per final .o with multiple .o linked together?
> >> What is this metadata?
> >
> > Yep, that's a very valid question. I've also CC'ed Andrey.
>
> For the libxdp use case, I need metadata per program. But I'm already
> sticking that in a single section and disambiguating by struct name
> (just prefixing the function name with a _ ), so I think it's fine to
> have this kind of "concatenated metadata" per elf file and parse out the
> per-program information from that. This is similar to the BTF-encoded
> "metadata" we can do today.
>
> >> If it's just unreferenced by program read only data then no special na=
mes or
> >> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any ma=
p to any
> >> program and it would be up to tooling to decide the meaning of the dat=
a in the
> >> map. For example, bpftool can choose to print all variables from all r=
ead only
> >> maps that match "bpf_metadata_" prefix, but it will be bpftool convent=
ion only
> >> and not hard coded in libbpf.
> >
> > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> > specially, given libbpf itself doesn't care about its contents at all.
> >
> > So thanks for bringing this up, I think this is an important
> > discussion to have.
>
> I'm fine with having this be part of .rodata. One drawback, though, is
> that if any metadata is defined, it becomes a bit more complicated to
> use bpf_map__set_initial_value() because that now also has to include
> the metadata. Any way we can improve upon that?

I know that skeleton is not an answer for you, so you'll have to find
DATASEC and corresponding variable offset and size (libbpf provides
APIs for all those operations, but you'll need to combine them
together). Then mmap() map and then you can do partial updates. There
is no other way to update only portions of an ARRAY map, except
through memory-mapping.

>
> -Toke
>
