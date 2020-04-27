Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D501BAFF1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgD0VGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgD0VGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:06:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB1CC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:06:37 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 20so19616243qkl.10
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 14:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=926jNFTQBTE7hPU/ryko5Ue6ZEuE/W6P6L9OkvRtdTM=;
        b=NKf7pQNWNKaKYD8P2cXiQ25i9E23wM21ddZcZDW0w7Sza/xBnpK1NtUKOGB/v/kjtv
         AEqjADaVSEY8WhkGBEKIxLZDtMTFHhlY2gYFsPNeX/tgwkcT1qFKiAYfkyyNZIR+ugBy
         b3nlAtedbZpu0vmwL+7YCtZYq3Si5LmqpzfLEWInuSVkwwTUKCC0+VvYDRnyYPjQCMIl
         aHjkFk37Vn8USBVT7FLKQKrRFCZXA+n3sxtpHgmUHwAJsS6eTAySGgT/YyaSWJRKM2BI
         nChtDp7IglIjWRv2snGHTdSXksxZ6gCfQkbEzjfyf0W3pH3YfBvJTKX0Uiq++Nl4iCTz
         nY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=926jNFTQBTE7hPU/ryko5Ue6ZEuE/W6P6L9OkvRtdTM=;
        b=rT6myOQ+Cq6YX9ao0nil+eDGcMB91pa9SUSyWj75riIXY8y/qawDh6qJXICWHL4s4U
         mIMzNyl4yiD83sr5vpMpf63JCcDaTkXW1735TS+87QwSJI9Igmn8QRoCPq6xeFU7ybiC
         800n3umlSjCQYyKUEN9Ky3kK2vnTHktLUHIXKyS9bqzKt9DFHbEV9an73J6mtnQwkvXP
         KXoc5ywNtCai/KYxNp/OddS9VUL3SmrAmr3vnf49/BTAfS8KdnM9dZjaC5ofAcVuv0r5
         agIOhtL9MRvbSc1JGdDP00DMBQPW5r6FICnqztOB/mbQrkK3T1gP5dvBlVJ8gvGlkM27
         TzRA==
X-Gm-Message-State: AGi0PualdfQMrDURB7WvQMxidKMFfPjcBzaFwuyYgMO/q9z8IGnYLLR2
        UWYux7s8qYXFcwWhzqhvsYw=
X-Google-Smtp-Source: APiQypJH4b4WxLBByBG73dMvAFRK7ft5K9P9CcxZ3q7XUvXh2l52c6T3Nr35I9myfCJCN7zqEaTurg==
X-Received: by 2002:a37:66d0:: with SMTP id a199mr20886933qkc.245.1588021596481;
        Mon, 27 Apr 2020 14:06:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id z18sm11523985qti.47.2020.04.27.14.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 14:06:35 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] net: ipv4: add sysctl for nexthop api
 compatibility mode
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
 <1588021007-16914-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <98b2beca-342d-2394-5cbe-488fd05bf8cf@gmail.com>
Date:   Mon, 27 Apr 2020 15:06:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588021007-16914-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 2:56 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Current route nexthop API maintains user space compatibility
> with old route API by default. Dumps and netlink notifications
> support both new and old API format. In systems which have
> moved to the new API, this compatibility mode cancels some
> of the performance benefits provided by the new nexthop API.
> 
> This patch adds new sysctl nexthop_compat_mode which is on
> by default but provides the ability to turn off compatibility
> mode allowing systems to run entirely with the new routing
> API. Old route API behaviour and support is not modified by this
> sysctl.
> 
> Uses a single sysctl to cover both ipv4 and ipv6 following
> other sysctls. Covers dumps and delete notifications as
> suggested by David Ahern.
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  Documentation/networking/ip-sysctl.txt | 12 ++++++++++++
>  include/net/netns/ipv4.h               |  2 ++
>  net/ipv4/af_inet.c                     |  1 +
>  net/ipv4/fib_semantics.c               |  3 +++
>  net/ipv4/nexthop.c                     |  5 +++--
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  net/ipv6/route.c                       |  3 ++-
>  7 files changed, 32 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


