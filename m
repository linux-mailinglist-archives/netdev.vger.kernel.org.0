Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0E123B0EE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgHCXau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCXat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:30:49 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F929C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:30:49 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 2so32735967qkf.10
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y7GqFz2mWvTr7XtWeQW+VB9Ej11kKdP7jccN0hMh14Y=;
        b=tTBJTSILryV9nSicado3GQHFYYZ/RLOM1stYbEBqpAlZlYUSs4caj5/+WqmD2aPJvi
         LPzeYXM79HfLr9Uj3zHuiNUZd00f0M4761zsqBkOO9MV8xYVrcqIZ4zrySy3rMEVUttN
         OY9i0rL9WFRPdtIYkCr0iOYw1oj+xMDMoy0as6/uryXcVC4eqoZop8D+4UKkkv9NIZ3E
         RBbzVrseHEm0fjFN/qgBvfcYykkYyukuJde/3P23w9KXxs9mp8utPtGzNoeAH06ROKsG
         EuY4et0J+MiSfx441jQuL/skyWaKo4NzdvlSvs1KqpwJJTnAyv9WVnGfyskkgRO9Kb4P
         hSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y7GqFz2mWvTr7XtWeQW+VB9Ej11kKdP7jccN0hMh14Y=;
        b=BWm632NFbUYfrNHoQq7RdGkeAuv+aPemf31E3bNeS6NGX3UYsAHc+dYTlQXLVmBKoT
         llbgBShC5kN5Ozs7oPcV9YjrtCENDX//shYJhtuL5taed7P9hE6c0bm0QPnE9DxcmSu8
         JaMEiYYlCdsWTM+zNG99dvjejzpRiNM7WkZwN8U2j7AAcHsb2h/8nZklG+Ppy+1PBr/c
         fQT7NUyD4iEbqpTdFEXZY9kpjSQ0lwH3NurASErrY2FAmR5geVL9yUscNUd768TYfKou
         vGUSu0+1kklTxzUAQ5IOvg2xoZK4sshkT1PsFBKs1xbNS4YzcTUKBg1YGhI446W+tbkv
         gGqA==
X-Gm-Message-State: AOAM530tJnAIseUpTQTCVmKTX4zLjIEBOglPHvP75qNhLT7kZ9cgxcj1
        fnSNFx0LrwINnzR20RH7MF6Sr3e/
X-Google-Smtp-Source: ABdhPJziHxe9KAbeAjpCvxQ60MOSVNcE5FLVEg/tuT/EpFGVkkBS7a5FE0IsiCWugL3YR1snIb7pgA==
X-Received: by 2002:a37:9287:: with SMTP id u129mr18145617qkd.238.1596497448635;
        Mon, 03 Aug 2020 16:30:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c16b:8bf3:e3ba:8c79? ([2601:282:803:7700:c16b:8bf3:e3ba:8c79])
        by smtp.googlemail.com with ESMTPSA id t8sm24833010qtc.50.2020.08.03.16.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:30:48 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] ipv4: route: Ignore output interface in FIB
 lookup for PMTU route
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596487323.git.sbrivio@redhat.com>
 <86a082ace1356cebc4430ea38256069e6e2966c3.1596487323.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26681884-43fa-65b7-4832-ef9d757e8c0b@gmail.com>
Date:   Mon, 3 Aug 2020 17:30:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <86a082ace1356cebc4430ea38256069e6e2966c3.1596487323.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 2:52 PM, Stefano Brivio wrote:
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index a01efa062f6b..c14fd8124f57 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1050,6 +1050,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
>  	struct flowi4 fl4;
>  
>  	ip_rt_build_flow_key(&fl4, sk, skb);
> +	fl4.flowi4_oif = 0;	/* Don't make lookup fail for encapsulations */
>  	__ip_rt_update_pmtu(rt, &fl4, mtu);
>  }
>  
> 

Can this be limited to:
	if (skb &&
	    netif_is_bridge_port(skb->dev) || netif_is_ovs_port(skb->dev))
		fl4.flowi4_oif = 0;

I'm not sure we want to reset oif for all MTU updates.
