Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63370A418B
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 03:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfHaBsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 21:48:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46227 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfHaBsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 21:48:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id o3so4096064plb.13
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 18:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xJgw8Hr2Gj0y+BG1WKsKeKejJfrzJC2ejy3fwY+Cits=;
        b=uvznGtnFnBGOusnhVGujW/quhqQPdEILIcqjabZYw2e3CNY+H2Sp8N+XyhqUe4hrT+
         byOOKd0iAoyqPLGRY4me2W35Sk82TCZ+Vv8uSUnpgoai+/i5UBWt9ChgI4Jych2tCRBm
         hMKikQxGTz1d7210uw3ZWEdIYwhhFAVYILIE+CLXKsQkZL66emsK5jIY5Pj8VCsyNTQ0
         /3e14D1ZOfPRj9t47GShQBlm/CMI4I2D7j000clyIsIXN3foSL9LXeQpYuk/AtocDYnE
         v1jC+J2T6fhCvTInARsvCbAqtKNawkHqpJfs3QOxz+bT0ZYzD6S2ty1QQgxx1xWRva/p
         eiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJgw8Hr2Gj0y+BG1WKsKeKejJfrzJC2ejy3fwY+Cits=;
        b=HjOYYa6IYfpKbPrY1tSk3bdA8+OpnR/vqCRsRIssrRq/rxI5CQXO8Sk4IMl+3l3j/c
         8R9F7GnfsijEPTHJfAWD6QRTpLTKk4554ymgxRXwzE1W2zPvhXkD+mmYvSaT/3qQs2HF
         6jXTVFqSgtBM1Vc9IiCVJpOhauF10G2na0C3UY9N95Dz42P+O09S6JK/nLterJwnP7AH
         92LkTqHcG+ukZYPwT795MKgjnSmwIUz0r2o1hW2vR0MPQ4sbc+tPDR8c6Bcjt98k0cEe
         QoSHrFsLPTNH/2EAIIDC0ZqMsWK1t2MlKZxBwKs4ApMgHjS5OQIvujdvD6Zx0Q28G/ax
         2QAw==
X-Gm-Message-State: APjAAAWK1/RKV0Y8a+wOszmqmykXsQdSqG6n85HaY/EWMiCybkMpbMiC
        M37sYm4ZJ+n+Y8OMquS7lrc=
X-Google-Smtp-Source: APXvYqw/AqHDZKof8kjCS/9XU2viDTOnG/cZzPFV8xfH6+VFaeGfc+/1ipiw8/knrBBZC3xnogaTEA==
X-Received: by 2002:a17:902:2bc8:: with SMTP id l66mr19054181plb.222.1567216086843;
        Fri, 30 Aug 2019 18:48:06 -0700 (PDT)
Received: from [192.168.1.82] (host-184-167-6-196.jcs-wy.client.bresnan.net. [184.167.6.196])
        by smtp.googlemail.com with ESMTPSA id q8sm19472041pje.2.2019.08.30.18.48.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 18:48:05 -0700 (PDT)
Subject: Re: [PATCH net] net: Properly update v4 routes with v6 nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@kernel.org, sworley@cumulusnetworks.com
References: <20190830181446.25262-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4b2e04e-295a-a8c4-138e-8b9dd5606cde@gmail.com>
Date:   Fri, 30 Aug 2019 19:48:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190830181446.25262-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 12:14 PM, Donald Sharp wrote:
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 4c81846ccce8..c7e94edae482 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -513,7 +513,7 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
>  			  struct netlink_callback *cb);
>  
>  int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
> -		     unsigned char *flags, bool skip_oif);
> +		     u8 family, unsigned char *flags, bool skip_oif);
>  int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
> -		    int nh_weight);
> +		    int nh_weight, u8 family);

Call this rt_family in both for 'route family' to make it clear.

>  #endif  /* _NET_FIB_H */
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 95f766c31c90..f13c61806abf 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -172,7 +172,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh)

nexthop_mpath_fill_node should take the family as input argument and
then ...

>  		struct fib_nh_common *nhc = &nhi->fib_nhc;
>  		int weight = nhg->nh_entries[i].weight;
>  
> -		if (fib_add_nexthop(skb, nhc, weight) < 0)
> +		if (fib_add_nexthop(skb, nhc, weight, nhc->nhc_family) < 0)

pass it to fib_add_nexthop.

>  			return -EMSGSIZE;
>  	}
>  

The rest looks ok to me.

as an FYI for the archives, the fib_nexthops.sh script does show the
unexpected gw for IPv6 but it does not flag it as an error. I need to
fix that so this should have been caught in the original submission.
