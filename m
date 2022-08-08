Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4E58C6F5
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbiHHKyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbiHHKyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A33CC2F
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659956038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cqTZfTOpSZv/oxvZyQIT3dmO6v6DeAZnUAfnA5NVFOM=;
        b=hgAr4wdAB7n99/kjR2gXD1uCd/g3qvycybsjMOwW6aQokcGIIMuvMepWI3tLEupgorQSX0
        zNako5IxOKOJSucEq3e3MFRlZ53ho25bdempIFgbGJnCcCkPb11BpG24oHBO2pCtNad4PF
        fqo3kuv/HuNlvEqpdnmlQq9nbFVo654=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-Lu1A_hgzOEK2e4re1P5jmg-1; Mon, 08 Aug 2022 06:53:57 -0400
X-MC-Unique: Lu1A_hgzOEK2e4re1P5jmg-1
Received: by mail-qk1-f199.google.com with SMTP id y17-20020a05620a25d100b006b66293d75aso7610313qko.17
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cqTZfTOpSZv/oxvZyQIT3dmO6v6DeAZnUAfnA5NVFOM=;
        b=zVbI8IrCuYAbkyOdbk1BFWSz5tfrwJTcJQ+kKSzFwQhDl3nP/r8x2T+KVh3pWsE/vl
         xdTTKKXJmx5aqLk+StaQT0jMIiF6o0X8ipCifW9f1OV0WFxySqHcDwAvKWEoyuD1TD2d
         dqrhf2/lfSyRdt0vkRhtkF7m/OMy13xMdP/EpjWQ0LMH2lWTUcWRzbET6TWphXxNCjhK
         OugTLZpde2xwBYpCMkDLasixpYr6pFRdDnPULJ4pCAS6WivzSDYHIIXFOpuAmEwR7ISI
         WocsdRbXukRtqSCshMTPdpAtGMt8quwoVfkb8IDoyyl2xrfgGCqamGXPnZzTnlAP8Jwc
         TR1A==
X-Gm-Message-State: ACgBeo2Yh/cpxX3Pw53cUsepH7vicEJR6US7oe/RCcfENWk9tHlVvXlb
        bzM7jUMOYGwkPRRisBX4k6aiCM20ctFkxw3oSP06jQarQCN8r8LPXXLQBVepZ6CKBYLAShPaiFJ
        BpwKIjMJpZR6do0Wp
X-Received: by 2002:a05:620a:f8f:b0:6b5:be6c:255e with SMTP id b15-20020a05620a0f8f00b006b5be6c255emr13571449qkn.638.1659956036589;
        Mon, 08 Aug 2022 03:53:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5eZOYkfnMEABqPmnzlbZTfqIBNY9uF7dpmoPWJ7+Uc8TBxra/Vn+m6r3fobIYoBwsf4CHA7A==
X-Received: by 2002:a05:620a:f8f:b0:6b5:be6c:255e with SMTP id b15-20020a05620a0f8f00b006b5be6c255emr13571431qkn.638.1659956036378;
        Mon, 08 Aug 2022 03:53:56 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id az38-20020a05620a172600b006b8619a67f4sm8787400qkb.34.2022.08.08.03.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:53:55 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:53:45 +0200
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
Subject: Re: [RFC PATCH v3 6/9] vsock: add API call for data ready
Message-ID: <20220808105345.vm7x6nzbi4ss7v6j@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <edb1163d-fb78-3af0-2fdd-606c875a535b@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <edb1163d-fb78-3af0-2fdd-606c875a535b@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 02:01:57PM +0000, Arseniy Krasnov wrote:
>This adds 'vsock_data_ready()' which must be called by transport to kick
>sleeping data readers. It checks for SO_RCVLOWAT value before waking
>user,thus preventing spurious wake ups.Based on 'tcp_data_ready()' logic.
>

Since it's an RFC, I suggest you add a space after the punctuation. :-)

The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 10 ++++++++++
> 2 files changed, 11 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index eae5874bae35..7b79fc5164cc 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -77,6 +77,7 @@ struct vsock_sock {
> s64 vsock_stream_has_data(struct vsock_sock *vsk);
> s64 vsock_stream_has_space(struct vsock_sock *vsk);
> struct sock *vsock_create_connected(struct sock *parent);
>+void vsock_data_ready(struct sock *sk);
>
> /**** TRANSPORT ****/
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 3a1426eb8baa..47e80a7cbbdf 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -882,6 +882,16 @@ s64 vsock_stream_has_space(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_stream_has_space);
>
>+void vsock_data_ready(struct sock *sk)
>+{
>+	struct vsock_sock *vsk = vsock_sk(sk);
>+
>+	if (vsock_stream_has_data(vsk) >= sk->sk_rcvlowat ||
>+	    sock_flag(sk, SOCK_DONE))
>+		sk->sk_data_ready(sk);
>+}
>+EXPORT_SYMBOL_GPL(vsock_data_ready);
>+
> static int vsock_release(struct socket *sock)
> {
> 	__vsock_release(sock->sk, 0);
>-- 
>2.25.1

