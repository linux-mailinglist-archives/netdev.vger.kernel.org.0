Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D964587D6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhKVBvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhKVBva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:51:30 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1CC061574;
        Sun, 21 Nov 2021 17:48:24 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z5so69873967edd.3;
        Sun, 21 Nov 2021 17:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i1J0Xb2sfQHrmsobBbTZtxUiY6+9/kLkq8Mq2CDUntQ=;
        b=PR3MPsCr6h037YzD86rArigSgb4AenakNnTh8X+OxJVl1Il+XYdl5x9fp6SPA+ZjWt
         Dv9O2gtBNeWtGD2TymMzlQEmEmMmsAa/8hv1xykOAARGARaHLExx6D+mtUp0Oxx2jkrX
         JCQu2PNy4M1l7JYVhAjY6ZwHBT+BmKahlZrdhCyraiQZ76PsQhd4eD1mrUqf5NimDFl3
         1sM0jKTRKs64jgPTvQ0JlOMybKr9drN6Q65TqGkPP6Xh0mpFdPIT7vAEKINtyPOTYDQ7
         BuRnnUV3un78y//tputIt9tDw99HihC0d2S8JkcM+ayz6TaxfI9aruQwmH88NgTWxyok
         bIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i1J0Xb2sfQHrmsobBbTZtxUiY6+9/kLkq8Mq2CDUntQ=;
        b=6SXPHrCi6gE6MqIH5wHdwmm8dSDbTYf1iGhgqj+eYLuA5BDEUIq+CYDCu1Bo760KeL
         jXJUPlZnSGi54dqyIv5LwTTU/Wr1BsUfqKcFreia1UtMNgGNZy0dAhxd6IxGJahtN0X8
         OH/RHawfLPu9i0AHJo+F1jG/+d/joY3o/deXehqqP+eDjzOfuVTH+2VPH6uPx61LClWG
         c+OAquHXY0Lc+wmG818J0O36roNkbPu013dbGfwkdO2naNKsqtBHnAEkQKavHMCvG7Oi
         xpFn6/I0UPdfrkkrUgWDszPTbl8pLTa3laBpX/8puIrp54L86q3/xBgT57mx/QnbKNbl
         WWzQ==
X-Gm-Message-State: AOAM5323rMv5SLbp0Ririv7xj3a/kCwKtP15CmFLKjwjM4AEL9mY+nLh
        f89SIOjKsUf6GL77YOvfBmU=
X-Google-Smtp-Source: ABdhPJwSbzrFapuOgEJps4E94InvBYzusW40ToT/ETszC0Ee+/UDoKKO64HIvAOzs4VSdvbnQjmhww==
X-Received: by 2002:aa7:d412:: with SMTP id z18mr27181312edq.315.1637545702893;
        Sun, 21 Nov 2021 17:48:22 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id gn26sm3005025ejc.14.2021.11.21.17.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:48:22 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:48:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 9/9] net: dsa: qca8k: add support for
 mdb_add/del
Message-ID: <20211122014821.syd7qrlthenwak4b@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:13AM +0100, Ansuel Smith wrote:
> Add support for mdb add/del function. The ARL table is used to insert
> the rule. The rule will be searched, deleted and reinserted with the
> port mask updated. The function will check if the rule has to be updated
> or insert directly with no deletion of the old rule.
> If every port is removed from the port mask, the rule is removed.
> The rule is set STATIC in the ARL table (aka it doesn't age) to not be
> flushed by fast age function.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 97 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 21a7f1ed7a5c..e37528c8dbf2 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -417,6 +417,79 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask, const u8 *mac, u16 vid)

FYI the networking tree is still sticking to its guns w.r.t. the 80
character per line limit. You can ignore the rule if you want to and it
makes sense, for example if you're printing a long string on nearby
lines (which shouldn't be split into multiple lines, because people grep
for error messages) and therefore it wouldn't look so out of place to
also have lines that are a bit longer. But in this case, the function
prototypes are sticking out like a sore thumb IMO, the nearby lines are
short otherwise.

And to be honest I don't understand your choice of where to split the
line either, this consumes two lines too, but doesn't exceed 80 characters:

static int qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
				       const u8 *mac, u16 vid)

Otherwise:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +{
> +	struct qca8k_fdb fdb = { 0 };
> +	int ret;
> +
> +	mutex_lock(&priv->reg_mutex);
> +
> +	qca8k_fdb_write(priv, vid, 0, mac, 0);
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = qca8k_fdb_read(priv, &fdb);
> +	if (ret < 0)
> +		goto exit;
> +
> +	/* Rule exist. Delete first */
> +	if (!fdb.aging) {
> +		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
> +		if (ret)
> +			goto exit;
> +	}
> +
> +	/* Add port to fdb portmask */
> +	fdb.port_mask |= port_mask;
> +
> +	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
> +
> +exit:
> +	mutex_unlock(&priv->reg_mutex);
> +	return ret;
> +}
> +
> +static int
> +qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask, const u8 *mac, u16 vid)
> +{
> +	struct qca8k_fdb fdb = { 0 };
> +	int ret;
> +
> +	mutex_lock(&priv->reg_mutex);
> +
> +	qca8k_fdb_write(priv, vid, 0, mac, 0);
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
> +	if (ret < 0)
> +		goto exit;
> +
> +	/* Rule doesn't exist. Why delete? */
> +	if (!fdb.aging) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
> +	if (ret)
> +		goto exit;
> +
> +	/* Only port in the rule is this port. Don't re insert */
> +	if (fdb.port_mask == port_mask)
> +		goto exit;
> +
> +	/* Remove port from port mask */
> +	fdb.port_mask &= ~port_mask;
> +
> +	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
> +	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
> +
> +exit:
> +	mutex_unlock(&priv->reg_mutex);
> +	return ret;
> +}
> +
>  static int
>  qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
>  {
> @@ -1915,6 +1988,28 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static int
> +qca8k_port_mdb_add(struct dsa_switch *ds, int port,
> +		   const struct switchdev_obj_port_mdb *mdb)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	const u8 *addr = mdb->addr;
> +	u16 vid = mdb->vid;
> +
> +	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
> +}
> +
> +static int
> +qca8k_port_mdb_del(struct dsa_switch *ds, int port,
> +		   const struct switchdev_obj_port_mdb *mdb)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	const u8 *addr = mdb->addr;
> +	u16 vid = mdb->vid;
> +
> +	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
> +}
> +
>  static int
>  qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>  			  struct netlink_ext_ack *extack)
> @@ -2023,6 +2118,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_fdb_add		= qca8k_port_fdb_add,
>  	.port_fdb_del		= qca8k_port_fdb_del,
>  	.port_fdb_dump		= qca8k_port_fdb_dump,
> +	.port_mdb_add		= qca8k_port_mdb_add,
> +	.port_mdb_del		= qca8k_port_mdb_del,
>  	.port_vlan_filtering	= qca8k_port_vlan_filtering,
>  	.port_vlan_add		= qca8k_port_vlan_add,
>  	.port_vlan_del		= qca8k_port_vlan_del,
> -- 
> 2.32.0
> 

