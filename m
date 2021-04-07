Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF05357806
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDGWz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDGWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:55:56 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33262C061760;
        Wed,  7 Apr 2021 15:55:46 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so399699oty.12;
        Wed, 07 Apr 2021 15:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zJJBRBmoNh7AVevPubo0Tlu6DWii+4e8891pEEDBHjI=;
        b=tYauJZsY/gR3rIUod4Y0oKs0ALsaWOKRQ/SVZ7eFqKJptKQns6rV+TMnmCxDCSgR0H
         wuBShPAAsZ+dybrCY9cNbTsyvDfhhF3dNKfo4gWE9xw9ni4Y5LTj9eFeFDSM44Aq+jyU
         H9fPWaWDqDANyHBpHTon8b8RDhsmT4jFZpNMt4c7q/AbzfW6bwtxZM0IhhnF/wNLrGHL
         1UekFF0WctXYmnmziZN/kBHmEG4UP2LQmV0+LUDOmUIHy316lvT14QsoXUewotjznTYz
         Bc86xajkEV+AewzsPoza9BQHW4EtlUc4sXS/eyX1QkPoVJoDO8DmYbXRyGyvqYHKBOOq
         aWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJJBRBmoNh7AVevPubo0Tlu6DWii+4e8891pEEDBHjI=;
        b=qAA4TzOynEBVrOtYhEGTdmNo1tNoRCtQQjiGR0Q28ms07BNFL0Zta0iPvaRRPcbq90
         vHzQSUBNM1XI5QERR1Lkp48rrh3Bj6WBEG3HzYPHftrg+4x2c2hQ9Ep9CZ8O2ev/kuUt
         UDfxZPFhfZtslJE8CRKsIIVp19ayYEZSokPaNngu/xww4tIkQjVEym5OSis91CcdMSK2
         AcClJkYqRTFC0HyqoefDVeFwOPKR5wjTPpbqiTA76XQeGeIyhycDzFNPayMw8nSXFonH
         3SlsZgVwo961xRZFNfOd1Lhq+8Kr7Imhc3hZjZsBy+NFBpKnKPN33fGMLDDLsHA793Og
         GFGA==
X-Gm-Message-State: AOAM530LKnrdgFrQFyihY88vbnzR3FzfUvVtKpdQ/IC79hw8+ZsBUQFK
        LU6ApjCLoW+vlG4KmDnRW1o=
X-Google-Smtp-Source: ABdhPJysmR1+19ZGEMyK6LNwk3NCDthz5dXudt+ttQYbA3zcKzmGwlqSOOqSPfEQULFC6h0oxGXShw==
X-Received: by 2002:a9d:1c7:: with SMTP id e65mr4879178ote.259.1617836145665;
        Wed, 07 Apr 2021 15:55:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id 3sm5156627ood.46.2021.04.07.15.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 15:55:44 -0700 (PDT)
Subject: Re: [RFC net-next 1/1] seg6: add counters support for SRv6 Behaviors
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
 <20210407180332.29775-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26222d31-2a27-c250-97e2-9220c098d836@gmail.com>
Date:   Wed, 7 Apr 2021 16:55:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407180332.29775-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/21 12:03 PM, Andrea Mayer wrote:
> diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> index 3b39ef1dbb46..ae5e3fd12b73 100644
> --- a/include/uapi/linux/seg6_local.h
> +++ b/include/uapi/linux/seg6_local.h
> @@ -27,6 +27,7 @@ enum {
>  	SEG6_LOCAL_OIF,
>  	SEG6_LOCAL_BPF,
>  	SEG6_LOCAL_VRFTABLE,
> +	SEG6_LOCAL_COUNTERS,
>  	__SEG6_LOCAL_MAX,
>  };
>  #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
> @@ -78,4 +79,11 @@ enum {
>  
>  #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
>  
> +/* SRv6 Behavior counters */
> +struct seg6_local_counters {
> +	__u64 rx_packets;
> +	__u64 rx_bytes;
> +	__u64 rx_errors;
> +};
> +
>  #endif

It's highly likely that more stats would get added over time. It would
be good to document that here for interested parties and then make sure
iproute2 can handle different sized stats structs. e.g., commit support
to your repo, then add a new one (e.g, rx_drops) and verify the
combinations handle it. e.g., old kernel - new iproute2, new kernel -
old iproute, old - old and new-new.

