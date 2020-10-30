Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE129FDED
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 07:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3GlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 02:41:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40254 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3GlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 02:41:08 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604040066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oGUugxoRy6Kt+rNkQvB6dvhrL/E4cemjCK8GQAqgmeo=;
        b=FBGZC6KO8YQewVsg+gOZ3GqdRaHi84PjWPwz9Wg9ARlr9fxPnvQ59HQ9rdFH1sdLJSEZPr
        a1zm1rJvVbhu3baXw3T/IJwCNjys5AveyI7f6BzOh28WfWurrdAhw9YRrVYxdEUWHW89p0
        pRPkn/NVO4+vIrxj9rpdCif6pLYnUdyoKvLzkL+ojjedgrk6De1hpIU8eJlU71k8y9HnnU
        M09yzeFGWXxPgXshERjKESUw1nAlkKnPK//QgblROj+gGCGZ4DY+4bUO8NQaRyRLIV9yyI
        t/xLhN90CxJaxVp46XXG2ZI9RcSQVaL5Vhhc0BdGfU31pZrY6MkfzsdhMznLoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604040066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oGUugxoRy6Kt+rNkQvB6dvhrL/E4cemjCK8GQAqgmeo=;
        b=+McG+/EpqkxBcf83yfuTMOy79MHdqwvF2QFX/F/Op55xOhJkLQF9JlROeAsklykYWV18G8
        C/QzG3aiJqEqCGDw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH v2 net-next 01/12] net: dsa: implement a central TX reallocation procedure
In-Reply-To: <20201030014910.2738809-2-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com> <20201030014910.2738809-2-vladimir.oltean@nxp.com>
Date:   Fri, 30 Oct 2020 07:41:05 +0100
Message-ID: <87imas9pxa.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Oct 30 2020, Vladimir Oltean wrote:
> At the moment, taggers are left with the task of ensuring that the skb
> headers are writable (which they aren't, if the frames were cloned for
> TX timestamping, for flooding by the bridge, etc), and that there is
> enough space in the skb data area for the DSA tag to be pushed.
>
> Moreover, the life of tail taggers is even harder, because they need to
> ensure that short frames have enough padding, a problem that normal
> taggers don't have.
>
> The principle of the DSA framework is that everything except for the
> most intimate hardware specifics (like in this case, the actual packing
> of the DSA tag bits) should be done inside the core, to avoid having
> code paths that are very rarely tested.
>
> So provide a TX reallocation procedure that should cover the known needs
> of DSA today.
>
> Note that this patch also gives the network stack a good hint about the
> headroom/tailroom it's going to need. Up till now it wasn't doing that.
> So the reallocation procedure should really be there only for the
> exceptional cases, and for cloned packets which need to be unshared.
> The tx_reallocs counter should prove that.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only

Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

I'll wait with the hellcreek series until this is merged.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+btYEACgkQeSpbgcuY
8KYabA/+NCN7q/A7Nhv35ni4l+VA0reY/n/2LDVtMmYFmvpYffxhWUiQcZqChimD
/u0BEJjdOWOjgu6izOobNtGzl72lMjfVOD2F38NOuWjNz3mFPmIrbx6NgsbTGyBy
wmkNIvWwLAB7yfmM7dOo/J8YMncRhUBBiaATpdFyCWH3rkmgiZNcabEVbKnz0iSW
uMlqvusQgkwDdqljDdRT1z2AA81pkwCPHGEb5hDx4MINGDsylfTu/xH9E7sVWknw
4PWEjq/gOjc/nlYnmS8bU6w+4qW0RmnTywowIg0/RXAyt0A7Ib5X0umGFlUuGI8d
/PBi0AnFUHqK+I0AkFi+MXFBQKBpgQ1DXwavpRo2DymfG+9OzarkbBru7Gtlqbzs
6BPuhFwOku6v+NeHBGcPVEy1zxpsbxCefYTzzpuQT9GDKsLCc9nEygy7eF20djr0
7aDBp2wM97Z/kFTXImMkUGXpBEqwGVM1Ak6GZyF7M45jGqoKYZX8ZT1b+hNsWE1h
9p+n3c4J93iu9tpW1y34RavAJiY/z7Yse4KpSrUC0y0Exb4D2HdSbx+siOT3gMwf
8AO9Uuksq4Ki9IuxPhxZ6E0riuV/e+0jTukmjvW0bsX8TfYjd7AnxugcueCv0bmI
II6mx5a50OHL0+cybYTdZfyYcCzqsS5lqjgVPhHAo0dZnSQrXJ4=
=dWwU
-----END PGP SIGNATURE-----
--=-=-=--
