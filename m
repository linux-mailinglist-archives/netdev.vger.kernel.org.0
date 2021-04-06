Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B3E355B09
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbhDFSM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhDFSM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:12:27 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C172C06174A;
        Tue,  6 Apr 2021 11:12:19 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r193so13587757ior.9;
        Tue, 06 Apr 2021 11:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dbKehqFatDSQcVDjENi2b6srsbitv1ymAQeqIDiNaU0=;
        b=YlpQNCtgMLKGKl0/MlVQ5QzAQnf8j7YfUx8YQjXk+FYH/NKcersaLBL5v6UsnOpYxa
         zfsKnjKmRkA8+WcCaS19Wot7kOmKA6qLWJIk3i8tlVioydF6UVgkNNpz6tGsocD27EpQ
         D7JkPDE7BWuy+XSEiYiUlLAz0HU5BpnDnJRRamXf+S3oy7dSYZj8h6qB5sAJ6BGMGDB/
         UvtGeUrmHxiIAP8+8WXiMPKYJmR21vUVS6NNXC4dOGVkl3uRMS9sUFUcL/cFCU5x79WF
         uo00NvNDtboeHNDqTuJehmQOabbnPesxmIbnzyUfO3EWbWx6Va4uVDVi7CVpkqmeKM35
         TxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dbKehqFatDSQcVDjENi2b6srsbitv1ymAQeqIDiNaU0=;
        b=VIjY1UD76cDw8CiKpg9F95MCQ7aqSyQGBRKOiy2Q9fonBd7yMuUFS4b2xEW5J8x78W
         4wjFCWr0zAZK1BVQuhTRMnRplGge0VCmpimxi3uH1bY976+5Q/Beicu3xb3nqjCdBNGH
         6JJBXNDyiA9Kqubqo7lk3BflmBBDy6Cn8lzR8ZFZLUm/jAy0YI6eglEF9MivOht9cTgt
         ZWgRo6mvqb7N7/Sc1F91BiOQY/RYQSDSe6JIyk5gLY0+bM52sGhNscJ7kpJZ4W5pKgYa
         vMcXB3rCDAlGDKFR4peWCV1Gk6GT8dlkyunnkVVBkMBOODb946ig/KAKWdhVr5N792AP
         w1lw==
X-Gm-Message-State: AOAM533QXAkfeUbGxWVu5CmyZNkqGomYXBKH15i7pQ/NtlT/TmEhFiRs
        cZIOZRJLh1/wTl9TNQ5sij0=
X-Google-Smtp-Source: ABdhPJw+z4Usn808/YCBABN/hRCf3PPqpQZEwzKjA4wnlnkBVupuYDqPRP43tye5+IFzEmzdXFDFaA==
X-Received: by 2002:a05:6638:2101:: with SMTP id n1mr30775934jaj.7.1617732738752;
        Tue, 06 Apr 2021 11:12:18 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id d2sm13022251ilm.7.2021.04.06.11.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:12:18 -0700 (PDT)
Date:   Tue, 06 Apr 2021 11:12:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606ca47a5496b_f02420821@john-XPS-13-9370.notmuch>
In-Reply-To: <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-11-xiyou.wangcong@gmail.com>
 <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
Subject: Re: [Patch bpf-next v8 10/16] sock: introduce
 sk->sk_prot->psock_update_sk_prot()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> 
> 
> On 3/31/21 4:32 AM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > Currently sockmap calls into each protocol to update the struct
> > proto and replace it. This certainly won't work when the protocol
> > is implemented as a module, for example, AF_UNIX.
> > 
> > Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> > protocol can implement its own way to replace the struct proto.
> > This also helps get rid of symbol dependencies on CONFIG_INET.
> 
> [...]
> 
> 
> >  
> > -struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> > +int tcp_bpf_update_proto(struct sock *sk, bool restore)
> >  {
> > +	struct sk_psock *psock = sk_psock(sk);
> 
> I do not think RCU is held here ?

Hi, thanks for looking at this.

> 
> sk_psock() is using rcu_dereference_sk_user_data()

First caller of this is here,

 sock_{hash|map}_update_common <- has a WARN_ON_ONCE(!rcu_read_lock_held);
  sock_map_link()
   sock_map_init_proto()
    psock_update_sk_prot(sk, false)

And the other does this,

 sk_psock_put()
   sk_psock_drop()
     sk_psock_restore_proto
        psock_update_sk_prot(sk, true)

But we can get here through many callers and it sure doesn't look like its
all safe. For example one case,

 .sendmsg
   tcp_bpf_sendmsg
    psock = sk_psock_get(sk)
    sk_psock_put(sk, psock) <- this doesn't have the RCU held

> 
> >  	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
> >  	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
> >  
> 
> Same issue in udp_bpf_update_proto() of course.
> 

Yep.

Either we revert the patch or we can fix it to pass the psock through.
Passing the psock works because we have a reference on it and it wont
go away. I don't have any other good ideas off-hand.

Thanks Eric! I'm a bit surprised we didn't get an RCU splat from the
tests though.

.John
