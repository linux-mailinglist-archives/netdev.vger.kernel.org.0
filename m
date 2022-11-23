Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21132636A44
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbiKWTzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiKWTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:55:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EF4B57
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:54:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EFD3E1F8B4;
        Wed, 23 Nov 2022 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1669233265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/SIuTSW6AIk5ukBRSB7KR0brKThwfaAQ7iR/WpsuQL8=;
        b=uL3oBdBdXkrIcrmH1DIaXdmWdn3Bhg/zDDvjJ4B35eE+8euzSs0mTBu5UIYv3O4S2an3+9
        I66R0iKJmsyRjKJ+TXB068zLbnrZ7IrZ4pTdJjpAAtV54X80/C5yxChoalZPe4Q1v6xG0M
        7tbV48A3hiQg+JpiBnLU8vv0WBlATKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1669233265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/SIuTSW6AIk5ukBRSB7KR0brKThwfaAQ7iR/WpsuQL8=;
        b=ynCTbmM/tNCtYFIVnSXHgq8JFZ/SJr8zawzKzJkbGNT+aLPSPQujz1/ddF76KI4Lt9r2Xu
        Pvc0h+AuUyO3ToDg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DCD252C141;
        Wed, 23 Nov 2022 19:54:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AD8D160954; Wed, 23 Nov 2022 20:54:22 +0100 (CET)
Date:   Wed, 23 Nov 2022 20:54:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v5] ethtool: add netlink based get rss support
Message-ID: <20221123195422.bjvm7y7i3pmtbhag@lion.mk-sys.cz>
References: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vhmygxsypnrnvrfq"
Content-Disposition: inline
In-Reply-To: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vhmygxsypnrnvrfq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 10:48:46AM -0800, Sudheer Mogilappagari wrote:
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
> in ioctl path. It fetches RSS table, hash key and hash function
> of an interface to user space. In addition ETHTOOL_A_RSS_RINGS
> attribute is added to return queue/rings count to user space.
> This simplifies user space implementation while maintaining
> backward compatibility of output.
>=20
> This patch implements existing functionality available
> in ioctl path and enables addition of new RSS context
> based parameters in future.
>=20
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> ---
> v5:
> -Updated documentation about ETHTOOL_A_RSS_RINGS attribute.
>=20
> v4:
> -Don't make context parameter mandatory.
> -Remove start/done ethtool_genl_ops for RSS_GET.
> -Add rings attribute to RSS_GET netlink message.
> -Fix documentation.
>=20
> v3:
> -Define parse_request and make use of ethnl_default_parse.
> -Have indir table and hask hey as seprate attributes.
> -Remove dumpit op for RSS_GET.
> -Use RSS instead of RXFH.
>=20
> v2: Fix cleanup in error path instead of returning.
> ---
>  Documentation/networking/ethtool-netlink.rst |  29 +++-
>  include/uapi/linux/ethtool_netlink.h         |  15 ++
>  net/ethtool/Makefile                         |   2 +-
>  net/ethtool/netlink.c                        |   7 +
>  net/ethtool/netlink.h                        |   2 +
>  net/ethtool/rss.c                            | 169 +++++++++++++++++++
>  6 files changed, 222 insertions(+), 2 deletions(-)
>  create mode 100644 net/ethtool/rss.c
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index bede24ef44fd..883555b8876b 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
[...]
> @@ -1687,6 +1689,31 @@ to control PoDL PSE Admin functions. This option i=
s implementing
>  ``IEEE 802.3-2018`` 30.15.1.2.1 acPoDLPSEAdminControl. See
>  ``ETHTOOL_A_PODL_PSE_ADMIN_STATE`` for supported values.
> =20
> +RSS_GET
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +Get indirection table, hash key and hash function info associated with a
> +RSS context of an interface similar to ``ETHTOOL_GRSSH`` ioctl request.
> +In addition ring count information is also returned to user space.
> +
> +Request contents:
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_RSS_HEADER``             nested  request header
> +  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
> + =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_RSS_HEADER``             nested  reply header
> +  ``ETHTOOL_A_RSS_CONTEXT``            u32     RSS context number
> +  ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
> +  ``ETHTOOL_A_RSS_RINGS``              u32     Ring count
> +  ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
> +  ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
> + =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

It would be helpful to have some basic information about the attributes
here, e.g. a mention that ETHTOOL_A_RSS_CONTEXT is optional, the format
of ETHTOOL_A_RSS_INDIR and ETHTOOL_A_RSS_HKEY or which constants are
returned in ETHTOOL_A_RSS_HFUNC.

> +
>  Request translation
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> @@ -1768,7 +1795,7 @@ are netlink only.
>    ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>    ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
>    ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
> -  ``ETHTOOL_GRSSH``                   n/a
> +  ``ETHTOOL_GRSSH``                   ``ETHTOOL_MSG_RSS_GET``
>    ``ETHTOOL_SRSSH``                   n/a
>    ``ETHTOOL_GTUNABLE``                n/a
>    ``ETHTOOL_STUNABLE``                n/a

Now that ETHTOOL_MSG_RSS_GET returns also the number of Rx rings,
ETHTOOL_GRXRINGS should also map to it.

> diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
> new file mode 100644
> index 000000000000..86b9e0de954c
> --- /dev/null
> +++ b/net/ethtool/rss.c
[...]
> +static int
> +rss_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct rss_req_info *request =3D RSS_REQINFO(req_info);
> +
> +	if (!tb[ETHTOOL_A_RSS_CONTEXT]) {
> +		request->rss_context =3D 0;
> +		return 0;
> +	}
> +
> +	request->rss_context =3D nla_get_u32(tb[ETHTOOL_A_RSS_CONTEXT]);
> +	return 0;
> +}

