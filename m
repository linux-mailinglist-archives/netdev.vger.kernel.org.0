Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8011CB2A1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgEHPQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:16:00 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:32910 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgEHPQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:16:00 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 11:15:59 EDT
Received: from PC192.168.2.51 (p200300E9D7489C6046CAB6DD825DF9A4.dip0.t-ipconnect.de [IPv6:2003:e9:d748:9c60:46ca:b6dd:825d:f9a4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0789FC06E3;
        Fri,  8 May 2020 17:09:44 +0200 (CEST)
Subject: Re: [PATCH net-next] ieee802154: 6lowpan: remove unnecessary
 comparison
To:     Yang Yingliang <yangyingliang@huawei.com>, alex.aring@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-wpan@vger.kernel.org
References: <1588909928-58230-1-git-send-email-yangyingliang@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <e9ce1e47-79aa-aca2-e182-b9063d17fad8@datenfreihafen.org>
Date:   Fri, 8 May 2020 17:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588909928-58230-1-git-send-email-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 08.05.20 05:52, Yang Yingliang wrote:
> The type of dispatch is u8 which is always '<=' 0xff, so the
> dispatch <= 0xff is always true, we can remove this comparison.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   net/ieee802154/6lowpan/rx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/6lowpan/rx.c b/net/ieee802154/6lowpan/rx.c
> index ee17938..b34d050 100644
> --- a/net/ieee802154/6lowpan/rx.c
> +++ b/net/ieee802154/6lowpan/rx.c
> @@ -240,7 +240,7 @@ static inline bool lowpan_is_reserved(u8 dispatch)
>   	return ((dispatch >= 0x44 && dispatch <= 0x4F) ||
>   		(dispatch >= 0x51 && dispatch <= 0x5F) ||
>   		(dispatch >= 0xc8 && dispatch <= 0xdf) ||
> -		(dispatch >= 0xe8 && dispatch <= 0xff));
> +		dispatch >= 0xe8);
>   }
>   
>   /* lowpan_rx_h_check checks on generic 6LoWPAN requirements
> 

This looks good to me. Thanks for fixing this.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>

Dave, can you apply this directly to your net tree? I have no other 
ieee802154 fixes pending to fill a pull request.

regards
Stefan Schmidt
