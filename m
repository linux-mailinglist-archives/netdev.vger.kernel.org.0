Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D623A1C1
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgHCJar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:30:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20533 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725996AbgHCJaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596447045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OhB8EQdx0fMFvoZXTeHedNXLUoc0coC/TlC1y0aNOZQ=;
        b=S8daZlAOJkcJcEc6Zo+loB8/pQ/Smim+JxCcpU7SL8gN59UHQpxSyKoeM+u30yfMSSZfAy
        tFbvz4te6ZckAruo26zXrj12Kwbwnk19niI2HTVR+uiyqPL0a9DDBwHvEHjveSMPCZsoeD
        MZT7LrwWPjzNtnmq00uYdrhZKJ0TO4g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-XwO9Sa2JOWSiPtP4zzyQhQ-1; Mon, 03 Aug 2020 05:30:43 -0400
X-MC-Unique: XwO9Sa2JOWSiPtP4zzyQhQ-1
Received: by mail-wm1-f69.google.com with SMTP id g72so1095925wme.4
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 02:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OhB8EQdx0fMFvoZXTeHedNXLUoc0coC/TlC1y0aNOZQ=;
        b=P2WziEr/kATp6C+i6o2+Q10OOLePTvaacWs+5p7y5of80CbPGGsntmlmzwSEww73KO
         umF32sh8yUUmOK0x3aLvxhQ+le8m1kVvuFBfa0mZaFwAF041LvmcVX7cf4kZcq4VJgd5
         +hkRoujAOCgPDxsJUCTncRetyLQfiMbsda74AHbY2Aac6K2kUlk4VAB4bWj2BC1Ir5Qu
         yenkkaK2hy2MxVPxfGWyw/iD6zZdFdybZT7KUPXAW6lb2KZQEa0YoPYkOc45EKdd42r0
         cdDp668X7tp6TYIZF9nSZyiJLo9VplH2J5kUbjkrmh8F4QojBpwytT5bF9DvyMP5oIR4
         vrPQ==
X-Gm-Message-State: AOAM531jigoIRRjonBAwvbos+soDdhsItjWfP8+8gJudIGrfyuL/vCfG
        WDq7NI15U50dO5J9jxyn2k6s0cJO16JI/i8/fm+SVroCmMYcrKKmiC3MV4aJh76ilrmQ81jhBzS
        8d0+KKa62G1yhBIUr
X-Received: by 2002:a5d:54ce:: with SMTP id x14mr14201867wrv.52.1596447042352;
        Mon, 03 Aug 2020 02:30:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5t/JGrhTrs9V30f+uuTB42hdPQhw6p+yd7+7duVWcpfivIxcP5ZtljGKmkSwtQRkSSQ4LEw==
X-Received: by 2002:a5d:54ce:: with SMTP id x14mr14201852wrv.52.1596447042196;
        Mon, 03 Aug 2020 02:30:42 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 111sm24299272wrc.53.2020.08.03.02.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 02:30:41 -0700 (PDT)
Date:   Mon, 3 Aug 2020 11:30:39 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 2/2] vxlan: fix getting tos value from DSCP field
Message-ID: <20200803093039.GB3827@linux.home>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200803080217.391850-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803080217.391850-3-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 04:02:17PM +0800, Hangbin Liu wrote:
> In commit 71130f29979c ("vxlan: fix tos value before xmit") we strict
> the vxlan tos value before xmit. But as IP tos field has been obsoleted
> by RFC2474, and updated by RFC3168 later. We should use new DSCP field,
> or we will lost the first 3 bits value when xmit.
> 
Why sending this patch to net-next? Commit 71130f29979c ("vxlan: fix
tos value before xmit") broke setups where the high TOS bits were used.
This needs to be fixed in net (and probably pushed to -stable too).

> Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  drivers/net/vxlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 77658425db8a..fe051ed0f6db 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2722,7 +2722,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  		ndst = &rt->dst;
>  		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
>  
> -		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
> +		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
>  		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
>  		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
>  				      vni, md, flags, udp_sum);
> @@ -2762,7 +2762,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  
>  		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
>  
> -		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
> +		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
>  		ttl = ttl ? : ip6_dst_hoplimit(ndst);
>  		skb_scrub_packet(skb, xnet);
>  		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
> -- 
> 2.25.4
> 

