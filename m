Return-Path: <netdev+bounces-9946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E520272B3F6
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 22:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B66B1C209CB
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 20:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8778B10949;
	Sun, 11 Jun 2023 20:43:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0F32C9D;
	Sun, 11 Jun 2023 20:43:23 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3144E4E;
	Sun, 11 Jun 2023 13:43:20 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b1b3836392so41645791fa.0;
        Sun, 11 Jun 2023 13:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686516199; x=1689108199;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LDvPKEEw8JpFVZ6XsO+05o6a890refZ0b8CPIMe0v1Y=;
        b=dIg3ePutDnUCTLvArNqRB5SFB4wL6Rb8TU3raRnDb0WejyjakQ2T3o2J3wSm+5M/yQ
         OiMggPFklD0WwV+XZ1t286eOtmpmofRglwahFqrIDdnUAwdzvafbEmBezMgzEdcWkYlj
         VAcP50oVkapqXdbKZtzzqtwnt4tdywm6Rrmi2VZB3jZiJPiCLECyrVGDDEGVfv/0eXIK
         4fYbxem18H/zywQRHojQVNPzM4eiUV28sY2oKjnhISEzrRKlP8fe+dtEZA4Vd0D/zGNw
         rw9B8YyBOcoQB2eyxZvCHsJzj75kojI1bUWZYJ+mHbBjJy0jO21mJRrxw2jbGAnqK+p/
         0alg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686516199; x=1689108199;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDvPKEEw8JpFVZ6XsO+05o6a890refZ0b8CPIMe0v1Y=;
        b=ROcAb1X+dMefKE5NytCwTCB9YaM1AzvjSQ6LhmkXbvP1LiFvLqkGPtSKgCBsRmX7XP
         Ub0+Hz2gfRgTlgC+pl+btRtq2HE+spLYiduht/GKfpN6I9wTxTAjA1iUmRa84+yZC/O6
         QeuauMLQnYALn1jtvqttPg7NBGqT9ZP/VHiFcJfnPevqN817a/kOSfeulVnjFpjnyrDu
         mo1BSIR0sBKlX5iIomuxWjnrJW2PArk2B3nXg6uKc6botFKXNBB08zk9WNdmW8D8JiY6
         foHdDJws07gnjIA4EVGoN/lI1q9LaG1qbeas00cnidqkZiWFq2ixp1Y2SNOi7aep4KEz
         E9EQ==
X-Gm-Message-State: AC+VfDw1iO7082N9kwxfWUe7arZOmy1ZFaTZCuHq+aK/m4hPvHmRMc1r
	UKLlj8a75SCW+PA98fiL/oA=
X-Google-Smtp-Source: ACHHUZ7rV0noTu2E+w1DLxfUXFc4AxG5KUoAARsAB8bEwsRGJIbd1zP8Bd/kxfAakh7KtU3vVEBD4w==
X-Received: by 2002:a19:4347:0:b0:4f3:b2a7:68ef with SMTP id m7-20020a194347000000b004f3b2a768efmr2704260lfj.10.1686516198358;
        Sun, 11 Jun 2023 13:43:18 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c487:9300:dcc4:573f:aaf5:21af? ([2a00:1e88:c487:9300:dcc4:573f:aaf5:21af])
        by smtp.gmail.com with ESMTPSA id n18-20020a2e86d2000000b002ada919a09asm1429082ljj.73.2023.06.11.13.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 13:43:17 -0700 (PDT)
Message-ID: <3eb6216b-a3d2-e1ef-270c-8a0032a4a8a5@gmail.com>
Date: Sun, 11 Jun 2023 23:43:15 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v4 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Content-Language: en-US
To: Bobby Eshleman <bobby.eshleman@bytedance.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>,
 Vishnu Dasa <vdasa@vmware.com>,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 bpf@vger.kernel.org
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-1-0cebbb2ae899@bytedance.com>
From: Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v4-1-0cebbb2ae899@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
	HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Bobby! Thanks for this patchset! Small comment below:

