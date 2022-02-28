Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338C44C60A6
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiB1BdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiB1BdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:33:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9465ADEB3
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D9A9B80D76
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A7C340E9;
        Mon, 28 Feb 2022 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646011962;
        bh=mya8zbN7kRI1NcZiHZBwMbKNPmCWttI8bfIsVpzQGnU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WGLSBvvr1i4AHqky32x/q03U9lNJhzvyNhGK2NiPhvoIT1dGQP4SPwB6yhoSf5no9
         GrAnE0eBOYgUQZhQasn8VE2BsvcSvq2OpV/iyoLnKfQW2vHBSmph9oJ/4xvgU8eUu6
         hgCOJoTQVVl9mKIYa4+AyAYTBGzeX1pq9Anb7jv060JarRz0VrXcvqetlUgpuCiw63
         xa4yoeD03Qpfff8PG0cWsm+6MYdmjuzVu7uD9BOT7OhIjzDisHXKXKA3X2B6bnX4gJ
         EE24pJXh5iHW8z1boMSq+GrTFgs/rAh/2Ozv2Jkw0sTpKFfXvzGIaa2MXA3WEPEGj2
         dxopfMkmfWrQw==
Message-ID: <243fb2a1-f8d5-c427-a0a7-44ac3d71af58@kernel.org>
Date:   Sun, 27 Feb 2022 18:32:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCHv2 iproute2-next] bond: add ns_ip6_target option
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
 <20220221055458.18790-7-liuhangbin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220221055458.18790-7-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 10:54 PM, Hangbin Liu wrote:
> Similar with arp_ip_target, this option add bond IPv6 NS/NA monitor
> support. When IPv6 target was set, the ARP target will be disabled.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: define BOND_MAX_NS_TARGETS
> ---
>  ip/iplink_bond.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 

> +		} else if (matches(*argv, "ns_ip6_target") == 0) {

changed matches to strcmp and applied.

we are not accepting any more uses of matches.
