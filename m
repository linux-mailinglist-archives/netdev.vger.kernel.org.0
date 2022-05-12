Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6481525221
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356029AbiELQJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356247AbiELQJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:09:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3037D266068
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:09:44 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k126so3327224wme.2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YSfMLsONHK1LZkF9jdzD22OUrIMJ2Pr5LrAS+0ZZSOI=;
        b=Q2tNfjb5tJm5fDHFhAOL40ieN0IECQ9F5eS+sJgEXbNdfMAjR5E47ObZUDnMtepEgt
         uxJxHcBkkCcngReW69i69PwkGHuk3umiTsOEyCb2F+JtSKMjQ+HB8I70X5sleALpHbhT
         19ZNPvTpStzJAMZmlSv1eOyryq2lXLXcn8j8Kfgv5nlDwGVwSmSR8u4+RJVBS0mije1z
         FW2bBw6QfzRojy7jsFMa/tPIGW/1/ppW67wPrhBiITcmowDukYJ9O43vBSShGElSjtsD
         5ZK9SRQgkD5ktAvvsoTLIFqlh+EOQWzZMiyJ6FcmC5DKt4vfqSZHxmLmcFs8cV5nPajv
         FzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=YSfMLsONHK1LZkF9jdzD22OUrIMJ2Pr5LrAS+0ZZSOI=;
        b=NMFisFIZMWHylOnHvxNp0/FYNbw4Z1JeV6uHsHxhN64WgX/Os7NU7GXRLKlX9nK2/0
         UEjRZepWPH15G3HPlelDiS9rqLPykN5T4QAFexPbAB3NLq1VA69ZZX3UU67n5ZuECde7
         3TuENG/VfDDiIZd4ulAKK5w302MhiApaE/szCUUbXzfKogbQcF+g8GP4CX6fGPYT3Kz9
         Io9yU2mDFHvNAWmxrHRpnybMvfBc0ZzgncvFgUtBQ6sQpPa/EKJFRZ9jZ0esAWPBbSOs
         ScH8S27uZ9mydrlLlfnQmy8lQrzyrw/5EOA9/MWpjE56fvMmpHe27EkD5GtMjhwzanc2
         YnMQ==
X-Gm-Message-State: AOAM533sqK7/YhcXUx2E4X8tH967g6IT9Hoi/Fnxdx41aCCC9zsbT/wN
        zYQAYZIJSw1lr/LtNuKcki9sxA==
X-Google-Smtp-Source: ABdhPJzqJemekKe4McXmthJgrxILSuAcDzEACHdHYpRzsJ9JixeThprc+V2hOyvj/ISfm46hH916pA==
X-Received: by 2002:a05:600c:c8:b0:395:a97c:c458 with SMTP id u8-20020a05600c00c800b00395a97cc458mr512071wmm.119.1652371782727;
        Thu, 12 May 2022 09:09:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e9a5:cbdb:f85d:26c7? ([2a01:e0a:b41:c160:e9a5:cbdb:f85d:26c7])
        by smtp.gmail.com with ESMTPSA id k19-20020a05600c0b5300b003947b59dfdesm3570171wmr.36.2022.05.12.09.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:09:41 -0700 (PDT)
Message-ID: <dca644d9-aee1-9eae-19fb-b134b19827ec@6wind.com>
Date:   Thu, 12 May 2022 18:09:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: fix "disable_policy" flag use when arriving
 from different devices
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
References: <20220512104831.976553-1-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220512104831.976553-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 12/05/2022 à 12:48, Eyal Birger a écrit :
> In IPv4 setting the "disable_policy" flag on a device means no policy
> should be enforced for traffic originating from the device. This was
> implemented by seting the DST_NOPOLICY flag in the dst based on the
> originating device.
> 
> However, dsts are cached in nexthops regardless of the originating
> devices, in which case, the DST_NOPOLICY flag value may be incorrect.
> 
> Consider the following setup:
> 
>                      +------------------------------+
>                      | ROUTER                       |
>   +-------------+    | +-----------------+          |
>   | ipsec src   |----|-|ipsec0           |          |
>   +-------------+    | |disable_policy=0 |   +----+ |
>                      | +-----------------+   |eth1|-|-----
>   +-------------+    | +-----------------+   +----+ |
>   | noipsec src |----|-|eth0             |          |
>   +-------------+    | |disable_policy=1 |          |
>                      | +-----------------+          |
>                      +------------------------------+
> 
> Where ROUTER has a default route towards eth1.
> 
> dst entries for traffic arriving from eth0 would have DST_NOPOLICY
> and would be cached and therefore can be reused by traffic originating
> from ipsec0, skipping policy check.
> 
> Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
> of the DST in IN/FWD IPv4 policy checks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---

[snip]

> @@ -1852,8 +1856,7 @@ static int __mkroute_input(struct sk_buff *skb,
>  		}
>  	}
>  
> -	rth = rt_dst_alloc(out_dev->dev, 0, res->type,
> -			   IN_DEV_ORCONF(in_dev, NOPOLICY),
> +	rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,>  			   IN_DEV_ORCONF(out_dev, NOXFRM));
no_policy / DST_NOPOLICY is still needed in the dst entry after this patch?
