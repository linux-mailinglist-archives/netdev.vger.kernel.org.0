Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914422ECE8E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbhAGLTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGLTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:19:06 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F2DC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 03:18:25 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx16so9107786ejb.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 03:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZCZtuOxjUPrYHi8Vl+LFDqpXcGWaGetjPZOftf97C0s=;
        b=jIFAvH4l7LX04buD1dLvbeOLu8P38Jn96bPmJRCA6YLaFOIcUT0yEVf08WwtOppQCc
         dfoXN/Hh+7ITcatFF+yM0nzAdGaVKg+iq889PkgeY5bEMHd58fhhlD6bQmH+wsj4+hJI
         Ye99Orn/ORVQ5HytCAUbdDXQnMM6Z9Y9Xo91uoOS9wZQgrdD1qlR+6IrJTWQz8JBiGg4
         QALjYV0ksQ8zyGpl4Y8BrTrTzsya9xN9ulqfDB5ku8340tBLukfQVsHkMg0YacNiRbAt
         xZtLemx/BVKD/jJ0NpkkP8CS1p6ZmQ843mFddlu9B9ufjN0tKtIX3LtXc90tS9bTm7yl
         LsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZCZtuOxjUPrYHi8Vl+LFDqpXcGWaGetjPZOftf97C0s=;
        b=ezGGZ4ueH/smJOO2apgPmjxLklbZ6qO3PMbpNLSP7wmIgRuzB5g3BXVYiJ4YjjUbtg
         a8lqiXaiwWzCeCih8JbHxJ8TYIovGfVGL4vpM8phyHtybg8jjCg/cA71ga97EXqs32B5
         RKGC2qhqruc2vRZYYvGkCSSDqgWkhn3+ocSXV6AAwPum0nKl0qvZ5HOWah8phxR3dZ+z
         FycpiwdI1iFqouhyPZEraZ+i1bhsvc3gWxbML+/EWo6fFes2We3fThmlNmMKmyTUdIU/
         JlePz5V+Y6vnXMPLny+womBeNtEgZlp4Q7tFPRbH+ORdug9/v+9ji0c4CKuZe4atrQeo
         FFnA==
X-Gm-Message-State: AOAM532C2gP90Mnd3+dDz7RrpE3Grk+4nL3SiFmcgWdK8mUzqyM04NqC
        vqziXLaCjJbpx7lB+Q8seqY=
X-Google-Smtp-Source: ABdhPJyYa01ElE/lDFmzIJ2rx/mx+aTJgr1Xf/zoyd8qOrYSu9FhEcznejSo/FoVHuF0SGQq3qVgdQ==
X-Received: by 2002:a17:906:2e85:: with SMTP id o5mr5866380eji.521.1610018304464;
        Thu, 07 Jan 2021 03:18:24 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s19sm2556570edx.7.2021.01.07.03.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 03:18:23 -0800 (PST)
Date:   Thu, 7 Jan 2021 13:18:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>, petrm@nvidia.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 03/11] net: switchdev: remove the transaction
 structure from port object notifiers
Message-ID: <20210107111822.icmzu4lvs5ygsuef@skbuf>
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-4-olteanv@gmail.com>
 <20210107103835.GA1102653@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107103835.GA1102653@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:38:35PM +0200, Ido Schimmel wrote:
> +Petr
> 
> On Thu, Jan 07, 2021 at 01:17:20AM +0200, Vladimir Oltean wrote:
> >  static int mlxsw_sp_port_obj_add(struct net_device *dev,
> >  				 const struct switchdev_obj *obj,
> > -				 struct switchdev_trans *trans,
> >  				 struct netlink_ext_ack *extack)
> >  {
> >  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
> >  	const struct switchdev_obj_port_vlan *vlan;
> > +	struct switchdev_trans trans;
> >  	int err = 0;
> >  
> >  	switch (obj->id) {
> >  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> >  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> > -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
> > +
> 
> Got the regression results. The call to mlxsw_sp_span_respin() should be
> placed here because it needs to be triggered regardless of the return
> value of mlxsw_sp_port_vlans_add().

So before, mlxsw_sp_span_respin() was called right in between the
prepare phase and the commit phase, regardless of the error value of
mlxsw_sp_port_vlans_add. How does that work, I assume that
mlxsw_sp_span_respin_work gets to run after the commit phase because it
serializes using rtnl_lock()? Then why did it matter enough to schedule
it between the prepare and commit phase in the first place?
And what is there to do in mlxsw_sp_span_respin_work when
mlxsw_sp_port_vlans_add returns -EOPNOTSUPP, -EBUSY, -EINVAL, -EEXIST or
-ENOMEM?
