Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A73031D0C9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBPTQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhBPTQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:16:30 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39835C061574;
        Tue, 16 Feb 2021 11:15:50 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id a7so66522iok.12;
        Tue, 16 Feb 2021 11:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HKLvgchqwj+B7qkXQkb3HWmOD8jrJbICNAT1eDbPAP8=;
        b=ctapiPjMVLxmt+6W8GVykOii3tJPLhXx1pyBCvAh3klwM3Z1atAkxv1p2uLtKcc0Gm
         6YkfXlPBf7E1P20B/SJ2OWlzZ4DyL0FoasDc4OkONBbVYMyMtYlMOSzVmoMwTxqMf7/k
         nYnS0dPc/0v5GVeI1QSj9JoBeuEGl97ZOXP0AsGJmpZqnDwA8Vl9NT9jk85jV2U05dZF
         eFHiZ+dGPGd/gfDhcGBNftLCB8V6+nejYag/iQ3uIGLA2dkv8Fwyt3S+GRr/jGmRj43W
         0C//3LnTV1nkcy86LdN4BaNevgDdvGbQO7fw5BOk57v5gJBKrx3ZxWbC+M4UHXSEtlI7
         OZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HKLvgchqwj+B7qkXQkb3HWmOD8jrJbICNAT1eDbPAP8=;
        b=Fbtfq8Kk67J1/Zf9kMaC9l90lptM38EdYZjKjpbq64tdZrcY4q4W94HS9LTlukELkV
         12F83a7wN4F4+hmdEzX46DxgDX3fuTJ+xTBGC2Pn+B1r73zLAojmcBujz4DaGMTquxq7
         DYUQ2SCKavBaP50Qwtf/PiG0zmFB8QMCb0pNQX9dfUQU/YijbRS6ZwxYwwZxqmt7vQZA
         zyNQScjXKC3WO/G/2C+VDrtmBW7uRj8aeZD7iWAOtws5ZSpaJdh+ChDlX369d3w7EQTM
         ZyL8gPzBxZJ9P00lj4OJ8uAW/2y1cs6WGQRAKh1iyKzx5oPrkuOmXNY3PWha/91tezGn
         FO4g==
X-Gm-Message-State: AOAM530wTZbaZWkEa42AaP6t0ds9poav7o98N+LZ9t3/6M1QW220SiJ+
        QGAen9HRYHHy24DXa6dIZ/Q=
X-Google-Smtp-Source: ABdhPJxLo/3LQdmYMEUzeGk6EgPz27pGnjREReOihKdMUy2JaroMTFHOK/viKzzXLIXiGi8HtB+K/A==
X-Received: by 2002:a6b:f20c:: with SMTP id q12mr6374250ioh.149.1613502949618;
        Tue, 16 Feb 2021 11:15:49 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id h6sm6900057ioq.52.2021.02.16.11.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 11:15:49 -0800 (PST)
Date:   Tue, 16 Feb 2021 11:15:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Message-ID: <602c19dd5b1c2_6b719208e6@john-XPS-13-9370.notmuch>
In-Reply-To: <87mtw4b8k3.fsf@toke.dk>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
 <87mtw4b8k3.fsf@toke.dk>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
> =

> > On 2021-02-15 21:49, John Fastabend wrote:
> >> Maciej Fijalkowski wrote:
> >>> Currently, if there are multiple xdpsock instances running on a sin=
gle
> >>> interface and in case one of the instances is terminated, the rest =
of
> >>> them are left in an inoperable state due to the fact of unloaded XD=
P
> >>> prog from interface.
> >>>
> >>> To address that, step away from setting bpf prog in favour of bpf_l=
ink.
> >>> This means that refcounting of BPF resources will be done automatic=
ally
> >>> by bpf_link itself.
> >>>
> >>> When setting up BPF resources during xsk socket creation, check whe=
ther
> >>> bpf_link for a given ifindex already exists via set of calls to
> >>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_b=
y_fd
> >>> and comparing the ifindexes from bpf_link and xsk socket.
> >>>
> >>> If there's no bpf_link yet, create one for a given XDP prog and unl=
oad
> >>> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.=

