Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B6F41FBDF
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhJBMyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 08:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhJBMym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 08:54:42 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844F5C0613EC;
        Sat,  2 Oct 2021 05:52:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b20so50188167lfv.3;
        Sat, 02 Oct 2021 05:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=73l45VrsSMydq7i5W9f5vyJ/5wGhCAznnH6g8ZTpcK8=;
        b=axca/9yT9QokobdzZGXyB3WifC708N5PFiq+4VXM/HAVzZdhrjfS/laZpgecjU/HLR
         2mhUZh0rBJPd6RdrZvhXwV9AO5xEI6+RtSFM8msyGw+L7Rpu0VREeiwIkPUzxQjt7fAP
         NKqXPJoeWBmyyUkmZSnegH3Pimf2hUnx/3CULNwMEw20Asz+sf3TRxn9dDckKGlOMkrN
         l48gLJUtrrMzX2HtPCNXUJVUdqDT5OPdyPdBQS5mc2Cp5mm46jxBtuTWTTclycOGSoo5
         mAu55SJ81zXninBFziWtnWE4026DEd29OAeWkOgLP3P1R3hsGNSB+Aoiiv/SvqEKVfXf
         y9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=73l45VrsSMydq7i5W9f5vyJ/5wGhCAznnH6g8ZTpcK8=;
        b=umd72jkGHfxXtyRTF+S920vzUG4jlIfBuSxENAmoioheuTCOiWFsqb1XSf2XcW5NNb
         PoS9S8Ta6cq1ZlYIx+AbTPy1V4fILsa+AO1c6fCKCPdavoDlzKtpj1s/Ak3yysJ1UzG9
         QMGfHkVYxu2mKBehzTW4O96JnUhgyhmdL5Z4+DdjWln44sVPzeKRUkhPEXYiPIzbSoib
         uCuM/VAAwqknVmSAaqtYV6zRFXvRBtqGN/oZFaos8lr+ei0OsDkVYE8svX82nCxCJPI7
         kU25rsYuL+7Rcc3mjsyfeJ5XL8b4p6X33Zh9vIe9tGA7SJZUTTSma2wt4ujnnj0Bp81C
         5Zyw==
X-Gm-Message-State: AOAM532Zy6FU0ZsBBiZcg/+BcfC0/cJI8EvkHrkcVMjH5MJTjvNud5hr
        tijVJf3WiK6ZwF6wb3LGu8s=
X-Google-Smtp-Source: ABdhPJz8J+cj/0eMvqhbDlSeH/YQGoRx8gu4jxv4uMCSa5e/vmwSfl5+hoQkEMwvffe/Gnvxk0NAXA==
X-Received: by 2002:ac2:514e:: with SMTP id q14mr3801162lfd.154.1633179174773;
        Sat, 02 Oct 2021 05:52:54 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id x24sm1015279lji.0.2021.10.02.05.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 05:52:54 -0700 (PDT)
Message-ID: <cc51edb5-92f2-bf33-f101-2a5c9f75ca58@gmail.com>
Date:   Sat, 2 Oct 2021 15:52:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: Any idea to fix the recursive call in tls_setsockopt?
Content-Language: en-US
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <CAD-N9QW=ex-+gkwnJNw0eQjFCPcQ-awN_NH5OERjQfo-FC=z4A@mail.gmail.com>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAD-N9QW=ex-+gkwnJNw0eQjFCPcQ-awN_NH5OERjQfo-FC=z4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/21 11:38, Dongliang Mu wrote:

[ +CC netdev, LKML ]

> BUG: stack guard page was hit at ffffc90000b87ff8 (stack is
> ffffc90000b88000..ffffc90000b8bfff)
> kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP
> RIP: 0010:tls_setsockopt+0xe/0x650 net/tls/tls_main.c:617
> Call Trace:
>   tls_setsockopt+0x6a/0x650 net/tls/tls_main.c:621
> ......
>   tls_setsockopt+0x6a/0x650 net/tls/tls_main.c:621
>   tls_setsockopt+0x6a/0x650 net/tls/tls_main.c:621
>   __sys_setsockopt+0x1b0/0x360 net/socket.c:2176
>   __do_sys_setsockopt net/socket.c:2187 [inline]
>   __se_sys_setsockopt net/socket.c:2184 [inline]
>   __x64_sys_setsockopt+0x22/0x30 net/socket.c:2184
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> My local syzkaller instance finds this bug, however, I am not sure how
> to fix it. So I post the bug report here to seek help. The
> implementation of tls_setsockopt is as follows:
> 
> static int tls_setsockopt(struct sock *sk, int level, int optname,
>                            sockptr_t optval, unsigned int optlen)
> {
>          struct tls_context *ctx = tls_get_ctx(sk);
> 
>          if (level != SOL_TLS)
>                  return ctx->sk_proto->setsockopt(sk, level, optname, optval,
>                                                   optlen);
> 
>          return do_tls_setsockopt(sk, optname, optval, optlen);
> }
> 
> Since I am not familiar with this part code, the fix in my mind is to
> do a sanity check on "ctx->sk_proto->setsockopt" and make sure it is
> not tls_setsockopt.
> 
> Any comment here?
> 
> --
> My best regards to you.
> 
>       No System Is Safe!
>       Dongliang Mu
> 


With regards,
Pavel Skripkin
