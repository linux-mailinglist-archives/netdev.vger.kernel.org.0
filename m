Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBAE510205
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352410AbiDZPjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352399AbiDZPjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:39:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281EC15831
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j9VAZH5eUvbC9WkY1+q41sBAmz2EBnK0lG2ak2ONIE8=; b=V8TKtus7N7QAWyllMKkFOOWOl4
        cv3T/VOjTWbhJLeHl6h5NGueaBSU4Ot9cyAJnQshE+X1rlQOgG+WS3mI2xTKa8R8MCP6/SPmn2McI
        JMqEzJuFdIRVVLibvD+Dpf9PvfHOCqrrHnFWP6vMESkjh3PwvIbGYbNLI4dqoB81ioJQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njNEp-00HZi0-RL; Tue, 26 Apr 2022 17:36:27 +0200
Date:   Tue, 26 Apr 2022 17:36:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmgRe/oeI52KD3PC@lunn.ch>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <YmeViVZ1XhCBCFLN@nanopsycho>
 <YmflStBQCrzP8E6t@lunn.ch>
 <YmfoXsw+o9LE9dF3@nanopsycho>
 <Ymf3jKNeyuYHzsBC@lunn.ch>
 <Ymf8N19bQYcKJJ1g@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymf8N19bQYcKJJ1g@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 04:05:43PM +0200, Jiri Pirko wrote:
> Tue, Apr 26, 2022 at 03:45:48PM CEST, andrew@lunn.ch wrote:
> >> Well, I got your point. If the HW would be designed in the way the
> >> building blocks are exposed to the host, that would work. However, that
> >> is not the case here, unfortunatelly.
> >
> >I'm with Jakub. It is the uAPI which matters here. It should look the
> >same for a SoC style enterprise router and your discombobulated TOR
> >router. How you talk to the different building blocks is an
> >implementation detail.
> 
> It's not that simple. Take the gearbox for example. You say bunch of
> MDIO registers. ASIC FW has a custom SDK internally that is used to
> talk to the gearbox.
> 
> The flash, you say expose by MTD, but there is no access to it directly
> from host. Can't be done. There are HW design limitations that are
> blocking your concept.

The MTD API and your SDK API are abstractions. You give it a blob of
data and ask it to write it to the storage. Somehow that happens. Does
user space need to know MTD or an SDK is being used? Does user space
care? I would expect the same uAPI for both, here is a firmware blob,
write it to storage. The driver knows if it needs to use the MTD API
or the SDK API, it is all abstracted away in the driver.

	Andrew

