Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4358A558A7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFYUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:22:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36789 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:22:40 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so13686ioh.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gzrxdz74KaD8C3FKctdtHzK8RCeCQWCtOk8n/PnUA60=;
        b=Do56nf8Thfkh+VUL7ifKwbIdfi6GmtTP9GXbwPCQceXdqojRX0NMLvsaPEYqfsD4HZ
         ELkjkNC4SUSR57N97AN1ylBH6y59CNSEO7VKXW5qogH/qQq2GU/NycoYMua0W9bLROfW
         AKMNu/iXNpnbBHg2U1iz8Dcn6GuZ27UUw0KBlg0PdPmRunq1fdl158pjd+PBQ87qDNgn
         tr/doL4KaONemYya9uwv/CN4gITqw/C3GV2LluNllmRLsegvtgX13rvGJbNhPjYFMopj
         aNWqNNowLcJrZqaBVDSwm0/QdBZ+JzRj/yNv5iwnNyxtp+23t+ZAuwG9tkqNBZiSl0X8
         0C6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gzrxdz74KaD8C3FKctdtHzK8RCeCQWCtOk8n/PnUA60=;
        b=hpTcw8GYD3esY50ABuyshw9DMNIBaLTahIs+UnGmJHz9zTWBVgEtJ3vh51p1cpVYyV
         lPZXs3fR1Bj9APFLb3/+sHYwpWczIHOxRbV/B0w6pNzqA+1FwhOEo4ZIzeLubHYj0kP5
         twe1dj93prueEGUQVPOnpJGPnBPTWAed2kiWUfdBXZ0VXpusKu3o+RrjdEplwDlRpTjs
         /Zss8zHEs4/vBIowo+2D6XV/ndqE4RLLEbmnVdCdAVILWvV1hzNH8fRfMCbtgBQa83Q8
         FgyXu75lK1+SgEHvgK9UeLPzaWuyomuq4kO0qnqCU6YY0WwaoXqL8tx45best57Are9N
         BDhQ==
X-Gm-Message-State: APjAAAXl8Z+Ig1Sg639F8zrXt9Mqf568f+I7Cvq8H+LvxdHd1RZdp4Hn
        0Wyp99bBk6Lk/OMBM80C239lMe/J
X-Google-Smtp-Source: APXvYqxZowl8IEYsRkvXPB3no9lbboHtCpP3MVgT9OBUVvqnkxkcqMX1AGFgEgKk4r46nd1ZgelHqw==
X-Received: by 2002:a02:7121:: with SMTP id n33mr94658jac.19.1561494159643;
        Tue, 25 Jun 2019 13:22:39 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:15b9:c7c8:5be8:b2c9? ([2601:282:800:fd80:15b9:c7c8:5be8:b2c9])
        by smtp.googlemail.com with ESMTPSA id 15sm13188011ioe.46.2019.06.25.13.22.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 13:22:38 -0700 (PDT)
Subject: Re: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190625103359.31102-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
Date:   Tue, 25 Jun 2019 14:22:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190625103359.31102-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:33 AM, Stephen Suryaputra wrote:
> @@ -363,10 +376,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  #endif
>  		   ) {
>  			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
> -			if (newskb)
> +			if (newskb) {
> +				/* Reset rt_iif so that inet_iif() will return
> +				 * skb->dev->ifIndex which is the VRF device for
> +				 * socket lookup. Setting this to VRF ifindex
> +				 * causes ipi_ifindex in in_pktinfo to be
> +				 * overwritten, see ipv4_pktinfo_prepare().
> +				 */
> +				if (netif_is_l3_slave(dev))

seems like the rt_iif is a problem for recirculated mcast packets in
general, not just ones tied to a VRF.

> +					ip_mc_reset_rt_iif(net, rt, newskb);
> +
>  				NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING,
>  					net, sk, newskb, NULL, newskb->dev,
>  					ip_mc_finish_output);
> +			}
>  		}
>  
>  		/* Multicasts with ttl 0 must not go beyond the host */
