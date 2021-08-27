Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3847E3F93BE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 06:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhH0EiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 00:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhH0EiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 00:38:04 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17940C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 21:37:16 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 17so4985728pgp.4
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 21:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MP4VH0QByUbd5W7Ty/kLruORRgfA//v7nC9xITK/E6Q=;
        b=UJPqrI0rNFKtKiuhObd4FR8RoANAq42iNlrbCKVj75uxChC9lmNwvBrcYE1AeP3tHc
         eqQJe0G48rPE7cC/Hp9zRBuG+a0msQ9+XjsNCEyn5+4TePZ6sA+H6X18s9nA6uNnTuA7
         zL0yihxanvZzoVKZG+Ftv65F/jJdzc+uiCHXAMZ1gFvYsMaRZJy48RODP/GCq2aUHUzE
         rusMLBI6w9Wkw3VRIZTA1VzZ4buXh9fte2m+KebTcypNDlgEf8tjjMotAbcUP6iUh5Ab
         cJSMuOtE+F8CIgsKdOctuwSD8pKaeGmdOY1MS2gNiDDxHSuHVsCffSW/4n2uez2tANry
         vdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MP4VH0QByUbd5W7Ty/kLruORRgfA//v7nC9xITK/E6Q=;
        b=gnRm1MqSqbU48DXiKT/3DmeaqhY+7emv75gzp53B1JykO7c0nIM9NIaus4Srm/nTMh
         p2LIXCw+vsHBdq7bc2FznwSoGmgexd4FJk4rnB1Pyd8Et5HmVmBOFZBbTeW9exrsnwMN
         5ZKlnjeYHw3UFfWVH+RakG9+Gvdx8t6DshV5Ze5/BmEbSnAaTTsVug0BVS5yAly5T5G+
         8QzL6lMABsz+4cryyrzjVQrCnu6JXQVAH6WcGMN0QLOWmeEr7nVaZKemZm5hdqMICX6z
         rTByi7u1X5sBQb3YiZeIdVkUSJqRKAVsZ5XgGlQ+4C6e87/J6PhTvl9OiF9ZnFzIPKJY
         zT/g==
X-Gm-Message-State: AOAM531m64MS5A+JL4yfXOgEfivRzVysDORXr8pYfpPJRUn6bptzCqoD
        UgrtOtr/EYl+V3c/zH7F8mg=
X-Google-Smtp-Source: ABdhPJzMDAEq81UdfDfAoZJx2rCDPoecPDXu+eiYIjFNQNg2GHabdEAg5i980zxsAfUaI9/F77qxng==
X-Received: by 2002:a63:4563:: with SMTP id u35mr6207720pgk.275.1630039035567;
        Thu, 26 Aug 2021 21:37:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:647:5e00:7920:e0af:c816:c42a:733e])
        by smtp.googlemail.com with ESMTPSA id 31sm5105235pgy.26.2021.08.26.21.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 21:37:14 -0700 (PDT)
Subject: Re: Question about inet_rtm_getroute_build_skb()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>
References: <4a0ef868-f4ea-3ec1-52b9-4d987362be20@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d02bd384-526f-7b87-4c73-137f26cf8519@gmail.com>
Date:   Thu, 26 Aug 2021 21:37:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4a0ef868-f4ea-3ec1-52b9-4d987362be20@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21 6:16 PM, Eric Dumazet wrote:
> Hi Roopa
> 
> I noticed inet_rtm_getroute_build_skb() has this endian issue 
> when building an UDP header.
> 
> Would the following fix break user space ?

I do not see how. As I recall this is only for going through
ip_route_input_rcu and ip_route_output_key_hash_rcu and a call to
fib4_rules_early_flow_dissect.

> 
> Thanks.
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index a6f20ee3533554b210d27c4ab6637ca7a05b148b..50133b935f868c2ae9474eea027a0ad864a43936 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -3170,7 +3170,7 @@ static struct sk_buff *inet_rtm_getroute_build_skb(__be32 src, __be32 dst,
>                 udph = skb_put_zero(skb, sizeof(struct udphdr));
>                 udph->source = sport;
>                 udph->dest = dport;
> -               udph->len = sizeof(struct udphdr);
> +               udph->len = htons(sizeof(struct udphdr));
>                 udph->check = 0;
>                 break;
>         }
> 

