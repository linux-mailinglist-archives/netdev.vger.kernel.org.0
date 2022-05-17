Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EFD529A8C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiEQHJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiEQHId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:08:33 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8958847563;
        Tue, 17 May 2022 00:08:29 -0700 (PDT)
Received: from [IPV6:2003:e9:d730:2275:90ad:628b:58df:e295] (p200300e9d730227590ad628b58dfe295.dip0.t-ipconnect.de [IPv6:2003:e9:d730:2275:90ad:628b:58df:e295])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DC8ADC02C8;
        Tue, 17 May 2022 09:08:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1652771307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xroGG9gPawE3RP2cg03Dt0eyU7bDJbhHLIhC64NcZ0Y=;
        b=AhhojJ5TCXMKgsrwTUAWLezNYbJufujIt28U2eM25PWKF0JFZgrBluD0m7sy31ftYy0uY3
        Df2UWndOlF97T8RZA080p/QSvDytGUhslsT84l5oOvKBcmCnvzr7moGqlHe0zazC0cGCpx
        HbXr1utd6AThCIrxnJXfjwaxhf/IduzJ1RZOd8CYUJwmQm47xCbQMWO3I2vF0+YF1/BYQp
        nosuYKU5CaKmJGUTx81ZF0aiNYYMTXRsdn8J4St/Hu6RB7omVwNypra/ZrvYkw0fptX0GZ
        LHkRje3wfQ0jdwe4Q2k+0KeruHdy5Ij1QTwnX8lCZygdp3VMoCTFwqJJqm1i8A==
Message-ID: <a3e28227-a2fe-4bf7-4abf-242421d07243@datenfreihafen.org>
Date:   Tue, 17 May 2022 09:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
References: <20220516215638.1787257-1-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 16.05.22 23:56, Jakub Kicinski wrote:
> Most protocol-specific pointers in struct net_device are under
> a respective ifdef. Wireless is the notable exception. Since
> there's a sizable number of custom-built kernels for datacenter
> workloads which don't build wireless it seems reasonable to
> ifdefy those pointers as well.
> 
> While at it move IPv4 and IPv6 pointers up, those are special
> for obvious reasons.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: johannes@sipsolutions.net
> CC: alex.aring@gmail.com
> CC: stefan@datenfreihafen.org
> CC: mareklindner@neomailbox.ch
> CC: sw@simonwunderlich.de
> CC: a@unstable.cc
> CC: sven@narfation.org
> CC: linux-wireless@vger.kernel.org
> CC: linux-wpan@vger.kernel.org
> ---
>   include/linux/netdevice.h       | 8 ++++++--
>   include/net/cfg80211.h          | 5 +----
>   include/net/cfg802154.h         | 2 ++
>   net/batman-adv/hard-interface.c | 2 ++
>   net/wireless/core.c             | 6 ++++++
>   5 files changed, 17 insertions(+), 6 deletions(-)

For the ieee802154 changes:

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
