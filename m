Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0568C1FE995
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgFRDoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:44:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF11C06174E;
        Wed, 17 Jun 2020 20:44:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u8so1914631pje.4;
        Wed, 17 Jun 2020 20:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1Rgq0ulDPtp4yL9OdQkGowJ9k/7ZXwP4nQO/fYmYMbM=;
        b=Xh8lFTG082UWXegg2JpUiaBdyxR5+66Tax9pDwaZnh63dJCF3Wsx+Vb5MqF+DJiXWe
         46+7dFEvdQq1GlwQ4y5KprkaYajwpovX5/iAHlGU5a3zbZ3PAJYnM3C6dEIw1dqruSIQ
         fFSjnJbpsC/HjBInlX0Wcx6aWgix7nvVlUnmSrcoQc2xIe2J6gutgsXS144sPbjcgPzy
         ZSKA2rpxwpXfWwsSyt8KoucZAga+s+82sNrN726YGAbg2nZDd/SIII+9XVioL7sTCFe/
         SU5jTSYo1EtlR0xgmEzE/hm6sihHYIqqSRD+kXbHx41+Mk8SkAQF6FqHafpXOAhy0+vS
         l2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Rgq0ulDPtp4yL9OdQkGowJ9k/7ZXwP4nQO/fYmYMbM=;
        b=bVUuD8WsOhTZfwVZ8zcIFh8nvQJK3hrz/jZd68lVRHlvM5+JL4nzYN3AkTXQ2vrYRN
         gBrVvcUQ575HgwyBtIIL62+t/UpaUQKOkDYv1Dg6lcTIxxJLGF8Xsftd9HmfbgVNiUDa
         YZeJkbhmI/QA7MynTYfbbkSWG64o6Ygoxqia1YK8jHWFI56BeRuBc4QwoZ4cXcsaoQYi
         Di5AEOD9712cuG3dV7gxZQ6PowO8hXA2nbW7c7UmsoWC1PkkLuLparUNJxA9dy1w+ab6
         /HR5IsVr+GaK+3VO4uOr2O8VBimE0nO4m75Ta1Nl2PBVpGkEm9fGwh0a2eBHvHtreWpA
         BvmA==
X-Gm-Message-State: AOAM533TfZ/ShPr1BS1yMsCcQw4hNtMzdWnQuj6OwsNK1s7b8u/K3/0m
        ikcDLq0cSW3rhrVFQVSPH92a125P
X-Google-Smtp-Source: ABdhPJy83+fOVe5D78nh+uY3Ofr/Hi/62J/UjRsIJ5oTOKKnTAN5pZGy+pbcpkDkKjP3ONLWLAzFFQ==
X-Received: by 2002:a17:90a:ac0f:: with SMTP id o15mr2212743pjq.105.1592451841385;
        Wed, 17 Jun 2020 20:44:01 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t76sm1193806pfc.220.2020.06.17.20.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 20:44:00 -0700 (PDT)
Subject: Re: [PATCH] [net/sched] Fix null pointer deref skb in tc_ctl_action
To:     Gaurav Singh <gaurav1086@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200618014328.28668-1-gaurav1086@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c84daca7-4103-9f56-5cf8-a09a75159ebd@gmail.com>
Date:   Wed, 17 Jun 2020 20:43:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200618014328.28668-1-gaurav1086@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/20 6:43 PM, Gaurav Singh wrote:
> Add null check for skb
> 

Bad choice really.

You have to really understand code intent before trying to fix it.

> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  net/sched/act_api.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 8ac7eb0a8309..fd584821d75a 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1473,9 +1473,12 @@ static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
>  static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
>  			 struct netlink_ext_ack *extack)
>  {
> +	if (!skb)
> +		return 0;


We do not allow this

warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

> +
>  	struct net *net = sock_net(skb->sk);
>  	struct nlattr *tca[TCA_ROOT_MAX + 1];
> -	u32 portid = skb ? NETLINK_CB(skb).portid : 0;
> +	u32 portid = NETLINK_CB(skb).portid;
>  	int ret = 0, ovr = 0;
>  
>  	if ((n->nlmsg_type != RTM_GETACTION) &&
> 

Please compile your patches, do not expect us from doing this.

