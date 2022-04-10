Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EE24FB001
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243879AbiDJUJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiDJUJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:09:13 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51852427FD;
        Sun, 10 Apr 2022 13:07:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r13so27058889ejd.5;
        Sun, 10 Apr 2022 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=c7ppvSGFMjXTyAACKzFwqYFiWmXivSzgvL4BwU7SqKc=;
        b=QCrfuyYV9QtWOFIfcgtA1QjB4ZlZXyDB6yb27ilwN40G9t99u9DV7E4YEcS3iDf1D0
         gPu1ja+uAVRP7g21Exws4PuS4fj1pcxNI50VHKPZb2Z2mHEIgIJ0OroTwI2EKT0Jiylq
         Ak303v1ThmTUdWqUhbe5oCVI9WT4PbxF4zRVX6sKNsMV2TKwOxaIBIa5S+J4Mna6/v9s
         gyKPYSH12bfPTStTQn11Vx8CtQihilapqxB4tJbPJIrQ7ZAcQQu7rkfujT38uf4SPJr7
         rodkAP1za+7grryh4416obMSb0Szv7MeOGiLOaqJ06o1m9LL0e4+GX20R28tHNDWJmrn
         SDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=c7ppvSGFMjXTyAACKzFwqYFiWmXivSzgvL4BwU7SqKc=;
        b=TSf7Ehp24rjuoGd/J/qLuIob+xy3tp0WU/9KzJFOXERXj/wi9+0vhg+XBaogOH5C/x
         FKJMazjGTgvcM4Fa0FAXc0Jsa7ymExDTEjwytyjV0IYoGBFxw9YJmujnnugdDuMFx0jq
         6mTQUGUjRL4tcV3zPgd9ptTBIoHduUWn/iTuSfkcx7TtKft+9Z/YaIu8t3HsX0YTCyLY
         owiRQfVj/h/ir4qr0GoSnLBDDR0X3aGhFG/gQWFlizIC5/ySi1aqGOA743hB++wC4czK
         b3YjAaRE5JXT4wrOdWBrQeugmUWjB+dJW/DyD6oA7mwaKCFcOPDCCyLnOvJUTl9xgC17
         lj7A==
X-Gm-Message-State: AOAM5304Mfildttk9j0Q5hoDbz6WNgYw3gEC0nNytBRYDO2yR55VwrBp
        BBYrBBefY9ts/9iHoTuZICt1FJsdAX0=
X-Google-Smtp-Source: ABdhPJyxHbErd5pOT77ULDChG7+6rv5MlbAqGZ9qz+pS92PjEbqN2+fKwAQlyX2i/N1Jyt0OCuFDkg==
X-Received: by 2002:a17:907:3f03:b0:6df:b04b:8712 with SMTP id hq3-20020a1709073f0300b006dfb04b8712mr27535756ejc.290.1649621219711;
        Sun, 10 Apr 2022 13:06:59 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id q15-20020a1709060e4f00b006cdf4535cf2sm11073022eji.67.2022.04.10.13.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 13:06:59 -0700 (PDT)
Date:   Sun, 10 Apr 2022 23:06:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: offload BR_HAIRPIN_MODE,
 BR_ISOLATED, BR_MULTICAST_TO_UNICAST
Message-ID: <20220410200657.cwx7xy3t6jycqqrn@skbuf>
References: <20220410134227.18810-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220410134227.18810-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 04:42:27PM +0300, Arınç ÜNAL wrote:
> Add BR_HAIRPIN_MODE, BR_ISOLATED and BR_MULTICAST_TO_UNICAST port flags to
> BR_PORT_FLAGS_HW_OFFLOAD so that switchdev drivers which have an offloaded
> data plane have a chance to reject these bridge port flags if they don't
> support them yet.
> 
> It makes the code path go through the
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
> -EINVAL for everything they don't recognize.
> 
> For drivers that don't catch SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS at
> all, switchdev will return -EOPNOTSUPP for those which is then ignored, but
> those are in the minority.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> Let me know if this is netdev/net material instead.

The thing with targeting this against "net" is that we've seen the
introduction of BR_PORT_LOCKED fairly recently which has tainted the
BR_PORT_FLAGS_HW_OFFLOAD macro. So backporting would conflict very
quickly down the path. Sure that isn't a decisive problem, but I don't
think it's worth the extra trouble of preparing special patches for the
"stable" trees, and having those diverge from the current master.

> 
> Commit log is heavily quoted from Vladimir Oltean <olteanv@gmail.com>.
> 
> Arınç
> ---
>  net/bridge/br_switchdev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 8cc44c367231..81400e0b26ac 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -72,7 +72,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>  
>  /* Flags that can be offloaded to hardware */
>  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED)
> +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
> +				  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
>  
>  int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  			       unsigned long flags,
> -- 
> 2.25.1
> 
