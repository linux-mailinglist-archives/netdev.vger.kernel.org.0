Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDFF6C89A5
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjCYA3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCYA3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:29:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DD1AD;
        Fri, 24 Mar 2023 17:28:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so6626057pjt.2;
        Fri, 24 Mar 2023 17:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679704128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+OJY+zSJTEbG+AuJjykC53+E1s0LzCafsUtUrzK3O/Y=;
        b=ZIqETiwHYCeFzJpsQdChujE4OTMgqGWZc55KzIxJ2BcDhSYGQMPiy2JCN5J8gDoU3W
         NhjzA+cKhG6JcsF2VqcQhXufOS97wdhqeY91wIqi24BJJiv/i4UTJaFLzCb7AJ+4znpr
         UDmD+EhI6ePI1NnQrHXt+hen+ThFhf02rmNo2f6rVOnSa2lxu4TW4LrRv4XIo0GySa3B
         XcPgxhKSbFwXYL4vaPtRCIXrobQCE1lRIdOTVsyMYA6zRGWoPMeabbMYME7muXufjPhI
         glPlyVG81xV4Enq+x4bP+WQavcFwNHwhkepPcSoRGkM9f/067IUEigs7wtrQab7DM9Fz
         CNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679704128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OJY+zSJTEbG+AuJjykC53+E1s0LzCafsUtUrzK3O/Y=;
        b=Kx4j0UvgYwBQgClYZftupCtTYd5Xc6drXh7hdKvb1BHs9bVVOIgWu3xPhf9+s7nO0/
         id4eF299c9u5Zu92sXTAUo2ELB+dbOD/ai7DAiM/m/oVvGgzgDaxP/jKrPMKcMWBqOQC
         Tcn1Rtmc3bmVACAVyD/t4X6UDf1HG37ZBkMXdhaQbFCNgzAxQTsXQsJ4d3LS8hbx+zgy
         rbaC95y71hMhXsX+BAD8za9YXNAk1LZSvGtmFRki3ZC2tNJEp+tLM3936oAiXAY0m4PJ
         skB/7tAMY0DLpb1cpsqVUnQfb6UPdgBSUC+tp4xGJLpftBu4j+Og2dKte8nkjgsJj7DU
         grNg==
X-Gm-Message-State: AAQBX9caMFX5l5K/REQyjBE1r1Ge5rUbSuMQQOZIvtcSnotkJMTFocrZ
        DR+uHQa7yDCmavogbn3mdzNAu6xzhCxMtQ==
X-Google-Smtp-Source: AKy350ZrHPNC9SOz6cEZTAj1pSiTqDkl0dFv2BqMWx7x8G+KNbE5ILINLToJgrFvAp3VLdXvonPyTA==
X-Received: by 2002:a17:902:d409:b0:1a1:a44f:70ed with SMTP id b9-20020a170902d40900b001a1a44f70edmr3726975ple.61.1679704128050;
        Fri, 24 Mar 2023 17:28:48 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902820800b0019a7ef5e9a8sm14813074pln.82.2023.03.24.17.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 17:28:47 -0700 (PDT)
Date:   Sat, 18 Mar 2023 00:15:35 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, avkrasnov@sberdevices.ru,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
Subject: Re: [PATCH net] vsock/loopback: use only sk_buff_head.lock to
 protect the packet queue
Message-ID: <ZBUCp4sSBURn5zRl@bullseye>
References: <20230324115450.11268-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324115450.11268-1-sgarzare@redhat.com>
X-Spam-Status: No, score=1.9 required=5.0 tests=DATE_IN_PAST_96_XX,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 12:54:50PM +0100, Stefano Garzarella wrote:
> pkt_list_lock was used before commit 71dc9ec9ac7d ("virtio/vsock:
> replace virtio_vsock_pkt with sk_buff") to protect the packet queue.
> After that commit we switched to sk_buff and we are using
> sk_buff_head.lock in almost every place to protect the packet queue
> except in vsock_loopback_work() when we call skb_queue_splice_init().
> 
> As reported by syzbot, this caused unlocked concurrent access to the
> packet queue between vsock_loopback_work() and
> vsock_loopback_cancel_pkt() since it is not holding pkt_list_lock.
> 
> With the introduction of sk_buff_head, pkt_list_lock is redundant and
> can cause confusion, so let's remove it and use sk_buff_head.lock
> everywhere to protect the packet queue access.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Cc: bobby.eshleman@bytedance.com
> Reported-and-tested-by: syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/vsock_loopback.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 671e03240fc5..89905c092645 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -15,7 +15,6 @@
>  struct vsock_loopback {
>  	struct workqueue_struct *workqueue;
>  
> -	spinlock_t pkt_list_lock; /* protects pkt_list */
>  	struct sk_buff_head pkt_queue;
>  	struct work_struct pkt_work;
>  };
> @@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
>  	struct vsock_loopback *vsock = &the_vsock_loopback;
>  	int len = skb->len;
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
>  	skb_queue_tail(&vsock->pkt_queue, skb);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
>  
>  	queue_work(vsock->workqueue, &vsock->pkt_work);
>  
> @@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)
>  
>  	skb_queue_head_init(&pkts);
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
> +	spin_lock_bh(&vsock->pkt_queue.lock);
>  	skb_queue_splice_init(&vsock->pkt_queue, &pkts);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
> +	spin_unlock_bh(&vsock->pkt_queue.lock);
>  
>  	while ((skb = __skb_dequeue(&pkts))) {
>  		virtio_transport_deliver_tap_pkt(skb);
> @@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
>  	if (!vsock->workqueue)
>  		return -ENOMEM;
>  
> -	spin_lock_init(&vsock->pkt_list_lock);
>  	skb_queue_head_init(&vsock->pkt_queue);
>  	INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
>  
> @@ -156,9 +152,7 @@ static void __exit vsock_loopback_exit(void)
>  
>  	flush_work(&vsock->pkt_work);
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
>  	virtio_vsock_skb_queue_purge(&vsock->pkt_queue);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
>  
>  	destroy_workqueue(vsock->workqueue);
>  }
> -- 
> 2.39.2
> 

Makes sense to me. Thanks for getting to this so fast.

Best,
Bobby

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
