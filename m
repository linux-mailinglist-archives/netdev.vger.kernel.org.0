Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5A4CCC9B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbiCDEiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbiCDEiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:38:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB6E180209
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 20:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1209C61B39
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABB3C340E9;
        Fri,  4 Mar 2022 04:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646368640;
        bh=pSzZtz6RrRbgOzshM0bmpNrJiUKsh2zS8cQqyOF0EaU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=u7IYETVTA6zqbObHSkERTc5Vl+ARMvMSLU5Y8ZpXW1rJwowFDE4k8WFcldQuWZuoS
         mDlNw2YVOTl3cCDx0zVPvIzmFaZMN8WxekH3v2QkJIBpBRvG34EvZ0r+VqashIHPBK
         /MFi0p5mH0CCTww0aehtiFA+qNM9Lr1Zj5m3/IUolgNqnZTpyKDqpm4BYDaCBAcF7G
         1rkrufsP06plW6KnmeR+ab492rb7bldIdBcefu3hT/Cg/Lmz5oA43Bff/4uCuErHaj
         6xw+x65JFfEWDb0vKOARwv5SihA+Z9m0WUmmd7qgRHzz0Ww84T8Wf/DrHUeHLxR0ws
         UUFfMchmn5LxQ==
Message-ID: <f7c14a37-3404-2ad0-bb71-2446b52c572d@kernel.org>
Date:   Thu, 3 Mar 2022 21:37:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 07/14] ipv6: add GRO_IPV6_MAX_SIZE
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-8-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220303181607.1094358-8-eric.dumazet@gmail.com>
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

On 3/3/22 11:16 AM, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Enable GRO to have IPv6 specific limit for max packet size.
> 
> This patch introduces new dev->gro_ipv6_max_size
> that is modifiable through ip link.
> 
> ip link set dev eth0 gro_ipv6_max_size 185000
> 
> Note that this value is only considered if bigger than
> gro_max_size, and for non encapsulated TCP/ipv6 packets.
> 

What is the point of a max size for the Rx path that is per ingress
device? If the stack understands the larger packets then the ingress
device limits should not matter. (yes, I realize the existing code has
it this way, so I guess this is a historical question)
