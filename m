Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62AF470610
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbhLJQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhLJQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:47:32 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E43C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:43:57 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w1so8925133ilh.9
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Zg/QKVZKkl+UWbbCFkLJsd24kqstcfV/D3VkUVfDZFM=;
        b=WDkrloC5bim8HeySPsC+4hCLVnIMAPDZyuHhF9KxENDLZzlp4S9YOg0FHF2ccUWx4U
         GGBYb8h/wfaZZA79yfeVwNw+B/RXATIW80t0UxXPkB7yLENaqbSZ2a/Hik8Jb06TIufe
         1vWHnliY+gzP4vdvCCi1EJviak/yfHtEPnx/NTnxiq8kfBoaPwH5Scqv3gJ9U8+CE/DZ
         bjFkEk1skxAi5x0eB7NmqgZbep3/m7zOLLCjcghDhSK/89fp53MQOfl7M0brRWiYeBpO
         1kIrjsLjuQ5lYbMY5QjbUQM0A1aPO5rnr0rDRATRHMnOPf1YS5E2s9G0nWCwa3az4OGb
         7Nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Zg/QKVZKkl+UWbbCFkLJsd24kqstcfV/D3VkUVfDZFM=;
        b=2BxlqCoFsLb16etUOJnfcgNhg075huIlAQktl5VcT9EQDt9GSS7V46DnoLCNnEGNAD
         sqHJ2ZENriKADeV9vvWB//SV+HqfGflDkp1mNjvLUAdzhr9PoaNs1LrYymCTsJZ1gEO+
         k9NzDUL/BkHwZ4WWkuouy2vRXH3e5DIKhXzEFeYP2sZNL6zYME43+EwKnmuRUM0AbveQ
         MXytVv7anKgHKsApotpYj0l0jOps/Pe8SIa/2kKS16uGIX2rXjo+fiPKk4gsflDpz47x
         BcnTqljsuxYh1cfB+adY8aIUZLNl33xkEUoZSZ64JEf6O9KKCILLgpxv5iXo+GVAFude
         vzvA==
X-Gm-Message-State: AOAM530xXrEB3UyZwZ5AaTNZ/XZbALt5q5CDNUhc28m0O/mvADt9nYCx
        RsN4/0yVfwan6vlFjxk9s1Y=
X-Google-Smtp-Source: ABdhPJxZSle7G3Fp7Gzm1y10DNRRZzouFAKFhcwHpFg07Fw/bue9Fw099S3cPxU6z1jYdfeOgqYUAA==
X-Received: by 2002:a05:6e02:12e5:: with SMTP id l5mr17125050iln.316.1639154636892;
        Fri, 10 Dec 2021 08:43:56 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x18sm2473139iow.53.2021.12.10.08.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:43:56 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:43:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Message-ID: <61b383c6373ca_1f50e20816@john.notmuch>
In-Reply-To: <20211208145459.9590-3-xiangxia.m.yue@gmail.com>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com>
Subject: RE: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xiangxia.m.yue@ wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Try to resolve the issues as below:
> * We look up and then check tc_skip_classify flag in net
>   sched layer, even though skb don't want to be classified.
>   That case may consume a lot of cpu cycles. This patch
>   is useful when there are a lot of filters with different
>   prio. There is ~5 prio in in production, ~1% improvement.
> 
>   Rules as below:
>   $ for id in $(seq 1 5); do
>   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>   $ done
> 
> * bpf_redirect may be invoked in egress path. If we don't
>   check the flags and then return immediately, the packets
>   will loopback.

This would be the naive case right? Meaning the BPF program is
doing a redirect without any logic or is buggy?

Can you map out how this happens for me, I'm not fully sure I
understand the exact concern. Is it possible for BPF programs
that used to see packets no longer see the packet as expected?

Is this the path you are talking about?

 rx ethx  ->
   execute BPF program on ethx with bpf_redirect(ifb0) ->
     __skb_dequeue @ifb tc_skip_classify = 1 ->
       dev_queue_xmit() -> 
          sch_handle_egress() ->
            execute BPF program again

I can't see why you want to skip that second tc BPF program,
or for that matter any tc filter there. In general how do you
know that is the correct/expected behavior? Before the above
change it would have been called, what if its doing useful
work.

Also its not clear how your ifb setup is built or used. That
might help understand your use case. I would just remove the
IFB altogether and the above discussion is mute.

Thanks,
John
