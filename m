Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70926CCB94
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjC1Uk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjC1Uk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:40:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 474A02D74;
        Tue, 28 Mar 2023 13:40:55 -0700 (PDT)
Date:   Tue, 28 Mar 2023 22:40:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/1] netfilter: ctnetlink: Support offloaded
 conntrack entry deletion
Message-ID: <ZCNQ0YqLR3OxMgd3@salvia>
References: <1679470532-163226-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1679470532-163226-1-git-send-email-paulb@nvidia.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Apologies for lagging to catch up with this.

On Wed, Mar 22, 2023 at 09:35:32AM +0200, Paul Blakey wrote:
> Currently, offloaded conntrack entries (flows) can only be deleted
> after they are removed from offload, which is either by timeout,
> tcp state change or tc ct rule deletion. This can cause issues for
> users wishing to manually delete or flush existing entries.
> 
> Support deletion of offloaded conntrack entries.
> 
> Example usage:
>  # Delete all offloaded (and non offloaded) conntrack entries
>  # whose source address is 1.2.3.4
>  $ conntrack -D -s 1.2.3.4
>  # Delete all entries
>  $ conntrack -F

This fine with me.

I think probably it much be documented somewhere that in case of
hardware offload, deletion is asynchronous.
