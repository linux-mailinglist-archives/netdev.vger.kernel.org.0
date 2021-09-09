Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166D405F98
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 00:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhIIWbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 18:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIIWbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 18:31:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DB7C061574;
        Thu,  9 Sep 2021 15:29:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23so71286pji.0;
        Thu, 09 Sep 2021 15:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bnhX5uj2rAQbqykqjIAuORREFzEvDfH4zbDhGukqKhI=;
        b=fOJ4FfY7JfvYVDAPeWdDQhYHAVy2gS076rWTqLu4ZPRLZPN+9/C03g/vsNR0YLvk4J
         Id23kkXi6/3+UdDb3YfWQpjlLuDbGEXjfO7jGi9WeWieJ5aIHWDb2VMCsfamy8MYLeTB
         0qdfhVo7tHgTDi4uK0o+ilKYfH2CbO+XdaPbAgyNxmQZS3GC6a9g+QI9zmrJqVCc8DLu
         5O6khzd6r93RcbsFgOP53i+kFzpswihgO5avBq0b9LqffJf9mAjkuevIfKKO/fxMvawr
         AWnMhFjitkjIa5kiSAoPQewEnsMpahKkHSS9z/1+szwtzIIe3RJR8nW2EhP+WgMWuPCp
         MAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bnhX5uj2rAQbqykqjIAuORREFzEvDfH4zbDhGukqKhI=;
        b=YjhBNFvTXVxhIuIYWorKOOaTdoYTC9mNXbIsVMKQzrnAru6h8luL8CywBXMsOWnPiu
         Y9PlW9TZ+ubLhjpzt8VHcI4i5diSMKVQgEnTOYWIh7A8ctzkFDFYQ/F+27O1n2M+LZYF
         WCB+kvPeH6qoOVxy2skhjamdx5Di6gxEe5w5wrh7ByVQcQNlG8Jp9Ptc9eDcDu1UeEPz
         w9dnH0GnCQeWy+QaVGs12RVmch7iq8Jw9A5C478JFeB8KVfTu9I/MxpeTRj/e+8tFNsc
         zEDqHDvChUSInvWO4apZmwzlzkk3a2sIb7mk5Pj4knex9ShYumnK/dZKAH4265nLWiJS
         Xqqg==
X-Gm-Message-State: AOAM532dC3LN7ECB7SPWErgjmS15Qk08DDEjzdP7aksK6AsFJn1y3f/V
        0Wdpm9r/+8+7t9wHTrU+/XY=
X-Google-Smtp-Source: ABdhPJyT+PH6brx2Qu2YHDrGWG+OBmAWiR2Slu4WCfACX4II1Uc5BHEYehpqb8TRfZqxHqEFcdMUDQ==
X-Received: by 2002:a17:90a:a88b:: with SMTP id h11mr5992014pjq.44.1631226596550;
        Thu, 09 Sep 2021 15:29:56 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id d13sm3146968pfn.114.2021.09.09.15.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 15:29:56 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 9 Sep 2021 12:29:54 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        m@lambda.lt, alexei.starovoitov@gmail.com, andrii@kernel.org,
        sdf@google.com
Subject: Re: [PATCH bpf v2 1/3] bpf, cgroups: Fix cgroup v2 fallback on v1/v2
 mixed mode
Message-ID: <YTqK4oAG3CTxQ7Lq@slm.duckdns.org>
References: <f36377d0c40cce0cdeaff50031c268bc640d94f0.1631219956.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f36377d0c40cce0cdeaff50031c268bc640d94f0.1631219956.git.daniel@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Sep 09, 2021 at 10:43:40PM +0200, Daniel Borkmann wrote:
...
> Generally, this mutual exclusiveness does not hold anymore in today's user
> environments and makes cgroup v2 usage from BPF side fragile and unreliable.
> This fix adds proper struct cgroup pointer for the cgroup v2 case to struct
> sock_cgroup_data in order to address these issues; this implicitly also fixes
> the tradeoffs being made back then with regards to races and refcount leaks
> as stated in bd1060a1d671, and removes the fallback, so that cgroup v2 BPF
> programs always operate as expected.
> 
>   [0] https://github.com/nestybox/sysbox/
>   [1] https://kind.sigs.k8s.io/
> 
> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Martynas Pumputis <m@lambda.lt>
> Cc: Stanislav Fomichev <sdf@google.com>

While this does increase cgroup's footprint inside sock, I think it's worth
considering the following points:

1. It's clear now that we won't need more cgroup related socket fields for
   network integration. cgroup2 membership tagging has proven flexible
   enough especially in combination with bpf.

2. Users have been transitioning from cgroup1 to cgroup2, some gradually,
   which is why this multiplexing is becoming an issue. In time, as
   transtions progress further, we should be able to disable cgroup1 network
   controllers for many use cases.

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
