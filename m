Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E76E3CBC
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDPXIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 19:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDPXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 19:08:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D752108
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 16:08:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p17so12620200pla.3
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 16:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681686490; x=1684278490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RT0tuZZilKuzj7md7XFaZUJKFbSDRsiyEtzr0wYj6ZM=;
        b=Ql5ciPSoQkd5BX+3HcLCToFULpxVrcQiHPq/7c6MaOgeCDLWaItuIdXoEODL9uiiGV
         YR4K8EXjDRwxRO+eiXg3TzGFWnFUvrDsUUmbOCrf4IdEzG0OJfGwN4RTUSxcMR5gCfZn
         j9WwPmDArFGjcWhGHJn+/Y2Ul/Jx/MK+kE4QawPQEynDFIMei03gJ6J2KpXCFjzSoWya
         blModjTPQWx+43X/Akmn7axT6twT86dxHen/jKLRvzNkOBIoQcfWcoFKfB+Lr+MPj2Vg
         UPLaHidSpVWl6xhR6yeO0ezVBB/malku8yd7J39uQAfeSZ9kV28vQM+G0ljQBg/3w1rg
         33yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681686490; x=1684278490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RT0tuZZilKuzj7md7XFaZUJKFbSDRsiyEtzr0wYj6ZM=;
        b=Zx80RmjBiWiMB/PpzN3fnKg7IVY25JRa94eoMoJ6/aJ1IMDF4klVVQz/uR7JGVoIzi
         AbsERSNAdC04Wglt6z+OHGgsQETpLnVGbL4aTVXPsuc57J1YEZcXKLKCpgqrrdXoVjoo
         mAtK2wn+1FbCDJr0mPeaw+CLuzCkM2vdxIiBNKAwhhrIqtKzm2J2PgaBB9JldGA8rINj
         bnBsQ7MVVI0KVLF41660jWpa7kLu5SQwz6E8uMXvZAxh0HokFF1disKNexWbAszQOHvT
         CRra0YaL7D5AhfOSbTtf91zQJHHs6ehJycm7maeHVWPz4kqQvBQ9AOQvvP1E78FDcArE
         yzCQ==
X-Gm-Message-State: AAQBX9eGkAq+nHfAHeeaBLLaPMGvmu40Jx3JUfb0r3OMAzyo+e9I2I+S
        HNEiucqcdv9eacZB2L9eoJM=
X-Google-Smtp-Source: AKy350aoLS1bCRI8o78VYiPTj1BgkiTbUQpfKzhvqZD6VP4HuINAXVW94cVsTQOQAhIzl9SxLOqUOg==
X-Received: by 2002:a17:902:c408:b0:19e:baa6:5860 with SMTP id k8-20020a170902c40800b0019ebaa65860mr13044264plk.2.1681686490492;
        Sun, 16 Apr 2023 16:08:10 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jj6-20020a170903048600b001a5059861adsm6369314plb.224.2023.04.16.16.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 16:08:09 -0700 (PDT)
Date:   Mon, 17 Apr 2023 07:08:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping support
Message-ID: <ZDx/01XAwCNJCNeq@Laptop-X1>
References: <20230414083526.1984362-1-liuhangbin@gmail.com>
 <20230414180205.1220135d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414180205.1220135d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 06:02:05PM -0700, Jakub Kicinski wrote:
> On Fri, 14 Apr 2023 16:35:26 +0800 Hangbin Liu wrote:
> > v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
> >     RTNL. Only check _TX_SOFTWARE for the slaves.
> 
> > +	ASSERT_RTNL();
> > +
> >  	rcu_read_lock();
> >  	real_dev = bond_option_active_slave_get_rcu(bond);
> >  	dev_hold(real_dev);
> > @@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >  			ret = ops->get_ts_info(real_dev, info);
> >  			goto out;
> >  		}
> > +	} else {
> > +		/* Check if all slaves support software tx timestamping */
> > +		rcu_read_lock();
> > +		bond_for_each_slave_rcu(bond, slave, iter) {
> 
> > +			ret = -1;
> > +			ops = slave->dev->ethtool_ops;
> > +			phydev = slave->dev->phydev;
> > +
> > +			if (phy_has_tsinfo(phydev))
> > +				ret = phy_ts_info(phydev, &ts_info);
> > +			else if (ops->get_ts_info)
> > +				ret = ops->get_ts_info(slave->dev, &ts_info);
> 
> My comment about this path being under rtnl was to point out that we
> don't need the RCU protection to iterate over the slaves. This is 
> a bit of a guess, I don't know bonding, but can we not use
> bond_for_each_slave() ?

Sorry, I misunderstood your comment in patchv3. I thought you agreed to use
the same use case like rlb_next_rx_slave(). I will post a new fix version.

> 
> As a general rule we should let all driver callbacks sleep. Drivers 
> may need to consult the FW or read something over a slow asynchronous
> bus which requires process / non-atomic context. RCU lock puts us in 
> an atomic context. And ->get_ts_info() is a driver callback.
> 
> It's not a deal breaker if we can't avoid RCU, but if we can - we should
> let the drivers sleep. Sorry if I wasn't very clear previously.

Thanks for the explanation.

Regards
Hangbin
