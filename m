Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED0C647512
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLHRml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiLHRmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:42:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E6828B;
        Thu,  8 Dec 2022 09:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C47A62010;
        Thu,  8 Dec 2022 17:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A4DC433F0;
        Thu,  8 Dec 2022 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670521351;
        bh=utdMMEDMbfjfANs9F7ogpyQ+wApNaZHIFkDzje1WJv8=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=V8qzq44Vq/8QwTdsjTYOhe3MIneNOz5L12HbgDnpv0/TeTKU6mwkibRz0j89hW/Ae
         g156wOzaGlx2DLdlcfgB4sQGHeBCMs22tRxwPJVkXA1p9KfFv54XmBXg3bmqfkZ44s
         vX3e+qnRsEoDqkqgt62wcfGAwd5QJhqP60C5ErSFa878dR2hh3gdXUyBMKf19K8Mkg
         yjYsowlsvjJxDf9G8Uj+Go6xmuDylsjfLE66Jo01yxsNX0J6RU+9a383mk3uoY7Kvw
         kIsYvaG7ageK9CPy3o3RuYdlHFBx/PV98CGQONTGSYIa12SppxGF74oQUd+jQ90XNY
         T3BMGwkB7RgTQ==
Message-ID: <7b510e87-3a34-d9c8-a9e9-65c1d93ad645@kernel.org>
Date:   Thu, 8 Dec 2022 10:42:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v2] net: setsockopt: fix IPV6_UNICAST_IF option for
 connected sockets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221208145437.GA75680@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221208145437.GA75680@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 7:54 AM, Richard Gobert wrote:
> Change the behaviour of ip6_datagram_connect to consider the interface
> set by the IPV6_UNICAST_IF socket option, similarly to udpv6_sendmsg.
> 
> This change is the IPv6 counterpart of the fix for IP_UNICAST_IF.
> The tests introduced by that patch showed that the incorrect
> behavior is present in IPv6 as well.
> This patch fixes the broken test.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/r/202210062117.c7eef1a3-oliver.sang@intel.com
> Fixes: 0e4d354762ce ("net-next: Fix IP_UNICAST_IF option behavior for connected sockets")
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  net/ipv6/datagram.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

