Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCCC579FEE
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbiGSNqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbiGSNqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 532C2106AC0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GpFb8vkFvojqhTGDZMr57afoE9WFfoScp9OlFzV0WwU=;
        b=hec0C2Iz2alWvQfu8C+LRxs9zsGkUilc+xlrN7TSYmZmsFyTtAj7B/jkByf4iq70v8DdBK
        FLz368fzZhGmLN5mwPkDCSekKSXQ3G7Y4d6q9PYEw+cPhv7MV4XYTp0LQshOVPeWx26FDS
        T1jCPlZiotp6oByNX/MjF7t+NcxHuS8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-YJ1Yc8tWNzGLskZGere3HA-1; Tue, 19 Jul 2022 08:59:06 -0400
X-MC-Unique: YJ1Yc8tWNzGLskZGere3HA-1
Received: by mail-qk1-f197.google.com with SMTP id m8-20020a05620a24c800b006b5d8eb23efso7879405qkn.10
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GpFb8vkFvojqhTGDZMr57afoE9WFfoScp9OlFzV0WwU=;
        b=MkDfkEm3clCzRMVXNmmhaYECriBe2D7Ksl6i7PTUKd6//oKL6Vt8CsXE9wnl2x1lSY
         8w+JnWQlG9jNgq5PwH9lrPhX+Vugh3hQdutMMnUKJyRPSnKdUzygl29Nkr4F2E0k0GrU
         KXffK3KiA7ZiwahXe3PH8EyWUJcWZkCYVRZIvqg0CnJcrMMvLz2AdQQ2TMd8n8esZfft
         HemF2j4cfXcOwGzIqFeUj0n2iJBw7DBheXw+MWvU7yCCnAP5Uj4Fkr0LS9F2Nb+d/u/C
         HLmOmtRbXKjDWPbtjxXRCxOtiCm99Zy4K5YgyKShGXR2Z5CwAE+l47lYUlnd4f1DpM97
         qpjA==
X-Gm-Message-State: AJIora9bzUzM5OCijNcd/jELFwEQQYpjJwIPktqCRe2/AcKx11uA5u6v
        f3urBlD1zzhX5fIQmNHqlBQPD+fLYQZ7g9KHvaAIEYslaCb18T5JfSpurxQGTVMdsma9GOMI5gn
        oWuA56chJ0krgwpgM
X-Received: by 2002:a37:bb06:0:b0:6af:1396:733a with SMTP id l6-20020a37bb06000000b006af1396733amr20076306qkf.19.1658235545578;
        Tue, 19 Jul 2022 05:59:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v3rTh6rpiRFqOJRQK0ZLJtgg3flVdhc61hiFQaT3lCYarTqS5U4ciXv6GiDuKhdb9qoBSiNg==
X-Received: by 2002:a37:bb06:0:b0:6af:1396:733a with SMTP id l6-20020a37bb06000000b006af1396733amr20076290qkf.19.1658235545356;
        Tue, 19 Jul 2022 05:59:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id bk8-20020a05620a1a0800b006b5fe4c333fsm1422065qkb.85.2022.07.19.05.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:59:04 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:58:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Message-ID: <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:12:52AM +0000, Arseniy Krasnov wrote:
>Hello,
>
>during my experiments with zerocopy receive, i found, that in some
>cases, poll() implementation violates POSIX: when socket has non-
>default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>POLLRDNORM bits in 'revents' even number of bytes available to read
>on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>POLLIN flag and then tries to read data(for example using  'read()'
>call), but read call will be blocked, because  SO_RCVLOWAT logic is
>supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>requires that:
>
>"POLLIN     Data other than high-priority data may be read without
>            blocking.
> POLLRDNORM Normal data may be read without blocking."
>
>See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>
>So, we have, that poll() syscall returns POLLIN, but read call will
>be blocked.
>
>Also in man page socket(7) i found that:
>
>"Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>socket as readable only if at least SO_RCVLOWAT bytes are available."
>
>I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>this case for TCP socket, it works as POSIX required.

I tried to look at the code and it seems that only TCP complies with it 
or am I wrong?

>
>I've added some fixes to af_vsock.c and virtio_transport_common.c,
>test is also implemented.
>
>What do You think guys?

Nice, thanks for fixing this and for the test!

I left some comments, but I think the series is fine if we will support 
it in all transports.

I'd just like to understand if it's just TCP complying with it or I'm 
missing some check included in the socket layer that we could reuse.

@David, @Jakub, @Paolo, any advice?

Thanks,
Stefano

