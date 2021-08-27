Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7CD3F9CAD
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhH0Qmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhH0Qmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:42:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCA3C061757;
        Fri, 27 Aug 2021 09:41:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e15so4271786plh.8;
        Fri, 27 Aug 2021 09:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3V2CZy6dmdkD9GfcdkbWhhKFYcBdzsCBJHlbGNHPDlM=;
        b=iDLnafUOq6WqYT+CV5zlg1K1jj8RSH2+gL+TL710pxFogi71WDp11udZQMWz4G3Cje
         vZHbGQaHIzbIE4hmLZg9PuXRq9gvFMiZ6jA4ywMVdC4BHI1Thda/mGewhWsFd8TviI6V
         6/tflR2Tq2yu8Ky8mi+M7YOFy2NfW2qmlp72ygpg9s7mpgkT/L3IJtlCxsnUx6iYDH3L
         TMYGvQ2IbMKFYWKUCYZidE4G5GtJ2cjLJHDqSQ2ZuEQsqa8rjmNo8WCjQqGg+mEVOXmC
         SQ3tjoR1OAKFPDBUEBzA4YHVJDEdztAalrSnyphgY4y3dDTm7QPA+bpTZoXyoPJs1qFl
         dRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3V2CZy6dmdkD9GfcdkbWhhKFYcBdzsCBJHlbGNHPDlM=;
        b=tUhOCLNuK88Fi2yjllA8Nm69ssLgfVIQA7ic85BVa9RjNqU1P79QGa4cctpnc82XIV
         Zr1AbHz5fWCVoBXP42hXQS6anLczma6XWiY4iztz5Wgvl3Plfq/wFHEOAgau+lH2y+1J
         mB5YxcPHdAXP6nMh8Ccd+S5z26gIszWX8ChEFcmMrYK9Fl4XJBqIaqtfCiG5zr0AEi4M
         84LcXwuLVtpXd2l6kfA/AmEC0hfZLuBsIQHaO9uEJNHOFZpfdkrPTbLZHtmb0ScDrjpE
         w+8LExMKFlrcykIDfGz78PNNQz/s4SLeq+rN36TmKqTQgANLHlVckrKJbHwD4obVWn97
         E43A==
X-Gm-Message-State: AOAM530KvwIm089UIcXoJ2T8YUsgl2R542F/BEfcLRVP4yoOTLnYqsO0
        L0wjPL/CMM27Fe0gLtUXPsM=
X-Google-Smtp-Source: ABdhPJwASjddcM9h65Sw+qmPBLmmgOUuenDeBxxNvZDAFoEs6Kzmn2wHc4GYH3puhZGsXvYeSqAiKw==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr24495129pjo.194.1630082515636;
        Fri, 27 Aug 2021 09:41:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id cq8sm6511133pjb.31.2021.08.27.09.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 09:41:55 -0700 (PDT)
Subject: Re: [PATCH net-next v6] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210827150412.9267-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <88523c38-f0b4-8a63-6ca6-68a3122bef79@gmail.com>
Date:   Fri, 27 Aug 2021 09:41:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827150412.9267-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 8:04 AM, Rocco Yue wrote:
> The kernel provides a "/proc/sys/net/ipv6/conf/<iface>/mtu"
> file, which can temporarily record the mtu value of the last
> received RA message when the RA mtu value is lower than the
> interface mtu, but this proc has following limitations:
> 
> (1) when the interface mtu (/sys/class/net/<iface>/mtu) is
> updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will
> be updated to the value of interface mtu;
> (2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
> ipv6 connection, and not affect ipv4.
> 
> Therefore, when the mtu option is carried in the RA message,
> there will be a problem that the user sometimes cannot obtain
> RA mtu value correctly by reading mtu6.
> 
> After this patch set, if a RA message carries the mtu option,
> you can send a netlink msg which nlmsg_type is RTM_GETLINK,
> and then by parsing the attribute of IFLA_INET6_RA_MTU to
> get the mtu value carried in the RA message received on the
> inet6 device. In addition, you can also get a link notification
> when ra_mtu is updated so it doesn't have to poll.
> 
> In this way, if the MTU values that the device receives from
> the network in the PCO IPv4 and the RA IPv6 procedures are
> different, the user can obtain the correct ipv6 ra_mtu value
> and compare the value of ra_mtu and ipv4 mtu, then the device
> can use the lower MTU value for both IPv4 and IPv6.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  include/net/if_inet6.h             |  2 ++
>  include/uapi/linux/if_link.h       |  1 +
>  net/ipv6/addrconf.c                | 10 ++++++++++
>  net/ipv6/ndisc.c                   | 17 +++++++++++------
>  tools/include/uapi/linux/if_link.h |  1 +
>  5 files changed, 25 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


