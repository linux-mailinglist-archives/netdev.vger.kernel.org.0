Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1243551D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFECGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:06:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44680 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFECGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:06:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so9080709pll.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 19:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m+rRMCjHR6VZHbkoJXjJIdErttpII88SWS9j+suw/xE=;
        b=Oy1Lew1b8vz4WxkjYnYSeqbhMRM/MIrMVNb/HiUEgiL7FNZkZHbSVJ6bHMVHxFOop9
         +WSQeyMFHkCTXE0hzyGfiEFhNH9W3co5nqa35yX3aGi1wrmU8lwYzpj9sexOArLcchxG
         fZ+WdtmQB1mFnftRyevGCuWxexwYExe4/1iYQME/8HkZ8FbTlEyIsQDWd8Kos6z+9jcD
         v1+GGa1rovW32EM2VHCvzD8rHgW81n0RROAniE/76gdStcSDxUQnr6t5ZxCisLuWuCyf
         HK7gsOfLjz5d6oyhXh3t1YRSihIUGynMn0WBFeMtpu/oobJUXXMwzpHyG/PAheiyJ2Lc
         FOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+rRMCjHR6VZHbkoJXjJIdErttpII88SWS9j+suw/xE=;
        b=OImbAyumvbm3ZxoclDgiIg3XmN45CXmSlvgAXAqEI2uj/+29EGe5mB0SvLsP4qT6/U
         Gz2OH7UqStcmisIpEDfE8/7I8dYDjCWsxQUpHpCOchG8lk6cOzzwfipkt7ZrXZUfRxEI
         VfhkcZYGmPP+X1gIZaX9JVezIEIdNM4UYFxtWpUNBCNuQ05jg43HqOVcKH+9m10zaKub
         bCzdJndwH4hGZK6KUnaUwVToAgwYPHk6R1lR2jUVKlS+g9bc9iXKZCC8RcCUcrms+aDK
         1vGY1LvstUX4Vtmy1OpDO6NXe5E9Cjbtf9c3cJRpE8FlzoplSMHrLdEyF5KeQZHJlB0d
         yFKQ==
X-Gm-Message-State: APjAAAWDUm9MZgFLh2Uda5E+ZhaxNa6MaPkOdm8lhL59iOGMbajZj2Cn
        IrH44R1AqdjAn5nUQv0QW3U=
X-Google-Smtp-Source: APXvYqw74Cp9wOetU/7TLy8+OjvGSrmMGghsEmSC7yRZRxUytkUzYFG8fhmCUmKZbJ3kW0PCg/GzWQ==
X-Received: by 2002:a17:902:6bc8:: with SMTP id m8mr39216503plt.227.1559700362013;
        Tue, 04 Jun 2019 19:06:02 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x128sm22173486pfd.186.2019.06.04.19.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 19:06:00 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Martin Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
 <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
 <20190605003903.zxxrebpzq2rfzy52@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a5838766-529c-75dd-5793-3abe4e56ed1c@gmail.com>
Date:   Tue, 4 Jun 2019 20:05:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190605003903.zxxrebpzq2rfzy52@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 6:39 PM, Martin Lau wrote:
> IMO, ip6_create_rt_rcu(), which returns untracked rt, was a mistake
> and removing it has been overdue.  Tracking down the unregister dev
> bug is not easy.

I must be missing something because I don't have the foggiest idea why
you are barking up this tree.

If code calls a function that returns a dst_entry with a refcount taken,
that code is responsible for releasing it. Using a pcpu cached dst
versus a new one in no way tells you who took the dst and bumped the
refcnt on the netdev. Either way the dst refcount is bumped. Tracking
netdev refcnt is the only way to methodically figure it out.

What am I overlooking here?
