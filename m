Return-Path: <netdev+bounces-1522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0856FE17C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0DA028152C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03441641E;
	Wed, 10 May 2023 15:23:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191D125B8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:23:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E0C2D4A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683732200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQz0FmqJ0fhhQVp092YrUUlwTUhSHWlf9UDAQ/T7kzA=;
	b=ik8ESORAgyBVZDpyLxhJY3PK7uCOvT0siu1pWv7LUwXSO0jgfSexOWLkENCvkWMl4NFUFg
	pu3YVAERnJnsSjvt02odRlUvUcCE9ChhZd+Fd6cxqZ9LS+SGpmVaq2FlgEddwg/PxiyJ3N
	RE+tA7IzKn/dcwNYsJ+PAvHf2UroflE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-MyhEWhsvPqey0BjEqUwO_Q-1; Wed, 10 May 2023 11:23:19 -0400
X-MC-Unique: MyhEWhsvPqey0BjEqUwO_Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30640be4fd0so2632457f8f.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683732198; x=1686324198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQz0FmqJ0fhhQVp092YrUUlwTUhSHWlf9UDAQ/T7kzA=;
        b=IafMa8lUKbtkLCxlggP3rm71p7qKGmHAcVC6tZiWJkb4wbK7HKNEHm079R+knaxgME
         i3sQPzm4h0BiALCFASqP9BSrU4mhpAgyA3njuVvujzF9OXeUyMgHrtFCkUHAIBD445ma
         fAo6P6FUgj9MV5h/2UHUMIUhkABO+ye1hvJJGwXo7SdfczVjifJjj69ecOBaUaWKAEt+
         cUSwdZDBlL6keycE5ZIfyre6zBMd4frIukR80L0ZCExIxZ3fWl4+LWCryY3DV9b5N/PH
         rwBcTQTaLVAioEmI7LkyF8lD4NQ9BFw8BexOYso5jNPhWyW4c1KT6Vn4MB/CFMvgm/pd
         ye3w==
X-Gm-Message-State: AC+VfDw98JF5w9gvodJnsRhBXvqLFsBCero5eeZuR7utRQuaNY6qwsim
	ulA6cVDzumBHMLYq55dW6wW0Na5ql1VwJoCBhulpJb2JjXHW3+ysprbQOARZRe0JMg4mZX2Yh/f
	xgNfAS/xozJylIFlU
X-Received: by 2002:a5d:668c:0:b0:2fe:2775:6067 with SMTP id l12-20020a5d668c000000b002fe27756067mr13070915wru.28.1683732198397;
        Wed, 10 May 2023 08:23:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5OVnaJRiAA0cQBb92KuhDH69k4SVMEoaKebUn/GNPF4wmy0jKK0SNfVankDjgdH6JTuuX5bw==
X-Received: by 2002:a5d:668c:0:b0:2fe:2775:6067 with SMTP id l12-20020a5d668c000000b002fe27756067mr13070898wru.28.1683732198056;
        Wed, 10 May 2023 08:23:18 -0700 (PDT)
Received: from sgarzare-redhat ([217.171.72.110])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb11000000b003075428aad5sm17481409wrr.29.2023.05.10.08.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 08:23:17 -0700 (PDT)
Date: Wed, 10 May 2023 17:23:14 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Zhuang Shengen <zhuangshengen@huawei.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, arei.gonglei@huawei.com, 
	longpeng2@huawei.com, jianjay.zhou@huawei.com
Subject: Re: [PATCH] vsock: bugfix port residue in server
Message-ID: <ftuh7vhoxdxbymg6u3wlkfhlfoufupeqampqxc2ktqrpxndow3@dkpufdnuwlln>
References: <20230510142502.2293109-1-zhuangshengen@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230510142502.2293109-1-zhuangshengen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,
thanks for the patch, the change LGTM, but I have the following
suggestions:

Please avoid "bugfix" in the subject, "fix" should be enough:
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#describe-your-changes

Anyway, I suggest to change the subject in
"vsock: avoid to close connected socket after the timeout"

On Wed, May 10, 2023 at 10:25:02PM +0800, Zhuang Shengen wrote:
>When client and server establish a connection through vsock,
>the client send a request to the server to initiate the connection,
>then start a timer to wait for the server's response. When the server's
>RESPONSE message arrives, the timer also times out and exits. The
>server's RESPONSE message is processed first, and the connection is
>established. However, the client's timer also times out, the original
>processing logic of the client is to directly set the state of this vsock
>to CLOSE and return ETIMEDOUT, User will release the port. It will not

What to you mean with "User" here?

>notify the server when the port is released, causing the server port remain
>

Can we remove this blank line?

>when client's vsock_connect timeout，it should check sk state is

The remote peer can't trust the other peer, indeed it will receive an
error after sending the first message and it will remove the connection,
right?

>ESTABLISHED or not. if sk state is ESTABLISHED, it means the connection
>is established, the client should not set the sk state to CLOSE
>
>Note: I encountered this issue on kernel-4.18, which can be fixed by
>this patch. Then I checked the latest code in the community
>and found similar issue.
>

In order to backport it to the stable kernels, we should add a Fixes tag:
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#describe-your-changes

Thanks,
Stefano

>Signed-off-by: Zhuang Shengen <zhuangshengen@huawei.com>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 413407bb646c..efb8a0937a13 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1462,7 +1462,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> 			vsock_transport_cancel_pkt(vsk);
> 			vsock_remove_connected(vsk);
> 			goto out_wait;
>-		} else if (timeout == 0) {
>+		} else if ((sk->sk_state != TCP_ESTABLISHED) && (timeout == 0)) {
> 			err = -ETIMEDOUT;
> 			sk->sk_state = TCP_CLOSE;
> 			sock->state = SS_UNCONNECTED;
>-- 
>2.27.0
>


