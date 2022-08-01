Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E26586FFC
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiHAR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiHAR7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8425F27CE4
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D90FB81608
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 17:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366D3C433D6;
        Mon,  1 Aug 2022 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659376734;
        bh=aCpB0E8tMH/8jopW6VTKssnQU7vOl0S9e6dSKrMC7TU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OVZNBXWnxFqjWwkbq9cGfZuSyIH478w7pMxlbk1zGD7a9ediSt9Sy8wC20frgG91W
         n/oN74O6ZjSN7CLoE4EaksP7AX8ugmpcuKP6WSQJ3/RgkQVUyDL6KKamvKX1AlGjE7
         Firn68QxnsoC9JKcutELEaxyb0uE30Bp/eIKAlTgdGahQzBLxQZ/l16j2PNndFlmo7
         kIU/riQSfKcsM09mJMTWEK2sT7y2YEPkw6Eqt7IWuMjXt9GKsGnpo5OWj0f1KK6UNY
         HoR5vmUDtvnw3ZCQEks3Sn4X+bkzq4RRwfbJTkOO4fBHl9YR6nTs89jwfhjsV8R1MV
         S0dRDEpQG9NOw==
Date:   Mon, 1 Aug 2022 10:58:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 0/4] Make DSA work with bonding's ARP monitor
Message-ID: <20220801105853.282543dd@kernel.org>
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jul 2022 15:41:04 +0300 Vladimir Oltean wrote:
> Where I'd need some help from Jakub is to make sure these changes
> somehow get integrated into the 5.10 stable kernel, since that's what
> Brian, who reported the issue, actually uses. I haven't provided any
> Fixes tags.

We can just tell Greg to pull them in after the patches appear in
Linus's tree, right? Or are there extra acrobatics required I missed?

As long as Jay is okay with the approach, LGTM. Thanks a lot for
working on the solution!

BTW we could potentially also revert a31d27fbed5d ("tun: fix bonding
active backup with arp monitoring") given we revert veth.
