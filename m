Return-Path: <netdev+bounces-7036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 356987195D4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE19D1C20FFB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F2EC12D;
	Thu,  1 Jun 2023 08:41:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E075250
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:41:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC915E2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685608899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q7l8GTS9GpdOoo1zOHl/lA+HDvKVa49LWct1T5+lgHA=;
	b=KeVeYB3xkdN5UqDTL6PF9ppzJx3Z/45GryR+5+abKm/63fss0EsYf+Be6UXZgI9v3qKGXv
	IVaOia09r6Xmo6TE25R45q2ZJ2XJLVk0shkMSERhyL/pWHdzYXGBxEvuR3sQtKNhx800iK
	OeFyGPEOmXT5nrrT+yqZI+onQifN/d4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-gQ3u1Ni8Nv-42xdGzydS-Q-1; Thu, 01 Jun 2023 04:41:37 -0400
X-MC-Unique: gQ3u1Ni8Nv-42xdGzydS-Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f5fde052b6so956395e9.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 01:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685608896; x=1688200896;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7l8GTS9GpdOoo1zOHl/lA+HDvKVa49LWct1T5+lgHA=;
        b=SXx5WvsPJlZ40IQtJgwZ6JgJKDCuxPiwBAA24dnV8yr8+PnLhQuow+xJXXM5RvOqd8
         hpi2sfjaM/L17K/4whaj9P05z5oDf+Iuwy3I2tk9YPiR+2j+PTnE3dcGfSPQEcw4HD3j
         /2exLm1jE+iQxPxUKEhUXVOQbg0vK2/+6smkqvK0hfChIW+m46TzH8Cqpib6aQRV0pd/
         oIwCK9RGtX4s0WvmMi7SF0sp6xjfxZ6W0gsoBNyKXI1mi9/nKm+X1J1s8MTIg3a9nBjT
         PgKO9U1lBHjHZBIhL6FVIJNMIEjU7yHj9kVXwwO2fzlTJ6ZnjAMxJMPK0iFz3f7GyiHD
         O1Cg==
X-Gm-Message-State: AC+VfDwydArIEIjcx7A7oTUozMJ3jFnmhlDOA9wAQqU1fgR+8filDR3F
	66QUvsa+9LM75Z3UL1JmcgXm+ZMWS+pdH3CEqiytxSmFLx0AXqv4WD9VIj/+7HSOhEZnkvgylJl
	I82gpuI9MR4s7DDRd
X-Received: by 2002:a5d:534f:0:b0:30a:f103:1f55 with SMTP id t15-20020a5d534f000000b0030af1031f55mr5782215wrv.0.1685608896519;
        Thu, 01 Jun 2023 01:41:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ626Kt6ImpYOTgZmZUEm+Tg7IMlMe1JY3ab1PXP1Pb+AbaZKIT+vKdlGl+LNZIaxjD5CtiFKw==
X-Received: by 2002:a5d:534f:0:b0:30a:f103:1f55 with SMTP id t15-20020a5d534f000000b0030af1031f55mr5782206wrv.0.1685608896246;
        Thu, 01 Jun 2023 01:41:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id n2-20020a5d6602000000b0030903d44dbcsm9273875wru.33.2023.06.01.01.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 01:41:35 -0700 (PDT)
Message-ID: <7d84293de72a05c76d66f9010248f4d233cd1c1a.camel@redhat.com>
Subject: Re: [PATCH net] net: renesas: rswitch: Fix return value in error
 path of xmit
From: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <simon.horman@corigine.com>, Yoshihiro Shimoda
	 <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org,  netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Date: Thu, 01 Jun 2023 10:41:34 +0200
In-Reply-To: <ZHXhNH64lel+h/+R@corigine.com>
References: <20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com>
	 <ZHXhNH64lel+h/+R@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 13:42 +0200, Simon Horman wrote:
> On Mon, May 29, 2023 at 04:38:17PM +0900, Yoshihiro Shimoda wrote:
> > Fix return value in the error path of rswitch_start_xmit(). If TX
> > queues are full, this function should return NETDEV_TX_BUSY.
> >=20
> > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet=
 Switch"")
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>=20
> Hi Shimoda-san,
>=20
> I agree that this is the correct return value for this case.
> But I do wonder if, as per the documentation of ndo_start_xmit,
> something should be done to avoid getting into such a situation.
>=20
>  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
>  *                               struct net_device *dev);
>  *      Called when a packet needs to be transmitted.
>  *      Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should =
stop
>  *      the queue before that can happen; it's for obsolete devices and w=
eird
>  *      corner cases, but the stack really does a non-trivial amount
>  *      of useless work if you return NETDEV_TX_BUSY.
>  *      Required; cannot be NULL.

I agree with Simon, it looks like the driver usage of
netif_stop_subqueue()/netif_wake_subqueue() is a dubious.

I think you will be better of using
netif_subqueue_maybe_stop()/netif_subqueue_completed_wake() alike what
rtl8169 is doing. e.g. netif_subqueue_maybe_stop() should be invoked
after the tx buffer enqueue, and netif_subqueue_completed_wake() should
be invoked after successful tx ring cleanup.

Thanks!

Paolo



