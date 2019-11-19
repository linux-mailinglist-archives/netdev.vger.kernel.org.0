Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20E4102039
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKSJ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:26:12 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40243 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKSJ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:26:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2so22517164ljg.7
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EaDBGaUrTCyGilB8DhkN1F/kJnvQ8bUshlfDqjHoxzk=;
        b=ikbsjyFhsTnrhXVyUK14RaUtYzx0tqRfpB9YUHH//6RbExWy1uHu91Bw1ZqhWuYbEu
         J39r/tOknfZ3t8x8kShgq6SCikWU4DYb7MMMWoysNVhfxTMkRSwbTzcPvhMD4p8sgjAU
         4QjeCxbJ16VrHpovL5nIUKdXL9z22ioGdACH8vuzEQZROcVKDeT1ubAEzquTuG95sM2A
         dQCjEhbvewCWNLPG1cGfqrZ0tgg/uwcrzxR+vXipT65+wKK/fp/j6aSUv+FahTBJgOLG
         e3S4cGKWcfCPPuk+115tGtCk7iM7aynce+d36C6WeC1EWFqlTNcwmG/e0hO5Gj5du2CC
         xLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EaDBGaUrTCyGilB8DhkN1F/kJnvQ8bUshlfDqjHoxzk=;
        b=HccBYculbRYSnz/RTNaUWSbJcM7VID57G8xrRRprFHOdWgNe4ygKGA6dSn56/cf4Yu
         93y35HCGfEvn2byznVyMTOKFQLX7Nq9ftETLPHqRMf6UeZW9MWgZCW/RtLXqqBwf5goG
         Vkk6oKnjn1grtR/Xgc7LT2LadIc9fkgEJf67YDXo/FUtOJgQOskyZwMdkJ0zy0Bh5Uxd
         PwAn3F2+oBR2orTXFf5mTZXLSTzHqY6Eu7+8ak/8J4zOwQCQCoKQWAtMynYaOyMoLvou
         Vo+C/6N3BseaxO5pOR7RbcuOyO07WTHv27UANOSDs88zfUyzD8qcuRa9hU74qIu2U2vb
         OgXw==
X-Gm-Message-State: APjAAAWehbIZjXrFQ9LSUkp9vCGwTbLtx8ETuwscJa/ijpiP/49kfpjb
        to4L6QlTVclJqHJFIILFcDsB9Q==
X-Google-Smtp-Source: APXvYqxfnIPD6olHEqZuEZ+IBMXW4FA6tTunsko04mShwCPVfe7DxsvfHXGljZgNnffteATkneZFuQ==
X-Received: by 2002:a05:651c:1053:: with SMTP id x19mr2976201ljm.39.1574155567470;
        Tue, 19 Nov 2019 01:26:07 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:21a:5b37:6d7b:a689:ba65:5cea? ([2a00:1fa0:21a:5b37:6d7b:a689:ba65:5cea])
        by smtp.gmail.com with ESMTPSA id u2sm10244727ljg.34.2019.11.19.01.26.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:26:06 -0800 (PST)
Subject: Re: [net-next] seg6: allow local packet processing for SRv6 End.DT6
 behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191118182026.2634-1-andrea.mayer@uniroma2.it>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <703510f1-22af-aca1-b066-d2c38fe572b1@cogentembedded.com>
Date:   Tue, 19 Nov 2019 12:25:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191118182026.2634-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.2019 21:20, Andrea Mayer wrote:

> End.DT6 behavior makes use of seg6_lookup_nexthop() function which drops
> all packets that are destined to be locally processed. However, DT* should
> be able to delivery decapsulated packets that are destined to local

    Deliver?

> addresses. Function seg6_lookup_nexthop() is also used by DX6, so in order
> to maintain compatibility I created another routing helper function which
> is called seg6_lookup_any_nexthop(). This function is able to take into
> account both packets that have to be processed locally and the ones that
> are destined to be forwarded directly to another machine. Hence,
> seg6_lookup_any_nexthop() is used in DT6 rather than seg6_lookup_nexthop()
> to allow local delivery.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>   net/ipv6/seg6_local.c | 22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index e70567446f28..43f3c9f1b4c1 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -149,8 +149,9 @@ static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
>   	*daddr = *addr;
>   }
>   
> -int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
> -			u32 tbl_id)
> +static int
> +seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
> +			u32 tbl_id, int local_delivery)
>   {
>   	struct net *net = dev_net(skb->dev);
>   	struct ipv6hdr *hdr = ipv6_hdr(skb);
[...]
> @@ -199,6 +207,12 @@ int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
>   	return dst->error;
>   }
>   
> +inline int seg6_lookup_nexthop(struct sk_buff *skb,
> +			       struct in6_addr *nhaddr, u32 tbl_id)
> +{
> +	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);

    The last parameter to that function is of type *int*, not 'bool'. Be 
consistent please...

> @@ -396,7 +410,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
>   
>   	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
>   
> -	seg6_lookup_nexthop(skb, NULL, slwt->table);
> +	seg6_lookup_any_nexthop(skb, NULL, slwt->table, true);

    Same here, just declare the last parameter as 'bool'.

[...]

MBR, Sergei
