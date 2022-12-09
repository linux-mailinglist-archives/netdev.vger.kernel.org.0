Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAFF647E9D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiLIHcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLIHcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:32:24 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B549115B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:32:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v7so2936325wmn.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SIxveZre+8NlzeDt7utvIp6t4jf30eHuNZN/6H3+xYM=;
        b=4ND5KS73UpftC8y+BoMtMe5FgelG7H82ffwcQBcpgSXKkJ1TEMXurxFSSareiCH4Vf
         5TmTChu0WoG3Zig+wLrT2LJv9fhHP0UL95Ws/BNmtoytDEsiTeZ8oukU8l0KHniMEJRc
         3g8cx4Wi96SoY5jS8lGi/2AR6SPcRTWXVL86T+vSpmoRbKb0zo/ts2nptxI3eLpYVj/w
         FqzFL/wUaqdr20BUgaoln08Slc/o2qge3teqTs2+fNq1j2gEdfenuOSoIaRaNxHhcE/s
         DkBJsvCXyHDK9ADYtFm3OaprTO1xTROWzU/ZgSfNf06JW02fWp9QMzZet0Mum6hTgtoh
         Fc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SIxveZre+8NlzeDt7utvIp6t4jf30eHuNZN/6H3+xYM=;
        b=yHyBcPaROIcharHs+InTCFrWoeMg1a6mSciIsjkGOMfK+G3Z6OlHXY2KVOULy4gLmH
         E2aMUK6/58SDGeClYWBRzF2+gm+pfiO0dZ5iTP7fyQVB/sWLTWa3fbgNfuz1C+cQWTKJ
         QH4VJZLHd0LS4gefcBjoKctXCxC/k/w4mMNdBzx7ooc2A+slMkLZFyyodj3qzRyvVQ92
         28UzhPguBVDx/jVGaYrGpwzB71Ah6bGIbocx/rKALLkE0B0vgsSz02qJOlEiG9xlFQtN
         x1EJS4HkGdRXfO5w1d/cZtULbm6oQCgh45P0k2mBGfleTpzmbNOgjgWE4kyjEVJTeucg
         OQxA==
X-Gm-Message-State: ANoB5pnOgv4AvI3Vir41fAqcIX2glBoaoNqSuWYsLTnur7SHP+am/inY
        g9+vEaYY7clQKwu7GLQJ70KtaQ==
X-Google-Smtp-Source: AA0mqf44dGtgY0Fn0SWwzqf0se3Mx899UqVB/FoSnAmso92rYum/9jpk/QGG2+d9IvNjrMSTEBeiXg==
X-Received: by 2002:a05:600c:4f89:b0:3d1:caf1:3f56 with SMTP id n9-20020a05600c4f8900b003d1caf13f56mr3647609wmq.9.1670571140865;
        Thu, 08 Dec 2022 23:32:20 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c228d00b003c5571c27a1sm1091746wmf.32.2022.12.08.23.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:32:20 -0800 (PST)
Message-ID: <bc17a159-41d9-6627-080a-272464ee05fe@blackwall.org>
Date:   Fri, 9 Dec 2022 09:32:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 07/14] bridge: mcast: Add a flag for user
 installed source entries
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-8-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-8-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> There are a few places where the bridge driver differentiates between
> (S, G) entries installed by the kernel (in response to Membership
> Reports) and those installed by user space. One of them is when deleting
> an (S, G) entry corresponding to a source entry that is being deleted.
> 
> While user space cannot currently add a source entry to a (*, G), it can
> add an (S, G) entry that later corresponds to a source entry created by
> the reception of a Membership Report. If this source entry is later
> deleted because its source timer expired or because the (*, G) entry is
> being deleted, the bridge driver will not delete the corresponding (S,
> G) entry if it was added by user space as permanent.
> 
> This is going to be a problem when the ability to install a (*, G) with
> a source list is exposed to user space. In this case, when user space
> installs the (*, G) as permanent, then all the (S, G) entries
> corresponding to its source list will also be installed as permanent.
> When user space deletes the (*, G), all the source entries will be
> deleted and the expectation is that the corresponding (S, G) entries
> will be deleted as well.
> 
> Solve this by introducing a new source entry flag denoting that the
> entry was installed by user space. When the entry is deleted, delete the
> corresponding (S, G) entry even if it was installed by user space as
> permanent, as the flag tells us that it was installed in response to the
> source entry being created.
> 
> The flag will be set in a subsequent patch where source entries are
> created in response to user requests.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_multicast.c | 3 ++-
>  net/bridge/br_private.h   | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 8432b4ea7f28..48170bd3785e 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -552,7 +552,8 @@ static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src,
>  			continue;
>  
>  		if (p->rt_protocol != RTPROT_KERNEL &&
> -		    (p->flags & MDB_PG_FLAGS_PERMANENT))
> +		    (p->flags & MDB_PG_FLAGS_PERMANENT) &&
> +		    !(src->flags & BR_SGRP_F_USER_ADDED))
>  			break;
>  
>  		if (fastleave)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index a3db99d79a3d..74f17b56c9eb 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -300,6 +300,7 @@ struct net_bridge_fdb_flush_desc {
>  #define BR_SGRP_F_DELETE	BIT(0)
>  #define BR_SGRP_F_SEND		BIT(1)
>  #define BR_SGRP_F_INSTALLED	BIT(2)
> +#define BR_SGRP_F_USER_ADDED	BIT(3)
>  
>  struct net_bridge_mcast_gc {
>  	struct hlist_node		gc_node;

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

