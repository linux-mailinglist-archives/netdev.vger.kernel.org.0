Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BFD672942
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjARU1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjARU1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:27:20 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CB74956F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:27:19 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id b127so23989iof.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIbSTlbsVtfHCswDmb/GGRU2T+/OgEIy4NIKEHpk9Cg=;
        b=Xk+LMsRWASFEGmkjk6gJ8Y/pjwgC7gQyaFhb+ifHkmFljFv+0SLTESArdVg89KGZsk
         2MiYZrKsD3QeOmFdTKVInDmVR7j0JwkMtMlCEnywB5sgcitLtgA/nrKOi6t+lIl7oh4K
         V7WAMfQmwL5Ce8OBOXxzbGQY/h4sUHPmnVnFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIbSTlbsVtfHCswDmb/GGRU2T+/OgEIy4NIKEHpk9Cg=;
        b=VhX1pI1Gq3WJ8egcVmqnngTPbuHVrspVcpcXAmWYwI+uEmGwW9S//NgbKty5pLFNcb
         WdTyvjPeag3YrueTzraBNUB+jOwAjsaprPJfxtMRQ/uNtosn+Vk0JT70oaUcyQQFkJFF
         0xuIUbq7rQmOVErsTZL8VSj5aVWjxoXs9qfcWEWN8vdOuP9J8r917KfkAH+xSHQXaOqi
         2VKsL/AS023B1eSKM3mC1pGHBmH5uFYjC2yQQKR7x2FnO4XUbH59clTX2Jj5qwJ3YEVX
         wMsrYAkVRAZV9RyRqlD9BhHx9E/bey03kxxTwhxODD1+JGOINjMoMJDz9SLzmh+Dnmg9
         v0Cg==
X-Gm-Message-State: AFqh2kr+KguwMM1Pb3+FrPBZEsDKofQdh3PS/hwIXAchHiiQGV9is+6I
        RPuzrF9svNxqPh8ujlrU/jIkLg==
X-Google-Smtp-Source: AMrXdXuTNbZ8I1C1Q0wR9x5vcVKc9ZaKVd1jRdWIv4SyQrykOX9KxQYJormNtGigAlLgx6JuFzC2xQ==
X-Received: by 2002:a6b:6909:0:b0:6df:e175:74c1 with SMTP id e9-20020a6b6909000000b006dfe17574c1mr5488835ioc.21.1674073639250;
        Wed, 18 Jan 2023 12:27:19 -0800 (PST)
Received: from [192.168.0.41] ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id x8-20020a0566380ca800b0039e28b92b51sm10201805jad.121.2023.01.18.12.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 12:27:18 -0800 (PST)
Message-ID: <8cd33923-a21d-397c-e46b-2a068c287b03@cloudflare.com>
Date:   Wed, 18 Jan 2023 14:27:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
Content-Language: en-US
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 1/18/23 11:07 AM, Eric Dumazet wrote:
>>
>> Thanks,
>> Fred
> 
> Thanks for the report
> 
> I guess this part has been missed in commit 0a375c822497ed6a
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> sock *sk, struct dst_entry *dst,
>          th->window = htons(min(req->rsk_rcv_wnd, 65535U));
>          tcp_options_write(th, NULL, &opts);
>          th->doff = (tcp_header_size >> 2);
> -       __TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> +       TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> 
>   #ifdef CONFIG_TCP_MD5SIG
>          /* Okay, we have all we need - do the md5 hash if needed */

Thanks for the fast response!

I applied this change to our Kernel and started the rollout process. 
I'll report back with any findings once we have sufficient data.
