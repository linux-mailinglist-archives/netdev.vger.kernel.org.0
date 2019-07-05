Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2E60B16
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfGERaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:30:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33703 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfGERaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:30:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so10698773wru.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vth/r4Kd4QqL5Bf7HZ2daPonwmJBJKd8d9hKsehESGY=;
        b=EHytRtgDJjHzr/UuaggW8U7VvBRewMMCPHkT0vr4guuSSBjuoel8cyYb5nDBruCKhd
         MVitFwgRvRQUKtirBW/8GzOcgiGGKg/Be1rLIq+EeD5FLvKDO3GqxTS5LC4bNaU2G27I
         pLcFCVybHINRD7UGtZIOiBpHaHPV/F2M3+/DFk07YCPFAP6j7vs2zziVt4w4ZrlVARUm
         kkVz9mke3Y/VbToK/2oxuZUATTQIzKY/OKNOInl3wH04gtKwaUKC1Y5MLeLL/ZjIjVlX
         E5NUVn+NXm2mQ1HznnuJXwdv35X91pocl+ZZUM919GsMvmb1fFbiJV6tSeTYOO2TpHPB
         ixwA==
X-Gm-Message-State: APjAAAUIn0zfIbMBxNspeeSXp9d7esQJVxN9HSUl6xDoO8UB1193NDF8
        Nbyp4D7A5XNspTOg8mNBIu6hpQ==
X-Google-Smtp-Source: APXvYqxQ+1rZTG2cMdvOpr5I+NLqE1cKymRN+HRWaIzRaMIXKA/wgpfVgIPGCqg6JXdr2x5iiwKp8g==
X-Received: by 2002:adf:a55b:: with SMTP id j27mr4949167wrb.154.1562347815866;
        Fri, 05 Jul 2019 10:30:15 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id m24sm7655988wmi.39.2019.07.05.10.30.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:30:14 -0700 (PDT)
Date:   Fri, 5 Jul 2019 19:30:11 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: NEIGH: BUG, double timer add, state is 8
Message-ID: <20190705173011.GA2882@localhost.localdomain>
References: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
 <1f4be489-4369-01d1-41c6-1406006df9c5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1f4be489-4369-01d1-41c6-1406006df9c5@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jul 05, David Ahern wrote:
> On 7/4/19 3:59 PM, Marek Majkowski wrote:
> > I found a way to hit an obscure BUG in the
> > net/core/neighbour.c:neigh_add_timer(), by piping two carefully
> > crafted messages into AF_NETLINK socket.
> >=20
> > https://github.com/torvalds/linux/blob/v5.2-rc7/net/core/neighbour.c#L2=
59
> >=20
> >     if (unlikely(mod_timer(&n->timer, when))) {
> >         printk("NEIGH: BUG, double timer add, state is %x\n", n->nud_st=
ate);
> >         dump_stack();
> >      }
> >=20
> > The repro is here:
> > https://gist.github.com/majek/d70297b9d72bc2e2b82145e122722a0c
> >=20
> > wget https://gist.githubusercontent.com/majek/d70297b9d72bc2e2b82145e12=
2722a0c/raw/9e140bcedecc28d722022f1da142a379a9b7a7b0/double_timer_add_bug.c
>=20
> Thanks for the report - and the reproducer. I am on PTO through Monday;
> I will take a look next week if no one else does.

Hi David and Marek,

looking at the reproducer it seems to me the issue is due to the use of
'NTF_USE' from userspace.
Should we unschedule the neigh timer if we are in IN_TIMER receiving this
flag from userspace? (taking appropriate locking)

Regards,
Lorenzo

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXR+JIAAKCRA6cBh0uS2t
rKOBAQCuXZ+NQC4l5Pe6dJAwgsWy38fKaaR8+A+X4Fq2wdmruAD/QmGjxJO/bHtL
zfKNJA3DRMb9VZrgaAjlrqBF6V0CDgU=
=B4XQ
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
