Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1781F60271B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJRIhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJRIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:37:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876BA9C23A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ot12so30529756ejb.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YKJw2qpF3iJxcC8WpvUyBdGxAEqGRGDuO70Dlx4m/SM=;
        b=phft8sgdI/bymGOE9M77QzP+qBHNW01yWqM+P73mHM9JVCzbekbC2ZEV1AEzvHfslD
         yqwzoi2yHaUb0WubzsnBgfg9YF5OHEWoPlWzKpr3dI9BNc0uDJZwGkxj2JyfEzxTKXjM
         xdLWYWZtaC6LFXbHGeYM4ZBcRaklt81h0qjhnMz6Vr/LOl+JYncoE5P0U2EGs4D2KIQg
         XHc8Ik49gwa9FOilvhqNppuoFoqgFelCgK/SWOC2Omb2NyKQbp3cf7UzTaX9D8W+WCsn
         cAx9r9kt15jvbYSh6f6sqbMgzXhYbouWps1PjdktRq4fjLSv5+15iOx2PF4yOiXMoIFr
         kjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YKJw2qpF3iJxcC8WpvUyBdGxAEqGRGDuO70Dlx4m/SM=;
        b=kjMZz4tVvDC6XzpdbD1+OhB5v9xCoGBjxqgdJX5QBMRnK+7DOLkzJW13qKx7HFYooX
         i9HZ1rlDKdxrtk3LEnVkIr0lLTdtOdjBDWEf+vpwXTSnnw+16SJfqs5c/cfzdnrCpfuK
         GNg5LOM3srqTeFx2dGcad1TP4xqS92tNGpynrOjAdAUJfYC/iLHYSgMyIjUtWAvb856B
         fDHmO0eRxgVAThbMsgVJFZXam3EgTXmzR3j7aIeqxCM/BXRE67C1jYvOnHAELlW2sbZ8
         WNBeMp1LkcsSR5A/XKIcI4mmUC69rmyeZF7Tm6IvuK+JQfT+GVvIsM+BmrCGc754MP40
         GhdQ==
X-Gm-Message-State: ACrzQf3ctDh2+wRrRiEJJ0zmAv6W50Tl/uau8SyvdaTjn0RMVyR/4fZn
        dKnNm6e67L5wek7u4KJ56xMadg==
X-Google-Smtp-Source: AMsMyM72WREq/OE/yIKI/tDDqHexwsOQL9HZOSmigNFNiyLgf8XyqHVjosxH26G5z2EFvzJHNgJ5Lg==
X-Received: by 2002:a17:907:1c8e:b0:78d:fd24:a596 with SMTP id nb14-20020a1709071c8e00b0078dfd24a596mr1459201ejc.534.1666082251350;
        Tue, 18 Oct 2022 01:37:31 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id d23-20020a170906305700b0078afe360800sm7194257ejd.199.2022.10.18.01.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 01:37:31 -0700 (PDT)
Message-ID: <c8ca33cd-f0eb-e917-3fb3-c00a0f0ed753@blackwall.org>
Date:   Tue, 18 Oct 2022 11:37:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 3/4] bridge: mcast: Use spin_lock() instead of
 spin_lock_bh()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221018064001.518841-1-idosch@nvidia.com>
 <20221018064001.518841-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221018064001.518841-4-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2022 09:40, Ido Schimmel wrote:
> IGMPv3 / MLDv2 Membership Reports are only processed from the data path
> with softIRQ disabled, so there is no need to call spin_lock_bh(). Use
> spin_lock() instead.
> 
> This is consistent with how other IGMP / MLD packets are processed.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_multicast.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

