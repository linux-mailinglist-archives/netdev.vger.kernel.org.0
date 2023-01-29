Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70E67FDE5
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjA2Jky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjA2Jkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:40:53 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7934199C5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:40:52 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mc11so1734156ejb.10
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eddf/OwrN8syk9SCGChlswO63H1xILMxSP4jGfFBdTU=;
        b=k2XO9gHmWZEtvHEcfqAHyteQULMTseCOzFrDVkM2O8JH5utOTj6auuhblgX2LU4+Hl
         w+5FYPcwaxvBfeUx3pfPyUQc+PxZisXva8dEZQ95KY3fLirIbKgE+4FUz4lrSGIkKwXy
         uXWEJ1U0WB5QKlBO8yCT2ra0G2I1JCi0qHm8feObzovgUUDvcXhBs7KAzZGzKIXY8wER
         DUxdgri1f9nxpyjky16TtAiu6kYDSgqZP73r8ReY6cZq5urblcua6x67t5AzO6SoQso2
         5kKa9Vs6S84HDJEh06W1wjVgpudQqfGfe56zU0iNC7xzfx58n+C3d1SjJWCjbetcneEY
         n45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eddf/OwrN8syk9SCGChlswO63H1xILMxSP4jGfFBdTU=;
        b=eUF1UWIJiXZwpic3YL4nlIdySKJYZnaa74Q62P71b9MyUYyksktnjS/wenNMHs8vgd
         xPO1J0ocO5crJbE/3223NUeejor/8/sH05tpXmIc3ADGY+oH2atmEo++3b8hQX3wwkuk
         OXmRG7pJU+wGpsfuD2pucn8U1CPY20gS8otjS+DnXVyUEDpmNYRK+65skzn7KJ43LVp9
         YvDeAw5IClHiTSpqlR9qK9ypOn1X+90T0UTtKe0IJuG6lf2ERx9XvzypyhKDJXCRBqQf
         QD92vUuHoBcNVrOkGYEexMe62Xsnn+VJ2C8jxfbUDNfI1rKjb3J6QQppAYaCuGLtbcDu
         NLdQ==
X-Gm-Message-State: AFqh2kpvBR1t+i6CpsYF+WSn/qg3EWdlcIceKd31g8bNLHTT/wr38wU0
        SLKOoeWUB7A4033GNQ0suwpDiw==
X-Google-Smtp-Source: AMrXdXsBVgYMsgJQOriYF103odV/kWrthgNsPt4JKWebeUgn6xwBThNMMVlk1Ibbq4PNWDipGc5tdg==
X-Received: by 2002:a17:907:88c4:b0:86d:d041:b8aa with SMTP id rq4-20020a17090788c400b0086dd041b8aamr50189727ejc.27.1674985251084;
        Sun, 29 Jan 2023 01:40:51 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id ac7-20020a170907344700b00881c40ceffasm2321547ejc.112.2023.01.29.01.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:40:50 -0800 (PST)
Message-ID: <8a31500e-7376-618b-69a8-b8dee3a6899e@blackwall.org>
Date:   Sun, 29 Jan 2023 11:40:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 07/16] net: bridge: Maintain number of MDB
 entries in net_bridge_mcast_port
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <1dcd4638d78c469eaa2f528de1f69b098222876f.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1dcd4638d78c469eaa2f528de1f69b098222876f.1674752051.git.petrm@nvidia.com>
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

On 26/01/2023 19:01, Petr Machata wrote:
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
> Note that the per-port-VLAN mcast_max_groups value gets reset when VLAN
> snooping is enabled. The reason for this is that while VLAN snooping is
> disabled, permanent entries can be added above the limit imposed by the
> configured maximum. Under those circumstances, whatever caused the VLAN
> context enablement, would need to be rolled back, adding a fair amount of
> code that would be rarely hit and tricky to maintain. At the same time,
> the feature that this would enable is IMHO not interesting: I posit that
> the usefulness of keeping mcast_max_groups intact across
> mcast_vlan_snooping toggles is marginal at best.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_multicast.c | 131 +++++++++++++++++++++++++++++++++++++-
>  net/bridge/br_private.h   |   2 +
>  2 files changed, 132 insertions(+), 1 deletion(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

