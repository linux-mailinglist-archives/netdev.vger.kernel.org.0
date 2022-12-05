Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B926427AC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiLELk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLELkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:40:09 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BE01A23B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:40:08 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qk9so9323174ejc.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ck7nJMtJWfMXqJ5W4UKDMRT+n97feLu0BpQVT11JQQ=;
        b=lS/ObLnzVsgptiLXORTVWvMO3nrBM2AT6OkFfPPqf87rWVrtfvzCrbYETxTtU4bMQr
         sqObjWGqLJhO+5cq1gZllTYH3VpQRrhhPHQOQHpK22bXgoRDbpxLYuql91FRBeGZFcF4
         xqufuc3Q1cfFQIjwo3KcGlS92PTPq+NoxPJvgzEyjro7l4Z27qXNLZC/AsuumUE5aQNb
         V/rWtepKDqMCNLYgBqrpneI8YVBbWbs+4msacon5ZKGipn5pIHYKZgAZDGV9NVtGW8f5
         WidDsDvctGq05hQaxrmM+6IF6NJ9xhI8G74FyUXeiuaykl8PNjTLlJbo3v3zl4U+aOZW
         bsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ck7nJMtJWfMXqJ5W4UKDMRT+n97feLu0BpQVT11JQQ=;
        b=4le+KwX3b29xw/08MX8zkcOdWQeii959JzfLiwb3M7AR9JhJbZCm4fFwWs4PmYtpj4
         UcWN+1wKf+D8hOSwwk3onXwYnWbDQXGrc0N30terPmg89BSmNUfIRMPPyVHbw/4OyAD7
         4n+so4CsXGQ98/MR+N+BxlYGjE2sGSqHXotlpHRWU0JyGfv1qME5sFseLyg6dHKcfvc8
         tJWOMxaVxm4twCAUCEip404+vb3/VdYT+aaOORJlfGwG5YK0w3g49LjCb0dVYqa9YX5c
         aGuonvoPJXM3X3vpvXAcq98N40Rm+XQWtqVk8iWuMQ8t132VWCGj0mGmUT5mYJp2LDrs
         /K3Q==
X-Gm-Message-State: ANoB5plKK66wXdGYkE+XDva2vcGIsdo8AfoRtzHogDLpIqmqEtAfAohK
        8dyKgDsUrL7SDak23yLdWiHT7w==
X-Google-Smtp-Source: AA0mqf6E9ph8sx8+ENkFI2MTctWD4AfjkPQdO61g4GimLfgV69f3Iij40cEnMSM7tJQvDg90K83q2Q==
X-Received: by 2002:a17:906:76c9:b0:7bb:2867:7a92 with SMTP id q9-20020a17090676c900b007bb28677a92mr46527232ejn.441.1670240406730;
        Mon, 05 Dec 2022 03:40:06 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id sa22-20020a170906edb600b0073d7ab84375sm6199100ejb.92.2022.12.05.03.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:40:06 -0800 (PST)
Message-ID: <2d043351-0be2-67ea-5da2-1f29777c9fb7@blackwall.org>
Date:   Mon, 5 Dec 2022 13:40:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 4/8] bridge: mcast: Propagate MDB configuration
 structure further
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-5-idosch@nvidia.com>
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

On 05/12/2022 09:42, Ido Schimmel wrote:
> As an intermediate step towards only using the new MDB configuration
> structure, pass it further in the control path instead of passing
> individual attributes.
> 
> No functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

