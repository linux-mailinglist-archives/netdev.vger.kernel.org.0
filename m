Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FEF10A3D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfEAPpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:45:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36151 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfEAPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:45:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id w20so7731570plq.3
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 08:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jG2VRNrmEBltjCSyycsDyy6vg16aOk5jR2yf872/wHo=;
        b=rJdwnnOwbVebarF8taOg2QEpnkLKx2hgcnTOZxqGat8s/zUrKeZoUdjWYCAHVkFzzH
         eWEwxST40o79pv0b/mQrPVOeMvDfIFzgsiQ2S5qW8WvScshMBEKjY29DLiFHGB54H/Cj
         n+3j7NaiwuX7WKG5WlORUQ88xx9q8y2kMzeigtd4HDIrQWRcAdAvMKxafBIXhvljtVin
         cIn3Zw3gja/tKJcqGIgunt+ogUPISytEvRujXqrbtdZQD8/n9hSIsch1cKFETUHQ8O64
         dnXT0E/g2TJZrL8iADAuReoU1NSJpMBWljGQPismpWlRVXVutyOQDWBvKe+mLDPk5I6V
         xNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jG2VRNrmEBltjCSyycsDyy6vg16aOk5jR2yf872/wHo=;
        b=ViU+SR6oOTDSWiEf5DIaPdM7Fgq49lpC31hGht6aX95xVmMJHsm8wglhonMUDwZWtl
         bxQMmv2x1oJ3k7pG367jvfSX0NvRkWKlzJgIw25jn6cvqLcrYmjjSod76DAkaoSoo8KC
         b7RdkBSxh2ji+oPyxB4ABT1PX9xnKnKTcGUNb1+Ws/c9nYMHfEx0EoMrNjblfeFHxQVC
         tOsKFgoGNkQ3Jo08dz4khaQlbIngAvqZnZGy1DfLOKH26d577STSqEC1e9ERsRI+OwoV
         1Zb+jSomVrO9ATkqiWho4tMwGjhO321AbG7Js3favOoSW7krfMUcQlTniwgEpWIoURJE
         8N1Q==
X-Gm-Message-State: APjAAAV9g0PM5AmEHxiLGHEyyrceH/9aH3fU6iIe7+cYtjUJeetKSlSb
        oa5VwL2LdcsPWGOER3mElbYsRond
X-Google-Smtp-Source: APXvYqwQuE6Pi/1qRY7HU569VxGd3d429acTSaALSgKm29HCd6a3IikKBv6Ey7cE5NKBPt2JnijmaQ==
X-Received: by 2002:a17:902:2907:: with SMTP id g7mr78189215plb.238.1556725502125;
        Wed, 01 May 2019 08:45:02 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:950d:299e:8124:b280? ([2601:282:800:fd80:950d:299e:8124:b280])
        by smtp.googlemail.com with ESMTPSA id v19sm77749662pfa.138.2019.05.01.08.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 08:45:01 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: A few fixes on dereferencing rt->from
To:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Jonathan Lemon <bsd@fb.com>,
        kernel-team@fb.com, Wei Wang <weiwan@google.com>
References: <20190430174512.3898413-1-kafai@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <10752519-01db-e6f8-f10d-870f5cad983f@gmail.com>
Date:   Wed, 1 May 2019 09:44:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190430174512.3898413-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 11:45 AM, Martin KaFai Lau wrote:
> It is a followup after the fix in
> commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")
> 
> rt6_do_redirect():
> 1. NULL checking is needed on rt->from because a parallel
>    fib6_info delete could happen that sets rt->from to NULL.
>    (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).
> 
> 2. fib6_info_hold() is not enough.  Same reason as (1).
>    Meaning, holding dst->__refcnt cannot ensure
>    rt->from is not NULL or rt->from->fib6_ref is not 0.
> 
>    Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
>    is already doing, this patch chooses to extend the rcu section
>    to keep "from" dereference-able after checking for NULL.
> 
> inet6_rtm_getroute():
> 1. NULL checking is also needed on rt->from for a similar reason.
>    Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.
> 
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/ipv6/route.c | 38 ++++++++++++++++++--------------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, Martin.

