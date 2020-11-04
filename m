Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB562A703A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732330AbgKDWId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:08:33 -0500
Received: from mail-oo1-f66.google.com ([209.85.161.66]:43537 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:08:33 -0500
Received: by mail-oo1-f66.google.com with SMTP id z14so11858oom.10;
        Wed, 04 Nov 2020 14:08:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cUpVQds8DCOsEY6f9AUbNrj5fsXMdU/YU8tvU+q5oco=;
        b=gNATklkRs/ozvJWGjlIBK1ijbZyf5MVC74ysCZ37Ss8sm4US27AIU4PWxIq7R18Hq8
         YKnAMEE28zMsTUfek6mjv0QMdTjFqJ3FpiBjAPhRfqziMovQvEd+x7g1t+P68MxsCe9T
         14XjCQngDlRgq+K3SlZBuwLeb2bpFQk449vkrI3IK7/qmD2/vf9/eKTe4hjeUeixE8n3
         tkb47tyY1U1HbrIF8a1PjJa9ZotavwOuf46+W0Md0q37zfN+hKeiy8LG5ZFeS62iZZew
         sSFSQoQqjaMlAH5GSO/zpychy6g9ozaRvCorsIX83IeydDDSYF/ms9SkKLi+DCuphThe
         gEmg==
X-Gm-Message-State: AOAM531F02yZfMuzAyop7j4orC0MZipsHDrMHxeAHOaGjayWBdZNQIHD
        d17MojnKHHJio8Gl2cYtXq6HztRylg==
X-Google-Smtp-Source: ABdhPJwlVBWqAnaWTc0kRKqZp6PjxlWuv66zncIa54/soy0ziGh46mHILrMtnDZOUzvyTKu4aiY+Tg==
X-Received: by 2002:a4a:6f4d:: with SMTP id i13mr189550oof.25.1604527712393;
        Wed, 04 Nov 2020 14:08:32 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p126sm750613oia.24.2020.11.04.14.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 14:08:31 -0800 (PST)
Received: (nullmailer pid 13892 invoked by uid 1000);
        Wed, 04 Nov 2020 22:08:31 -0000
Date:   Wed, 4 Nov 2020 16:08:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
Message-ID: <20201104220831.GA10591@bogus>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-3-dmurphy@ti.com>
 <20201030195655.GD1042051@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030195655.GD1042051@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 08:56:55PM +0100, Andrew Lunn wrote:
> On Fri, Oct 30, 2020 at 12:29:48PM -0500, Dan Murphy wrote:
> > Per the 802.3cg spec the 10base T1L can operate at 2 different
> > differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
> > drive that output is dependent on the PHY's on board power supply.
> 
> Hi Dan
> 
> So this property is about the board being able to support the needed
> voltages? The PHY is not forced into 2.4v p2p, it just says the PHY
> can operate at 2.4v and the board will not melt, blow a fuse, etc?
> 
> I actually think it is normal to specify the reverse. List the maximum
> that device can do because of board restrictions. e.g.
> 
> - maximum-power-milliwatt : Maximum module power consumption
>   Specifies the maximum power consumption allowable by a module in the
>   slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
> 
> - max-link-speed:
>    If present this property specifies PCI gen for link capability.  Host
>    drivers could add this as a strategy to avoid unnecessary operation for
>    unsupported link speed, for instance, trying to do training for
>    unsupported link speed, etc.  Must be '4' for gen4, '3' for gen3, '2'
>    for gen2, and '1' for gen1. Any other values are invalid.
> 
>  - max-microvolt : The maximum voltage value supplied to the haptic motor.
>                 [The unit of the voltage is a micro]
> 
> So i think this property should be
> 
>    max-tx-rx-p2p = <1000>;
> 
> to limit it to 1000mv p2p because of board PSU limitations, and it is
> free to do 22000mv is the property is not present.

'-microvolt' suffix please.

> 
>    Andrew
> 
