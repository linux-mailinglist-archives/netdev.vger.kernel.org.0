Return-Path: <netdev+bounces-8959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D55CE72667D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBF331C20E79
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B1E1ACD4;
	Wed,  7 Jun 2023 16:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2763B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:53:38 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB91FE0;
	Wed,  7 Jun 2023 09:53:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-662f0feafb2so79620b3a.1;
        Wed, 07 Jun 2023 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686156805; x=1688748805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7l4QEpU0+LQkmsHXgVOh37YgpJ+290D8omMu7e7uYk=;
        b=knwnj2+fd6vq6FbFstDS35YGJ++HxkyO5xhWNIcrlBOTKoiZszvzNQ5+VKppnE6tup
         1/52xt/D1hQ7vLiuFfpbbFRjjg+urgFg5Wz9ALfvVeKt5u9dzgET3lMxuxdU+E8kSWSy
         t1Jyt63SD0xf78qxeGH/HH6Mdvr5rCqfb7/uTFAy7hqTlBaRR65mKIb8afbWyTRnCDXO
         KLfEgh8t3ys9a8OqMAAmxsTN0+xIIdiFy/bj217NTrtDrPSDAPA/juD2rb8pPdvA1T6c
         75Sr89EYvQIhccQgAOTm03X7oMNFFspmfd5IsqxA3TiHvrPOalvoomvZZ8DyWiy7OcuE
         60dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156805; x=1688748805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7l4QEpU0+LQkmsHXgVOh37YgpJ+290D8omMu7e7uYk=;
        b=RmQGa6TLcu3iBJch0gidVHgD+6+yj1cEGpaDewzgAG/45zaTyrYgTREnG0/wEkV56H
         Ps7dJbVx4kFl7gW6a32nmXdOqCpfX0H54qTTNMrJsiG6fKHJnbhmNxQ4t7S6KETkxE0y
         xHHgio/UkMetjwtmOElTUnIvafKb81lrYq16YgCXrgyaaSMI6y/A9M7u+J76IV6dUhQp
         iwiWja890hp46t14y1RY2uLz9VYEB0LoZvH/U7So39xmzuVCB7T5KEKRt5bSuLbl1bbN
         do5oQZl6JpGry2UEDOy1JYHdQfrWJIRnupV+UMqaF60kVuHMhjnU5Ajv9rWZAxBIWyhi
         2P2w==
X-Gm-Message-State: AC+VfDw46bTOJ6iS74N7DoAkoIyBqD6OFWnhSCB3yX2T7mwL7v7tDJfZ
	kFhwSWF1RtXMmcuBv+vumuQ=
X-Google-Smtp-Source: ACHHUZ78alg6kEwnhhJV/R4JA3Ql5IDIU8JKFwnCuRQ5xFw33MHp+HePQxLoOo5307wad7eQaZ/Wlg==
X-Received: by 2002:a05:6a00:16d1:b0:64f:ad7c:70fb with SMTP id l17-20020a056a0016d100b0064fad7c70fbmr6644193pfc.17.1686156804938;
        Wed, 07 Jun 2023 09:53:24 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id v11-20020a63480b000000b0053f22b76cdcsm9270839pga.82.2023.06.07.09.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:53:24 -0700 (PDT)
Date: Thu, 1 Jun 2023 07:53:25 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC net-next v3 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Message-ID: <ZHhOdfQPHQvxmndh@bullseye>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <20230413-b4-vsock-dgram-v3-1-c2414413ef6a@bytedance.com>
 <ZHduQMZG4an6A+DG@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHduQMZG4an6A+DG@corigine.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 05:56:48PM +0200, Simon Horman wrote:
> On Wed, May 31, 2023 at 12:35:05AM +0000, Bobby Eshleman wrote:
> > This commit drops the transport->dgram_dequeue callback and makes
> > vsock_dgram_recvmsg() generic. It also adds additional transport
> > callbacks for use by the generic vsock_dgram_recvmsg(), such as for
> > parsing skbs for CID/port which vary in format per transport.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> ...
> 
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index b370070194fa..b6a51afb74b8 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
> >  	return err - sizeof(*dg);
> >  }
> >  
> > -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> > -					struct msghdr *msg, size_t len,
> > -					int flags)
> > +int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> >  {
> > -	int err;
> >  	struct vmci_datagram *dg;
> > -	size_t payload_len;
> > -	struct sk_buff *skb;
> >  
> > -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > -		return -EOPNOTSUPP;
> > +	dg = (struct vmci_datagram *)skb->data;
> > +	if (!dg)
> > +		return -EINVAL;
> >  
> > -	/* Retrieve the head sk_buff from the socket's receive queue. */
> > -	err = 0;
> > -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> > -	if (!skb)
> > -		return err;
> > +	*cid = dg->src.context;
> > +	return 0;
> > +}
> 
> Hi Bobby,
> 
> clang-16 with W=1 seems a bit unhappy about this.
> 
>   net/vmw_vsock/vmci_transport.c:1734:5: warning: no previous prototype for function 'vmci_transport_dgram_get_cid' [-Wmissing-prototypes]
>   int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
>       ^
>   net/vmw_vsock/vmci_transport.c:1734:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>   int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
>   ^
>   static 
>   net/vmw_vsock/vmci_transport.c:1746:5: warning: no previous prototype for function 'vmci_transport_dgram_get_port' [-Wmissing-prototypes]
>   int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
>       ^
>   net/vmw_vsock/vmci_transport.c:1746:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>   int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
>   ^
>   static 
>   net/vmw_vsock/vmci_transport.c:1758:5: warning: no previous prototype for function 'vmci_transport_dgram_get_length' [-Wmissing-prototypes]
>   int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
>       ^
>   net/vmw_vsock/vmci_transport.c:1758:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>   int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
>   ^
> 
> I see similar warnings for net/vmw_vsock/af_vsock.c in patch 4/8.
> 
> > +
> > +int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> > +{
> > +	struct vmci_datagram *dg;
> >  
> >  	dg = (struct vmci_datagram *)skb->data;
> >  	if (!dg)
> > -		/* err is 0, meaning we read zero bytes. */
> > -		goto out;
> > -
> > -	payload_len = dg->payload_size;
> > -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> > -	if (payload_len != skb->len - sizeof(*dg)) {
> > -		err = -EINVAL;
> > -		goto out;
> > -	}
> > +		return -EINVAL;
> >  
> > -	if (payload_len > len) {
> > -		payload_len = len;
> > -		msg->msg_flags |= MSG_TRUNC;
> > -	}
> > +	*port = dg->src.resource;
> > +	return 0;
> > +}
> >  
> > -	/* Place the datagram payload in the user's iovec. */
> > -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> > -	if (err)
> > -		goto out;
> > +int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> > +{
> > +	struct vmci_datagram *dg;
> >  
> > -	if (msg->msg_name) {
> > -		/* Provide the address of the sender. */
> > -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> > -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> > -		msg->msg_namelen = sizeof(*vm_addr);
> > -	}
> > -	err = payload_len;
> > +	dg = (struct vmci_datagram *)skb->data;
> > +	if (!dg)
> > +		return -EINVAL;
> >  
> > -out:
> > -	skb_free_datagram(&vsk->sk, skb);
> > -	return err;
> > +	*len = dg->payload_size;
> > +	return 0;
> >  }
> >  
> >  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> 
> ...

Thanks for the review! Your feedback from both emails will be
incorporated in the next rev (with C=1 and W=1 output clearing).

Thanks again,
Bobby