Just a note: the request structure is guaranteed to be zeroed so that

	if (tb[ETHTOOL_A_RSS_CONTEXT])
		request->rss_context =3D nla_get_u32(tb[ETHTOOL_A_RSS_CONTEXT]);
	return 0;

would suffice. But it can stay like this if you prefer.

> +
> +static int
> +rss_prepare_data(const struct ethnl_req_info *req_base,
> +		 struct ethnl_reply_data *reply_base, struct genl_info *info)
> +{
> +	struct rss_reply_data *data =3D RSS_REPDATA(reply_base);
> +	struct rss_req_info *request =3D RSS_REQINFO(req_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	struct ethtool_rxnfc rings;
> +	const struct ethtool_ops *ops;
> +	u32 total_size, indir_bytes;
> +	u8 dev_hfunc =3D 0;
> +	u8 *rss_config;
> +	int ret;
> +
> +	ops =3D dev->ethtool_ops;
> +	if (!ops->get_rxfh)
> +		return -EOPNOTSUPP;
> +
> +	/* Some drivers don't handle rss_context */
> +	if (request->rss_context && !ops->get_rxfh_context)
> +		return -EOPNOTSUPP;
> +
> +	data->rss_context =3D request->rss_context;
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	data->indir_size =3D 0;
> +	data->hkey_size =3D 0;
> +	if (ops->get_rxfh_indir_size)
> +		data->indir_size =3D ops->get_rxfh_indir_size(dev);
> +	if (ops->get_rxfh_key_size)
> +		data->hkey_size =3D ops->get_rxfh_key_size(dev);
> +
> +	indir_bytes =3D data->indir_size * sizeof(u32);
> +	total_size =3D indir_bytes + data->hkey_size;
> +	rss_config =3D kzalloc(total_size, GFP_KERNEL);
> +	if (!rss_config) {
> +		ret =3D -ENOMEM;
> +		goto out_ops;
> +	}
> +
> +	if (data->indir_size)
> +		data->indir_table =3D (u32 *)rss_config;
> +
> +	if (data->hkey_size)
> +		data->hkey =3D rss_config + indir_bytes;
> +
> +	if (data->rss_context)
> +		ret =3D ops->get_rxfh_context(dev, data->indir_table, data->hkey,
> +					    &dev_hfunc, data->rss_context);
> +	else
> +		ret =3D ops->get_rxfh(dev, data->indir_table, data->hkey,
> +				    &dev_hfunc);
> +
> +	if (ret)
> +		goto out_ops;
> +
> +	data->hfunc =3D dev_hfunc;
> +	rings.cmd =3D ETHTOOL_GRXRINGS;
> +	ops->get_rxnfc(dev, &rings, NULL);
> +	data->rings =3D rings.data;

ops->get_rxnfc is not checked for null.

> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +	return ret;
> +}
> +
> +static int
> +rss_reply_size(const struct ethnl_req_info *req_base,
> +	       const struct ethnl_reply_data *reply_base)
> +{
> +	const struct rss_reply_data *data =3D RSS_REPDATA(reply_base);
> +	int len;
> +
> +	len =3D  nla_total_size(sizeof(u32)) +	/* _RSS_CONTEXT */
> +	       nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
> +	       nla_total_size(sizeof(u32)) +	/* _RSS_RINGS */
> +	       nla_total_size(sizeof(u32)) * data->indir_size + /* _RSS_INDIR */

As discussed before, nla_total_size() counts also the netlink attribute
header so that nla_total_size(sizeof(u32)) is 8, not 4. Therefore we
need

  nla_total_size(sizeof(u32) * data->indir_size)

instead. Fortunately it's incorrect "in the good direction"
(overestimating the length) but I would still prefer to have the correct
estimate.

> +	       data->hkey_size;			/* _RSS_HKEY */

This should be nla_total_size(data->hkey_size) to count the attribute
header and potential padding.

> +
> +	return len;
> +}
> +
> +static int
> +rss_fill_reply(struct sk_buff *skb, const struct ethnl_req_info *req_bas=
e,
> +	       const struct ethnl_reply_data *reply_base)
> +{
> +	const struct rss_reply_data *data =3D RSS_REPDATA(reply_base);
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_RSS_CONTEXT, data->rss_context) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RSS_RINGS, data->rings) ||
> +	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
> +		    sizeof(u32) * data->indir_size, data->indir_table) ||
> +	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey))
> +		return -EMSGSIZE;

The optional attributes should be only added if they are to be returned.

Michal

--vhmygxsypnrnvrfq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmN+emgACgkQ538sG/LR
dpUjGwf8CIoUoAdwU4lgaw0evJRS3ZqK+w88zHIDh6j9ubW8xH1w1V1q11nvfZi0
sT0/8X0tFULNvds0v6ekiCs7t5kY+rl9gRH2F0xwW7MlpUgEubhNkLscnwHtZgdj
SUAPh8wq+/sGdGGsovZUU2POR0AD0ZfqcCr2cm0baN9+mIK6BziEBznR7WdN8l3A
Q/IYF04TA+vd4V+Cjva92/X6jxQvjIHEBDKbOi2ao14ghvsv9RqGUJxo3E+iPgMs
0XnDZekxGEMXssbq8avmYiJoJU1eOWxSAuBjPWGqTMJVjuQbavUGJbAZR6gmfGKE
AnMfEWTb2t5j2TSVnq17btib4HGElQ==
=XmF9
-----END PGP SIGNATURE-----

--vhmygxsypnrnvrfq--
