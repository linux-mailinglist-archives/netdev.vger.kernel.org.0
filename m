Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF9915DA77
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgBNPSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:18:31 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35743 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgBNPSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:18:31 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so3852120plt.2
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1SjS2A8q+WGJP8LH1KRadK6yRE7p3kQE6YGYBFXP9J8=;
        b=G45pCbZ+eIlxQkvIH2+D8ETrulaAdj4pe74VwO9V7pdNEilrEPG1f8jABuXMAcOKfn
         5WuTk3WRsgrcNWLli/dhR3I8PWOTsLdO8DxrFijWOy+63nyE5AzvV434zSMbPOnTEw1J
         xFSiCP+a3Usq4Yf/VrD91ID2iiwpZvRKWlJA8OUDH+2CkDXeNFZs84byAMdkVAnS4mt3
         bMXeIpGZOzBbwPsw4FRJrrx+cafY18XnFk5+5dpcN79LF+BMH2wQ0Da7lm3s/iuvQZPK
         qIZ0WG1uobfCxl29CI/Tnu0sSxsgiVwURJAdiXnDVUhhQC5gbsP4kNvofvLz0ECCFb9D
         0Z5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1SjS2A8q+WGJP8LH1KRadK6yRE7p3kQE6YGYBFXP9J8=;
        b=nbCGJuNHPO3h4mvuO6wSZLgfpDnK825ry1+bCYkI4KfTiyev9KH+CquVQTg0MgXG5m
         XH7k0LWdFIlBeZ7woHAGXb6f+PapwRmsudvfuILNIL1TN54ptyCQDiJ8Qwu/rgFQ3znf
         QpS/uAY5ieJV2CdEppIoBuqgcNYhgAp7IlCfN40B24ojgNJ4GMa0MpnLWy9Wt/yINO7y
         1KHLF87/2WzDqNMMxib5PACEroQfI9RuBGIqrWrNHn4pnWS7PGkpBpdP1hmKgphwViKs
         HHfngH7iUzQhHoPDkszsZbFEh/0dIWtdOvbHKXj/2Z0HxTKdBDLc+wn6ApLEtUB0cxp1
         Y37A==
X-Gm-Message-State: APjAAAUiAdRuMkqL7EVxrZN/SOjmZ76gYpFxioKdqXFCIIVigRdMrP81
        zJ2n5f1bP4nQO7eA+Q5X8B7esj/Y
X-Google-Smtp-Source: APXvYqwPhbdqvy/ElVKeYUNOgpwblftwKHWZvKjubFxhUJ1w7NqeiKu7xaQrR3hlgTKcp6+wtRVB5A==
X-Received: by 2002:a17:902:302:: with SMTP id 2mr3951769pld.58.1581693510671;
        Fri, 14 Feb 2020 07:18:30 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o19sm13769868pjr.2.2020.02.14.07.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 07:18:29 -0800 (PST)
Subject: Re: [PATCH net 3/3] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20200214133404.30643-1-Jason@zx2c4.com>
 <20200214133404.30643-4-Jason@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ba6b4c66-3c15-cdbc-7d0e-eaf307c5904c@gmail.com>
Date:   Fri, 14 Feb 2020 07:18:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214133404.30643-4-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 5:34 AM, Jason A. Donenfeld wrote:
> It turns out there's an easy way to get packets queued up while still
> having an MTU of zero, and that's via persistent keep alive. This commit
> makes sure that in whatever condition, we don't wind up dividing by
> zero. Note that an MTU of zero for a wireguard interface is something
> quasi-valid, so I don't think the correct fix is to limit it via
> min_mtu. This can be reproduced easily with:
> 
> ip link add wg0 type wireguard
> ip link add wg1 type wireguard
> ip link set wg0 up mtu 0
> ip link set wg1 up
> wg set wg0 private-key <(wg genkey)
> wg set wg1 listen-port 1 private-key <(wg genkey) peer $(wg show wg0 public-key)
> wg set wg0 peer $(wg show wg1 public-key) persistent-keepalive 1 endpoint 127.0.0.1:1
> 
> However, while min_mtu=0 seems fine, it makes sense to restrict the
> max_mtu. This commit also restricts the maximum MTU to the greatest
> number for which rounding up to the padding multiple won't overflow a
> signed integer. Packets this large were always rejected anyway
> eventually, due to checks deeper in, but it seems more sound not to even
> let the administrator configure something that won't work anyway.
> 

If mtu is set to 0, the device must not send any payload.

>  
> diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
> index c13260563446..ae77474dadeb 100644
> --- a/drivers/net/wireguard/send.c
> +++ b/drivers/net/wireguard/send.c
> @@ -148,7 +148,8 @@ static unsigned int calculate_skb_padding(struct sk_buff *skb)
>  	 * wouldn't want the final subtraction to overflow in the case of the
>  	 * padded_size being clamped.
>  	 */
> -	unsigned int last_unit = skb->len % PACKET_CB(skb)->mtu;
> +	unsigned int last_unit = PACKET_CB(skb)->mtu ?
> +				 skb->len % PACKET_CB(skb)->mtu : skb->len;
>  	unsigned int padded_size = ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE);
>  
>  	if (padded_size > PACKET_CB(skb)->mtu)
> 

Are you sure this works ?

Last statement :

return padded_size - last_unit;

will return a a ' negative number' 

