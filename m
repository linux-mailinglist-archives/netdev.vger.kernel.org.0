Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAD4567D8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhKSCKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhKSCKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:10:01 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC679C061574;
        Thu, 18 Nov 2021 18:06:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so35823610edb.8;
        Thu, 18 Nov 2021 18:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sy5gTTFulPpJ8wmOoZB3V7rj1SaJOS29bzWAZosYg9s=;
        b=oTTvKeFJysJeNDkq6JhvFlpjnCZNme94N4CIUYGzREVhw/75rT5afwjMrK7HLthvsn
         PYZ/OEQvBTs6rVFIIib3r+AR/uakslyoyQNcOh0+7taU2yuBEE3wV19Aqy+fyRlZMLFk
         oj/70NDp31DC+dnZowzIspgAIKOHOKZVFYX2gnuN8omH18P46dWKZ3boPYAPsmPXPQ22
         4rNUQGok7lmVJTjMThyV24EkIcRbY5fp90iZqq/QCOv6KqpBnFHSbvXVx2Sj6mdEJHej
         mC5jbFxMRdqpGtzBSQLths2r5C1s+9iKPWhXmkT8iFpLSbemnl4+E7eD6K+NIntGZo9k
         dJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sy5gTTFulPpJ8wmOoZB3V7rj1SaJOS29bzWAZosYg9s=;
        b=NSng64FpWjJ3Yxe/VXquZNahClXxW3bvkF8O4EOGFta09ef+1uNV8TdMtUO+M5DyTj
         JzkXk2u9xsn12Qqa3jqrqA9MdaSF/BQUEhO/hiidW0hABcucsc5GHMP1Est5Qkviwcub
         AMgIQjOzTfU1j4gAi74PHJXRGZ9EyaupHareklq27RQwBJ89qpRl7zXHDCQJ93FOV5LH
         DnF7ZfGCUF2Pc4Z0DwJtJJCqmahKeqGPlGSFa4Xp2KeWWYYw4wPgIEVeu+sV+7AcU7CK
         1YThHEMqx1ocnexMqBDU0MF0p9lusm0A8fJFbnreNvyrFjrgR5Gh7ArKqSZ01aijQFtd
         U+5w==
X-Gm-Message-State: AOAM531EbcmWQ0BcLTzDtg3zwOOqPFASNFqSbY1+z+u/u4expjANb04s
        uxY2REN9jomNeZtcgKIVU08=
X-Google-Smtp-Source: ABdhPJznGI2HWYR0tspouX3S6CwWUUrWUtM7PDNvoVdAsKOD2xr+IULL6OlvwHCLDgnjTucoCZ9EhQ==
X-Received: by 2002:a05:6402:5146:: with SMTP id n6mr18428106edd.126.1637287618437;
        Thu, 18 Nov 2021 18:06:58 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id e1sm528345ejy.82.2021.11.18.18.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:06:58 -0800 (PST)
Date:   Fri, 19 Nov 2021 04:06:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 14/19] net: dsa: qca8k: add support for
 mdb_add/del
Message-ID: <20211119020657.77os25yh4vhiukvi@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-15-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-15-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:46PM +0100, Ansuel Smith wrote:
> Add support for mdb add/del function. The ARL table is used to insert
> the rule. A new search function is introduced to search the rule and add
> additional port to it. If every port is removed from the rule, it's
> removed. It's set STATIC in the ARL table (aka it doesn't age) to not be
> flushed by fast age function.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 82 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index dda99263fe8c..a217c842ab45 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -417,6 +417,23 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +qca8k_fdb_search(struct qca8k_priv *priv, struct qca8k_fdb *fdb, const u8 *mac, u16 vid)
> +{
> +	int ret;
> +
> +	mutex_lock(&priv->reg_mutex);

If I were you, I'd create a locking scheme where the entire FDB entry is
updated under the same critical section. Right now you're relying on the
rtnl_mutex serializing calls to ->port_mdb_add()/->port_mdb_del(). But
that might change. Don't leave that task to someone that has non-expert
knowledge of the driver.

> +	qca8k_fdb_write(priv, vid, 0, mac, 0);
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = qca8k_fdb_read(priv, fdb);
> +exit:
> +	mutex_unlock(&priv->reg_mutex);
> +	return ret;
> +}
> +
>  static int
>  qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
>  {
> @@ -1959,6 +1976,69 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static int
> +qca8k_port_mdb_add(struct dsa_switch *ds, int port,
> +		   const struct switchdev_obj_port_mdb *mdb)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	struct qca8k_fdb fdb = { 0 };
> +	const u8 *addr = mdb->addr;
> +	u8 port_mask = BIT(port);

This doesn't really need to be kept in a temporary variable as it is
only used once.

> +	u16 vid = mdb->vid;
> +	int ret;
> +
> +	/* Check if entry already exist */
> +	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Rule exist. Delete first */
> +	if (!fdb.aging) {
> +		ret = qca8k_fdb_del(priv, addr, fdb.port_mask, vid);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Add port to fdb portmask */
> +	fdb.port_mask |= port_mask;
> +
> +	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
> +}
> +
> +static int
> +qca8k_port_mdb_del(struct dsa_switch *ds, int port,
> +		   const struct switchdev_obj_port_mdb *mdb)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	struct qca8k_fdb fdb = { 0 };
> +	const u8 *addr = mdb->addr;
> +	u8 port_mask = BIT(port);
> +	u16 vid = mdb->vid;
> +	int ret;
> +
> +	/* Check if entry already exist */
> +	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Rule doesn't exist. Why delete? */

Because refcounting is hard. In fact with VLANs it is quite possible to
delete an absent entry. For MDBs and FDBs, the bridge should now error
out before it even reaches to you.

> +	if (!fdb.aging)
> +		return -EINVAL;
> +
> +	ret = qca8k_fdb_del(priv, addr, port_mask, vid);
> +	if (ret)
> +		return ret;
> +
> +	/* Only port in the rule is this port. Don't re insert */
> +	if (fdb.port_mask == port_mask)
> +		return 0;
> +
> +	/* Remove port from port mask */
> +	fdb.port_mask &= ~port_mask;
> +
> +	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
> +}
> +
>  static int
>  qca8k_port_mirror_add(struct dsa_switch *ds, int port,
>  		      struct dsa_mall_mirror_tc_entry *mirror,
> @@ -2160,6 +2240,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_fdb_add		= qca8k_port_fdb_add,
>  	.port_fdb_del		= qca8k_port_fdb_del,
>  	.port_fdb_dump		= qca8k_port_fdb_dump,
> +	.port_mdb_add		= qca8k_port_mdb_add,
> +	.port_mdb_del		= qca8k_port_mdb_del,
>  	.port_mirror_add	= qca8k_port_mirror_add,
>  	.port_mirror_del	= qca8k_port_mirror_del,
>  	.port_vlan_filtering	= qca8k_port_vlan_filtering,
> -- 
> 2.32.0
> 

