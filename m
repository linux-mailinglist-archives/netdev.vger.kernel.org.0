Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C589D31D1F4
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhBPVST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhBPVSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:18:15 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B60CC06174A;
        Tue, 16 Feb 2021 13:17:35 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id y15so9471224ilj.11;
        Tue, 16 Feb 2021 13:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A3RpTVYaZzEschH+ErWNZmLtFHtFy1YpfdnyI7dRNvM=;
        b=JhR6CzmWqbMgdQUb8mnTrYvFnfnYWpYXH6cg+/8jeuTkYSoVXTBlYMAXWN7HhvMLpt
         qWKejbkn19wUkgNdUGToD4WF2LRRKkIy3lE7hKxqZss36aPay883mvIG1bX7Vo7DlUg5
         yOaex1RVQKlAiS518A+RdVJHnth6ycqhvwzLq/WOgGNpF+jqjlvTB+0zRWlXrWGkgGXv
         BpLik5aCMnnFJCOVfGlYc3+sZl7ePDCTdbhqim5Lz6r5/N8ANzF2GvgMF25q6yCTyl+S
         sDFfZdu8IYJ6x12JMx23hLnDYPNapVfT6KWzp4WVZMraIknwYEnHGdnA3tni9wnN2YAC
         E8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A3RpTVYaZzEschH+ErWNZmLtFHtFy1YpfdnyI7dRNvM=;
        b=ShS3m5GcxX9hOHTKPTlEhnLjY/jZwz+1pB8yAwZy0QxpOfTs+zNw8ygzgSofVoiUTw
         sX9LZ7daNuzIKEkLv2NRZK+HXKDrO1PwEvGUzFD3VxuOkgRWVCXeWHUyjCBEMhu7pGA3
         Ez7DWYrS6fwZhWteBxbAEo3OeGdHfKuaFYq+ZCQg9u0WTcho9dkmx5bXMMGXeauK93ky
         X8N+fUQkK7QGEV4t26oV7c17aHxbZA0747P013DG+aPpg/I+rGagZPKovboKiLqan+Gj
         JE6WOLkkvWTISU75Mfb3/Ph3JCX2KYUFu2GGG9SKFxO0J9mJcyebNoT4V8OigpLrIf6n
         Ti0w==
X-Gm-Message-State: AOAM5326Ku5qnyDfSTC3TQdE+Cgdx5V/28M8dVAZpnPdMxQ4vRez/oFZ
        KVPgb7znh5oibmXFTA5LUoQ=
X-Google-Smtp-Source: ABdhPJy61JDKUi1ds4pighjwQwbZRzXCpfgRyU2cH6JHwPs9PUd9taYGC0VD26ak0RXsT4zzSAgsCQ==
X-Received: by 2002:a05:6e02:214f:: with SMTP id d15mr18971086ilv.180.1613510254856;
        Tue, 16 Feb 2021 13:17:34 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id i8sm11319657ilv.57.2021.02.16.13.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 13:17:34 -0800 (PST)
Date:   Tue, 16 Feb 2021 13:17:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Message-ID: <602c3665b1f61_76b702083a@john-XPS-13-9370.notmuch>
In-Reply-To: <20210216205021.GC17126@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
 <87mtw4b8k3.fsf@toke.dk>
 <602c19dd5b1c2_6b719208e6@john-XPS-13-9370.notmuch>
 <20210216205021.GC17126@ranger.igk.intel.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Tue, Feb 16, 2021 at 11:15:41AM -0800, John Fastabend wrote:
> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
> > > =

> > > > On 2021-02-15 21:49, John Fastabend wrote:
> > > >> Maciej Fijalkowski wrote:
> > > >>> Currently, if there are multiple xdpsock instances running on a=
 single
> > > >>> interface and in case one of the instances is terminated, the r=
est of
> > > >>> them are left in an inoperable state due to the fact of unloade=
d XDP
> > > >>> prog from interface.
> > > >>>
> > > >>> To address that, step away from setting bpf prog in favour of b=
pf_link.
> > > >>> This means that refcounting of BPF resources will be done autom=
atically
> > > >>> by bpf_link itself.
> > > >>>
> > > >>> When setting up BPF resources during xsk socket creation, check=
 whether
> > > >>> bpf_link for a given ifindex already exists via set of calls to=

