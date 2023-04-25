Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5EA6EDBE1
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 08:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjDYGsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 02:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjDYGsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 02:48:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C58CC01
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:47:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94f3df30043so839105266b.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1682405272; x=1684997272;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r4WWE8HXKFBPnGoE2eacPBmcXTye9ANIzC/BWWDQXRk=;
        b=Jvrzt64LKKSfbWqlyZHET+VwucFJkya9K1SuR18k0jMRyNg9tfKe5vA11oLb7I/U4L
         hhIE92Pt14tICiJ773YhRdPYd/MbL+3MfZSYF6fM/XK8T3Yu6W/fPk9F3GNuIHmPghM3
         06NmBMPRvp46Aq12xg2eei2wL/WGCIU71yipPHJRn+p+J3er0kF94AOXz6mFG61oUYLP
         Hn5/9Zyf9QOQx+oANGcBGms2NSIVkWy1OKAevsCwED+4NrbPHoQgf65BVwqZlImRrvMv
         ta/dMNPWzCNOMIMxuAvipnIyUc8igj9Z60LD5mjVF+N9t3iOzGQTD8K7ZCLqUWZVqpfm
         QQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682405272; x=1684997272;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4WWE8HXKFBPnGoE2eacPBmcXTye9ANIzC/BWWDQXRk=;
        b=Ekdco7JV+zA9q/rRdZfjazclpytMXfrNmsYbQ7/SHV9dPwTD8WFy7ODOiFirgH0Stq
         EFeicCb0nZaxRoUZF9ly/pU3nCcP9N+KlUrmOxPcr1Te1CSlRTUmskLAKbJxspO4/BQI
         gC02E960vBgqiAM6mQJHqJ3hfGIYPe1LPf/Y7WWEPIkZUrQRIqlmc8EpvCdQn9s0HTnk
         zbpra54V8YaemX11Td36RgGiUffVL3FkpB8OgmxuiD3+MGwprJjSzSv6L1CVaU/WmpOU
         2RTpZ7S1Q5X7MqCRLULFY5KmKqHZEhLH/nqQfMC6nAUIfGNUIffjTdXKM5I6X5MM4Rve
         KWcA==
X-Gm-Message-State: AAQBX9eVIeoJRTLEnYlA7DTWIFnlzgyxP8q4Lbgn860pPRmb2SEPiIqv
        hxVs7tMgjtdFqEg2LAg2Ghkb8Q==
X-Google-Smtp-Source: AKy350alP7zD6AD9rm5XvnUanxw5IQ7ejFu7stfkQWNIZ+pRKR2AzYjVrjGtQZXsp3bX9Ii43ZpCMw==
X-Received: by 2002:a17:906:cd07:b0:94a:4499:ec30 with SMTP id oz7-20020a170906cd0700b0094a4499ec30mr11958493ejb.15.1682405271583;
        Mon, 24 Apr 2023 23:47:51 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id qf22-20020a1709077f1600b0094a8aa6338dsm6467953ejc.14.2023.04.24.23.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 23:47:50 -0700 (PDT)
Message-ID: <68a2e74c-9dfc-27f0-fd3a-360e88e8b023@blackwall.org>
Date:   Tue, 25 Apr 2023 09:47:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next 1/2] bridge: vlan: Add support for
 neigh_suppress option
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, liuhangbin@gmail.com
References: <20230424160951.232878-1-idosch@nvidia.com>
 <20230424160951.232878-2-idosch@nvidia.com>
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230424160951.232878-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2023 19:09, Ido Schimmel wrote:
> Add support for the per-VLAN neigh_suppress option. Example:
> 
>  # bridge vlan set vid 10 dev swp1 neigh_suppress on
>  # bridge -d -j -p vlan show dev swp1 vid 10
>  [ {
>          "ifname": "swp1",
>          "vlans": [ {
>                  "vlan": 10,
>                  "state": "forwarding",
>                  "mcast_router": 1,
>                  "neigh_suppress": true
>              } ]
>      } ]
>  # bridge -d vlan show dev swp1 vid 10
>  port              vlan-id
>  swp1              10
>                      state forwarding mcast_router 1 neigh_suppress on
> 
>  # bridge vlan set vid 10 dev swp1 neigh_suppress off
>  # bridge -d -j -p vlan show dev swp1 vid 10
>  [ {
>          "ifname": "swp1",
>          "vlans": [ {
>                  "vlan": 10,
>                  "state": "forwarding",
>                  "mcast_router": 1,
>                  "neigh_suppress": false
>              } ]
>      } ]
>  # bridge -d vlan show dev swp1 vid 10
>  port              vlan-id
>  swp1              10
>                      state forwarding mcast_router 1 neigh_suppress off
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/vlan.c     | 18 ++++++++++++++++++
>  man/man8/bridge.8 | 11 ++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


