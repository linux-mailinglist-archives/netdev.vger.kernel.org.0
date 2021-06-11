Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752D03A403E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFKKg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFKKgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:36:21 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE27C061574;
        Fri, 11 Jun 2021 03:34:07 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u24so36518597edy.11;
        Fri, 11 Jun 2021 03:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NqdU3sOPvnR+y/ypTNiGIzWaUB5NcaIKafz3tiUSmpM=;
        b=sdjgMGJFIKdoradeiL2ZfLPCgHjC6zByFn+nnk86c22p5+Q0fAa8qPkuZ7xdFWwEAH
         Zg1dZSA2WqmPMxrr7aJp1FO8PfguyGU6XmB+P/XJdkwNiCc41PDRR1mEBITssA265dqr
         RTeb/ABgnulZjqxT0Hj85V3mql23NlsQ2E9PdZ4xu69vzWdWA5CqYKTlrPQcA5V8Vh5j
         zlV7LDQCY94r5dD550t9GGkn4Zvn8mNQqVIKqpXCe0b0q9HisCw5z5gg6Qk1/DQolcGq
         XhzgFzxaBEYyLBZkpme+QgkMzTWbOPlLtDIRc7ItgA8rIGWbQQznUeVV8XevTBpsBsdC
         962w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NqdU3sOPvnR+y/ypTNiGIzWaUB5NcaIKafz3tiUSmpM=;
        b=XjLHfvPMNL4qZPWvWBn7hTf20k2E/Ih8ummoj6k81oLI0038rFevqLJvplPXoJlp0j
         R9rftqPAuCfWdnxhFgZ8o2sQZm88gW3SJRyLAv3/MMg57nP0mMRQxe8n5wZH7lvC5XWA
         3aJHUxsXHxf/QmKn3jBkM3Fde6wVLgmShr1fJKnpQIRu8pgLtXk9ltoaAsLr6Wc+ypvN
         PHiHEhW9Uz0FIxU3BZj+KeWTBCbuFC3FXH9WFKom9J74pIEtpOandsQn8ejhnAJN9MJD
         P8umILZh/3g885vkhNYbdPxOEQBALJf7pOFRSMsozR4ObfHVmLdkJ78sT16KJna6LRE+
         SKqg==
X-Gm-Message-State: AOAM533Jw9RmuDFuSwwSRoR6z+4Tkq0y42/ZEXmF2FhRj9UsIC/e+etS
        wq/5BoIefSXUF7Qs5tblHGU=
X-Google-Smtp-Source: ABdhPJxaCKfyBszmk3v9dxTZpj0N5BnWB8a922PpkjmnznnabLW2hMTyHEPdcQqa//6jSix6xc5YsA==
X-Received: by 2002:a05:6402:b11:: with SMTP id bm17mr2928498edb.109.1623407646447;
        Fri, 11 Jun 2021 03:34:06 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di16sm2409153edb.62.2021.06.11.03.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:34:05 -0700 (PDT)
Date:   Fri, 11 Jun 2021 13:34:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: b53: Create default VLAN entry
 explicitly
Message-ID: <20210611103404.jqyw4q5ux7ao27tc@skbuf>
References: <20210611035733.400713-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611035733.400713-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 08:57:32PM -0700, Florian Fainelli wrote:
> In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
> b53 driver to ensure that the default PVID VLAN entry will be configured
> with the appropriate untagged attribute towards the CPU port. We were
> implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
> instead make it explicit.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_common.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 6e199454e41d..5fd9ed327c1b 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -748,9 +748,20 @@ int b53_configure_vlan(struct dsa_switch *ds)
>  
>  	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
>  
> -	b53_for_each_port(dev, i)
> +	/* Create an untagged VLAN entry for the default PVID in case
> +	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
> +	 * dsa_slave_vlan_rx_add_vid() to create the default VLAN
> +	 * entry. Do this only when the tagging protocol is not
> +	 * DSA_TAG_PROTO_NONE
> +	 */
> +	b53_for_each_port(dev, i) {
> +		v = &dev->vlans[def_vid];
> +		v->members |= BIT(i);
> +		if (dev->tag_protocol != DSA_TAG_PROTO_NONE)
> +			v->untag = v->members;
>  		b53_write16(dev, B53_VLAN_PAGE,
>  			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
> +	}
>  
>  	/* Upon initial call we have not set-up any VLANs, but upon
>  	 * system resume, we need to restore all VLAN entries.
> -- 
> 2.25.1
> 

So VLAN 0 is by default egress-tagged?
This means that for tag_proto == DSA_TAG_PROTO_NONE, you are
reintroducing the problem fixed by commit d965a5432d4c ("net: dsa: b53:
Ensure the default VID is untagged"), aka untagged packets sent from the
DSA master will land as VID-0-tagged on the wire?

I would expect something like this would yield consistent results
between the b53_configure_vlan and the b53_vlan_add code path, is that
true?

-----------------------------[ cut here ]-----------------------------
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6e199454e41d..03456e019406 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -728,6 +728,13 @@ static u16 b53_default_pvid(struct b53_device *dev)
 		return 0;
 }
 
+static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+
+	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
+}
+
 int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -748,6 +755,21 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
 
+	/* Create an untagged VLAN entry for the default PVID in case
+	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
+	 * dsa_slave_vlan_rx_add_vid() to create the default VLAN
+	 * entry. Do this only when the tagging protocol is not
+	 * DSA_TAG_PROTO_NONE
+	 */
+	v = &dev->vlans[def_vid];
+
+	b53_for_each_port(dev, i) {
+		v->members |= BIT(i);
+
+		if (!b53_vlan_port_needs_forced_tagged(ds, port))
+			v->untag |= BIT(i);
+	}
+
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
@@ -1460,13 +1482,6 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
-{
-	struct b53_device *dev = ds->priv;
-
-	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
-}
-
 int b53_vlan_add(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan,
 		 struct netlink_ext_ack *extack)
-----------------------------[ cut here ]-----------------------------
