Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E1176655
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 22:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCBVp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 16:45:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21684 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726720AbgCBVp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 16:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583185555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7pvj7+126Q/TbyNuhXK/upsQEitIpDOYMKc9lbL5EvE=;
        b=GtUZ96Zloeuh76M5flOPIWdGyKvM9Sr5U14dUGnugpGH/4DCwZpVGslHZ+86oRQVB4MVPn
        mkRUFslBdgh2Cl7AnlUbYfPqQ2Rsc/CrmykWuAo2VpVhCjQY7cbAfxPXoTvI7aIZP1BBEj
        ckrCFG8KJSkgYL57jBDfNmkbv+QQL0s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-15eRi8ozPmyD8bQOp8pLHA-1; Mon, 02 Mar 2020 16:45:53 -0500
X-MC-Unique: 15eRi8ozPmyD8bQOp8pLHA-1
Received: by mail-wm1-f69.google.com with SMTP id c5so246872wmd.8
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 13:45:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7pvj7+126Q/TbyNuhXK/upsQEitIpDOYMKc9lbL5EvE=;
        b=cL+mFRHDPhaLxSyC7+aV+U1wPrDtLW/JnNk+rtyVv73WU4452xwa7QoQWXF4e5wfW8
         L8A8SsP1IaNtmUavbEfZW+Yc9+mvMefrrGRdBi7d9lA9rq1KNpkpJeVQJFWMQDWygQyL
         s/8ROdCUbZnvQkwo7jYgPDgv3IcdpndmuHumkl3OAm3Sv5SRUFtbxcKmiOYO1Xyf4gHG
         h6teczCyIC95Sum7V47yc5AQxmhsdvdh4QO1giKVa6EcntjRKBTqn988RpRLCR77RX00
         qOvkbm4Zlb0UBCB7+HyFdY6Bn30qdtprPCUvVUOGcjZ1bslyTa3cGGsBiJOzZKyUSd/W
         i4jw==
X-Gm-Message-State: ANhLgQ2GiJ67IP9sRon2cKGwvD29JYe36Xjl7D1cSmpU3GeVwx1qPkrz
        w0ePqTGKzQc15qC/h5FwLGQT5MxK+sEV8IbMIa/6rzJyvpIz5Vow8AHJbXAsUxSg+2bHQm/NCrq
        B7jIpcYBM+Bw04whk
X-Received: by 2002:a7b:c344:: with SMTP id l4mr406190wmj.25.1583185552471;
        Mon, 02 Mar 2020 13:45:52 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuJ/TnUUxhSZAMYvTJgi7imoOHF41pUQ2QW3Ttf7BSx/ztq2AtPsw0wX1n6FlZtAKDl3PQMXg==
X-Received: by 2002:a7b:c344:: with SMTP id l4mr406177wmj.25.1583185552174;
        Mon, 02 Mar 2020 13:45:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z14sm30292564wru.31.2020.03.02.13.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 13:45:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B4C85180362; Mon,  2 Mar 2020 22:45:50 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: add bpf_link pinning/unpinning
In-Reply-To: <CAEf4BzakHPjOHcyf=idh+kMUVhk0jr=Zqd2px8vfxU5N1MV3Rg@mail.gmail.com>
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-3-andriin@fb.com> <87h7z7t620.fsf@toke.dk> <CAEf4BzakHPjOHcyf=idh+kMUVhk0jr=Zqd2px8vfxU5N1MV3Rg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 22:45:50 +0100
Message-ID: <87o8tesa5t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Mar 2, 2020 at 2:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > With bpf_link abstraction supported by kernel explicitly, add
>> > pinning/unpinning API for links. Also allow to create (open) bpf_link =
from BPF
>> > FS file.
>> >
>> > This API allows to have an "ephemeral" FD-based BPF links (like raw tr=
acepoint
>> > or fexit/freplace attachments) surviving user process exit, by pinning=
 them in
>> > a BPF FS, which is an important use case for long-running BPF programs.
>> >
>> > As part of this, expose underlying FD for bpf_link. While legacy bpf_l=
ink's
>> > might not have a FD associated with them (which will be expressed as
>> > a bpf_link with fd=3D-1), kernel's abstraction is based around FD-base=
d usage,
>> > so match it closely. This, subsequently, allows to have a generic
>> > pinning/unpinning API for generalized bpf_link. For some types of bpf_=
links
>> > kernel might not support pinning, in which case bpf_link__pin() will r=
eturn
>> > error.
>> >
>> > With FD being part of generic bpf_link, also get rid of bpf_link_fd in=
 favor
>> > of using vanialla bpf_link.
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> > ---
>> >  tools/lib/bpf/libbpf.c   | 131 +++++++++++++++++++++++++++++++--------
>> >  tools/lib/bpf/libbpf.h   |   5 ++
>> >  tools/lib/bpf/libbpf.map |   5 ++
>> >  3 files changed, 114 insertions(+), 27 deletions(-)
>> >
>> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > index 996162801f7a..f8c4042e5855 100644
>> > --- a/tools/lib/bpf/libbpf.c
>> > +++ b/tools/lib/bpf/libbpf.c
>> > @@ -6931,6 +6931,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_lo=
ad_attr *attr,
>> >  struct bpf_link {
>> >       int (*detach)(struct bpf_link *link);
>> >       int (*destroy)(struct bpf_link *link);
>> > +     char *pin_path;         /* NULL, if not pinned */
>> > +     int fd;                 /* hook FD, -1 if not applicable */
>> >       bool disconnected;
>> >  };
>> >
>> > @@ -6960,26 +6962,109 @@ int bpf_link__destroy(struct bpf_link *link)
>> >               err =3D link->detach(link);
>> >       if (link->destroy)
>> >               link->destroy(link);
>> > +     if (link->pin_path)
>> > +             free(link->pin_path);
>>
>> This will still detach the link even if it's pinned, won't it? What's
>
> No, this will just free pin_path string memory.

I meant the containing function; i.e., link->detach() call above will
close the fd.

>> the expectation, that the calling application just won't call
>> bpf_link__destroy() if it pins the link? But then it will leak memory?
>> Or is it just that __destroy() will close the fd, but if it's pinned the
>> kernel won't actually detach anything? In that case, it seems like the
>> function name becomes somewhat misleading?
>
> Yes, the latter, it will close its own FD, but if someone else has
> open other FD against the same bpf_link (due to pinning or if you
> shared FD with child process, etc), then kernel will keep it.
> bpf_link__destroy() is more of a "sever the link my process has" or
> "destroy my local link". Maybe not ideal name, but should be close
> enough, I think.

Hmm, yeah, OK, I guess I can live with it ;)

-Toke

