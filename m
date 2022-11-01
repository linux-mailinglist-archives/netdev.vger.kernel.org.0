Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD8E6147AF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 11:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKAK2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 06:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiKAK2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 06:28:03 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36937186DA;
        Tue,  1 Nov 2022 03:28:02 -0700 (PDT)
Received: from [IPV6:2003:e9:d70d:1c31:377b:dae8:293d:d053] (p200300e9d70d1c31377bdae8293dd053.dip0.t-ipconnect.de [IPv6:2003:e9:d70d:1c31:377b:dae8:293d:d053])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id EE16CC0373;
        Tue,  1 Nov 2022 11:27:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1667298480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/Leu3k78Fk6bj5c/wAxoaMkKzuH9+bD0W7kXsBIx/U=;
        b=gyz7jyN1UlJwnm10K/iFbf+Fr/fxJHZeH6hNKlAXhQlNC1OPL9ujkqlLA0lHzyDVe9KV7t
        0SW0IfcKDMwQsFDfY8fNdpID0C0hgz2uWEUg0zl2wi1pOQUDnf/RVKJ8sNUAbc5BTsiO20
        Ihpj72F4PYBFj5MWtE1uuqljR+00jnbsxxSVTmA18s+156IMPmM/Ihw8/uNJxPtLVNiBr4
        nh3bJbIpTMSBgfwZ1WExdtvt6p1xfSpVG1KdHhBQIG8g1WGjFhSTs01W64xJeedSKiNfJd
        WQtQb51TOWDt72zAVD6i73fv+9u81Rfu7aDCPO2lwMultCwD1SPd05bfAdDUlw==
Message-ID: <0758fadf-d559-1383-3542-87bebf78e1e4@datenfreihafen.org>
Date:   Tue, 1 Nov 2022 11:27:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator
 interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
Content-Language: en-US
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221026093502.602734-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 26.10.22 11:34, Miquel Raynal wrote:
> Hello,
> These three patches allow the creation of coordinator interfaces, which
> were already defined without being usable. The idea behind is to use
> them advertizing PANs through the beaconing feature.
> 
> Changes since v1:
> * Addition of patches 1 and 2.
> * Improved the commit message of patch 3.
> * Rebased.
> * Minor fixes.
> 
> Miquel Raynal (3):
>    mac802154: Move an skb free within the rx path
>    mac802154: Clarify an expression
>    mac802154: Allow the creation of coordinator interfaces
> 
>   net/mac802154/iface.c | 15 ++++++++-------
>   net/mac802154/main.c  |  2 +-
>   net/mac802154/rx.c    | 24 +++++++++++-------------
>   3 files changed, 20 insertions(+), 21 deletions(-)


These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
