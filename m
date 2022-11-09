Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA10622B00
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKIL4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKIL4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:56:31 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA41EEF8
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:56:30 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 278145C00BB;
        Wed,  9 Nov 2022 06:56:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 09 Nov 2022 06:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667994990; x=1668081390; bh=jWsWzm7xiwDdFEGIz2JVkFKAPw0H
        dsQ7LP1LFo0fHh0=; b=pPjzkjK90N44gCTCeWTvtaRdhNOw6sYd4Sbj0tXYez5m
        fQ6sJ0/6T+3xtGUB2WacS/SffCSEOlcgxwE2/6s/CaKyrmCFUWbvsczxfeHis3VM
        RBHY1vZgPFxjIhj+gSTZar2qzEolW4JJIQkt6d/vl54wa5ZQwhcnpm4JKD4Ko2xh
        Q6B4wEZ4WWgUjZEPVtax9v459dzyEtsGVrXDdSIuGby+iCl56zmOkP7HA3i6SUqf
        kEBvCWHVsT3J1+kquM3EALAIweZ6hKmULhTjXbovBqWF5qZ4Owyzu3ZNl9Fw5Cdd
        f3bWp/6Yuz5x9ioUuw5mRUMy3EuK6sSee4czER0JNQ==
X-ME-Sender: <xms:bZVrYw-dlIdpdtDfevx8mvLqfI9Nz07pGSeJqVSlvHtf4EhIq5xjPA>
    <xme:bZVrY4t1LFPYYIdWikme1PuOLeBr6z33ATxVOHnCOPVX4CJvGlgrAOEI-DATVep0n
    01s_WP4GN8nIBg>
X-ME-Received: <xmr:bZVrY2BGDTlSMA9DXvPQG3kRRouQAgeAPfPYK2WWPWhSgzD6_Qf2ImTXY04T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bZVrYwejRJ1irJifh0PMyJ0CPrdCHpXyJC6ReImY_rU-HK0m9PmXrw>
    <xmx:bZVrY1N4aTl3BcDEfx5_5VX4eH-py5rORs_pgsX72-WkC1Eflla69w>
    <xmx:bZVrY6lpbZvmSaxhp2q5LXOohKO-UaIy4yfWMgRksYfzN4zhstOpmA>
    <xmx:bpVrY4d4mswrkgoZFBvSATyp0DmpawTXnxVmX2dQ491PT7kWerBS9g>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 06:56:28 -0500 (EST)
Date:   Wed, 9 Nov 2022 13:56:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next v2 1/3] net: introduce a helper to move notifier
 block to different namespace
Message-ID: <Y2uVawK4hLEu0X0G@shredder>
References: <20221108132208.938676-1-jiri@resnulli.us>
 <20221108132208.938676-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108132208.938676-2-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 02:22:06PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently, net_dev() netdev notifier variant follows the netdev with
> per-net notifier from namespace to namespace. This is implemented
> by move_netdevice_notifiers_dev_net() helper.
> 
> For devlink it is needed to re-register per-net notifier during
> devlink reload. Introduce a new helper called
> move_netdevice_notifier_net() and share the unregister/register code
> with existing move_netdevice_notifiers_dev_net() helper.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

I'm not sure what is net_dev(), but the code looks fine:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
