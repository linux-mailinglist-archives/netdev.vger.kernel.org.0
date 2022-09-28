Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468015EDEAB
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiI1OV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiI1OV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9577FA99DE
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30FB361D22
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F529C433D6;
        Wed, 28 Sep 2022 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664374916;
        bh=cloregP/aos++elb+suheS+O3ksxULCx1+0jflcjtHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IumXy0Bb65TqzUoxxiojlU6lAwJl64IwjKBTD8biWOkFocrNFOWRgtBMpzFuqy6Pp
         PxGtwayoKyFBWsKbP08iAP4fe0mZoopeyVgGaTd26XpO+hK1gn7K7mV85yYe3frWSD
         X3tikZoFwrkDSHq5FnUuJ8R+DXGq3WxWlnLBbAVRJE2os0iKiQlPRuotWJhx7K49yH
         3DCGT8/Vr9FKfbQWAPuxsaFZJFC1td0lhVDh4b6F2N0lYqv2qJK62u8NwlS2DoFAwH
         6WmIRDHTsrTW0bL7xG+cj4Ee6zeh4csdVtsvl3dQgR28SxfNQ0ZJapuQjm8awcBgUq
         u++rsnsOt1C5A==
Date:   Wed, 28 Sep 2022 07:21:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage
 of Netlink flags
Message-ID: <20220928072155.600569db@kernel.org>
In-Reply-To: <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
References: <20220927212306.823862-1-kuba@kernel.org>
        <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
> bulk delete to mdbs as well, and IIRC there were plans for other object types.
> I can update the doc once they are applied, but IMO it will be more useful to explain
> why they are used instead of who's using them, i.e. the BULK was added to support
> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
> it will be more beneficial if other object types can re-use it so moved to a flag).
> The first version of the fdb flush support used only netlink attributes to do the
> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
> finally settled on the flag[3][4] so everyone can use it.

I thought that's all FDB-ish stuff. Not really looking forward to the
use of flags spreading but within rtnl it may make some sense. We can
just update the docs tho, no?

BTW how would you define the exact semantics of NLM_F_BULK vs it not
being set, in abstract terms?
