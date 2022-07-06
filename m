Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06F756887E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiGFMkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 08:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiGFMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 08:40:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C28252AA;
        Wed,  6 Jul 2022 05:40:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o94K7-0004EF-24; Wed, 06 Jul 2022 14:40:07 +0200
Date:   Wed, 6 Jul 2022 14:40:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        mark.rutland@arm.com, broonie@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220706124007.GB7996@breakpoint.cc>
References: <20220702205651.GB15144@breakpoint.cc>
 <YsKxTAaIgvKMfOoU@e126311.manchester.arm.com>
 <YsLGoU7q5hP67TJJ@e126311.manchester.arm.com>
 <YsQYIoJK3iqJ68Tq@e126311.manchester.arm.com>
 <20220705105749.GA711@willie-the-truck>
 <20220705110724.GB711@willie-the-truck>
 <20220705112449.GA931@willie-the-truck>
 <YsVmbOqzACeo1rO4@e126311.manchester.arm.com>
 <20220706120201.GA7996@breakpoint.cc>
 <20220706122246.GI2403@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706122246.GI2403@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will Deacon <will@kernel.org> wrote:
> On Wed, Jul 06, 2022 at 02:02:01PM +0200, Florian Westphal wrote:
> > +	/* ->status and ->timeout loads must happen after refcount increase */
> > +	smp_rmb();
> 
> Sorry I didn't suggest this earlier, but if all of these smp_rmb()s are
> for upgrading the ordering from refcount_inc_not_zero() then you should
> use smp_acquire__after_ctrl_dep() instead. It's the same under the hood,
> but it illustrates what's going on a bit better.

Ok, I can replace it and send a v2, no problem.
