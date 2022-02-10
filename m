Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4E24B0847
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiBJIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:30:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiBJIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:30:32 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6A110B8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:30:33 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p24so13468998ejo.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4BAbC2SrKWiikj9sQCe8GZxvTJd08+U2hgXBpuolPto=;
        b=s8pXpBQeUNug2WzF/0ZLJCiDOoSVGmUqybFpEraPZF/lCgswGicM3tDaouz3TeHrOF
         fBsGbAotjowRZ30ET4SpUOXQgWE9T28ljK8qGn0WnjalcAZoppJweaNPqvC6QXowV8oP
         fdGNJk7/6sv/lUAIGXi/0+qClfMjGhbglUkLcjUljRKSIXvi/os3LiG3/CqUOfEWnp2k
         a34gA/sTvHlyxXDs+nNZXdc+mLT8E/kNVL+VXr4qgu9PzX4CJHxJdZIU69fC+VILbQw4
         rnYIgYPV+7eYuHVFwlTVVsalqXogXw30U7cEAi2EOqTVgP4MnQDfyUQv3eklF8LBtG8l
         G0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4BAbC2SrKWiikj9sQCe8GZxvTJd08+U2hgXBpuolPto=;
        b=BguLGeufizWGpOc/QtuLGA9YLNPwdFeDNXpE7/w5MqbV7joG+P7ooJC9Fh0ARyCGzy
         6o7IvX96s5iXfWYWVinDNSKZpLHvV3hS/8C2hiKzoqGQcKu+QaCexj2eLynqQeSp7w+K
         FBy9X0/ZIH/ni+ACbvBDdnax/cGir2d3blwIwhGOhRU28MMI8g1F5Ny49UnwefYpkYLb
         D8X+K9frrE7z2/YTjUwDpZi0qSuavIkG8pdNTOztuDklpHHHJJ8kuSQI8upu80JOgGhz
         RhOLSA2wkuvIT5NVWg7UIh3wJ7GjEtVeoXb2bqgpgnnzjIcz0QnaOdx7FMe6HTGKXqol
         GqEw==
X-Gm-Message-State: AOAM531AHEUdOT91K2rxI/X004+d9NRT2kytlVmcVJmQs5GTaX7Tk1Z7
        r/1A6PSjE27trtDNcSbniFqLjLyqnBe6Tl8ipSQ=
X-Google-Smtp-Source: ABdhPJwCH5pjvaVVQ6C2muwLRjFSPeu+sMuohXKnxHQ79qrclhxZguUvuBpNEXUFqL18/R6lx8jyfg==
X-Received: by 2002:a17:907:d9f:: with SMTP id go31mr5614027ejc.282.1644481832240;
        Thu, 10 Feb 2022 00:30:32 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id h8sm9384574edk.14.2022.02.10.00.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 00:30:31 -0800 (PST)
Message-ID: <c9374232-00a3-d046-87f6-29f471b50f5c@blackwall.org>
Date:   Thu, 10 Feb 2022 10:30:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 2/5] net: bridge: Add support for offloading
 of locked port flag
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220209130538.533699-3-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220209130538.533699-3-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:05, Hans Schultz wrote:
> Various switchcores support setting ports in locked mode, so that
> clients behind locked ports cannot send traffic through the port
> unless a fdb entry is added with the clients MAC address.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  net/bridge/br_switchdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index f8fbaaa7c501..bf549fc22556 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -72,7 +72,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>  
>  /* Flags that can be offloaded to hardware */
>  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED)
>  
>  int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  			       unsigned long flags,

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

