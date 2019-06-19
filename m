Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505834C40E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfFSXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:21:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45164 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSXVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 19:21:41 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so1481253ioc.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 16:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d3hmDUmXI7PB3F2/jxEksOSHFq1xVZ3WVny9rGmWBZ0=;
        b=UIeOPHNvK9WGuVslx0qodX78+E7pd+flL3J/dE+dPnz8iunybNx97oZH8UT0n1Xejj
         5LMhUVrOfindEL+CvC3HtH9Xy0F0ZvIKkbfYltsfyOxtesAwuMcAKGEgSZX91+Tes0OT
         finYw5mN2f9aRUSpw3LgrmLnSOzHRO3QvesL8lp4fW3wWX8D1zq9Uhs8XoO6v0QElpiD
         wgMQA9HLBb7ZnpMAWnofujuKWmO4pgdPco55g4Msz8apQmLh5U3KNyiUN7ZRnFABh+oI
         chdlCbAe0Z4uT6rBoZwR3fg37tfjVbVvDj/fJOsGS0/Dvp86oWnz9L1kuxgVO3rz6Qro
         E0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3hmDUmXI7PB3F2/jxEksOSHFq1xVZ3WVny9rGmWBZ0=;
        b=hg3QIr4l6eUHo6OfBmLgHd69VmLa6NEg7cbo+Y9CFVBE8CW68fHTUVIaq39rGwbPAF
         9rbKN6d9Pakvk1BqNI/llBi/VYDkC0kTM3Z8XoIkHS0NuTZ2uofc1WcwmI35jB5oWw1V
         3nHCcPf++QJQDZfQW+vyVlI2O9lIxkgwouCUg4fMNGJ0jjyR5ltpM+r60bN/2a3OD2o1
         2zb0UE4FLswSHIoOofWCmyD84d4374lrfwEEVX4g5lV6RPXF+HAbrp7hBEx6nQbdduDE
         RoT3gORyjC1Q0NAr46L2kNg7xFNJYVV4I07Z/uaTFN5sD6nuRZj9r9Jyk003UNIIlW8g
         85jg==
X-Gm-Message-State: APjAAAXtFgw3WE0HHc5wWnOc8XPOmmjF4/UPO3nUdWRsJlKA3uBf+WsG
        U7aPZryH4N3w8mPD4UJU6tQ=
X-Google-Smtp-Source: APXvYqxOPxtAtXyFXfhesiG6s5RbSYJyx8yEODS067hzdXajQXTFTfJThtmVSsnaUQt+MJtN4UZ38g==
X-Received: by 2002:a02:b050:: with SMTP id q16mr10368707jah.120.1560986500707;
        Wed, 19 Jun 2019 16:21:40 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30? ([2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30])
        by smtp.googlemail.com with ESMTPSA id 20sm20143692iog.62.2019.06.19.16.21.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 16:21:39 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 5/5] ipv6: convert major tx path to use
 RT6_LOOKUP_F_DST_NOREF
To:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
 <20190619223158.35829-6-tracywwnj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0860def-4b20-610f-3fde-f9601eb1600e@gmail.com>
Date:   Wed, 19 Jun 2019 17:21:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190619223158.35829-6-tracywwnj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 4:31 PM, Wei Wang wrote:
> diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
> index e942372b077b..d8c37317bb86 100644
> --- a/include/net/l3mdev.h
> +++ b/include/net/l3mdev.h
> @@ -31,8 +31,9 @@ struct l3mdev_ops {
>  					  u16 proto);
>  
>  	/* IPv6 ops */
> -	struct dst_entry * (*l3mdev_link_scope_lookup)(const struct net_device *dev,
> -						 struct flowi6 *fl6);
> +	struct dst_entry * (*l3mdev_link_scope_lookup_noref)(
> +					    const struct net_device *dev,
> +					    struct flowi6 *fl6);

I would prefer to add a comment about not taking a references vs adding
the _noref extension. There is only 1 user for 1 context and the name
length is getting out of hand (as evidenced by the line wrapping below).
