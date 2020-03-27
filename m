Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A74119520F
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 08:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgC0Hap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 03:30:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39131 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0Hap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 03:30:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so10174092wrt.6
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 00:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RAnXqIzInlW4gWec0Ule/RF9K8ErbWP7PH4Hkw1rX4=;
        b=dgRUN1R0wQm9h529YXRkAl4axvpannikJYVTwnEnUw2xGQuZcxewvOEa6QB6gHbUHp
         NPwZ5Iu/5O1NMKolGL+H5wTAphFE933V7Q76KIV/ChGxSOFaZuJXFGrMbcTzGjq6cMsZ
         eKQrmtE7yWhy9zYdkUDoTRMz1Vv0jI6fyxQEfljO4PH8e9pQj9QNTrFUjKI1tIkuA2Ua
         tDk1LcU0elxxUqh6HWNkQuJ84Mz1Tw4ptjKCSiYesZri2NReMVSlMstPg946mHGJZQW3
         qQTBPdYzc8rTGt9ITYC+jxfQ4NDN2yT2AfB2+M/UETU+JEUtn6/Uv22J/+/wykfu2zCC
         jbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/RAnXqIzInlW4gWec0Ule/RF9K8ErbWP7PH4Hkw1rX4=;
        b=WyCquqPjT/r0LPOlzBc1s3rnMjQnsLI67dauMivbqw00zY2/pTwduH6oaZH9N6xePx
         Qlaf4OUFH9BjCcWIINK3qFijkcTb5oJ5DiRyOElFCk1XyHIXDGb0pbJ1RxtxSw+WybRd
         An/LOjPBZ3MEGIGXunC7DUD/0NZc66eS7QTnKF8OT2spBOnTEVKLIQ0xzz9nabrjVPih
         JJqUBITB21w9H18qxtR1DPIFGU2kaJzua/zrZC5QNaly+iAbe1bb7LY5Apqe+KErpIEX
         67v1gtxRNC+akFz0gcEQGFc9N7EC3o+Ly4HCxdoS7/fxJUrbsAuDaiiOYwsTOfp6BuST
         XCnA==
X-Gm-Message-State: ANhLgQ1PyMCzpcLkJGd3kGFmEJ7IoW3KGfeF+/+K1ee3GKePqrVycqun
        HL81/DLXnwn3cJWS37OLpFddi2RRdTM=
X-Google-Smtp-Source: ADFU+vvFwfKXwTxLpJPhW4DBlVwUYlDOil9orYNPOjzfdWAHaeyrF06EzBmpSB2BtmRRpnrkRiL/Tg==
X-Received: by 2002:a5d:468c:: with SMTP id u12mr14402657wrq.394.1585294242801;
        Fri, 27 Mar 2020 00:30:42 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:bcbe:695c:bd6e:5082? ([2a01:e0a:410:bb00:bcbe:695c:bd6e:5082])
        by smtp.gmail.com with ESMTPSA id b82sm6868207wmb.46.2020.03.27.00.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 00:30:41 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] net, ip_tunnel: fix interface lookup with no key
To:     William Dauchy <w.dauchy@criteo.com>
Cc:     netdev@vger.kernel.org
References: <20200325150304.5506-1-w.dauchy@criteo.com>
 <67629ca1-ad66-735a-ecfc-28531b079c40@6wind.com>
 <20200326185626.GA22732@dontpanic>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d74c2c22-19e7-8be3-3d21-ea17c1863b13@6wind.com>
Date:   Fri, 27 Mar 2020 08:30:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200326185626.GA22732@dontpanic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/03/2020 à 19:56, William Dauchy a écrit :
> Hello Nicolas,
> 
> Thanks for your review.
> 
> On Thu, Mar 26, 2020 at 07:01:20PM +0100, Nicolas Dichtel wrote:
>> Hmm, removing this test may break some existing scenario. This flag is part of
>> the UAPI (for gre). Suppose that a tool configures a gre tunnel, leaves the key
>> uninitialized and set this flag. After this patch, the lookup may return
>> something else.
> 
> Indeed I was not sure about possible other impacts, as it seemed to not
> break iproute2 tooling, but it's true it could break other tools.
> But if we consider to remove the key test in that case, would it be
> acceptable to have something like:
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 74e1d964a615..8bdb9856d4c4 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -142,23 +142,32 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>     cand = t;
>   }
> 
> - if (flags & TUNNEL_NO_KEY)
> -  goto skip_key_lookup;
> -
> - hlist_for_each_entry_rcu(t, head, hash_node) {
> -  if (t->parms.i_key != key ||
> -      t->parms.iph.saddr != 0 ||
> -      t->parms.iph.daddr != 0 ||
> -      !(t->dev->flags & IFF_UP))
> -   continue;
> + if (flags & TUNNEL_NO_KEY) {
> +  hlist_for_each_entry_rcu(t, head, hash_node) {
> +   if (t->parms.iph.saddr != 0 ||
> +       t->parms.iph.daddr != 0 ||
> +       !(t->dev->flags & IFF_UP))
> +    continue;
> 
>    if (t->parms.link == link)
>     return t;
>    else if (!cand)
>     cand = t;
> - }
> + } else {
> +
> +  hlist_for_each_entry_rcu(t, head, hash_node) {
> +   if (t->parms.i_key != key ||
> +       t->parms.iph.saddr != 0 ||
> +       t->parms.iph.daddr != 0 ||
> +       !(t->dev->flags & IFF_UP))
> +    continue;
> +
> +   if (t->parms.link == link)
> +    return t;
> +   else if (!cand)
> +    cand = t;
> +  }
> 
> -skip_key_lookup:
>   if (cand)
>    return cand;
> 
Maybe less code duplication? Something like:

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 74e1d964a615..cd4b84310d92 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -142,11 +142,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 			cand = t;
 	}

-	if (flags & TUNNEL_NO_KEY)
-		goto skip_key_lookup;
-
 	hlist_for_each_entry_rcu(t, head, hash_node) {
-		if (t->parms.i_key != key ||
+		if ((!(flags & TUNNEL_NO_KEY) && t->parms.i_key != key) ||
 		    t->parms.iph.saddr != 0 ||
 		    t->parms.iph.daddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
@@ -158,7 +155,6 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 			cand = t;
 	}

-skip_key_lookup:
 	if (cand)
 		return cand;

