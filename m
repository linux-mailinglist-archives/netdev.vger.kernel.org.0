Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0C217F11
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgGHF0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHF0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 01:26:52 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5C9C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 22:26:52 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d194so17736023pga.13
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 22:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZH1oNxYlroOMdlZigCIOZepS0C+vxs6N4dX/LN9MkP4=;
        b=sMzfLBCigtH0rHImJ1jEP1FE6p13Cjkcj2IH/voKBguC3Jx9Q+LjQC9x4TxivSoXug
         XJTvO0GfmqmXMlYT4f0JUm/GYNznlL7spDici8RArmJMQtf8ryy+Jb3q2AnBfFfrHpwE
         eYE0WiKvWYXUneC+g28fj1JTBcTLUIzfMEaMy/ehg5JRLiQjGgqe3pus7hDwmVALWZg7
         11n4GtJNegFJ3+rbRVJu3hX8dSnI5NaLvwQ/RHlU4x3GQ/y3Yd6u4JOc4XiurzaPIyq7
         9tbPEv6QuXYbNcmYeYtd6rxlhVCwz/VJB4dSOXJRT2GCz5DXy+6JiJ3YxmGpygjUaEUp
         Q9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZH1oNxYlroOMdlZigCIOZepS0C+vxs6N4dX/LN9MkP4=;
        b=tavz+0hPNqzKt6tRKw11KD1g9W87FpRSwPuEUQGt5tlOtQ6vGjgp/RGbsvtgv4CIrG
         1cpuo/GooKM8HTO3eeWd4tnwWN25QkVRhJl7cVhSRHbjM4B5qgeoc2cB1DBaDrbPqlCk
         ITKSxVM41DmvgzdpK1JyFSbsaCGxmpRF8MSVtACGsTBJOfphPqZgmxSvXz7Fyq8adElQ
         ugKjBowF9OEliUElfmB2Mv3EEWkE80dpKzyWaV+NJHNI+h9ykFc0hV5J+iHCK17RUoI7
         VsiGLuOXZJqgZwarnHxciahit2Myhi+EbUeUcs9slOj/LB5iAaxT69vO/VZ5AvqGS0Uz
         N3qQ==
X-Gm-Message-State: AOAM5302ZQPakCiB8BifaDg7AShq+/oUH69GFS+rcwrxPOrtIDZJkmuv
        HGOi4h2g/x8744IkeLdQTaQ=
X-Google-Smtp-Source: ABdhPJz2lwAlKsLBriKk1pUJd8+GNBvXD75KTL5sXh882ov8Xqx54tmh4X0WEF94J7NgSDvTy+222Q==
X-Received: by 2002:a63:6e0e:: with SMTP id j14mr46089509pgc.384.1594186011852;
        Tue, 07 Jul 2020 22:26:51 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q24sm21534305pfg.34.2020.07.07.22.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 22:26:51 -0700 (PDT)
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to
 NETIF_F_SOFTWARE_GSO
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <96a4cb06-c4d2-2aec-2d63-dfcd6691e05a@gmail.com>
Date:   Tue, 7 Jul 2020 22:26:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 8:48 PM, Huazhong Tan wrote:
> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with


s/NETIF_F_SOFTWARE_GSO/NETIF_F_GSO_UDP_L4/

> a software fallback.  This allows UDP GSO to be used even if
> the hardware does not support it, and for virtual device such
> as VxLAN device, this UDP segmentation will be postponed to
> physical device.

Is GSO stack or hardware USO able to perform this segmentation,
with vxlan (or other) added encapsulation ?

What about code in net/core/tso.c (in net-next tree) ?

> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  include/linux/netdev_features.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 2cc3cf8..c7eef16 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -207,7 +207,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>  				 NETIF_F_FSO)
>  
>  /* List of features with software fallbacks. */
> -#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | \
> +#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | NETIF_F_GSO_UDP_L4 | \
>  				 NETIF_F_GSO_SCTP)
>  
>  /*
> 
