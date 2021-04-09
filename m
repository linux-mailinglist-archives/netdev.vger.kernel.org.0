Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFFC35A7BC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhDIUQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:16:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233916AbhDIUQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617999383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=74gpCvDRUj2bXmpFWW0aVIT6UA5LUQWlZ+5lk4rmegI=;
        b=C2d1XBjQlwePegbKVl+6D9e/xi4vqisAn1A2Yg243Z9x1o9u0NsYhBO3IbFIt19MDo2D+8
        BhYIGAB3SM7ROw3tiIl6O22ysnwVYD4oYi2HEAlSiZuaLy8vOOewB2zLt9d8Unz2DLnlZy
        RyIBgVylCjvLVTybP+DJHWg6ZgyESnk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-E4mcO2LlPMyTdxsnK69Exw-1; Fri, 09 Apr 2021 16:16:19 -0400
X-MC-Unique: E4mcO2LlPMyTdxsnK69Exw-1
Received: by mail-ed1-f71.google.com with SMTP id o9so2385317edq.16
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 13:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=74gpCvDRUj2bXmpFWW0aVIT6UA5LUQWlZ+5lk4rmegI=;
        b=PdWkht3NWOFudsWZs8t5ceKiYGjlLBdC2fb1TsiClRcY2pv81ZK6MJjyhMWYNJicGS
         CZ+JBSRRSzmOkz5nY+XeVrPIQZdEyPYqPHoY0uf+MgvWVxbrxYaVzWCcSlT2hzK4ySOC
         b66wN9iLmqDM7sZARlrKN1O5jC2n8SWmSMBi6kSAGZyn3iorh2kfeE3opkqGZbJ/x3CG
         UgfpxcPiQiCbuOG8YwIpD3CqAL61iOIUPjDnKyIj/DMIT7Rwpkj010wQL81JxSmIbbyN
         2KG6j0clGCoFjRCqln8zVL0YpevTfYMSx3iygRemYj8dot1DvUIkV9ptjXjpsKKQV3OU
         cCQg==
X-Gm-Message-State: AOAM531oqPiCpNTO+ImB211OKqDx0NM1+zM8OtFUwb9gmsfHsQllNE89
        OJmPmk6ijPOc4oH+aShJtt1O5Vth8yL16vp8gd3ZEYj0UQfBkfzBGjbZ0TNpOPO+zwKL1GBrrIh
        ZYFDoh1dpLij5NefQ
X-Received: by 2002:a05:6402:1545:: with SMTP id p5mr18947562edx.155.1617999378524;
        Fri, 09 Apr 2021 13:16:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9mK8vKVOV85+1tHlDPiiZGdqitN74xyEH6CWruRNLrUNrSvRhhe5dieXv0wTWmYViquFJDw==
X-Received: by 2002:a05:6402:1545:: with SMTP id p5mr18947547edx.155.1617999378351;
        Fri, 09 Apr 2021 13:16:18 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id t11sm1672608ejs.95.2021.04.09.13.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 13:16:17 -0700 (PDT)
Date:   Fri, 9 Apr 2021 22:16:14 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YHC2DlTAoxwKVR/m@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <606fa62f6fe99_c8b920884@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1unJHuNHhZmELAas"
Content-Disposition: inline
In-Reply-To: <606fa62f6fe99_c8b920884@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1unJHuNHhZmELAas
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:

[...]

>=20
> I just read the commit messages for v8 so far. But, I'm still wondering h=
ow
> to handle use cases where we want to put extra bytes at the end of the
> packet, or really anywhere in the general case. We can extend tail with a=
bove
> is there anyway to then write into that extra space?
>=20
> I think most use cases will only want headers so we can likely make it=20
> a callout to a helper. Could we add something like, xdp_get_bytes(start, =
end)
> to pull in the bytes?
>=20
> My dumb pseudoprogram being something like,
>=20
>   trailer[16] =3D {0,1,2,3,4,5,6,7,8,9,a,b,c,d,e}
>   trailer_size =3D 16;
>   old_end =3D xdp->length;
>   new_end =3D xdp->length + trailer_size;
>=20
>   err =3D bpf_xdp_adjust_tail(xdp, trailer_size)
>   if (err) return err;
>=20
>   err =3D xdp_get_bytes(xdp, old_end, new_end);
>   if (err) return err;
>=20
>   memcpy(xdp->data, trailer, trailer_size);
>=20
> Do you think that could work if we code up xdp_get_bytes()? Does the driv=
er
> have enough context to adjust xdp to map to my get_bytes() call? I think
> so but we should check.

Hi John,

can you please give more details about how xdp_get_bytes() is expected to w=
ork?
iiuc trailer will be pulled at the beginning of the frame after updating the
xdp_buff with xdp_get_bytes helper, correct?
If so I guess it will doable, it is just a matter of reserve more space map=
ping
the buffer on the dma engine respect to XDP_PACKET_HEADROOM. If the frame d=
oes
not fit in a single buffer, it will be split over multiple buffers.
If you are referring to add trailer at the end of the buffer, I guess it is
doable as well introducing a bpf helper.
I guess both of the solutions are orthogonal to this series.

Regards,
Lorenzo

>=20
> >=20
> > More info about the main idea behind this approach can be found here [1=
][2].
>=20
> Thanks for working on this!
>=20

--1unJHuNHhZmELAas
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHC2DAAKCRA6cBh0uS2t
rEW7AQCEdonXqDewBU7wor7cqy0J7Z2F1szFywQ20/rUGPeuUQEAjTwh2shN3MMz
iFC32FCOn0y0wH8nMeg47IQtwI0sNAc=
=qoRY
-----END PGP SIGNATURE-----

--1unJHuNHhZmELAas--

