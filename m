Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB741639C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhIWQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhIWQvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:51:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB47C061574;
        Thu, 23 Sep 2021 09:49:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a7so4418917plm.1;
        Thu, 23 Sep 2021 09:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MhAQCN3MCef3eJJtF6/ulwUDJ61UOPaUB864XhY6hE=;
        b=E6h0eAjLzztag0xmHm4rwsMjS/0omLXnEHKaP64ien169x1qhb7wHjy82xy4RWt16t
         O4WtxrwNbsU5rMfw9Q/jG/UmihU093yEOGj62l/q088u7b0g6088/PxGzQZJcakCjLix
         4TjuXiIrm12uHELiTguio2JjaXIc545CmfcTj59FmmEoWMH4urLSuUET2iP3wi5LPWdR
         DnX04XoZSVLrY3O9NRvuODOdRxbhVUDkqyCJ7iadBDkCYdUAcrz5dUTDfRYyJif5AxQl
         yFeA6po4Zh1zzrFxLMGLbutyKAz3L/VoBTlPW6p4NRH3nmm1OTfYPtwiJ4a/GYFIgrYk
         r6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MhAQCN3MCef3eJJtF6/ulwUDJ61UOPaUB864XhY6hE=;
        b=rbSu3fB2NEhA63Mf1r4eFJeme3rMYsgJTrkjcfjS1ABW8zONBQeOTeJ0qpBFVMUd1R
         GW5T6I4Z38M+3S1EbNljkxaN5K4saQkezZ4qh7NUWmY7DhX063/R5mqGZKtkAHFV2e+5
         hTzsSP5KkP6PfMXmnTlSw7QAQk3fmS22QWuF8hKnEV8mQYQh/fTk93yehPPUbCyajxyx
         wYJ98zy89o2Mnnfv5uhEDnY4IIXBklSwi/pezaX5ftN2OYVmcC4wcHNU6C2nP1lCW5d6
         INeujBw5Rp7LHgllAVTckYMvvTKed+C3niVgGOxqBhXKQI1iTYQgCCoLh83Z4BTYdWl+
         g3yQ==
X-Gm-Message-State: AOAM530gydtwZ4s6FCVsp131vfoV5ajYJT4ce14Inqo/Me2N5sc9kHFp
        eqeksvzEJSBLDJ3w2wMgJayhTuoa6d4=
X-Google-Smtp-Source: ABdhPJyIYDJ/7xNtXUZjb4UZO+bXii4P0gJq7epfVHL852Suf8ajpLowrePBQu4B2z+0PmnrN+fbUw==
X-Received: by 2002:a17:902:6848:b0:13a:4ffd:202e with SMTP id f8-20020a170902684800b0013a4ffd202emr4566154pln.79.1632415791253;
        Thu, 23 Sep 2021 09:49:51 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 9sm10017046pjs.14.2021.09.23.09.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:49:50 -0700 (PDT)
Subject: Re: [PATCH net-next] net: socket: integrate sockfd_lookup() and
 sockfd_lookup_light()
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210922063106.4272-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b6263d35-0d31-e4a8-a955-494ce2b36ad6@gmail.com>
Date:   Thu, 23 Sep 2021 09:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922063106.4272-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/21 11:31 PM, Yajun Deng wrote:
> As commit 6cb153cab92a("[NET]: use fget_light() in net/socket.c") said,
> sockfd_lookup_light() is lower load than sockfd_lookup(). So we can
> remove sockfd_lookup() but keep the name. As the same time, move flags
> to sockfd_put().

???

> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/linux/net.h |   8 +++-
>  net/socket.c        | 101 +++++++++++++++++---------------------------
>  2 files changed, 46 insertions(+), 63 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index ba736b457a06..63a179d4f760 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -238,8 +238,14 @@ int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
>  struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
>  struct socket *sockfd_lookup(int fd, int *err);
>  struct socket *sock_from_file(struct file *file);
> -#define		     sockfd_put(sock) fput(sock->file)
>  int net_ratelimit(void);
> +#define		     sockfd_put(sock)             \
> +do {                                              \
> +	struct fd *fd = (struct fd *)&sock->file; \
> +						  \
> +	if (fd->flags & FDPUT_FPUT)               \
> +		fput(sock->file);                 \
> +} while (0)
>  

Really ?

I wonder how was this tested ?

We can not store FDPUT_FPUT in the sock itself, for obvious reasons.
Each thread needs to keep this information private.

