Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCE143B3FA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhJZO27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhJZO26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:28:58 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3746EC061745;
        Tue, 26 Oct 2021 07:26:35 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r194so392012iod.7;
        Tue, 26 Oct 2021 07:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=L5D0+j7FaSezg76oVeVVLGGUXUUlkCip1HOizeqS3F0=;
        b=BYEtfYnADJR1nva03YwbtWDmJqc0JekTqrBc/UkvtxMbR20tM3+tjsd40tPOCuQ0FY
         mu5qiIcDEjGZwnM2+m+zFZ6iW8t2OYkc6xvvzj5BGz5sZoI9XLsvY5vCHrMGEJ8E9Ptw
         4eplondyATTctuNYB8NWANcRWHH3X5b0+0mRmUoKHrnmmZ7NXZ8hCag8++ViQxdZ1Dyd
         ebk/vOqZYAmaXGj4DmMmWsHrAN0L7gKeQkAW7PxHQt/fFABfRJrPpCA/HVuMIGNnbHcY
         XyQ59m0y31feprCF+/0BwMHpZJIrM1/97wECpeLFXWF7ZbVcoAZcjg1QrGnpcEHIwOe6
         pA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=L5D0+j7FaSezg76oVeVVLGGUXUUlkCip1HOizeqS3F0=;
        b=CrZUSQ/BCOrtXmcsjYlkZPXzyBDb0rfI4d4dwbNqPQ0q0MUuSGIhQk89r0vFGvDtX0
         UufyEm1tB5fkJA38wnPqQBQe7r3MPvhsMrvyuJLkC71hrDzccXSpWlOqPTSZKk77Lc7Y
         JFGxrW0GFJZ3R1K+O8JSNAi3L+uIviszbKapSLLzzFAjggl15zThNonk8NlZ/pJzcYsl
         sTF7g2UQbBcaEme9uc53T4TDsWk+aq2NJBr/JpFNJ6vXneZ5tWP+KPWjkF8CUgAs2zdr
         ERHcoE2AGCZ/MoM2SeYNr9WAgie81XKrDPUyVCuAI/fftRky/0nUpWEbe5Uo3+08qGKK
         BOBw==
X-Gm-Message-State: AOAM532j3G/26+7aJEf5Bidfz09gNsOyW82pSYIuCEFV80qbLqpW/wNL
        1YTr8WbwjHd7B5xzpuIp3aM=
X-Google-Smtp-Source: ABdhPJzxea8hMZMheKY2Qt87166kL9BeX6gTsSp6/EmMzyCyZ2m/IhY3w2E/abL5pJIiDFxFPGzQjQ==
X-Received: by 2002:a5d:954b:: with SMTP id a11mr5045902ios.99.1635258394676;
        Tue, 26 Oct 2021 07:26:34 -0700 (PDT)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id m11sm1352031ilh.0.2021.10.26.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:26:34 -0700 (PDT)
Date:   Tue, 26 Oct 2021 07:26:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <61781010b20b3_108a220859@john-XPS-13-9370.notmuch>
In-Reply-To: <20211012052019.184398-1-liujian56@huawei.com>
References: <20211012052019.184398-1-liujian56@huawei.com>
Subject: RE: [PATHC bpf v2] tcp_bpf: Fix one concurrency problem in the
 tcp_bpf_send_verdict function
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> With two Msgs, msgA and msgB and a user doing nonblocking sendmsg calls (or
> multiple cores) on a single socket 'sk' we could get the following flow.
> 
>  msgA, sk                               msgB, sk
>  -----------                            ---------------
>  tcp_bpf_sendmsg()
>  lock(sk)
>  psock = sk->psock
>                                         tcp_bpf_sendmsg()
>                                         lock(sk) ... blocking
> tcp_bpf_send_verdict
> if (psock->eval == NONE)
>    psock->eval = sk_psock_msg_verdict
>  ..
>  < handle SK_REDIRECT case >
>    release_sock(sk)                     < lock dropped so grab here >
>    ret = tcp_bpf_sendmsg_redir
>                                         psock = sk->psock
>                                         tcp_bpf_send_verdict
>  lock_sock(sk) ... blocking on B
>                                         if (psock->eval == NONE) <- boom.
>                                          psock->eval will have msgA state
> 
> The problem here is we dropped the lock on msgA and grabbed it with msgB.
> Now we have old state in psock and importantly psock->eval has not been
> cleared. So msgB will run whatever action was done on A and the verdict
> program may never see it.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Yep thanks for digging into this. Nice catch. And commit looks good now.

Acked-by: John Fastabend <john.fastabend@gmail.com>
