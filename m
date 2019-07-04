Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E71D5F4B3
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGDImq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:42:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39339 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbfGDImq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 04:42:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3669E21AD2;
        Thu,  4 Jul 2019 04:42:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 04:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tvh7PJ
        Ba9EI0sBphhBvNVZyUTvTLgnQ/53szrvVNVKw=; b=YfrUZV1F5yetxqvQMDp2Gw
        4yOW5PzC09G1a3Y5SFyYq29Jx7x5R/KqmLZkkpjyrWIlQKIZ1UHH5eNsJKJCV+cw
        o5NHEVQXfnUzXSMLz6jEHNcrKTmuPri6z9z1FLHuH1XEXH1kqxSCEG13Upe31AIx
        q/wUGz/ibJT83zcXy0xaW6HTw4FwQW6+ySBYTDoF9FOms/fvE9ONvvNd8HKCey1k
        d0K85WWIuBhmGXU1eWdknNnMWjP83rZL/15oi0gg5BAj8NCDOMMxO+RhQJVY8ZO0
        MGfeBeDtSNbQyaS6XAFm7XU4rjLufTIy7bedM4iRCJ+zjhTnIQsC983HasmPvi8A
        ==
X-ME-Sender: <xms:A7wdXQs4csLGAMyixnKIF41gE9wTj6IDIRVm9HCgEaBl3MFo7Zeg2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedvgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtre
    dttdervdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:BLwdXQ9099J8Cxk-ElgehpXDrctHR4SgO2jKE5gKa9X_FvYY5AMafw>
    <xmx:BLwdXSi_xXObBgHToochJwBFYoAoONerLXePbQh1DtykvaCiDBD0HA>
    <xmx:BLwdXRdRk7E-TBeR2EMqnP3KjrIYSVZP2v1reqA6tLvlBvfzrAFg_g>
    <xmx:BLwdXW9ActnaER03ixyhBojnCZS9dHX5ZrZssiWCWKGrRWnmug_lIg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CF01380084;
        Thu,  4 Jul 2019 04:42:43 -0400 (EDT)
Date:   Thu, 4 Jul 2019 11:42:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next 3/3] selftests: forwarding: Test multipath
 hashing on inner IP pkts for GRE tunnel
Message-ID: <20190704084241.GA3274@splinter>
References: <20190703151934.9567-1-ssuryaextr@gmail.com>
 <20190703151934.9567-4-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703151934.9567-4-ssuryaextr@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 11:19:34AM -0400, Stephen Suryaputra wrote:
> Add selftest scripts for multipath hashing on inner IP pkts when there
> is a single GRE tunnel but there are multiple underlay routes to reach
> the other end of the tunnel.
> 
> Four cases are covered in these scripts:
>     - IPv4 over GRE over IPv4
>     - IPv6 over GRE over IPv4
>     - IPv4 over GRE over IPv6
>     - IPv6 over GRE over IPv6
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Thanks a lot for all the tests! Ran gre_inner_v4_multipath.sh and it
looks good to me.

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