> > > >>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_in=
fo_by_fd
> > > >>> and comparing the ifindexes from bpf_link and xsk socket.
> > > >>>
> > > >>> If there's no bpf_link yet, create one for a given XDP prog and=
 unload
> > > >>> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not =
set.
> > > >>>
> > > >>> If bpf_link is already at a given ifindex and underlying progra=
m is not
> > > >>> AF-XDP one, bail out or update the bpf_link's prog given the pr=
esence of
> > > >>> XDP_FLAGS_UPDATE_IF_NOEXIST.
> > > >>>
> > > >>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com=
>

[...]

> > =

> > I'm not a real user of AF_XDP (yet.), but here is how I would expect =
it
> > to work based on how the sockmap pieces work, which are somewhat simi=
lar
> > given they also deal with sockets.
> =

> Don't want to be picky, but I suppose sockmap won't play with ndo_bpf()=

> and that's what was bothering us.
> =

> > =

> > Program =

> > (1) load and pin an XDP BPF program
> >     - obj =3D bpf_object__open(prog);
> >     - bpf_object__load_xattr(&attr);
> >     - bpf_program__pin()
> > (2) pin the map, find map_xsk using any of the map APIs
> >     - bpf_map__pin(map_xsk, path_to_pin)
> > (3) attach to XDP
> >     - link =3D bpf_program__attach_xdp()
> >     - bpf_link__pin()
> > =

> > At this point you have a BPF program loaded, a xsk map, and a link al=
l
> > pinned and ready. And we can add socks using the process found in
> > `enter_xsks_into_map` in the sample. This can be the same program tha=
t
> > loaded/pinned the XDP program or some other program it doesn't really=

> > matter.
> > =

> >  - create xsk fd
> >       . xsk_umem__create()
> >       . xsk_socket__create
> >  - open map @ pinned path
> >  - bpf_map_update_elem(xsks_map, &key, &fd, 0);
> > =

> > Then it looks like we don't have any conflicts? The XDP program is pi=
nned
> > and exists in its normal scope. The xsk elements can be added/deleted=

> > as normal.
> =

> The only difference from what you wrote up is the resource pinning, whe=
n
> compared to what we currently have + the set I am proposing.
> =

> So, if you're saying it looks like we don't have any conflicts and I am=

> saying that the flow is what we have, then...? :)
> =

> You would have to ask Magnus what was behind the decision to avoid API
> from tools/lib/bpf/libbpf.c but rather directly call underlying functio=
ns
> from tools/lib/bpf/bpf.c. Nevertheless, it doesn't really make a big
> difference to me.
> =

> > If the XDP program is removed and the map referencing (using
> > normal ref rules) reaches zero its also deleted. Above is more or les=
s
> > the same flow we use for any BPF program so looks good to me.
> =

> We have to be a bit more specific around the "XDP program is removed".
> Is it removed from the network interface? That's the thing that we want=
 to
> avoid when there are other xsk sockets active on a given interface.

What I'm suggesting here is to use the normal rules for when an
XDP program is removed from the network interface. I don't think we
should do anything extra to keep the XDP program attached/loaded
just because it has a xsk map which may or may not have some
entries in it. If the user wants this behavior they should pin
the bpf_link pointer associated with the xdp program. This is the
same as any other program/map I have in my BPF system.

> =

> With bpf_link, XDP prog is removed only when bpf_link's refcount reache=
s
> zero, via link->ops->release() callback that is invoked from
> bpf_link_put().
> =

> And the refcount is updated with each process that attaches/detaches fr=
om
> the bpf_link on interface.
> =

> > =

> > The trouble seems to pop up when using the higher abstraction APIs
> > xsk_setup_xdp_prog and friends I guess? I just see above as already
> > fairly easy to use and we have good helpers to create the sockets it =
looks
> > like. Maybe I missed some design considerations. IMO higher level
> > abstractions should go in new libxdp and above should stay in libbpf.=

> =

> xsk_setup_xdp_prog doesn't really feel like higher level abstraction, a=
s I
> mentioned, to me it has one layer of abstraction peeled off.

Except it seems to have caused some issues. I don't think I gain
much from the API personally vs just doing above steps. But, I
appreciate you are just trying to fix it here so patches are
a good idea with v2 improvements. And I expect whenever
libbpf/libxdp split the above "high level" APIs will land in
libxdp.

Thanks,
John

> =

> > =

> > /rant off ;)
> > =

> > Thanks,
> > John


