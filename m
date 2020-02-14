Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025D315F535
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394972AbgBNSZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:25:28 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42736 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388295AbgBNSZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:25:21 -0500
Received: by mail-qk1-f193.google.com with SMTP id o28so8765282qkj.9;
        Fri, 14 Feb 2020 10:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=BKp7G1122CfiCTZzfKgQoDAhSZdALPY4roih/emwM7c=;
        b=prrtIsUiDVqvdF4xDl1ND2r5obgn9RUw515rlFE0kjWd+YyVr2091ZkRsPbQBZvzlN
         7t07v33i4auW8vuyG9QPQM9/IgqvoLNmuaAflylZq1LtSOMiBMnFf9RR1yNLyRydhnvp
         btk0GjPd0JuNvxceyTOMaUrY5poDxU9wqpHEVYlGqcob38dO6uJL9G9UhmqXedNOr1f5
         QN8AOtj2znUhjQSNkDu1kmrxQC+PV8J6Ouuxh/kSaccHcFntp5qJFV9pLUPlGkvK/Hmy
         g6auiM0OMpQ24TGtINvm+v0PvHqU7jtVxdE3NmzHPAe5SCHiHqA72sMrl/tOHwOTurXq
         nHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=BKp7G1122CfiCTZzfKgQoDAhSZdALPY4roih/emwM7c=;
        b=SyacTwWZ+ZATpEC0Np5Fsd3h1v6gWa3/c+ZbfpqU/huVFizL0g8aGCoeUP7VlPtUVa
         a6GmGGpR4yH9P/NGBPsxBkZL/NOq6ye9BEu2zu08MellLf0WIhy7jVcnQ9ilERBR32rX
         /1Cs+ndI1vQ1HOoCj/EOZ0kis9ierd8NqepGyxhEfkLwbEfAdGtH+rmSCQeRP2kRac8w
         XTqoNyHnnznLCuZsRIMfg9rzjJc3nc/+klCWhlyyoW5r58e/ADiF2QmmzIpovoDAKtkW
         7o12xNpjGPVdmhTEx6QPP2q0Zq8GyzLSoe9H2vs50jHTftgjLqfOxkubyMmNQXhZ2RH4
         Tb8g==
X-Gm-Message-State: APjAAAX9VYmMrFfNjW03cxWafR/NGkszm39/uJt+UaANfr4rvWFlRFSh
        t0MrVtL6/Gd9KVonxQc35d3+XpoV2A0=
X-Google-Smtp-Source: APXvYqwBkx0OeDyCpL06Vsr+OP80p1tO6EzNW08bbylQO2m38OsDi47j9ZiVaG3KtK89UbiDjk1FTg==
X-Received: by 2002:a37:4a95:: with SMTP id x143mr3500590qka.23.1581704720045;
        Fri, 14 Feb 2020 10:25:20 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f59sm3723372qtb.75.2020.02.14.10.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 10:25:19 -0800 (PST)
Date:   Fri, 14 Feb 2020 13:25:18 -0500
Message-ID: <20200214132518.GC1625342@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, hkallweit1@gmail.com,
        michal.vokac@ysoft.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: Treat VLAN ID 0 as PVID untagged
In-Reply-To: <20200212200555.2393-1-f.fainelli@gmail.com>
References: <20200212200555.2393-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, 12 Feb 2020 12:05:55 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> VLAN ID 0 is special by all kinds and is really meant to be the default
> ingress and egress untagged VLAN. We were not configuring it that way
> and so we would be ingress untagged but egress tagged.
> 
> When our devices are interfaced with other link partners such as switch
> devices, the results would be entirely equipment dependent. Some
> switches are completely fine with accepting an egress tagged frame with
> VLAN ID 0 and would send their responses untagged, so everything works,
> but other devices are not so tolerant and would typically reject a VLAN
> ID 0 tagged frame.
> 
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Hi all,
> 
> After looking at all DSA drivers and how they implement port_vlan_add()
> I think this is the right change to do, but would appreciate if you
> could test this on your respective platforms to ensure this is not
> problematic.
> 
> Thank you
> 
> 
>  net/dsa/slave.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 088c886e609e..d3a2782eb94d 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1100,6 +1100,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	struct bridge_vlan_info info;
> +	u16 flags = 0;
>  	int ret;
>  
>  	/* Check for a possible bridge VLAN entry now since there is no
> @@ -1118,7 +1119,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  			return -EBUSY;
>  	}
>  
> -	ret = dsa_port_vid_add(dp, vid, 0);
> +	/* VLAN ID 0 is special and should be the default egress and ingress
> +	 * untagged VLAN, make sure it gets programmed as such.
> +	 */
> +	if (vid == 0)
> +		flags = BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED;
> +
> +	ret = dsa_port_vid_add(dp, vid, flags);
>  	if (ret)
>  		return ret;

If a frame tagged with VID 0 ingresses a Marvell port with 802.1Q enabled,
the VID assigned will be the port's default VID.

That being said, the hardware shouldn't prevent us from programming a port's
default VID as 0 or adding an entry for VID 0 in the VLAN table, but AFAICT
we are rejecting the latter for some reasons (it might have no effect, idk).

With this change we will be overriding the port's default VID with 0 in
addition to attempting to program a VLAN entry for the null VID (mv88e6xxx
would still return -EOPNOTSUPP at the moment for both anyway). Am I correct?


Thank you,

	Vivien
