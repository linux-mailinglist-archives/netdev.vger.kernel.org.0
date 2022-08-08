Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84CB58C707
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242270AbiHHK6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiHHK6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:58:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6003913D0C
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659956325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5BkF9VQ4oVZ/Nt6vln0zfXoLspYvmMIFVYA6ooCx7l8=;
        b=EmB0G5UdFsDbQJstURjWdEYKxok3UmMXubA+FLe5WUEem6sleSd/uYkSo91DZ9VKeTj68C
        rguu6NG6Zhxamp9PiDRhgO8S7whw8BDsFAlywKak/Mso+Fq4pLBzk7x8C1hPJqz87+bAgm
        usujH+xE+5c2RS8a1Q1sCQXNm2QUVYU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-Rv17qjTUOPS7XlRxu9byrw-1; Mon, 08 Aug 2022 06:58:44 -0400
X-MC-Unique: Rv17qjTUOPS7XlRxu9byrw-1
Received: by mail-qt1-f197.google.com with SMTP id i19-20020ac85e53000000b00342f05b902cso3416882qtx.7
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5BkF9VQ4oVZ/Nt6vln0zfXoLspYvmMIFVYA6ooCx7l8=;
        b=qa7K7ubQ8xsQHOjmYZgj+TvTY4m7R70ABXiJ43FeX7/6UyYYoU/DA34tP0bqVNO81w
         VSdRekIWEGQEr/9Febnu/2aQSp6ePqP+hPQiH1Q1AEWI8XPBvxLd4OsdyV1a4SZuURyG
         479ibIgUrWIxodQk8Ymc6iXEHQ4sD2o9pmRsg7h4DiRW8v7qRUsuXJolyylkPB/Tc2jZ
         xTqNJUJNNbVTKTAvhACRas14zKKC0O+I6FVTs2CSBvYAA+GJtDPjDSuJvq61F9uFfdXx
         BZnptz524BZedgXQOuAWn7zRfGOdbXsQoO39u95a0Pz16qoaGR2EgCu3RmHON9a/h/6m
         KrlA==
X-Gm-Message-State: ACgBeo1as3Prz17gQmCjSCazh/ClJSpyEJSiNkud28PGBTk0p44TWS1c
        5VuHxTxvnWiQ73Wb9HfaDeu36NnLV3EVpJ/0mJzztkicQUMG8aASJFmNLVKekuSHVrSBRJZRE1R
        s1WkaMM2h2VeQ6Roe
X-Received: by 2002:ac8:5f88:0:b0:31e:f6dd:8f13 with SMTP id j8-20020ac85f88000000b0031ef6dd8f13mr15458706qta.186.1659956323685;
        Mon, 08 Aug 2022 03:58:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5BsuHRIUq6wXNolDgQxk5mQgfsZOfzYCRJPeNXwjqfHLEGI2rLwNjrLc7Z9hUqvybFoBiEUw==
X-Received: by 2002:ac8:5f88:0:b0:31e:f6dd:8f13 with SMTP id j8-20020ac85f88000000b0031ef6dd8f13mr15458701qta.186.1659956323477;
        Mon, 08 Aug 2022 03:58:43 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id e13-20020ac8490d000000b00342f80223adsm2359896qtq.89.2022.08.08.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:58:42 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:58:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 7/9] virtio/vsock: check SO_RCVLOWAT before wake
 up reader
Message-ID: <20220808105829.fwenw7tuda4rdxob@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <e08064c5-fd4a-7595-3138-67aa2f46c955@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e08064c5-fd4a-7595-3138-67aa2f46c955@sberdevices.ru>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 02:03:58PM +0000, Arseniy Krasnov wrote:
>This adds extra condition to wake up data reader: do it only when number
>of readable bytes >= SO_RCVLOWAT. Otherwise, there is no sense to kick
>user,because it will wait until SO_RCVLOWAT bytes will be dequeued.

Maybe we can mention that these are done in vsock_data_ready().

Anyway, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 8f6356ebcdd1..35863132f4f1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1081,7 +1081,7 @@ virtio_transport_recv_connected(struct sock *sk,
> 	switch (le16_to_cpu(pkt->hdr.op)) {
> 	case VIRTIO_VSOCK_OP_RW:
> 		virtio_transport_recv_enqueue(vsk, pkt);
>-		sk->sk_data_ready(sk);
>+		vsock_data_ready(sk);
> 		return err;
> 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
> 		virtio_transport_send_credit_update(vsk);
>-- 
>2.25.1

