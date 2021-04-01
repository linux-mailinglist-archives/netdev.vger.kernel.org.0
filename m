Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A23510A3
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 10:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhDAIKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 04:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhDAIKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 04:10:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29437C061788
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 01:10:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 12so1492857lfq.13
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 01:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=359/3Z1CYKxxl5toasV/Z3a4f/q0gbTdIT4dOTC6TX4=;
        b=hmy31Zhh31GXyDnFegs87CjLtlaApmiQ/cw90wjma2uhuGFInGbEfs1W1jA+9p5qIG
         dblYVTYk1fLeQEWJvUUIwfgKqNSC60dzwaCyDus2zXZYFc6RptCP1CDCDw/88N0MpZ/m
         iIG3sQgvnpjzpmnfnZmK83lJ5CN4oYgfj2H+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=359/3Z1CYKxxl5toasV/Z3a4f/q0gbTdIT4dOTC6TX4=;
        b=ReJ8zB4Z232AGXqYHzslpJFQXeXmLI45TG2OPUcO6kqkidGwXxh5+b/2rkmsOrUbPy
         hFZxNyvikYEzWCLfst+aL4tH8dI+ffK0aywxzBjmSot7cwwvObJIWIdzDoOiexZn7h7Y
         3RdT24tXcFn9nuZD/h6636F/VOa4APPmGF+9cpU9j7lKyJayyzvxCldscckFqTkhq9qQ
         DDOfHpaZ00HP9hSRlm67cOLm5BGB/J/forPbgRoIo97ON4t693tUk2RqczVZenZPRu17
         /GoO9O36PwMeKCNkeOlDiMre2uGfuD1pGiey8MfTUfF794ufB7zCGvdXgrotKBoPtBWz
         ooyQ==
X-Gm-Message-State: AOAM531N9OPy4/ygSOHxdrQCNxWstdkqps9f7kgnj3U7un3IzfE1tZEj
        jChnjqaICQTxJNHxuYUjmfGA5A==
X-Google-Smtp-Source: ABdhPJzqPkCkdYPRatKHnZ5p6Tzfh31w0pWZqV6gEe7smyLxtkbY3Cd2vS+HT00hSPyWRUDVKwqAhA==
X-Received: by 2002:ac2:50d0:: with SMTP id h16mr4790179lfm.369.1617264623102;
        Thu, 01 Apr 2021 01:10:23 -0700 (PDT)
Received: from cloudflare.com (83.5.248.223.ipv4.supernova.orange.pl. [83.5.248.223])
        by smtp.gmail.com with ESMTPSA id d21sm535710ljo.55.2021.04.01.01.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 01:10:22 -0700 (PDT)
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-4-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v8 03/16] net: introduce skb_send_sock() for
 sock_map
In-reply-to: <20210331023237.41094-4-xiyou.wangcong@gmail.com>
Date:   Thu, 01 Apr 2021 10:10:20 +0200
Message-ID: <87tuoq2zo3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 04:32 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> We only have skb_send_sock_locked() which requires callers
> to use lock_sock(). Introduce a variant skb_send_sock()
> which locks on its own, callers do not need to lock it
> any more. This will save us from adding a ->sendmsg_locked
> for each protocol.
>
> To reuse the code, pass function pointers to __skb_send_sock()
> and build skb_send_sock() and skb_send_sock_locked() on top.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
