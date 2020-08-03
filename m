Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8F23AC5A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgHCS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgHCS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:27:29 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99645C06174A;
        Mon,  3 Aug 2020 11:27:29 -0700 (PDT)
Received: from localhost.localdomain (unknown [80.156.89.97])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9BFCAC260F;
        Mon,  3 Aug 2020 20:27:24 +0200 (CEST)
Subject: Re: [PATCH] ieee802154/adf7242: check status of adf7242_read_reg
To:     trix@redhat.com, michael.hennerich@analog.com,
        alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        marcel@holtmann.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200802142339.21091-1-trix@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <cb5859ab-e013-2e45-4871-a8e82235e2ab@datenfreihafen.org>
Date:   Mon, 3 Aug 2020 20:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200802142339.21091-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 02.08.20 16:23, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this error
> 
> adf7242.c:887:6: warning: Assigned value is garbage or undefined
>          len = len_u8;
>              ^ ~~~~~~
> 
> len_u8 is set in
>         adf7242_read_reg(lp, 0, &len_u8);
> 
> When this call fails, len_u8 is not set.
> 
> So check the return code.
> 
> Fixes: 7302b9d90117 ("ieee802154/adf7242: Driver for ADF7242 MAC IEEE802154")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ieee802154/adf7242.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
> index c11f32f644db..7db9cbd0f5de 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -882,7 +882,9 @@ static int adf7242_rx(struct adf7242_local *lp)
>   	int ret;
>   	u8 lqi, len_u8, *data;
>   
> -	adf7242_read_reg(lp, 0, &len_u8);
> +	ret = adf7242_read_reg(lp, 0, &len_u8);
> +	if (ret)
> +		return ret;
>   
>   	len = len_u8;
>   
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
