Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AD261FED
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgIHUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgIHPTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:19:54 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E1DC061A1C
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:14:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x2so15748079ilm.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/53F9WIxOg4aNONZFOJnQbiQlplRuRbaaauqCgOOLbQ=;
        b=BFE6Lg5Lmm9uBNCTgussoq14Nv0l1PEvh6cSYxRjyEu9FuX2K7aabkmvps0nl6i2rA
         49d5ycG3R4Ksedn2Oi/EVZutZINZOdxaTWXMCbCOiKEJbhb3byiIpuPivKk/JX0BD5ZB
         kRl7AOVgrHmPfw8n0AjRK825p9xK3yjEVzPji2usVPQkXXDkl6Dzzw/gdsrVX4QNEHtI
         1FqDNo/xO93ProjjnYesoOirs2kCd9gHRI+hJth6GeC5jdXS0XJAlWVktil4VJeN+9dD
         2RpLM3LpWlry+7d/GKYoTBXMtx2Lb9Fik3V6DBqm2f3EQQSGBxYdgsOqTVfQp9LGuR0w
         et2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/53F9WIxOg4aNONZFOJnQbiQlplRuRbaaauqCgOOLbQ=;
        b=J14r2+xhlFGomPXTBML2nk/vEikonly9X9OWSizKDtG5LazlqksxOS/Hme30CQU0g9
         0uHUXJBsoBhgBtxtMlhDKbYkWsC4LNEFjYasluM/Twvgdh5ri87G6GYvTxvu8oUqK+wD
         fDpGBZOfJsuDB2DuIpRxbxBF9XeXUJEEbc1JMULjfNyfF+1rS2zMSxt0DYEyLKd6BW9a
         8xj1fGqYRghdJ+Cqf9VoLOEamiZYbmt2xXj9ME/nWDgxM+vbDc7kNlFUnDXPLNGu4+2g
         OLxuMwc5zTE71zhJE2JpGbKgsto6kBK9ZyEHdSIkAnScyiDCR2ofHA1q/r19A5PdbgVK
         g/nw==
X-Gm-Message-State: AOAM531oNdaQ9DB4ruBcEPoUct78M0ox2MVmh3UqVBohgfD/EEwfzGZR
        ULG1FWVwAPN7iikWTgVg34bKikIUByUD4A==
X-Google-Smtp-Source: ABdhPJyTNicyj3fYytaYS8MVlyJI1n8rxNhJTI2xwI+7dCjN4dOEsEhsJZwtIhmzC5cTXb+sVR+kpw==
X-Received: by 2002:a92:9fc9:: with SMTP id z70mr22765101ilk.91.1599578079098;
        Tue, 08 Sep 2020 08:14:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id p3sm10344910ilq.59.2020.09.08.08.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:14:38 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 10/22] nexthop: Allow setting "offload" and
 "trap" indications on nexthops
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-11-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e07b34f5-b36e-b0f7-8f1a-e8a7ae5131ac@gmail.com>
Date:   Tue, 8 Sep 2020 09:14:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-11-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a function that can be called by device drivers to set "offload" or
> "trap" indication on nexthops following nexthop notifications.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/nexthop.h |  1 +
>  net/ipv4/nexthop.c    | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 0bde1aa867c0..4147681e86d2 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -146,6 +146,7 @@ struct nh_notifier_info {
>  
>  int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
>  int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
> +void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap);

how about nexthop_set_hw_flags? consistency with current nexthop_get_
... naming

>  
>  /* caller is holding rcu or rtnl; no reference taken to nexthop */
>  struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 70c8ab6906ec..71605c612458 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -2080,6 +2080,27 @@ int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_nexthop_notifier);
>  
> +void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap)
> +{
> +	struct nexthop *nexthop;
> +
> +	rcu_read_lock();
> +
> +	nexthop = nexthop_find_by_id(net, id);
> +	if (!nexthop)
> +		goto out;
> +
> +	nexthop->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
> +	if (offload)
> +		nexthop->nh_flags |= RTNH_F_OFFLOAD;
> +	if (trap)
> +		nexthop->nh_flags |= RTNH_F_TRAP;
> +
> +out:
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(nexthop_hw_flags_set);
> +
>  static void __net_exit nexthop_net_exit(struct net *net)
>  {
>  	rtnl_lock();
> 

