Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAC03C6179
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhGLRH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbhGLRHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:07:54 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A02C0613DD;
        Mon, 12 Jul 2021 10:05:05 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k16so23504100ios.10;
        Mon, 12 Jul 2021 10:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xwTndIajSX77vddtcA1Zj4UfhnN6xalvEUcShg8NSMA=;
        b=XFJF+7g2Y8YM4/ql5RdR1upRMg3VGecV9stHZ0/6Ey0VChcABW1lPOTsRn2fvbsDYN
         s2CONQ34SAvZ3uw/CMZVI95YEODwiUsmaBNBk+iHKeN3DvYIvsfyKjumgEinZXqMThOF
         KIuq3pAgdviAoGkBfsGeVA0k1O89ThHynj6jq2oFTAr2tIvwVKbKR3sj/Az9AjgLuZ7y
         Lz5ElSPWONxAlkp6M9+Q6D8Bq/pTIyiB77HuUveWS68gaeVVpx828QCzgJLVPDDsL49u
         LQAeBFZzAfXOMCKx03uhV3qkSbLB8iqvPl0Ac50YAQfl0MnIhgOmqfaHTtSNs6Pr9v7t
         2q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xwTndIajSX77vddtcA1Zj4UfhnN6xalvEUcShg8NSMA=;
        b=mFhNX1LL0E3Uu2elDzVtm7h04h9L2lgdKM/9GClwQrd8KKZYHZ5NMNw1aoBRK4xWi0
         5NQqKh15x779q3RIcuwCXIPISJrCeu4Zmecgf4JvLexYbpoMKTWFZkWKNBJtu0duw1RV
         xpKKjmwSBgBsn7EDyKFaFaD4bfLbjG0gPK8YmKIEJcYijx1nGUeJ4hNGpMDjk3Y1/myy
         BvyTQvBhxX0ZUwk6VrtOkZM+56PAINVsQVDePAyXr12hNGy0M19FWBR9A2jeodn+YGiY
         V77U+ynKT9FlWIbHvyUwhRU/cKyWCNHBHhk6pBAUC5CCooIig9TiT/0dg6I4DiVxu34i
         UumQ==
X-Gm-Message-State: AOAM531V0LdNwHu7RJ1JovQTg96S3BAg4dhIgcLtb4uZBPykM0lgkzpk
        xvclnpseXRFm5GQOsuw8PdY=
X-Google-Smtp-Source: ABdhPJxkAqtv3Z4C51zm3OBv513GEG6Vvzn2JqU+9VyUYSFd66Y6uCHZ5L6I8/6Zfg86trjMZ/7JXw==
X-Received: by 2002:a05:6602:3347:: with SMTP id c7mr20916734ioz.101.1626109505219;
        Mon, 12 Jul 2021 10:05:05 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i5sm8678178ilc.16.2021.07.12.10.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:05:04 -0700 (PDT)
Date:   Mon, 12 Jul 2021 10:04:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60ec763a26b02_29dcc208e8@john-XPS-13-9370.notmuch>
In-Reply-To: <20210704190252.11866-4-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
 <20210704190252.11866-4-xiyou.wangcong@gmail.com>
Subject: RE: [PATCH bpf-next v5 03/11] af_unix: implement ->read_sock() for
 sockmap
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
> Implement ->read_sock() for AF_UNIX datagram socket, it is
> pretty much similar to udp_read_sock().
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

[...]

> +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> +			  sk_read_actor_t recv_actor)
> +{
> +	int copied = 0;
> +
> +	while (1) {
> +		struct unix_sock *u = unix_sk(sk);
> +		struct sk_buff *skb;
> +		int used, err;
> +
> +		mutex_lock(&u->iolock);
> +		skb = skb_recv_datagram(sk, 0, 1, &err);
> +		mutex_unlock(&u->iolock);
> +		if (!skb)
> +			return err;
> +
> +		used = recv_actor(desc, skb, 0, skb->len);
> +		if (used <= 0) {
> +			if (!copied)
> +				copied = used;
> +			kfree_skb(skb);

Is it OK to drop a unix dgram? I think the sockets likely wouldn't
expect this?

Anyways I'll have a proposed fix for TCP side shortly. And we can
extend it here as well if needed.

> +			break;
> +		} else if (used <= skb->len) {
> +			copied += used;
> +		}
> +
> +		kfree_skb(skb);
> +		if (!desc->count)
> +			break;
> +	}
> +
> +	return copied;
> +}
> +
>  /*
>   *	Sleep until more data has arrived. But check for races..
>   */
> -- 
> 2.27.0
> 


