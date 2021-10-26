Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEDC43B0E4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhJZLTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:19:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233778AbhJZLTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635247013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gM1+OP3lV+p8AGHiQhCemg7WeEVqw72uF3wN2Z65I9w=;
        b=ZEGEUO2EJnU4y0dtk8jRtYP+tTzUd/FS6AdBisnRV2YDP47vQu2EBJpGsSGi0U/l6l/Wtd
        9qH2l/TX4CE/kO2EKgBqtKP528c2SxD5ZdLoMuoITKZybP35D9tparb4+UByjyugn65ttX
        8JT1hzKcSAICO+d5U2WT0RLPZOHrE6g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-0xDj-mZTOJixAW0YASWRyQ-1; Tue, 26 Oct 2021 07:16:51 -0400
X-MC-Unique: 0xDj-mZTOJixAW0YASWRyQ-1
Received: by mail-ed1-f71.google.com with SMTP id w7-20020a056402268700b003dd46823a18so6842711edd.18
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 04:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gM1+OP3lV+p8AGHiQhCemg7WeEVqw72uF3wN2Z65I9w=;
        b=InP7ygxXp1oPzR8tSCVXF7IQoI9dCQkZPXbhG9kfZlkPJb+hZWVQk6SZbS0BIIYLBy
         2WFBZ6R9ttrn9AMWutsh3sOO5j3MVQRB9OIV26+hTm698E6hhXYQO0zMeGrvmLNArry9
         naPM2/gRcsPiozdCP7Bw7RsaxEE51v9X+ZCigPsk4Pz3tvlFQASwVkgswtASdFOcZ2rx
         xhyadrUsFj80DnkblNBHQ1WucA+GZzHpSpw3h0Zg5enWP0vn1VH7wetavCi7hUPHcBu+
         qtXDqbtX7zvjSiSh40wRDNg8djsbmUjtDZAd0xvrfW1FDzRzZoSodnNz6QfTJTfnHblw
         N20Q==
X-Gm-Message-State: AOAM532HTM/QqRIZAjsHuD3aIfWd9FOaYQmeyvrJbIgn/zVD/kqdJ9gz
        7wGDjCC8JRp2Ys3mtnNjwnX/4oy7FtRq8KTPIa5ES7LF4Bn2J5Eb442hrMQzCL4Th8vuNo/SxjB
        jn4vDkiMrcCxGpFIb
X-Received: by 2002:aa7:cb0a:: with SMTP id s10mr34375700edt.289.1635247010567;
        Tue, 26 Oct 2021 04:16:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKEZT9K3ILhygPXLegfKvqxWNXZZhC21MNCRdKOmRxl77I0G5JRyyNWH8XVelOeM6npj13dQ==
X-Received: by 2002:aa7:cb0a:: with SMTP id s10mr34375677edt.289.1635247010362;
        Tue, 26 Oct 2021 04:16:50 -0700 (PDT)
Received: from steredhat (host-79-30-88-77.retail.telecomitalia.it. [79.30.88.77])
        by smtp.gmail.com with ESMTPSA id ca4sm8979329ejb.1.2021.10.26.04.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 04:16:50 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:16:47 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH 03/10] vsock: owner field is specific to VMCI
Message-ID: <CAGxU2F4n7arHPJ3SpbpJzk1qoT1rQ57Ki3ZjeHquew+_SpRd_A@mail.gmail.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
 <20211021123714.1125384-4-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021123714.1125384-4-marcandre.lureau@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCing Jorgen.

On Thu, Oct 21, 2021 at 04:37:07PM +0400, Marc-André Lureau wrote:
>This field isn't used by other transports.

If the field is used only in the VMCI transport, maybe it's better to 
move the field and the code in that transport.

Thanks,
Stefano

>
>Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
>---
> include/net/af_vsock.h   | 2 ++
> net/vmw_vsock/af_vsock.c | 6 ++++++
> 2 files changed, 8 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index ab207677e0a8..e626d9484bc5 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -41,7 +41,9 @@ struct vsock_sock {
>                                        * cached peer?
>                                        */
>       u32 cached_peer;  /* Context ID of last dgram destination check. */
>+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
>       const struct cred *owner;
>+#endif
>       /* Rest are SOCK_STREAM only. */
>       long connect_timeout;
>       /* Listening socket that this came from. */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index e2c0cfb334d2..1925682a942a 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -761,7 +761,9 @@ static struct sock *__vsock_create(struct net *net,
>       psk = parent ? vsock_sk(parent) : NULL;
>       if (parent) {
>               vsk->trusted = psk->trusted;
>+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
>               vsk->owner = get_cred(psk->owner);
>+#endif
>               vsk->connect_timeout = psk->connect_timeout;
>               vsk->buffer_size = psk->buffer_size;
>               vsk->buffer_min_size = psk->buffer_min_size;
>@@ -769,7 +771,9 @@ static struct sock *__vsock_create(struct net *net,
>               security_sk_clone(parent, sk);
>       } else {
>               vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
>+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
>               vsk->owner = get_current_cred();
>+#endif
>               vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
>               vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
>               vsk->buffer_min_size = VSOCK_DEFAULT_BUFFER_MIN_SIZE;
>@@ -833,7 +837,9 @@ static void vsock_sk_destruct(struct sock *sk)
>       vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
>       vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
>
>+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
>       put_cred(vsk->owner);
>+#endif
> }
>
> static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>--
>2.33.0.721.g106298f7f9
>

