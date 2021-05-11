Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D8537AB1C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhEKPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhEKPuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:50:39 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2218C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:49:32 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id b25so14199273oic.0
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pwyZgKNRoPleYlFl/w7k/YF3I9DGnqgEl5f1/8MhRMg=;
        b=qkKOo3ZVkRLbovoTEzyNd0mf4f9AlTIyH/Q1Vk7ccA+yW+rLMrpPj6Iz7+fB1srYjo
         cdk4VzWGJpp3lpGz3S8tCfbtW/fqPQnxNWiGSazeLfdun7whn76gHr41PKu6xVexnMy0
         l9PoCuxYcPEWDUpr3CdVl3KpN+JivK/rTg9PFGS0QyaKcw1yBH7RhS6I5PptwoffKiC+
         bFjzqCS791Kc9Nc/VgVANUpLCHUCntTMEOaqBsrhNLBjSWduLZizkgj3vaquX5qhxDtf
         aPrtBHhf4q/qGNtHSn5zh3fBtCX/9m03bl8kAGRTXBmseNvfEMfS2twLAW3jNZOS7GO8
         MB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pwyZgKNRoPleYlFl/w7k/YF3I9DGnqgEl5f1/8MhRMg=;
        b=dKGSOkjHB0JN1tp0s4TibX4X3MRWOHoSI+uONcqJUT5ZNUmWS2LfRE3piLxfJI2a2a
         3q4vqI7TDXo3uCdo8oQhqryhGatp2DUwssWIbFawGVRzSWcjHO9Yp8P2HhM9NMeHb8k+
         YHv8fTIy/Jq1+7aWHbol2VZAjKwdEB/rWto2pDqnG3KI1pCTAyz/SoDLcB/IRGcphSZ8
         +u3Byhoc7zE2KzyAt57iYUOzG1UHH75yWw5WPoZxRqZ4t+lJ4S2lyc1KEE3X9SEjvH5C
         JWXOCT1mpq+KfxSAJHQ/D9uM80x4kugu9pHTjtql4lHxWTave0jSbeC1RbzK+8Wg5KEo
         MEpw==
X-Gm-Message-State: AOAM533wrBN8Gp8UfmwP6dJVk3vH6DmYY/iQpl0T4PlzTlF/Jw5Wk9MI
        Rs4RLyhtB79ttEYE0MrG4XJvaKgY+Kk/ng==
X-Google-Smtp-Source: ABdhPJz+0kIVYek9SC+jtULTeg3KCUWpJSmaTWyy3Cppa9GBC9Mp4UxOz8UCVN1LxG2Bo3Lfd9NTyQ==
X-Received: by 2002:aca:c109:: with SMTP id r9mr4007747oif.83.1620748172141;
        Tue, 11 May 2021 08:49:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:8052:e21b:4a8:8b78])
        by smtp.googlemail.com with ESMTPSA id n37sm3864162otn.9.2021.05.11.08.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 08:49:31 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control
 multipath hash fields
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <95516cbb-1fa3-566c-62f9-ae6adcbf8fe9@gmail.com>
Date:   Tue, 11 May 2021 09:49:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509151615.200608-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/21 9:16 AM, Ido Schimmel wrote:
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index a62934b9f15a..da627c4d633a 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -19,6 +19,7 @@
>  #include <net/snmp.h>
>  #include <net/icmp.h>
>  #include <net/ip.h>
> +#include <net/ip_fib.h>
>  #include <net/route.h>
>  #include <net/tcp.h>
>  #include <net/udp.h>
> @@ -48,6 +49,8 @@ static int ip_ping_group_range_min[] = { 0, 0 };
>  static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
>  static u32 u32_max_div_HZ = UINT_MAX / HZ;
>  static int one_day_secs = 24 * 3600;
> +static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
> +	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
>  
>  /* obsolete */
>  static int sysctl_tcp_low_latency __read_mostly;
> @@ -1052,6 +1055,14 @@ static struct ctl_table ipv4_net_table[] = {
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= &two,
>  	},
> +	{
> +		.procname	= "fib_multipath_hash_fields",
> +		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
> +		.maxlen		= sizeof(u32),
> +		.mode		= 0644,
> +		.proc_handler	= proc_douintvec_minmax,
> +		.extra2		= &fib_multipath_hash_fields_all_mask,

no .extra1 means 0 is allowed which effectively disables hashing and
multipath selection; only the first leg will be used. Is that intended?



> +	},
>  #endif
>  	{
>  		.procname	= "ip_unprivileged_port_start",
> 

