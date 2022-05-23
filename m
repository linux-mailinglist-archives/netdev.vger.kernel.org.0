Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B850A531985
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbiEWS1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbiEWS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FE638D83
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1202B614C2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 17:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208A5C341DE;
        Mon, 23 May 2022 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653328732;
        bh=KXCC8IaDurI6U1NFyXpYULJsDt6zjB7jND29xlcCDfY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o10eZvTXKlX7+xUVB3alNlQbfFQscx4zel5vJwhZBeDwMeJG76V03VxKUmyRVSDwl
         nmLbGWsXS0bA8f9Kph9DwyIEOj/GuAqOHSAy0H7B40bmR7jwXxlvSMcIWNqc4KHg/H
         m2ePf1DkJNgs5XMjJvJZMCyVoz+OgnD1ApbeuaqWn/XBMv+KxdnLUwhQ/7LtwO7pzo
         NRVbUQgmrnU0YcdGpcZu9JCbbtUd6NTbiMmk2bYn3wkR0WLjJ+AHf5BsrO4TXaN2cG
         KXDKDX7w8iFIJHpgFwGoMFmBcebIYoX0Bt1p7bFg0CMr/xcbAwIPIIkEI+CjFJXkj9
         NqSGG3y3azmIg==
Date:   Mon, 23 May 2022 10:58:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kolacinski, Karol" <karol.kolacinski@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Message-ID: <20220523105850.606a75c1@kernel.org>
In-Reply-To: <MW4PR11MB58005F4C9EFF1DF1541A421C86D49@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
        <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
        <20220518215723.28383e8e@kernel.org>
        <MW4PR11MB58005F4C9EFF1DF1541A421C86D49@MW4PR11MB5800.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 16:56:44 +0000 Kolacinski, Karol wrote:
> On Thu, 19 May 2022 06:57 +0200 Jakub Kicinski wrote:
> > > Create a second read-only TTY device.  
> > 
> > Can you say more about how the TTY devices are discovered, and why there
> > are two of them? Would be great if that info was present under
> > Documentation/  
> 
> Both TTY devices are used for the same GNSS module. First one is
> read/write and the second one is read only. They are discovered by
> checking ICE_E810T_P0_GNSS_PRSNT_N bit in ICE_PCA9575_P0_IN register.
> This means that the GNSS module is physically present on the PCB.
> The design with one RW and one RO TTY device was requested by
> customers.

I meant discovered at the uAPI level. Imagine I plug in a shiny E810T
with a GNSS receiver into a box, the PRSNT_N bit is set and the driver
registered the ttys. How do I find the GNSS under /dev ?
