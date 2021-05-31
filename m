Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340EC396405
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 17:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhEaPn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhEaPlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 11:41:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6059C08E9AC;
        Mon, 31 May 2021 07:29:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b9so16901120ejc.13;
        Mon, 31 May 2021 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qNjqZ5zd2V40yN4Zg4sWv5pTo9qBY5VHb+FiIliKXlQ=;
        b=RfzreTFwv7GzzZL2BeFwL70PpxPupd5vxJ6j6yTfPHtV636uy1Qb8ycfBgYRRiMz6V
         1QDhtIQokdhY6SS5DkDxRQXWQHuqVzAlB7+v9QmyrOsriJRWIYbhVEAf7OASAnUAz3Tg
         R/Nw4ap6hT8Ekl/1dEp0GYgjjXyyrqzQyEOWelDf3GIUuUXqsOqxBpZsBhNSTG6CYYKy
         smk2hiOGcMO2fB8B2tYXlMYTFYNfgFQIK1/l+gYcg2IbfAi9/d6PwcMLS/Y4lSTTKyo3
         1l1Xhpq4FuiSM6W/KJ54uDjICcviWnlKUKbIFZG3E04hWYGCD7Vg/5BFls4Fu6hOG7/f
         MBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qNjqZ5zd2V40yN4Zg4sWv5pTo9qBY5VHb+FiIliKXlQ=;
        b=Tubry8l/VMrBZlmKeG2r+00WM0HGQZOHE5i82UDRjAhor1BPIsyjBZcG/tqVC2EiZr
         LTRlzDlF9pssX00i+kNOnGt9UaqdxUh2d4XOZSN+cFfI9eBf03ryQQXEsVUrAprZJ0Qh
         hakMBuVUDIYsLaX/XHjZAlyCNgskGRVHz3ksjbwDzv8BRgKSVrFze4XqKcxcpt8Hod7V
         pV4GoGzH4IqKU9QGvLcyaI1onoiNMDbkNlXOuQn5J7+H0DRfLldicYaYAvKVKe3fHSth
         5I/wVUoPyax31kcuQxIsg6W8iycQ9HyTZA7kxZ4VQ9Pp5tXt9b/qi+dmdfoYNoK9CqvR
         rl2g==
X-Gm-Message-State: AOAM531EuZhMr5ByMZX1QTC28PB1xCid3UaVsvaTHa80jFFtxrBd2GQU
        IdEyW96WLhlGhgwUFqx1kDE=
X-Google-Smtp-Source: ABdhPJyxfWuqNyBrWukySA+Pv7Eu8C+/LWEiJmrzZkXj1dqR35uMeIMS8NCjnFFsE2PAd7ML1rCA9A==
X-Received: by 2002:a17:906:3f86:: with SMTP id b6mr23407366ejj.530.1622471356280;
        Mon, 31 May 2021 07:29:16 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id kj1sm2804057ejc.10.2021.05.31.07.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:29:15 -0700 (PDT)
Date:   Mon, 31 May 2021 17:29:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ben Hutchings <ben.hutchings@essensium.com>
Cc:     netdev@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-omap@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Ethernet padding - ti_cpsw vs DSA tail tag
Message-ID: <20210531142914.bfvcbhglqz55us6s@skbuf>
References: <20210531124051.GA15218@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531124051.GA15218@cephalopod>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ben,

On Mon, May 31, 2021 at 02:40:52PM +0200, Ben Hutchings wrote:
> I'm working on a system that uses a TI Sitara SoC with one of its
> Ethernet ports connected to the host port of a Microchip KSZ8795
> switch.  I'm updating the kernel from 4.14.y to 5.10.y.  Currently I
> am using the ti_cpsw driver, but it looks like the ti_cpsw_new driver
> has the same issue.
> 
> The Microchip switch expects a tail tag on ingress from the host port
> to control which external port(s) to forward to.  This must appear
> immediately before the frame checksum.  The DSA core correctly pads
> outgoing skbs to at least 60 bytes before tag_ksz appends the tag.
> 
> However, since commit 9421c9015047 ("net: ethernet: ti: cpsw: fix min
> eth packet size"), the cpsw driver pads outgoing skbs to at least 64
> bytes.  This means that in smaller packets the tag byte is no longer
> at the tail.
> 
> It's not obvious to me where this should be fixed.  Should drivers
> that pad in ndo_start_xmit be aware of any tail tag that needs to be
> moved?  Should DSA be aware that a lower driver has a minimum size >
> 60 bytes?

These are good questions.

In principle, DSA needs a hint from the master driver for tail taggers
to work properly. We should pad to ETH_ZLEN + <the hint value> before
inserting the tail tag. This is for correctness, to ensure we do not
operate in marginal conditions which are not guaranteed to work.

A naive approach would be to take the hint from master->min_mtu.
However, the first issue that appears is that the dev->min_mtu value is
not always set quite correctly.

The MTU in general measures the number of bytes in the L2 payload (i.e.
not counting the Ethernet + VLAN header, nor FCS). The DSA tag is
considered to be a part of the L2 payload from the perspective of a
DSA-unaware master.

But ether_setup() sets up dev->min_mtu by default to ETH_MIN_MTU (68),
which cites RFC791. This says:

    Every internet module must be able to forward a datagram of 68
    octets without further fragmentation.  This is because an internet
    header may be up to 60 octets, and the minimum fragment is 8 octets.

But many drivers simply don't set dev->min_mtu = 0, even if they support
sending minimum-sized Ethernet frames. Many set dev->min_mtu to ETH_ZLEN,
proving nothing except the fact that they don't understand that the
Ethernet header should not be counted by the MTU anyway.

So to work with these drivers which leave dev->min_mtu = ETH_MIN_MTU, we
would have to pad the packets in DSA to ETH_ZLEN + ETH_MIN_MTU. This is
not quite ideal, so even if it would be the correct approach, a large
amount of drivers would have to be converted to set dev->min_mtu = 0
before we could consider switching to that and not have too many
regressions.

Also, dev->min_mtu does not appear to have a very strict definition
anywhere other than "Interface Minimum MTU value". My hopes were some
guarantees along the lines of "if you try to send a packet with a
smaller L2 payload than dev->mtu, the controller might pad the packet".
But no luck with that, it seems.

Going to commit 9421c9015047, it looks like that took a shortcut for
performance reasons, and omitted to check whether the skb is actually
VLAN-tagged or not, and if egress untagging was requested or not.
My understanding is that packets smaller than CPSW_MIN_PACKET_SIZE _can_
be sent, it's only that the value was chosen (too) conservatively as
VLAN_ETH_ZLEN. The cpsw driver might be able to check whether the packet
is a VLAN tagged one by looking at skb->protocol, and choose the pad
size dynamically. Although I can understand why Grygorii might not want
to do that.

The pitfall is that even if we declare the proper min_mtu value for
every master driver, it would still not avoid padding in the cpsw case.
This is because the reason cpsw pads is due to VLAN, but VLAN is not
part of the L2 payload, so cpsw would still declare dev->min_mtu = 0 in
spite of needing to pad.

The only honest solution might be to extend struct net_device and add a
pad_size value somewhere in there. You might be able to find a hole with
pahole or something, and it doesn't need to be larger than an u8 (for up
to 255 bytes of padding). Then cpsw can set master->pad_size, and DSA
can look at it for tail taggers.
