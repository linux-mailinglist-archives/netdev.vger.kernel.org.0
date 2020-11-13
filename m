Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D628A2B16B2
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgKMHrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKMHrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:47:01 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E87C0613D1;
        Thu, 12 Nov 2020 23:47:01 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so11986810ejb.3;
        Thu, 12 Nov 2020 23:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xyFPgfJGZElUDS+PI2Phj5FKf+h5B1qSjvSoQQaGK30=;
        b=H0uuAfr62wXmYh3GdjTb4/g0FY9lMiVTQFQk3ppJb1GKYB12OFKy9YeMM/+CP7W9w2
         p4NVxzdZS6eV4fTQ1SgRyV2HKd6PACx9D1IO0ZMzIELSEpScp95uALTHXNZ3vh0xe1x0
         lTPSXGIm9CU16mcIs3wK++he5jeCwhVPvk56cHdQi6Ag7XY+7Ze67zgSCOiPc9dBI5Af
         HBS7KapJUUIlDqFPgBQS93LT7O/RVagtEpPUrVBg1uCyU/QmyB+RLiqJkBwDeTcPFli1
         sHfW6xVe733NsPh6CW1off/H9mB7KLezJr3nUmo0+7fAGwUdHrCNXKOjF9mqprwoHfye
         kc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xyFPgfJGZElUDS+PI2Phj5FKf+h5B1qSjvSoQQaGK30=;
        b=qIsxHwpkuwo2V1I0A7jhH78l4vpHLIG4LoLPmFPePSyNjOkDGm5xUIeUihklUUcxUo
         yrfuZ2wBF8ASDNfqIvqhliqpG5uy+jeSIN/zG5m4Uoqtp0LRmguromBrD0DoLeUcZtEh
         /3A9DYWK80RpzJg0FtLI7RiekKqMykuplIaBPxCSIRQLZquUgW76cdh9udWRgFzv+qRq
         AbveGe+4coJixoPlEeeZ/FcNIIH87ZKYr0U6JGO1y2XhuBOSgqeswywC7NVjeFFgxpRC
         6fEbnju9ZJypb7WE4lBiyqjdTqRSzH56Pzn1NmXZP5RWseeIHFHRCaXBgHBLfEgktQBW
         Zv/Q==
X-Gm-Message-State: AOAM533ZsnUdgAF7KvrUQvVLzYqXm0d8GJkltHuOLEplQ3FgGaLX/UpG
        96XGqY/Vk63AIfXzdfwonTygpiwTJc2CTw==
X-Google-Smtp-Source: ABdhPJwVXDRwL7YD222iy0r6wsuoZZ145TW4JxlvR8+v+l+0iKXRcADDSJJINNHbSgRywEniUgJZSw==
X-Received: by 2002:a17:906:e53:: with SMTP id q19mr805931eji.254.1605253618387;
        Thu, 12 Nov 2020 23:46:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id y18sm3011727ejq.69.2020.11.12.23.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 23:46:57 -0800 (PST)
Subject: Re: [PATCH 3/3] net: xfrm: use core API for updating TX stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <20201112111345.34625-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <59b6c94d-e0de-e4f5-d02e-e799694f6dc8@gmail.com>
Date:   Fri, 13 Nov 2020 08:46:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112111345.34625-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12.11.2020 um 12:13 schrieb Lev Stipakov:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code.
> 
LGTM. In addition you can replace xfrmi_get_stats64() with
dev_get_tstats64().

> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
>  net/xfrm/xfrm_interface.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index 9b8e292a7c6a..43ee4c5a6fa9 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -319,12 +319,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  
>  	err = dst_output(xi->net, skb->sk, skb);
>  	if (net_xmit_eval(err) == 0) {
> -		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
> -
> -		u64_stats_update_begin(&tstats->syncp);
> -		tstats->tx_bytes += length;
> -		tstats->tx_packets++;
> -		u64_stats_update_end(&tstats->syncp);
> +		dev_sw_netstats_tx_add(dev, 1, length);
>  	} else {
>  		stats->tx_errors++;
>  		stats->tx_aborted_errors++;
> 

