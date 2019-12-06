Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C73B114F25
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 11:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfLFKmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 05:42:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40609 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfLFKmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 05:42:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so7210860wrn.7
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 02:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ITssicnubGUXjNAdjKreGi4FjOYoVJ0UEE8ulgb6FE=;
        b=msTxkh1gQiNVYbTq63tQfNU56gF3S7zqJPqTztUZjU3rso0VEhCG8UjbSY50H9ry89
         nwKwFs4pid+SHb6ITQ8rRInVag5GmPS8/MqgJFKzpK8EvsPRIcnk/GhX5seVY8Xe2bP8
         40HypEjwTgA0Ra55j9a6cmCyalMQNgkt2kwbIrHl87J9d+mq/IEuGP09LyxcEu8iFr84
         N3rudDqzpf2zEino37W6MK3zo1TGio7C++TTDI9Es1u/yP5WLHmUuvDRSODQLGC0BYHu
         mfOAP8BWAmdPWeOjK/UhjLod2C+DjOGZpIyiaMXIniiy0g9aXoii9Y+GOfxgISUjyQXa
         v5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ITssicnubGUXjNAdjKreGi4FjOYoVJ0UEE8ulgb6FE=;
        b=Vu0feFIqQchvmDbo5mR3u2XksLPReaqBWUd0i5/ngLLfl0yt2mDOKjQ9/iVlwsaUIh
         q2Mhg5ip6J+ThyyHi/sULXsDmU2NNZ5xcAv6YHC8iSEB60Nc+59aOy84oH3Oy1QmlrK3
         coHxVLN9bIK7sO0Hcb3u4VsIgiDtogR44sO+cYV2V2C+745/BBThXREN17J6WEuQE7a9
         ZUrCLhWKl1+blQKokwghmhDwH/DwW1UqpYaToY7RdMWgwShSkxTtI+spiVEnEpLG0aOg
         yuLD1RekhlJhr7U8zGowldNMLL4loEc/gRvfbe+PlSO5VfKmdVlszKGtxLuavzJBzB2C
         0aWw==
X-Gm-Message-State: APjAAAUXsb9Uf0MAKN3D+lv3HdxhaJsnLfycpyIgJQxJ0O5RCiogEYlt
        MmRrj/kIyKOmjuOlVjgXaC/38g==
X-Google-Smtp-Source: APXvYqwxGNHL0bszK/v2AlgpLL+OcZ3INscN3tNLGVDL+ZdS4P2N38TFo6qqbPF+8IBGPYTcLTAJUw==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr15485264wrm.13.1575628934171;
        Fri, 06 Dec 2019 02:42:14 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id y10sm2852405wmm.3.2019.12.06.02.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 02:42:13 -0800 (PST)
Date:   Fri, 6 Dec 2019 11:42:13 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after
 pskb_may_pull()
Message-ID: <20191206104212.GE27144@netronome.com>
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On Thu, Dec 05, 2019 at 07:39:02PM -0800, Cong Wang wrote:
> After pskb_may_pull() we should always refetch the header
> pointers from the skb->data in case it got reallocated.
> 
> In gre_parse_header(), the erspan header is still fetched
> from the 'options' pointer which is fetched before
> pskb_may_pull().
> 
> Found this during code review of a KMSAN bug report.
> 
> Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
> Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/ipv4/gre_demux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
> index 44bfeecac33e..5fd6e8ed02b5 100644
> --- a/net/ipv4/gre_demux.c
> +++ b/net/ipv4/gre_demux.c
> @@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
>  		if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
>  			return -EINVAL;
>  
> -		ershdr = (struct erspan_base_hdr *)options;
> +		ershdr = (struct erspan_base_hdr *)(skb->data + nhs + hdr_len);

It seems to me that in the case of WCCPv2 hdr_len will be 4 bytes longer
than where options would be advanced to. Is that a problem here?

>  		tpi->key = cpu_to_be32(get_session_id(ershdr));
>  	}
>  
> -- 
> 2.21.0
> 
