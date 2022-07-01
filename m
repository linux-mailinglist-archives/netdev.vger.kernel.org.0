Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE679563AA0
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiGAUBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiGAUB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:01:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA44D165;
        Fri,  1 Jul 2022 13:01:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o7MpC-00040v-4C; Fri, 01 Jul 2022 22:01:10 +0200
Date:   Fri, 1 Jul 2022 22:01:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220701200110.GA15144@breakpoint.cc>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> While running the udp-flood test from stress-ng on Ampere Altra (Mt.
> Jade platform) I encountered a kernel panic caused by NULL pointer
> dereference within nf_conntrack.
> 
> The issue is present in the latest mainline (5.19-rc4), latest stable
> (5.18.8), as well as multiple older stable versions. The last working
> stable version I found was 5.15.40.

Do I need a special setup for conntrack?

No crashes after more than one hour of stress-ng on
1. 4 core amd64 Fedora 5.17 kernel
2. 16 core amd64, linux stable 5.17.15
3. 12 core intel, Fedora 5.18 kernel
4. 3 core aarch64 vm, 5.18.7-200.fc36.aarch64

I used standard firewalld ruleset for all of these and manually tuned
conntrack settings to make sure the early evict path (as per backtrace)
gets exercised.
