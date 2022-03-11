Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D04D6ABB
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCKWq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiCKWqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:46:45 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C662213B1;
        Fri, 11 Mar 2022 14:21:56 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id s8so9010121pfk.12;
        Fri, 11 Mar 2022 14:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LmW5vUK9KoRLxo/PSGb5rbV+ARklvHlsTha23hQR9mw=;
        b=KBFsvFgNVvZ+1ywMkytegzF6la0bukQWFV5x89J3kZhsqJZxFBqL0L08qW+/KnGbgq
         6mATpGXcQVYg9aB0ZodzSUPIQrQFF/6pTuV1C73gCAY9kKxcddjg3p3Nm3Ur/s3ferwF
         ZWh//SycJtJjytkHlj0AjKad+U8JNLxb1I7g6qEXQ+J52tPLQhLeUxyLX3ncuh/6cXHh
         3Pxlv2cwVaPJvta9wFeOWfxxrWmexlk+eStnlQR/zjGcCXD+QYi7zNhIy8J1l1/1TK95
         Yu4oaGuzq6qN/gOcxz7wSmuROM9X0c1Ioob15cLHH5sONS+q/j6a1r9WRjAiT3ul59KK
         gJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LmW5vUK9KoRLxo/PSGb5rbV+ARklvHlsTha23hQR9mw=;
        b=jywrrvjHuVh4PCuEyY5zsyjoZIzjiemD9SSJcuhnDRlgfyHo1BIkqF8/48Id32Sp2J
         rd+FEz9ZK2DujtrJhXIKnI/KEoz4pEqyBH2C0J4pWsyhXuTpE9Qz64Q4le1eQ3qjHxp9
         FjJm7XY1PNxWiuh3dNfkMlw043PDOdIbY76xaXrkdhK3owTjoOYXTyoblm3bXNQpNCIH
         +faH+LRLJYzdohL+gB0TAQ9OOzTThlj7OCvi6Kr6kPWPBeNG7VQjicdy1mJ0bDOYfmcf
         buUDncuupzhoXhg6ZNgk/ISqNeqrkMt6zqyTjnopPkiqHqa8inp3uDpNZbzoVmXi7TSt
         nDIg==
X-Gm-Message-State: AOAM5337BJvA8akUuju0GrX1BquMl8LbYSemhlM7x9tg3k299DzwyBDe
        8m/ICCNq34IEkJM363HqBOqtpdkCbGJ4VQ==
X-Google-Smtp-Source: ABdhPJwY46nvb/RvNPd6oa4/pmc9J3ZRlYiPiAzxIuOoQ2ZWNwZLtgWeajQ/W2MBKSGZJXbfMJnEeg==
X-Received: by 2002:a05:6e02:188d:b0:2c6:70cd:2d66 with SMTP id o13-20020a056e02188d00b002c670cd2d66mr9666327ilu.36.1647035510364;
        Fri, 11 Mar 2022 13:51:50 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id q9-20020a5edb09000000b00645c7a00cbbsm4590572iop.20.2022.03.11.13.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 13:51:50 -0800 (PST)
Date:   Fri, 11 Mar 2022 13:51:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, bpf@vger.kernel.org
Cc:     edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Message-ID: <622bc46dafb12_8327a2081f@john.notmuch>
In-Reply-To: <20220304081145.2037182-5-wangyufen@huawei.com>
References: <20220304081145.2037182-1-wangyufen@huawei.com>
 <20220304081145.2037182-5-wangyufen@huawei.com>
Subject: RE: [PATCH bpf-next v3 4/4] bpf, sockmap: Fix double uncharge the mem
 of sk_msg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen wrote:
> If tcp_bpf_sendmsg is running during a tear down operation, psock may be
> freed.
> 
> tcp_bpf_sendmsg()
>  tcp_bpf_send_verdict()
>   sk_msg_return()
>   tcp_bpf_sendmsg_redir()
>    unlikely(!psock))
>      sk_msg_free()
> 
> The mem of msg has been uncharged in tcp_bpf_send_verdict() by
> sk_msg_return(), and would be uncharged by sk_msg_free() again. When psock
> is null, we can simply returning an error code, this would then trigger
> the sk_msg_free_nocharge in the error path of __SK_REDIRECT and would have
> the side effect of throwing an error up to user space. This would be a
> slight change in behavior from user side but would look the same as an
> error if the redirect on the socket threw an error.
> 
> This issue can cause the following info:
> WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
> Call Trace:
>  <TASK>
>  __sk_destruct+0x24/0x1f0
>  sk_psock_destroy+0x19b/0x1c0
>  process_one_work+0x1b3/0x3c0
>  worker_thread+0x30/0x350
>  ? process_one_work+0x3c0/0x3c0
>  kthread+0xe6/0x110
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x22/0x30
>  </TASK>
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/ipv4/tcp_bpf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Thanks John!

Acked-by: John Fastabend <john.fastabend@gmail.com>
