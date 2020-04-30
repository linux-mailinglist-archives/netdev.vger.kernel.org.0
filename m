Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB891C0272
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgD3Q1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726503AbgD3Q1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:27:39 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FE4C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:27:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b11so7727577wrs.6
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 09:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5dGhgdXjcFYxh7PeZsK1x6o20/MILmLxPmOVMwjKo0=;
        b=NuTQIojov+07F6xjJTplr1hK3fBv2T8BNYWmbMsYCR51qNx/9EhRJhNKIx27ZOVI33
         WxC2zphjWv3rhhmvkZiytQPTps/9yYexZy5Or1HUF/0EpQ+kZMo5nOiuECg1lyTmIww/
         M1lwRz43jJUZ3cEhw7RG26DumaptsHa10FjC3+JL7jajCw20qOLTUx5wk/JM9RMcIqv7
         mj8sOIeBq0+rbHVMVl341W50xT6x2QLiask76D6kx0zRE0T/icmMuSuRDL42AAMwxycQ
         PPbkyFHHOS5R1bKxNFPF21Wz69+9g7/vZELdRStZ0ewdK+3WbapeXic6ijWO2SQLAAQl
         0yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w5dGhgdXjcFYxh7PeZsK1x6o20/MILmLxPmOVMwjKo0=;
        b=JziZ89g9sBbaOk+htP6XXfTQGpM4Otar2MA6vek3517P1wK8Av8fvn+9sn+fkNB7Gk
         DEuP4rOsZ/vLMZCJlMSFj7cfnpS7GL5ez2j6YeFKVHnVCgHuivnd4HwgFVdJxBMuvve7
         ID21EsChxkZX1URADiQ1yzc1R84tYNmJRylTqxfio0n/pBdPl9B681tvdjsx6GgFAekh
         nAtOKg1xhqPmjrtlxe68s6axnY3a23NBSET400kvchMK9QbHHHOQ5dw2AJt0hBVO9Y1Z
         /hHlJYBsTuVG7ETL9I11Eac0ns8dx3hn7/LRLPeenWpa9ad/u7wzEeY5sjzcricmexUJ
         Kgjw==
X-Gm-Message-State: AGi0PuZS5A/THnb6LZedSPkCppfrvSafkRJ8yYMrIVDruvAD4gxQCXe7
        DeuVTttoPPbUEKVChMCSV/ZkfA==
X-Google-Smtp-Source: APiQypK/S9ssbCP3O7yRjBOcTDEB2eOJHUdkej82Rj3tFbMuOofvHnKMurj7qpGmWZNAM+sap2TkoQ==
X-Received: by 2002:adf:e450:: with SMTP id t16mr5141548wrm.301.1588264057546;
        Thu, 30 Apr 2020 09:27:37 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:702e:e652:aa4d:63d6? ([2a01:e0a:410:bb00:702e:e652:aa4d:63d6])
        by smtp.gmail.com with ESMTPSA id e2sm281025wrv.89.2020.04.30.09.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 09:27:37 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v4 2/3] net: ipv4: add sysctl for nexthop api
 compatibility mode
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
 <1588021007-16914-3-git-send-email-roopa@cumulusnetworks.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <74f127c0-8612-e964-b01e-bafec6669051@6wind.com>
Date:   Thu, 30 Apr 2020 18:27:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588021007-16914-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/04/2020 à 22:56, Roopa Prabhu a écrit :
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Current route nexthop API maintains user space compatibility
> with old route API by default. Dumps and netlink notifications
> support both new and old API format. In systems which have
> moved to the new API, this compatibility mode cancels some
> of the performance benefits provided by the new nexthop API.
> 
> This patch adds new sysctl nexthop_compat_mode which is on
> by default but provides the ability to turn off compatibility
> mode allowing systems to run entirely with the new routing
> API. Old route API behaviour and support is not modified by this
> sysctl.
> 
> Uses a single sysctl to cover both ipv4 and ipv6 following
> other sysctls. Covers dumps and delete notifications as
> suggested by David Ahern.
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  Documentation/networking/ip-sysctl.txt | 12 ++++++++++++
>  include/net/netns/ipv4.h               |  2 ++
>  net/ipv4/af_inet.c                     |  1 +
>  net/ipv4/fib_semantics.c               |  3 +++
>  net/ipv4/nexthop.c                     |  5 +++--
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  net/ipv6/route.c                       |  3 ++-
>  7 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 6fcfd31..a8f2da4 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -1553,6 +1553,18 @@ skip_notify_on_dev_down - BOOLEAN
>  	on userspace caches to track link events and evict routes.
>  	Default: false (generate message)
>  
> +nexthop_compat_mode - BOOLEAN
> +	New nexthop API provides a means for managing nexthops independent of
> +	prefixes. Backwards compatibilty with old route format is enabled by
> +	default which means route dumps and notifications contain the new
> +	nexthop attribute but also the full, expanded nexthop definition.
> +	Further, updates or deletes of a nexthop configuration generate route
> +	notifications for each fib entry using the nexthop. Once a system
> +	understands the new API, this sysctl can be disabled to achieve full
> +	performance benefits of the new API by disabling the nexthop expansion
> +	and extraneous notifications.
> +	Default: true (backward compat mode)
Maybe it could be good to allow only the transition true -> false to avoid
nightmare debug. When the user chooses to leave the compat mode, it should never
come back to it, it's not a game ;-)


Regards,
Nicolas
