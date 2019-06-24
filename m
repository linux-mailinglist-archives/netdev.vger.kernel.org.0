Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F25C51D76
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfFXVzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:55:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39366 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:55:53 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so734905iod.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FappfH93soJPWGvC6Xj6RgUUCXMFSluz8GZuwNy8rf8=;
        b=G2/3co3KETMYHUgwfXEglKDX8RnsgMqqCd80gviHvJ8qO/wOyyHCK+u9sJVlVKlD7c
         9hQglmXyiVN8hzzvU2iRkgdY/TRastrO+Ia0DeWX4lQfE48RsHKrVu31lg6dZyK34KiI
         g81u8aiqdoaacmIJ/lWqGvuIM4m5JlM6pZ5KGNygEnSlLvW1Q9X/LMSG3rp7slyZzZUv
         2KxFGbiWPsi6gjVqwqHe9igm9tjHqxIF7wQGiPG3vRGzrc8+k9AZxOuJnbN8BwRnZOeB
         wa8GCg+i2CL8Jll3wyxZJQacpKSNUoJPuliE9nkxNUNCCbnrnuOhWQJVoRFB0RchXwXp
         M+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FappfH93soJPWGvC6Xj6RgUUCXMFSluz8GZuwNy8rf8=;
        b=inPShPPDD9qm6cf0RwmxuPOMA8HhwmSpps1/c7ivCpX5S2+KUt3aCL50ZfgdvrBeDm
         CyQ/4NuWzToWcqKnD6eFHAj9t5SJfSnoJHbu+jHCcyD6dtfxUnHtR50cZ/5Qe8WT9cNj
         dR/3aCos3AmhmcXuTQE/Sck+3LCJz53Z/Ia6Dzn6aoopJro/JSciYEDW0YLZlZCh4U/X
         j4Lo3Lf5cN49w3oNauwhto6QolLI08mett94dnZ32I/VyRfORKZu63DCF2/pbQLOnzyX
         HvkOM45inqQkbkQ4GfftLGbBuREaMdhBtRY15HoRMInuRB1zGv9EkA4wymyWQbRxVDjY
         jBBA==
X-Gm-Message-State: APjAAAVImRU+3NHUUjSR5PrScKW7KKH9rHtd1fQ244JPkqUFJy9qTk79
        /P9992z4VGfW6xHaob2iVWV2XSO3
X-Google-Smtp-Source: APXvYqxkmzkNvzHaqx3DGaPLCuTva+NBdYVf2AFfig8HtfJAEXWakguWI37IpmVdqPFPbSRKdXWdVA==
X-Received: by 2002:a6b:2cc7:: with SMTP id s190mr3073740ios.29.1561413352160;
        Mon, 24 Jun 2019 14:55:52 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f558:9f3d:eff4:2876? ([2601:282:800:fd80:f558:9f3d:eff4:2876])
        by smtp.googlemail.com with ESMTPSA id k8sm11877426iob.78.2019.06.24.14.55.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:55:51 -0700 (PDT)
Subject: Re: [PATCH iproute2] iproute: Pass RTM_F_CLONED on dump to fetch
 cached routes to be flushed
To:     Stefano Brivio <sbrivio@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <209bcb66-2d57-eecf-d1a0-cc86af034e95@gmail.com>
Date:   Mon, 24 Jun 2019 15:55:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 7:33 PM, Stefano Brivio wrote:
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 2b3dcc5dbd53..192442b42062 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1602,6 +1602,16 @@ static int save_route_prep(void)
>  	return 0;
>  }
>  
> +static int iproute_flush_flags(struct nlmsghdr *nlh, int reqlen)

rename that to iproute_flush_filter to be consistent with
iproute_dump_filter.

Actually, why can't the flush code use iproute_dump_filter?

> +{
> +	struct rtmsg *rtm = NLMSG_DATA(nlh);
> +
> +	if (filter.cloned)
> +		rtm->rtm_flags |= RTM_F_CLONED;
> +
> +	return 0;
> +}
> +
>  static int iproute_flush(int family, rtnl_filter_t filter_fn)
>  {
>  	time_t start = time(0);
> @@ -1624,7 +1634,7 @@ static int iproute_flush(int family, rtnl_filter_t filter_fn)
>  	filter.flushe = sizeof(flushb);
>  
>  	for (;;) {
> -		if (rtnl_routedump_req(&rth, family, NULL) < 0) {
> +		if (rtnl_routedump_req(&rth, family, iproute_flush_flags) < 0) {
>  			perror("Cannot send dump request");
>  			return -2;
>  		}
> 

