Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C74460AE7
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 23:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhK1WyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 17:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhK1WwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 17:52:18 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4A0C061757
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 14:48:38 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so1418706otu.10
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 14:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eIU7OSYtKyFPpV9HgvRQj49bD5rWM4T/4vtedXHEEQA=;
        b=FRz2mCnqhNWwi36YqocG+pCT6x/QsiraCYWiNzjTkVIw9Gw7CPgOMbAonCXj6PAa+2
         x6tcCJc/wNt/jglHVE0N0J8SB88UYmXXaKMobfJe5l1xbG5B451nJ6ibQCCvf3jQObrv
         PDjNM1bakgzZ9skpJ9mP0+KLTK38FJiGOZtu1nInMpC/jwTdvhgiQ0udfNLG4MkfO5lQ
         AiddJHfFntjp8nCqt2kUw9gEmsLrPAjv/Xt86uMLkHA733JjHCzyUO3QQewrj1X3iSzV
         wFNVnWXRfj5uH4yMjD1/ZNIF3GgrxoXs0lLgYnEBz9rKcMSxlHY9+gevAAcZSWVUzUpe
         aYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eIU7OSYtKyFPpV9HgvRQj49bD5rWM4T/4vtedXHEEQA=;
        b=11hS7XAbbSzfOsuM6f/+vJIhkdZMkukKJaTVf2Cugyib5IGKUpEFX/JtPWoO65Lzzp
         RlemL3/Mz92Ut/Q3cjw99P/AUrAhmMxJ0faedAppygosnUiW55gdHZ4pryO3hhckYE65
         P9aLmsGx9QntsdpwdPfueroGG9wFiztYURILuf5f7mvVM/zUqF8MEJtLHyJJ3g6LJqmL
         go+YTqjl0FO4ddR5bKVjVTXc5sWm4vzxaWorlLEkuDVHuxOMtDD4OHrdIUwb8PMhU9lC
         HVEeXHQwsdEDBzMFhBUtYxxjRclsRGEIMPFss785NoMOVqhZASlxRoMjtCJgQVl6UAF5
         +x/g==
X-Gm-Message-State: AOAM530nIhFn+avF7Sbvd8MPi5nDzFnp7fwwcIRPF0Q87DB+yU1Clb2t
        9Mm8nK3wCfHg3K8sQMXf7oB1uTQeum4=
X-Google-Smtp-Source: ABdhPJx0BXbMf04Fi551wp7q6H+izlbttQM/E5Le1NwUFoyALAIvOr/riZTfHyHZA41+j9GNvv41LA==
X-Received: by 2002:a9d:6394:: with SMTP id w20mr41510079otk.248.1638139717677;
        Sun, 28 Nov 2021 14:48:37 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n189sm2580847oif.33.2021.11.28.14.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 14:48:37 -0800 (PST)
Message-ID: <1b3a135b-e4f4-dec8-de40-09d135a3f7eb@gmail.com>
Date:   Sun, 28 Nov 2021 15:48:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: IPCB isn't initialized when MPLS route is pointing to a VRF
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        ebiederm@xmission.com, roopa@nvidia.com
Cc:     fw@strlen.de
References: <20211122160546.GA95191@ssuryadesk>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211122160546.GA95191@ssuryadesk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/21 9:05 AM, Stephen Suryaputra wrote:
> Hi,
> 
> We ran into a problem because IPCB isn't being initialized when MPLS is
> egressing into a VRF. Reproducer script and its teardown are attached,
> but they are only to illustrate our setup rather than seeing the problem
> as it depends on what is in the skb->cb[].
> 
> We found this when h0 is sending an ip packet with DF=1 to 10.1.4.2 and
> on ler1 the code path is as follows: mpls_forward() calls mpls_egress()
> and then calls neigh_xmit(), which ends up calling __dev_queue_xmit()
> and vrf_xmit() through dev_hard_start_xmit(). vrf_xmit() eventually will
> call ip_output() and __ip_finish_output() that has the check for
> IPCB(skb)->frag_max_size. The conditional happens to be true for us due
> to IPCB isn't being initialized even though the packet size is small.
> The packet then is dropped in ip_fragment().
> 
> The change in this diff is a way to fix:
> 
> diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
> index ffeb2df8be7a..1d0a0151e175 100644
> --- a/net/mpls/af_mpls.c
> +++ b/net/mpls/af_mpls.c
> @@ -310,6 +310,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
>  			      htons(hdr4->ttl << 8),
>  			      htons(new_ttl << 8));
>  		hdr4->ttl = new_ttl;
> +		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
>  		success = true;
>  		break;
>  	}
> @@ -327,6 +328,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
>  			hdr6->hop_limit = dec.ttl;
>  		else if (hdr6->hop_limit)
>  			hdr6->hop_limit = hdr6->hop_limit - 1;
> +		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
>  		success = true;
>  		break;
>  	}
> 
> Here are my questions. Is this the best place to initialize the IPCB?
> Would it be better done in vrf.c? I can work on the formal patch once we
> agree on where the final fix should be 

vrf.c seems like the right place since it does the direct recirculation
(vs loopback which puts in back in the Rx queue).

> 
> Cc Florian Westphal since we found the problem after upgrading to kernel
> version that has his commit bb4cc1a18856 ("net: ip: always refragment ip
> defragmented packets"). But I think the bug is there without his commit
> as well if (IPCB(skb)->flags & IPCB_FRAG_PMTU) happens to evaluate to
> true.
> 
> Thanks,
> 
> Stephen.
> 

