Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D502E64D5B0
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 04:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiLODs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 22:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLODsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 22:48:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A12E55A9A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 19:48:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fy4so9166663pjb.0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 19:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnul5VTYkXHwvriv1EmZ2nafdK1nNjiRNk+R2S7uLwM=;
        b=eRBFc6BBcLOCzgCHzVu9OnZWJ8XlA0RAc5MeDxVw72AKGn5a16GakmCaJ4Z0Wnqq8a
         +J8p7I7DDhBSOayHF6WvoIzx3GurPq0kB9VFhSZHEdKo0AA9nqqFwEij+f7Rc1vFkTPU
         hW5JOd6WlWmEZejNbhLJJYkTqrTzDx3YNiZTC3w6/UrPzVXmTQ0L9LcEpF2qU6paTDh6
         carWK0clTbd3JokToT7vlT3BxuJbV4k/euuBCxL1VUcmdcFBQK/7o252c2u4PPPf5LZE
         PWYD5DNWRur+y5ANlELfWTgM/OBDS59D5iTV0bLIISebcTLnYTu4LYaNWEQVeuxfzaKB
         UPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnul5VTYkXHwvriv1EmZ2nafdK1nNjiRNk+R2S7uLwM=;
        b=i8DUoDWNLWfq/5Via+w5wrNlUhjj/2mSqsvZmN5tDDbcXps21307Zrkq5/xtMGgQTh
         nw8C3LVbuLJ9XbIP4nov3d36spq0TLFC9KvP4jOIndW2F/MKSsm6xkL4NzRZOHxljSRG
         y6y0zngGKvnKQR4bJPcFy1MURBNLORqq2Mz6nAkaahSypWC2fXzPaXIMjc0b/OZ2V86Y
         V08vITGTTMs5SLycJ/blq/FrgidM6HhvNIxt7xh35+ZROdPnF4asQ6b5Iar4HeRpG3ul
         OiHA/2A24YmNwGxSqSsdR/ve2lfWDOtWiFKgGAjtOSkWRF0OKiPrqlS7aQvbw3+dHFbz
         Of5A==
X-Gm-Message-State: AFqh2kr95m+XgQw3bIQpzuBfEevB+sihpwWfYm5fF/2Mj+/QB6Mr88d8
        swzfeggZClsK7YDpbZ7/kObt2LnGNBdZtOVVtEOwXA==
X-Google-Smtp-Source: AMrXdXuYpZipRrMYFz4Y87dPivngY2R/EOxE9yCQKMxVPVGXMKJA8g/l4JIZYdBVRK0yh2vY2wfFmmGLx69pgAeECcs=
X-Received: by 2002:a17:90a:6090:b0:218:9107:381b with SMTP id
 z16-20020a17090a609000b002189107381bmr62020pji.75.1671076128610; Wed, 14 Dec
 2022 19:48:48 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-2-sdf@google.com>
 <Y5iqTKnhtX2yaSAq@maniforge.lan> <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
 <87fsdigtow.fsf@toke.dk> <CAKH8qBuv0pZUT-w3LVKoss6XixdNP9cbZpxe9UWghdpbWDXtgA@mail.gmail.com>
 <87r0x1eegg.fsf@toke.dk>
In-Reply-To: <87r0x1eegg.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Dec 2022 19:48:36 -0800
Message-ID: <CAKH8qBuCwxiCPLmH9xzfG+C39GUEHFcC4h45DLZVJ9V1bsJnRA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 01/15] bpf: Document XDP RX metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Vernet <void@manifault.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 3:46 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Wed, Dec 14, 2022 at 2:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > On Tue, Dec 13, 2022 at 8:37 AM David Vernet <void@manifault.com> wr=
ote:
> >> >>
> >> >> On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
> >> >> > Document all current use-cases and assumptions.
> >> >> >
> >> >> > Cc: John Fastabend <john.fastabend@gmail.com>
> >> >> > Cc: David Ahern <dsahern@gmail.com>
> >> >> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >> >> > Cc: Jakub Kicinski <kuba@kernel.org>
> >> >> > Cc: Willem de Bruijn <willemb@google.com>
> >> >> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >> >> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >> >> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >> >> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >> >> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> >> >> > Cc: xdp-hints@xdp-project.net
> >> >> > Cc: netdev@vger.kernel.org
> >> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> >> > ---
> >> >> >  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++=
++++++
> >> >> >  1 file changed, 90 insertions(+)
> >> >> >  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
> >> >> >
> >> >> > diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentatio=
n/bpf/xdp-rx-metadata.rst
> >> >> > new file mode 100644
> >> >> > index 000000000000..498eae718275
> >> >> > --- /dev/null
> >> >> > +++ b/Documentation/bpf/xdp-rx-metadata.rst
> >> >>
> >> >> I think you need to add this to Documentation/bpf/index.rst. Or eve=
n
> >> >> better, maybe it's time to add an xdp/ subdirectory and put all doc=
s
> >> >> there? Don't want to block your patchset from bikeshedding on this
> >> >> point, so for now it's fine to just put it in
> >> >> Documentation/bpf/index.rst until we figure that out.
> >> >
> >> > Maybe let's put it under Documentation/networking/xdp-rx-metadata.rs=
t
> >> > and reference form Documentation/networking/index.rst? Since it's mo=
re
> >> > relevant to networking than the core bpf?
> >> >
> >> >> > @@ -0,0 +1,90 @@
> >> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >> > +XDP RX Metadata
> >> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >> > +
> >> >> > +XDP programs support creating and passing custom metadata via
> >> >> > +``bpf_xdp_adjust_meta``. This metadata can be consumed by the fo=
llowing
> >> >> > +entities:
> >> >>
> >> >> Can you add a couple of sentences to this intro section that explai=
ns
> >> >> what metadata is at a high level?
> >> >
> >> > I'm gonna copy-paste here what I'm adding, feel free to reply back i=
f
> >> > still unclear. (so we don't have to wait another week to discuss the
> >> > changes)
> >> >
> >> > XDP programs support creating and passing custom metadata via
> >> > ``bpf_xdp_adjust_meta``. The metadata can contain some extra informa=
tion
> >> > about the packet: timestamps, hash, vlan and tunneling information, =
etc.
> >> > This metadata can be consumed by the following entities:
> >>
> >> This is not really accurate, though? The metadata area itself can
> >> contain whatever the XDP program wants it to, and I think you're
> >> conflating the "old" usage for arbitrary storage with the driver-kfunc
> >> metadata support.
> >>
> >> I think we should clear separate the two: the metadata area is just a
> >> place to store data (and is not consumed by the stack, except that
> >> TC-BPF programs can access it), and the driver kfuncs are just a gener=
al
> >> way to get data out of the drivers (and has nothing to do with the
> >> metadata area, you can just get the data into stack variables).
> >>
> >> While it would be good to have a documentation of the general metadata
> >> area stuff somewhere, I don't think it necessarily have to be part of
> >> this series, so maybe just stick to documenting the kfuncs?
> >
> > Maybe I can reword to something like below?
> >
> > The metadata can be used to store some extra information about the
> > packet timestamps, hash, vlan and tunneling information, etc.
> >
> > This way we are not actually defining what it is, but hinting about
> > how it's commonly used?
>
> Sent another reply to the original patch with some comments that are
> hopefully a bit more constructive :)

Thanks, everything makes sense, will incorporate. I'll also try to
share the patches privately with you sometime tomorrow maybe; not
super comfortable sending them out with a bunch of changes on top of
your authorship without some kind of ack from you :-)

> -Toke
>
