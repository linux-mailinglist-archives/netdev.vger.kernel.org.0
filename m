Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BF91BA6CD
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgD0Ope (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728076AbgD0Opb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:45:31 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECD8C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:45:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w4so19048571ioc.6
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JOrvGFLeNn45xI/s2rl/zzxlYHtks7rM0/IsMdE+VMY=;
        b=iowfW7HBSpT+htzCmqY6/CIEXd2XCfxS769yXC6LGs1QoXKTzz4yfAlVF9P8Qv29Oy
         hmjQFjfGgK4kjEDtD/btNKpDxG+agvQ/Dm3gDsN86UP9NZJk25fxVxSBV8SECsG+pHto
         X5xXXNA2oery012flkc7uV4sRvIvCX7y5JhZ/0fBjK0A6EBdpUpW/d/y6S3fgiObeLve
         1Au7stpPbKB6UA1+kBQab0SYmZqFDDcROaZ/8rbQe2/TSKO2WQjbGJjNOT5PX7VzdxH4
         OkwadeCU2Z96OqsYvO7VRCx/TpVlDMcoUUDW/z9tXNwdIa/CI0u8XIiCmpuJnFUKxVwv
         LJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JOrvGFLeNn45xI/s2rl/zzxlYHtks7rM0/IsMdE+VMY=;
        b=px8CULxdGA9rI0JaWoNIBKMX/m+nC1W7nYbZEFvvbhmgSunz0bJZs0yAzoOGYMTRxX
         SvUwy0C2s6djYbC9GRkZrKblNW6pzMMm5YhOrSgHxw+35S6Dgu5g/CFov62jeM36R3Hz
         ODSGCMjsjAjN8CeiKEUNcBKhVjgS270DEhDNl7236Z0wFCenvbi90ExzP1mY/rjUklgP
         v/a3YPQ59FrHbrrSqJfwaZGfSqSyHiOKdPO3f4eV9Txb01dHxCFcZAABxg4eRAFUXgE+
         IRBCVXrb1ynkQKfXH5/CB4bXuiOgLTTV+BT4PAVn5UTWEtg6GJjCnPuVKcqi6jlQFRHq
         9cXg==
X-Gm-Message-State: AGi0PuYjVsfjtsXkBsePzYgHxYUdstpOe1PWYEvb3T/vEvDfO8TYNu6r
        xRlKkUVfkSOJe9HvsA4IVG4=
X-Google-Smtp-Source: APiQypJdl3kcE/9h1CDKz/NCuq1/h+Tkqnb+3JkGMCnXqLiZoU6GIuvkNlBbdLEGlKu/nGhoeJIQBA==
X-Received: by 2002:a05:6602:2e96:: with SMTP id m22mr19219868iow.169.1587998730213;
        Mon, 27 Apr 2020 07:45:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id b71sm5543070ill.75.2020.04.27.07.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 07:45:29 -0700 (PDT)
Subject: Re: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb
 handler
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
 <20200427102229.414644-1-Jason@zx2c4.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58760713-438f-a332-77ab-e5c34f0f61b6@gmail.com>
Date:   Mon, 27 Apr 2020 08:45:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427102229.414644-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 4:22 AM, Jason A. Donenfeld wrote:
> @@ -4544,6 +4544,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	 * header.
>  	 */
>  	mac_len = skb->data - skb_mac_header(skb);
> +	if (!mac_len) {
> +		add_eth_hdr = true;
> +		mac_len = sizeof(struct ethhdr);
> +		*((struct ethhdr *)skb_push(skb, mac_len)) = (struct ethhdr) {
> +			.h_proto = skb->protocol
> +		};

please use a temp variable and explicit setting of the fields; that is
not pleasant to read and can not be more performant than a more direct

                eth_zero_addr(eth->h_source);
                eth_zero_addr(eth->h_dest);
                eth->h_proto = skb->protocol;
