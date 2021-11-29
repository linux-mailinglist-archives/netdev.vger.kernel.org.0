Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274B94618DA
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbhK2Oer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:34:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45041 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378468AbhK2Oca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:32:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 261D25C0110;
        Mon, 29 Nov 2021 09:29:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Nov 2021 09:29:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ODm1Tu
        n5Dn3eeRSRL1/FeAQ+5jHGPNz8LLO7NS3C+dI=; b=XEEm4sO++9zWX73vRCb6Gn
        9y3V0VboMKm0EopFAjDPq2eN3FVqypUU7ipEkFJmPClWhgksNCx47276mi/yLazR
        J1rqBaAtBTjK/O39veIfRhmzDF3tSshG1YzS4aGJ/dCpLby15lNfuF/VSIYL5L0h
        +OZ9a2srf2h+ResbEy7Td/9f7ltgH1qTIB0sL81k65/nEfSyo23/fVN8VX1KeF+t
        4NXUHxGV4LKxIeNPHKels/fRcrNj94LDW425TAduxAMj/KgaAyi3fSSOQ6fKRfIc
        R60VgnRMKP51YThLIcnuLFZVeBsYMvd3B6qJ8IGyvFUOwwzLu01Sb27goXN2Nsjg
        ==
X-ME-Sender: <xms:teOkYYo5Oc63gO8FcxXJDDC5nKOAbd1-I0NFr75MlhFMkbPML9hcyg>
    <xme:teOkYeqXPTf3JXHyt85x23mfDJj-bLP9qv1jHm21fVAhfT9f_uZgy7Yvyy9t_Li7c
    4BjZCMhRnBEiWM>
X-ME-Received: <xmr:teOkYdNCzsqUZZ92OlG1Y0KcrkW_RygvibWYjbsLrx_vQRNG8e3EeqzWb9AsU-iyXRmBQdi0o-99XYfRz4JEhwBpogjUew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheelgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:teOkYf5xQ4NvnCVSc7zda36gmRAa4qMX9xX9rJBbOquVkPvRfbztjQ>
    <xmx:teOkYX6BjRIVm8mQzjm5h4Wt5pqxi0J9eJBRsfRKzXSCM7xbq7Zx5A>
    <xmx:teOkYfjypS1-USMKcDD7wXTMqHq4CPtGavZ9jwXP5DbqbDLJki3PLA>
    <xmx:teOkYZm_zP8aj9FbHdA5eS31k87pNTnF54EwlEdTzBfY66VMSyFExg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Nov 2021 09:29:08 -0500 (EST)
Date:   Mon, 29 Nov 2021 16:29:04 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next] net: nexthop: reduce rcu synchronizations when
 replacing resilient groups
Message-ID: <YaTjsHnf3kpH3SqW@shredder>
References: <20211129120924.461545-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129120924.461545-1-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 02:09:24PM +0200, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can optimize resilient nexthop group replaces by reducing the number of
> synchronize_net calls. After commit 1005f19b9357 ("net: nexthop: release
> IPv6 per-cpu dsts when replacing a nexthop group") we always do a
> synchronize_net because we must ensure no new dsts can be created for the
> replaced group's removed nexthops, but we already did that when replacing
> resilient groups, so if we always call synchronize_net after any group
> type replacement we'll take care of both cases and reduce synchronize_net
> calls for resilient groups.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>

I ran fib_nexthops.sh that used to trigger the bug fixed by commit
563f23b00253 ("nexthop: Fix division by zero while replacing a resilient
group") and it looks good.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
