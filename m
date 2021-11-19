Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384CE4567FA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhKSCWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbhKSCWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:22:35 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D262EC061574;
        Thu, 18 Nov 2021 18:19:34 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so36032343edd.3;
        Thu, 18 Nov 2021 18:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=hb5aPgBnkKqCPy5/Q4m/uS3CM2nzkIbj5X/U4QcG1nI=;
        b=Pa2/jq6HSjmIt72rJbja71HdzXCrXUqt97EHT4c2xzU2Ac/4XUJiYqYln0hHd2+G7l
         0mhXkitK4PVdkcWEgiXUPJPYsH+sXxptXia5iq5bKroNDO0RbfTzuK7c8gyM0SZT2sOg
         hoehN1sNMDDBrNpSORF0BdDgUszA5Dm3asJt7IAB7V6NFenHLzD2Q0rICydtbERnqph8
         SgYIRNEkaqBHXWJ4rA/n5BpF/nl9LLRe4FjIjFGeySGHtWYu0+c6Ox9hWIyRfvKM2Yq7
         cyOT611H/VoD3lIhAuTqMSdcSERe2+rYEoxciblt5x+J03CrL9G+93e67zRMeihtDBqN
         pg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=hb5aPgBnkKqCPy5/Q4m/uS3CM2nzkIbj5X/U4QcG1nI=;
        b=fa8O0WA9KVFMxmhG33gm6lsWrETMNDOvkWUUbaOnp3PVB7hQMTP6nog+N5MZKiiqSW
         MjjhYuMHvUmFrleAPwGQ7oBzP5PyZPhOCHOKqpAYmaUnXWcidBH6KMq9MWHPdctmbxoF
         G/NtzUudNdhdtklEUlPdsL/E2sL9Iv/X9HrnOBkf1779cJwzT0DZJQ28xXhdlTp4rTo1
         pk9qUzy7xJkjdDBJexZV+eRcFZ0Br4rJ9clhhUZtwsdOciUN8xsfOFFgC22uZBUHDbU1
         dJHDpLGh+HJ4U+psTV+XJxkh6HRPxgklDbsksWL2wuGIAA6d4qaolM1toEnm86ln+S9t
         wPkQ==
X-Gm-Message-State: AOAM5313/prt5qukLSDEKswdWhhxWtJtbsD9U/6UYT8d61da8PUz3QLY
        j34+EImpU1cuJfXmNcHPMZR0xnmXj+g=
X-Google-Smtp-Source: ABdhPJz1T6eKOiQwkS82Fhkxyp7kR0T2pWtdmxOgGn9QKAeg0kKbmzbBkxtrR61o2kEIt1qAKN9TGQ==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr2802959ejc.275.1637288373297;
        Thu, 18 Nov 2021 18:19:33 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id l16sm860409edb.59.2021.11.18.18.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:19:33 -0800 (PST)
Message-ID: <619709b5.1c69fb81.83cb5.4150@mx.google.com>
X-Google-Original-Message-ID: <YZcJsuH/1yMaRkoX@Ansuel-xps.>
Date:   Fri, 19 Nov 2021 03:19:30 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 14/19] net: dsa: qca8k: add support for
 mdb_add/del
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-15-ansuelsmth@gmail.com>
 <20211119020657.77os25yh4vhiukvi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020657.77os25yh4vhiukvi@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 04:06:57AM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 10:04:46PM +0100, Ansuel Smith wrote:
> > Add support for mdb add/del function. The ARL table is used to insert
> > the rule. A new search function is introduced to search the rule and add
> > additional port to it. If every port is removed from the rule, it's
> > removed. It's set STATIC in the ARL table (aka it doesn't age) to not be
> > flushed by fast age function.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 82 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 82 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index dda99263fe8c..a217c842ab45 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -417,6 +417,23 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
> >  	mutex_unlock(&priv->reg_mutex);
> >  }
> >  
> > +static int
> > +qca8k_fdb_search(struct qca8k_priv *priv, struct qca8k_fdb *fdb, const u8 *mac, u16 vid)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&priv->reg_mutex);
> 
> If I were you, I'd create a locking scheme where the entire FDB entry is
> updated under the same critical section. Right now you're relying on the
> rtnl_mutex serializing calls to ->port_mdb_add()/->port_mdb_del(). But
> that might change. Don't leave that task to someone that has non-expert
> knowledge of the driver.
>

