Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CC6E71DF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 05:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjDSDvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 23:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjDSDvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 23:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393F5BB9E
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 20:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D67462F8B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D95C433EF;
        Wed, 19 Apr 2023 03:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681876224;
        bh=a0csmOkPCahehCfVX/g1jfAYHj7ji/i3zkDii2XJY38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mi59o02n/hNTXXFraRb2XVVJVQMvqqr8JUlnvAYN5o+PLg82DQ+OQTDEHJTS8DukK
         LpetHgQ5ygv9OSLtx2nRRRE61aC/mvrdkutWhqzxaA8rRL3MRb7x5QNSWInWdP8Yfc
         +mQTWJNWsUYBtEntqWu4IsbydiXxt7zvmTigFmp3inbjLpHAsOg9sV5pzwBJzBm0Wu
         OMDHIhxO/7xWm8OFX1NYcvQy7ea43FrYSJih4V/JE9YPAD000ivkLIv0RJ7udIj6s+
         4GFKbl9YQmClPsuXzKO796lRWiuthPbwhJ4lgFzNYHmaigBNQQPAEkvv6OByWQ7Udd
         BFtH0A7p+/EJw==
Date:   Tue, 18 Apr 2023 20:50:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230418205023.414275ab@kernel.org>
In-Reply-To: <20230418034841.2566262-1-liuhangbin@gmail.com>
References: <20230418034841.2566262-1-liuhangbin@gmail.com>
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

On Tue, 18 Apr 2023 11:48:41 +0800 Hangbin Liu wrote:
> Currently, bonding only obtain the timestamp (ts) information of
> the active slave, which is available only for modes 1, 5, and 6.
> For other modes, bonding only has software rx timestamping support.
> 
> However, some users who use modes such as LACP also want tx timestamp
> support. To address this issue, let's check the ts information of each
> slave. If all slaves support tx timestamping, we can enable tx
> timestamping support for the bond.
> 
> Add a note that the get_ts_info may be called with RCU, or rtnl or
> reference on the device in ethtool.h>
> 
> Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v5: remove ASSERT_RTNL since bond_ethtool_get_ts_info could be called
>     without RTNL. Update ethtool kdoc.

I'll apply Jay's ack from v4 since these are not substantial changes.
Thanks!
