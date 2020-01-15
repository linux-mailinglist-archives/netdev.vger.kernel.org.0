Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995D813C2C0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgAONaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:30:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41670 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgAONaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 08:30:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so15748849wrw.8
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 05:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0YLzqfrLW1TFPTFyetIPuiU4ElOFslfRB5SrvXVr1Y=;
        b=f6cMykjpyXmxygcqE2TpVKg7UV+K0Agg4E0TxefSrOmALM/4BJDlqMlHR2jf02tuPW
         xYAphXgryB/d4YV5qZ4d0tijXFFhNp9FURjeXVwlILDjmwC7odkl0ghosoSnYlZe5QqO
         uhbXLkXDO1LbuOVxaqc3BTY2W7gixv49xDBFf7VRTpEhX2Fi8ovUw74HfuRhDtU2Kiqj
         afIGsAKFoU+ucW9fWlUsbhLZV6qPm3qTmqvIn/5XPP8+R8L08Nb1ZwG5RXm0Bh41V6LB
         p+36zHuFE1YfxJo+TBVGxuLcQY/PgJNsG1RMPFGNn7rj/IVx3ZHkjVAJPiQ39wfttMxw
         CVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T0YLzqfrLW1TFPTFyetIPuiU4ElOFslfRB5SrvXVr1Y=;
        b=jjFokNh3NEH0pThRZPkJm4FJ69Gr8ejElozRcHunFmhwwefXJm4tw7kiRdD8uVb7tF
         I9EvtdKVTmaOBBAhtfLK1F3HdkR41yO9ZNPh6lWFiFePWlWLFktdM68P7kvvoCCuDYiz
         KqRwv9hiNy3lT4b+AhUgJ+m+Gy2mTgr2mCJ0+4Vajxg5o6d4EzbuxoJGX46bm1qXxFmj
         rhxFQruvWhoQ6LhPM1Cf9idPoIXjqhw//yLKDh6HzVeJ+Ky8Yyt8MC0NA9/C56CpaDYj
         FfWzr4m3egsSAo9J9+OmBdFzSNSO4u4cYzAEUYOxz6EdBWHYZ7sWzvsiuwRMl1L2PRbs
         S8bQ==
X-Gm-Message-State: APjAAAXOydVaOAWzGmuMmTVhyZtdUH1r9RBnnuav3LDVI7StILNpnAhr
        FWYJGPCz/EEnPchkL4xVeUqVSQW9cM4=
X-Google-Smtp-Source: APXvYqyrItOspP7PzIFYcafj2bDEesRz+7eG0GLZXGDdaBXWA8uG8zNKeBA1JKfQubUCZZxLR/cmkg==
X-Received: by 2002:adf:eb46:: with SMTP id u6mr31881291wrn.239.1579095014987;
        Wed, 15 Jan 2020 05:30:14 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:d497:1e4d:f822:7486? ([2a01:e0a:410:bb00:d497:1e4d:f822:7486])
        by smtp.gmail.com with ESMTPSA id p5sm23430750wrt.79.2020.01.15.05.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 05:30:14 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/2] netns: Parse NETNSA_FD and NETNSA_PID as
 signed integers
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <cover.1579040200.git.gnault@redhat.com>
 <0f37c946179b082bf1c5e34d2cfdd9223979ea83.1579040200.git.gnault@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b4a7a751-5566-fd9b-d038-c80878ec41f7@6wind.com>
Date:   Wed, 15 Jan 2020 14:30:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0f37c946179b082bf1c5e34d2cfdd9223979ea83.1579040200.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/01/2020 à 23:25, Guillaume Nault a écrit :
> These attributes represent signed values (file descriptors and PIDs).
> Make that clear in nla_policy.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/core/net_namespace.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 6412c1fbfcb5..85c565571c1c 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -706,8 +706,8 @@ static struct pernet_operations __net_initdata net_ns_ops = {
>  static const struct nla_policy rtnl_net_policy[NETNSA_MAX + 1] = {
>  	[NETNSA_NONE]		= { .type = NLA_UNSPEC },
>  	[NETNSA_NSID]		= { .type = NLA_S32 },
> -	[NETNSA_PID]		= { .type = NLA_U32 },
> -	[NETNSA_FD]		= { .type = NLA_U32 },
> +	[NETNSA_PID]		= { .type = NLA_S32 },
> +	[NETNSA_FD]		= { .type = NLA_S32 },
Please, keep them consistent with IFLA_NET_NS_*:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/core/rtnetlink.c?h=v5.5-rc6#n1793

>  	[NETNSA_TARGET_NSID]	= { .type = NLA_S32 },
>  };
>  
> @@ -731,10 +731,10 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	nsid = nla_get_s32(tb[NETNSA_NSID]);
>  
>  	if (tb[NETNSA_PID]) {
> -		peer = get_net_ns_by_pid(nla_get_u32(tb[NETNSA_PID]));
> +		peer = get_net_ns_by_pid(nla_get_s32(tb[NETNSA_PID]));
Same here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/core/rtnetlink.c?h=v5.5-rc6#n2115


Thank you,
Nicolas
