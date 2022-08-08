Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A77658C479
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbiHHH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiHHH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9191E5FDC
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659945411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AufWZZEcgThI2xBgpMKruzYOgK1FWSrmvzjD3Nvo93Q=;
        b=HLM8ROvV42hgXX7JO115DQX3PC8JNm7G3G2Lz7hY3E72+uAFAlG+aza6rdz4KdnbMoluSj
        E9HptPP5wwpLdBfZx6II7OyxpLLaRr98D9k+w2Y+wxOqxO9/rItRZSTQ9+bsmRFHWibTM2
        2NvFWaz5yboetgChLBvfIP4FVQdVGJ4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-JRRCIIebMSS1itAD5E4LIA-1; Mon, 08 Aug 2022 03:56:50 -0400
X-MC-Unique: JRRCIIebMSS1itAD5E4LIA-1
Received: by mail-qt1-f198.google.com with SMTP id d29-20020ac8615d000000b0033d168124e9so6313193qtm.19
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 00:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AufWZZEcgThI2xBgpMKruzYOgK1FWSrmvzjD3Nvo93Q=;
        b=JrL6vzthoHuJFuPUkP0dDYDV8WpLe8m9HuQ2rBzYfCs6r0z34rOmVLQw3rGJG3FfaK
         TO1xy98ZeTSxQPngqy6/VTqhb++VrBPOQT+3BTUEMJzv4EiomwbSJWrGxV3UsZvx0l5m
         q9ztc04qTcSwfY88TZWomVuc74MTqraICFFY9RWx0g8szb7LRhJEGogHSN1kl20oDzH5
         QbPelou09UI+iEpgzFcZo4qxltw/npDy0bfF2+vgZim2JBLmO/dg/+epjfyhMm4t7ihA
         4219IAFn+Ngw9R6rfRjKHf96F+jUlnD8zGTWOwti0pojci4fO36wPUtDnRxD6UHRm61q
         vXNA==
X-Gm-Message-State: ACgBeo0orQ8XSLPMCTJ6fqMvUtICHOg9bU2YhinsLCWz8X0L1dKElcwt
        rSv8WkZYs2J83mZiiw4XDtSdVnSIcTejvV9Gg04ljT/0D1sjklmB8gF90UGIa46LRlmMlVWy4II
        DDfv2+MS5gDSXhcYO
X-Received: by 2002:a05:620a:2b8b:b0:6b9:43ca:4a6 with SMTP id dz11-20020a05620a2b8b00b006b943ca04a6mr3566707qkb.346.1659945409701;
        Mon, 08 Aug 2022 00:56:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5AHQLL6/c6cBtSoanSesmnPrpZdXyxLWrWNaQRi8fOEBNqs018hbyfcdBhlapIkl42VoQl4w==
X-Received: by 2002:a05:620a:2b8b:b0:6b9:43ca:4a6 with SMTP id dz11-20020a05620a2b8b00b006b943ca04a6mr3566697qkb.346.1659945409523;
        Mon, 08 Aug 2022 00:56:49 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id b16-20020a05622a021000b0031eddc83560sm7421933qtx.90.2022.08.08.00.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 00:56:48 -0700 (PDT)
Date:   Mon, 8 Aug 2022 09:56:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        Andy King <acking@vmware.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] vsock: Set socket state back to
 SS_UNCONNECTED in vsock_connect_timeout()
Message-ID: <20220808075640.5it462iozqgecxih@sgarzare-redhat>
References: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
 <5cf1337b4f6e82bc0a4eb0bef422a53dcc9d584a.1659862577.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5cf1337b4f6e82bc0a4eb0bef422a53dcc9d584a.1659862577.git.peilin.ye@bytedance.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 07, 2022 at 02:00:46AM -0700, Peilin Ye wrote:
>From: Peilin Ye <peilin.ye@bytedance.com>
>
>Imagine two non-blocking vsock_connect() requests on the same socket.
>The first request schedules @connect_work, and after it times out,
>vsock_connect_timeout() sets *sock* state back to TCP_CLOSE, but keeps
>*socket* state as SS_CONNECTING.
>
>Later, the second request returns -EALREADY, meaning the socket "already
>has a pending connection in progress", even if the first request has
>already timed out.
>
>As suggested by Stefano, fix it by setting *socket* state back to
>SS_UNCONNECTED, so that the second request will return -ETIMEDOUT.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
>Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>---
>(new patch in v2)

Thanks for sending this :-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

