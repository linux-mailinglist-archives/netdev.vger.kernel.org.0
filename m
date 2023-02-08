Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0868EE3D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBHLtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBHLtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:49:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7245A4671E
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:49:09 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a10so12979655edu.9
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 03:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/SjDO6EqNmi5y7XE3sAL8vvCHxfKdZQcflUbJwAoNdk=;
        b=sl6rqalKTORmeCW3cgfxYFWnfEdrE1Ohxuo91EvA9Kk25SNlDc/wPrTo5+U85ov5I0
         J+odxvOcte2fm31vDYc4IEVPsiPVZVFpPgmmoGBTI5Z8Svfe/J5du2qeKHerKelaMVNa
         lH0hJktWHtD7hMiYsXQyOJQ4cTg6VnzzrJjjZHhg9EDWGBrga8T5gtLcjVJxBAOlODLV
         j/jfmI5j82iJZdsYU1+lIqIIEc/a6HUEZaUIx6gdV+u+FBP1ZQcumDWagY0W9BmXHRpl
         88PO9uP5RRvw2YaRLtXvUXBApCl8RWEj4Swvwyp7nzQoA+Gq9L8k9V5ECdfNPawapsrg
         0jzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/SjDO6EqNmi5y7XE3sAL8vvCHxfKdZQcflUbJwAoNdk=;
        b=VNLhb6Ngq3H15q+LWOEhOCcsMPEQHhxVJyc4BjzA144rBbBp6+EPvjXdMyr/PE8X/P
         +NVoQhfAukuveMVvPWZA3TFnz52We/7H/3xslzuTMqVZav/vSh+aGT+Ea0i5bxjq3Uv5
         qjg2/2dUhjW0w/2eY1LDAKZsRXQpW4a/HNvxlDcjm6M2PXu0S542EKp/IPWqlQBVnbVf
         cxFOy4vCToAubetzIxw2hhOS5p1S0LpIoOEj3kTECL4FqsuiYtg1rDCni78FTBtg+smo
         MZxZYnzPIw8hN/klwS0LnyVNNWT0IfgbaTRGf1wYBl2K6C0TO6vdqJjKdIrh/60RtZJ0
         iWAg==
X-Gm-Message-State: AO0yUKV2sfTDWcabzH3S244DLf3TMDHuwQNDHHo+8HIWNFbWSsJ917rB
        HV0ZFWWvIpqex2HZ6nW2xg1OGA==
X-Google-Smtp-Source: AK7set8USNC3aQ1gyxtjT07nJH5xh1j36nmp6Eni3999lVqI6j72LeJJg7AuVYE6YXllxd0EX3+Vaw==
X-Received: by 2002:a50:d741:0:b0:4a2:3d2e:6502 with SMTP id i1-20020a50d741000000b004a23d2e6502mr7918896edj.4.1675856947911;
        Wed, 08 Feb 2023 03:49:07 -0800 (PST)
Received: from [192.168.3.225] ([81.6.34.132])
        by smtp.gmail.com with ESMTPSA id r6-20020a056402018600b0049f29a7c0d6sm7775392edv.34.2023.02.08.03.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 03:49:07 -0800 (PST)
Message-ID: <77af7d2b-d7f4-4df0-294b-14a17300ef8f@blackwall.org>
Date:   Wed, 8 Feb 2023 12:49:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] net: bridge: clean up one inconsistent indenting
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, roopa@nvidia.com,
        pabeni@redhat.com, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 02:56, Yang Li wrote:
> ./net/bridge/br_netlink_tunnel.c:317:4-27: code aligned with following code on line 318
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3977
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   net/bridge/br_netlink_tunnel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
> index 17abf092f7ca..eff949bfdd83 100644
> --- a/net/bridge/br_netlink_tunnel.c
> +++ b/net/bridge/br_netlink_tunnel.c
> @@ -315,7 +315,7 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
>   
>   			if (curr_change)
>   				*changed = curr_change;
> -			 __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
> +			__vlan_tunnel_handle_range(p, &v_start, &v_end, v,
>   						    curr_change);
>   		}
>   		if (v_start && v_end)

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

