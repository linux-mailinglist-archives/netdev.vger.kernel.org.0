Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A1839CBF5
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 02:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFFA4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 20:56:41 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:37675 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFFA4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 20:56:41 -0400
Received: by mail-ed1-f53.google.com with SMTP id b11so15719285edy.4;
        Sat, 05 Jun 2021 17:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5k/iS3Z5RT6D+xK4ZwQ9/9Ly3jmBdwhBfNLrRJfoaKQ=;
        b=CXkXjD1GeZAay7O/29IZo/OJIv7emonfM2TvpipbnXf4YfcKxIPmU2vQhaUUcfah3S
         aoDXyTOzTU7g2Jz+oN9xfBkHSHHnK+kLMXilgJeoEceZ+Kib306aKDAEhuy+tmzXVKmh
         k1Z8WCrDJbWK4YLxoWk7LQf6RWdGlmnjskQ2hPMqb07rB0/M47kmz7eM1hc+tW3xIBfB
         XM/NxfKCsGFXikH1hE8h5UJW68HIYGx96XeQfuKrt9SVkF4H705UIl0yVoAnoP5jk+ey
         gZ+uWd8z/iWTz15bnnzFEiUMy+ept3veXt9NVijPaqxb8iyDJBrvbYXZMDcQDU8trg4v
         7/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5k/iS3Z5RT6D+xK4ZwQ9/9Ly3jmBdwhBfNLrRJfoaKQ=;
        b=neTRNHPikGZst/8nX3PfnAlqrvJnr/MoffXWtUyIGtsj96UcfJNrrdlIr1zMghayYP
         PCe9eoVC0kOzMF2q8m5cmTLmznUQiTP3H0vLmZg/u029wNUjufkUY0ITIRE2babPeqIi
         hTcFkA/P3FuL7Sry7tSxwHIXwjXrtjJLj5JfU8xhxa/Uwj0yTPuFflJtez25Nf3EgFq3
         8Z2MZsAmmyO8sTmA+cISzM+OAdsIrYEnpmt/tmMdrZBAeHw6rhfTcGIYnjrMgi7BlADD
         zV0+KJqKq8ZRQFepLxVxhFWxYJbuOgnbes3gYoOxV2epNTG59gL7LLblrWoEgSaG6r9c
         H05w==
X-Gm-Message-State: AOAM532h3KjzMZ/Bov65FwZBYRDHALiOfSRiKg9Kj+TlrYm1wkpBwYPb
        fAvKskHJ1zHEuQoow+wTsaE=
X-Google-Smtp-Source: ABdhPJwWwPaMVkAk4H9NtVZPFoTRMWMXB6KCo1G+BQT3qFv6QwV/tXO//GPnIy1PR5omg4d47Jw8sw==
X-Received: by 2002:a05:6402:510f:: with SMTP id m15mr12782128edd.283.1622940817497;
        Sat, 05 Jun 2021 17:53:37 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gw7sm4692666ejb.5.2021.06.05.17.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 17:53:37 -0700 (PDT)
Date:   Sun, 6 Jun 2021 03:53:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
Message-ID: <20210606005335.iuqi4yelxr5irmqg@skbuf>
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch>
 <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

On Sat, Jun 05, 2021 at 11:39:24PM +0100, Matthew Hagan wrote:
> On 05/06/2021 21:35, Andrew Lunn wrote:
> 
> >> The tested case is a Meraki MX65 which features two QCA8337 switches with
> >> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
> > Hi Matthew
> >
> > The BCM58625 switch is also running DSA? What does you device tree
> > look like? I know Florian has used two broadcom switches in cascade
> > and did not have problems.
> >
> >     Andrew
> 
> Hi Andrew
> 
> I did discuss this with Florian, who recommended I submit the changes. Can
> confirm the b53 DSA driver is being used. The issue here is that tagging
> must occur on all ports. We can't selectively disable for ports 4 and 5
> where the QCA switches are attached, thus this patch is required to get
> things working.
> 
> Setup is like this:
>                        sw0p2     sw0p4            sw1p2     sw1p4 
>     wan1    wan2  sw0p1  +  sw0p3  +  sw0p5  sw1p1  +  sw1p3  +  sw1p5
>      +       +      +    |    +    |    +      +    |    +    |    +
>      |       |      |    |    |    |    |      |    |    |    |    |
>      |       |    +--+----+----+----+----+-+ +--+----+----+----+----+-+
>      |       |    |         QCA8337        | |        QCA8337         |
>      |       |    +------------+-----------+ +-----------+------------+
>      |       |             sw0 |                     sw1 |
> +----+-------+-----------------+-------------------------+------------+
> |    0       1    BCM58625     4                         5            |
> +----+-------+-----------------+-------------------------+------------+

It is a bit unconventional for the upstream Broadcom switch, which is a
DSA master of its own, to insert a VLAN ID of zero out of the blue,
especially if it operates in standalone mode. Supposedly sw0 and sw1 are
not under a bridge net device, are they?

If I'm not mistaken, this patch should solve your problem?

-----------------------------[ cut here ]-----------------------------
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..d6655b516bd8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1462,6 +1462,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	bool really_untagged = false;
 	struct b53_vlan *vl;
 	int err;
 
@@ -1474,10 +1475,10 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	b53_get_vlan_entry(dev, vlan->vid, vl);
 
 	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
-		untagged = true;
+		really_untagged = true;
 
 	vl->members |= BIT(port);
-	if (untagged && !dsa_is_cpu_port(ds, port))
+	if (really_untagged || (untagged && !dsa_is_cpu_port(ds, port)))
 		vl->untag |= BIT(port);
 	else
 		vl->untag &= ~BIT(port);
-----------------------------[ cut here ]-----------------------------
