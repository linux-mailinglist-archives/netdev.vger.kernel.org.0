Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27FB25F8C7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgIGKsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgIGKsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:48:25 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D07EC061573;
        Mon,  7 Sep 2020 03:48:25 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b12so12289260edz.11;
        Mon, 07 Sep 2020 03:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iBqtvek5TDmjyz+u1puGykNUu2EobR0SzbFd/gaLNY8=;
        b=Ys8Tr0RlWHm9NXqOBsW0xIAmymRgasAlujUuk8CeID/ldaeEKw2aYdEjyW7XT2AgYK
         NCwZ1s+CK/oQNo7GsUbF3zWM1Gnj3e0V2mRc3nWrjxwefOm9JtzsgIMIE5zIpw2vutk2
         eWXNTVOEvjsNuKwyXf2IP1mhJ/fwPFSaRam239YUB3M2CSoFDC0OPdse0866Ov3c0jgb
         3zjG7oZywmlpSRYBMhFLnEK/0WaTh1inST5s/kLcPxZqR62FSym9dXJbTgj9/iW2Evwn
         pXPr3n6iw05KHHXc43PviPVdlH+/eL5OcfwYL0qGa61/kfAhW8KDKVP49A3GSJbXA3sA
         w5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iBqtvek5TDmjyz+u1puGykNUu2EobR0SzbFd/gaLNY8=;
        b=IdIPvaLcmM87gefnsXnAXfM+KuorV4rT9JptMM2+URk+4o07xJWOul0UBnjF5os2NP
         N+5ySgwp2n9fdWcNk8GAfU81LF9nuFC74e5QFgnedUi0I98jfC8AFyA1aloC+3v7IlLZ
         clhHv5CEJjI5UI8y3nJy63k8JHtTRe/r6eQ00jIJplXOqsXP2QoiwelSRhtLzYKd6gKH
         mFSRf6fdOKDvNRqRAzytNepTOKHGIbSiuXiNneVpoyXQo01CVo5Lr0BdzdODCkfJpMrm
         YP/b9g7irmzpzGV8AywkcKpVmwsMoHZbEkYSpM6PqJKi0BTWoN0Eq70tvDw6q8RXOR5y
         Wugw==
X-Gm-Message-State: AOAM533gWVwByUrhuZ1Sw1aMp+a5uglSSTHAMToQJuxqFdH+I6z0x6Sa
        RV4q5rNJnqFUnKW3yiG/Yxg=
X-Google-Smtp-Source: ABdhPJx3LyEptdDFFpalWUgmLIuVLO+5QsBC/eBajLBrpHGmvWSXvRFV0jl2R2iwsS9DKPgTLkWOnA==
X-Received: by 2002:a50:ce09:: with SMTP id y9mr20541740edi.91.1599475704007;
        Mon, 07 Sep 2020 03:48:24 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id i26sm2252381edq.47.2020.09.07.03.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:48:23 -0700 (PDT)
Date:   Mon, 7 Sep 2020 13:48:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200907104821.kvu7bxvzwazzg7cv@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de>
 <20200904062739.3540-3-kurt@linutronix.de>
 <20200905204235.f6b5til4sc3hoglr@skbuf>
 <875z8qazq2.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z8qazq2.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 08:05:25AM +0200, Kurt Kanzenbach wrote:
> Well, that depends on whether hellcreek_vlan_add() is called for
> creating that vlan interfaces. In general: As soon as both ports are
> members of the same vlan that traffic is switched.

That's indeed what I would expect.
Not only that, but with your pvid-based setup, you only ensure port
separation for untagged traffic anyway. I don't think you even need to
call hellcreek_vlan_add() for VID 100 to be switched between ports,
because your .port_vlan_filtering callback does not in fact disable VLAN
awareness, it just configures the ports to not drop unknown VLANs. So,
arguably, VLAN classification is still performed. An untagged packet is
classified to the PVID, a tagged packet is classified to the VID in the
packet. So tagged packets bypass the separation.

So, I think that's not ok. I think the only proper way to solve this is
to inform the IP designers that VLANs are no substitute for a port
forwarding matrix (a lookup table that answers the question "can port i
forward to port j"). Switch ports that are individually addressable by
the network stack are a fundamental assumption of the switchdev
framework.

> > I remember asking in Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
> > whether it would be possible for you to set
> > ds->configure_vlan_while_not_filtering = true during hellcreek_setup.
> > Did anything unexpected happen while trying that?
>
> No, that comment got lost.
>
> So looking at the flag: Does it mean the driver can receive vlan
> configurations when a bridge without vlan filtering is used? That might
> be problematic as this driver uses vlans for the port separation by
> default. This is undone when vlan filtering is set to 1 meaning vlan
> configurations can be received without any problems.

Yes.
Generally speaking, the old DSA behavior is something that we're trying
to get rid of, once all drivers set the option to true. So a new driver
should not rely on it even if it needs something like that. If you need
caching of VLANs installed by the bridge and/or by the 8021q module,
then you can add those to a list, and restore them in the
.port_vlan_filtering callback by yourself. You can look at how sja1105
does that.

Thanks,
-Vladimir
