Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2656E1C07DB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgD3UZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgD3UZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:44 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278C5C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:44 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t11so2347891lfe.4
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lJmhJmuG1IWJED6rmkx8pwPYj9TB5d9M3E2doIVmkRs=;
        b=fASOuBt8zE/+5tGQ1qY43ZGmu7xs3H/w9z3Pm/vJuvfUa2asOH8b4HVp+BzFYW2gq9
         k/vAAX9bsEroUhXniLEqBNheSAyqquWOoBWhfRRhPTtM6BNPU/YY6wRnpLXIHX5op9zn
         oX5+7hg/ULQ559d9tT1q7s9x1uq1m04Av3I1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lJmhJmuG1IWJED6rmkx8pwPYj9TB5d9M3E2doIVmkRs=;
        b=HVXE8cZH8mp3a+CyjOI5F1F6apVjGctRCxoCg4fDM4p9bQS08KXpjk1JDwWgqe6xXv
         E5GWdP6HKZEkkiPeCi4vhuahmMbSW2Lx+ZHIFDbEKcP8WqZq8iUHg+hT80zQGii3GplK
         fExmeN97NREWMkkCqcRBj4NhNivT7TWxjx5IUhjgXSYKuFWOP9bZdWt0ZYROoxfkSArj
         EVpoKRNmt5nmCkDwjKeE/wrcUjcXh9kqVsfUH9mkmGpb1NiL4lFl2JnPV28hh4BvNWRn
         0m6s0m32IRy5xvup3t4UZpDFUifmkuH8hB1nYDd5OOUIdxZDyKd9D+/ICVekgW+h6L5q
         huGg==
X-Gm-Message-State: AGi0PuaHUrAJgWT7kB/aWPrkjB893XcNiqgTaQUW0FDsOIcyOzdi99nB
        IpxmlW76pXHDzJ+im59iZXV6ow==
X-Google-Smtp-Source: APiQypLXh16bLr7nrtxsHyK57JkwYRJPJAQr9YrysD+IeYnq/jqeSZIdvMAI24JYBJY2PPX2vk0tqg==
X-Received: by 2002:a05:6512:3f4:: with SMTP id n20mr283882lfq.100.1588278342612;
        Thu, 30 Apr 2020 13:25:42 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g3sm553096ljj.13.2020.04.30.13.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:25:42 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: vlan: Add a schedule point during VLAN
 processing
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@cumulusnetworks.com,
        s.priebe@profihost.ag, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200430193845.4087868-1-idosch@idosch.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <ab70b93d-c296-402e-865f-c96be764e7a3@cumulusnetworks.com>
Date:   Thu, 30 Apr 2020 23:25:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430193845.4087868-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 22:38, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> User space can request to delete a range of VLANs from a bridge slave in
> one netlink request. For each deleted VLAN the FDB needs to be traversed
> in order to flush all the affected entries.
> 
> If a large range of VLANs is deleted and the number of FDB entries is
> large or the FDB lock is contented, it is possible for the kernel to
> loop through the deleted VLANs for a long time. In case preemption is
> disabled, this can result in a soft lockup.
> 
> Fix this by adding a schedule point after each VLAN is deleted to yield
> the CPU, if needed. This is safe because the VLANs are traversed in
> process context.
> 
> Fixes: bdced7ef7838 ("bridge: support for multiple vlans and vlan ranges in setlink and dellink requests")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> ---
>  net/bridge/br_netlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 43dab4066f91..a0f5dbee8f9c 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -612,6 +612,7 @@ int br_process_vlan_info(struct net_bridge *br,
>  					       v - 1, rtm_cmd);
>  				v_change_start = 0;
>  			}
> +			cond_resched();
>  		}
>  		/* v_change_start is set only if the last/whole range changed */
>  		if (v_change_start)
> 

Looks good, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
