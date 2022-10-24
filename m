Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1C609B9F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 09:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJXHmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 03:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJXHm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 03:42:27 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEBE60E85;
        Mon, 24 Oct 2022 00:42:17 -0700 (PDT)
Received: from [10.1.64.117] (unknown [217.17.28.204])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 89F40C0434;
        Mon, 24 Oct 2022 09:42:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1666597335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTeI0QsB8Wty5iifFtznxJnrKumidiuEiElOyVPtyCM=;
        b=pUeTvTVJI8o0zDxT6kkGGvQHQ95xIxC+EyooYinSj5Dw9ag/H6DdOFtmeWDCGKI03hyKkN
        ZndrSQR1dfaNwHjHMOkleWIav+zT8WXGJrqmOOXZgrpgfWbe4e5NE2Ei5opyaIZMTXTm7F
        3Zqgyo+DRFL8GSIGEr9QEF7g9qFkjf182Nf2RQNtuJEGMFz9/GomWPB1D5qtatie/f+WWr
        z+LRGeTtgJKAyMDQYneXkdnD7YftCZ7rCHfLcTmZKuGbICU9+kix8bc/HTZvi4wrnJCFkx
        Xi44dRauFYHp9QiQC6fIX2z8+ej9/lgZQlb6uPYr2e8Q/PmG9Q4YkE1NWlAMFQ==
Message-ID: <22043b0d-ce42-15fa-98e1-a98e631b8def@datenfreihafen.org>
Date:   Mon, 24 Oct 2022 09:42:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan-next v6 0/3] IEEE 802.15.4 filtering series followup
Content-Language: en-US
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
References: <20221019134423.877169-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221019134423.877169-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.10.22 15:44, Miquel Raynal wrote:
> Hello,
> 
> The filtering series v4 [1] lead to a discussion about the use of a PIB
> attribute to save the required PHY filtering level instead of accessing
> the MAC internals, which is bein addressed in patch 1/3 and 2/3. The
> last patch has been sent alone as a v5 because of a debug message
> needing rewording. Actually Stefan wanted me to rebase on top of
> wpan-next without keeping a patch sent as a fix which conflicts with it,
> so here it is.
> 
> Once these three patches will be merged (I don't expect much discussions
> on it to be honest?) I will send the next small series bringing support
> for COORD interfaces.
> 
> Cheers, Miquèl
> 
> Miquel Raynal (3):
>    ieee802154: hwsim: Introduce a helper to update all the PIB attributes
>    ieee802154: hwsim: Save the current filtering level and use it
>    mac802154: Ensure proper scan-level filtering
> 
>   drivers/net/ieee802154/mac802154_hwsim.c | 88 +++++++++++++++---------
>   net/mac802154/rx.c                       | 16 +++--
>   2 files changed, 67 insertions(+), 37 deletions(-)


These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
