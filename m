Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8757449FA42
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbiA1NBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiA1NBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:01:00 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58997C061749;
        Fri, 28 Jan 2022 05:00:59 -0800 (PST)
Received: from [IPV6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d] (p200300e9d705dc252cd134b0e26de30d.dip0.t-ipconnect.de [IPv6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3F54DC0963;
        Fri, 28 Jan 2022 14:00:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643374857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SwRXvp4anoiRWcjo/rFJ2ukSP2RgDfwZbWYriq2fE84=;
        b=LcnaRCdXsOnhAHVu+iBGtSOqnAB1o61nB+0rMueP/PHv5dV4Qk1fuHBvgHoBBSjDy64U5u
        E7yoi9TfAaTHwFeBO3dAY53gvMGUOOB5BvEexdvStCoUgyAydd7lGaUOG2zF3Xou/pGhrL
        Zjni/MN9705QFaAIGdD3sdTAwSipsi0nq2lXQVlQCiSlxu1oM9Bsjb2BGbe3hE9CpM77Xe
        u/j93r9OoJBoCqT2T10MDEA7X6gkCshGS7GkffksU23PCdrU7r0u3whEnnEkXgDkRey6iP
        AOpkcYfhjk9kvvHPszlMu5Py/CJ6OadGSMFu/4uJmu2skhGaTj+yKDkFbGr9zw==
Message-ID: <0ab159b2-b2f2-2442-0fba-cc6ec82cf397@datenfreihafen.org>
Date:   Fri, 28 Jan 2022 14:00:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH wpan-next v2 3/5] net: mac802154: Convert the symbol
 duration into nanoseconds
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-4-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220128110825.1120678-4-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 28.01.22 12:08, Miquel Raynal wrote:
> Tdsym is often given in the spec as pretty small numbers in microseconds
> and hence was reflected in the code as symbol_duration and was stored as
> a u8. Actually, for UWB PHYs, the symbol duration is given in
> nanoseconds and are as precise as picoseconds. In order to handle better
> these PHYs, change the type of symbol_duration to u32 and store this
> value in nanoseconds.
> 
> All the users of this variable are updated in a mechanical way.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   drivers/net/ieee802154/at86rf230.c | 22 +++++++++++-----------
>   drivers/net/ieee802154/atusb.c     | 22 +++++++++++-----------
>   drivers/net/ieee802154/ca8210.c    |  2 +-
>   drivers/net/ieee802154/mcr20a.c    |  8 ++++----

I get a error on the mcr20a hunk when applying this. I assume its due to 
the mcr20a fix that hit wpan, but is not yet in wpan-next.

The wpan pull request for the fixes has been send today. Once merged and 
the next merge of net to net-next happened I will pull that in here to 
resolve the conflict.

regards
Stefan Schmidt
