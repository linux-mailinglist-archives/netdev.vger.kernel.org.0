Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61F060EAE1
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiJZVeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 17:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiJZVdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:33:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DC4149DC5;
        Wed, 26 Oct 2022 14:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8dhh8ch0xap5ZeZVggnI6sA242VonLDpQCZRZx8JO74=; b=blMt6gL2McMQLAIs6kPAN1Mc0p
        HVHyy6PcRc/mIH7kg9zl4UYGasekN8WMOLtQixxBoYmzGlhx6F8Vmu8daHpnvVHLLtGzuWCvqoOIh
        J1vOLfivTAkuvC4+7WsZ+q4MMtH2GEzDpcIw6rHk3fK237Ne1Ic8zENDVckZmbzQIgBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ono0M-000ekO-W2; Wed, 26 Oct 2022 23:32:06 +0200
Date:   Wed, 26 Oct 2022 23:32:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, corbet@lwn.net,
        michael.chan@broadcom.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y1mnVsB883dKWa4a@lunn.ch>
References: <20221026020948.1913777-1-kuba@kernel.org>
 <Y1klvBsXfEXd4y8M@lunn.ch>
 <20221026091015.643b3e8f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026091015.643b3e8f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 09:10:15AM -0700, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 14:19:08 +0200 Andrew Lunn wrote:
> > You might want to consider a generic implementation in phylib.
> 
> Would bumping a counter in phy_link_down() be suitable?

Yes, that seems reasonable.

> I'm slightly unsure about the cable test behavior but 
> I think increments during cable tests are quite fair.

Me too. The interface is not usable, and the link will do an auto-neg
once the cable test is finished. So it does seem reasonable to count
such events.

> > You should then have over 60 drivers implementing this, enough
> > momentum it might actually get used.
> 
> Depends on your definition of "get used", I can guarantee it will 
> get used according to my definition :)

We have too many features which only one driver implements. So yes,
you might use it, with one driver. But will it get used by others?  If
it magically starts working for more than 1/2 the kernel drivers, it
seems much more likely it will find more widespread us.

     Andrew
