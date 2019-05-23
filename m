Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A718281F9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfEWP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:58:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46981 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfEWP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:58:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id o11so3169026pgm.13
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 08:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MxXnx92be2nvF7xZ7bbdR68LKvIJOLf//2lMxqyf48g=;
        b=hvpc3gpukMGUq7Ov7toOO2z72FB9I2W7YDgyHfAiOKYca1iuBFnk5QPEsd9GHXq274
         sJJUHpt/T0Gg8VyN3OW4jH0sc1nwtlkbp/kSq5cP2H+juRnkiJgkCpSo5iDB/hjagTiD
         C6eY5g1OnjrWQeYLm073BWKjsNIHqu4QxqedH6QNni9MKpCZIp1EP5+1S6BET0sYb1U6
         lJDU+ZBrS/NDJaKGXf2z1aifOz/ELvG4x2ixvreJlJDJs+4C+bCzJlSswgIiGRv0LRbf
         N6zCo/9Fe6iaTLXNbWp/k4ogW5SWZhX8GrezbmCOuwR9J4TbjoQeIFtzn0EtDBIoyatt
         ZUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MxXnx92be2nvF7xZ7bbdR68LKvIJOLf//2lMxqyf48g=;
        b=MHt56yhCPIVqMd7wB62B6HGZmXlgCUwjN8QRq15l5olvOtc3V5dcQisZhOSllvlzqd
         eebDdPOHe8SbyOnKokisSwmm0SllshSDw3DgJmYWL3uEAfTsLJ/ku3I0rXRlGGpxa0tn
         QIxtlnjc7dyU3tLhXLMOkHs0+NvnI47U8Qw3bPYEKAzdAH9kOQzka3RkiIB5/po9eCH3
         A2QlH2el5HrymGsPQQXId4e+Qt6Arxfjoihk24Ohww7fM9JKOxtkQK1YLx7YZJjASKYc
         nEKNyXqH0lfNXn7vmLM/+no8oKj1OAJAFEOB/kZK+NJotnNlB20qknMeojt67IWCaxfg
         O2TA==
X-Gm-Message-State: APjAAAXYBOvL2mxYFdDMflltX6yzHN2B7NVD3nPRGVqzUS6nuMFsjfts
        wIlsIm2QWrK+1vOVZ3Vlt680/SzZJa4=
X-Google-Smtp-Source: APXvYqxKT5iJ2j9LMwVeDWUW8iR9cwvkqzhrpKiKd/iYF3iW8UnkDLJzt5wn59B0vm++qVruStUCCQ==
X-Received: by 2002:a62:e205:: with SMTP id a5mr67429492pfi.40.1558627115892;
        Thu, 23 May 2019 08:58:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a3sm30701760pgl.74.2019.05.23.08.58.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 08:58:35 -0700 (PDT)
Date:   Thu, 23 May 2019 08:58:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Message-ID: <5ce6c32418618_64ba2ad730e1a5b44@john-XPS-13-9360.notmuch>
In-Reply-To: <87v9y2zqpz.fsf@cloudflare.com>
References: <20190211090949.18560-1-jakub@cloudflare.com>
 <5439765e-1288-c379-0ead-75597092a404@iogearbox.net>
 <871s423i6d.fsf@cloudflare.com>
 <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch>
 <87v9y2zqpz.fsf@cloudflare.com>
Subject: Re: [PATCH net] sk_msg: Keep reference on socket file while psock
 lives
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]

> 
> Thanks for taking a look at it. Setting MSG_DONTWAIT works great for
> me. No more crashes in sk_stream_wait_memory. I've tested it on top of
> current bpf-next (f49aa1de9836). Here's my:
> 
>   Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> The actual I've tested is below, for completeness.
> 
> BTW. I've ran into another crash which I haven't seen before while
> testing sockmap-echo, but it looks unrelated:
> 
>   https://lore.kernel.org/netdev/20190522100142.28925-1-jakub@cloudflare.com/
> 
> -Jakub
> 
> --- 8< ---
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e89be6282693..4a7c656b195b 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
>                 kv.iov_base = skb->data + offset;
>                 kv.iov_len = slen;
>                 memset(&msg, 0, sizeof(msg));
> +               msg.msg_flags = MSG_DONTWAIT;
> 
>                 ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
>                 if (ret <= 0)

I went ahead and submitted this feel free to add your signed-off-by.

Thanks,
John