Ok will change the logic and do the search and add/del operation in one
lock.

> > +	qca8k_fdb_write(priv, vid, 0, mac, 0);
> > +	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
> > +	if (ret < 0)
> > +		goto exit;
> > +
> > +	ret = qca8k_fdb_read(priv, fdb);
> > +exit:
> > +	mutex_unlock(&priv->reg_mutex);
> > +	return ret;
> > +}
> > +
> >  static int
> >  qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
> >  {
> > @@ -1959,6 +1976,69 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
> >  	return 0;
> >  }
> >  
> > +static int
> > +qca8k_port_mdb_add(struct dsa_switch *ds, int port,
> > +		   const struct switchdev_obj_port_mdb *mdb)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +	struct qca8k_fdb fdb = { 0 };
> > +	const u8 *addr = mdb->addr;
> > +	u8 port_mask = BIT(port);
> 
> This doesn't really need to be kept in a temporary variable as it is
> only used once.
> 
> > +	u16 vid = mdb->vid;
> > +	int ret;
> > +
> > +	/* Check if entry already exist */
> > +	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Rule exist. Delete first */
> > +	if (!fdb.aging) {
> > +		ret = qca8k_fdb_del(priv, addr, fdb.port_mask, vid);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/* Add port to fdb portmask */
> > +	fdb.port_mask |= port_mask;
> > +
> > +	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
> > +}
> > +
> > +static int
> > +qca8k_port_mdb_del(struct dsa_switch *ds, int port,
> > +		   const struct switchdev_obj_port_mdb *mdb)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +	struct qca8k_fdb fdb = { 0 };
> > +	const u8 *addr = mdb->addr;
> > +	u8 port_mask = BIT(port);
> > +	u16 vid = mdb->vid;
> > +	int ret;
> > +
> > +	/* Check if entry already exist */
> > +	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Rule doesn't exist. Why delete? */
> 
> Because refcounting is hard. In fact with VLANs it is quite possible to
> delete an absent entry. For MDBs and FDBs, the bridge should now error
> out before it even reaches to you.
> 

So in this specific case I should simply return 0 to correctly decrement
the ref, correct? 

> > +	if (!fdb.aging)
> > +		return -EINVAL;
> > +
> > +	ret = qca8k_fdb_del(priv, addr, port_mask, vid);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Only port in the rule is this port. Don't re insert */
> > +	if (fdb.port_mask == port_mask)
> > +		return 0;
> > +
> > +	/* Remove port from port mask */
> > +	fdb.port_mask &= ~port_mask;
> > +
> > +	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
> > +}
> > +
> >  static int
> >  qca8k_port_mirror_add(struct dsa_switch *ds, int port,
> >  		      struct dsa_mall_mirror_tc_entry *mirror,
> > @@ -2160,6 +2240,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> >  	.port_fdb_add		= qca8k_port_fdb_add,
> >  	.port_fdb_del		= qca8k_port_fdb_del,
> >  	.port_fdb_dump		= qca8k_port_fdb_dump,
> > +	.port_mdb_add		= qca8k_port_mdb_add,
> > +	.port_mdb_del		= qca8k_port_mdb_del,
> >  	.port_mirror_add	= qca8k_port_mirror_add,
> >  	.port_mirror_del	= qca8k_port_mirror_del,
> >  	.port_vlan_filtering	= qca8k_port_vlan_filtering,
> > -- 
> > 2.32.0
> > 
> 

-- 
	Ansuel
