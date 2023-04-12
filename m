Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249EF6DF534
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDLM2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDLM2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:28:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B257DA0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:28:15 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mn5-20020a17090b188500b00246eddf34f6so3619306pjb.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681302495; x=1683894495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SOQfdthChsRC8OgxisEpt9iSnRcbWfqQq6X3cBEOC8Q=;
        b=HsDRkLoYfPb7Mn+8V68CGhjmuMwr/Nd+t14gv2PKq5OiVd+n/O81cf0/HHr8YgJ3xt
         EXoZftBsQpg1uQP83998mf/nwSDwRRgLQC5oJ7i7+OM5t7lLnxrlea8YBHWuogvXYsVU
         lI1aes8CXxL3Ea534jj1cKXigcZBk2osL0DaLeqP0fL0gojCuSDUnFD3STM+NxY2SiAA
         jVC/AUjFrsrl8FUPIH+GAJ/5QX5lN9/OF9URZ3WjVpTU8CjRBKWv0kQ1QBmE4G5z4xR3
         fYMGnhq3O7bgDyOKtQOGJg/WQvFtvrrwBAa8WZAqLIUENBBRiQoYd/h9b4Zr/zidfUZZ
         rheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681302495; x=1683894495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOQfdthChsRC8OgxisEpt9iSnRcbWfqQq6X3cBEOC8Q=;
        b=7Q4aFyyHFHArm4YMDoUuQBI6xO/j3K2HViOKEr5W88teVCg8yHcAFWxLNhS1GuuTPd
         uGfpA6oZ79BH+QTS8zt4O9UUROx/RS0wkrwbz2bZtdbO6CYp7n7W218iGf0LrQuz3XyI
         ys9A3chdY/semdj+GbJM54zsUQKKtKn5sERQyoRxrZV48TLMx4GXMIseJ2iYBSkE8lwX
         aCRJNl4xUNgdV7h4eKTFZzSiHVbv7XEJbllwn/RRx4cnkI58qdp2NLXeylgjmQv6Xger
         qULoFDKUREucsxdu6P6fs6QOQQtjEQcVftVgDrEu+eh9QDSZlIlKy8h2bCoS9XNbdFpy
         XZwQ==
X-Gm-Message-State: AAQBX9cvT7CbjfRuSbDgtSJVkZbOvWxGMYSbcIwQ/M0F+F0W+tGvd1BA
        b71bU0wcdX6dZCrKRHAx6NM=
X-Google-Smtp-Source: AKy350a+ox0gktCrB/lqKKcVNBUtXmfjMAkFw75bAqs9RIpVzz0YYjsMmz6R+LbOZiOVASW9IYpumg==
X-Received: by 2002:a17:902:db12:b0:1a2:afdd:8476 with SMTP id m18-20020a170902db1200b001a2afdd8476mr24060767plx.2.1681302494566;
        Wed, 12 Apr 2023 05:28:14 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7826:7100:99c4:7575:f7e2:a105])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902b18600b001a64ce7b18dsm4317166plr.165.2023.04.12.05.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 05:28:13 -0700 (PDT)
Date:   Wed, 12 Apr 2023 20:28:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv3 net-next] bonding: add software tx timestamping support
Message-ID: <ZDaj2J/2CR03H/Od@Laptop-X1>
References: <20230410082351.1176466-1-liuhangbin@gmail.com>
 <20230411213018.0b5b37ec@kernel.org>
 <32194.1681281203@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32194.1681281203@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 11:33:23PM -0700, Jay Vosburgh wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> >On Mon, 10 Apr 2023 16:23:51 +0800 Hangbin Liu wrote:
> >> @@ -5707,10 +5711,38 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >>  			ret = ops->get_ts_info(real_dev, info);
> >>  			goto out;
> >>  		}
> >> +	} else {
> >> +		/* Check if all slaves support software rx/tx timestamping */
> >> +		rcu_read_lock();
> >> +		bond_for_each_slave_rcu(bond, slave, iter) {
> >> +			ret = -1;
> >> +			ops = slave->dev->ethtool_ops;
> >> +			phydev = slave->dev->phydev;
> >> +
> >> +			if (phy_has_tsinfo(phydev))
> >> +				ret = phy_ts_info(phydev, &ts_info);
> >> +			else if (ops->get_ts_info)
> >> +				ret = ops->get_ts_info(slave->dev, &ts_info);
> >
> >Do we _really_ need to hold RCU lock over this?
> >Imposing atomic context restrictions on driver callbacks should not be
> >taken lightly. I'm 75% sure .ethtool_get_ts_info can only be called
> >under rtnl lock off the top of my head, is that not the case?
> 
> 	Ok, maybe I didn't look at that carefully enough, and now that I
> do, it's really complicated.
> 
> 	Going through it, I think the call path that's relevant is
> taprio_change -> taprio_parse_clockid -> ethtool_ops->get_ts_info.
> taprio_change is Qdisc_ops.change function, and tc_modify_qdisc should
> come in with RTNL held.
> 
> 	If I'm reading cscope right, the other possible caller of
> Qdisc_ops.change is fifo_set_limit, and it looks like that function is
> only called by functions that are themselves Qdisc_ops.change functions
> (red_change -> __red_change, sfb_change, tbf_change) or Qdisc_ops.init
> functions (red_init -> __red_change, sfb_init, tbf_init).
> 
> 	There's also a qdisc_create_dflt -> Qdisc_ops.init call path,
> but I don't know if literally all calls to qdisc_create_dflt hold RTNL.
> 
> 	There's a lot of them, and I'm not sure how many of those could
> ever end up calling into taprio_change (if, say, a taprio qdisc is
> attached within another qdisc).
> 
> 	qdisc_create also calls Qdisc_ops.init, but that one seems to
> clearly expect to enter with RTNL.
> 
> 	Any tc expert able to state for sure whether it's possible to
> get into any of the above without RTNL?  I suspect it isn't, but I'm not
> 100% sure either.

You dug more than me. Maybe we can add an ASSERT_RTNL() checking here first?
But since we can't 100% sure we are holding the rtnl lock, I think we
can keep the rcu lock for safe. I saw rlb_next_rx_slave() also did the same...

> 
> 
> >> +			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) ==
> >> +				    SOF_TIMESTAMPING_SOFTRXTX) {
> >
> >You could check in this loop if TX is supported...
> 
> 	I see your point below about not wanting to create
> SOFT_TIMESTAMPING_SOFTRXTX, but doesn't the logic need to test all three
> of the flags _TX_SOFTWARE, _RX_SOFTWARE, and _SOFTWARE?

I think Jakub means we have already add _RX_SOFTWARE and _SOFTWARE for bonding
whatever slave's flag, then we just need to check slave's _TX_SOFTWARE flag.

Thanks
Hangbin
