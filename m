Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133786AA5B3
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCCXkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCXkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF06760D7B
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 15:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D1A961941
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 23:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7E3C433D2;
        Fri,  3 Mar 2023 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677886816;
        bh=/l48rVeFT1pfaG+pZGx/Q+r9Lo8IvSGjrxwIDtjZQmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kBFXR/SRPgJDqVTX0IQQXgTRE8i2o1dIO2ri+htpe2Pz+apYvy7rNJ60uykbum9tN
         QsxVTGFEpEXerHl/VM6tD6Q9QmBbXhR3EH2Q9WafTdeRZSWBw79KKT6H5hzN445SCr
         Rc8t0RjL7Ct/o4zXuZt6NAJ4Ta7U+N4xB050tqTwKprWGmnaOSDnIGPGZHiQ1GqR0T
         88YCm2mLMCna4UInYm+3xLhoE0Ji3hmh5+usAhVOfCd6+EWwdbL8vSApO94D9Df16L
         bC1EoZhLt8VFXOhwh9N7EEP9CZ5X4Q/KoRTBnpf9HOwtLd92uTM9pe11bL2HpvtUIX
         EycY5OkFcq7FQ==
Date:   Fri, 3 Mar 2023 15:40:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230303154014.678a8f92@kernel.org>
In-Reply-To: <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
        <20230303102005.442331-1-michael@walle.cc>
        <ZAH0FIrZL9Wf4gvp@lunn.ch>
        <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Mar 2023 14:03:03 +0000 Russell King (Oracle) wrote:
> > 4) Some solution to the default choice if there is no DT property.  
> 
> I thought (4) was what we have been discussing... but the problem
> seems to be that folk want to drill down into the fine detail about
> whether PHY or MAC timestamping is better than the other.

There seems to be no solid heuristic. Maybe it's better to give up 
and force the user to pick (for new drivers)?
