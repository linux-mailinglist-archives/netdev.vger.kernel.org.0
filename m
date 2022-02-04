Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E164A92F0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 05:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356911AbiBDEJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 23:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356905AbiBDEJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 23:09:38 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729EC061714;
        Thu,  3 Feb 2022 20:09:38 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s18so5876490ioa.12;
        Thu, 03 Feb 2022 20:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9vd5xE0knFEuVKlXB3qXa46DN9ZLxiL/V6mLS4klh6s=;
        b=OYiVJbaeVKGlU0Qy0/egzhuPTlLjAtl5WWUGYD78em7H+P02gbi4zCXjhW7uM6Np/L
         LmdfZqNL9vzss4qH3u4psC1QZ3Qr+eRLuY8tr6FvDCLEHWt85900koNhoEMWa9Icubzg
         +MNGevJHAHWNHtqH3hLVRjQVa9lF3q3U/w/WOPdR/TnN/hHJlnwQITfh+KohtE07pcAC
         nbHl2DCnjPIR0LJjXKRKW4gMagwrg2dCnynMci2nO3T+tZVyt+MdhAGCNBdXAVX/JdGw
         T4HDeQ6suivK+wODqxH7ewEOiX2BGAQXWiN2cLzp+hG4us0RUakr0usl3BzzI4tiTtzl
         Rjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9vd5xE0knFEuVKlXB3qXa46DN9ZLxiL/V6mLS4klh6s=;
        b=viNzLbhTNXzITiihuhsSC2bUGj3buE6pEUQoSwNg9jeUQKKmXSnNAAcFV+XwcAML5L
         V6nkbAMr1gadIBUgqrlfPtwkD9E7mh3lDdiSDImQHalUSD6TOPSHkyWZredNGjc7HUYZ
         b4L93lwh1bWXTEEHuNAkuiKQ/a1IiVmtzYRU6e3xfqQQjVIOuczJF1wWuzxpg7INJbJq
         q1hSH6vA1/g0Nw9z1yjklPtKeh4zTsavvXlm9LwFaaU0ULgAXRliuR9o22MHzemcdu/T
         wyhPjb0YBQVoV4GYtiDv7yMx6z+cxiiEkNnsyvRPUZMxl0R+wtEaUI7FuHfIAQefPPe8
         Vd3g==
X-Gm-Message-State: AOAM531W0IALn87hR6FI6pmdmCdp9ggLCwjWryN2f4FqUo1NDS/aYw33
        iAN8zaA5NPrehmYu1jPdCvzbmThs+4Q=
X-Google-Smtp-Source: ABdhPJzXVQkmUfon04VNUqLrSdFDjnJvuv8muUVAdHLB8jLF9LNcZrLvjy0XC22k6CRcl9d16c2pUw==
X-Received: by 2002:a05:6638:ccb:: with SMTP id e11mr549657jak.206.1643947777569;
        Thu, 03 Feb 2022 20:09:37 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id g14sm451139ilr.12.2022.02.03.20.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 20:09:37 -0800 (PST)
Message-ID: <35a6322b-cd8d-0fa3-69b2-76c984a48c00@gmail.com>
Date:   Thu, 3 Feb 2022 21:09:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v2] net: don't include ndisc.h from ipv6.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jeremy Kerr <jk@codeconstruct.com.au>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        oliver@neukum.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        alex.aring@gmail.com, jukka.rissanen@linux.intel.com,
        matt@codeconstruct.com.au, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20220203231240.2297588-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220203231240.2297588-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 4:12 PM, Jakub Kicinski wrote:
> Nothing in ipv6.h needs ndisc.h, drop it.
> 
> Link: https://lore.kernel.org/r/20220203043457.2222388-1-kuba@kernel.org
> Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: j.vosburgh@gmail.com
> CC: vfalico@gmail.com
> CC: andy@greyhouse.net
> CC: oliver@neukum.org
> CC: yoshfuji@linux-ipv6.org
> CC: dsahern@kernel.org
> CC: alex.aring@gmail.com
> CC: jukka.rissanen@linux.intel.com
> CC: matt@codeconstruct.com.au
> CC: linux-usb@vger.kernel.org
> CC: linux-bluetooth@vger.kernel.org
> CC: linux-wpan@vger.kernel.org
> ---
>  drivers/net/bonding/bond_alb.c | 1 +
>  drivers/net/usb/cdc_mbim.c     | 1 +
>  include/net/ipv6.h             | 1 -
>  include/net/ipv6_frag.h        | 1 +
>  net/6lowpan/core.c             | 1 +
>  net/ieee802154/6lowpan/core.c  | 1 +
>  net/mctp/device.c              | 1 +
>  7 files changed, 6 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


