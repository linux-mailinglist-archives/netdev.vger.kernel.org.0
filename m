Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D544A22A290
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgGVWq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgGVWq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:46:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B682DC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:46:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n22so4218744ejy.3
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QqZeExRja9iLo3aP7UXSPVfY+zvHY7+HCW+H9bFbzF8=;
        b=OBUHp3Mre3/0mfNP0MHJ82ZXDncGoKD7NXUa1GjafYXHeZpxYbiE2uvRTURRvlu/2t
         TWD0I4ZU2K2sCc2K0XbFj6VJrAiO3s9zvYyO6l+rO1yzWtesfB4Ox1yeR/Kp/VoWXDGr
         taw8cbl/IZ9l2y/rjW4SdToMYVBNpOIkqGqYqjbgbRhbnLOjRExcLXOUYcVjFigTCBUc
         s8aXbJ/4ldmsuPVpDxhtswvlstvqYHwxrSTSxBW3rongw8zSmJ9r2ba/WsJqANqe/uRV
         2wE1R3ADuAU59aKFYJlfw38NVeGigMilNtbZlycZQguVT7qO1ObjjLLwgAuUbqZ+bYxH
         sUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QqZeExRja9iLo3aP7UXSPVfY+zvHY7+HCW+H9bFbzF8=;
        b=Kc70E0YB0BTSdyrYqCnqUS98wyOSLAbmF8FAtGaZ6aSGyGgnQZgIcz+9M6ERuWpAlx
         DL3CDhYehhyBo2NSR5iIGGi2cwu572QDJaMx4OJOtcgklvnxsd5d0aeNUYyRu+Lyw/VU
         cmAKnlZvIopg6BZGV0M/o84HAk7F7VSD4FK0Bc8m5iC4/DiR3PS3tyDWT51yjg4QQH+X
         zgyL28dot5wy32DWaER1l8PMz61WcQFAIr6qGVKaeToHCTyQ+UB/tOqLXijrF/eLTX7e
         AJ/XJQCoAsSxvmk9a6fhKzZnlYL5z3QB48MonxlXRgEfV/DavywyeRafFvv/ksPYmNVy
         Czqg==
X-Gm-Message-State: AOAM532XsY8LGl34JRi8u+RiHa2JIy2Zyg9MYPQ5+lXlK6ZQkezBeO2O
        in34dsQRairplOZ8NYXt81s=
X-Google-Smtp-Source: ABdhPJyg7bHOh+vi9D5CIr5F2PP7ZPPLKwCGGGY80+187S3u9zN1H2yYRMBRKjDiO9V8iectzWmzhA==
X-Received: by 2002:a17:906:8605:: with SMTP id o5mr1731665ejx.533.1595458017314;
        Wed, 22 Jul 2020 15:46:57 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id h10sm779121eds.0.2020.07.22.15.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 15:46:56 -0700 (PDT)
Date:   Thu, 23 Jul 2020 01:46:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, mkubecek@suse.cz, richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: restore DSA behavior of not overriding
 ndo_get_phys_port_name if present
Message-ID: <20200722224654.nqlw4nhdm22f7a5d@skbuf>
References: <20200722205348.2688142-1-olteanv@gmail.com>
 <98325906-b8a5-fb0c-294d-b03c448ba596@gmail.com>
 <20200722220650.dobse2zniylfyhs6@skbuf>
 <6db74106-af90-deac-907d-9f0c971ec698@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6db74106-af90-deac-907d-9f0c971ec698@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 03:11:09PM -0700, Florian Fainelli wrote:
> On 7/22/20 3:06 PM, Vladimir Oltean wrote:
> > On Wed, Jul 22, 2020 at 02:53:28PM -0700, Florian Fainelli wrote:
> >> On 7/22/20 1:53 PM, Vladimir Oltean wrote:
> >>> Prior to the commit below, dsa_master_ndo_setup() used to avoid
> >>> overriding .ndo_get_phys_port_name() unless the callback was empty.
> >>>
> >>> https://elixir.bootlin.com/linux/v5.7.7/source/net/dsa/master.c#L269
> >>>
> >>> Now, it overrides it unconditionally.
> >>>
> >>> This matters for boards where DSA switches are hanging off of other DSA
> >>> switches, or switchdev interfaces.
> >>> Say a user has these udev rules for the top-level switch:
> >>>
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p0", NAME="swp0"
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p1", NAME="swp1"
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p2", NAME="swp2"
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p3", NAME="swp3"
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p4", NAME="swp4"
> >>> ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p5", NAME="swp5"
> >>>
> >>> If the DSA switches below start randomly overriding
> >>> ndo_get_phys_port_name with their own CPU port, bad things can happen.
> >>> Not only may the CPU port number be not unique among different
> >>> downstream DSA switches, but one of the upstream switchdev interfaces
> >>> may also happen to have a port with the same number. So, we may even end
> >>> up in a situation where all interfaces of the top-level switch end up
> >>> having a phys_port_name attribute of "p0". Clearly not ok if the purpose
> >>> of the udev rules is to assign unique names.
> >>>
> >>> Fix this by restoring the old behavior, which did not overlay this
> >>> operation on top of the DSA master logic, if there was one in place
> >>> already.
> >>>
> >>> Fixes: 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
> >>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> >>> ---
> >>> This is brain-dead, please consider killing this and retrieving the CPU
> >>> port number from "devlink port"...
> >>
> >> That is fair enough. Do you want to submit such a change while you are
> >> at it?
> >>
> > 
> > If I'm getting you right, you mean I should be dropping this patch, and
> > send another one that deletes dsa_ndo_get_phys_port_name()?
> > I would expect that to be so - the problem is the fact that we're
> > retrieving the number of the CPU port through an ndo of the master
> > interface, it's not something we can fix by just calling into devlink
> > from kernel side. The user has to call into devlink.
> 
> Yes, that is what I meant, that an user should call the appropriate
> devlink command to obtain the port number, this particular change has
> caused more harm than good, and the justification for doing it in the
> first place was weak to begin with.
> -- 
> Florian

If the patch at this link is considered appropriate:
https://patchwork.ozlabs.org/project/netdev/patch/20200722224312.2719813-1-olteanv@gmail.com/
then this can be considered superseded by that.

If not, please apply this.

Thanks,
-Vladimir
