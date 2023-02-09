Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C21690204
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBIISw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBIISu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:18:50 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9E2367E4
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:18:49 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ml19so4138777ejb.0
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IBa8E8PwdjPXkRzD62dAtTjcrA6uST3bjufU3dsZCM8=;
        b=MTowCXDFtV7Xj5ue9879TT9Ap06V2DgRQCk6nXhSg7BXGP8l+/WIriZaVT/18QfdHS
         rTarGG0ojyrm+D6hvNUcqiQCXhn+hj659/cNhvbAGfsqSdMpDP9Ko1mymtolpS+Mp1If
         OJBKTYFg1B5enmxCb1kiHyxEBogWKsKxYaeV1tbGcVH4aMqCgZe3nwivuco7+vER6BK2
         r0SoBcatNMVKT9q9+lNsijM+kAgF1drigZLr4FRaFDidI4YNyc92L0rieAo8cJ88hhCq
         QqGZRFreCbCmDG+Auz9oV+IHq1z4+IvJmm0sBDHHjjGJXbhSLsUo8GpBpPJsUGI35DgR
         wRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBa8E8PwdjPXkRzD62dAtTjcrA6uST3bjufU3dsZCM8=;
        b=qnkpbd38TFyeKe1J98OIRxquROlmUBwRy/BbDr/8bMdjZ8BDBgr0MHxgWFYfn9fgLx
         n7ZMQ3hKGtZbXS1DAM1YRTMQ3r1PgmXLaehR63IzuYYSOQxxFmAAy229KpEOplakJ/QP
         bxaG0YLvNmI27bNKN1/lLFpG6CBWP/cSj1mOoWZPiHGnYPqRCtkeSZyHraUNm3GyQi3V
         qzHgFoUQOh29txuLdQTd9XStiN3bqox1eUWzZO8uhudfCfZHjw5MlyYCBBu+WJVHCTRK
         hmOxuI+DPjig5Lw2fyTFG7d6rAKmx0AHsduzmp+l/JpbbswCePKlpRzncB/BDnxl3Tw9
         YIog==
X-Gm-Message-State: AO0yUKU91hsdpaN7AlxCQqjIy8leh+TRwszMcQ/yLnsJqIEyoHtE7PYy
        g1/w6b7Z48p25Jn5S8/x0NVmjg==
X-Google-Smtp-Source: AK7set/rad4+n8saJlUdFRl0dHukZZ7p5+4oK5g/WwUNtI5VOeALPMcpxqYqS8Idh7FWYHocoHU/Yw==
X-Received: by 2002:a17:907:6d05:b0:87b:6bbb:11ac with SMTP id sa5-20020a1709076d0500b0087b6bbb11acmr14726084ejc.60.1675930728285;
        Thu, 09 Feb 2023 00:18:48 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906c01400b008ae3324c8adsm548507ejz.214.2023.02.09.00.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:18:48 -0800 (PST)
Message-ID: <48be3497-7c8f-ac73-0760-a8b1125ab2ab@blackwall.org>
Date:   Thu, 9 Feb 2023 09:18:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 1/4] bridge: mcast: Use correct define in MDB
 dump
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230209071852.613102-1-idosch@nvidia.com>
 <20230209071852.613102-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230209071852.613102-2-idosch@nvidia.com>
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
> 'MDB_PG_FLAGS_PERMANENT' and 'MDB_PERMANENT' happen to have the same
> value, but the latter is uAPI and cannot change, so use it when dumping
> an MDB entry.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   net/bridge/br_mdb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 9f22ebfdc518..13076206e497 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -259,7 +259,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
>   #endif
>   	} else {
>   		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
> -		e.state = MDB_PG_FLAGS_PERMANENT;
> +		e.state = MDB_PERMANENT;
>   	}
>   	e.addr.proto = mp->addr.proto;
>   	nest_ent = nla_nest_start_noflag(skb,

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
