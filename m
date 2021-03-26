Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E7349F59
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhCZCK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCZCKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 22:10:34 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB26BC06174A;
        Thu, 25 Mar 2021 19:10:33 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id n21so3927749ioa.7;
        Thu, 25 Mar 2021 19:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=f4QzQHkIISPtJxpK6emPxDOPAZKulChsIifxFNKcOeI=;
        b=quzSlVV7O/ubnIoiiGrJZDgzzkzGKXV2JwhndjDAwLnMPdYFlAMD3O2M4lVzJxkacH
         8pJq8h/wqpeaAaohw22lAA+pslRp+a+kf9goM+Wp7CWsfvSxmkFuW7ajeHbcFmItfb0z
         59Zg+smu7QCbHDtpN+lsrE+nxL27WfG518MW654Ro8VdjZKTozPScZr1i2NAK72YDPM5
         aMhiXd8wvwSASimuNI6w6KFIb+hsVO5UPaGjWuE0gmCkd4bef228k8KhW9s/QMXBZz1e
         bTIgRVdi2Pa1p6aJC6LYckUbDPBtf1Jj/2/vG9enNhoSu9f6FMM/VPCZOC/DGMfSSKfH
         i1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=f4QzQHkIISPtJxpK6emPxDOPAZKulChsIifxFNKcOeI=;
        b=Rj+OfWk+MDYPEY82fOkAwrBZuXAB1ssz5g60EMcQA5HO3Y89cJnlM+DxGG+PmqGR7E
         IKdicAY1ujurPfgApQSi2ByYWgQnNo4AwXJG9tCPvUcfVMfcOonTsrNL247CFvavE22d
         GJylnRKttJYu1bD8t85q1/ugZX6zF9Q8EqDuRuj+HUXJPmJGDoNBsFGg9c18U4+hgqOO
         gpX/7nPeuTrKRTADKTviC9NMd9RJprFKfeUJ45ESW+CZgrxrLDI963dBNicP1pwydlJS
         UbgZLQ+pkTeX1+ttOk6q0x013SADK+iq0xMsugOMhf26QvE7TiTuMi4j5j9LvnZhan+t
         oTsQ==
X-Gm-Message-State: AOAM531MXq85q0vCUSBBT2hVWXNqSUSxQdPLtyaN+19vTowTFA+5XI4V
        TC+fo0DgvaIRyYIVmON1Uao=
X-Google-Smtp-Source: ABdhPJwEqGBIP/3XjOGVLC1ymlpWYmj5QFCoyOq9plHe1O2vHawyqHDADMk2zW+LBvW3gOlg2fgFCQ==
X-Received: by 2002:a02:aa92:: with SMTP id u18mr9972919jai.119.1616724633011;
        Thu, 25 Mar 2021 19:10:33 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id b9sm3622534iof.54.2021.03.25.19.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 19:10:32 -0700 (PDT)
Date:   Thu, 25 Mar 2021 19:10:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605d428fa91cd_9529c20842@john-XPS-13-9370.notmuch>
In-Reply-To: <20210323003808.16074-5-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v6 04/12] skmsg: avoid lock_sock() in
 sk_psock_backlog()
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
> We do not have to lock the sock to avoid losing sk_socket,
> instead we can purge all the ingress queues when we close
> the socket. Sending or receiving packets after orphaning
> socket makes no sense.
> 
> We do purge these queues when psock refcnt reaches zero but
> here we want to purge them explicitly in sock_map_close().
> There are also some nasty race conditions on testing bit
> SK_PSOCK_TX_ENABLED and queuing/canceling the psock work,
> we can expand psock->ingress_lock a bit to protect them too.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h |  1 +
>  net/core/skmsg.c      | 51 +++++++++++++++++++++++++++----------------
>  net/core/sock_map.c   |  1 +
>  3 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index f2d45a73b2b2..cf23e6e2cf54 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
>  }
>  
>  struct sk_psock *sk_psock_init(struct sock *sk, int node);
> +void sk_psock_stop(struct sk_psock *psock, bool wait);
>  
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 305dddc51857..9176add87643 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -497,7 +497,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  	if (!ingress) {
>  		if (!sock_writeable(psock->sk))
>  			return -EAGAIN;
> -		return skb_send_sock_locked(psock->sk, skb, off, len);
> +		return skb_send_sock(psock->sk, skb, off, len);
>  	}
>  	return sk_psock_skb_ingress(psock, skb);
>  }
> @@ -511,8 +511,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  	u32 len, off;
>  	int ret;

Hi Cong,

I'm trying to understand if the workqueue logic will somehow prevent the
following,

  CPU0                         CPU1

 work dequeue
 sk_psock_backlog()
    ... do backlog
    ... also maybe sleep

                               schedule_work()
                               work_dequeue
                               sk_psock_backlog()

          <----- multiple runners -------->

 work_complete

It seems we could get multiple instances of sk_psock_backlog(), unless
the max_active is set to 1 in __queue_work() which would push us through
the WORK_STRUCT_DELAYED state. At least thats my initial read. Before
it didn't matter because we had the sock_lock to ensure we have only a
single runner here.

I need to study the workqueue code here to be sure, but I'm thinking
this might a problem unless we set up the workqueue correctly.

Do you have any extra details on why above can't happen thanks.

>  
> -	/* Lock sock to avoid losing sk_socket during loop. */
> -	lock_sock(psock->sk);
>  	if (state->skb) {
>  		skb = state->skb;
>  		len = state->len;
> @@ -529,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  		skb_bpf_redirect_clear(skb);
>  		do {
>  			ret = -EIO;
> -			if (likely(psock->sk->sk_socket))
> +			if (!sock_flag(psock->sk, SOCK_DEAD))
>  				ret = sk_psock_handle_skb(psock, skb, off,
>  							  len, ingress);
>  			if (ret <= 0) {

Thanks,
John
