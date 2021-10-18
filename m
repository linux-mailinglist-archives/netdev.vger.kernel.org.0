Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2793B431F28
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhJRORE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhJRORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:17:02 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEBAC03544C;
        Mon, 18 Oct 2021 06:53:42 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id s3so15060623ild.0;
        Mon, 18 Oct 2021 06:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EOZerNjV7VwRXGLfK1GgW58LQxxa7xTDPEkBD+ahYkk=;
        b=MT8G7y3ID+Y6hFzKjaDOoJZ/IOb7HMWvo4wYT0ZX1CsuyXPXxlPxz9ydKtAoEKDEol
         HBwMr92lF5CAy7XqnOBVPfWaIfyNXH4/ShAa3FTghKCL3fCHfpvRxHnvB8bwqw0PTLX8
         v1IeBe+iuo0ReVqoZaR27A3mIEYHg9yM3E7IFLayu2PreQScPfF8BrJw2tzEH+6QZqlf
         6AbdAhRxQTZib4nXx12aporL8S0EP5qvPZGO6cXQx3pAnV2JMLV49kEaw8/1Wa3ws6b6
         dxxjCXZZr99gZCm35+WXlgWQXqBymBR9eE1jsmwyu7q/QU7lPGVl37sWQgnd7+wwJ5kc
         BXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EOZerNjV7VwRXGLfK1GgW58LQxxa7xTDPEkBD+ahYkk=;
        b=m6JHwvulJcW8x0eRiHpOThqXyvG4VUBhDhLEEXxMaLdqovXUt6QWAi8+20ektPxox9
         5MgQFG7sETB4tQ3P9cfQ7fW4c66QXmtYunxylUj1RSVS+uklrS2wJXm7glzVw6yBU53M
         rFBX9iCcfwX6s/giUYMpA7VhjCtzZC2EuHlZkYWj92bzHPo2vnp/TXs7HPyEjgcmGYEu
         H7nqazYq3LH/ExjrQYBk1B38e35vmRdXf2ulSetQOQfGVdRbT4NrVjg0grX6it/WKmnJ
         G00b3Ph9iJB8G2IoB2IlfPsIq+HwIo6QfLuPop9TDpjxO/N6frmls36ZZsUqNsgQNjg0
         p6qA==
X-Gm-Message-State: AOAM531O4AnfF+kzdDu39cWRFN/lHxb25+RaapgptO2Gp/jPC4DtER3r
        uSZrA/3J+++Kmv+Lfwm2uIw=
X-Google-Smtp-Source: ABdhPJyXvxdhBXoSeTKmihalt1uma35kPl5KzbxSsvve67eVWXNiimgTwedVCHGZz0miFzjk2M498w==
X-Received: by 2002:a92:ca0c:: with SMTP id j12mr15408263ils.50.1634565221879;
        Mon, 18 Oct 2021 06:53:41 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id k9sm7521032ilo.46.2021.10.18.06.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 06:53:41 -0700 (PDT)
Date:   Mon, 18 Oct 2021 06:53:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, lmb@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <616d7c5aa492a_1eb12084b@john-XPS-13-9370.notmuch>
In-Reply-To: <87v91ug1bi.fsf@cloudflare.com>
References: <20211015080142.43424-1-liujian56@huawei.com>
 <87v91ug1bi.fsf@cloudflare.com>
Subject: Re: [PATCH] bpf, sockmap: Do not read sk_receive_queue in
 tcp_bpf_recvmsg if strparser enabled
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Fri, Oct 15, 2021 at 10:01 AM CEST, Liu Jian wrote:
> > If the strparser function of sk is turned on, all received data needs to
> > be processed by strparser first.
> >
> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
> 
> [...]
> 
> >  net/core/skmsg.c      | 5 +++++
> >  net/ipv4/tcp_bpf.c    | 9 ++++++---
> >  3 files changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index 94e2a1f6e58d..25e92dff04aa 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -390,6 +390,7 @@ void sk_psock_stop(struct sk_psock *psock, bool wait);
> >  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> >  void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
> >  void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
> > +bool sk_psock_strparser_started(struct sock *sk);
> >  #else
> >  static inline int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
> >  {
> > @@ -403,6 +404,11 @@ static inline void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
> >  static inline void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
> >  {
> >  }
> > +
> > +static inline bool sk_psock_strparser_started(struct sock *sk)
> > +{
> > +	return false;
> > +}
> >  #endif
> >  
> >  void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index e85b7f8491b9..dd64ef854f3e 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -1105,6 +1105,11 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
> >  	sk->sk_write_space = sk_psock_write_space;
> >  }
> >  
> > +bool sk_psock_strparser_started(struct sock *sk)
> > +{
> > +	return sk->sk_data_ready == sk_psock_strp_data_ready;
> 
> What if kTLS is configured on the socket? I think this check won't work then.

Liu, did you see this. I think its a bit cleaner, avoids the extra parser
check in hotpath, and should solve the issue?

https://patchwork.kernel.org/project/netdevbpf/patch/20211011191647.418704-3-john.fastabend@gmail.com/

I think it should also address Jakub's concern.

Thanks,
John

> 
> > +}
> > +
> >  void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
> >  {
> >  	if (!psock->saved_data_ready)
> 
> [...]


