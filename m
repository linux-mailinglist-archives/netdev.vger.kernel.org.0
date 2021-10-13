Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D596242C221
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhJMOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbhJMOJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:09:14 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F01C061570;
        Wed, 13 Oct 2021 07:07:10 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j8so2856678ila.11;
        Wed, 13 Oct 2021 07:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OIpe5CXqjO0j1Yipt7qNHWybOtR4WIPY8YXbWdPRvqc=;
        b=prg2sO/RoAM/NU+d18t+N1X/wfQBQtbzHGlrtZEJ+lb36kxgu75bzfVjzovHwTxJEt
         AAXEeqBdhK3XB6wAmlPAcg1/koAVvQ0+h95HiwYspCKTbJXw62oUPj4gMKCQtt8RS0lS
         PvFZKPO4ClQ1sXACJuuAP3P2eXm9KKT1ybWohyD2NISq5fjnSGh2dTYIsOC9piOHNRQ/
         g6B0W9MP5HYv5ze4910IAO7Pats3uaEDfnlEFUDqMqzDkObBkpO5p3O4qLeiL7x+HNMI
         pNRw06ChcZbu2xuSQuBEN32yMfImbgHvJDvBkfHvNc/csK2jl72PvThjFE5csCbaYvaC
         YQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OIpe5CXqjO0j1Yipt7qNHWybOtR4WIPY8YXbWdPRvqc=;
        b=dITsMd1C2RiRPwU5pBCQCxupEofkL9twfPW+z+yBf2R8E9uLPktc3+7m+g7g2oJUve
         pxUnpMpjbyQVqWvY6xGF6f4cOuggUskrcukx6MinZlOvggKyxxg5y3s9sNI4wPXPu+bZ
         Fbl7Duq9eCeeSEdI+E+WoL/sQloKDMVfB69PfaFbYIoqn8w7ejc/CN3AKQQ7adCnux2A
         IwtoRgONNi0TqKs2GqkRHmYhXPGP0aQabkZjUDxJSSNb+osbQmhN12kRKsKMKjcgkFz9
         VBZ0Orja/pAPIHUbJsfs8JQ/sjW0ENgBO8lwJUxLbvu1GGlxfIPtk4StsA+j4SDErPX0
         i6Sg==
X-Gm-Message-State: AOAM533W42by9X5T97agkqxSu9MuSzFLFbUB2+lCFKz9FSOjo5lt2jDr
        cNCSve5RY6WX5oLsK/S0+hs=
X-Google-Smtp-Source: ABdhPJwfX9AVotR7iYVaFCTGFpDajdE8cs6ZUD3nPJAlsTI16uIyGiqEUu2tZTeaf003ZKhp7s64SQ==
X-Received: by 2002:a05:6e02:2141:: with SMTP id d1mr6361675ilv.5.1634134030082;
        Wed, 13 Oct 2021 07:07:10 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id g13sm6328890ilc.54.2021.10.13.07.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:07:09 -0700 (PDT)
Date:   Wed, 13 Oct 2021 07:07:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6166e806d00ea_48c5d208be@john-XPS-13-9370.notmuch>
In-Reply-To: <20211007195147.28462-1-xiyou.wangcong@gmail.com>
References: <20211007195147.28462-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v3] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
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
> Jiang observed OOM frequently when testing our AF_UNIX/UDP
> proxy. This is due to the fact that we do not actually limit
> the socket memory before queueing skb to ingress_skb. We
> charge the skb memory later when handling the psock backlog,
> and it is not limited either.
> 
> This patch adds checks for sk->sk_rcvbuf right before queuing
> to ingress_skb and drops or retries the packets if this limit
> exceeds. This is very similar to UDP receive path. Ideally we
> should set the skb owner before this check too, but it is hard
> to make TCP happy with sk_forward_alloc.
> 
> For TCP, we can not just drop the packets on errors. TCP ACKs
> are already sent for those packet before reaching
> ->sk_data_ready(). Instead, we use best effort to retry, this
> works because TCP does not remove the skb from receive queue
> at that point and exceeding sk_rcvbuf limit is a temporary
> situation.
> 
> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Makes sense to include a fixes tag here.

> ---
> v3: add retry logic for TCP
> v2: add READ_ONCE()

I agree this logic is needed, but I think the below is not
complete. I can get the couple extra fixes in front of this
today/tomorrow on my side and kick it through some testing here.
Then we should push it as a series. Your patch + additions.

> 
>  net/core/skmsg.c | 15 +++++++++------
>  net/ipv4/tcp.c   |  2 ++
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 2d6249b28928..356c314cd60c 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c

All the skmsg changes are good.


> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e8b48df73c85..8b243fcdbb8f 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1665,6 +1665,8 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  			if (used <= 0) {
>  				if (!copied)
>  					copied = used;
> +				if (used == -EAGAIN)
> +					continue;

This is not a good idea, looping through read_sock because we have
hit a memory limit is not going to work. If something is holding the
memlimit pinned this could loop indefinately.

Also this will run the verdict multiple times on the same bytes. For
apply/cork logic this will break plus just basic parsers will be
confused when they see duplicate bytes.

We need to do a workqueue and then retry later.

Final missing piece is that strparser logic would still not handle
this correctly.

I don't mind spending some time on this today. I'll apply your
patch and then add a few fixes for above.

Thanks,
John
