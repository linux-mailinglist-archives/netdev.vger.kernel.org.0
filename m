Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433248129C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhL2MUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbhL2MUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:20:44 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26026C06173E
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 04:20:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id k18so7364151wrg.11
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 04:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qdxysVGtt4FcWQNLA8BShzevbYmgDdMZZHbKkdXEhqc=;
        b=Ji4DMvElI3uotsoXs1c78pyZyHcVYEJjOZMFBfs9dbd8d0XLxjdb7Jgw76bNZCZsCH
         0ieSGZkZj68IXoGVq2amW5FXDnNW4F59P+Q+t5lI5UWh723BP+3N7WsdeoxH5oN4TT/o
         BGJDtlOS3Nl6l6xaVipLLLtweZUVsbN+HCchOSdKsVjI2K/d+0jpR72pezVf2IWdA5Sz
         1pIdN8aFuEq7+oYLG4rj3ZuFt6IkdXXhc93q88D8nxNpRDck9Tv+dTOILegxDpgaMQaP
         Dymk72ZSLBC43dunQ4paVVrGUMzPdzjci5vDA0HX4Pfst0/YOGwSp+07ZbdhEZtykSnn
         Lv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qdxysVGtt4FcWQNLA8BShzevbYmgDdMZZHbKkdXEhqc=;
        b=5iERuO345p2EfYrY5KdRHkH+Rc02QS+l7yri44Udb5ERkvWv6SWhnpXMLQWrCkWbj0
         MnX6aNAWJvqaCGIxpN1rtUX5WV49z86asahWxWeFOkmxB6ree4YCTNQkoO9J57gCHfgS
         OLPTfAhaOiMzMvT7JK5KRKxiT6gTqMwhX8Pfr17zI4JhO29YNsnoojU4UhrLMXrGD9i0
         0Bd6rnkuX6dDCefj0tQuwnT1JarGDAlbTd2ojHg/mXz6np0lQAVZQ5Xfp9h9dAhVjxIs
         6WM9JrfdmIVE7jLPTOhwsyhKl//iRpcPG+1gWFjOuMPZhPA/Y7tLM3LXPISCWJPFRsyX
         6suQ==
X-Gm-Message-State: AOAM531yuDrW+bHDJarof8zh4qiVnqgUtw65Ej7y01iYdq3TEUrgCrZg
        7ltsyhx13W89os2aNF25wq+bpg==
X-Google-Smtp-Source: ABdhPJwnKEqMnn1CMxmAL3M3tBnIe+RumF4OwRsvIzHGJxu6pjb3MMw56OApPMB/lZBYuCq8jjQ4Bg==
X-Received: by 2002:a5d:4d42:: with SMTP id a2mr20779611wru.311.1640780441975;
        Wed, 29 Dec 2021 04:20:41 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id h19sm20347949wmm.13.2021.12.29.04.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 04:20:41 -0800 (PST)
Date:   Wed, 29 Dec 2021 12:20:39 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv2 net] sctp: use call_rcu to free endpoint
Message-ID: <YcxSl+YZ2WCRh9Ls@google.com>
References: <152f3b81e78d311514330a5b97131beb459b01f5.1640282670.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <152f3b81e78d311514330a5b97131beb459b01f5.1640282670.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021, Xin Long wrote:

> This patch is to delay the endpoint free by calling call_rcu() to fix
> another use-after-free issue in sctp_sock_dump():
> 
>   BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
>   Call Trace:
>     __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
>     lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>     _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
>     spin_lock_bh include/linux/spinlock.h:334 [inline]
>     __lock_sock+0x203/0x350 net/core/sock.c:2253
>     lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
>     lock_sock include/net/sock.h:1492 [inline]
>     sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
>     sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
>     sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
>     __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
>     inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
>     netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
>     __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
>     netlink_dump_start include/linux/netlink.h:216 [inline]
>     inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
>     __sock_diag_cmd net/core/sock_diag.c:232 [inline]
>     sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
>     netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
>     sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
> 
> This issue occurs when asoc is peeled off and the old sk is freed after
> getting it by asoc->base.sk and before calling lock_sock(sk).
> 
> To prevent the sk free, as a holder of the sk, ep should be alive when
> calling lock_sock(). This patch uses call_rcu() and moves sock_put and
> ep free into sctp_endpoint_destroy_rcu(), so that it's safe to try to
> hold the ep under rcu_read_lock in sctp_transport_traverse_process().
> 
> If sctp_endpoint_hold() returns true, it means this ep is still alive
> and we have held it and can continue to dump it; If it returns false,
> it means this ep is dead and can be freed after rcu_read_unlock, and
> we should skip it.
> 
> In sctp_sock_dump(), after locking the sk, if this ep is different from
> tsp->asoc->ep, it means during this dumping, this asoc was peeled off
> before calling lock_sock(), and the sk should be skipped; If this ep is
> the same with tsp->asoc->ep, it means no peeloff happens on this asoc,
> and due to lock_sock, no peeloff will happen either until release_sock.
> 
> Note that delaying endpoint free won't delay the port release, as the
> port release happens in sctp_endpoint_destroy() before calling call_rcu().
> Also, freeing endpoint by call_rcu() makes it safe to access the sk by
> asoc->base.sk in sctp_assocs_seq_show() and sctp_rcv().
> 
> Thanks Jones to bring this issue up.
> 
> v1->v2:
>   - improve the changelog.
>   - add kfree(ep) into sctp_endpoint_destroy_rcu(), as Jakub noticed.
> 
> Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/sctp.h    |  6 +++---
>  include/net/sctp/structs.h |  3 ++-
>  net/sctp/diag.c            | 12 ++++++------
>  net/sctp/endpointola.c     | 23 +++++++++++++++--------
>  net/sctp/socket.c          | 23 +++++++++++++++--------
>  5 files changed, 41 insertions(+), 26 deletions(-)

My test has been soaking for about an hour now with no crashes.

So far so good:

Tested-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
