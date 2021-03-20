Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4A342BB4
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCTLMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhCTLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:12:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50ADC061794;
        Sat, 20 Mar 2021 03:35:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t4so1203269wrn.11;
        Sat, 20 Mar 2021 03:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TP+FtNROxyLbaOckk0iExdure1j/Nq80b62IW/64ezM=;
        b=LoUTcH+VzzCLcAWrK0vuR2PaKQ80+HhUCYIqhQ8q2McJfGeN4KqzBsa7Ng6Bn/gcUL
         ObgZw+D2aKjUqvW5fduHCzFNaQx6loyz/rnKYFrAnTaKEgHC/VOv9IBSTqbN/nMJ6Gwo
         XEdnbouS67rjLlJycgwUddlStZa5/IB9XztqPjGG78fIcsqwQ35gOORY6Xx3NmOhsfcg
         418J0VNMyUb4hMTC3V/gUCTxquENWomJzKnalF5nBHz/jImDhhhq4V4I7dKRL8JmqNkz
         nN9oKLaC6C82ZYATelcRiXC5f0VDoC6TAQGtbMHIzmzgsuL4G/CsXBBUBlbuiuCSzi/f
         uxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TP+FtNROxyLbaOckk0iExdure1j/Nq80b62IW/64ezM=;
        b=CrUQ3X6Y0irhtOWHGUPyd7X3dMbJfVFEo03NoFB9ZnVdnTov7DkssMB6zrNNx/BNzW
         wsoOaJj2I9V+LMeIlnkz9P+lyoDV9yIOHTGPV+UhdUB47FJZ6/ZgppKn/au4HhIk2faE
         iRri1K7/XVa/c3sehN7jm2t1QxgJOg8ahCMSPI7W58HCBUf4KfbltD5xpihXrcQKhRc7
         t6TxUkG4gVDVn1c/bUg2jAnwutTkaKx75yCrPga/81DhHh1zo/sPT/9dtlWv8ztsN4x3
         Wtk5IWnC0kiRFW4DX3pO54sk2gVq9nJ0WeOc4IqJjgYYppndKS4urkD2Rd3G3bb5Cnn2
         KfFg==
X-Gm-Message-State: AOAM5326l+ihCb/flFOQubx2kSxdVtSXhFL6IYhLz9yLOjJC+YP8BPGd
        VCJ0694TLw4hqnFmvDlzNZU3g+PDrcE=
X-Google-Smtp-Source: ABdhPJyWUNT8oSWbTTKG6xeLiRmZl0+fc9j5teyYJ/LFak8AwzwgsJoRcSLKFOolfm7NGHxJAX00xg==
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr9172430eji.323.1616235001944;
        Sat, 20 Mar 2021 03:10:01 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s6sm5081696ejx.83.2021.03.20.03.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 03:10:01 -0700 (PDT)
Date:   Sat, 20 Mar 2021 12:09:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 07/16] net: dsa: sync ageing time when
 joining the bridge
Message-ID: <20210320100959.w6mwmcwf4mstxord@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-8-olteanv@gmail.com>
 <7bc2c277-e75c-35e7-23d7-78616757177e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc2c277-e75c-35e7-23d7-78616757177e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:13:03PM -0700, Florian Fainelli wrote:
> > diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> > index 86b5e05d3f21..3dafb6143cff 100644
> > --- a/net/bridge/br_stp.c
> > +++ b/net/bridge/br_stp.c
> > @@ -639,6 +639,19 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
> >  	return 0;
> >  }
> >  
> > +clock_t br_get_ageing_time(struct net_device *br_dev)
> > +{
> > +	struct net_bridge *br;
> > +
> > +	if (!netif_is_bridge_master(br_dev))
> > +		return 0;
> > +
> > +	br = netdev_priv(br_dev);
> > +
> > +	return jiffies_to_clock_t(br->ageing_time);
> 
> Don't you want an ASSERT_RTNL() in this function as well?

Hmm, I'm not sure. I don't think I'm accessing anything that is under
the protection of the rtnl_mutex. If anything, the ageing time is
protected by the "bridge lock", but I don't think there's much of an
issue if I read an unsigned int while not holding it.
