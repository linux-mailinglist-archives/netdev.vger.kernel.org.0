Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760C963C1F1
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiK2OKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbiK2OKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:10:13 -0500
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 06:10:03 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190275BD5B;
        Tue, 29 Nov 2022 06:10:02 -0800 (PST)
Received: from [IPV6:2003:e9:d724:11f3:6a8a:fec:d223:2c22] (p200300e9d72411f36a8a0fecd2232c22.dip0.t-ipconnect.de [IPv6:2003:e9:d724:11f3:6a8a:fec:d223:2c22])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DEF59C0BFA;
        Tue, 29 Nov 2022 15:01:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1669730462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tuLukpKCzhM0X/X1MjQzYoVSveA4A5uOI5pwQmS2Yko=;
        b=PWj4aadTGc7Muu7Ij1ZF4trLwr4EbxZDcfGIFBJjAfUyqkR3cjqP+Vj05UJ63A2+sKs4EO
        nZINuKkXOAsl3dWuYE5KUS925zFOFeuzclTV0y80W1+VgEkX9BTWbG66bjqbUaHXgeOxjn
        R51wNW4vSHSscRQmNP566K1D/fj4nMwvzpTOGU8i+uhHFfUdMAecJf6ER2bnkqdQqt9Otm
        /UsRKL+X+pzxk2QqL5JQTMNC8tx7ul1o8DDhIcWS88ZeQoYRiizJAg2HfcduAry+z0Nmxq
        iBLeiZYJ/V7W3E5FvvGCIa1dPUyQGjHdiZvV52BzX0yPu8TYlAFsF3g0eqb5WA==
Message-ID: <fdbc3c12-71c8-16da-6b69-eb235964fcd7@datenfreihafen.org>
Date:   Tue, 29 Nov 2022 15:01:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] ieee802154: cc2520: Fix error return code in
 cc2520_hw_init()
Content-Language: en-US
To:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        varkabhadram@gmail.com, alex.aring@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20221120075046.2213633-1-william.xuanziyang@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221120075046.2213633-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.11.22 08:50, Ziyang Xuan wrote:
> In cc2520_hw_init(), if oscillator start failed, the error code
> should be returned.
> 
> Fixes: 0da6bc8cc341 ("ieee802154: cc2520: adds driver for TI CC2520 radio")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>   drivers/net/ieee802154/cc2520.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index c69b87d3837d..edc769daad07 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -970,7 +970,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
>   
>   		if (timeout-- <= 0) {
>   			dev_err(&priv->spi->dev, "oscillator start failed!\n");
> -			return ret;
> +			return -ETIMEDOUT;
>   		}
>   		udelay(1);
>   	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
