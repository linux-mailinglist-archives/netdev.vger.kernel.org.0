Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0E73E7D8E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhHJQgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhHJQf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 12:35:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E71BC0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:35:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d6so31078686edt.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ad8kzRHEvMyXrK+cBglwvgIkG+uk5OMXJrBwXcYdeNo=;
        b=GupTUGVpxdaiukjMuV6rO9Czv1EmNrlBujhdze5L2IaurfTd5BgtrC2PUqZ6Ybte0I
         wyXjXhraPSsae3MjX6yLjQG2+yDApMGGYRYHKStQMUQUSyZmWsA7tJhW8ukz4Fo/SIfK
         lLSDwVrzUp6LHNL3NZH57IIMzkJuzdyqwTITX9+Drx25vK9s5OOXHl02yys+xWPzAdFj
         5/uYHJx7Bx5RnEtn74bgImfiBC7MkduDbGPur5wb3b1TB2SP4oUxoU2t+9PAQM5Meabp
         v1u2/sjZ3U2rsKvMBkzGvKZ+BOhJ8tJszLlATEersrbUTQbqFWdmuvjojTxC7S7HGqoE
         E7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ad8kzRHEvMyXrK+cBglwvgIkG+uk5OMXJrBwXcYdeNo=;
        b=bMdW8J75BOpbq8LApoF7jfq/pr+7nn+fAErIu8jfjAeGwkqUo9u7p59xeHyBdhjsD0
         e3IHVfwriyc/HiLfJyDOxDUwkv59EiFNgDBJmgt2/9kpoxvYvtxTA9KMIce8qSl7jfTf
         71Eaq9rIq0jG+5JsA+GgTmwb3PuFwTNGmkPHS+AQhEBf0uG1cjqoNhF5rz/PGNLDXyW9
         o6hQocModtjO0JCqfw4kJ5WJSvLQvuu5/hGKP7NTv/csdvANSqyl2Ak8NjpArREmpoU/
         69/SXVGRIj7thHytlKYow20mXmcKK3QvCrOG2M9LJ2YHXTYU6N8+q3B3K1X5GOwzB/+s
         nyyQ==
X-Gm-Message-State: AOAM531AVwpCN03xT3vkMDIMpwyFIqyMITDHwRLvhueMwkQWZ9GMdIO8
        lzPsVPD9+vGtQCVaOrpWrHk=
X-Google-Smtp-Source: ABdhPJyEE3dDyCtjwdxrdivvkAqckqMNjwDUV12ivKIZuqFPRTvEshVNuySI+9ATg36iudtyMndfwg==
X-Received: by 2002:a50:9b03:: with SMTP id o3mr3964385edi.203.1628613335612;
        Tue, 10 Aug 2021 09:35:35 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id u4sm7034332eje.81.2021.08.10.09.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:35:35 -0700 (PDT)
Date:   Tue, 10 Aug 2021 19:35:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a
 loop" antipattern from the core
Message-ID: <20210810163533.bn7zq2dzcilfm6o5@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-3-vladimir.oltean@nxp.com>
 <20210810033339.1232663-1-dqfext@gmail.com>
 <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com>
 <20210810113532.tvu5dk5g7lbnrdjn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810113532.tvu5dk5g7lbnrdjn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:35:32PM +0300, Vladimir Oltean wrote:
> On Tue, Aug 10, 2021 at 02:41:07AM -0700, Florian Fainelli wrote:
> > On 8/9/2021 8:33 PM, DENG Qingfang wrote:
> > > On Mon, Aug 09, 2021 at 10:03:18PM +0300, Vladimir Oltean wrote:
> > > > Ever since Vivien's conversion of the ds->ports array into a dst->ports
> > > > list, and the introduction of dsa_to_port, iterations through the ports
> > > > of a switch became quadratic whenever dsa_to_port was needed.
> > > 
> > > So, what is the benefit of a linked list here? Do we allow users to
> > > insert/delete a dsa_port at runtime? If not, how about using a
> > > dynamically allocated array instead?
> > 
> > The goal was to flatten the space while doing cross switch operations, which
> > would have otherwise required iterating over dsa_switch instances within a
> > dsa_switch_tree, and then over dsa_port within each dsa_switch.
> 
> To expand on that: technically dsa_port_touch() _does_ happen at
> runtime, since multiple switches in a cross-chip tree probe
> asynchronously. To use a dynamically allocated array would mean to
> preallocate the sum of all DSA switch ports' worth of memory, and to
> preallocate an index for each DSA switch within that single array.
> Overall a list is simpler.

If I were to guess where Qingfang was hinting at, is that the receive
path now needs to iterate over a list, whereas before it simply indexed
an array:

static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
						       int device, int port)
{
	struct dsa_port *cpu_dp = dev->dsa_ptr;
	struct dsa_switch_tree *dst = cpu_dp->dst;
	struct dsa_port *dp;

	list_for_each_entry(dp, &dst->ports, list)
		if (dp->ds->index == device && dp->index == port &&
		    dp->type == DSA_PORT_TYPE_USER)
			return dp->slave;

	return NULL;
}

I will try in the following days to make a prototype implementation of
converting back the linked list into an array and see if there is any
justifiable performance improvement.

[ even if this would make the "multiple CPU ports in LAG" implementation
  harder ]
