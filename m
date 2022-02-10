Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF67F4B1520
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245639AbiBJST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:19:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245623AbiBJST1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:19:27 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713D010C2;
        Thu, 10 Feb 2022 10:19:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y8so8975137pfa.11;
        Thu, 10 Feb 2022 10:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kP/r6ciT/Vm39ZDyFy8OC4GH3CIXX3/lFIjjnRjDeJE=;
        b=U+SP4WF7R2F/etf0bWXIhP/okFePvx1VZDmuZFyiw+EBCaN+dxWqSAUxrJI5hL07TJ
         IaeRKDsbrukIcuXwdL3vHDfksxNsC0MYgyEZSZpqfWmEZoW4h0jrNJjXSV13WInI9Ez4
         Um76iQoNXbX0mQzVhFqMrDYQ6Rgh5XttF3mOhkU7WpGAH741UoW2Ov5+MDBD2K9+OgyC
         7J+3JX3XdSVNSY3UFJaZ2LV/zIi9qENdSbn79OcFYCpOWGm26GeYdRS5FLMjms02iU4J
         lpDa+IPnIx99qiEz5QjbIwJuJxKHCcC0Z8EuUMsIh8jV+Vcub9lHLc5g56FGEk91KePR
         RKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kP/r6ciT/Vm39ZDyFy8OC4GH3CIXX3/lFIjjnRjDeJE=;
        b=bR6Y8QrTWDaRsjGn5idsDxMJ6434WCuViE6M+CGTolzVoS14/TLotrNg4PjdHMdZVD
         d8sQnQ3IkwFy9EGwnB+ANr4VrV72iANhxrLmofxpw/ReAvUC2Vx+ZRtky13DHppZRwVv
         Hz0lkpW7+Iy+Avpn9s4Q8HU6P8xf86xANCSXUFTraCNP7jukbK4z4b5X0T9fKxIqvafc
         GG9NvPXH8ISIdTLEBECvgB8+dloZMLwhAI97SVaZG3xxQotb1hQC9jmcQ73SccirHsGM
         EfJ0aASuVqYVpabpD0fFgCUTCbQA8cqmxW4W5tw0OydSp1FszgPy77vv46s3njNOXdPX
         TpvA==
X-Gm-Message-State: AOAM530ocmraxhK8VQp7YgFSjS3uruIXc2a/yUpHcXAO8DI3JplOhlIz
        WLiAGX/noeWwomfzuYxtMJMndvBZfY4=
X-Google-Smtp-Source: ABdhPJyTCdtsFxy4cqBTRW830iCwzbzx6TN2AKBZig/fQJXIWdaxcr20MBLDBb2Goc9zC9o2qRGCrg==
X-Received: by 2002:a63:864a:: with SMTP id x71mr3152989pgd.380.1644517168025;
        Thu, 10 Feb 2022 10:19:28 -0800 (PST)
Received: from [10.20.86.120] ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id f8sm24518343pfv.24.2022.02.10.10.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:19:27 -0800 (PST)
Message-ID: <e867c94f-b817-b520-6d98-1e410df978a7@gmail.com>
Date:   Thu, 10 Feb 2022 10:19:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH] Generate netlink notification when default IPv6 route
 preference changes
Content-Language: en-US
To:     Kalash Nainwal <kalash@arista.com>, netdev@vger.kernel.org
Cc:     fruggeri@arista.com, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220209203818.11351-1-kalash@arista.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220209203818.11351-1-kalash@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 12:38 PM, Kalash Nainwal wrote:
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index f03b597e4121..fd14f5b1c767 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -1337,8 +1337,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  			return;
>  		}
>  		neigh->flags |= NTF_ROUTER;
> -	} else if (rt) {
> +	} else if (rt && IPV6_EXTRACT_PREF(rt->fib6_flags) != pref) {
> +		struct nl_info nlinfo = {
> +			.nl_net = net,
> +		};
>  		rt->fib6_flags = (rt->fib6_flags & ~RTF_PREF_MASK) | RTF_PREF(pref);
> +		inet6_rt_notify(RTM_NEWROUTE, rt, &nlinfo, NLM_F_CREATE);
>  	}
>  
>  	if (rt)

route exists, but the flags are updated so that should be NLM_F_REPLACE.
