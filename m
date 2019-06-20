Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317FE4C9ED
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfFTIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42199 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfFTIyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 04:54:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id t28so1912859lje.9
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 01:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XV+YrUigCDDIRUveyB1XDbziMO/ZiZxaiH7FYVcJoGA=;
        b=oqo/RX2HVGGth+PchSW9tgaJlBbosx7yeOeKiv2xpeptiCb0zw8dSM60I9Qk5CjNLl
         uhvO5+S8++Yv3BfNO7ZQzBgjcAZnkHAPscqBDhxJvetgYLWbosZ4l927qqQa/chrJtR7
         A3uKtCybx70wqQmW4ObJCkVb6c1dRTESQzCN8dE66a2j6mY989zO0eu89/Guino7kOID
         N6Db8x+eP/gyGsXv73A59ly40QRQjjHD4uFuUiGLgDjgGRKQl+reY4gVhqjKShU9QtQ3
         nV6zmcOuPFlVnSz4E8yPjoExAiD5USTpr3PZsyY6cNa2uhF7yDpBQVuljOF0vdXVqHVZ
         biOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XV+YrUigCDDIRUveyB1XDbziMO/ZiZxaiH7FYVcJoGA=;
        b=myKrLxafXGeCRc+D+v91m0cUUHpEk3D8H/4J3KuYCXnQCgXTrgGx5+oHBCLa9W/qCA
         sK0AnePLK5FAzZWCZGhSjmt4vQu6C68uRKOh7xBKQ3H5GRMefCVlb4+4vdeoHdcRHc0B
         3+LQDs1JyAZfINhFkstT1JBhMaVLlghCCP8ENRL+jUDLpl/U05stgk4C6EGM52DCrulH
         nxD2zAeKPgpjBNg5+NTCSNbF6gb1T5ngZ0n2MFojB0eOMpvM04DZHAb4A/2AwMXHMwIy
         UUTbrB4yCtkqIUVIZRC5D9e9FtMM1AlxSgXeXLFNPikdXwnahUsAXBr63P2vKptS9PM8
         tXFg==
X-Gm-Message-State: APjAAAVjuunGfVqgFVdn/YWaKkkvq8ywmu112xiERbg/FVIAl0jrzPmj
        uFse3g4ze5HXb+0XkOr+yxwBow==
X-Google-Smtp-Source: APXvYqyJjdTh32uiq2m1OlJfja/u0w5AOiM1eNFaRWsQXrUo9GwtQy8LhikCB+Bm2QgsDSkFzZt1HA==
X-Received: by 2002:a2e:8082:: with SMTP id i2mr7925357ljg.121.1561020859602;
        Thu, 20 Jun 2019 01:54:19 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.13])
        by smtp.gmail.com with ESMTPSA id 137sm3429314ljj.46.2019.06.20.01.54.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 01:54:19 -0700 (PDT)
Subject: Re: [PATCH] mlxsw: spectrum_ptp: fix 32-bit build
To:     Arnd Bergmann <arnd@arndb.de>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Shalom Toledo <shalomt@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190619133128.2259960-1-arnd@arndb.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <099199e8-bf5a-4124-d850-0bb5a764f17a@cogentembedded.com>
Date:   Thu, 20 Jun 2019 11:53:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190619133128.2259960-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 19.06.2019 16:31, Arnd Bergmann wrote:

> On 32-bit architectures, we cannot easily device 64-bit numbers:

    s/device/divide/?

> ERROR: "__aeabi_uldivmod" [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
> 
> Use do_div() to annotate the fact that we know this is an

    div_u64() really?

> expensive operation.
> 
> Fixes: 992aa864dca0 ("mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> index 2a9bbc90225e..618e329e1490 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> @@ -87,7 +87,7 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
>   	u32 next_sec;
>   	int err;
>   
> -	next_sec = nsec / NSEC_PER_SEC + 1;
> +	next_sec = div_u64(nsec, NSEC_PER_SEC) + 1;
>   	next_sec_in_nsec = next_sec * NSEC_PER_SEC;
>   
>   	spin_lock(&clock->lock);

MBR, Sergei
