Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC4934D9B4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 23:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhC2VrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 17:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhC2Vqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 17:46:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617054406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4IQn1Iq4DKxtPfzHamU7ytxyjqtyzllBqT9fYE0lGXU=;
        b=jScHiE0JC9eq8aLdYPAB9vCdbFbgjK4M8kqiAfNpx+39+ylO4cEuzEWk0/S9mBp5HzXKyD
        ECCX+5WRxzfIalApQIwMJXUXi8E20Se/pML67GYTpP0C/EKaKSmDXJZlER1vNVFx1bv9Q5
        Iutrd+ktDYoXBQ1SLDThXIGdokmgcHU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-njK1KshVM8eeLnT7NHUd7A-1; Mon, 29 Mar 2021 17:46:44 -0400
X-MC-Unique: njK1KshVM8eeLnT7NHUd7A-1
Received: by mail-ed1-f70.google.com with SMTP id w18so9211957edu.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 14:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4IQn1Iq4DKxtPfzHamU7ytxyjqtyzllBqT9fYE0lGXU=;
        b=NeLTdLgXGyib/9ZzhzFzMSopoWiJNZjwE0/iTaX9QPiXKFyiQUxJst4zkKcPdakde/
         hU0VoqGW/7sa0lkgAEJT5PDHk/S/ISdfEbo+FXvdorn/EYCg7X3HfDtjHiPX6OOE6r9z
         L85qgxzcRAlLn2LYCybgdCNhHPz0dbkJPii3RVkLgLLUK7Vl+NvyGPNGI1OsS/jKdAwX
         SQbXclKHTFNeJNvUMpldtV6vuncdcV5+6aQv6y7gLdLyKlD/908eoDHrR2rI+x1zpCEx
         6LJ37hoeSMERbmQTLcpOEIa3uVlx3byZsrkJBqdNpMoIg2BCGKL0sGNQEVgFvF/066f0
         KkWw==
X-Gm-Message-State: AOAM530mxEOcSDKI8yotPCsQMLR53IUtCPRwMsAOfuIq8s+w4EVHOEPy
        j3NFfpxZrExeekSVDTI9WRP+a7ZxXmy7ZNrPlc0U5PhR3EK8aB+5InoTnqqpxGtCS92QnYyym3l
        J8lFPuVq3BxMaohQH
X-Received: by 2002:a17:906:b202:: with SMTP id p2mr12080075ejz.244.1617054402910;
        Mon, 29 Mar 2021 14:46:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/LqmchSiNU/Ln+iuJM+UJX0D0DWIaUvQD29/+n7GhQo7X5r+b7NYV23u09ftMITAeRWQiBQ==
X-Received: by 2002:a17:906:b202:: with SMTP id p2mr12080042ejz.244.1617054402489;
        Mon, 29 Mar 2021 14:46:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bm10sm9904054edb.2.2021.03.29.14.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 14:46:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 592F9180293; Mon, 29 Mar 2021 23:46:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v4 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210329193234.GA9506@ranger.igk.intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
 <20210326230938.49998-7-maciej.fijalkowski@intel.com>
 <87o8f2te2f.fsf@toke.dk> <20210329131401.GA9069@ranger.igk.intel.com>
 <87zgymrqzm.fsf@toke.dk> <20210329193234.GA9506@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 23:46:41 +0200