On 10.06.2023 03:58, Bobby Eshleman wrote:
> This commit drops the transport->dgram_dequeue callback and makes
> vsock_dgram_recvmsg() generic. It also adds additional transport
> callbacks for use by the generic vsock_dgram_recvmsg(), such as for
> parsing skbs for CID/port which vary in format per transport.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  drivers/vhost/vsock.c                   |  4 +-
>  include/linux/virtio_vsock.h            |  3 ++
>  include/net/af_vsock.h                  | 13 ++++++-
>  net/vmw_vsock/af_vsock.c                | 51 ++++++++++++++++++++++++-
>  net/vmw_vsock/hyperv_transport.c        | 17 +++++++--
>  net/vmw_vsock/virtio_transport.c        |  4 +-
>  net/vmw_vsock/virtio_transport_common.c | 18 +++++++++
>  net/vmw_vsock/vmci_transport.c          | 68 +++++++++++++--------------------
>  net/vmw_vsock/vsock_loopback.c          |  4 +-
>  9 files changed, 132 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 6578db78f0ae..c8201c070b4b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -410,9 +410,11 @@ static struct virtio_transport vhost_transport = {
>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>  
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_bind               = virtio_transport_dgram_bind,
>  		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> +		.dgram_get_length	  = virtio_transport_dgram_get_length,
>  
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index c58453699ee9..23521a318cf0 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -219,6 +219,9 @@ bool virtio_transport_stream_allow(u32 cid, u32 port);
>  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>  				struct sockaddr_vm *addr);
>  bool virtio_transport_dgram_allow(u32 cid, u32 port);
> +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
> +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
> +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
>  
>  int virtio_transport_connect(struct vsock_sock *vsk);
>  
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index 0e7504a42925..7bedb9ee7e3e 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -120,11 +120,20 @@ struct vsock_transport {
>  
>  	/* DGRAM. */
>  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> -	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> -			     size_t len, int flags);
>  	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
>  			     struct msghdr *, size_t len);
>  	bool (*dgram_allow)(u32 cid, u32 port);
> +	int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
> +	int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
> +	int (*dgram_get_length)(struct sk_buff *skb, size_t *length);
> +
> +	/* The number of bytes into the buffer at which the payload starts, as
> +	 * first seen by the receiving socket layer. For example, if the
> +	 * transport presets the skb pointers using skb_pull(sizeof(header))
> +	 * than this would be zero, otherwise it would be the size of the
> +	 * header.
> +	 */
> +	const size_t dgram_payload_offset;
>  
>  	/* STREAM. */
>  	/* TODO: stream_bind() */
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index efb8a0937a13..ffb4dd8b6ea7 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1271,11 +1271,15 @@ static int vsock_dgram_connect(struct socket *sock,
>  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  			size_t len, int flags)
>  {
> +	const struct vsock_transport *transport;
>  #ifdef CONFIG_BPF_SYSCALL
>  	const struct proto *prot;
>  #endif
>  	struct vsock_sock *vsk;
> +	struct sk_buff *skb;
> +	size_t payload_len;
>  	struct sock *sk;
> +	int err;
>  
>  	sk = sock->sk;
>  	vsk = vsock_sk(sk);
> @@ -1286,7 +1290,52 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>  #endif
>  
> -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> +		return -EOPNOTSUPP;
> +
> +	transport = vsk->transport;
> +
> +	/* Retrieve the head sk_buff from the socket's receive queue. */
> +	err = 0;
> +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> +	if (!skb)
> +		return err;
> +
> +	err = transport->dgram_get_length(skb, &payload_len);
> +	if (err)
> +		goto out;
> +
> +	if (payload_len > len) {
> +		payload_len = len;
> +		msg->msg_flags |= MSG_TRUNC;
> +	}
> +
> +	/* Place the datagram payload in the user's iovec. */
> +	err = skb_copy_datagram_msg(skb, transport->dgram_payload_offset, msg, payload_len);
> +	if (err)
> +		goto out;
> +
> +	if (msg->msg_name) {
> +		/* Provide the address of the sender. */
> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> +		unsigned int cid, port;
> +
> +		err = transport->dgram_get_cid(skb, &cid);
> +		if (err)
> +			goto out;
> +
> +		err = transport->dgram_get_port(skb, &port);
> +		if (err)
> +			goto out;

Maybe we can merge 'dgram_get_cid' and 'dgram_get_port' to a single callback? Because I see that this is
the only place where both are used (correct me if i'm wrong) and logically both operates with addresses:
CID and port. E.g. something like that: dgram_get_cid_n_port().

Moreover, I'm not sure, but is it good "tradeoff" here: remove transport specific callback for dgram receive
where we already have 'msghdr' with both data buffer and buffer for 'sockaddr_vm' and instead of it add new
several fields (callbacks) to transports like dgram_get_cid(), dgram_get_port()? I agree, that in each transport
specific callback we will have same copying logic by calling 'skb_copy_datagram_msg()' and filling address
by using 'vsock_addr_init()', but in this case we don't need to update transports too much. For example HyperV
still unchanged as it does not support SOCK_DGRAM. For VMCI You just need to add 'vsock_addr_init()' logic
to it's dgram dequeue callback.

What do You think?

Thanks, Arseniy

> +
> +		vsock_addr_init(vm_addr, cid, port);
> +		msg->msg_namelen = sizeof(*vm_addr);
> +	}
> +	err = payload_len;
> +
> +out:
> +	skb_free_datagram(&vsk->sk, skb);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>  
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> index 7cb1a9d2cdb4..ff6e87e25fa0 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -556,8 +556,17 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
>  	return -EOPNOTSUPP;
>  }
>  
> -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> -			     size_t len, int flags)
> +static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int hvs_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int hvs_dgram_get_length(struct sk_buff *skb, size_t *len)
>  {
>  	return -EOPNOTSUPP;
>  }
> @@ -833,7 +842,9 @@ static struct vsock_transport hvs_transport = {
>  	.shutdown                 = hvs_shutdown,
>  
>  	.dgram_bind               = hvs_dgram_bind,
> -	.dgram_dequeue            = hvs_dgram_dequeue,
> +	.dgram_get_cid		  = hvs_dgram_get_cid,
> +	.dgram_get_port		  = hvs_dgram_get_port,
> +	.dgram_get_length	  = hvs_dgram_get_length,
>  	.dgram_enqueue            = hvs_dgram_enqueue,
>  	.dgram_allow              = hvs_dgram_allow,
>  
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e95df847176b..5763cdf13804 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -429,9 +429,11 @@ static struct virtio_transport virtio_transport = {
>  		.cancel_pkt               = virtio_transport_cancel_pkt,
>  
>  		.dgram_bind               = virtio_transport_dgram_bind,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>  		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> +		.dgram_get_length	  = virtio_transport_dgram_get_length,
>  
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index b769fc258931..e6903c719964 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -797,6 +797,24 @@ int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
>  
> +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> +{
> +	return -EOPNOTSUPP;
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
> +
> +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> +{
> +	return -EOPNOTSUPP;
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
> +
> +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> +{
> +	return -EOPNOTSUPP;
> +}
> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
> +
>  bool virtio_transport_dgram_allow(u32 cid, u32 port)
>  {
>  	return false;
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index b370070194fa..bbc63826bf48 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
>  	return err - sizeof(*dg);
>  }
>  
> -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> -					struct msghdr *msg, size_t len,
> -					int flags)
> +static int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
>  {
> -	int err;
>  	struct vmci_datagram *dg;
> -	size_t payload_len;
> -	struct sk_buff *skb;
>  
> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> -		return -EOPNOTSUPP;
> +	dg = (struct vmci_datagram *)skb->data;
> +	if (!dg)
> +		return -EINVAL;
>  
> -	/* Retrieve the head sk_buff from the socket's receive queue. */
> -	err = 0;
> -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> -	if (!skb)
> -		return err;
> +	*cid = dg->src.context;
> +	return 0;
> +}
> +
> +static int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> +{
> +	struct vmci_datagram *dg;
>  
>  	dg = (struct vmci_datagram *)skb->data;
>  	if (!dg)
> -		/* err is 0, meaning we read zero bytes. */
> -		goto out;
> -
> -	payload_len = dg->payload_size;
> -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> -	if (payload_len != skb->len - sizeof(*dg)) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> +		return -EINVAL;
>  
> -	if (payload_len > len) {
> -		payload_len = len;
> -		msg->msg_flags |= MSG_TRUNC;
> -	}
> +	*port = dg->src.resource;
> +	return 0;
> +}
>  
> -	/* Place the datagram payload in the user's iovec. */
> -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> -	if (err)
> -		goto out;
> +static int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> +{
> +	struct vmci_datagram *dg;
>  
> -	if (msg->msg_name) {
> -		/* Provide the address of the sender. */
> -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> -		msg->msg_namelen = sizeof(*vm_addr);
> -	}
> -	err = payload_len;
> +	dg = (struct vmci_datagram *)skb->data;
> +	if (!dg)
> +		return -EINVAL;
>  
> -out:
> -	skb_free_datagram(&vsk->sk, skb);
> -	return err;
> +	*len = dg->payload_size;
> +	return 0;
>  }
>  
>  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> @@ -2040,9 +2023,12 @@ static struct vsock_transport vmci_transport = {
>  	.release = vmci_transport_release,
>  	.connect = vmci_transport_connect,
>  	.dgram_bind = vmci_transport_dgram_bind,
> -	.dgram_dequeue = vmci_transport_dgram_dequeue,
>  	.dgram_enqueue = vmci_transport_dgram_enqueue,
>  	.dgram_allow = vmci_transport_dgram_allow,
> +	.dgram_get_cid = vmci_transport_dgram_get_cid,
> +	.dgram_get_port = vmci_transport_dgram_get_port,
> +	.dgram_get_length = vmci_transport_dgram_get_length,
> +	.dgram_payload_offset = sizeof(struct vmci_datagram),
>  	.stream_dequeue = vmci_transport_stream_dequeue,
>  	.stream_enqueue = vmci_transport_stream_enqueue,
>  	.stream_has_data = vmci_transport_stream_has_data,
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 5c6360df1f31..2f3cabc79ee5 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -62,9 +62,11 @@ static struct virtio_transport loopback_transport = {
>  		.cancel_pkt               = vsock_loopback_cancel_pkt,
>  
>  		.dgram_bind               = virtio_transport_dgram_bind,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>  		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> +		.dgram_get_length	  = virtio_transport_dgram_get_length,
>  
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
> 

