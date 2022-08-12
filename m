Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96101591356
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiHLPzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbiHLPze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:55:34 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D2A1EAED;
        Fri, 12 Aug 2022 08:55:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 17so1101463plj.10;
        Fri, 12 Aug 2022 08:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc;
        bh=/OXCsoEFS1t2Ps27Ay8CucU2gGUVOh6I1V6v+9hpAN0=;
        b=FxbUeIeYMDT/MyAtLY2rOj1i1srqsf0p3CVUF8jOAzFwyCYY5dwVs0AKLFlSXzImIL
         yYEY3Pal4/+jtf6MBcvjvTjzrKFUTooLWqiMf7vyq3JAm+ouJjC7qLdTi5r637p1eqcl
         smv0udlNm34GgE3mHfYOcBQ4nspubK6jnQOu25aA+XPHQxzAHEf7L9DwAcn9TsrWQ91Y
         wgW289PXbPOFt9IejisSHfw8lQj67bfjkWHO3J/JUrID28ArKLjRoOQyRfxvyLaNyXj2
         PN0vAPlEHY8EcbEpGnBqyZmLR1+GVfejPCVIZwsWh3Ta3mwgQyiDkzmkfio5L4WHyfTI
         lcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc;
        bh=/OXCsoEFS1t2Ps27Ay8CucU2gGUVOh6I1V6v+9hpAN0=;
        b=H1rGSg75utTR2cVQ9Wl5vyt/ejaEELi7SboztRm/orrTz/gNJ7973+XED50adUpl52
         HNhfthsGmthke5j89U5Z0hdv5wTpVQ2Zr0sigw5uh0FJChbxryK3pUmnz7xwbYwIcD63
         6c8vcsnuOSGxXIG9pS9SAriO+BOVLAOegykMwmoTztqjL/1s9Rd2JAVhjV8OrXFCSO+F
         x/t2OAUGkVdP10kYUwvIOklgo/wdVkvhrJ9IhLG/ggeJ+rkQZ9Hg+g6lpf/90NDftbg8
         GbBbHbKbmYWBN/57CmI5qM6R7nSCD2ib0RSyoj9sCc6AcJTiD4YU9l9Yd1GJYlfoCL9b
         iWGA==
X-Gm-Message-State: ACgBeo3sNJWKim9wgj8wdS0rXnDkIO+bUw8RrFr7PhB23cyLA6+1q4K/
        e6p92tQ1RdBHCWN4uoRUIcU=
X-Google-Smtp-Source: AA6agR5MUpUETBIiMk5PZAsfPCi3u/pr+aMUp+dEKeF+hy09OjR+IszK2mpqk6WUVCivhd5AXwDvYA==
X-Received: by 2002:a17:903:2311:b0:16f:2420:dde4 with SMTP id d17-20020a170903231100b0016f2420dde4mr4526493plh.20.1660319732853;
        Fri, 12 Aug 2022 08:55:32 -0700 (PDT)
Received: from localhost ([98.97.34.78])
        by smtp.gmail.com with ESMTPSA id c70-20020a621c49000000b0052fd43f1747sm1737555pfc.185.2022.08.12.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 08:55:31 -0700 (PDT)
Date:   Fri, 12 Aug 2022 08:55:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <62f677f22b20f_2d80c208b9@john.notmuch>
In-Reply-To: <20220809094915.150391-1-liujian56@huawei.com>
References: <20220809094915.150391-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf-next v2] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> Fix one kernel NULL pointer dereference as below:
> 
> [  224.462334] Call Trace:
> [  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
> [  224.462441]  ? sock_has_perm+0x78/0xa0
> [  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
> [  224.462494]  inet_recvmsg+0x5b/0xd0
> [  224.462534]  __sys_recvfrom+0xc8/0x130
> [  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
> [  224.462606]  ? __do_page_fault+0x2de/0x500
> [  224.462635]  __x64_sys_recvfrom+0x24/0x30
> [  224.462660]  do_syscall_64+0x5d/0x1d0
> [  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> 
> In commit 9974d37ea75f ("skmsg: Fix invalid last sg check in
> sk_msg_recvmsg()"), we change last sg check to sg_is_last(),
> but in sockmap redirection case (without stream_parser/stream_verdict/
> skb_verdict), we did not mark the end of the scatterlist. Check the
> sk_msg_alloc, sk_msg_page_add, and bpf_msg_push_data functions, they all
> do not mark the end of sg. They are expected to use sg.end for end
> judgment. So the judgment of '(i != msg_rx->sg.end)' is added back here.
> 
> Fixes: 9974d37ea75f ("skmsg: Fix invalid last sg check in sk_msg_recvmsg()")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

OK lets take this. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
