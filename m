Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663632F778
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 02:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCFBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 20:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCFBVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 20:21:06 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87350C06175F;
        Fri,  5 Mar 2021 17:21:06 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e2so3752892ilu.0;
        Fri, 05 Mar 2021 17:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5lSJ3kjsDvPGbTIMzkdA7HrV3yg0LgzvSV7ZarmtD0c=;
        b=mcJ7A0v5dgFe21u+S5ZFErKtmIJmTqW7vnPz8mk4Fn0X24nFGEZgSQD62qUdoTS3sA
         B0cUGs/NPkS3H7hsYSIwRCuKjE/qlPeSbETr8sb1y/qi+8hsV3hvi5iZ9TTDdYsG1saF
         r7mNy4fZadBE8DodE3cC13UxT1SQjNlLDmu8MnoqkxeOmSYW+gTOy03Ro3W9P+hmurZu
         s/xc0Q45LtHxq+q3DDCbY2porEhSspyW5uh612ED1qJTWvZFgn/2JPWPHCiu8BgDFXPW
         i9yV+AH7MUrH69aOeeMtNf/Gkq5qOZkYXxDPGBqdsIHMUcnxCinrum9SBSFqXAfJMLvt
         fzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5lSJ3kjsDvPGbTIMzkdA7HrV3yg0LgzvSV7ZarmtD0c=;
        b=N35VVJMrFiOB2EZAH7Q8LzealW0lf8b67ca2LWpFPe7hXobaT9UET2l71+XiQ9VAGQ
         oAiJc5jiljyCW+TuerMJVffsJ3vV1qSpw7LBSe3Z9UqlDxRADkU7IEpCez7x+ujPX/5+
         K70OE/heKixXyM/QeAmvV7vqOS/mUM/zjg5ngpOemYsYhk4/wGgXLNLJlTIXx/N1wwOx
         R/EEtgJDxQggCtTzoaa4ZaFTXJPW1DosDNmU/itz1+KZ4xA7BgI+53FeAHNGyJELoqCO
         1aOgvWhtJLMcqIKoKbjx856NC2L3wgYMUXHxEgsGIGRV5fetUEHrgkh8R1q/J8yfijb2
         YEcA==
X-Gm-Message-State: AOAM530ucIu+Rw1XBzsOuXXuPdIE4OVBPySf3/MeVcQq14RHQ773cEdT
        mdlXBcTmlfmyWBPCnZPZZTU=
X-Google-Smtp-Source: ABdhPJymyv6By5j/o0dMpugGv3oJy57cMVDl+Fs2ONVe8gVMfLjb0pZRswfsPx4eSyPKSOyd8OnFKA==
X-Received: by 2002:a05:6e02:b4e:: with SMTP id f14mr10526242ilu.289.1614993665758;
        Fri, 05 Mar 2021 17:21:05 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id t9sm2101522ioi.27.2021.03.05.17.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 17:21:05 -0800 (PST)
Date:   Fri, 05 Mar 2021 17:20:58 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6042d8fa32b92_135da20871@john-XPS-13-9370.notmuch>
In-Reply-To: <20210305015655.14249-4-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
 <20210305015655.14249-4-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 3/9] udp: implement ->sendmsg_locked()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> UDP already has udp_sendmsg() which takes lock_sock() inside.
> We have to build ->sendmsg_locked() on top of it, by adding
> a new parameter for whether the sock has been locked.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/udp.h  |  1 +
>  net/ipv4/af_inet.c |  1 +
>  net/ipv4/udp.c     | 30 +++++++++++++++++++++++-------
>  3 files changed, 25 insertions(+), 7 deletions(-)

[...]

> -int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
> +static int __udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
>  {

The lock_sock is also taken by BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK() in
udp_sendmsg(),

 if (cgroup_bpf_enabled(BPF_CGROUP_UDP4_SENDMSG) && !connected) {
    err = BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk,
                                    (struct sockaddr *)usin, &ipc.addr);

so that will also need to be handled.

It also looks like sk_dst_set() wants the sock lock to be held, but I'm not
seeing how its covered in the current code,

 static inline void
 __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
        struct dst_entry *old_dst;

        sk_tx_queue_clear(sk);
        sk->sk_dst_pending_confirm = 0;
        old_dst = rcu_dereference_protected(sk->sk_dst_cache,
                                            lockdep_sock_is_held(sk));
        rcu_assign_pointer(sk->sk_dst_cache, dst);
        dst_release(old_dst);
 }

I guess this could trip lockdep now, I'll dig a bit more Monday and see
if its actually the case.

In general I don't really like code that wraps locks in 'if' branches
like this. It seem fragile to me. I didn't walk every path in the code
to see if a lock is taken in any of the called functions but it looks
like ip_send_skb() can call into netfilter code and may try to take
the sock lock.

Do we need this locked send at all? We use it in sk_psock_backlog
but that routine needs an optimization rewrite for TCP anyways.
Its dropping a lot of performance on the floor for no good reason.

.John
