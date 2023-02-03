Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525956892EE
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjBCI7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjBCI73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:59:29 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74FB8DAE2
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:59:28 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ml19so13622261ejb.0
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ni5qRfYvZFsymzma6ZOjk3L3LwaxH0Q0qj+WSjXryNg=;
        b=lzyKKlVfBtu4E19a5HXbvOlfH03T7LO7t0w24toNmp+P5tRXo/J1JTSr666Si1hjeu
         QewnfPtAIwMewEUWV5YSdGUJ+xbY7n6PNYkU5VJW0zg2eO/LlqMREb1nYLOMZ6MIAakH
         ETaHXxw+26Guc/nf1Ppv4PSsLXC464TCdE+OV74e3X/nLcBOX6MmmncTtPkhX2WqzwGP
         9PeJdp0+cptUGcZKEunPL7SZPKLafezyvnAWWmELGlmqCJvBXGRB05cAGK0DqifrfIOO
         q2JH+p2td6gCBElGkavGzvMZJD7dxAQCyobfMqvL4KiYj74mYZXqh0zRHN9xjPUMx19U
         a2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ni5qRfYvZFsymzma6ZOjk3L3LwaxH0Q0qj+WSjXryNg=;
        b=t+Cr3FX5lcuw2UjAp7pzYs21kT649RFYgn8whoQRc9iVKZC0fI3PKm2TnWFsPbhM2D
         t7mtlKHskX7tUnNwOJSZ8MKthexedxZOCJ0j2UP/J4i7QHYx2+LIPZXU7QJFAmDOt4EF
         jVtBcIEogLNzaDHPhSpS0Zmrj9vBO1m7Nkr8CSLXzccVbTIbsrnaSa8nSWgr/dRNkN6t
         tKnVcmQWgyKxCPGi7kEojJbv2QXbSm2l+rkm83MwICYWzaE/I16sRxQ0Bx1VmZJaoigV
         IFMuodcXbPUXyWBO8qFj7KMrarHO7fgB2KhEpLhs+cwLO4OQMpx4YQmiMdpHXL2Q7zKr
         l70g==
X-Gm-Message-State: AO0yUKU9e6WZNu+dogenwi9gyH2pVLrWh4u8aWPj8oxQptDAQZaLFnyI
        VkfQnfbxz+zltAnQlVtGJ9jtoQ==
X-Google-Smtp-Source: AK7set9g432vmHMY9Ns9HgsIN+8sKJ+ZB53CcXne2Im12s/0JaCR62pSSz2IqOkNuruiFUscCjEG1g==
X-Received: by 2002:a17:906:230f:b0:844:d342:3566 with SMTP id l15-20020a170906230f00b00844d3423566mr8840529eja.22.1675414767094;
        Fri, 03 Feb 2023 00:59:27 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709063b8a00b0088b93bfa782sm1075535ejf.176.2023.02.03.00.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 00:59:26 -0800 (PST)
Message-ID: <fb2a9ee9-ff66-3590-9aa9-88f5b037d786@blackwall.org>
Date:   Fri, 3 Feb 2023 10:59:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 07/16] net: bridge: Maintain number of MDB
 entries in net_bridge_mcast_port
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
 <8bd6e90beed928790059134471ecbb9c3d327894.1675359453.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <8bd6e90beed928790059134471ecbb9c3d327894.1675359453.git.petrm@nvidia.com>
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
> The MDB maintained by the bridge is limited. When the bridge is configured
> for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
> capacity. In SW datapath, the capacity is configurable through the
> IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
> similar limit exists in the HW datapath for purposes of offloading.
> 
> In order to prevent the issue of unilateral exhaustion of MDB resources,
> introduce two parameters in each of two contexts:
> 
> - Per-port and per-port-VLAN number of MDB entries that the port
>   is member in.
> 
> - Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
>   per-port-VLAN maximum permitted number of MDB entries, or 0 for
>   no limit.
> 
> The per-port multicast context is used for tracking of MDB entries for the
> port as a whole. This is available for all bridges.
> 
> The per-port-VLAN multicast context is then only available on
> VLAN-filtering bridges on VLANs that have multicast snooping on.
> 
> With these changes in place, it will be possible to configure MDB limit for
> bridge as a whole, or any one port as a whole, or any single port-VLAN.
> 
> Note that unlike the global limit, exhaustion of the per-port and
> per-port-VLAN maximums does not cause disablement of multicast snooping.
> It is also permitted to configure the local limit larger than hash_max,
> even though that is not useful.
> 
> In this patch, introduce only the accounting for number of entries, and the
> max field itself, but not the means to toggle the max. The next patch
> introduces the netlink APIs to toggle and read the values.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v3:
>     - Access mdb_max_/_n_entries through READ_/WRITE_ONCE
>     - Move extack setting to br_multicast_port_ngroups_inc_one().
>       Since we use NL_SET_ERR_MSG_FMT_MOD, the correct context
>       (port / port-vlan) can be passed through an argument.
>       This also removes the need for more READ/WRITE_ONCE's
>       at the extack-setting site.
>     
>     v2:
>     - In br_multicast_port_ngroups_inc_one(), bounce
>       if n>=max, not if n==max
>     - Adjust extack messages to mention ngroups, now that
>       the bounces appear when n>=max, not n==max
>     - In __br_multicast_enable_port_ctx(), do not reset
>       max to 0. Also do not count number of entries by
>       going through _inc, as that would end up incorrectly
>       bouncing the entries.
> 
>  net/bridge/br_multicast.c | 136 +++++++++++++++++++++++++++++++++++++-
>  net/bridge/br_private.h   |   2 +
>  2 files changed, 137 insertions(+), 1 deletion(-)

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


