Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60290161D6E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgBQWiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:38:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57056 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbgBQWip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581979124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NymLtRtDCvksl9Nxa72rbeaRJgU35z454HfVv3yh+EA=;
        b=b8Jcq+r6KxFeyN07PY0mDGD12E/xUlnR/tC1hFVwikTmd6TqP7GwnieXJVcACuhCXDNsdQ
        ral625GY+Fx1LuO3jtWdFpoby8BpFXfZF4I+aL/hwfYl5+sJhY8EH1xVoADB7I7KtNAXIr
        DvEq7tiLBjggsJMOWVgfM17R1ZpOxyc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-RF3gv3S2MkivnqYhvBEqpQ-1; Mon, 17 Feb 2020 17:38:42 -0500
X-MC-Unique: RF3gv3S2MkivnqYhvBEqpQ-1
Received: by mail-wr1-f70.google.com with SMTP id m15so9648502wrs.22
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:38:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NymLtRtDCvksl9Nxa72rbeaRJgU35z454HfVv3yh+EA=;
        b=ChmRIcJDPGfLIE5dZvq7egki1QvXRDW10stqNIrYwXBzbttmxm4F6338FS2AqO9ctR
         E4A+c7UE3jLW3JF6PmK1L0vnoas0VRfI3MGrtw8IUvfaHZAtBwOd6zHfPxF0j4rbSpXw
         m0lnGS3o/4jdBzUVq/cjQqz/ZI3zXcyfoEPEspCSgpY1mOgCLR1xI/LELZ1Tv/uJ2pZ6
         y76qy+NhHMaLzYgK+0FVc6RAxlZADIXKA/FtWlTmK9TcWX69KVPwFMfJgVnFoDsXPk1Q
         fgb8Pgbt/cbR22DFXIV/uC+9OecnI+cR0Bksea3VV782QzjNVQRTPTzTs6Xvxzw5ZCh5
         XTIA==
X-Gm-Message-State: APjAAAXt4MzbQX0bFsFa0rddknYt7YMQ30819W1DhlR8wHXQPWPl0LTO
        N33UqzpfWeFqkqt3J3LDYQ5yxy6MujAa93trU6ku9Vsa9UOk4M4Juwv7EU2CrJ5zwmHzZ7BzGgx
        H15e6ljoODHLB/dpN
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr1134217wmh.22.1581979120915;
        Mon, 17 Feb 2020 14:38:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSN4aiDtJiBBE1Ht8Yx46Arfxvcv4DorPaWHQzoGKPEFFo9K6XhAtVGHyMZ4v6H/NkQJDWFw==
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr1134204wmh.22.1581979120655;
        Mon, 17 Feb 2020 14:38:40 -0800 (PST)
Received: from lore-desk-wlan ([151.48.137.85])
        by smtp.gmail.com with ESMTPSA id a13sm2934557wrp.93.2020.02.17.14.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:38:40 -0800 (PST)
Date:   Mon, 17 Feb 2020 23:38:37 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     brouer@redhat.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, dsahern@kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217223837.GA5669@lore-desk-wlan>
References: <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
 <20200217111718.2c9ab08a@carbon>
 <20200217102550.GB3080@localhost.localdomain>
 <20200217.141850.2134390863127670308.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20200217.141850.2134390863127670308.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date: Mon, 17 Feb 2020 11:25:50 +0100
>=20
> > yes, I think it is definitely better. So to follow up:
> > - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
> >   XDP_TX verdict and for ndo_xdp_xmit
> > - introduce a new "xdp_tx" counter only for XDP_TX verdict.
> >=20
> > If we agree I can post a follow-up patch.
>=20
> What names do other drivers use?  Consistency is important.  I noticed
> while reviewing these patches that mellanox drivers export similar
> statistics in the exact same way.

According to David's suggestion, I am following mellanox implementation
adding "rx_" prefix for xdp actions on rx path and, based on Jesper's comme=
nt,
I am differentiating between XDP_TX and ndo_xdp_xmit.
So, to follow up:

XDP_TX: rx_xdp_tx_xmit
XDP_DROP: rx_xdp_drop
XDP_PASS: rx_xdp_pass
XDP_REDIRECT: rx_xdp_redirect
ndo_xdp_xmit: tx_xdp_xmit

I will post a RFC patch soon.

Regards,
Lorenzo

>=20

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXksV6gAKCRA6cBh0uS2t
rPMtAP9LV3ttyfAZVqDtzm/OKXh0otr7LL/yrs2BWjOGc+4FQAD+P9C0iNo8kmLj
9Mf7vMARZitKgFaIRvELIn3T3SX5FwA=
=W4uj
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--

