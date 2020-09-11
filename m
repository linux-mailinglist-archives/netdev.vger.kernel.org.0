Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B47326627C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgIKPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgIKPs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:48:26 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26833C061786;
        Fri, 11 Sep 2020 08:48:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so14468050ejb.1;
        Fri, 11 Sep 2020 08:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yfq8mhLzBQ1KFwMRJwpAyIxVLnM24Bwo6yRLbuTpTrg=;
        b=eGVNHZ+xZIxSU88fSYKg0SMen0jp9gNJxpoTd3XJqL3iM6MCx/mXDnrCtEeASAlQry
         xg50hVEzbbZH4OAvRvC8cGhMjzAh6dSoft/ckUQQhe7O5IsD9tpRWALIGjSXy0HEJu+e
         z0n7HRbl6DFJt+ICoVF3/USrvQ2tgEfrRDNz/CZ2ewIj7BmejnyYO9Y95PjnTv0MdeBw
         3X/UgpLJSCvz+qm01G9JHBSCSCD+xgkN9OEpevc2t5TKm7fFdce0TKpr+0HkhwTDuFh0
         HMA/lwX70s43ZXLuBYMPCq1Y3OAWw5gJxA8gKjKBNtBKC4HAVSX3iP4TNtb3KPM0+Rqi
         B3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yfq8mhLzBQ1KFwMRJwpAyIxVLnM24Bwo6yRLbuTpTrg=;
        b=EGhEkJEf+lRGl90XsBsp+CE7DgKjpS2mebpbiGAsTsCoBl4dWCQlvMXUstSnnfN//6
         aJUKR0hzkIR7XB9gdBtVn3O50uM4PAN+oqXg57k9Uylsb63ajoucPEy7N7wkuUc1l3wj
         Dn7tI4/S7ivntx7DgI42zEeJQvt6Hhhe4C88SHRVr1KJTiGn8MCTmsFz1op/26e1v+WO
         c3p5GAzz1epXFiWeY2Qrp8nqLPkUCunzpHbt1dIjNJ6I6QP37Nt04KhXg9nu9X3QtT0Q
         UPRXDlC4KWibJY7rSz9JfAI2UzuwfhdG5RRreJSuJUG4qy8FCuGxXJFUJWLCe2oGOQ5M
         O/cw==
X-Gm-Message-State: AOAM532pQ18Ayqg0rbEmoYELTHFzL1ISm+Zd/DHhEdj5PasaaWxxH6oS
        ZNqFEoneHqkhIBJDIJm1tO4=
X-Google-Smtp-Source: ABdhPJxhZJs5pB8DvTPdxmDxp9Oe1cHmS5A8p5N3ibhqe1zeGh7gcP9CjNMYo6J6v6LNjAUktkVszA==
X-Received: by 2002:a17:906:bc52:: with SMTP id s18mr2505209ejv.398.1599839291789;
        Fri, 11 Sep 2020 08:48:11 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id a15sm1801209ejy.118.2020.09.11.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 08:48:11 -0700 (PDT)
Date:   Fri, 11 Sep 2020 18:48:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: b53: Configure VLANs while not
 filtering
Message-ID: <20200911154809.jc72jesrctvmiqtr@skbuf>
References: <20200911041905.58191-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911041905.58191-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 09:19:05PM -0700, Florian Fainelli wrote:
> Update the B53 driver to support VLANs while not filtering. This
> requires us to enable VLAN globally within the switch upon driver
> initial configuration (dev->vlan_enabled).
>
> We also need to remove the code that dealt with PVID re-configuration in
> b53_vlan_filtering() since that function worked under the assumption
> that it would only be called to make a bridge VLAN filtering, or not
> filtering, and we would attempt to move the port's PVID accordingly.
>
> Now that VLANs are programmed all the time, even in the case of a
> non-VLAN filtering bridge, we would be programming a default_pvid for
> the bridged switch ports.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Not sure it's worth a lot, but:

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/b53/b53_common.c | 23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 6a5796c32721..46ac8875f870 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1377,23 +1377,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
>  int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
>  {
>  	struct b53_device *dev = ds->priv;
> -	u16 pvid, new_pvid;
> -
> -	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
> -	if (!vlan_filtering) {
> -		/* Filtering is currently enabled, use the default PVID since
> -		 * the bridge does not expect tagging anymore
> -		 */
> -		dev->ports[port].pvid = pvid;
> -		new_pvid = b53_default_pvid(dev);
> -	} else {
> -		/* Filtering is currently disabled, restore the previous PVID */
> -		new_pvid = dev->ports[port].pvid;
> -	}
> -
> -	if (pvid != new_pvid)
> -		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
> -			    new_pvid);
>
>  	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
>
> @@ -1444,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>  			untagged = true;
>
>  		vl->members |= BIT(port);
> -		if (untagged && !dsa_is_cpu_port(ds, port))
> +		if (untagged)
>  			vl->untag |= BIT(port);
>  		else
>  			vl->untag &= ~BIT(port);
> @@ -1482,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>  		if (pvid == vid)
>  			pvid = b53_default_pvid(dev);
>
> -		if (untagged && !dsa_is_cpu_port(ds, port))
> +		if (untagged)
>  			vl->untag &= ~(BIT(port));
>
>  		b53_set_vlan_entry(dev, vid, vl);
> @@ -2619,6 +2602,8 @@ struct b53_device *b53_switch_alloc(struct device *base,
>  	dev->priv = priv;
>  	dev->ops = ops;
>  	ds->ops = &b53_switch_ops;
> +	ds->configure_vlan_while_not_filtering = true;
> +	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
>  	mutex_init(&dev->reg_mutex);
>  	mutex_init(&dev->stats_mutex);
>
> --
> 2.25.1
>
