Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153126E3CEA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 02:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDQARu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 20:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDQARt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 20:17:49 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB7B1FEE
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 17:17:47 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5c4c769aso1147114b3a.3
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 17:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681690667; x=1684282667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=teiQI8eNPAQlmHlvUwumQNaZZIXxgvb6IeHUFkLejts=;
        b=IR45T4m6vViBe6yUJXurpyKiKVwdKemxPIJBfjCB0XCtyooXvC8j3Wa0hhR3ku9EmR
         Q6jwz3Wf/7N2qlCWfWs6GwgAJH6CfUNqOuWyTOY/UUu1fXjd8Mk7dkocOIhm3uwOcv0H
         OgDUKfFYlnk1eJOTntGm1CqB/Fu24iQK3h+BmUZw9cztOzM37dME+Au5xTmRvhVs/LoK
         nGEkFv0wxGtGRO6ipHiQ4OeDLlT7ujrV3YqZok7pezUhPI44LGRLT3+7ZjxnLjFuo+xi
         noKgoJk+DQgcVB/n8/xs/8yyJcrabq6qFERUvVPTccFraWu++2nmTpLgAPBiyLNAQDlC
         nKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681690667; x=1684282667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teiQI8eNPAQlmHlvUwumQNaZZIXxgvb6IeHUFkLejts=;
        b=I+0LGIjWDCWwzS7wJlJ1khSx/X2vE6vEX9JhS1fAUC1Cf5H2T8HhXArHXgShPCoSGw
         q+L71OkDwq6Zp1ho2S7HYggKxWYYee48odcWcX+oIun9UDB7wPb0FdH4ShUHS7BxmV1c
         n+3n6hUPWpxxv2Xfyn6e7g/s8BBYQmLP/cT85fIi0RkjDXw0Wkd3ws6TesW/WHzqIYC3
         FSdlKUBOXUqvHEbj4cTzkdThE9o0TNHkzMFqe8BPbnVY0V1gALhwUwIKOI3RbImdftvr
         G4CRmnPW+7AARWu7hLb/woNrZQX8pwjBYIcLogCTFcaWMqe9kHxh486EM3gVZ094pd8C
         VtWg==
X-Gm-Message-State: AAQBX9f6i9W0NZQ3cW4Q7EIB0XTAsEzWCCNjY0meXTQXNcas0LJsej9z
        rJs+IM/WIBPlStb5mFlNacc=
X-Google-Smtp-Source: AKy350Yto+idQpmpGPjy0rRb5alg9l8hCSaW8j4Pol7LISXkbYV95RTlrd8mT8Miv2CtEWDxAddTPw==
X-Received: by 2002:a05:6a00:84d:b0:63b:84a4:7b0 with SMTP id q13-20020a056a00084d00b0063b84a407b0mr6945306pfk.30.1681690667298;
        Sun, 16 Apr 2023 17:17:47 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16-20020aa79210000000b00594235980e4sm6358749pfo.181.2023.04.16.17.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 17:17:46 -0700 (PDT)
Date:   Mon, 17 Apr 2023 08:17:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping support
Message-ID: <ZDyQIwhC6Bu05VLf@Laptop-X1>
References: <20230414083526.1984362-1-liuhangbin@gmail.com>
 <20230414180205.1220135d@kernel.org>
 <6105.1681530194@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6105.1681530194@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 08:43:14PM -0700, Jay Vosburgh wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> >On Fri, 14 Apr 2023 16:35:26 +0800 Hangbin Liu wrote:
> >> v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
> >>     RTNL. Only check _TX_SOFTWARE for the slaves.
> >
> >> +	ASSERT_RTNL();
> >> +
> >>  	rcu_read_lock();
> >>  	real_dev = bond_option_active_slave_get_rcu(bond);
> >>  	dev_hold(real_dev);
> >> @@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >>  			ret = ops->get_ts_info(real_dev, info);
> >>  			goto out;
> >>  		}
> >> +	} else {
> >> +		/* Check if all slaves support software tx timestamping */
> >> +		rcu_read_lock();
> >> +		bond_for_each_slave_rcu(bond, slave, iter) {
> >
> >> +			ret = -1;
> >> +			ops = slave->dev->ethtool_ops;
> >> +			phydev = slave->dev->phydev;
> >> +
> >> +			if (phy_has_tsinfo(phydev))
> >> +				ret = phy_ts_info(phydev, &ts_info);
> >> +			else if (ops->get_ts_info)
> >> +				ret = ops->get_ts_info(slave->dev, &ts_info);
> >
> >My comment about this path being under rtnl was to point out that we
> >don't need the RCU protection to iterate over the slaves. This is 
> >a bit of a guess, I don't know bonding, but can we not use
> >bond_for_each_slave() ?
> 
> 	Ah, I missed that nuance.  And, yes, you're correct,
> bond_for_each_slave() works with RTNL and we don't need RCU here if RTNL
> is held.

Hi Jay, Jakub,

I remember why I use bond_for_each_slave_rcu() here now. In commit
9b80ccda233f ("bonding: fix missed rcu protection"), I added the
rcu_read_lock() as syzbot reported[1] the following path doesn't hold
rtnl lock.
- sock_setsockopt
  - sock_set_timestamping
    - sock_timestamping_bind_phc
      - ethtool_get_phc_vclocks
        - __ethtool_get_ts_info
	  - bond_ethtool_get_ts_info

[1] https://lore.kernel.org/netdev/20220513084819.zrg4ssnw667rhndt@skbuf/T/

Thanks
Hangbin
