Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E697B49C139
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiAZCVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiAZCVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:21:15 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C979BC06161C;
        Tue, 25 Jan 2022 18:21:14 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id w133so8026035oie.7;
        Tue, 25 Jan 2022 18:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=izDn6XA19FjFGaMN8LDQg14yCf1OqoC3aN5CCP5/Csw=;
        b=Pb12RKghajH3C2XyzIC3ql94p0rV59G26kHf96TO8CD6wGSVRJkUNUpuTPfObQA5+V
         sYuLOqmcqpd+pG/OFy75AsrJLmTsY8n9Sl75JjHQ0Vu5T4DL/0Ntv2UIRoAelwg/6sni
         kaZJrFV6a+ThMTunryEogSY14iyZqvOCjPfet2mDQSmzo3Hwh7XXeHItt5xH23b63RTD
         wH8P73BAF8PSAcTDL3tqHoycnUCS6gC3AnimITqx5aqxvPia5rEYlJMgKZzRxDW2sfMU
         E0QIH66yCsz2G/hS+a1QMN5V7EVnRxqtlaZUtQPvCuOPIkv+n9IW6BwrGpoD7Z2oiufw
         EOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=izDn6XA19FjFGaMN8LDQg14yCf1OqoC3aN5CCP5/Csw=;
        b=lkBc3JZ0M6CbKUjYk+gFDiN8/r5QQL4kcZoY/8mWF2K8if3q9eDyAWP1zRo0To0w58
         qZkHM8micmIfmeAN98z7sWPhHbjJZY1XcFAGqcB8U1mIP5d0Pg1qxndxp6Qaakp+o14U
         A7UyKEENmOT+EkQoI0lPqPgse7D0rB8nzOIwlSEd4hyi7K9VG5IV+s/TWO9/Ho2ETmc5
         EZjVlnnwXUXeyLpjQKZAv1CFJ/5BMYbVef2v5CNt0vZbJHi9wVeQc63MUJGwIMpeba+J
         JQ85614WuOnIsdENtXLjO/NcwKJjsNhE56TQvg+pbQ5yUwBRiSd+2lKUYU+RyOsEQZRG
         OAEg==
X-Gm-Message-State: AOAM532uLjaTk5U5ZvOTTm5nju0dAJmqagwsiYHDuixeRG9D2bWk8ndm
        FZRY0o8SsD6Mbyu4+6JEqaM=
X-Google-Smtp-Source: ABdhPJxwf7E6hpB/JVhjOvVGuM0xNAYCYJs9kavqMBTBBXAM4CyQ8G17nhh6psfd0bx0TXzT9+woug==
X-Received: by 2002:a05:6808:21a9:: with SMTP id be41mr2596720oib.237.1643163674130;
        Tue, 25 Jan 2022 18:21:14 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id c22sm6949317oot.38.2022.01.25.18.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 18:21:13 -0800 (PST)
Message-ID: <f493e1e7-0fa0-45f6-4bd6-790492055797@gmail.com>
Date:   Tue, 25 Jan 2022 19:21:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 4/6] net: ipv4: use kfree_skb_reason() in
 ip_protocol_deliver_rcu()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-5-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220124131538.1453657-5-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 8942d32c0657..603f77ef2170 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -328,6 +328,8 @@ enum skb_drop_reason {

It would be worthwhile to document the meaning of these as you add them
-- long description of the enum.

>  	SKB_DROP_REASON_IP_RPFILTER,
>  	SKB_DROP_REASON_EARLY_DEMUX,
>  	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,

	/* xfrm policy check failed */
> +	SKB_DROP_REASON_XFRM_POLICY,

	/* no support for IP protocol */
> +	SKB_DROP_REASON_IP_NOPROTO,
>  	SKB_DROP_REASON_MAX,
>  };
>  


If the enum is 1:1 with an SNMP counter, just state that.
