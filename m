Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB34323CE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhJRQ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhJRQ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:29:09 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D058C06161C;
        Mon, 18 Oct 2021 09:26:58 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id m20so16929335iol.4;
        Mon, 18 Oct 2021 09:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=offus+2ar6u0y56JRk1lmDPVUgFh2hpnxwvio9DDSkg=;
        b=ZpleY+Mg375E2NzQdCafhH3vCAVhN3audaqcw/mWIMZrNOyQyslIs5KNAkZUmvYG0q
         SUzzZUruNqQ6ugogCiHB5p3aa9cPV4dAyhOkHR0/YBUSfJsSNRz0rzIXJKPA2YaVkFso
         GGpcbyR52p+mc7dvzDP5CKb49+inh412KdCoeJeZ/1SMBGlUrhlfDkdcmvjDIVhnBOtO
         0qmF7/HxrXfufLbm/Wo4Z5dFiZ8umxk1IfOK6yJ+lY5YwEiK5ipw0xGzBSyO0ISAqNIv
         AdMmc62IHivW7CFdW9fX6bEYDAosYdKqJmpjV3pF+Cgdq3I8Q9tniHQGy9DppebpjhNP
         johw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=offus+2ar6u0y56JRk1lmDPVUgFh2hpnxwvio9DDSkg=;
        b=ZQ/QylqyucznaiAtT22JnaH8ZSZN5QNZhWtVBC0it+KcImF3bLyjSduXO967drcn3J
         I0AgoLXX/jcBXcOtdk2tBKN/LqEspQ6iuxhWtW3Ch7enAeB/fXFraeUtHDko8NZ2jLbY
         k0omWbm79RcIBcWo2L5iKWDkh9PwudxVNlvAGYR9OWyxL59L6zVmlbNO+GxCySej4AVM
         tWXR+N30/+dO68TamfnzB7hveqe/IVkTXjdA2hhm87488WJGw8fu0iA0hjm75ObEE194
         eUgAo6s9ncVgJEmDwA1OpLY1ZU3pannpFcNqHvUNCVgpE+dE8aShqLo7nga0JUi8rzfX
         GQ5A==
X-Gm-Message-State: AOAM531xNYpt0epNFSG0nhvZ2Z8yF+P+V7Kwrz9ki5qEWGZ/pr03h4ZQ
        wYvu+rYrnp0ip6OXx55lXIY=
X-Google-Smtp-Source: ABdhPJwTaJyTZxdcPRPvuecXIBXcsXXAZiARQZZ0xn4z3qI/THeN4y2v62gMUUsZ8FRrv+wxDxKxrg==
X-Received: by 2002:a05:6602:2dd2:: with SMTP id l18mr15508118iow.86.1634574417569;
        Mon, 18 Oct 2021 09:26:57 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id d4sm7492970ilv.3.2021.10.18.09.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 09:26:57 -0700 (PDT)
Date:   Mon, 18 Oct 2021 09:26:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Qing Wang <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Message-ID: <616da04982886_1eb12083d@john-XPS-13-9370.notmuch>
In-Reply-To: <1634556651-38702-1-git-send-email-wangqing@vivo.com>
References: <1634556651-38702-1-git-send-email-wangqing@vivo.com>
Subject: RE: [PATCH V2] net: bpf: switch over to memdup_user()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qing Wang wrote:
> This patch fixes the following Coccinelle warning:
> 
> net/bpf/test_run.c:361:8-15: WARNING opportunity for memdup_user
> net/bpf/test_run.c:1055:8-15: WARNING opportunity for memdup_user
> 
> Use memdup_user rather than duplicating its implementation
> This is a little bit restricted to reduce false positives
> 
> Signed-off-by: Qing Wang <wangqing@vivo.com>
> ---
>  net/bpf/test_run.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)

LGTM, but subject line should be '[PATCH bpf-next v2]' there is no reason
to push to fixes trees here.

Also might be worth noting that the original kzalloc could have just been
a kalloc because copy_from_user will zero any extra bytes.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 5296087..fbda8f5
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -358,13 +358,9 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>  		return -EINVAL;
>  
>  	if (ctx_size_in) {
> -		info.ctx = kzalloc(ctx_size_in, GFP_USER);
> -		if (!info.ctx)
> -			return -ENOMEM;
> -		if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
> -			err = -EFAULT;
> -			goto out;
> -		}
> +		info.ctx = memdup_user(ctx_in, ctx_size_in);
> +		if (IS_ERR(info.ctx))
> +			return PTR_ERR(info.ctx);
>  	} else {
>  		info.ctx = NULL;
>  	}
> @@ -392,7 +388,6 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>  	    copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32)))
>  		err = -EFAULT;
>  
> -out:
>  	kfree(info.ctx);
>  	return err;
>  }
> @@ -1052,13 +1047,9 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
>  		return -EINVAL;
>  
>  	if (ctx_size_in) {
> -		ctx = kzalloc(ctx_size_in, GFP_USER);
> -		if (!ctx)
> -			return -ENOMEM;
> -		if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
> -			err = -EFAULT;
> -			goto out;
> -		}
> +		ctx = memdup_user(ctx_in, ctx_size_in);
> +		if (IS_ERR(ctx))
> +			return PTR_ERR(ctx);
>  	}
>  
>  	rcu_read_lock_trace();
> -- 
> 2.7.4
> 


