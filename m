Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFBD3D74A4
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhG0L5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhG0L5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 07:57:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E3FC061757;
        Tue, 27 Jul 2021 04:57:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id f13so12239453edq.13;
        Tue, 27 Jul 2021 04:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p0DWAB4t1tJcsckdcxMqGk/mRhll9m/JiTYWeKlyRr8=;
        b=BvEa2g68qsxugdRrqJai9aNZuzBhLagnC30fsrRDdgGjOivz+9fb7mZLcrS+K7IKKO
         iMdzNK8gMINqaUh7fbeTRpI9m0BAt+yhdCZUCdizdw+ltnla9fRD6JPP9azfYkr7qKTU
         4E9IasSo+rsetg3Zsy5XdqD0qB6v2pqQWsjH1mMSLYBK+tFRgnrYB/mCIVUpH2bLmN+2
         jf5rjU463FrLnvq3tabtBV2laN4VHI1NmIjsCRj3avZrYydBKwVxjaBLSouagDeZJRpz
         aB2YXeNRqbHKY7wp6G9wf99rkXPnfordLNqU2UUxYIXfMcoRVa5XOVwO/8c1Vmcn1r2S
         Uk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p0DWAB4t1tJcsckdcxMqGk/mRhll9m/JiTYWeKlyRr8=;
        b=O38oSaLxKngOdCcO4yaZi//VLQxL8TvS6Fdts2dUs2aw+xmYiQDOPXRLWT8xfdz+h7
         vJ4i4K1+yPkMaqr29p03NF0hcHZWWr6BJmrna/ddCLUmgKPf23EBYiQZtI5dnJs9mzjI
         z6ajKVnneJGk+d3fazIXjPDKpZ9GrqfgrM+Bb1WuJHm/MnPPYdSnsWvCjN71RPKxoEDl
         sBa5uoitj+9CEcM36oSTMx+aQKA3VxE7EmjxYhX/+XNnPiVjjkKWJ6fjlOpfFkwtmHi5
         TFGstuIQbnkcJPI+uULeBi3g2nrCeZDvkJTJKwmmyxRCQIWR1axIeXPGfD8uJsh4akTi
         AjYw==
X-Gm-Message-State: AOAM530fNFsIpO9lU9o2FCV/LvDvZqzw3iNWLiE97pMQDJ7ctdPjBynm
        /8Y+WPR/ffh9AxXNknfzM4c=
X-Google-Smtp-Source: ABdhPJxIAep0weNy40bdDhpt0sK+i4v8WkIc0iMb16IapnHccMfUtay1lqUZnBn2pDv9Rjzq/do8Lg==
X-Received: by 2002:aa7:d342:: with SMTP id m2mr3571197edr.40.1627387053603;
        Tue, 27 Jul 2021 04:57:33 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id h8sm841189ejj.22.2021.07.27.04.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 04:57:33 -0700 (PDT)
Date:   Tue, 27 Jul 2021 14:57:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?UGF3ZcWC?= Dembicki <paweldembicki@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Wallej <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
Message-ID: <20210727115731.s7kkwh3k7ficgune@skbuf>
References: <20210120063019.1989081-1-paweldembicki@gmail.com>
 <20210121224505.nwfipzncw2h5d3rw@skbuf>
 <CAJN1KkyCopZLzHc76GC9fi4nPf_y52syKZHQ1J4zbx7Z9sauyQ@mail.gmail.com>
 <20210128003755.am4onc5d2xtmu2la@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128003755.am4onc5d2xtmu2la@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pawel,

On Thu, Jan 28, 2021 at 02:37:55AM +0200, Vladimir Oltean wrote:
> With even more enhancements to the bridge and DSA data path, the source
> port information might not even matter for the network stack when the
> port is bridged, since the packet will end up in the data path of the
> bridge anyway, regardless of which bridged port the packet came in
> through (a notable exception to this is link-local traffic like bridge
> PDUs - some switches treat link-local packets differently than normal
> data ones). On transmission, the imprecise steering to the correct
> egress port poses further complications, because of the flooding
> implementation in the Linux bridge: a packet that is to be flooded
> towards swp0, swp1 and swp2 will be cloned by the bridge once per egress
> port, and each skb will be individually delivered to each net_device
> driver for xmit. The bridge does not know that the packet transmission
> through a DSA driver with no tagging protocol is imprecise, and instead
> of delivering the packet just towards the requested egress port, that
> the switch will likely flood the packet.  So each packet will end up
> flooded once by the software bridge, and twice by the hardware bridge.
> This can be modeled as a TX-side offload for packet flooding, and could
> be used to prevent the bridge from cloning the packets in the first
> place, and just deliver them once to a randomly chosen port which is
> bridged.

Did you make any progress with getting rid of DSA_TAG_PROTO_NONE for
vsc73xx?

Just FYI, the bridge and DSA enhancement that I was talking about above
got accepted and you should be able to make use of it.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=356ae88f8322066a2cd1aee831b7fb768ff2905c
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=beeee08ca1d432891f9e1f6188eea85ffac68527

Assuming you haven't solved your issue with link-local packets, you
should at least be able to configure the switch as follows:
- in standalone mode and under a VLAN-unaware bridge: enable Shared VLAN
  Learning, set VLAN_TCI_IGNORE_ENA to always classify packets to the
  port-based VLAN and not look at the VLAN headers, reserve the
  1024-3071 VID range for tag_8021q, and call dsa_tag_8021q_register().
- under a VLAN-aware bridge: same as the above except enable Independent
  VLAN Learning and disable VLAN_TCI_IGNORE_ENA. Packets from ports
  under a VLAN-aware bridge will come tagged with the bridge VLAN, so
  you can draw inspiration from net/dsa/tag_sja1105.c to see how to
  perform reception for those (dsa_find_designated_bridge_port_by_vid).
This should give you the ability to expose the switch as an STP-incapable
bridge accelerator with port isolation and VLAN support, which frankly
seems about all that the hardware can offer.