> >>>
> >>> If bpf_link is already at a given ifindex and underlying program is=
 not
> >>> AF-XDP one, bail out or update the bpf_link's prog given the presen=
ce of
> >>> XDP_FLAGS_UPDATE_IF_NOEXIST.
> >>>
> >>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> >>> ---

[...]

> >>> -	ctx->prog_fd =3D prog_fd;
> >>> +	link_fd =3D bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_=
XDP, &opts);
> >>> +	if (link_fd < 0) {
> >>> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> >>> +		return link_fd;
> >>> +	}
> >>> +
> >> =

> >> This can leave the system in a bad state where it unloaded the XDP p=
rogram
> >> above, but then failed to create the link. So we should somehow fix =
that
> >> if possible or at minimum put a note somewhere so users can't claim =
they
> >> shouldn't know this.
> >> =

> >> Also related, its not good for real systems to let XDP program go mi=
ssing
> >> for some period of time. I didn't check but we should make
> >> XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
> >>
> >
> > This is the default for XDP sockets library. The
> > "bpf_set_link_xdp_fd(...-1)" way is only when a user sets it explicit=
ly.
> > One could maybe argue that the "force remove" would be out of scope f=
or
> > AF_XDP; Meaning that if an XDP program is running, attached via netli=
nk,
> > the AF_XDP library simply cannot remove it. The user would need to re=
ly
> > on some other mechanism.
> =

> Yeah, I'd tend to agree with that. In general, I think the proliferatio=
n
> of "just force-remove (or override) the running program" in code and
> instructions has been a mistake; and application should only really be
> adding and removing its own program...
> =

> -Toke
> =


I'll try to consolidate some of my opinions from a couple threads here. I=
t
looks to me many of these issues are self-inflicted by the API. We built
the API with out the right abstractions or at least different abstraction=
s
from the rest of the BPF APIs. Not too surprising seeing the kernel side
and user side were all being built up at once.

For example this specific issue where the xsk API also deletes the XDP
program seems to be due to merging the xsk with the creation of the XDP
programs.

I'm not a real user of AF_XDP (yet.), but here is how I would expect it
to work based on how the sockmap pieces work, which are somewhat similar
given they also deal with sockets.

Program =

(1) load and pin an XDP BPF program
    - obj =3D bpf_object__open(prog);
    - bpf_object__load_xattr(&attr);
    - bpf_program__pin()
(2) pin the map, find map_xsk using any of the map APIs
    - bpf_map__pin(map_xsk, path_to_pin)
(3) attach to XDP
    - link =3D bpf_program__attach_xdp()
    - bpf_link__pin()

At this point you have a BPF program loaded, a xsk map, and a link all
pinned and ready. And we can add socks using the process found in
`enter_xsks_into_map` in the sample. This can be the same program that
loaded/pinned the XDP program or some other program it doesn't really
matter.

 - create xsk fd
      . xsk_umem__create()
      . xsk_socket__create
 - open map @ pinned path
 - bpf_map_update_elem(xsks_map, &key, &fd, 0);

Then it looks like we don't have any conflicts? The XDP program is pinned=

and exists in its normal scope. The xsk elements can be added/deleted
as normal. If the XDP program is removed and the map referencing (using
normal ref rules) reaches zero its also deleted. Above is more or less
the same flow we use for any BPF program so looks good to me.

The trouble seems to pop up when using the higher abstraction APIs
xsk_setup_xdp_prog and friends I guess? I just see above as already
fairly easy to use and we have good helpers to create the sockets it look=
s
like. Maybe I missed some design considerations. IMO higher level
abstractions should go in new libxdp and above should stay in libbpf.

/rant off ;)

Thanks,
John=
