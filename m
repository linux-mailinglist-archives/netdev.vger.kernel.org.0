Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A354E6DD
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377174AbiFPQTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiFPQTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:19:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4B0393F4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:19:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 98E811FA0F;
        Thu, 16 Jun 2022 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655396388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGoaovIK6WCNADBDqD0qD1eHvPkUm91rE6qFEA/ao1Y=;
        b=Vm7+QwwGMmui8NB9iB+CxX0NpRawr37OC6t3tpPG0KD1ZRC3oURHyBG4KZWx+lHXCMJg1Y
        3uT5ICHu870sBc+l40MZ3V9GGWAl4i545dFc83aWKsVPPZa7GMJVFq2wFZAgagjMnvtTru
        zlUZY52FUWkjuk5nwdVrxWxECCjVs10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655396388;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGoaovIK6WCNADBDqD0qD1eHvPkUm91rE6qFEA/ao1Y=;
        b=neqQL3YRIuP4nrh4UB3hLtm1OLu/853DBqDO1+W7/wdQrPgcPCk0hAJIT0yF+g8WBWBkkd
        v4xx4CeFFOn0UBBQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8AFD42C141;
        Thu, 16 Jun 2022 16:19:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5B4FC608FF; Thu, 16 Jun 2022 18:19:45 +0200 (CEST)
Date:   Thu, 16 Jun 2022 18:19:45 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, Daniel Juarez <djuarezg@cern.ch>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool] sff-8079/8472: Fix missing sff-8472 output in
 netlink path
Message-ID: <20220616161945.eofmu3l4kzy77bb6@lion.mk-sys.cz>
References: <20220616155009.3609572-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l7a7d26jyn3vb2sz"
Content-Disposition: inline
In-Reply-To: <20220616155009.3609572-1-ivecera@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l7a7d26jyn3vb2sz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 16, 2022 at 05:50:09PM +0200, Ivan Vecera wrote:
> Commit 5b64c66f58d ("ethtool: Add netlink handler for
> getmodule=0D (-m)") provided a netlink variant for getmodule
> but also introduced a regression as netlink output is different
> from ioctl output that provides information from A2h page
> via sff8472_show_all().
>=20
> To fix this the netlink path should check a presence of A2h page
> by value of bit 6 in byte 92 of page A0h and if it is set then
> get A2h page and call sff8472_show_all().
>=20
> Fixes: 5b64c66f58d ("ethtool: Add netlink handler for getmodule=0D (-m)")

Looks like the leading "2" in commit id got lost and "^M" got into the
subject somehow. AFAICS this should be

  Fixes: 25b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")

Michal

--l7a7d26jyn3vb2sz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKrWBsACgkQ538sG/LR
dpVH4wgAmDKgfgPoDs0IoAL3wXy0ImI2dCchj+Iw02FH8UKMozx2hUG7W8ITk65z
wtyyUh15yABIkygr9jH8/C2Ltq30ZN/v8uQj9TbsvN1+Hve/4LMdCZXuNmHP1PHg
wJX5AOBLfIQP6jTdsTUqXdyx3wcEErVEVSPtsJ8KZNaH63lduvX/sPixNh6Jy6e2
Baab+IOUre5xndZgoKXK7XRpLsWuBj0ziH6ywVFcks2SL50sETKi4/kTVgbEpvU4
J0Qd6VdMuxaNO85rDXD1f0LfIsUuPRnOz/pPTTqz9yAVp17E8PoWopiF9ubDYPzJ
Fn2TuzhwUuZlt7j3rqnZz3PT6ySEGA==
=hLLq
-----END PGP SIGNATURE-----

--l7a7d26jyn3vb2sz--
