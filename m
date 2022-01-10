Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5273E48947A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiAJI5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:57:34 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:54072 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241968AbiAJI5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 03:57:06 -0500
Received: from [IPV6:2003:e9:d726:98fc:cdf9:bc0b:bacf:e07a] (p200300e9d72698fccdf9bc0bbacfe07a.dip0.t-ipconnect.de [IPv6:2003:e9:d726:98fc:cdf9:bc0b:bacf:e07a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4E392C05A1;
        Mon, 10 Jan 2022 09:57:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641805022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IaYI1Hh+FARrQFhEF0cAj1myGc5Q4XmWUc/d7YCm7jg=;
        b=BKDixR9k/4qpycMv7rQ/G7RH+cpCQMhfg2Acg7w/IGD1+rdGc5GseTOKD1i5UytXMKqtya
        P9+m/lrTcpfV8t+WRUlMGlNtdTfnCBT3W8oaWT/c/QANHfS8NRCf5jFbZ8zLkQKvCLOOed
        yGN/gBkqLSKlNjs5VwU5jbRUgT9G9/ug6FAbjZjNAuIT5fsTHyNvRRkC436soN+aEoRniV
        fSJBQsh9SDom8Jd1MGrnbTkQiNUoyVzEIweKsN+YisIWze//bFrVeLV78xblj6gwoFbxoe
        L4XDfc5zqgf30t6x3WHLdxo49ceKt7ZOybXOlcFfw7OJj9A8fL1NUhfAbNhaRw==
Message-ID: <871f2181-6356-8bfd-47cb-0872d70b2cd9@datenfreihafen.org>
Date:   Mon, 10 Jan 2022 09:57:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH -next v2] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <2439d9ab-133f-0338-24f9-a9a5cd2065a3@datenfreihafen.org>
 <20220108131838.12321-1-paskripkin@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220108131838.12321-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 08.01.22 14:18, Pavel Skripkin wrote:
> Old USB API is prone to uninit value bugs if error handling is not
> correct. Let's move atusb to use new USB API to
> 
> 	1) Make code more simple, since new API does not require memory
> 	   to be allocates via kmalloc()
> 
> 	2) Defend driver from usb-related uninit value bugs.
> 
> 	3) Make code more modern and simple
> 
> This patch removes atusb usb wrappers as Greg suggested [0], this will make
> code more obvious and easier to understand over time, and replaces old
> API calls with new ones.
> 
> Also this patch adds and updates usb related error handling to prevent
> possible uninit value bugs in future
> 
> Link: https://lore.kernel.org/all/YdL0GPxy4TdGDzOO@kroah.com/ [0]
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v2:
> 	- Fixed logic bug in atusb_get_and_conf_chip()
> 	- Renamed rc variable to reg in atusb_read_subreg()
> 
> ---
>   drivers/net/ieee802154/atusb.c | 186 ++++++++++++---------------------
>   1 file changed, 67 insertions(+), 119 deletions(-)


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
