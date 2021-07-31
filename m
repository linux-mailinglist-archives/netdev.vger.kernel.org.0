Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4CD3DC726
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhGaRSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 13:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhGaRSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 13:18:04 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7174C06175F;
        Sat, 31 Jul 2021 10:17:56 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso1197572otq.6;
        Sat, 31 Jul 2021 10:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VBFOhjOELzONs4QzqrGKY4r1pt4kNYPN+iXUO9A8HRo=;
        b=N9bRK/48BMswzWvFDp+hnpgMPXfBw7DFPC19+KpweWJt3pFkZsVC4AMiq/Yyg61GWb
         axBC1y3M1D05GTfP0vk5GdqMOOHqnOlJBbGS20g5Th1RIO7LvIHFH/mTWfXvRxX/fjVd
         OPbzwTCGhJrrygPx9QD6QHKSBApwu1ZOwOPvSEskg/uMzPU3/g9KAC19hPXWkMqQFzi8
         3Ut9ULN5QhczSVYl3uh9I8Rz2htQz8oGy3fvOsV8GOLJMN8fTr7K1t8ZVztUer0rwYSz
         iQ4DEuOhKk4+gUWKpGNVebBaDEv8UqxFxF0cdlNfzRWjb+Po3W/0qIhF0Jna/mjvJtAR
         CJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VBFOhjOELzONs4QzqrGKY4r1pt4kNYPN+iXUO9A8HRo=;
        b=pqJIFqLRUHbP+oTQQ+tLUu2rnsgcGnvGZjkG1gjptkmBL9ZdDxL3DfpCG+1ethARHI
         rfLQ/l51y5UYlH9FwAPQWSvsKCq/sTPQFVFI00aiAeG0TWW3/97bcQTCVb6qi93Zomh1
         089RC5D5sOCPKWcAaPuFnSJwHXrT8wc+dhpCQZ7Zy7aYFyzn8Rur1H4eILLEljKMQ4UB
         kCqJbWC1fXONS1halTc8Sg14jkjxW+0/P/gKV51PqTschZBb0GGQOnFqwgfGH++a67IS
         vl0TUEOjYRyd9LcmU57zsYA7EOkwLed1yYy5gt2jGEHejroF3qCzxXotLNXliHMVkHtk
         fBWA==
X-Gm-Message-State: AOAM530rMWngf+jRU1JKIUBnOA0cDbLjZaE1RA9Vpx2NL4rV7+M42HtU
        RJvYk65MF+YZ+eGrxombTEg=
X-Google-Smtp-Source: ABdhPJx8dMsfdRNVpMvtjqsv4yB7q1OfwLARLxoOCcl5wQCeeGCDMPXRWVPYcKy1drB1zqT/sE7kCw==
X-Received: by 2002:a9d:7651:: with SMTP id o17mr6259175otl.205.1627751875242;
        Sat, 31 Jul 2021 10:17:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id i43sm934749ota.53.2021.07.31.10.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 10:17:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210731015230.11589-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5be90cf4-f603-c2f2-fd7e-3886854457ba@gmail.com>
Date:   Sat, 31 Jul 2021 11:17:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210731015230.11589-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/21 7:52 PM, Rocco Yue wrote:
> The kernel provides a "/proc/sys/net/ipv6/conf/<iface>/mtu"
> file, which can temporarily record the mtu value of the last
> received RA message when the RA mtu value is lower than the
> interface mtu, but this proc has following limitations:
> 
> (1) when the interface mtu (/sys/class/net/<iface>/mtu) is
> updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will
> be updated to the value of interface mtu;
> (2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
> ipv6 connection, and not affect ipv4.
> 
> Therefore, when the mtu option is carried in the RA message,
> there will be a problem that the user sometimes cannot obtain
> RA mtu value correctly by reading mtu6.
> 
> After this patch set, if a RA message carries the mtu option,
> you can send a netlink msg which nlmsg_type is RTM_GETLINK,
> and then by parsing the attribute of IFLA_INET6_RA_MTU to
> get the mtu value carried in the RA message received on the
> inet6 device.
> 
> In this way, if the MTU values that the device receives from
> the network in the PCO IPv4 and the RA IPv6 procedures are
> different, the user space process can read ra_mtu to get
> the mtu value carried in the RA message without worrying
> about the issue of ipv4 being stuck due to the late arrival
> of RA message. After comparing the value of ra_mtu and ipv4
> mtu, then the device can use the lower MTU value for both
> IPv4 and IPv6.

you are storing the value and sending to userspace but never using it
when sending a message. What's the pointing of processing the MTU in the
RA if you are not going to use it to control message size?

> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  include/net/if_inet6.h             | 2 ++
>  include/uapi/linux/if_link.h       | 1 +
>  net/ipv6/addrconf.c                | 5 +++++
>  net/ipv6/ndisc.c                   | 5 +++++
>  tools/include/uapi/linux/if_link.h | 1 +
>  5 files changed, 14 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4882e81514b6..fcd1ae29f154 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -417,6 +417,7 @@ enum {
>  	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
>  	IFLA_INET6_TOKEN,	/* device token			*/
>  	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
> +	IFLA_INET6_RA_MTU,	/* mtu carried in the RA message  */
>  	__IFLA_INET6_MAX
>  };
>  
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3bf685fe64b9..98eeaba9f86c 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -5537,6 +5537,7 @@ static inline size_t inet6_ifla6_size(void)
>  	     + nla_total_size(ICMP6_MIB_MAX * 8) /* IFLA_INET6_ICMP6STATS */
>  	     + nla_total_size(sizeof(struct in6_addr)) /* IFLA_INET6_TOKEN */
>  	     + nla_total_size(1) /* IFLA_INET6_ADDR_GEN_MODE */
> +	     + nla_total_size(4) /* IFLA_INET6_RA_MTU */
>  	     + 0;
>  }
>  
> @@ -5645,6 +5646,9 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
>  	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
> +		goto nla_put_failure;
> +
>  	return 0;
>  
>  nla_put_failure:
> @@ -5761,6 +5765,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
>  static const struct nla_policy inet6_af_policy[IFLA_INET6_MAX + 1] = {
>  	[IFLA_INET6_ADDR_GEN_MODE]	= { .type = NLA_U8 },
>  	[IFLA_INET6_TOKEN]		= { .len = sizeof(struct in6_addr) },
> +	[IFLA_INET6_RA_MTU]		= { .type = NLA_U32 },
>  };
>  
>  static int check_addr_gen_mode(int mode)

Its value is derived from an RA not set by userspace, so set the type to
NLA_REJECT so that inet6_validate_link_af will reject messages that have
IFLA_INET6_RA_MTU set. You can set "reject_message" in the policy to
return a message that "IFLA_INET6_RA_MTU can not be set".

