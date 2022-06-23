Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC4455769B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiFWJaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiFWJaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:30:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 343094756C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655976611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yi0ECMkNhZdo3ou3Qb26Wd4xWq35GWgeRWMvIk5Uuew=;
        b=Jk1rLChRfKvVfyWOPSZrTh8MgYVAPKu2iR0CoHHoVBa0tAK/qRPmO2B9jytMnsuv7c2kfr
        oc0fJ2IBdMoCqTtdiNhDR0u7iLq3VlLar/amzYsgmqddXff9LqIx79bjTyYgAfU56m7eu8
        WJil14fqFmEqJmLRWJFFE329FU6SsB0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-flfKPjefPSqxEEE0v-ncRw-1; Thu, 23 Jun 2022 05:30:08 -0400
X-MC-Unique: flfKPjefPSqxEEE0v-ncRw-1
Received: by mail-wr1-f70.google.com with SMTP id n7-20020adfc607000000b0021a37d8f93aso4532576wrg.21
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Yi0ECMkNhZdo3ou3Qb26Wd4xWq35GWgeRWMvIk5Uuew=;
        b=kN7DPfHlMvMOPO9XdX6O0HZZwCUF8taaFLtKRgEnmy5+TS2f9Y8bSAYBebx+YbGcIM
         4jpCI3SeH+kMKTb7TVjSueVI02Ev/Gll2G9q/NZRw7qptKRXn2APSPjRuiRb1i/b7kWt
         KaZUVvtXFYxu3ehidHo76uxrq6O9GK6mIv9hb6oQmTgqd2yixQoKDVLN543jw4ra1a+B
         XchG1cakmNHN6wy++M1QSofG0hYG022/pOxohuf/59cb4DmO+DXB52SwTr9n04qhM7/w
         dwu6dxrNpZlH5UbNAVSPQ6CR3KheH78gPmdOmP3616sOiQeRzkvh46o6EQMRixAJeYFK
         AhwQ==
X-Gm-Message-State: AJIora9a1DgW3y497xMSeGEyDMfsIpWuSb7ma7CvbjHbQhcCFwlsM0u+
        YBI/fcKdpnd9kDv+fXuHD4HIqr2lcu2DUR9I2/unjweWQJviRZ5CHZXRlCeiPTgyqxgbz30Dssu
        mduyERwT10cN/yUOo
X-Received: by 2002:adf:ed05:0:b0:21b:947c:c97b with SMTP id a5-20020adfed05000000b0021b947cc97bmr7079258wro.509.1655976606756;
        Thu, 23 Jun 2022 02:30:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5+b+rMsQ2CD3MI59GsQBq9eBzv2lsIUGK/dQnGLx3FklVb+gWr5zXQ0BlVvxGqA+CEibk6w==
X-Received: by 2002:adf:ed05:0:b0:21b:947c:c97b with SMTP id a5-20020adfed05000000b0021b947cc97bmr7079235wro.509.1655976606519;
        Thu, 23 Jun 2022 02:30:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id r127-20020a1c4485000000b0039c4ba160absm10051798wma.2.2022.06.23.02.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:30:05 -0700 (PDT)
Message-ID: <30eac5047e0e3b6edce260fb31d3f6527e142dee.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 11:30:04 +0200
In-Reply-To: <49f1e353c0a1e4f896cb255d77d08888d7b2e3fc.1655869357.git.duoming@zju.edu.cn>
References: <cover.1655869357.git.duoming@zju.edu.cn>
         <49f1e353c0a1e4f896cb255d77d08888d7b2e3fc.1655869357.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-22 at 12:01 +0800, Duoming Zhou wrote:
> When the link layer connection is broken, the rose->neighbour is
> set to null. But rose->neighbour could be used by rose_connection()
> and rose_release() later, because there is no synchronization among
> them. As a result, the null-ptr-deref bugs will happen.
> 
> One of the null-ptr-deref bugs is shown below:
> 
>     (thread 1)                  |        (thread 2)
>                                 |  rose_connect
> rose_kill_by_neigh              |    lock_sock(sk)
>   spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
>   rose->neighbour = NULL;//(1)  |
>                                 |    rose->neighbour->use++;//(2)
> 
> The rose->neighbour is set to null in position (1) and dereferenced
> in position (2).
> 
> The KASAN report triggered by POC is shown below:
> 
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> ...
> RIP: 0010:rose_connect+0x6c2/0xf30
> RSP: 0018:ffff88800ab47d60 EFLAGS: 00000206
> RAX: 0000000000000005 RBX: 000000000000002a RCX: 0000000000000000
> RDX: ffff88800ab38000 RSI: ffff88800ab47e48 RDI: ffff88800ab38309
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed1001567062
> R10: dfffe91001567063 R11: 1ffff11001567061 R12: 1ffff11000d17cd0
> R13: ffff8880068be680 R14: 0000000000000002 R15: 1ffff11000d17cd0
> ...
> Call Trace:
>   <TASK>
>   ? __local_bh_enable_ip+0x54/0x80
>   ? selinux_netlbl_socket_connect+0x26/0x30
>   ? rose_bind+0x5b0/0x5b0
>   __sys_connect+0x216/0x280
>   __x64_sys_connect+0x71/0x80
>   do_syscall_64+0x43/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This patch adds lock_sock() in rose_kill_by_neigh() in order to
> synchronize with rose_connect() and rose_release().
> 
> Meanwhile, this patch adds sock_hold() protected by rose_list_lock
> that could synchronize with rose_remove_socket() in order to mitigate
> UAF bug caused by lock_sock() we add.
> 
> What's more, there is no need using rose_neigh_list_lock to protect
> rose_kill_by_neigh(). Because we have already used rose_neigh_list_lock
> to protect the state change of rose_neigh in rose_link_failed(), which
> is well synchronized.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  net/rose/af_rose.c    | 5 +++++
>  net/rose/rose_route.c | 2 ++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index bf2d986a6bc..dece637e274 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -169,9 +169,14 @@ void rose_kill_by_neigh(struct rose_neigh *neigh)
>  		struct rose_sock *rose = rose_sk(s);
>  
>  		if (rose->neighbour == neigh) {
> +			sock_hold(s);
>  			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
>  			rose->neighbour->use--;
> +			spin_unlock_bh(&rose_list_lock);

You can't release the lock protecting the list traversal, then re-
acquire it and keep traversing using the same iterator. The list could
be modified in-between.

Instead you could build a local list containing the relevant sockets
(under the rose_list_lock protection), additionally acquiring a
reference to each of them

Then traverse such list outside the rose_list_lock, acquire the socket
lock on each of them, do the neigh clearing and release the reference.

Doing the above right is still fairly non trivial.

/P




