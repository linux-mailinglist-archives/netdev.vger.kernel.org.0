Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07871381B12
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhEOUrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbhEOUrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 16:47:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E4BC061573;
        Sat, 15 May 2021 13:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=UoJ9DFfErbajmQEYJKCqN6Ov0S2aMEodekeWmwF9UXs=; b=Ha8GFjiLgIF5p/vutkuHnNkj8X
        +ZHJeYbzLAFq6/hYfPXadLpKaV5J+MI6LN6bdkCmzce1FbH6whyMJLnWo8E93Kyq7Lv0Hj1uO0dx1
        5FoyvdvrjChkAzsYT8qmpAnkxvxS5/wdr4mTlDDRSZtgQru4PsQGGeOvtngUq9K90ODOV+QBU/rZ7
        bID5QH8oDiadMzrMjGHmtUAioBsGbeUWYvbdl4mr2jBqcIpX49L4LkkrPCvZhlPMXuEebvKx9ui3l
        u86V92lEYBy1wF3O32tMQ92QNPfK+9aiT+QgIJLj4V111PJfn+bKg+aDa64BxdXDdrV17SKWbYQ3U
        9mJMb+hQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1li1B3-00CgFX-GE; Sat, 15 May 2021 20:46:25 +0000
Subject: Re: [PATCH] net: bridge: fix signature of stub br_multicast_is_router
To:     trix@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210515203849.1756371-1-trix@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <17c9c0cb-6f7a-20e7-62dd-9a2845e962ba@infradead.org>
Date:   Sat, 15 May 2021 13:46:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210515203849.1756371-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/21 1:38 PM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Building with CONFIG_IPV6 off causes this build error
> 
> br_input.c:135:8: error: too many arguments to function
>   ‘br_multicast_is_router’
>         br_multicast_is_router(br, skb)) {
>         ^~~~~~~~~~~~~~~~~~~~~~
> In file included from net/bridge/br_input.c:23:
> net/bridge/br_private.h:1059:20: note: declared here
>  static inline bool br_multicast_is_router(struct net_bridge *br)
>                     ^~~~~~~~~~~~~~~~~~~~~~
> 
> Comparing the stub with the real function shows the stub needs
> another parameter.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Hi,

A similar patch has already been merged:

https://lore.kernel.org/netdev/20210514073233.2564187-1-razor@blackwall.org/

> ---
>  net/bridge/br_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index f9a381fcff094..9fd54626ca809 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1056,7 +1056,7 @@ static inline void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  {
>  }
>  
> -static inline bool br_multicast_is_router(struct net_bridge *br)
> +static inline bool br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
>  {
>  	return false;
>  }
> 


-- 
~Randy

