Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFDD54464D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbiFIIoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242433AbiFIInA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC2C0C17
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654764068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6hc+0uRrIyBBUIt2+YgJFXzhqP3fUJnP5Yt67N6e6M=;
        b=S2tn9DEdXSFudwdQvDVNI/R+fMiFDJTmt79ucUK5x/d7RXlyDYw3EJAIIY1ZQMnulWjrTG
        1s85Oy4yL72ghEimJhlvRe+JUwWrECBA2eYnex0BakONUpoI4m3170R7IQMVDHg5fofjIc
        4OFOZF175qI4axO9MlN1gclXMvYk/AQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-V_4WVFsgNE2fXIs_VyiHzQ-1; Thu, 09 Jun 2022 04:41:07 -0400
X-MC-Unique: V_4WVFsgNE2fXIs_VyiHzQ-1
Received: by mail-qv1-f69.google.com with SMTP id ke5-20020a056214300500b00461fc78b983so14526904qvb.17
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 01:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=J6hc+0uRrIyBBUIt2+YgJFXzhqP3fUJnP5Yt67N6e6M=;
        b=e06U5KuxJYh50tAlr/V+MLvnhtKF04E/acg3hI/LVMuOU7GWyHfl9dCWVdIHJQXvRB
         kW7qny7hqzf5vH1ElZiFakRUWHahEGGkoNV/qv4Eg1Qr7vutjD1FjyEG+aTv0+NKv9My
         wXvOGqffiUAgTIn+e16DAwZFtcSslMFREh3S8BCPSukGLSEloIpFz8xOhq6r+cpfkLdA
         whFYZ/P2zJwnEGd6h/mYkqqA4G6S0Nyye4jC+anoaCiVYTYAnKr51oqwrRfzTcfWxb+c
         y99X3oTEo5/cLq9SNsAD5KvYRXzoYTmYMDI2/V6SSYSsK3QkgLJrqfZj9UOvptQozm+D
         OWlg==
X-Gm-Message-State: AOAM532HAft0acsUX158JNVd0DgpAEHigBlKqkvhSXH6kle3rRVF8PUW
        yG2Fgyu2pJ0vRVtddxEtJHrAbr8CNTj75xUKgVJ5qg9hwLxykXAtqfKxsMVwddVHEZkPLyJiD6/
        jXv71dFBEEOHbDLLS
X-Received: by 2002:a05:622a:1a21:b0:2f1:f29e:40a with SMTP id f33-20020a05622a1a2100b002f1f29e040amr29940292qtb.235.1654764067092;
        Thu, 09 Jun 2022 01:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFbSDIRjUzi5na5uVNt0lbiM9L3H/7eIiZKHIhwyuet4AUBQGYalT4HlYt8flSM9MKu4kpRg==
X-Received: by 2002:a05:622a:1a21:b0:2f1:f29e:40a with SMTP id f33-20020a05622a1a2100b002f1f29e040amr29940281qtb.235.1654764066804;
        Thu, 09 Jun 2022 01:41:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id m16-20020a05620a291000b006a6bb044740sm10557147qkp.66.2022.06.09.01.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:41:06 -0700 (PDT)
Message-ID: <22175690a4e89a78abcb8244dfd0bdd0005267a5.camel@redhat.com>
Subject: Re: [PATCH v3] net: ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, thomas@osterried.de
Date:   Thu, 09 Jun 2022 10:41:02 +0200
In-Reply-To: <20220608012923.17505-1-duoming@zju.edu.cn>
References: <20220608012923.17505-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-08 at 09:29 +0800, Duoming Zhou wrote:
> The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
> and block until it receives a packet from the remote. If the client
> doesn`t connect to server and calls read() directly, it will not
> receive any packets forever. As a result, the deadlock will happen.
> 
> The fail log caused by deadlock is shown below:
> 
> [  369.606973] INFO: task ax25_deadlock:157 blocked for more than 245 seconds.
> [  369.608919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.613058] Call Trace:
> [  369.613315]  <TASK>
> [  369.614072]  __schedule+0x2f9/0xb20
> [  369.615029]  schedule+0x49/0xb0
> [  369.615734]  __lock_sock+0x92/0x100
> [  369.616763]  ? destroy_sched_domains_rcu+0x20/0x20
> [  369.617941]  lock_sock_nested+0x6e/0x70
> [  369.618809]  ax25_bind+0xaa/0x210
> [  369.619736]  __sys_bind+0xca/0xf0
> [  369.620039]  ? do_futex+0xae/0x1b0
> [  369.620387]  ? __x64_sys_futex+0x7c/0x1c0
> [  369.620601]  ? fpregs_assert_state_consistent+0x19/0x40
> [  369.620613]  __x64_sys_bind+0x11/0x20
> [  369.621791]  do_syscall_64+0x3b/0x90
> [  369.622423]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  369.623319] RIP: 0033:0x7f43c8aa8af7
> [  369.624301] RSP: 002b:00007f43c8197ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> [  369.625756] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f43c8aa8af7
> [  369.626724] RDX: 0000000000000010 RSI: 000055768e2021d0 RDI: 0000000000000005
> [  369.628569] RBP: 00007f43c8197f00 R08: 0000000000000011 R09: 00007f43c8198700
> [  369.630208] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff845e6afe
> [  369.632240] R13: 00007fff845e6aff R14: 00007f43c8197fc0 R15: 00007f43c8198700
> 
> This patch moves the skb_recv_datagram() before lock_sock() in order that
> other functions that need lock_sock could be executed. What`s more, we
> add skb_free_datagram() before goto out in order to mitigate memory leak.
> 
> Suggested-by: Thomas Osterried <thomas@osterried.de>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Reported-by: Thomas Habets <thomas@@habets.se>
> ---
> Changes in v3:
>   - Add skb_free_datagram() before goto out in order to mitigate memory leak.
> 
>  net/ax25/af_ax25.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 95393bb2760..62aa5993093 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1665,6 +1665,11 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  	int copied;
>  	int err = 0;
>  
> +	/* Now we can treat all alike */
> +	skb = skb_recv_datagram(sk, flags, &err);
> +	if (!skb)
> +		goto done;
> +

Note that this causes a behavior change: before this patch, calling
recvmsg() on unconnected seqpacket sockets returned immediatelly with
an error (due to the the check below), now it blocks. 

The change may confuse (== break) user-space applications. I think it
would be better replacing skb_recv_datagram with an open-coded variant
of it releasing the socket lock before the
__skb_wait_for_more_packets() call and re-acquiring it after such call.
Somewhat alike __unix_dgram_recvmsg().

In any case this lacks a 'Fixes' pointing to the commit introducing the
issue addressed here.

Thanks,

Paolo

