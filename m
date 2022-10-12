Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02765FC25C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJLIvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJLIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:51:00 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C2E8B2FA;
        Wed, 12 Oct 2022 01:50:51 -0700 (PDT)
Received: from [IPV6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd] (p200300e9d70ef1c1fef218a826e347fd.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0AA41C040D;
        Wed, 12 Oct 2022 10:50:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665564648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXeCVDvzCP0CH8sShZI5EYfA702+ZGIfxVpzqrhwPXg=;
        b=QItewZRnf/siiDUldZXgKaOg+58JQnL9vIPKxJdaslutnY4qWjEBT3n58+o55qbb9Wz2YW
        OaC3wDpIuWT9korBStKQ9u6oAdBmn55GucWOG1Z5wqaHasifDUgG09Hx+EKuLYI3vP4SCy
        Jf7R5wvq7EoUBvZhaQgxYdYjyPTGN9x0omMeXP/mBTZXh+D5vMzNlej3B3golNI2RMA7if
        r4EZrzWAUe8H7mnoYZyf1ICLvhQ7wjckWzl3C1sFRsIVsgnPAXmR7nJCXPz0wKdHi4myTC
        Yu01/bUKY1gPmyBpGUzv1eA5O+ELG0u+IV/FVHncFzHw7akBUytRznEQa+S9bQ==
Message-ID: <7011ee4d-6ef4-669b-1fbd-596341a6573f@datenfreihafen.org>
Date:   Wed, 12 Oct 2022 10:50:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH -next] net: ieee802154: mcr20a: Switch to use
 dev_err_probe() helper
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org
Cc:     liuxuenetmail@gmail.com, alex.aring@gmail.com, davem@davemloft.net
References: <20220915071258.678536-1-yangyingliang@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220915071258.678536-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 15.09.22 09:12, Yang Yingliang wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/net/ieee802154/mcr20a.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index 2fe0e4a0a0c4..f53d185e0568 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -1233,12 +1233,9 @@ mcr20a_probe(struct spi_device *spi)
>   	}
>   
>   	rst_b = devm_gpiod_get(&spi->dev, "rst_b", GPIOD_OUT_HIGH);
> -	if (IS_ERR(rst_b)) {
> -		ret = PTR_ERR(rst_b);
> -		if (ret != -EPROBE_DEFER)
> -			dev_err(&spi->dev, "Failed to get 'rst_b' gpio: %d", ret);
> -		return ret;
> -	}
> +	if (IS_ERR(rst_b))
> +		return dev_err_probe(&spi->dev, PTR_ERR(rst_b),
> +				     "Failed to get 'rst_b' gpio");
>   
>   	/* reset mcr20a */
>   	usleep_range(10, 20);


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
