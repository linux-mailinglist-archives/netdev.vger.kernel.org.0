Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8BC55F558
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiF2Ek0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2EkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7F82C64A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 267BBB821B0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0627DC3411E;
        Wed, 29 Jun 2022 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477621;
        bh=iHw9bd8s4EekjXNRbJp+UlyFG/OqrDWm5kUz2JiIYjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GD4Q6OAPWtS2tJDYyq+B7IwLHgSANFRKHGUT4Saed8lSn1NUhBWXev69bFxTercB6
         bIGPDAXbVWHucBIs96tei3pdmPkZvfrqbBTKusg0Mg5LmXRi/sxIJRRYifZpS5idhD
         w/V7bLpfIHjd4jK+zsqo4GpKqzz9rl6RixbAh6DRu+7tTeZe5yNvVWTMa/HJcSyh++
         xIrkYg5ueBsONBT7aBLBOUHxBwHNSMKFQes23nRhGFPQjjvHLw/ZkBebgPSCBGH+aI
         byZ5JVdByHN///4+qc6uiu5eOj5/MsqacmbFuWnIjEfwq0kB3/1usSXBZV3a3YtxZs
         LWWZq7oUrDdLg==
Date:   Tue, 28 Jun 2022 21:40:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
        kurt@linutronix.de, pablo@netfilter.org, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com
Subject: Re: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE
 dissectors
Message-ID: <20220628214020.0f83fc21@kernel.org>
In-Reply-To: <20220628112918.11296-2-marcin.szycik@linux.intel.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
        <20220628112918.11296-2-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 13:29:15 +0200 Marcin Szycik wrote:
> +static bool is_ppp_proto_supported(__be16 proto)

What does supported mean in this context?

> +{
> +	switch (ntohs(proto)) {
> +	case PPP_AT:

Byte swap on the constant.

> +	case PPP_IPX:
> +	case PPP_VJC_COMP:
> +	case PPP_VJC_UNCOMP:
> +	case PPP_MP:
> +	case PPP_COMPFRAG:
> +	case PPP_COMP:
> +	case PPP_MPLS_UC:
> +	case PPP_MPLS_MC:
> +	case PPP_IPCP:
> +	case PPP_ATCP:
> +	case PPP_IPXCP:
> +	case PPP_IPV6CP:
> +	case PPP_CCPFRAG:
> +	case PPP_MPLSCP:
> +	case PPP_LCP:
> +	case PPP_PAP:
> +	case PPP_LQR:
> +	case PPP_CHAP:
> +	case PPP_CBCP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
