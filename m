Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAE1A76CB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfICWRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:17:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44446 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfICWRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:17:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so9974819pgl.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+49jYAt/cTc0JQj+iUCFarvKdCzcdPAe1yY7LUy2AAk=;
        b=uvdjWga77TsAe82aS3x1gRTcSsz+baGSOKaPSoQDWsSCXJLtMniab8X2lzhaXseAg0
         0ghBxgxYM9LpxtV57IFrIaaQ20mLfCIg3nYQeFLmb/ucSCj2biNRtN3cnkjpiuJxm9ZI
         fMSIZZOXusU6a9U6YrvBn2xlPJHn82VLfGv7AqmBuV++Pt9ePhKymkVA+YwGQhNw2ckA
         rlycyEsHBiXPWvlQ8fRYwMEI8K5ioKrmTm4Ua1n4bfU45ee++kWi/nRJ1WyXgsDgxLBb
         oZ91Rir2MvOlLqpHiHJXJtVskc747thK9EC0UfAMy72+9OId1LaQPjJUzHI6234DBQ6G
         vg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+49jYAt/cTc0JQj+iUCFarvKdCzcdPAe1yY7LUy2AAk=;
        b=Q+Dy4f4AxyW6iAGFrP9SCWP/y06WgXkIOOaeBon5F0ANHcRYyvo/0oUXDjePruEYez
         LWeAWY6q5btxxtMebbU13hjANQO9gCh2jvKTuvaU2MLKBilsoiyP+XA0jQbnq7p1lAli
         MHhOi+R224V/iImLx2+VQ11ABXM0hvrb7A86/u1QmQjFMjJTcu79Ih2hw8IcHe0zZtPv
         JyR8CtXdHod9NaWNqJMsblLPX9skhgUHuLWeaMxYdqHE6/DC09wwSe1lhQuYjjcJX+81
         6+m8HXuHC6/oCkk2zJ1ru42V0eOhsigjWpCqnsV7FZqPetcx9fIv+He4BiaTysnixwD/
         o3Mw==
X-Gm-Message-State: APjAAAWep+wHPvxQkM2FNQAMz6fL10JGT22d2C2kzRXHAN50U1L4XpYt
        QZzDSSVCztNs4wwe/Ho+pL0Cnifm
X-Google-Smtp-Source: APXvYqwJ0xRHffyBnGrmJx8fQS9xSlwNgWMsyBcxkNk2GIe2llUkSzkkkEF/bZkce1TjXC19Au+VCw==
X-Received: by 2002:a63:4a51:: with SMTP id j17mr32210231pgl.284.1567549033254;
        Tue, 03 Sep 2019 15:17:13 -0700 (PDT)
Received: from [172.27.227.244] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x5sm5940588pfn.149.2019.09.03.15.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:17:11 -0700 (PDT)
Subject: Re: [PATCH v2 net] net: Properly update v4 routes with v6 nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@kernel.org, sworley@cumulusnetworks.com
References: <20190831122254.29928-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4cecf207-775c-6b40-8152-66880de2be58@gmail.com>
Date:   Tue, 3 Sep 2019 16:17:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190831122254.29928-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/19 6:22 AM, Donald Sharp wrote:
> @@ -1684,7 +1684,8 @@ EXPORT_SYMBOL_GPL(fib_add_nexthop);
>  #endif
>  
>  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> -static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
> +static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi,
> +			     u8 rt_family)

The fib_info argument makes this an IPv4 only function, so the rt_family
is extraneous. Remove it here and the #else path below and use AF_INET
for the 2 calls below.

>  {
>  	struct nlattr *mp;
>  
> @@ -1693,13 +1694,14 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
>  		goto nla_put_failure;
>  
>  	if (unlikely(fi->nh)) {
> -		if (nexthop_mpath_fill_node(skb, fi->nh) < 0)
> +		if (nexthop_mpath_fill_node(skb, fi->nh, rt_family) < 0)
>  			goto nla_put_failure;
>  		goto mp_end;
>  	}
>  
>  	for_nexthops(fi) {
> -		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight) < 0)
> +		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
> +				    rt_family) < 0)
>  			goto nla_put_failure;
>  #ifdef CONFIG_IP_ROUTE_CLASSID
>  		if (nh->nh_tclassid &&
> @@ -1717,7 +1719,8 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
>  	return -EMSGSIZE;
>  }
>  #else
> -static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
> +static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi,
> +			     u8 family)
>  {
>  	return 0;
>  }
