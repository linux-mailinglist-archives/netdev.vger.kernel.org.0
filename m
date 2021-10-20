Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE2434374
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 04:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhJTCSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 22:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhJTCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 22:17:46 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F28AC061769
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:15:17 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id o83so7809990oif.4
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 19:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9bZ8jjpF06cd++M8WvcbJeYpvvXwWariX6eZZBJGh+w=;
        b=FCxluqo+1JRIiA59SkvsMDRBmISn52jFwlz1sFgfUtESwG9RHSeMKQ4CSa/b+ikLZF
         FjWrFz79VSKXvteWkWaHusnJKqyP2zgVSeUGIO7wppg1LQlrRysaSZylB0G3aDfo7Klh
         7o9I1niS1OAJguggAEwEfa+j5NGWy43x3BeO86vbX0R0zi10q84RqCub7JnvJYEGgibk
         uaddbFo5AiE/oRk2xbzck+MWNuHHANd2Oo9106tpvl/Cx5iRD6hBic9fEN8kp3mHk3HQ
         WMHeIguwNPqGpM/zv2fBFcyvKoo4DG9KqI8WEpGpV/K35GhV58WYR1nV86Sm4N7tMsKY
         /29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9bZ8jjpF06cd++M8WvcbJeYpvvXwWariX6eZZBJGh+w=;
        b=HfMkRRVzMCTf4SqQCmPsZj1bOvSDJdKLTfaOcMOHLHkv6zfVokUB2TR/+ZvUHG+2rZ
         S7aJQGgVyJrTA3hyfHQFRHgkRyXr6CSzdbfEntFmMqrb4vHLZwPveL4tND+f6ci6Li8/
         yoqHKIIyLWUd9GWWjKkwt13VRJP9BY5G+Uhl5Ykjm0dGUmJQaomgJoi07u0IUWLXtC8O
         FRhMfn4JslrIdr7kmfLQWOEj9s+Lrzw6i7ilNwInwsgjcWHIAynbbqjpJV52RxGTYG8N
         b4mrlj/p8So4IoeEh+7/v155CkzT+lHwqkngtU0A7E0V2v2vSEozYTfbbZA7AXD2fb8s
         jQeQ==
X-Gm-Message-State: AOAM533zYmWZXSUS5AqdPDCan8po2W5vTDDgkzldDyXRVEPsM5x0PeqK
        0uEk6WuRNIY0Knh/QY4f/ZQ=
X-Google-Smtp-Source: ABdhPJyrFjJ68Z8dAMJ+nelIWevB0gzD3W5lFGYPhkv1keitBzqCBdNlIdppyeh5XwNUyonv30GE3Q==
X-Received: by 2002:aca:a858:: with SMTP id r85mr7117940oie.9.1634696116391;
        Tue, 19 Oct 2021 19:15:16 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id c4sm190055ook.5.2021.10.19.19.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 19:15:15 -0700 (PDT)
Message-ID: <0fa3610f-50e4-139e-f914-da2728ab5b6c@gmail.com>
Date:   Tue, 19 Oct 2021 20:15:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v4] net: neighbour: introduce EVICT_NOCARRIER table option
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
References: <20211018192657.481274-1-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211018192657.481274-1-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 1:26 PM, James Prestwood wrote:
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 16b8bf72feaf..e2aced01905a 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -200,6 +200,15 @@ neigh/default/unres_qlen - INTEGER
>  
>  	Default: 101
>  
> +neigh/default/evict_nocarrier - BOOLEAN
> +	Clears the neighbor cache on NOCARRIER events. This option is important
> +	for wireless devices where the cache should not be cleared when roaming
> +	between access points on the same network. In most cases this should
> +	remain as the default (1).
> +
> +	- 1 - (default): Clear the neighbor cache on NOCARRIER events
> +	- 0 - Do not clear neighbor cache on NOCARRIER events
> +
>  mtu_expires - INTEGER
>  	Time, in seconds, that cached PMTU information is kept.
>  
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index e8e48be66755..71b28f83c3d3 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -54,7 +54,8 @@ enum {
>  	NEIGH_VAR_ANYCAST_DELAY,
>  	NEIGH_VAR_PROXY_DELAY,
>  	NEIGH_VAR_LOCKTIME,
> -#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_LOCKTIME + 1)
> +	NEIGH_VAR_EVICT_NOCARRIER,
> +#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_EVICT_NOCARRIER + 1)
>  	/* Following are used as a second way to access one of the above */
>  	NEIGH_VAR_QUEUE_LEN, /* same data as NEIGH_VAR_QUEUE_LEN_BYTES */
>  	NEIGH_VAR_RETRANS_TIME_MS, /* same data as NEIGH_VAR_RETRANS_TIME */
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index db05fb55055e..1dc125dd4f50 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -152,6 +152,7 @@ enum {
>  	NDTPA_QUEUE_LENBYTES,		/* u32 */
>  	NDTPA_MCAST_REPROBES,		/* u32 */
>  	NDTPA_PAD,
> +	NDTPA_EVICT_NOCARRIER,		/* u8 */

you are proposing a sysctl not a neighbor table attribute. ie., you
don't need this.


>  	__NDTPA_MAX
>  };
>  #define NDTPA_MAX (__NDTPA_MAX - 1)
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 47931c8be04b..953253f3e491 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -318,7 +318,7 @@ static void pneigh_queue_purge(struct sk_buff_head *list)
>  }
>  
>  static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
> -			    bool skip_perm)
> +			    bool nocarrier)

why are you dropping the skip_perm arg? These are orthogonal skip options.


your change seems all over the board here.

You should be adding a per netdevice sysctl to allow this setting to be
controlled per device, not a global setting or a table setting.

In neigh_carrier_down, check the sysctl for this device (and check 'all'
device too) and if eviction on carrier down is not wanted, then skip the
call to __neigh_ifdown.
