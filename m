Return-Path: <netdev+bounces-7266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C93CD71F6B5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B4D51C21142
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F21548234;
	Thu,  1 Jun 2023 23:39:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468FC10FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 23:39:50 +0000 (UTC)
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E178136;
	Thu,  1 Jun 2023 16:39:48 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-5584f8ec30cso1085378eaf.0;
        Thu, 01 Jun 2023 16:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685662788; x=1688254788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y66S7nKcbyO9mw2veazWYNce7x29EbNWsEjy9gQwvT8=;
        b=JgN6bMOPbZQQzmbjQOXjZR1MWbA658FbsmFwhmJTfIBw7YT4vVH5SbNbGOqDYNiykz
         NsONTUM1dbTRUtPmxQi/H2LhtTn0Gt6DO8HcjDTOBUhoGjYv59NWvC5TZ17iskx80o1o
         jZWxce7jFMBi1PMppTmfYEnMNSDmtgSD0HR7uL22/b+QOMO2srLfPklplvCwi4Zgpn/S
         +RyIJ/nq+QgwVgiZe0DQp6ybDulRm25BGxz2VtBmAV3+cM3FYgqFrIm/4tiHZjNDFj3/
         NVhs4YEuF3+R+IYByMBWLDGjNsegbKB3nzBunHXSaJIZCWh9PVtdIWIC9DuBPSNL49Un
         OkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685662788; x=1688254788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y66S7nKcbyO9mw2veazWYNce7x29EbNWsEjy9gQwvT8=;
        b=Kl6rnOXFgqoGrNqlLT8dnPnPlzHdmAVsxhGZhSVav0Wm46GJ6xbWllBqm5lNOhyCkD
         kBlB5IuFgqe0C4Ckulu1zs30gpFrzI45AphfoPTzHPxCvEh/rr7/JBiKroR9X0x9eSqd
         sxwBFRN2HfgxYvrcbEC/uQThpyvXsEhTq7Tco4jTgFgHJmkSfHxtBDUGq7wlbiymdSsM
         YzoylbgJAWOATl2u1QDAffsgzoI381z7GTbvDU7xShkObfyNWiO7A000GaD7FrQKXqeE
         tWXW4QvQE1Tv1Sft8mlgtuvy+NZqmUVpxCsLWIjdGZn+3kZrARd+6Fxzp4o3kWWKNJoA
         M7QQ==
X-Gm-Message-State: AC+VfDxIN6DIPPB9/MltVaGZlKkw8AjMC8H7vFnhhs8QYYIqJhNQ5f+2
	rkwQh0PjKFJ+dYhud7rfZBFaG7GgPa5zbfRq
X-Google-Smtp-Source: ACHHUZ5H3iz5f8fyOD3aj+Xa4IrVqtidCjhJ6HAZSYPdF8KVhqG0fRMzu2vPFMhJL5t8WczAz3B7Dw==
X-Received: by 2002:a05:6358:9896:b0:123:5c29:c39a with SMTP id q22-20020a056358989600b001235c29c39amr7109173rwa.31.1685662787613;
        Thu, 01 Jun 2023 16:39:47 -0700 (PDT)
Received: from localhost (ec2-52-9-159-93.us-west-1.compute.amazonaws.com. [52.9.159.93])
        by smtp.gmail.com with ESMTPSA id z15-20020aa791cf000000b0064d59e194c8sm5585299pfa.115.2023.06.01.16.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 16:39:47 -0700 (PDT)
Date: Wed, 31 May 2023 03:35:30 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Eric Dumazet <edumazet@google.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] virtio/vsock: fix sock refcnt bug on owner set
 failure
Message-ID: <ZHbAgkvSHEiQlFs6@bullseye>
References: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
 <35xlmp65lxd4eoal2oy3lwyjxd3v22aeo2nbuyknc4372eljct@vkilkppadayd>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35xlmp65lxd4eoal2oy3lwyjxd3v22aeo2nbuyknc4372eljct@vkilkppadayd>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:58:47AM +0200, Stefano Garzarella wrote:
> On Wed, May 31, 2023 at 07:47:32PM +0000, Bobby Eshleman wrote:
> > Previous to setting the owner the socket is found via
> > vsock_find_connected_socket(), which returns sk after a call to
> > sock_hold().
> > 
> > If setting the owner fails, then sock_put() needs to be called.
> > 
> > Fixes: f9d2b1e146e0 ("virtio/vsock: fix leaks due to missing skb owner")
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > net/vmw_vsock/virtio_transport_common.c | 1 +
> > 1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index b769fc258931..f01cd6adc5cb 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1343,6 +1343,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> > 
> > 	if (!skb_set_owner_sk_safe(skb, sk)) {
> > 		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
> > +		sock_put(sk);
> 
> Did you have any warning, issue here?
> 
> IIUC skb_set_owner_sk_safe() can return false only if the ref counter
> is 0, so calling a sock_put() on it should have no effect except to
> produce a warning.
> 

Oh yeah, you're totally right. I did not recall how
skb_set_owner_sk_safe() worked internally and thought I'd introduced an
uneven hold/put count with that prior patch when reading through the
code again. I haven't seen any live issue, just misread the code.

Sorry about that, feel free to ignore this patch.

Best,
Bobby

