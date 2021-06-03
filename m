Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8C399C8D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFCI3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCI3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:29:52 -0400
X-Greylist: delayed 414 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Jun 2021 01:28:08 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A399DC06174A;
        Thu,  3 Jun 2021 01:28:08 -0700 (PDT)
Received: from [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504] (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 02BBFC02EE;
        Thu,  3 Jun 2021 10:21:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1622708470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyQTFQMfdHTiufBAcnI9P/Wr2W6Ljpu4A2px9nIQ4KU=;
        b=DbMY5uxxDqgbj8Q0iGoJpkz8aKFIz58TxhEcSDJAxFbApN/BRtLXzST+cM1oM8AA5422AN
        5PyMcHFkm2h92/QCxZX1TNT5p5x8AuTwA79VpaBtWvTgQ4EJJJgu2s7OQTA/uH7fa9x6ld
        YD4bp2KWajjXV6ZqDSiCe/gaHrw9Pdn4owj+ef3k81FfbPAZ+4woRNR0X9JRUxvLdZdYVG
        Zt63VQB34AVgMV+I0INTFu27HD9ELe6yOzX2EVmDikEJh4h97Jx0j9p7b3/CkkwFGiA8EH
        8VrO7yCsBQ6V6jgWwdQjIFzFCjsicmMoyaf5JjuowfTHSVSpS3tqoBvgsoIhvQ==
Subject: Re: [PATCH] net/ieee802154: drop unneeded assignment in
 llsec_iter_devkeys()
To:     Yang Li <yang.lee@linux.alibaba.com>, alex.aring@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1619346299-40237-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <6bffca3c-6c85-b975-24d4-cdd1aa47380e@datenfreihafen.org>
Date:   Thu, 3 Jun 2021 10:21:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1619346299-40237-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 25.04.21 12:24, Yang Li wrote:
> In order to keep the code style consistency of the whole file,
> redundant return value ‘rc’ and its assignments should be deleted
> 
> The clang_analyzer complains as follows:
> net/ieee802154/nl-mac.c:1203:12: warning: Although the value stored to
> 'rc' is used in the enclosing expression, the value is never actually
> read from 'rc'
> 
> No functional change, only more efficient.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   net/ieee802154/nl-mac.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
> index 0c1b077..a6a8cf6 100644
> --- a/net/ieee802154/nl-mac.c
> +++ b/net/ieee802154/nl-mac.c
> @@ -1184,7 +1184,7 @@ static int llsec_iter_devkeys(struct llsec_dump_data *data)
>   {
>   	struct ieee802154_llsec_device *dpos;
>   	struct ieee802154_llsec_device_key *kpos;
> -	int rc = 0, idx = 0, idx2;
> +	int idx = 0, idx2;
>   
>   	list_for_each_entry(dpos, &data->table->devices, list) {
>   		if (idx++ < data->s_idx)
> @@ -1200,7 +1200,7 @@ static int llsec_iter_devkeys(struct llsec_dump_data *data)
>   						      data->nlmsg_seq,
>   						      dpos->hwaddr, kpos,
>   						      data->dev)) {
> -				return rc = -EMSGSIZE;
> +				return -EMSGSIZE;
>   			}
>   
>   			data->s_idx2++;
> @@ -1209,7 +1209,7 @@ static int llsec_iter_devkeys(struct llsec_dump_data *data)
>   		data->s_idx++;
>   	}
>   
> -	return rc;
> +	return 0;
>   }
>   
>   int ieee802154_llsec_dump_devkeys(struct sk_buff *skb,
> 

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
