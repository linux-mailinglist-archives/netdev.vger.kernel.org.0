Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1130B3906A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbfFGPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:49:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32772 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732041AbfFGPtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:49:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id g21so1000098plq.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 08:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1p0xq/BX2Hn6pLD54JU5UsUHLGBTGFJvPRv9yERfang=;
        b=OxFUmT78CMAg/k4xYv3xqBj0OfUWVNwkVEbdXnurmw/BZd4nW5eSLBvCsECMqTLaAZ
         a6/U/TPRhYYBOHGUlMHGINLw4UpQeJUZeOXcCc+COTRwGEEiOsSDBu6Eqs7Zr6UgdAID
         xYeCWY2v5JSohWvBBbWEwpBjwmq3CtanaDZCkqaBafgFo9sl7uYW07uX8q+SsS/jGSpF
         XT3mrfdcVC0Q2LkUczOYudntluNsDVv1DSdvJJl0KuujMY2UP2PQ0oYvB43hA3y+WjYm
         QKOdcwV+F5pE89K/kdxrn0zHwHP22UcCwrD2JrYw2vdUPAXC9jc41U+PjDMW7ScKsDL2
         JBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1p0xq/BX2Hn6pLD54JU5UsUHLGBTGFJvPRv9yERfang=;
        b=oRVXiKnC3E9fbJ5rvD2xZut9mAjMQfuRtRlQVCueGzAmxs8xJ4Bk2AvDxiJOrJDWqQ
         F4wpud20LEl0KtwKiwbpJeM4EYR7P98bO4uJnegy3fgj7ILtwNTguD7droVk86JnHB7K
         W1c8GBmKxPOCRCnPtu/zGrnkqxMORSbhacA1ZtoZwb9W+GONabR2LxCsijtFOsr+vf0i
         9/w+q0VBMoHeZyKVelmuHEvohiMkN7sXLlWKfsmXtk06a5ZGD3eWH36ayzd0QWB/4jO9
         +gAdERj+0k3zZfZZIl8WdIfmnTx+irY4fqMiTt2otNvIFJl6U+V6z+PYt6pxgtTAqaVa
         +Qyg==
X-Gm-Message-State: APjAAAXI65OMG8tLKO435jALvT7t3R4W47drJ8WZv9+u+isyLHzv/wAf
        sPy6rkCX7CwqR7u8rJzNkqaRR+zzvtM=
X-Google-Smtp-Source: APXvYqxfDdiTPKEHcOdSzQi69MxjshbcdLySativXsfIbgIWDZcwsvmhpaHpTS1xrpUZe+gyFZwi3A==
X-Received: by 2002:a17:902:467:: with SMTP id 94mr1008339ple.131.1559922589409;
        Fri, 07 Jun 2019 08:49:49 -0700 (PDT)
Received: from [172.27.227.254] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y12sm2360358pgi.10.2019.06.07.08.49.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 08:49:48 -0700 (PDT)
Subject: Re: [PATCH net] mpls: fix warning with multi-label encap
To:     George Wilkie <gwilkie@vyatta.att-mail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190607104941.1026-1-gwilkie@vyatta.att-mail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4688436a-2e57-55f1-a0a6-2ba6a2fbba96@gmail.com>
Date:   Fri, 7 Jun 2019 09:49:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190607104941.1026-1-gwilkie@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 4:49 AM, George Wilkie wrote:
> If you configure a route with multiple labels, e.g.
>   ip route add 10.10.3.0/24 encap mpls 16/100 via 10.10.2.2 dev ens4
> A warning is logged:
>   kernel: [  130.561819] netlink: 'ip': attribute type 1 has an invalid
>   length.
> 
> This happens because mpls_iptunnel_policy has set the type of
> MPLS_IPTUNNEL_DST to fixed size NLA_U32.
> Change it to a minimum size.
> nla_get_labels() does the remaining validation.
> 
> Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>
> ---
>  net/mpls/mpls_iptunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
> index 951b52d5835b..20c682143b01 100644
> --- a/net/mpls/mpls_iptunnel.c
> +++ b/net/mpls/mpls_iptunnel.c
> @@ -28,7 +28,7 @@
>  #include "internal.h"
>  
>  static const struct nla_policy mpls_iptunnel_policy[MPLS_IPTUNNEL_MAX + 1] = {
> -	[MPLS_IPTUNNEL_DST]	= { .type = NLA_U32 },
> +	[MPLS_IPTUNNEL_DST]	= { .len = sizeof(u32) },
>  	[MPLS_IPTUNNEL_TTL]	= { .type = NLA_U8 },
>  };
>  
> 

MPLS_IPTUNNEL_DST is an array of u32's so that looks correct

Reviewed-by: David Ahern <dsahern@gmail.com>
