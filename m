Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1DD67FA5D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 20:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjA1TKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 14:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjA1TKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 14:10:02 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A139A25291;
        Sat, 28 Jan 2023 11:10:01 -0800 (PST)
Date:   Sat, 28 Jan 2023 20:09:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Message-ID: <Y9VzBcDwtXIRDPkq@salvia>
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-3-vladbu@nvidia.com>
 <Y9U++4pospqBZugS@salvia>
 <87mt62ejd1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87mt62ejd1.fsf@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 06:03:37PM +0200, Vlad Buslov wrote:
> 
> On Sat 28 Jan 2023 at 16:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi,
> >
> > On Fri, Jan 27, 2023 at 07:38:40PM +0100, Vlad Buslov wrote:
> >> Currently flow_offload_fixup_ct() function assumes that only replied UDP
> >> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
> >> Allow users to modify timeout calculation by implementing new flowtable
> >> type callback 'timeout' and use the existing algorithm otherwise.
> >> 
> >> To enable UDP NEW connection offload in following patches implement
> >> 'timeout' callback in flowtable_ct of act_ct which extracts the actual
> >> connections state from ct->status and set the timeout according to it.
> >
> > I found a way to fix the netfilter flowtable after your original v3
> > update.
> >
> > Could you use your original patch in v3 for this fixup?
> 
> Sure, please send me the fixup.

What I mean is if you could use your original v3 2/7 for this
conntrack timeout fixup:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230119195104.3371966-3-vladbu@nvidia.com/

I will send a patch for netfilter's flowtable datapath to address the
original issue I mentioned, so there is no need for this new timeout
callback.
