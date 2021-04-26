Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4D36B921
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbhDZSkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbhDZSkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:40:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE23AC06175F;
        Mon, 26 Apr 2021 11:39:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g14so7258639edy.6;
        Mon, 26 Apr 2021 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QSLTTzQCC0wKi0r8S5pXPw/n2MOLQ2k6Ya29tOHfasw=;
        b=L5qvJeF/iHzDDfrka+aNey3iWqselqqJTZ9ePE+2nUVz5FJtVvY1utJmJ+kGwxcIpN
         nz9NZsnKV/NfxmDN1K2QGamiqNeDxtlfErrZMDFNk/WfiNKINc42PFS0LBUVu/Cr90fg
         EyH3PknDwckxijWAKvyEe4BbfNZobgAwkZPOSHLHKT+HV2YkEqCdOhAhIEN6M7mjFZu4
         geZBDtiPGw5IK1TpcS+RWDTuOmWrGBNoRgoxtW4StbXD+2SPXX2Yng/ZG4A16093jHyj
         sSBU0Yrk52i1nNCOUMaTFu4aUTOYs+fdCsj3CNPXTfbXA/HD8i05lgv4WoT3mOeTbjTy
         q6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QSLTTzQCC0wKi0r8S5pXPw/n2MOLQ2k6Ya29tOHfasw=;
        b=oWfDYnNvmX5XRcEao7HqPPD4CVGjYvZ0Tzk1alKmMxHUT4joZRbnS/uSvT6Z/pom4Q
         /QtCXF6kG0XF1RaYEk3ujj0R7x2fHJcpKeorm9IL7Xye8tt70XMR/6yqOtH75HTFd8AC
         mD6T4f0c/H+SRGgqYVdNAil7ucX1Y67e2D9jGuCFEtmgyUAt+HxgDJ+Hvk2HHbDLubvV
         6SW8gugAur7RjYACSfzditsLS0b7dBpZEVwYe1jbiClL0t50Z2PS7NHq2vDR5IsxiCHp
         v1yxiH2PQDPK9pCvWhJtMZFgyDMufgDAEELYFw2XWt0vLu/tmrx4L1WtHXWdf3UJGTY5
         /TdQ==
X-Gm-Message-State: AOAM532xutgkXnpvwPce5yRanjqbdEUV4l94r53MP/lUKx8A+MVhrpr2
        AQshv5Rjem1yRxYRgacpIyw=
X-Google-Smtp-Source: ABdhPJxXqqpz8mbWpXlVj9lOnOwGPuFhnSQkIKurLB0hpt8jIe/9DxwXBoMD66Z1diIswBA6AFBw9Q==
X-Received: by 2002:aa7:c349:: with SMTP id j9mr83754edr.230.1619462386502;
        Mon, 26 Apr 2021 11:39:46 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r25sm458593edv.78.2021.04.26.11.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 11:39:46 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:39:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Message-ID: <20210426183944.4djc5dep62xz4gh6@skbuf>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
 <20210426133846.GA22518@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426133846.GA22518@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 06:38:46AM -0700, Richard Cochran wrote:
> On Mon, Apr 26, 2021 at 05:37:58PM +0800, Yangbo Lu wrote:
> > @@ -624,7 +623,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  	dev_sw_netstats_tx_add(dev, 1, skb->len);
> >  
> > -	DSA_SKB_CB(skb)->clone = NULL;
> > +	memset(skb->cb, 0, 48);
> 
> Replace hard coded 48 with sizeof() please.

You mean just a trivial change like this, right?

	memset(skb->cb, 0, sizeof(skb->cb));

And not what I had suggested in v1, which would have looked something
like this:

-----------------------------[cut here]-----------------------------
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e1a2610a0e06..c75b249e846f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -92,6 +92,7 @@ struct dsa_device_ops {
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
+	unsigned int skb_cb_size;
 	const char *name;
 	enum dsa_tag_protocol proto;
 	/* Some tagging protocols either mangle or shift the destination MAC
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2033d8bac23d..2230596b48b7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -610,11 +610,14 @@ static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
+	const struct dsa_device_ops *tag_ops;
 	struct sk_buff *nskb;
 
 	dev_sw_netstats_tx_add(dev, 1, skb->len);
 
-	memset(skb->cb, 0, 48);
+	tag_ops = p->dp->cpu_dp->tag_ops;
+	if (tag_ops->skb_cb_size)
+		memset(skb->cb, 0, tag_ops->skb_cb_size);
 
 	/* Handle tx timestamp if any */
 	dsa_skb_tx_timestamp(p, skb);
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 50496013cdb7..1b337fa104dc 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -365,6 +365,7 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.overhead = VLAN_HLEN,
 	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
+	.skb_cb_size = sizeof(struct sja1105_skb_cb),
 };
 
 MODULE_LICENSE("GPL v2");
-----------------------------[cut here]-----------------------------

I wanted to see how badly impacted would the performance be, so I
created an IPv4 forwarding setup on the NXP LS1021A-TSN board (gianfar +
sja1105):

#!/bin/bash

ETH0=swp3
ETH1=swp2

systemctl stop ptp4l # runs a BPF classifier on every packet
systemctl stop phc2sys

echo 1 > /proc/sys/net/ipv4/ip_forward
ip addr flush $ETH0 && ip addr add 192.168.100.1/24 dev $ETH0 && ip link set $ETH0 up
ip addr flush $ETH1 && ip addr add 192.168.200.1/24 dev $ETH1 && ip link set $ETH1 up

arp -s 192.168.100.2 00:04:9f:06:00:09 dev $ETH0
arp -s 192.168.200.2 00:04:9f:06:00:0a dev $ETH1

ethtool --config-nfc eth2 flow-type ether dst 00:1f:7b:63:01:d4 m ff:ff:ff:ff:ff:ff action 0

and I got the following results on 1 CPU, 64B UDP packets (yes, I know
the baseline results suck, I haven't investigated why that is, but
nonetheless, it should still be relevant as far as comparative results
go):

Unpatched net-next:
proto 17:      65695 pkt/s
proto 17:      65725 pkt/s
proto 17:      65732 pkt/s
proto 17:      65720 pkt/s
proto 17:      65695 pkt/s
proto 17:      65725 pkt/s
proto 17:      65732 pkt/s
proto 17:      65720 pkt/s


After patch 1:
proto 17:      72679 pkt/s
proto 17:      72677 pkt/s
proto 17:      72669 pkt/s
proto 17:      72707 pkt/s
proto 17:      72696 pkt/s
proto 17:      72699 pkt/s

After patch 2:
proto 17:      72292 pkt/s
proto 17:      72425 pkt/s
proto 17:      72485 pkt/s
proto 17:      72478 pkt/s

After patch 4 (as 3 doesn't build):
proto 17:      72437 pkt/s
proto 17:      72510 pkt/s
proto 17:      72479 pkt/s
proto 17:      72499 pkt/s
proto 17:      72497 pkt/s
proto 17:      72427 pkt/s

With the change I pasted above:
proto 17:      71891 pkt/s
proto 17:      71810 pkt/s
proto 17:      71850 pkt/s
proto 17:      71826 pkt/s
proto 17:      71798 pkt/s
proto 17:      71786 pkt/s
proto 17:      71814 pkt/s
proto 17:      71814 pkt/s
proto 17:      72010 pkt/s

So basically, not only are we better off just zero-initializing the
complete skb->cb instead of looking up the tagger's skb_cb_size, but
zero-initializing the skb->cb isn't even all that bad. Yangbo's change
is an overall win anyway, all things considered. So just change the
memset as Richard suggested, make sure all patches compile, and we
should be good to go.