Message-ID: <87zgylr5tq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Mon, Mar 29, 2021 at 04:09:33PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>> > On Mon, Mar 29, 2021 at 01:05:44PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>> >>=20
>> >> > Currently, if there are multiple xdpsock instances running on a sin=
gle
>> >> > interface and in case one of the instances is terminated, the rest =
of
>> >> > them are left in an inoperable state due to the fact of unloaded XDP
>> >> > prog from interface.
>> >> >
>> >> > Consider the scenario below:
>> >> >
>> >> > // load xdp prog and xskmap and add entry to xskmap at idx 10
>> >> > $ sudo ./xdpsock -i ens801f0 -t -q 10
>> >> >
>> >> > // add entry to xskmap at idx 11
>> >> > $ sudo ./xdpsock -i ens801f0 -t -q 11
>> >> >
>> >> > terminate one of the processes and another one is unable to work du=
e to
>> >> > the fact that the XDP prog was unloaded from interface.
>> >> >
>> >> > To address that, step away from setting bpf prog in favour of bpf_l=
ink.
>> >> > This means that refcounting of BPF resources will be done automatic=
ally
>> >> > by bpf_link itself.
>> >> >
>> >> > Provide backward compatibility by checking if underlying system is
>> >> > bpf_link capable. Do this by looking up/creating bpf_link on loopba=
ck
>> >> > device. If it failed in any way, stick with netlink-based XDP prog.
>> >> > therwise, use bpf_link-based logic.
>> >> >
>> >> > When setting up BPF resources during xsk socket creation, check whe=
ther
>> >> > bpf_link for a given ifindex already exists via set of calls to
>> >> > bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_b=
y_fd
>> >> > and comparing the ifindexes from bpf_link and xsk socket.
>> >> >
>> >> > For case where resources exist but they are not AF_XDP related, bai=
l out
>> >> > and ask user to remove existing prog and then retry.
>> >> >
>> >> > Lastly, do a bit of refactoring within __xsk_setup_xdp_prog and pul=
l out
>> >> > existing code branches based on prog_id value onto separate functio=
ns
>> >> > that are responsible for resource initialization if prog_id was 0 a=
nd
>> >> > for lookup existing resources for non-zero prog_id as that implies =
that
>> >> > XDP program is present on the underlying net device. This in turn m=
akes
>> >> > it easier to follow, especially the teardown part of both branches.
>> >> >
>> >> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> >>=20
>> >> The logic is much improved in this version! A few smallish issues bel=
ow:
>> >
>> > Glad to hear that!
>> >
>> >>=20
>> >> > ---
>> >> >  tools/lib/bpf/xsk.c | 259 ++++++++++++++++++++++++++++++++++++----=
----
>> >> >  1 file changed, 214 insertions(+), 45 deletions(-)
>> >> >
>> >> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> >> > index 526fc35c0b23..c75067f0035f 100644
>> >> > --- a/tools/lib/bpf/xsk.c
>> >> > +++ b/tools/lib/bpf/xsk.c
>> >> > @@ -28,6 +28,7 @@
>> >> >  #include <sys/mman.h>
>> >> >  #include <sys/socket.h>
>> >> >  #include <sys/types.h>
>> >> > +#include <linux/if_link.h>
>> >> >=20=20
>> >> >  #include "bpf.h"
>> >> >  #include "libbpf.h"
>> >> > @@ -70,8 +71,10 @@ struct xsk_ctx {
>> >> >  	int ifindex;
>> >> >  	struct list_head list;
>> >> >  	int prog_fd;
>> >> > +	int link_fd;
>> >> >  	int xsks_map_fd;
>> >> >  	char ifname[IFNAMSIZ];
>> >> > +	bool has_bpf_link;
>> >> >  };
>> >> >=20=20
>> >> >  struct xsk_socket {
>> >> > @@ -409,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket =
*xsk)
>> >> >  	static const int log_buf_size =3D 16 * 1024;
>> >> >  	struct xsk_ctx *ctx =3D xsk->ctx;
>> >> >  	char log_buf[log_buf_size];
>> >> > -	int err, prog_fd;
>> >> > +	int prog_fd;
>> >> >=20=20
>> >> >  	/* This is the fallback C-program:
>> >> >  	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>> >> > @@ -499,14 +502,43 @@ static int xsk_load_xdp_prog(struct xsk_socke=
t *xsk)
>> >> >  		return prog_fd;
>> >> >  	}
>> >> >=20=20
>> >> > -	err =3D bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
>> >> > -				  xsk->config.xdp_flags);
>> >> > +	ctx->prog_fd =3D prog_fd;
>> >> > +	return 0;
>> >> > +}
>> >> > +
>> >> > +static int xsk_create_bpf_link(struct xsk_socket *xsk)
>> >> > +{
>> >> > +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_fla=
gs
>> >> > +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
>> >> > +	 */
>> >> > +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
>> >> > +			    .flags =3D (xsk->config.xdp_flags & XDP_FLAGS_MODES));
>> >>=20
>> >> This will silently suppress any new flags as well; that's not a good
>> >> idea. Rather mask out the particular flag (UPDATE_IF_NOEXIST) and pass
>> >> everything else through so the kernel can reject invalid ones.
>> >
>> > I'd say it's fine as it matches the check:
>> >
>> > 	/* link supports only XDP mode flags */
>> > 	if (link && (flags & ~XDP_FLAGS_MODES)) {
>> > 		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
>> > 		return -EINVAL;
>> > 	}
>> >
>> > from dev_xdp_attach() in net/core/dev.c ?
>>=20
>> Yeah, it does today. But what happens when the kernel learns to accept a
>> new flag?
>>=20
>> Also, you're masking the error on an invalid flag. If, in the future,
>> the kernel learns to handle a new flag, that check in the kernel will
>> change to accept that new flag. But if userspace tries to pass that to
>> and old kernel, they'll get back an EINVAL. This can be used to detect
>> whether the kernel doesn't support the flag, and can if not, userspace
>> can fall back and do something different.
>>=20
>> Whereas with your code, you're just silently zeroing out the invalid
>> flag, so the caller will have no way to detect whether the flag works
>> or not...
>
> I'd rather worry about such feature detection once a new flag is in place
> and this code would actually care about :) but that's me.
>
> I feel like stick has two ends in this case - if we introduce a new flag
> that would be out of the bpf_link's interest (the kernel part), then we
> will have to come back here and explicitly mask it out, just like you
> propose to do so with UPDATE_IF_NOEXIST right now.

Well I'd rather err on the side of throwing errors for new flags than on
silently suppressing them :)

(The partial sharing of flags between netlink and bpf_link is a bit odd
in any case, but that's another discussion)

> What I'm saying is that we need to mask out the FLAGS_REPLACE as well.
> Current code took care of that. So, to move this forward, I can do:
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index c75067f0035f..95da0e19f4a5 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -508,11 +508,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>=20=20
>  static int xsk_create_bpf_link(struct xsk_socket *xsk)
>  {
> -	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> -	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> -	 */
> -	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> -			    .flags =3D (xsk->config.xdp_flags & XDP_FLAGS_MODES));
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
>  	struct xsk_ctx *ctx =3D xsk->ctx;
>  	__u32 prog_id =3D 0;
>  	int link_fd;
> @@ -532,6 +528,8 @@ static int xsk_create_bpf_link(struct xsk_socket *xsk)
>  		return -EINVAL;
>  	}
>=20=20
> +	opts.flags =3D xsk->config.xdp_flags & ~(XDP_FLAGS_UPDATE_IF_NOEXIST | =
XDP_FLAGS_REPLACE);
> +
>  	link_fd =3D bpf_link_create(ctx->prog_fd, ctx->ifindex, BPF_XDP, &opts);
>  	if (link_fd < 0) {
>  		pr_warn("bpf_link_create failed: %s\n", strerror(errno));

Yup, this works for me! :)

-Toke

