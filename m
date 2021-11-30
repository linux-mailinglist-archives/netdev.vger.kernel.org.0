Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4847462BF2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 06:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhK3FQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 00:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbhK3FQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 00:16:46 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809FDC061574;
        Mon, 29 Nov 2021 21:13:27 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id p4so25510630qkm.7;
        Mon, 29 Nov 2021 21:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xT3OJBmBSLdDKQA0pF/Eep+RHgJNEz3TGcshjvO7yNM=;
        b=MVeA5cD2hTTZmfLu3F2ocne4+g4w6KTcjFFyyOBO4tV+EFfu7KyGNKSIwIElhefpTH
         NW7pWcA+P/9L9mKTlopbnOjTbZmwrGQ+Jd+e615NJljYeHwjYRXFj9qhmDaYdSq4me84
         n4QOwhih703FmTwCXhQH8BnfNm7B3m+eCmh6d5ZLWe8pmlO2AteNIRm1I737FqlT54Dc
         RliTSjySiOB9qx+ZVIsdstbNrLe0F8NQtlrb8T27HJC+xtETVqoacAV3B0aES3n5vVXw
         342hH5l8qWX9daltZgvhKYAr96bKYTEHX98MS5AiGaoKabB+pOo/8aRt1KSqnE0WEIbN
         sNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xT3OJBmBSLdDKQA0pF/Eep+RHgJNEz3TGcshjvO7yNM=;
        b=jNndvgtflS3xJUT6i44phW0J1jtnwBVfefMxlQBY0TeyVULKL++vmKYEOiLKOochaf
         58OTfVZILcfyLUbpkCX1QcBwihoOX1czi09y1Xr0RU3ATbwoeAjEMLiA/AGaWRv2CQEz
         OA7k3FXxPKAAO3sOQzy4x3z6hD/UPvb2LzHOJUzYX4ibxtIY+5ROJIztvMD8Z7/DACRH
         /9athpPcVoYznN/NSqnI8kYN45JK/VNBiYcF1Qe4rsS48bTVr6tDfN1csWamS4HV2d3L
         HK/siSw6hxJkC0xYZ+GWBQ23tZyeigbiTKLFx+ERyWrr642gFfZMfo4Ejr8Ng+jgMZ61
         M1uQ==
X-Gm-Message-State: AOAM530tVY8fOhVKnUWqcGp3/YkQz9jyviarkH+eaAIyaruitArrJJ9l
        uFbr7KjxUQh87enIdlc9QQ==
X-Google-Smtp-Source: ABdhPJxwR6z4vFjYRZTUewtGwlCIjV891UP5pTH35Ox/xk+CLMCyyFjIQbwieGXaVrlS7N8cwWX9IQ==
X-Received: by 2002:a05:620a:2955:: with SMTP id n21mr34627497qkp.581.1638249206710;
        Mon, 29 Nov 2021 21:13:26 -0800 (PST)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id e13sm10104176qte.56.2021.11.29.21.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 21:13:26 -0800 (PST)
Date:   Mon, 29 Nov 2021 21:13:22 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] selftests/fib_tests: ping from dummy0 in
 fib_rp_filter_test()
Message-ID: <20211130051322.GA4450@bytedance>
References: <20211129225230.3668-1-yepeilin.cs@gmail.com>
 <20211130004905.4146-1-yepeilin.cs@gmail.com>
 <c19ebcb5-2e25-ce9c-af83-e934cc3d0996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c19ebcb5-2e25-ce9c-af83-e934cc3d0996@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Mon, Nov 29, 2021 at 06:16:48PM -0700, David Ahern wrote:
> On 11/29/21 5:49 PM, Peilin Ye wrote:
> > -	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
> > +	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 198.51.100.1"
> >  	log_test $? 0 "rp_filter passes local packets"
> 
> confused by the point of this test if you are going to change dummy1 to
> dummy0. dummy0 has 198.51.100.1 assigned to it, so the ping should
> always work.

Ah...  Thanks for pointing this out, I'll try to figure out a different
way to test it in v3.

Thanks,
Peilin Ye

