Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17CA33CC4
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 03:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFDBgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 21:36:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42935 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFDBgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 21:36:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so8062777pgd.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 18:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L7M6oK1UHfGNRfGQaNApU8MBbkUXRm73r6MP5oAKCOY=;
        b=ScNfLN/TLf9uipgwF6lxLxK5e9vwT8wB9hrbvbwVt/gW08O3P6CHlye/86kHycK6+g
         DmMrHKBcBYeHWNbequR2aWoVqitFNmT9kYC6UbT1fSJ7LPsNzhdxaWyhC46cInRCGSMs
         L6OqQbudAiZA7pE11wJaInzymil8FfZiJ1N6e7ZL9hMthEf2n3lgxs+T+UiF1bwbD7Ff
         /HY+cnl1bDQWmH39NYc+IGU8IlttBGTmkyaWq+KEjWCfbcThIBZl5FsdYT3ncX8Zpinh
         D/kYg2zoJaFcOe+v+OkwSfLVxc9h+O4WaqOOisidcsx3tI/FkH3kVnfTNX9muzeiegsv
         DBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7M6oK1UHfGNRfGQaNApU8MBbkUXRm73r6MP5oAKCOY=;
        b=mnBrmEBTINaozXtN/mV08lUmBjLYdhq+tDJ4MlcznJF7tjgmg5mHUXDNkkU8CowtMp
         0cK5pbt+JeMY2VmqVYwsUh8xjGTlrl1qFAjbMOzz9jxO31qW3Qne/QictTYy3waRBtpf
         FUmeD3qcmVruhj6+V4RpKRyApe5oJA1FmgWV7DK/+Jh9Lptr4jqcuJdpWEQ9oAeOO+A+
         FlO/mImKR/BYizGbzyEw1qfJtIDGOT71p+T1IeAJ8SmvYLDroq9fC6f6dn0JiqgoNnuk
         LcifirUNXGaH8gcU/pU9+JUBRu07rmpr3j7OapYzAhP3LrDwAFHEX26jvdWgPSguv8x1
         nxPg==
X-Gm-Message-State: APjAAAWvj8M6bZKc+oUUUX6tCsV5gNMei7i0LPm62K0mdxH/n5RlyK8N
        bxEP2oqDkZwCkjmeIpqfA74=
X-Google-Smtp-Source: APXvYqy9rQsoUUVwg02qtX2qLtKgnOPUMo8azuYP4oeBTqLsKoO9Hini8qLYOziabz/s0LTfeO88mQ==
X-Received: by 2002:a62:4d03:: with SMTP id a3mr35854852pfb.2.1559612169651;
        Mon, 03 Jun 2019 18:36:09 -0700 (PDT)
Received: from [172.27.227.197] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id a64sm12812003pgc.53.2019.06.03.18.36.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 18:36:08 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Martin Lau <kafai@fb.com>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
Date:   Mon, 3 Jun 2019 19:36:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 6:58 PM, Martin Lau wrote:
> I have concern on calling ip6_create_rt_rcu() in general which seems
> to trace back to this commit
> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route_lookup")
> 
> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucket.
> In particular, how to react to NETDEV_UNREGISTER/DOWN like
> the rt6_uncached_list_flush_dev() does and calls dev_put()?
> 
> The existing callers seem to do dst_release() immediately without
> caching it, but still concerning.

those are the callers that don't care about the dst_entry, but are
forced to deal with it. Removing the tie between fib lookups an
dst_entry is again the right solution.
