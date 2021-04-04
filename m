Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34C63535FA
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 02:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhDDACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhDDACK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 20:02:10 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0DFC061756;
        Sat,  3 Apr 2021 17:02:07 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k8so1563731edn.6;
        Sat, 03 Apr 2021 17:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LiELD0z/DKiDnO4+77r07UQAbm709BAGanWiBrgupZM=;
        b=reOZQRaHowG7VaKnJH97mCgTczk/iG+eWPUgUwRbqF4Gppq+6VpKRvUBEFyxJSKAXP
         slzLs2DlbpLDL/gWrTO0T+McCPA53UzlHqhTYGQnpqEgPqrHcwVS9cQghypxke08PZBA
         +G59Chev1XIrN9e+UCPk5JWdUPadlvFnogMaOg6RjLiTIzKXXxGOUSTmaM1tLmM0Ahs+
         74n6wX6mf+v+YkDaIUdW+YQRoaYKuu1oqdw/FOOhE8/tXRJ54q5J5Fm40ThgNarkYCCS
         uB/OwzfROoktpGLFe4FnoXGfcbG73PW7DwPDagMbUjPy8/5oAmrRR3x3e2fJZ8w9b6Lo
         7kOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LiELD0z/DKiDnO4+77r07UQAbm709BAGanWiBrgupZM=;
        b=ZJWs6bVgSrpNUDN3CEYwm86GxiHJIET0wWROOUq0juERCFxZuurAhmVZzJk3T9+ukg
         NutwtQp2SqRvV6qkEtem7Jn9GyeZNkwj+ykOyQ+r38/SVQGXuusVM5b/5zekZczp3vuZ
         uUFKpAWBZ6UPzvYLKFxLUhsTZpInGRC1H9GgoYWb7z4RKZusgRFuCx83iwPAeiaQaaAf
         QgBQ0vUQnkGiQo7taxfLjW0O2MY4YdLvr/6lbe0BmcmG+6RG9b31XL8eyLWPgldGm7Gp
         HdJB8gYO9KPeNOu6vriRRxXnwtVWDF5Sec/n3l7GI1iSgyhNTBHxVLxtuyQQYmFSSg5R
         vNig==
X-Gm-Message-State: AOAM531GUTkrCLfZnia92ePRDajTH75eQvG4ikShdfVz+oOvrcIp73ey
        K6ioN9EuaueaR8BBR5QrhS6lSzoVb4Q=
X-Google-Smtp-Source: ABdhPJxtbZgqKSzNpcHPN0N5PJmT0nbemHaGWo2exNHCbBvtDzu5aKAjnhH+S1CYuLYK8eDEzMLBdQ==
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr22969336edv.230.1617494526030;
        Sat, 03 Apr 2021 17:02:06 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m14sm7837258edr.13.2021.04.03.17.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 17:02:05 -0700 (PDT)
Date:   Sun, 4 Apr 2021 03:02:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210404000204.kujappopdi3aqjsn@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
 <YGiAjngOfDVWz/D7@lunn.ch>
 <f4856601-4219-09c7-2933-2161afd03abe@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4856601-4219-09c7-2933-2161afd03abe@rempel-privat.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 07:14:56PM +0200, Oleksij Rempel wrote:
> Am 03.04.21 um 16:49 schrieb Andrew Lunn:
> >> @@ -31,6 +96,13 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
> >>  	__le16 *phdr;
> >>  	u16 hdr;
> >>
> >> +	if (dp->stp_state == BR_STATE_BLOCKING) {
> >> +		/* TODO: should we reflect it in the stats? */
> >> +		netdev_warn_once(dev, "%s:%i dropping blocking packet\n",
> >> +				 __func__, __LINE__);
> >> +		return NULL;
> >> +	}
> >> +
> >>  	phdr = skb_push(skb, AR9331_HDR_LEN);
> >>
> >>  	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
> >
> > Hi Oleksij
> >
> > This change does not seem to fit with what this patch is doing.
> 
> done
> 
> > I also think it is wrong. You still need BPDU to pass through a
> > blocked port, otherwise spanning tree protocol will be unstable.
> 
> We need a better filter, otherwise, in case of software based STP, we are leaking packages on
> blocked port. For example DHCP do trigger lots of spam in the kernel log.

I have no idea whatsoever what 'software based STP' is, if you have
hardware-accelerated forwarding.

> I'll drop STP patch for now, it will be better to make a generic soft STP for all switches without
> HW offloading. For example ksz9477 is doing SW based STP in similar way.

How about we discuss first about what your switch is not doing properly?
Have you debugged more than just watching the bridge change port states?
As Andrew said, a port needs to accept and send link-local frames
regardless of the STP state. In the BLOCKING state it must send no other
frames and have address learning disabled. Is this what's happening, is
the switch forwarding frames towards a BLOCKING port?
