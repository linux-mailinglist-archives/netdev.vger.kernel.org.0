Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC00C4C978F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbiCAVJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiCAVJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:09:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 835BB2C13F;
        Tue,  1 Mar 2022 13:08:49 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B7BE60745;
        Tue,  1 Mar 2022 22:07:21 +0100 (CET)
Date:   Tue, 1 Mar 2022 22:08:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net v4 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
Message-ID: <Yh6LXZnvax25PL8F@salvia>
References: <20220228092349.3605-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220228092349.3605-1-paulb@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 11:23:49AM +0200, Paul Blakey wrote:
> After cited commit optimizted hw insertion, flow table entries are
> populated with ifindex information which was intended to only be used
> for HW offload. This tuple ifindex is hashed in the flow table key, so
> it must be filled for lookup to be successful. But tuple ifindex is only
> relevant for the netfilter flowtables (nft), so it's not filled in
> act_ct flow table lookup, resulting in lookup failure, and no SW
> offload and no offload teardown for TCP connection FIN/RST packets.
> 
> To fix this, add new tc ifindex field to tuple, which will
> only be used for offloading, not for lookup, as it will not be
> part of the tuple hash.

Applied, thanks Paul.
