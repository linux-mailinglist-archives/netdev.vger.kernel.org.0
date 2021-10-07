Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553FB42541E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbhJGNdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbhJGNdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:33:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085DDC061570;
        Thu,  7 Oct 2021 06:31:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r18so23182827edv.12;
        Thu, 07 Oct 2021 06:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t0IAWOvl3a3qwkGQJmTuWOFjKcWUEE6niq8v/jG+sMs=;
        b=cNRmOr160e6uaaJtcXnnpj5v8Nww9ZAW4EAoDvssZx/ZUpQlf96833nHLScJmPXj5j
         NBl7FJxLzwNJE4b/n4YhJ079y8s8xt8vhahq3J3VFSf24UH9Y/p7MBaTJlaO9BNvbKea
         QI0kTw4Yy5tsiowM+4PRIpSJLB5VvE0c69/w+83SNkakB+BuwGbYdX5vpcyG7hJ/WbNm
         S1Y+Fe3MkyXhGW+RVlytzpQHqaoj3ZdgkkRcJH7EanVCtrZf4Q4lnukOgYLrCUxFYOje
         kEOoEaC4mHrpYnVfKITsTvlFDyy5h1VJmsE8zLQrZSmFuLZ2+s4bbSrXycSl7DzGBxkX
         ksbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t0IAWOvl3a3qwkGQJmTuWOFjKcWUEE6niq8v/jG+sMs=;
        b=JqEIBlJemSIvYBd+zs1yGKfu1CELMZCrLzMvs/HQD8lDYlwD0i13vvZrVtIte9fhAO
         w2rqb8OPja8NznmonKxJK8aWEJIyGOOva6mNtyV7nsbH6p5sWPTpi+ICXcX3Kre/vO+4
         N8UEaG27061IGK47aXabh4UsedI4RMItb2vOh4i64ct6/Q2wdYTr6ZZD/gpNt97nMm/p
         HxPJ58+b9tNdEWXqND0mnpJAlNc6JRT1uPAhC3ozjK4lUBS55QDnKa98uaZ5d5Kuny1X
         VM1ibPawWQq5J98b0cCBdzYku0BJEaeLRm9Zc3vzFydO/9fvhRI33+t4YCo0X0vocXxx
         Rn2w==
X-Gm-Message-State: AOAM533B1sRrF4BGNZVPVOZvUl0oe53N+mgb7igwbuqeVtpqQ+HE2aMJ
        i/8r7la4hSiweCqe4AxX/vI=
X-Google-Smtp-Source: ABdhPJyGqBLPYpc02uMHUDS4Ap9dBoYsz0P6x5BiSxF6siVTNfploZSxlisE5tRML1qBJK0xt518rA==
X-Received: by 2002:a05:6402:518d:: with SMTP id q13mr6333054edd.143.1633613475040;
        Thu, 07 Oct 2021 06:31:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u6sm11343551edt.30.2021.10.07.06.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:31:14 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:31:12 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 09/13] net: dsa: qca8k: check rgmii also on port
 6 if exchanged
Message-ID: <YV72oJ/wWiiNthAs@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-10-ansuelsmth@gmail.com>
 <YV4+KDQWNhDmcaHL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV4+KDQWNhDmcaHL@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:24:08AM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 12:35:59AM +0200, Ansuel Smith wrote:
> > Port 0 can be exchanged with port6. Handle this special case by also
> > checking the port6 if present.
> 
> This is messy.
> 
> The DSA core has no idea the ports have been swapped, so the interface
> names are going to be taken from DT unswaped. Now you appear to be
> taking phy-mode from the other port in DT. That is inconsistent. All
> the configuration for a port should come from the same place, nothing
> gets swapped. Or everything needs to swap, which means you need to
> change the DSA core.
> 
>     Andrew

The swap is internal. So from the dts side we still use port0 as port0,
it's just swapped internally in the switch.
The change here is required as this scan the rgmii delay and sets the
value to be set later in the phylink mac config.
We currently assume that only one cpu port is supported and that can be
sgmii or rgmii. This specific switch have 2 cpu port and we can have one
config with cpu port0 set to sgmii and cpu port6 set to rgmii-id.
This patch is to address this and to add the delay function to scan also
for the secondary cpu port. (again the real value will be set in the mac
config function)
Honestly i think we should just rework this and move the delay logic
directly in the mac_config function and scan there directly. What do you
think? That way we should be able to generalize this and drop the extra
if.

-- 
	Ansuel
