Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329676EDBE7
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 08:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjDYGsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 02:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjDYGst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 02:48:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C561AF32
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:48:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94a34a0b9e2so770180366b.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1682405303; x=1684997303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=frqIWmuMsnJvpTcv8b277P5yYXqZQL8XU5GL+4yig8s=;
        b=LCS5VEalN6bq7xzObS8UVm99RhpRCrT0NgpHR3OL+yR0lZIk3Ai4NIpfb84J7nehef
         FyXq9ldzgZfHsJ2zEpcYIx+pXo9wow27yZnpJgaM/AuX/gaMimoEH5quDNe7rtY1DkUH
         BjzNz+QYjV5FPoDPQMvTGna9oSX/yIO74qp86pxtjtp/W4ISJA2gjXb1fa+NUTlxoMpr
         +UerD8eWsOwhvwHfpW4X3RNiYJ+GXq0rizEVkusgoo1Sp+f0MOzAwRXY9vZtWDZ9gMcz
         QcNZbHEHhWeo8wQUs6i4Pr/8lTOrdYawCGFw/b6hN4dwtQ/uLam3FnB5CJ65WmIzUMbp
         lnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682405303; x=1684997303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frqIWmuMsnJvpTcv8b277P5yYXqZQL8XU5GL+4yig8s=;
        b=FXivuMFrzTNHd8gXCXegsVj77O7uUgNG4ap3QeMo9bjSBhXSzM2EEP9RiMPmGSKyJZ
         o3TX3V+YxZNM9BmczzYfcPj5KLSANqvJnySZNqHgmQ+LzfodENnD1aVTeXmXhr7n1nQh
         MNBHG3td9WPpvGJtBCd2AWFBG04RswOr0kjmV7Rz0bVfdFzBIQgd2xT5WEtzhz8isqTi
         +UUiwIGz5Kq9xLfUR0IxW1ChV3Hdq/z0RrxmyhRXT3EY7pulaL3kiRS9MyArb/Voj1xz
         bkaYFqIyjDnW1EBlGAfgN+iX0dbPZ4jwTP181yOe3OurPWLl3DyS0pmwAvnmlS8RQiSE
         LJZw==
X-Gm-Message-State: AAQBX9cFpZXocvd/AXfYaubhG6PvpxufwZuweD1XRo2I8iN3/Y7E4nBc
        aIAzQF0Gf79TrZtuwouwj9Yw2w==
X-Google-Smtp-Source: AKy350bH4REkDOHjXNQ7QqnNigt9XyYoDlqKghWZnmgdiOezt4XtLGqtUtOGNizyVjqi+p5T4hZsuA==
X-Received: by 2002:a17:906:ad81:b0:94f:2eb1:ffd2 with SMTP id la1-20020a170906ad8100b0094f2eb1ffd2mr11946449ejb.40.1682405302777;
        Mon, 24 Apr 2023 23:48:22 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090610c800b0093313f4fc3csm6381106ejv.70.2023.04.24.23.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 23:48:21 -0700 (PDT)
Message-ID: <32d0ce60-f79d-82d9-783f-89e190986ec6@blackwall.org>
Date:   Tue, 25 Apr 2023 09:48:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next 2/2] bridge: link: Add support for
 neigh_vlan_suppress option
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, liuhangbin@gmail.com
References: <20230424160951.232878-1-idosch@nvidia.com>
 <20230424160951.232878-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230424160951.232878-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2023 19:09, Ido Schimmel wrote:
> Add support for the per-port neigh_vlan_suppress option. Example:
> 
>  # bridge link set dev swp1 neigh_vlan_suppress on
>  # bridge -d -j -p link show dev swp1
>  [ {
>          "ifindex": 62,
>          "ifname": "swp1",
>          "flags": [ "BROADCAST","NOARP","UP","LOWER_UP" ],
>          "mtu": 1500,
>          "master": "br0",
>          "state": "forwarding",
>          "priority": 32,
>          "cost": 100,
>          "hairpin": false,
>          "guard": false,
>          "root_block": false,
>          "fastleave": false,
>          "learning": true,
>          "flood": true,
>          "mcast_flood": true,
>          "bcast_flood": true,
>          "mcast_router": 1,
>          "mcast_to_unicast": false,
>          "neigh_suppress": false,
>          "neigh_vlan_suppress": true,
>          "vlan_tunnel": false,
>          "isolated": false,
>          "locked": false,
>          "mab": false,
>          "mcast_n_groups": 0,
>          "mcast_max_groups": 0
>      } ]
>  # bridge -d link show dev swp1
>  62: swp1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
>      hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off neigh_suppress off neigh_vlan_suppress on vlan_tunnel off isolated off locked off mab off mcast_n_groups 0 mcast_max_groups 0
> 
>  # bridge link set dev swp1 neigh_vlan_suppress off
>  # bridge -d -j -p link show dev swp1
>  [ {
>          "ifindex": 62,
>          "ifname": "swp1",
>          "flags": [ "BROADCAST","NOARP","UP","LOWER_UP" ],
>          "mtu": 1500,
>          "master": "br0",
>          "state": "forwarding",
>          "priority": 32,
>          "cost": 100,
>          "hairpin": false,
>          "guard": false,
>          "root_block": false,
>          "fastleave": false,
>          "learning": true,
>          "flood": true,
>          "mcast_flood": true,
>          "bcast_flood": true,
>          "mcast_router": 1,
>          "mcast_to_unicast": false,
>          "neigh_suppress": false,
>          "neigh_vlan_suppress": false,
>          "vlan_tunnel": false,
>          "isolated": false,
>          "locked": false,
>          "mab": false,
>          "mcast_n_groups": 0,
>          "mcast_max_groups": 0
>      } ]
>  # bridge -d link show dev swp1
>  62: swp1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
>      hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off neigh_suppress off neigh_vlan_suppress off vlan_tunnel off isolated off locked off mab off mcast_n_groups 0 mcast_max_groups 0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/link.c            | 19 +++++++++++++++++++
>  ip/iplink_bridge_slave.c | 10 ++++++++++
>  man/man8/bridge.8        |  8 ++++++++
>  man/man8/ip-link.8.in    |  8 ++++++++
>  4 files changed, 45 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


