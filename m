Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990A9504EBD
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 12:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiDRKXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 06:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiDRKXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 06:23:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E3FA1A9
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 03:20:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so13697571pjb.1
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 03:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2gwAXdVP06wEmBpG7xATbjmH2Edfpdu5LjFJTpfA/ok=;
        b=NuakTi0d8doP0ON8sCciYZP7bwMAzVPUPLQEQibbt519+/1Pu74XJZ0ZcGZ0VxU4/F
         p/OUN4JLLI58IUj8M9iV1fDMmSBMUdEfQbcjMjQn/y9BX5FcqB3PeI5nAqnsL/ROgVY2
         EPrsyi9Meagm+m8p2W7pNPgS3tfJ3yUgJQ6sLXFNcaAO0KOeYrkLLK920tfTZJ/4p7pD
         n4nV3FQxU6nOH33xS/8JaIkmCymi2tBCDgdS54oGJ6dnSGUt7eBwwkDuaCNqRPShl7qJ
         amvUNxfeKcrlRKrMSRHuFonhyssdDyaVXa4IKJYdMBm0xXwcX5w7BJJVv3gLkiUXHUFf
         x+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2gwAXdVP06wEmBpG7xATbjmH2Edfpdu5LjFJTpfA/ok=;
        b=fhn75GTEGEnSsi0tjGkGCwuUSwDvCxJoWEyjQCq1k5EACfb8u0X8uo+6ucfIq4dmgJ
         F14zw46QQ+NbmoOgaWhXoUEoENEX/GuNJ9lxE4to7KKmJOLHUbnkiJjCYnbQOEbVxmEB
         AZettewuti4snZHvE5A2ljQs/WKi1rLFycqf6xqqtG96IN8wl8plV73GHi4Uw3hCqpV4
         sN/dRk/V2SUdRnXnEAfDkqg44Cm0seWMVKZCk+hLqgZ/1F7WkmJeLdcphxNGvKd9Ey38
         xscxsS1z78Pl5qa9s2C00nridXmISzkoLyAGk3KriXm8Aer7YQRXptwbGPI/5dhvDhXj
         uekA==
X-Gm-Message-State: AOAM531tUipMv3tCovjOzrRxjRPZ1V349GvGwTjjjZiRi9HAxkY02uIT
        6B8iFjBOGz1j+BbSFaAZ4rI=
X-Google-Smtp-Source: ABdhPJwMQPtdXuM/IKy2SqZm3n5KvGjHIZ9zPEssTfCjtkQFzxKpMcTQ8PoBr/5SittyCgLy2NaVmA==
X-Received: by 2002:a17:90a:28a4:b0:1d0:50f0:1e04 with SMTP id f33-20020a17090a28a400b001d050f01e04mr12014637pjd.86.1650277252485;
        Mon, 18 Apr 2022 03:20:52 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090a718600b001d27a7d1715sm4714058pjk.21.2022.04.18.03.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:20:51 -0700 (PDT)
Date:   Mon, 18 Apr 2022 18:20:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <Yl07fecwg6cIWF8w@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20134.1649778941@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 08:55:41AM -0700, Jay Vosburgh wrote:
> >> @@ -136,6 +141,7 @@ static int bond_slave_changelink(struct net_device *bond_dev,
> >>   				 struct nlattr *tb[], struct nlattr *data[],
> >>   				 struct netlink_ext_ack *extack)
> >>   {
> >> +	struct slave *slave = bond_slave_get_rtnl(slave_dev);
> >>   	struct bonding *bond = netdev_priv(bond_dev);
> >>   	struct bond_opt_value newval;
> >>   	int err;
> >> @@ -156,6 +162,12 @@ static int bond_slave_changelink(struct net_device *bond_dev,
> >>   			return err;
> >>   	}
> >>   +	/* No need to bother __bond_opt_set as we only support netlink
> >> config */
> >
> >Not sure this comment is necessary, it doesn't add any value. Also I would
> >recommend using bonding's options management, as it would allow for
> >checking if the value is in a defined range. That might not be
> >particularly useful in this context since it appears +/-INT_MAX is the
> >range.
> 
> 	Agreed, on both the comment and in regards to using the extant
> bonding options management stuff.
> 
> >Also, in the Documentation it is mentioned that this parameter is only
> >used in modes active-backup and balance-alb/tlb. Do we need to send an
> >error message back preventing the modification of this value when not in
> >these modes?
> 
> 	Using the option management stuff would get this for free.

Hi Jav, Jon,

I remembered the reason why I didn't use bond default option management.

It's because the bonding options management only take bond and values. We
need to create an extra string to save the slave name and option values.
Then in bond option setting function we extract the info from the string
and do setting again, like the bond_option_queue_id_set().

I think this is too heavy for just an int value setting for slave.
As we only support netlink for new options. There is no need to handle
string setting via sysfs. For mode checking, we do just do like:

if (!bond_uses_primary(bond))
	return -EACCES;

So why bother the bonding options management? What do you think?
Do you have a easier way to get the slave name in options management?
If yes, I'm happy to use the default option management.

Thanks
Hangbin
> 
> 	-J
> 
> >> +	if (data[IFLA_BOND_SLAVE_PRIO]) {
> >> +		slave->prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
> >> +		bond_select_active_slave(bond);
> >> +	}
> >> +
> >>   	return 0;
