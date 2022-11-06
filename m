Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0504C61E1FA
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiKFMEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 07:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiKFMEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 07:04:43 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861ABE0D1
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 04:04:39 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id BC34B1883857;
        Sun,  6 Nov 2022 12:04:36 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id B5A582500015;
        Sun,  6 Nov 2022 12:04:36 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 83A4C9EC0021; Sun,  6 Nov 2022 12:04:36 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 06 Nov 2022 13:04:36 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass
 (MAB) support with offload
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
User-Agent: Gigahost Webmail
Message-ID: <e6c4c3755e4aba80b3c7ebf31c8cdb58@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-25 12:00, Ido Schimmel wrote:
> Merge plan
> ==========
> 
> We need to agree on a merge plan that allows us to start submitting
> patches for inclusion and finally conclude this work. In my experience,
> it is best to work in small batches. I therefore propose the following
> plan:
> 
> * Add MAB support in the bridge driver. This corresponds to patches
>   #1-#2.
> 
> * Switchdev extensions for MAB offload together with mlxsw
>   support. This corresponds to patches #3-#16. I can reduce the number
>   of patches by splitting out the selftests to a separate submission.
> 
> * mv88e6xxx support. I believe the blackhole stuff is an optimization,
>   so I suggest getting initial MAB offload support without that. 
> Support
>   for blackhole entries together with offload can be added in a 
> separate
>   submission.

As I understand for the mv88e6xxx support, we will be sending 
SWITCHDEV_FDB_ADD_TO_BRIDGE
events from the driver to the bridge without installing entries in the 
driver.
Just to note, that will of course imply that the bridge FDB will be out 
of sync with the
FDB in the driver (ATU).

> 
> * Switchdev extensions for dynamic FDB entries together with mv88e6xxx
>   support. I can follow up with mlxsw support afterwards.
> 
> [1] 
> https://lore.kernel.org/netdev/20221018165619.134535-1-netdev@kapio-technology.com/
> [2] 
> https://lore.kernel.org/netdev/20221004152036.7848-1-netdev@kapio-technology.com/
> [3] 
> https://github.com/westermo/hostapd/blob/bridge_driver/hostapd/hostapd_auth_deauth.sh#L11
> [4] 
> https://lore.kernel.org/netdev/a11af0d07a79adbd2ac3d242b36dec7e@kapio-technology.com/
