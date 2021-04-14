Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2635F79E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352237AbhDNP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352218AbhDNP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:27:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A415C061574;
        Wed, 14 Apr 2021 08:27:13 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t140so14633263pgb.13;
        Wed, 14 Apr 2021 08:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLYWJz3osXjxAkCOlH86kH9Vsgq0eoIxvXtUSYuGwMA=;
        b=H8c8MPpbxSfENIBBEJjGnJQDVz+drAfETl7C6XyziXHwjqr7OlzqUOu/o/1ZLHwDvv
         /N8/bnTNcMWJK/opajmZsxCr56ZR8eTQPcFXCrLhf++lx+prInij6KuIOR8LpyTpgcw8
         R7GGuvMeWP9eoM3avQ5DSmbm9A/XVfsfTJQbXi/hwso3KOiJxYqvYBgWy3N40g+3X50X
         PNmDVbJgxjvZyd7Qs6gKOiAFOBmkoW1v6HJGozikxcaOBWBTHFPfHsf7ei8Ec0DZHO92
         yJ8zjSCkNTl3Cf3DQPSXBz0YMZc2yObPdzzPD+HAnc1RSV6qAadiuyDxn0cNohORn9H7
         HCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLYWJz3osXjxAkCOlH86kH9Vsgq0eoIxvXtUSYuGwMA=;
        b=P/W2rariKaJIY09PavzNeZnvGOj4QiVL1RVRF9reHsWj+H1Ka8WqxpSfN7EAQP/4pA
         CJ8ZqGzocu4brJ2I8TBpd6jZH1ZC0Hemc9V+3IqI+IhXheDHa0dCPMKYZ0xmzDCnd/Ae
         dBMBrwZ6lX3NP1cyXZ84qGg0dx1l3nxTcLDEu5ueuGktuMZSPBWhNIVxldoM9Cf+jcv+
         E3F2wth4cOi7TrBWvDlKHFJZEh8LQG1gbXx2qZPYiBXYfINSHYgmU4NAK/pX5hF1+Qk/
         D22J1eb/tAJboSBUUMK7YjVPf3nDfvzBTJHKGqCrlm0v88lMI0ttFnAfaUOXWW3DORGt
         JRCQ==
X-Gm-Message-State: AOAM533tb/O1G99qz8BEvIlOkkdMMb7wOSM9/T5lkBLpLUAwpaC5MIvz
        bqnasa4IqwBngz+xDX7vnmAbtiisPNSFyQ==
X-Google-Smtp-Source: ABdhPJybmMtmhdU9JtYDDLh7Qv+Aqdv4vk1t72ErZeP7Gf8BlsXZlnwfdBLtFsFSxM6MGRgjqwgm3w==
X-Received: by 2002:a63:4e47:: with SMTP id o7mr37462335pgl.286.1618414032749;
        Wed, 14 Apr 2021 08:27:12 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 25sm697832pgx.72.2021.04.14.08.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:27:12 -0700 (PDT)
Date:   Wed, 14 Apr 2021 18:26:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: bridge: switchdev: refactor
 br_switchdev_fdb_notify
Message-ID: <20210414152657.7ll7e2xh76njoc6l@skbuf>
References: <20210414151540.1808871-1-olteanv@gmail.com>
 <b541c88e-879e-ee9d-90d8-2cd37690f7e6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b541c88e-879e-ee9d-90d8-2cd37690f7e6@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 06:25:03PM +0300, Nikolay Aleksandrov wrote:
> On 14/04/2021 18:15, Vladimir Oltean wrote:
> > From: Tobias Waldekranz <tobias@waldekranz.com>
> > 
> > Instead of having to add more and more arguments to
> > br_switchdev_fdb_call_notifiers, get rid of it and build the info
> > struct directly in br_switchdev_fdb_notify.
> > 
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
> >  1 file changed, 11 insertions(+), 30 deletions(-)
> > 
> 
> Hi,
> Is there a PATCH 0/2 with overview and explanation of what's happening in this set ?
> If there isn't one please add it and explain the motivation and the change.
> 
> Thanks,
>  Nik

Nope, there isn't. Being a 2-patch series, and having the explanation
already provided in patch 2, I didn't consider a cover letter as
necessary. Change #1 is just preliminary refactoring.
