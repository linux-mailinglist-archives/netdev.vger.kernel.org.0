Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09AF665618
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjAKIb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbjAKIbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:31:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD32017
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673425836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S4mw9pfc+UQaXbGaY67GT+joOfvL7NA5BN3JPp+Zx/M=;
        b=jFZN1XwZH0ivpo8k8+Zp6Vzz49Rw/xDmJaVVQ3LoU4T3pkvPb7IpTFWjOerZ4Gm/ObkI6X
        5P35qjtJAQLMN1CmwguKL849+IJbwEafh/fcNS29yNKvPQPFFMaC04RmvfBGyCud5+20de
        30gllj63qD2uphxfvwXA0g0zhATTvtk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-dernHszFPZ-A43cSrr4ttw-1; Wed, 11 Jan 2023 03:30:35 -0500
X-MC-Unique: dernHszFPZ-A43cSrr4ttw-1
Received: by mail-qk1-f198.google.com with SMTP id i4-20020a05620a248400b006febc1651bbso10446572qkn.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4mw9pfc+UQaXbGaY67GT+joOfvL7NA5BN3JPp+Zx/M=;
        b=PVJ/MtJdS4u858SEJ+6n1a8ECNAP7sZwnYgrVez4Ah7tCJS1LKMNFflvVL6zyfZiwH
         U2DulTFg1haOalAHsO256M7XA95WhSu22VuoeGv06izBG5Y0/nHtOP1nF5PiVro9Y0Cx
         8dC0JNBpNe6tVThJMcvP/W/dNfEAAwt7zbFvnP2Cv56Fi/3fRIgVAqos9JY7as1GoF45
         BPbWn8Z7gcdbqVCWhWkY2UzcNm8x9nqqCaV7z5xnYgbuGvFK64r+rGtq0MJ5nYG35abX
         RE2sHyWrpFKDUxD75tJwQxVmH8RGBfPMliYdjgEjR7V5iLne5tNRoVxiOLft2xvHZK8Q
         R8RQ==
X-Gm-Message-State: AFqh2kpi0iemdY02OpTUr/sJICfLLMeitj80vHyy9Peh0qtmQ/SqV0kB
        gg9tiaYF1yXpr7yxC55t3xeohQKAHyvEblDcJFzGoneOv+fAl05iDpwWJTWlJAT3VC3dDjvJYJt
        ZnWV/J+XSjbFlqDMz
X-Received: by 2002:a05:622a:1e13:b0:3ab:b012:f173 with SMTP id br19-20020a05622a1e1300b003abb012f173mr52942407qtb.28.1673425835056;
        Wed, 11 Jan 2023 00:30:35 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvEk8vF6mc4Kf3RCImUwGjvS1uNUoaxaRyBiqLhtMpL5P+KvrQjkw/dFJf7NPNXlHYfzSbFgA==
X-Received: by 2002:a05:622a:1e13:b0:3ab:b012:f173 with SMTP id br19-20020a05622a1e1300b003abb012f173mr52942386qtb.28.1673425834804;
        Wed, 11 Jan 2023 00:30:34 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-244.retail.telecomitalia.it. [79.46.200.244])
        by smtp.gmail.com with ESMTPSA id fw13-20020a05622a4a8d00b003b1180f40d7sm94872qtb.40.2023.01.11.00.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 00:30:34 -0800 (PST)
Date:   Wed, 11 Jan 2023 09:30:29 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [PATCH net-next v7 4/4] test/vsock: vsock_perf utility
Message-ID: <20230111083029.yfcbkzohe5cr6u2k@sgarzare-redhat>
References: <67cd2d0a-1c58-baac-7b39-b8d4ea44f719@sberdevices.ru>
 <0a9464eb-ad31-426b-1f30-c19d77281308@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0a9464eb-ad31-426b-1f30-c19d77281308@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 10:18:32AM +0000, Arseniy Krasnov wrote:
>This adds utility to check vsock rx/tx performance.
>
>Usage as sender:
>./vsock_perf --sender <cid> --port <port> --bytes <bytes to send>
>Usage as receiver:
>./vsock_perf --port <port> --rcvlowat <SO_RCVLOWAT>
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/Makefile     |   3 +-
> tools/testing/vsock/README       |  34 +++
> tools/testing/vsock/vsock_perf.c | 427 +++++++++++++++++++++++++++++++
> 3 files changed, 463 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/vsock/vsock_perf.c

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

