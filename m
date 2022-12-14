Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBC264CF9F
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiLNSnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiLNSnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:43:10 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E688D5F43
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:43:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id fy4so7946613pjb.0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11gnFBq5/B+6biAVW8qF16RNrVbsfKYnaU/ZjQVxwSg=;
        b=gUPlgfZnJpd00o4gzd7LSKqLT48FfcnBbc/M6xdwTdHKeeGLYveYNUvJCR22pieC83
         3vq7BS6ZZmkGT7DoTucMHo4jst548PqaCTvKBes56fqboWoU+ydn15qfpl1M0w7E5Pbh
         NfJFhxaMCm0WUNsZvrU/rcesWVahdyiwNedMvl09dY42Uarhs9hqSptDFaxlwYOpneEq
         YCQ2tCdl2ysTA0wSj1gN3is0HR27fS+l+PovZWo70RK8NFe0QjECNSYtPH7jHgPyD4SQ
         QpVS6uekED33vl18nVJ03Jimm+iWbvOYYWnOoCgu6WPotn9MdXj60SSD3Vu8yxVf6+us
         IDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11gnFBq5/B+6biAVW8qF16RNrVbsfKYnaU/ZjQVxwSg=;
        b=fMjSyFCyfR/snAjbOvxoSwA6u1gIrN6ZL2War96tDvUdL9ZsdIpd1eMInKgOAH2qH0
         BFyCefyYJZDbgXgFR7HZxqJNUqF/Z0RWadWR71Syci4XAs2tDLUTe6AenuiW7vNp66FO
         1w8qwKfU3Lj31ChB378QORUaIXTM9xJbr3ZkjTflHCZXug/ezXtW77cSYXU0bofZraXl
         wod+xu/0hLZ4D3QV7iG6NGpcIEd3uKta+d5qz6Ka/hsvxt8CGMPiLCOdpFOnFmeY16tG
         lSK9/e8DeB76ZniPLDZAuxBIVdlaJoa9dBOzkKLljz3S4icWJx4G+9851OJHSfs4A5if
         xuxw==
X-Gm-Message-State: AFqh2kpmjnesu4cJNXjt6U4sQotWh+18ZkAZpWmo1INywlZgTlXrsV3E
        O9NW65ojeyNDgTuFlqEsQkIDi2toFdtTNs7jqjttwg==
X-Google-Smtp-Source: AMrXdXuJdZAKGvf4ZH96xVGYPU6uFwCC+7t6sVlZeIeSR0k+n4pnYJV3tA4TG8LYfPQawp8d6x7R0rhg7mkCT8xQv7c=
X-Received: by 2002:a17:90a:1f82:b0:21e:df53:9183 with SMTP id
 x2-20020a17090a1f8200b0021edf539183mr385673pja.66.1671043388240; Wed, 14 Dec
 2022 10:43:08 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-2-sdf@google.com>
 <Y5iqTKnhtX2yaSAq@maniforge.lan> <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
 <87fsdigtow.fsf@toke.dk>
In-Reply-To: <87fsdigtow.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Dec 2022 10:42:56 -0800
Message-ID: <CAKH8qBuv0pZUT-w3LVKoss6XixdNP9cbZpxe9UWghdpbWDXtgA@mail.gmail.com>
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

On Wed, Dec 14, 2022 at 2:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Tue, Dec 13, 2022 at 8:37 AM David Vernet <void@manifault.com> wrote=
:
> >>
> >> On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
> >> > Document all current use-cases and assumptions.
> >> >
> >> > Cc: John Fastabend <john.fastabend@gmail.com>
> >> > Cc: David Ahern <dsahern@gmail.com>
> >> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >> > Cc: Jakub Kicinski <kuba@kernel.org>
> >> > Cc: Willem de Bruijn <willemb@google.com>
> >> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> >> > Cc: xdp-hints@xdp-project.net
> >> > Cc: netdev@vger.kernel.org
> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> > ---
> >> >  Documentation/bpf/xdp-rx-metadata.rst | 90 ++++++++++++++++++++++++=
+++
> >> >  1 file changed, 90 insertions(+)
> >> >  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
> >> >
> >> > diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/b=
pf/xdp-rx-metadata.rst
> >> > new file mode 100644
> >> > index 000000000000..498eae718275
> >> > --- /dev/null
> >> > +++ b/Documentation/bpf/xdp-rx-metadata.rst
> >>
> >> I think you need to add this to Documentation/bpf/index.rst. Or even
> >> better, maybe it's time to add an xdp/ subdirectory and put all docs
> >> there? Don't want to block your patchset from bikeshedding on this
> >> point, so for now it's fine to just put it in
> >> Documentation/bpf/index.rst until we figure that out.
> >
> > Maybe let's put it under Documentation/networking/xdp-rx-metadata.rst
> > and reference form Documentation/networking/index.rst? Since it's more
> > relevant to networking than the core bpf?
> >
> >> > @@ -0,0 +1,90 @@
> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > +XDP RX Metadata
> >> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > +
> >> > +XDP programs support creating and passing custom metadata via
> >> > +``bpf_xdp_adjust_meta``. This metadata can be consumed by the follo=
wing
> >> > +entities:
> >>
> >> Can you add a couple of sentences to this intro section that explains
> >> what metadata is at a high level?
> >
> > I'm gonna copy-paste here what I'm adding, feel free to reply back if
> > still unclear. (so we don't have to wait another week to discuss the
> > changes)
> >
> > XDP programs support creating and passing custom metadata via
> > ``bpf_xdp_adjust_meta``. The metadata can contain some extra informatio=
n
> > about the packet: timestamps, hash, vlan and tunneling information, etc=
.
> > This metadata can be consumed by the following entities:
>
> This is not really accurate, though? The metadata area itself can
> contain whatever the XDP program wants it to, and I think you're
> conflating the "old" usage for arbitrary storage with the driver-kfunc
> metadata support.
>
> I think we should clear separate the two: the metadata area is just a
> place to store data (and is not consumed by the stack, except that
> TC-BPF programs can access it), and the driver kfuncs are just a general
> way to get data out of the drivers (and has nothing to do with the
> metadata area, you can just get the data into stack variables).
>
> While it would be good to have a documentation of the general metadata
> area stuff somewhere, I don't think it necessarily have to be part of
> this series, so maybe just stick to documenting the kfuncs?

Maybe I can reword to something like below?

The metadata can be used to store some extra information about the
packet timestamps, hash, vlan and tunneling information, etc.

This way we are not actually defining what it is, but hinting about
how it's commonly used?

> -Toke
>
