Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6C4D4857
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbiCJNrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiCJNrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:47:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88B314EF72
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:46:21 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646919979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zLKX4xFhXm8hH5y4R4O/xgrtMGQCwuZgxzGp4Vhsvak=;
        b=GFS8yKxOnILY1HKt4ePVukjHRQph/WfR4ZewKbjJxxkS+hKRb8waabthARVsSsCJ2AgwLP
        E5J4n0WEPXsAaSy28xsR7dhHdJVVl/pMLayY4zoi15gjQoml7yPPbHaHxl/SVk+FoYmt6R
        IekRs0v8r690ZaFgzY1VBi7jlHaNVqV4X+/41nZMc4nkjfxw2fDI1z5dhmPHGgk6UVmw7T
        5sta1HScB6TQtpTFTj9WUaYNLriTGfGms4ySgomuxIRB4/rBwO9lHs+9HrOCJqjkzHqVxc
        Oxws6BAZq2FxDa/Y/fp87zJqUsIbLFTiLvTY3Sp1jnWw82ZdS1QvIqq/q/h/WA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646919979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zLKX4xFhXm8hH5y4R4O/xgrtMGQCwuZgxzGp4Vhsvak=;
        b=Ba/Pp4ejEYAHM2uY9R1mA4o2fcD3qrMpsh+8WJmOhqQMOioNwJQMB+I+e5w1xnvoDmpE5n
        Z1oPzvXsdYOsqODA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next] flow_dissector: Add support for HSRv0
In-Reply-To: <20220310133403.bjf2k4tgpwl5xtsy@skbuf>
References: <20220310073505.49990-1-kurt@linutronix.de>
 <20220310133403.bjf2k4tgpwl5xtsy@skbuf>
Date:   Thu, 10 Mar 2022 14:46:17 +0100
Message-ID: <87tuc5ncnq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Mar 10 2022, Vladimir Oltean wrote:
> On Thu, Mar 10, 2022 at 08:35:05AM +0100, Kurt Kanzenbach wrote:
>> Commit bf08824a0f47 ("flow_dissector: Add support for HSR") added suppor=
t for
>> HSR within the flow dissector. However, it only works for HSR in version
>> 1. Version 0 uses a different Ether Type. Add support for it.
>>=20
>> Reported-by: Anthony Harivel <anthony.harivel@linutronix.de>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> This observation came up as a result of the fact that HSRv0 is still in
> actual use, or just for correctness' sake?

It came up while testing the Linux HSR implementation.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIqASkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgn9oD/4lSbBvN3B43ze1rlVCbzMZhFGv5yhx
uzkBa5RasFP3v+saAui7QGEZxR7C7vd3rGbjDlIqnrraRGYSnhivoTWVorLZCdUV
zdxPTfZwg8b/1wI/sCX89G4SNsOS7nu2qic/CL4iGISmhOUxubxevzVjxzZXsW3G
IAb/6OuCyFqfZrvx+zK4lLAB3RoGA6ietTXCtdH6kQL73WvrmWN7E1fI3Hj4PPYV
Ek8KpZgchsrPsYUnJoNT//DKffKrZP0Tb4ZV0/8WRbklpbX2K9kwDYNUGuPE6ZLy
DzRlrZI0c0JoqtdN37ik8q02B2tnCVURvZbr6cUSVA5sAKv+R5D3VRkDD7yXr32+
Z99wWwdlALGR4djVAiJVIf2BgLhKI0IxUmtk/PxFcfNwF7YoZt+5cyU9HkXWu2R3
lvLl0M9U1yGGzpCsZ9B9qDeR3OTYsMqnZR/781gBozrj7lr35bUstZYPM8yBFK94
sol+tiwu7sRu0VokHZwZKObCN5od+GuA45kyntHi55zE+eBbsWuCfnEbI1/11Uua
ichS3MewH+89IT5nvDWuQptnL5F+RMBCVghrirlfBB7P0iEbX2uY7GCaP4UiZHMW
L6vi8VYEuEae9HwTLGB+fh5CiHgf7VoJVA8zWo90r3uP/T8MjC5/0SBzq2QMTZB5
fmsKi38JtzzQzQ==
=TAeC
-----END PGP SIGNATURE-----
--=-=-=--
