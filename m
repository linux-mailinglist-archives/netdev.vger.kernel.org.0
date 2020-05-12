Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557561CEF16
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgELI2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgELI2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:28:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5314FC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 01:28:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u6so12585419ljl.6
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 01:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=95GbR0TC2RxBW+8LeWrRYGNf93ycRXGQPznoeVFPxjc=;
        b=YfkdN1kciz/KYl7ns9JAwxFgNKOP0wPqdPc0ksttDUXqoTzfw1QKp22yiiZ9wos4sM
         cD/T2xO2XyMpnqLje9FcDcKEbtfwPmaQNsZZ1XNzfiC7zSwqXRHe7okFEm9DQaXMw3Kn
         rIlgEHeUZQh54spRfnUN602nZsqVlZSkNlSDWTOgvsuzcz3Vu49JwfGBSJqhPbykgjhU
         w8LGUzhqT2fz7f5n6SjJGAhrdAos8uKkxaE/Ofqlt05zf5WFDQ/wIqWttnjZ2d+ZUD3E
         +ZgJxOUuAxhvEUW2qhIf41VgrWnKpEAVMtsgJzu03g5qJrihJhoDY3Z1iZTkfuCbTPEF
         qZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=95GbR0TC2RxBW+8LeWrRYGNf93ycRXGQPznoeVFPxjc=;
        b=grpcb7Xto7YbvkQ8I+hwgqACymBCi4GWGygN3NguM6SbKADgbN3bVpCB9qp8udUUUC
         6XlQztbMvLrVYJ1JGAbwgKso0EsQEbvWz6+00WRvRJ0M7q4MDuC7eG4XkDqCZ4OiZWYh
         w9+uNHiOg+ItGC9rFWjL9nxpZwAZ1V+WQ7zMMWzqe2qAuuMif93JeynoqwU/rJVkeDjg
         OMN5IrSNYPPbbgD6XWRS8Ly99j5tEGgZwFAj8BLoBh6htP2/G+0/aSF6D35WvQAbQF5Y
         VvyFCURf5skE0cdi0LhWQCdAExDl7aYJ6ifCnxgsAE5xukByG22I0jfeLNuyKefBd/ux
         YNeQ==
X-Gm-Message-State: AOAM530hs+At5q+P+XdtLiK+V7RXlcHfOSQ5aYYRSsxm+vMuPyeKMW+w
        QwWPI5wKeqpvh2zeXxs9ifChKJSZPqk=
X-Google-Smtp-Source: ABdhPJzP7yoMA2P0CSPKne8R1Adb7IieSl92dmH9QBd5oCS/wyRf/9ihDL58+wdT1kWj7l7HqUi5Hw==
X-Received: by 2002:a2e:b891:: with SMTP id r17mr13079793ljp.34.1589272094748;
        Tue, 12 May 2020 01:28:14 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:61b:c4fe:68d6:9937:777b:c884? ([2a00:1fa0:61b:c4fe:68d6:9937:777b:c884])
        by smtp.gmail.com with ESMTPSA id t16sm14599694lff.72.2020.05.12.01.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 01:28:14 -0700 (PDT)
Subject: Re: [PATCH 1/3] net: add a CMSG_USER_DATA macro
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511115913.1420836-1-hch@lst.de>
 <20200511115913.1420836-2-hch@lst.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <f754c4ac-db7d-6688-5582-2a5f476b0f08@cogentembedded.com>
Date:   Tue, 12 May 2020 11:28:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511115913.1420836-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11.05.2020 14:59, Christoph Hellwig wrote:

> Add a variant of CMSG_DATA that operates on user pointer to avoid
> sparse warnings about casting to/from user pointers.  Also fix up
> CMSG_DATA to rely on the gcc extension that allows void pointer
> arithmetics to cut down on the amount of casts.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[...]
> diff --git a/net/core/scm.c b/net/core/scm.c
> index dc6fed1f221c4..abfdc85a64c1b 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
[...]
> @@ -300,7 +300,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>   	if (fdnum < fdmax)
>   		fdmax = fdnum;
>   
> -	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
> +	for (i=0, cmfptr =(int __user *)CMSG_USER_DATA(cm); i<fdmax;

    Perhaps it's time to add missing spaces consistently, not just one that 
you added?

>   	     i++, cmfptr++)
>   	{
>   		struct socket *sock;

MBR, Sergei
