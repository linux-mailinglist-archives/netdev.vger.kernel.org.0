Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601BD6DD4BB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDKIED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 04:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKIEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 04:04:02 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4981D30DF
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:03:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gb34so18316841ejc.12
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1681200238; x=1683792238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k3Azqi0PzzANZ2Rni8AADHxyvhPXgRP3KYAVzLP4PpE=;
        b=UVDFhFMczoGb5yiDNS1TI66Sb20eqDUD+eJbsyOVBoYGQeTQV4wdBK+bMKV/onsr/8
         B+mAWm96B8bw4aZ5GP6ZT0KUBR8u1zeSHLGelX3CwrW8yPTz3ZPAO9kfGzAP31k2syfD
         wsPSLc2nYR3deHV0XBZMGVLOFvcz5uZRZhxR/P+98GBO3UzSK/4PsQD+vKkAUFxi3Eve
         pjB/nVFEQO0UN+1G6awcdyAMOz3d1RZpU9Lo0LRclae9nXgF7Ratg/l0z0kDL/v1nJSX
         U1Icua1Dhjnjrswa1x5KIok6g5L32KSZLUljk65OT4ZH9Ww4pMkMsRaptMXhkqM40HyR
         Irqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681200238; x=1683792238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k3Azqi0PzzANZ2Rni8AADHxyvhPXgRP3KYAVzLP4PpE=;
        b=lqWmBKRFnqDlJDx3fjFOLX2YYdrP/fV4+kk9AHsF6GJDmS+/PTnvgXNV1SJaXFQnQh
         gX4DqdxuibUw5ITl74MLKEpExPAvRIe3iQUNzAKfvArpN/fKp+m5hL5NcuLDTpYIqQvP
         tvmZiZ1Mk5+AMY8YjlL/kW/Xfy6ys+/aiWxLJIjLc6sPr1ntSsSb2OI38tsl1hSDLxgN
         MYxh8LNxXNZGEIk2UCSmb7iguoAgju+EchvYbdSLO6yaG2Aawyr9lqqDmWAN2zLWmmoZ
         4igvSPXtdafic3oMbDJiXjgpZG+dGqufXxsRPP2rVi65XFwRHcho+Mvicf2moyU+mo15
         6qsg==
X-Gm-Message-State: AAQBX9cdaYiTmsHIf6Y3uXpbMWWKRG/IsXuDzan/FV2Md1dbeUMlbd8l
        KplrzW9CJKtdApM4T1NroRxhpQ==
X-Google-Smtp-Source: AKy350bl5w/PbRVFk4NpsgpRWwUcUWZERdrRniZxsq9xv12GADdShhdRCVLeLu/fF+uZBvRDF6WzIA==
X-Received: by 2002:a17:907:674e:b0:94b:466b:a492 with SMTP id qm14-20020a170907674e00b0094b466ba492mr4511085ejc.19.1681200237539;
        Tue, 11 Apr 2023 01:03:57 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id wg11-20020a17090705cb00b0093a0e5977e2sm5861263ejb.225.2023.04.11.01.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 01:03:56 -0700 (PDT)
Message-ID: <87e5f12f-ec66-817a-9937-2db0e067d171@blackwall.org>
Date:   Tue, 11 Apr 2023 11:03:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net/bridge: add drop reasons for bridge
 forwarding
Content-Language: en-US
To:     yang.yang29@zte.com.cn, davem@davemloft.net
Cc:     edumazet@google.com, pabeni@redhat.com, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        zhang.yunkai@zte.com.cn, jiang.xuexin@zte.com.cn
References: <202304061930349843930@zte.com.cn>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <202304061930349843930@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 14:30, yang.yang29@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> This creates six drop reasons as follows, which will help users know the
> specific reason why bridge drops the packets when forwarding.
> 
> 1) SKB_DROP_REASON_BRIDGE_FWD_NO_BACKUP_PORT: failed to get a backup
>    port link when the destination port is down.
> 
> 2) SKB_DROP_REASON_BRIDGE_FWD_SAME_PORT: destination port is the same
>    with originating port when forwarding by a bridge.
> 
> 3) SKB_DROP_REASON_BRIDGE_NON_FORWARDING_STATE: the bridge's state is
>    not forwarding.
> 
> 4) SKB_DROP_REASON_BRIDGE_NOT_ALLOWED_EGRESS: the packet is not allowed
>    to go out through the port due to vlan filtering.
> 
> 5) SKB_DROP_REASON_BRIDGE_SWDEV_NOT_ALLOWED_EGRESS: the packet is not
>    allowed to go out through the port which is offloaded by a hardware
>    switchdev, checked by nbp_switchdev_allowed_egress().
> 
> 6) SKB_DROP_REASON_BRIDGE_BOTH_PORT_ISOLATED: both source port and dest
>    port are in BR_ISOLATED state when bridge forwarding.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Reviewed-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> Reviewed-by: Yang Yang <yang.yang19@zte.com.cn>
> Cc: Xuexin Jiang <jiang.xuexin@zte.com.cn>
> ---
>  include/net/dropreason.h | 33 ++++++++++++++++++++++++++++++++
>  net/bridge/br_forward.c  | 49 +++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 71 insertions(+), 11 deletions(-)
> 

In addition to Jakub's comments, next time please CC bridge maintainers.
I just noticed this patch now.

Thanks,
 Nik


