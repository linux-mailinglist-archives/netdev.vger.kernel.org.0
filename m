Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230E7690207
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBIITF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjBIITD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:19:03 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33C838020
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:19:02 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u21so1460028edv.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OScVKXBFx0PGgNxDsW0PI1/fpjTd06DrYTq/VBuYPDo=;
        b=3wdeSMrsOlQbCU0LGgDZBIDA9jEsyURuUKe3Lg6q6xWd8Pc/G9xmy85O7u1troTO8J
         YirhL8X9T7NBSRsRX+aDCwlGcXrHwWQzAGppBJAsedYuVYfMX+gbulfqS/Lb68/Xgd1P
         jSenRPB3//w2ckzFLw9iUpgReHF4NeBvMLpuayq0D/GAuduuMATMBjrYYsGKD7SZYHLy
         ScqByJb1Eg+hpYbQntj6/4OicwqRkiahzjA5VetgJ1nHAslk0Ry/iwXTdevvx+KtWVh9
         zLcJDiTB5x5C58zONjba+pvPA49bBFh6mTiQsT94axpLwROMefcIpO6RXP9jUV/qHYyg
         sT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OScVKXBFx0PGgNxDsW0PI1/fpjTd06DrYTq/VBuYPDo=;
        b=y1D/5nsfCW7HoAewVW4fI3YGP0d+KO9XRXKfd7mlzr1RxooKdf4mec7nq3O9BLBRwj
         xNz7IMXUGVQsnLM9akg1TWuU8PBYlU9BxK6xhPFM+moll8/dHuIZ5izDmXcQCXB7282F
         hugDoyrDKRdRzhQHZLpWK75YqSZraoL9bZE3UJdQbGIsGkFYwyMJo9pXIxoQzT6fix68
         JTv4tKGPiMx7FkVTWsieMcWb7xy1kfEMzBSt59RCyIFOPe4umfKENkkYxnEu84PiqpMV
         lp6M1KbGiQvTTVFTyZsN94UNdKTfF9EyenJ8BmXPZHQICS/+mmS7sH3yxFPHdS0i0S84
         TyVQ==
X-Gm-Message-State: AO0yUKVp9hQHw5nGLWCUrivkzF7Xwwnu2y+x+Ia8C2EVVDiXsWsMgNzc
        TrqV9bIW9u1xGNRJzy4S4GYjuw==
X-Google-Smtp-Source: AK7set+g6tO8/TJD+Q8qvYJ90JjmZ0arZaNag0sOGb3E8WY8ptLpf3/+m2g3+wMeu5wIGv8ccs1TNg==
X-Received: by 2002:a50:d642:0:b0:4ab:e03:661f with SMTP id c2-20020a50d642000000b004ab0e03661fmr5722435edj.15.1675930741507;
        Thu, 09 Feb 2023 00:19:01 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id c90-20020a509fe3000000b004ab16843035sm403977edf.80.2023.02.09.00.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:19:01 -0800 (PST)
Message-ID: <ca8740bc-0c72-efd9-670e-617dfd46f0f6@blackwall.org>
Date:   Thu, 9 Feb 2023 09:19:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 2/4] bridge: mcast: Remove pointless sequence
 generation counter assignment
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230209071852.613102-1-idosch@nvidia.com>
 <20230209071852.613102-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230209071852.613102-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 09:18, Ido Schimmel wrote:
> The purpose of the sequence generation counter in the netlink callback
> is to identify if a multipart dump is consistent or not by calling
> nl_dump_check_consistent() whenever a message is generated.
> 
> The function is not invoked by the MDB code, rendering the sequence
> generation counter assignment pointless. Remove it.
> 
> Note that even if the function was invoked, we still could not
> accurately determine if the dump is consistent or not, as there is no
> sequence generation counter for MDB entries, unlike nexthop objects, for
> example.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   net/bridge/br_mdb.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 13076206e497..96f36febfb30 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -421,8 +421,6 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
>   
>   	rcu_read_lock();
>   
> -	cb->seq = net->dev_base_seq;
> -
>   	for_each_netdev_rcu(net, dev) {
>   		if (netif_is_bridge_master(dev)) {
>   			struct net_bridge *br = netdev_priv(dev);


Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
