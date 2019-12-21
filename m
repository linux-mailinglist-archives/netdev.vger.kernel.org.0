Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30189128AD9
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 19:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfLUSiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 13:38:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLUSit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 13:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576953529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VGqxPGXoZYC8FaY7sY3ykBgRUxtqVwH4a5DMTx7YxLI=;
        b=aG72xD9hTfuFDAdtF+o8OLQYAlrkmCZ0g1yNKHlOhuUgkUzsI8j4GibdXvsHr+dg4xBfSy
        KXc55HDv1q7pim3boLWByfuHod4wcXjVEiy9JVUrMoFYZZzm0TBvmKcDH9ZBDxCNmlcZxh
        fCoKfOr3tTVYfibDoWw0r32Ivb6v5QQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-TY-3hzefOL-YiVz5c_Gmjw-1; Sat, 21 Dec 2019 13:38:46 -0500
X-MC-Unique: TY-3hzefOL-YiVz5c_Gmjw-1
Received: by mail-wr1-f69.google.com with SMTP id k18so4447238wrw.9
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 10:38:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VGqxPGXoZYC8FaY7sY3ykBgRUxtqVwH4a5DMTx7YxLI=;
        b=pxaGy/jcVNniktQGoHUBwlW7BeFsV88SB7qQ+FS3IRJEUeBlkbeTKE7XDnQ2t2lTko
         St8/xFxXDODrDIBSV7XYJPf2/Dif4BD9H6OBL2xBnYED60B8hAAPiGGiyYnGjCjt+C7o
         41S6CO4aSY00UVXg9029wvV+M+w2Woqi47dmvYsdoM2x1Cqnkgwi+O4FFz09acad2Vp1
         H1jGqBGcYoTLGlg0fcH2g6yBoIuNiGj/S/BKYSQ5Dm7ja/ATwngMu8Z9DQzyx9lmkW97
         ZvV/WwAQh4uStR77zOrk43hW/4+0moU+2JWaD5mflfUNH2Ab4XgP24rwyKBtPxsxRGFX
         hoDQ==
X-Gm-Message-State: APjAAAVq5I9xP+H9YDwLSzGfF9pM3BuQSdbXgPc21QPUlwmS+T7FoxPA
        dUsPKmZgx2smxUJQ0asVPG1nlIHGkcDZMwtoJOFYR+Uofpx7ppdHML0FLBeu5BbictZkBfhqlRn
        mSo1Rq/Ssd6ziQvKy
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr21906116wrw.289.1576953525043;
        Sat, 21 Dec 2019 10:38:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqziEW3vxCahK5ZY1Ix/xXJBXGf+hjTCQgPVBZsva2bzM/ap1oX8qwNUj62hqozJztAOVUbaAQ==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr21906100wrw.289.1576953524883;
        Sat, 21 Dec 2019 10:38:44 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id x132sm17658525wmg.0.2019.12.21.10.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 10:38:44 -0800 (PST)
Date:   Sat, 21 Dec 2019 19:38:42 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCHv4 net 8/8] net/dst: do not confirm neighbor for vxlan and
 geneve pmtu update
Message-ID: <20191221183842.GC7352@linux.home>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191220032525.26909-9-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220032525.26909-9-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:25:25AM +0800, Hangbin Liu wrote:
> When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> we should not call dst_confirm_neigh() as there is no two-way communication.
> 
> So disable the neigh confirm for vxlan and geneve pmtu update.
> 
> v4: No change.
> v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
>     dst_ops.update_pmtu to control whether we should do neighbor confirm.
>     Also split the big patch to small ones for each area.
> v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.
> 
> Fixes: a93bf0ff4490 ("vxlan: update skb dst pmtu on tx path")
> Fixes: 52a589d51f10 ("geneve: update skb dst pmtu on tx path")
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/net/dst.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 208e7c0c89d8..626cf614ad86 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -535,7 +535,7 @@ static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
>  	u32 encap_mtu = dst_mtu(encap_dst);
>  
>  	if (skb->len > encap_mtu - headroom)
> -		skb_dst_update_pmtu(skb, encap_mtu - headroom);
> +		skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom);
>  }
>  
Tested-by: Guillaume Nault <gnault@redhat.com>

