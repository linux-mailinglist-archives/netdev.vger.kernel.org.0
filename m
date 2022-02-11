Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079B84B29C7
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343717AbiBKQIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:08:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbiBKQIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:08:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C334188
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 08:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SDZCJ/Tk4EdLDb2m8uhU973oSZ/c2B8EcK0kGWKL+d4=; b=sQY+D46tx+NjPDiLzBBjQvds3r
        9mwkuETBfwCbkdkDtMxwUlX36/hATDo/bQ7fbVgAVHci/tAqa0s+S6nIIo2p7h8ZSoDt+hTSw3Lb/
        yrgc4RoC3nHhFwLi72ExzJAgOGDo0vl+CANe2nh7NW1sxEQR7k8oJz/feM+FGvILKqM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIYTZ-005UO9-97; Fri, 11 Feb 2022 17:08:49 +0100
Date:   Fri, 11 Feb 2022 17:08:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <YgaKEd0szVNnMzGm@lunn.ch>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf>
 <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
 <87h795dbnm.fsf@nvidia.com>
 <20220211152901.inmg5klgb6pryms7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211152901.inmg5klgb6pryms7@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Now I don't understand DSA at all, but given a chip with fancy defaults,
> > for the DCB interface in particular, it would make sense to me to have
> > two ops. As long as there are default-prio entries, a "set default
> > priority" op would get invoked with the highest configured default
> > priority. When the last entry disappears, an "unset" op would be called.
> 
> I don't understand this comment, sorry. I don't know what's a "chip with
> fancy defaults".

I think this is the point i just razed in my other reply. The hardware
starts with a preconfigured QoS profile. My guess would be, a Top Of
Rack defaults to all QoS features turned off, you need to turn them
off as appropriate for the use case. Typically, a SOHO switch is not
configured, it is just put in the corner and turned on. So having some
sensible defaults for a home/office makes sense. When it is used in
some other embedded use case, it probably is going to get configured
for that use cases.

So 'fancy defaults' == preconfigured QoS profile in the hardware.

    Andrew
