Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4654E4005
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiCVOFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiCVOFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:05:07 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3667F28E18;
        Tue, 22 Mar 2022 07:03:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q20so11142429wmq.1;
        Tue, 22 Mar 2022 07:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DQUpDcO12g6db/kIyfK1e6Kw7nHTfYujQgXltpRkSFg=;
        b=b4VE+ctl/VdCK8r8GNkoEiUh67I4El8WBG1Qr8LQ5BKq08m0SH+7NXsyOIFQ4ZB9+k
         JfBwYqGbcu6YfuWw81vuKXOl8owPF41CpTgRiQTECPL0lHbGnhfHBncXPt6TTUyzjCiY
         kEwp7ai+DImZaALiDbnyk5IT3qp+al6/uE1JKFNb9GvxMStkZLWnTWP+jsQluoItYfhm
         VlYdAP5FgluAtUVPj8zGqZUhiSWdUCX9ka9Oy9dQ4nvBap8CmRiqGAVIoSsJt2HNBK1W
         gYJIViLHxQpaN6yoPY7etHkF6+0rE9w4lEvGZPb3VbqSIp7r7tzwn0ISjlGFtP6iDIzX
         5/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DQUpDcO12g6db/kIyfK1e6Kw7nHTfYujQgXltpRkSFg=;
        b=JlGLun6+IZ3GKwEVpabVXtHED9ZWB2NJ+3nH5tinhF52YNc/iZnvt2cBAmapxCu6Vx
         7zVhqztMXaiaUAvGJVPV4EixuToNN8Kp3AI5HFI97KNwxtqAXt3i3B47X5eJg4CB20CP
         OK+3wD7kKX/42v+YnqfzYv0Dkn2BnFD8hrBt+3wyXsuJiA6zHv9Vjs7nj0f6icbHQYT2
         8l0YE13j8egt1WbmdvxZFLAZAJltN6x/Q8mN8qn5agEtsVbjQTXVKCRjqYbCQ/+cli5X
         I+MJE6rTKPFhJUNfzHnH0YsNUOEPbHPpVBoSbtU/fiLWK4eVNau2jdkmX3reYEZ8HHox
         qYKQ==
X-Gm-Message-State: AOAM533uIBOtzfKaTo6znW8jddkjrvEjqBSCaoEEr18BkYCuUGPxycPU
        k+lCsL2U2SN2q9sfZVlyxqarFuIAB2w=
X-Google-Smtp-Source: ABdhPJx+dEB7Kldsy3nrHqIk9ZQ5WR9/Z69fkNaw5lO7GbEDXo88WrxKztsIZXfPpj6WES2znjULtw==
X-Received: by 2002:a7b:cc12:0:b0:37c:1ae:100a with SMTP id f18-20020a7bcc12000000b0037c01ae100amr3849605wmh.54.1647957817479;
        Tue, 22 Mar 2022 07:03:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id r14-20020a7bc08e000000b0038ca55f9bcasm1887910wmh.42.2022.03.22.07.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:03:37 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:03:36 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322135535.au5d2n7hcu4mfdxr@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 03:55:35PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 22, 2022 at 02:38:08PM +0100, Ansuel Smith wrote:
> > On Tue, Mar 22, 2022 at 01:58:12PM +0200, Vladimir Oltean wrote:
> > > On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> > > > Drop the MTU array from qca8k_priv and use slave net dev to get the max
> > > > MTU across all user port. CPU port can be skipped as DSA already make
> > > > sure CPU port are set to the max MTU across all ports.
> > > > 
> > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > ---
> > > 
> > > I hardly find this to be an improvement and I would rather not see such
> > > unjustified complexity in a device driver. What are the concrete
> > > benefits, size wise?
> > >
> > 
> > The main idea here is, if the value is already present and accessible,
> > why should we duplicate it? Tracking the MTU in this custom way already
> > caused some bugs (check the comment i'm removing). We both use standard
> > way to track ports MTU and we save some additional space. At the cost of
> > 2 additional checks are are not that much of a problem.
> 
> Where is the bug?
>

There was a bug where we tracked the MTU with the FCS and L2 added and
then in the change_mtu code we added another time the FCS and L2 header
just because we used this custom way and nobody notice that we were adding
2 times the same headers. (it's now fixed but still it's a reason why
using standard way to track MTU would have prevented that)

> > Also from this I discovered that (at least on ipq806x that use stmmac)
> > when master needs to change MTU, stmmac complains that the interface is
> > up and it must be put down. Wonder if that's common across other drivers
> > or it's only specific to stmmac.
> 
> I never had the pleasure of dealing with such DSA masters. I wonder why
> can't stmmac_change_mtu() check if netif_running(), call dev_close and
> set a bool, and at the end, if the bool was set, call dev_open back?

Oh ok so it's not standard that stmmac_change_mtu() just refuse to
change the MTU instead of put the interface down, change MTU and reopen
it... Fun stuff...

From system side to change MTU to a new value (so lower MTU on any port
or set MTU to a higher value for one pot) I have to:
1. ifconfig eth0 down
2. ifconfig lan1 mtu 1600 up
3. ifconfig eth up

If I just ifconfig lan1 mtu 1600 up it's just rejected with stmmac
complaining.

-- 
	Ansuel
