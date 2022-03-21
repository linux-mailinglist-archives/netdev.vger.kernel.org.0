Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACA84E320A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiCUUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiCUUuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:50:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2B9286D7
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:48:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id r13so32312583ejd.5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bSlOQIrK58qWLxxG6HsBVZeci1CmosW49LnKblmx94o=;
        b=SZTRTM3u6bOQeAt0wsGb4UCZsFMlpA2fucgYEBY7dpx0PWxmPgh+C1RQDcchCkJDUB
         zDLyQ+BBNSwdDB2yzkRJYN6xO7jp00Yu2EKrY+W+fEumGZFcAcaokwgw8gHp4HOCpsZo
         jYx8Oa4LsusQV66JiCeaf9ZFzptYdb0hpoiNNp83fZgApL56XP/HuSIh5F2THcsn+U3R
         8DGgM7DUIYkFbNOmpbDmvh/4Mb6l3H6g3Oqa1EKbE6KiNR7eHUZJD38xGDYHU5Py8Z+7
         DHcUklc2Xr8GYlI6bjw3Wart8cSh+SBK/wJEGkDt9e71NV/Y5HFOKu94FzGxaws52oew
         P+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bSlOQIrK58qWLxxG6HsBVZeci1CmosW49LnKblmx94o=;
        b=zlGbLgvD/YQMDjSh6GSJlgUkvMUCZDVWeioN44zRtmfdHR6TCjnqlQZtIgctkAckQJ
         cl0DdkshgW8O+xLtRdBUVq7jqpM3Zn739DiBkHnSYHtL9VtxUU5yVJdo1d18nbuxA0ST
         /TQIfwdufib4DYyR6ztkCydVoWYGy7GGY/Hw0alSHC8H8A95DOVeeoKVOa3Dtvj4E8ai
         txXKOydG1xiglsUq4wmuIKj4tN5UE6gRq4O2LRJZFzvMSSGkTVkHQ3xlH0/KUWk+t8H5
         CSq/FXpEb9u2j3wzVpA+u0XZbqggWQ+9kEmgv/0MZl+P171AF9tTUFqCXlLJjoNbIDn9
         0hqQ==
X-Gm-Message-State: AOAM531LmbbnYnYQyqW37tBTocldkrDXAg1CpWLIfpyPKJdpZYE+Pf9D
        CaIzZxThNrR/N5HuN06Xrv4=
X-Google-Smtp-Source: ABdhPJywiI+aTCtr9A5Gz1PiOoqk206X0cKU+fUQ3o/Hd85PXqEfjWmWfZjg56syEo0u2eVLg/iJig==
X-Received: by 2002:a17:906:5d08:b0:6db:7291:df22 with SMTP id g8-20020a1709065d0800b006db7291df22mr21069371ejt.178.1647895714453;
        Mon, 21 Mar 2022 13:48:34 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id gg3-20020a170906e28300b006da68b9fdf1sm7298849ejb.68.2022.03.21.13.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:48:34 -0700 (PDT)
Date:   Mon, 21 Mar 2022 22:48:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH net-next] net: create a NETDEV_ETH_IOCTL notifier for
 DSA to reject PTP on DSA master
Message-ID: <20220321204832.dyz3telactx6jhqj@skbuf>
References: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
 <20220321132829.71fe30d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321132829.71fe30d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 01:28:29PM -0700, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 00:50:35 +0200 Vladimir Oltean wrote:
> > The fact that PTP 2-step TX timestamping is deeply broken on DSA
> > switches if the master also timestamps the same packets is well
> > documented by commit f685e609a301 ("net: dsa: Deny PTP on master if
> > switch supports it"). We attempt to help the users avoid shooting
> > themselves in the foot by making DSA reject the timestamping ioctls on
> > an interface that is a DSA master, and the switch tree beneath it
> > contains switches which are aware of PTP.
> > 
> > The only problem is that there isn't an established way of intercepting
> > ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
> > stack by creating a struct dsa_netdevice_ops with overlaid function
> > pointers that are manually checked from the relevant call sites. There
> > used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
> > one left.
> 
> Remind me - are the DSA CPU-side interfaces linked as lower devices 
> of the ports?

DSA CPU-side interfaces have no representation towards user space.
We overlay some port counters through the ethtool_ops of the host
controller, such that when the user runs "ethtool -S eth0" they see the
counters of the switch port and of the host port back to back, and
that's about it. The ioctl for which we have a special case, and which
I'm now trying to remove, is just to enforce a restriction.

> > In fact, the underlying reason which is prompting me to make this change
> > is that I'd like to hide as many DSA data structures from public API as
> > I can. But struct net_device :: dsa_ptr is a struct dsa_port (which is a
> > huge structure), and I'd like to create a smaller structure. I'd like
> > struct dsa_netdevice_ops to not be a part of this, so this is how the
> > need to delete it arose.
> 
> Isn't it enough to move the implementation to a C source instead 
> of having it be a static inline?

Assuming you mean to make that C source part of dsa_core.o:

obj-$(CONFIG_NET_DSA) += dsa_core.o

CONFIG_NET_DSA can be module, so it couldn't be called from built-in code.

Or do you mean adding something like:

obj-y := dsa_extra.o

which only contains dsa_master_ioctl(), basically?

> > The established way for unrelated modules to react on a net device event
> > is via netdevice notifiers. These have the advantage of loose coupling,
> > i.e. they work even when DSA is built as module, without resorting to
> > static inline functions (which cannot offer the desired data structure
> > encapsulation).
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > I'd mostly like to take this opportunity to raise a discussion about how
> > to handle this. It's clear that calling the notifier chain is less
> > efficient than having some dev->dsa_ptr checks, but I'm not sure if the
> > ndo_eth_ioctl can tolerate the extra performance hit at the expense of
> > some code cleanliness.
> > 
> > Of course, what would be great is if we didn't have the limitation to
> > begin with, but the effort to add UAPI for multiple TX timestamps per
> > packet isn't proportional to the stated goal here, which is to hide some
> > DSA data structures.
> 
> Was there a reason we haven't converted the timestamping to ndos?
> Just a matter of finding someone with enough cycles to go thru all 
> the drivers?

So you're saying that if SIOCSHWTSTAMP and SIOCGHWTSTAMP had their own
ndo, a netdev notifier would be easier to swallow?

Maybe, I haven't explored that avenue, but on the other hand,
ndo_eth_ioctl seems to only be used for PTP, plus PHY user-space access
(SIOCGMIIPHY, SIOCGMIIREG, SIOCSMIIREG). There isn't an active desire
from PHY maintainers to keep that UAPI in the best shape, to my
knowledge, since it is feared that if it works too well, vendors might
end up with user space PHY drivers for their SDKs. Those ioctls are
currently a best-effort debugging tool.
