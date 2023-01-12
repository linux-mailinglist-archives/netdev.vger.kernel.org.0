Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F3666C16
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbjALIHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbjALIHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:07:12 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C0F11463
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 00:06:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 537CF3EC11;
        Thu, 12 Jan 2023 08:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673510808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rHA0mONHFBanvQ8JdOSuKt5Hrcj83/2u9ZiTiU7vQCE=;
        b=DWD1c7gd0Sz3unWbZdkg7XT7OreUMemR1Q6iBXG6oXQyiSfa+0pBKLN05zLIR4gigZGUDy
        2Dks5nHeynUVCtW/S69p7vMQlrf43xNINu2/CQaApj2l8LaW/THX09MepS2KIQZJKvrtL+
        kGCoL8b5gbGiueLoXQxfUjY7TmIUzr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673510808;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rHA0mONHFBanvQ8JdOSuKt5Hrcj83/2u9ZiTiU7vQCE=;
        b=StYW4zuvhXWlDx6RLFq+2jw/JAiIpqvD9MdoFqvUy59MMLunuzUS93m/Y0OXkDKw/HX5Pm
        SkD6AO3tvDGA0+DQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 492712C141;
        Thu, 12 Jan 2023 08:06:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EF45C6052E; Thu, 12 Jan 2023 09:06:45 +0100 (CET)
Date:   Thu, 12 Jan 2023 09:06:45 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net] ethtool:add netlink attr in rss get reply only if
 value is not null
Message-ID: <20230112080645.4hxuzj4ygzkkx7b7@lion.mk-sys.cz>
References: <20230111235607.85509-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jhp2s67z4rabilnt"
Content-Disposition: inline
In-Reply-To: <20230111235607.85509-1-sudheer.mogilappagari@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jhp2s67z4rabilnt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2023 at 03:56:07PM -0800, Sudheer Mogilappagari wrote:
> Current code for RSS_GET ethtool command includes netlink attributes
> in reply message to user space even if they are null. Added checks
> to include netlink attribute in reply message only if a value is
> received from driver. Drivers might return null for RSS indirection
> table or hash key. Instead of including attributes with empty value
> in the reply message, add netlink attribute only if there is content.
>=20
> Fixes: 7112a04664bf ("ethtool: add netlink based get rss support")
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Note: the code was added in 6.2-rc1 merge window so that it is still
safe to change the output before 6.2 final without risk of "breaking the
userspace".

Michal

> ---
>  net/ethtool/rss.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
> index ebe6145aed3f..be260ab34e58 100644
> --- a/net/ethtool/rss.c
> +++ b/net/ethtool/rss.c
> @@ -122,10 +122,13 @@ rss_fill_reply(struct sk_buff *skb, const struct et=
hnl_req_info *req_base,
>  {
>  	const struct rss_reply_data *data =3D RSS_REPDATA(reply_base);
> =20
> -	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
> -	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
> -		    sizeof(u32) * data->indir_size, data->indir_table) ||
> -	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey))
> +	if ((data->hfunc &&
> +	     nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc)) ||
> +	    (data->indir_size &&
> +	     nla_put(skb, ETHTOOL_A_RSS_INDIR,
> +		     sizeof(u32) * data->indir_size, data->indir_table)) ||
> +	    (data->hkey_size &&
> +	     nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey)))
>  		return -EMSGSIZE;
> =20
>  	return 0;
> --=20
> 2.31.1
>=20

--jhp2s67z4rabilnt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmO/v40ACgkQ538sG/LR
dpW57Qf+POu4Kt78VPCzs4BXtBO/Q+DorS3wodFsQ7ud1WkbacPNqM3PuxUzg68s
Djev4jLWPRrNRSiAMxh2maFRQiL27PyebUJvQwPPMQ2zOWX4rdAveBpgZL+HgnQs
mCMJ9QwXczBwMh6QuyQ9Phq1NX8IvmkXPpFgKdFbM5u5Pv3NuuOUv7mVYQO2MkRH
BS/G+f5P5EY3DJX6fl9QsMP/iEnGiP5a+3TEdYGMRQcu/84rIBsdU9TDjKkvaiM6
Zg8Hb1kxnhoWNsCH6/H+jgng10M3tv+V/y3l+mhzISAdgvWdHz7X3HXVc14WEkXU
VM7thwtyLHRPaPFrmH5pY9Z9+VWIKg==
=AOiK
-----END PGP SIGNATURE-----

--jhp2s67z4rabilnt--
