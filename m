Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D24958AF
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiAUD4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiAUD4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:56:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD05C061574;
        Thu, 20 Jan 2022 19:56:44 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n8so7253325plc.3;
        Thu, 20 Jan 2022 19:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jqay1I725FeUvGPiLDlyxk2HmNUUXhWQc6GbtImmv/Q=;
        b=FIVTGVtO5rS2Gp5MdrS7usVFxeoehGr8N7c9ksUZ40dN8XRfywb6jmICdA+M3x02/R
         utE6jOwlIe/TT70UOGiylG+diDLpRDjcW6ojKVaENX4KfD7/HJEZ+s0quDLleTPK7sHZ
         vbsePBXeYc3Ut6affMrpThl4uyyb8Ohc2jppEQFZIc2T1WeWWqomNhzbO1L0Eas84I4/
         z8fE22PwlvE+Lu0u2V28cPZwnPVELSlZI7dSytLJEoB9zsZ/WQLqkf4IcgWOfa2h6Dx+
         UVtiuhWdGsfJ+/wNSYw0lVrCiQhQH+l2C6RdNukgPrAkEwf6A3CfWX+UnCMEGaA69jvV
         tKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jqay1I725FeUvGPiLDlyxk2HmNUUXhWQc6GbtImmv/Q=;
        b=up+FjGfKI1r13h1rLiL7lYUn1ZRG/iLVxOCowym+J9QUv3R+4OX1T+kutBG2fsI0gp
         cmgqhnwmxlyMVdmHGMySEXXGYIMXc07zvF5UpU46ZTntf6fdf4POkfilyTy+y7VeNvBi
         ZtzxLC7UtKdMA0Vt9BuqJBhaO2rYqC2ZMh7oUL56+Qf9i1CzCbwJg0nn3Pp71Dgu9hKW
         r0q9he0yKUpgGJ8fiVh6VCmpYooVevQHRB+MtGrtQniW5n3eTuD1F/OtIkfgHEyQ74UJ
         cHGIAZNl9AFBTbq2FrRJ4rQEiUp+e22sOouJ30cG8LgzKIiuN90a3KAhOuvRGP7J12tk
         Yulw==
X-Gm-Message-State: AOAM530EXao4o/Nq1j4lbLBLeZo6VgGltVhEIVZ1aOzkMoCYV2hwcl5g
        TZ6BsXL7/EshRBfDsl0J6yTfWFOcjzk=
X-Google-Smtp-Source: ABdhPJxlZaCSgO8mQc/efgk7lpe/8JYOkKISpRdZJLqatz3eL9CMkjAkexV8eSYdCJ809cnXFwvDMQ==
X-Received: by 2002:a17:902:bcc1:b0:149:a13f:af62 with SMTP id o1-20020a170902bcc100b00149a13faf62mr2335610pls.147.1642737404134;
        Thu, 20 Jan 2022 19:56:44 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h29sm4512514pfr.156.2022.01.20.19.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 19:56:43 -0800 (PST)
Date:   Fri, 21 Jan 2022 11:56:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH RFC V1 net-next 1/4] net: ethtool: Refactor identical
 get_ts_info implementations.
Message-ID: <Yeou9TKzW1NcBOKW@Laptop-X1>
References: <20220103232555.19791-2-richardcochran@gmail.com>
 <20220120161329.fbniou5kzn2x4rp7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120161329.fbniou5kzn2x4rp7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 04:13:29PM +0000, Vladimir Oltean wrote:
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index b60e22f6394a..f28b88b67b9e 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -5353,23 +5353,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >  				    struct ethtool_ts_info *info)
> >  {
> >  	struct bonding *bond = netdev_priv(bond_dev);
> > -	const struct ethtool_ops *ops;
> >  	struct net_device *real_dev;
> > -	struct phy_device *phydev;
> >  
> >  	rcu_read_lock();
> >  	real_dev = bond_option_active_slave_get_rcu(bond);
> >  	rcu_read_unlock();
> 
> Side note: I'm a bit confused about this rcu_read_lock() ->
> rcu_dereference_protected() -> rcu_read_unlock() pattern, and use of the
> real_dev outside the RCU critical section. Isn't ->get_ts_info()
> protected by the rtnl_mutex? Shouldn't there be a
> bond_option_active_slave_get() which uses rtnl_dereference()?
> I see the code has been recently added by Hangbin Liu.

Hi Vladimir,

Yes, it should be enough to use rtnl_dereference() since ->get_ts_info is
protected by the rtnl_lock. I just thought there is an existing get active
slave function and rcu read should be OK to be used here. So I just used the
existing one.

Hi Jay,

Do you think if there is a need to add a rtnl version of
bond_option_active_slave_get()?

Thanks
Hangbin
