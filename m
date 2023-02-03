Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E292A689302
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjBCJCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjBCJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:02:15 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BB9903B6
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:02:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hx15so13400918ejc.11
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5MQHO8EKwJIsLFg/g3UDWTz/OV1D9yhCMi3EQYhYwsY=;
        b=Bvy2tDpDM7BPHd0pjF/vFeJDhNGndCGkHd2Ms3/ge60h+Jkj90CVosOIR4WCV2+AV8
         gA0F+UI+2mOJKmrSsm/Y6KHNR6j+EXIlsscMk3FMbkNvqBmjKfu+na/NgO2JVKQ5CwmF
         QZYepNxfiJQc2cD9lVLHRTHvFMU5e8tOvwcdDnii+VqTxVy4geLUNir3DvvcpNZ/gclz
         5oOKFAsAmByvg1EoEZ8fvZZWX3y9QSEE+HMLL76feba8p2S8Q0smk6M+TqdoGFYB0MzX
         fCD9+oqapEmkl+0/Jm/GhSTFXgRZ6m5WyQqXTxuqbgUhMt2xQaOvMzejArkmGfiaoZVj
         zAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MQHO8EKwJIsLFg/g3UDWTz/OV1D9yhCMi3EQYhYwsY=;
        b=j9CGe/+fKiMwhcEAuTeiAKXeCRgecg6EmNKMZQz7egbx5pxWNbs9o0LPgpeQVm6vvV
         Y8nck1JbhxKZO6yT4jUQFp6FsBef+Juzz7g65VlCGUCys3mlzpZ2GCI3M43g0tN4Or+w
         cG9MeEPeL3c8Xedl/a43Mwz9JOMBBs+eqGeaswU5Hf0EO38laR0ICoBHHeotNk8BarhT
         HvssKYzhpzXcDRsno7lTg5WjrLPKRaAxl5HDs/1Cdu6AtKEWIjJqtn4eYY8jWegdrnNa
         EAxKbz2ABNm+yRVTgsTitO1bBmMt/g3RglFQIOx8urEOgeeO3QVpTIZfO2AnOldJ0QnK
         zOiw==
X-Gm-Message-State: AO0yUKXT828YlsQROrl7odeN2/8bK+O61zlP6cntzDmXSKWX1aMaJhw6
        YbCDHpkwhlbAi8AeSQFonYBtaQ==
X-Google-Smtp-Source: AK7set8i9W1eVLgP1NwUzguoUoDCmMC0ppgYX5yfRdFSp2qI0Y808uExcngzQO/WTFmbsRZvzsaJgA==
X-Received: by 2002:a17:906:e20a:b0:878:6da5:bf75 with SMTP id gf10-20020a170906e20a00b008786da5bf75mr9035312ejb.35.1675414932851;
        Fri, 03 Feb 2023 01:02:12 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t4-20020a170906268400b0087bda70d3efsm1065754ejc.118.2023.02.03.01.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 01:02:12 -0800 (PST)
Message-ID: <6a8a5a6f-a5f2-976d-e747-362e44222a1d@blackwall.org>
Date:   Fri, 3 Feb 2023 11:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 08/16] net: bridge: Add netlink knobs for
 number / maximum MDB entries
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
 <ad5b9a4a971f7a38951cb8475ca3c9a16057b0fd.1675359453.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ad5b9a4a971f7a38951cb8475ca3c9a16057b0fd.1675359453.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 19:59, Petr Machata wrote:
> The previous patch added accounting for number of MDB entries per port and
> per port-VLAN, and the logic to verify that these values stay within
> configured bounds. However it didn't provide means to actually configure
> those bounds or read the occupancy. This patch does that.
> 
> Two new netlink attributes are added for the MDB occupancy:
> IFLA_BRPORT_MCAST_N_GROUPS for the per-port occupancy and
> BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS for the per-port-VLAN occupancy.
> And another two for the maximum number of MDB entries:
> IFLA_BRPORT_MCAST_MAX_GROUPS for the per-port maximum, and
> BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS for the per-port-VLAN one.
> 
> Note that the two new IFLA_BRPORT_ attributes prompt bumping of
> RTNL_SLAVE_MAX_TYPE to size the slave attribute tables large enough.
> 
> The new attributes are used like this:
> 
>  # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
>                                       mcast_vlan_snooping 1 mcast_querier 1
>  # ip link set dev v1 master br
>  # bridge vlan add dev v1 vid 2
> 
>  # bridge vlan set dev v1 vid 1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
>  # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
>  Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.
> 
>  # bridge link set dev v1 mcast_max_groups 1
>  # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
>  Error: bridge: Port is already in 1 groups, and mcast_max_groups=1.
> 
>  # bridge -d link show
>  5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
>      [...] mcast_n_groups 1 mcast_max_groups 1
> 
>  # bridge -d vlan show
>  port              vlan-id
>  br                1 PVID Egress Untagged
>                      state forwarding mcast_router 1
>  v1                1 PVID Egress Untagged
>                      [...] mcast_n_groups 1 mcast_max_groups 1
>                    2
>                      [...] mcast_n_groups 0 mcast_max_groups 0
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v3:
>     - Move the br_multicast_port_ctx_vlan_disabled() check
>       out to the _vlan_ helpers callers. Thus these helpers
>       cannot fail, which makes them very similar to the
>       _port_ helpers. Have them take the MC context directly
>       and unify them.
>     
>     v2:
>     - Drop locks around accesses in
>       br_multicast_{port,vlan}_ngroups_{get,set_max}(),
>     - Drop bounces due to max<n in
>       br_multicast_{port,vlan}_ngroups_set_max().
> 
>  include/uapi/linux/if_bridge.h |  2 ++
>  include/uapi/linux/if_link.h   |  2 ++
>  net/bridge/br_multicast.c      | 15 +++++++++++++++
>  net/bridge/br_netlink.c        | 17 ++++++++++++++++-
>  net/bridge/br_private.h        |  6 +++++-
>  net/bridge/br_vlan.c           | 11 +++++++----
>  net/bridge/br_vlan_options.c   | 27 ++++++++++++++++++++++++++-
>  net/core/rtnetlink.c           |  2 +-
>  8 files changed, 74 insertions(+), 8 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


