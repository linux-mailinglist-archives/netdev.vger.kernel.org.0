Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96C234B89
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfFDPF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:05:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39737 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbfFDPFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:05:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so12862480pfe.6;
        Tue, 04 Jun 2019 08:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rIildGPAhYMmRfiFIbpXG3jfH8kDMHRA/Z+vqw7gr0Y=;
        b=Gh22HoKZrulWz2xOC0n9o6M9FelQqhG9JEqbfD+GG2tC3HbHxiCdTZFaHbJUKPxZJj
         9Rbgvo1GS274b74jntOWtLQG7JWicWdgsweOFMvUiMqs20GmgAD93xJiu8ANlOki4D0K
         Y4MyS7/xJUbFyap7uS31afmWC4fKFW6kqFT5I3dYgdmTkoyMXebnEKPltNJwRYUWFczv
         DbXLQULuzgbxRZzgV6YP5zDwBV28cwoVrvnqb64hShdCH9LBUuIYtMcYezjVVuU5pMaB
         DlSR3SEugMQyW48xwgHC6il1kn9uaSRKdYklrp68MiT3FiWwzdL/hR1pYyt3B9JggHja
         dQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rIildGPAhYMmRfiFIbpXG3jfH8kDMHRA/Z+vqw7gr0Y=;
        b=XymhT6pgQvFuFsHPwwiN/Z1LfakVuIy5ckSk+rvh7VAgiuwGCBxDzVyk1bbJ0+JDFH
         5aME9o2qItci4lZo3vUMsJWGyyCbkfRw2Bmef4bRyYHbWy1tQjczUz1jYFsxCY50VREE
         CImBI5GTMEbZwF2EP+mJ0nGXUZUBrWqzsY+/aY5VPAQXN+fUIhazC6pDxKtSREqX+j/O
         GpCIaGm7QRBJ21p60tESrjoZikr7MibfU9sdQpVcKmp4IjctFMilzac9wfUYXcLV4apx
         Zyr1q/qel5qtXPKB5tYs0kqxHEXagvMKLzuQ+GF0B4fjJD2OTAVL3cgpohp+nMApU2cg
         2Glg==
X-Gm-Message-State: APjAAAX21e5nl47rm+F0mSlSglr7LGnsOmOyuyFREusK/nfXVVGeieDM
        W86l+wAfWwG4S2UJtaMQllw=
X-Google-Smtp-Source: APXvYqwK6NgYXxKHTxU9XVTe1cAJmT4NgAcUs/IIRn8mYLbZpAgzW4n9S9TkjbmSQ3QZcS4jBUrBbA==
X-Received: by 2002:a62:f201:: with SMTP id m1mr32394735pfh.217.1559660753206;
        Tue, 04 Jun 2019 08:05:53 -0700 (PDT)
Received: from localhost ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id m6sm20240923pgr.18.2019.06.04.08.05.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:05:53 -0700 (PDT)
Date:   Tue, 4 Jun 2019 17:05:45 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     magnus.karlsson@intel.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 2/4] libbpf: check for channels.max_{t,r}x
 in xsk_get_max_queues
Message-ID: <20190604170545.00003ee7@gmail.com>
In-Reply-To: <87505132-2f1b-dc4d-5c1f-d52fc8dca647@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-3-maciej.fijalkowski@intel.com>
 <87505132-2f1b-dc4d-5c1f-d52fc8dca647@intel.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 10:06:57 +0200
Bj=F6rn T=F6pel <bjorn.topel@intel.com> wrote:

> On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > When it comes down to ethtool's get channels API, various drivers are
> > reporting the queue count in two ways - they are setting max_combined or
> > max_tx/max_rx fields. When creating the eBPF maps for xsk socket, this
> > API is used so that we have an entries in maps per each queue.
> > In case where driver (mlx4, ice) reports queues in max_tx/max_rx, we end
> > up with eBPF maps with single entries, so it's not possible to attach an
> > AF_XDP socket onto queue other than 0 - xsk_set_bpf_maps() would try to
> > call bpf_map_update_elem() with key set to xsk->queue_id.
> >=20
> > To fix this, let's look for channels.max_{t,r}x as well in
> > xsk_get_max_queues.
> >=20
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   tools/lib/bpf/xsk.c | 18 ++++++++++--------
> >   1 file changed, 10 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 57dda1389870..514ab3fb06f4 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -339,21 +339,23 @@ static int xsk_get_max_queues(struct xsk_socket *=
xsk)
> >   	ifr.ifr_data =3D (void *)&channels;
> >   	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
> >   	err =3D ioctl(fd, SIOCETHTOOL, &ifr);
> > -	if (err && errno !=3D EOPNOTSUPP) {
> > -		ret =3D -errno;
> > -		goto out;
> > -	}
> > +	close(fd);
> > +
> > +	if (err && errno !=3D EOPNOTSUPP)
> > +		return -errno;
> >  =20
> > -	if (channels.max_combined =3D=3D 0 || errno =3D=3D EOPNOTSUPP)
> > +	if (channels.max_combined)
> > +		ret =3D channels.max_combined;
> > +	else if (channels.max_rx && channels.max_tx)
> > +		ret =3D min(channels.max_rx, channels.max_tx);
>=20
> Hmm, do we really need to look at max_tx? For each Rx, there's (usually)
> an XDP ring.

Probably we would be good to go with only max_rx, but in drivers during the
umem setup we also are comparing the queue id provided by user against the =
num
tx queues...so in theory, we could allocate the max_rx entries, but if the
current txq count is lower than reported max_rx, a bunch of map entries wou=
ld
never be used, no?

>
> OTOH, when AF_XDP ZC is not implemented, it uses the skb path...
>=20
> > +	else if (channels.max_combined =3D=3D 0 || errno =3D=3D EOPNOTSUPP)
> >   		/* If the device says it has no channels, then all traffic
> >   		 * is sent to a single stream, so max queues =3D 1.
> >   		 */
> >   		ret =3D 1;
> >   	else
> > -		ret =3D channels.max_combined;
> > +		ret =3D -1;
> >  =20
> > -out:
> > -	close(fd);
> >   	return ret;
> >   }
> >  =20
> >=20

