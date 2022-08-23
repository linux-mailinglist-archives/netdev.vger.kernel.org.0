Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264A759EE91
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiHWWBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiHWWBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E965D0F7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 236BB61610
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152ABC433D6;
        Tue, 23 Aug 2022 22:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661292074;
        bh=13KkCImYPGO1gwY0tC1HOuvodh81OFdQBrAgXq/D+pI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rU+rvOvH78/4IzB5H5WlufNlZI5hipMeLQNMganD7Wk8CS36qRsKtVb0Qm8RPdp2s
         1KMLDkPHH2T/7MmkIGtiChb/sx3EL8liJoVXcHs8JY9diVsoe1XCy9lloy0OWY5FOt
         3Aim1PDu4WYCjL7ZUK/vis7bBgykrEL1rIMpIlH5mdKM99ypDwHRmZB22ZQX0M0MhJ
         ewa1OHUEMD8k6n7XZgEDW2lT88U7SmO0PN8ZjbguzWj5Wah6v18MT7BjYY0mUB6JJz
         tM7O9g9e9DaYeEejWRyFYr/fyUO6h5789uIHq7arK7Dx8p6GvhKXUq/xP2wL3eW4Lg
         UogYweEIBj+uQ==
Date:   Tue, 23 Aug 2022 15:01:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable
 and keep it off while standalone
Message-ID: <20220823150113.22616755@kernel.org>
In-Reply-To: <20220823214253.wbzjdxgforuryxqp@skbuf>
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
        <20220823143831.2b98886b@kernel.org>
        <20220823214253.wbzjdxgforuryxqp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 00:42:53 +0300 Vladimir Oltean wrote:
> On Tue, Aug 23, 2022 at 02:38:31PM -0700, Jakub Kicinski wrote:
> > > @maintainers: when should I submit the backports to "stable", for older
> > > trees?  
> > 
> > "when" as is how long after Thu PR or "when" as in under what
> > conditions?  
> 
> how long after the "net" pull request, yes.
> I'm a bit confused as to how patches from "net" reach the stable queue.
> If they do get there, I'm pretty confident that Greg or Sasha will send
> out an email about patches failing to apply to this and that stable
> branch, and I can reply to those with backports.

Adding Greg, cause I should probably know but I don't. 

My understanding is that Greg and Sasha scan Linus's tree periodically
and everything with a Fixes tag is pretty much guaranteed to be
selected. Whether that's a hard guarantee IDK. Would be neat if it was
so we don't have to add the CC: stable lines.

Also not sure if it's preferred to wait for the failure notification 
or you should pre-queue the backport as soon as it reaches Linus.
I vague recall someone saying to wait for the notification...
