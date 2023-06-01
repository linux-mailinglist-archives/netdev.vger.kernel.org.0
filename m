Return-Path: <netdev+bounces-7024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E41547194D5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4701C20FDE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F99C2EC;
	Thu,  1 Jun 2023 07:59:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9075BE7F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 07:59:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249331AE
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 00:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685606338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TS9b3RiFkUpCZDdrYBHho5/2B8BOEzYrjzr41mSr/Ds=;
	b=MkpTpAKnKSHO+q1DzI++y59XnqgDX4HLqxfs7U/LrgGPbzo7zAzhg+2ZVOVp6REpb9o/P+
	5H58/zUAO1OR4AIAfYE6ZrLhqhgU/KuRqUsODDV/gGkXSy5Vj8XsZ9+26d2wRy/jeC9QrY
	+IaExL1IZWrSDQ1LycA4zU/gBf4Rjg0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-BpjhA1oHNa-_7FOJlCrZHQ-1; Thu, 01 Jun 2023 03:58:57 -0400
X-MC-Unique: BpjhA1oHNa-_7FOJlCrZHQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-96f6fee8123so32522266b.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 00:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685606336; x=1688198336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS9b3RiFkUpCZDdrYBHho5/2B8BOEzYrjzr41mSr/Ds=;
        b=bby46yDNeT7ld+XYNHyth0wBsiqwwRF8uCGP99gACtS/Z4d1FZuRq2hNDJmFG7wYDn
         UwUs2m8iAOrhGnrXXPIwJ2ew54GAQ2jWOH16kCXrwlas3ckyTHzsvwI9ynk7CIrXEdvU
         Ku3NcigqK3y6tFeTrQDAIBnrL9koZ+9J4qKfF7vLiZB8FCBhvy1FKudq+PbYqQAGkaVf
         xqBjldQbioH9+KikoquWFzAyA8pRNn+XB55P6MnUYKsPxq4m7TT/zmy/yrTzthPmMO1S
         7iiHyWth4uaFzJAJ9GVlP6tvY9egL5mqXMvd5qljYzij7VY5GrNIKd9+7+EvgvgFO8WC
         3knA==
X-Gm-Message-State: AC+VfDw0dxCFBcByoWO/k6gcgehfzEXO5SQLi0G6MFDsDUX0j7ncPxS0
	oSwAj1I5OdWBf3pr/rA514S+iqIldmbfOQLZ1tRkNoBVwBT+xlvE2eI+T14XDl3Mlatymp8HPEz
	CHXNZv9z00Si4Jlkr
X-Received: by 2002:a17:907:6d1d:b0:96a:1c2a:5a38 with SMTP id sa29-20020a1709076d1d00b0096a1c2a5a38mr7615762ejc.11.1685606335951;
        Thu, 01 Jun 2023 00:58:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ie3v5LmwvGb/KlhSkOFjqXmTaLy6LzatU5TWS+dAPKf5UfysEeO19vXwVk6f6zCMci8fpbA==
X-Received: by 2002:a17:907:6d1d:b0:96a:1c2a:5a38 with SMTP id sa29-20020a1709076d1d00b0096a1c2a5a38mr7615751ejc.11.1685606335678;
        Thu, 01 Jun 2023 00:58:55 -0700 (PDT)
Received: from sgarzare-redhat ([134.0.3.103])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709064e4500b0096f6647b5e8sm10183211ejw.64.2023.06.01.00.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 00:58:54 -0700 (PDT)
Date: Thu, 1 Jun 2023 09:58:47 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio/vsock: fix sock refcnt bug on owner set
 failure
Message-ID: <35xlmp65lxd4eoal2oy3lwyjxd3v22aeo2nbuyknc4372eljct@vkilkppadayd>
References: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 07:47:32PM +0000, Bobby Eshleman wrote:
>Previous to setting the owner the socket is found via
>vsock_find_connected_socket(), which returns sk after a call to
>sock_hold().
>
>If setting the owner fails, then sock_put() needs to be called.
>
>Fixes: f9d2b1e146e0 ("virtio/vsock: fix leaks due to missing skb owner")
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index b769fc258931..f01cd6adc5cb 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1343,6 +1343,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>
> 	if (!skb_set_owner_sk_safe(skb, sk)) {
> 		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
>+		sock_put(sk);

Did you have any warning, issue here?

IIUC skb_set_owner_sk_safe() can return false only if the ref counter
is 0, so calling a sock_put() on it should have no effect except to
produce a warning.

Thanks,
Stefano


