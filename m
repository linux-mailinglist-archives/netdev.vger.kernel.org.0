Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F176ED182
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDXPhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjDXPg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:36:58 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2B67EC0;
        Mon, 24 Apr 2023 08:36:54 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D1858188374C;
        Mon, 24 Apr 2023 15:36:50 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id C669825004C3;
        Mon, 24 Apr 2023 15:36:45 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BD4F79B403F7; Mon, 24 Apr 2023 15:36:45 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 6373D9B403F4;
        Mon, 24 Apr 2023 15:36:45 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
In-Reply-To: <20230424122631.d7kwfwmlwvqjo3pz@skbuf>
References: <20230418155902.898627-1-vladimir.oltean@nxp.com>
 <875y9nt27g.fsf@kapio-technology.com>
 <20230424122631.d7kwfwmlwvqjo3pz@skbuf>
Date:   Mon, 24 Apr 2023 17:33:44 +0200
Message-ID: <87jzy11ehz.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 15:26, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Sun, Apr 23, 2023 at 10:47:15AM +0200, Hans Schultz wrote:
>> I do not understand this patch. It seems to me that it basically blocks
>> any future use of dynamic fdb entries from userspace towards drivers.
>> 
>> I would have expected that something would be done in the DSA layer,
>> where (switchcore) drivers would be able to set some flags to indicate
>> which features are supported by the driver, including non-static
>> fdb entries. But as the placement here is earlier in the datapath from
>> userspace towards drivers it's not possible to do any such thing in the
>> DSA layer wrt non-static fdb entries.
>
> As explained too many times already in the thread here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230318141010.513424-3-netdev@kapio-technology.com/
> the plan is:

Ahh yes thanks, I see the comment you wrote on march the 27th.
