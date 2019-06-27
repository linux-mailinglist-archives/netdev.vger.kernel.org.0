Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F409B58D94
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF0WE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:04:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41640 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0WE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:04:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so2002492pls.8;
        Thu, 27 Jun 2019 15:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=00evef/ayLM+dg1y18kUMmlFRCnU3hiwv5zN2enrdho=;
        b=KIyQxRglox+IYjflq/aM/KfRvlAZ8LIosypDvq26rI97FIhP2XatmVJrNA8bHvPErH
         TlBwmZBG8zsnXGGD6PSUfhG85rbbjmXOGiFGGjtU++qRaN7FJ1xPE3q79jxrvOvsWNJL
         uzFQzAtrhAN4nILywZys4rIQ/CUWdTedZ5tuN1GFK5EIfrilIWCBINmJcSj1G+bz+efA
         ETbzDuWrpcJzbqwIKl+Yi8mrlMJsWLnVEJW3pKtRiYGgiPbkNZgyGjKm8Bpizkz+Dy5/
         kMam1qvCTWfcuaSLAKkgMuwyZpIG/hga0XX2BdsBSqG4f1IGGpt1LjjAl+8HpXgPsXIb
         eEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=00evef/ayLM+dg1y18kUMmlFRCnU3hiwv5zN2enrdho=;
        b=dKy+u9Dkf0Eh534bw8GtX1MVBcFyJRJf3iC0eCnCHGRCOl6oPX396+odxoQwEb95rT
         HNMjqFNhwYX1Em8ltchTzBneWtecKUqrT67jPKPdj4jp+MU8umuY5C9bcifQjtLuM+Ww
         2wotwFIaX3GKvdmC+I2N3kkpiWZG4Z058wDLOC43OnGDoCroef5TRFOec9XK4/DLhq0C
         RdMTW/pGplG24FUmmdv0DGcRr6hjLjyoIUhLiidiX/gK5+i7tPhCyjT+8GmK8tfDwpC6
         4Fxsy50EmgnW+JkQyZrM+ZH4+Xi1OMH4bbH6B6bcGoftv49uTCvTnA5Tb2ikHh6+4U4/
         GKYA==
X-Gm-Message-State: APjAAAV6kw5MDVm5cemKoySRqprJzfGXEwinuj9Zs5hs7Hb4k0xclYKP
        gm8hfVuxkNm9flFu+ljZQbM=
X-Google-Smtp-Source: APXvYqxGj028cy2iifwg6UKnYwLZozVXHOCO16yNwBas3fLOK1KxD8YiEH9jepBpKM89UDF8gguzmA==
X-Received: by 2002:a17:902:8b82:: with SMTP id ay2mr6850510plb.164.1561673098595;
        Thu, 27 Jun 2019 15:04:58 -0700 (PDT)
Received: from [172.20.53.102] ([2620:10d:c090:200::6693])
        by smtp.gmail.com with ESMTPSA id p2sm70688pfb.118.2019.06.27.15.04.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 15:04:58 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v5 2/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Thu, 27 Jun 2019 15:04:57 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <74C6C13C-651D-4CD1-BCA1-1B8998A4FA31@gmail.com>
In-Reply-To: <20190627101529.11234-3-i.maximets@samsung.com>
References: <20190627101529.11234-1-i.maximets@samsung.com>
 <CGME20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934@eucas1p1.samsung.com>
 <20190627101529.11234-3-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 Jun 2019, at 3:15, Ilya Maximets wrote:

> Device that bound to XDP socket will not have zero refcount until the
> userspace application will not close it. This leads to hang inside
> 'netdev_wait_allrefs()' if device unregistering requested:
>
>   # ip link del p1
>   < hang on recvmsg on netlink socket >
>
>   # ps -x | grep ip
>   5126  pts/0    D+   0:00 ip link del p1
>
>   # journalctl -b
>
>   Jun 05 07:19:16 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>
>   Jun 05 07:19:27 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>   ...
>
> Fix that by implementing NETDEV_UNREGISTER event notification handler
> to properly clean up all the resources and unref device.
>
> This should also allow socket killing via ss(8) utility.
>
> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>  include/net/xdp_sock.h |  5 +++
>  net/xdp/xdp_umem.c     | 10 ++---
>  net/xdp/xdp_umem.h     |  1 +
>  net/xdp/xsk.c          | 87 
> ++++++++++++++++++++++++++++++++++++------
>  4 files changed, 87 insertions(+), 16 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d60f8a..82d153a637c7 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -61,6 +61,11 @@ struct xdp_sock {
>  	struct xsk_queue *tx ____cacheline_aligned_in_smp;
>  	struct list_head list;
>  	bool zc;
> +	enum {
> +		XSK_UNINITIALIZED = 0,
> +		XSK_BINDED,
> +		XSK_UNBINDED,
> +	} state;

I'd prefer that these were named better, perhaps:
    XSK_READY,
    XSK_BOUND,
    XSK_UNBOUND,


Other than that:
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

-- 
Jonathan



>  	/* Protects multiple processes in the control path */
>  	struct mutex mutex;
>  	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 267b82a4cbcf..20c91f02d3d8 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -140,11 +140,13 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, 
> struct net_device *dev,
>  	return err;
>  }
>
> -static void xdp_umem_clear_dev(struct xdp_umem *umem)
> +void xdp_umem_clear_dev(struct xdp_umem *umem)
>  {
>  	struct netdev_bpf bpf;
>  	int err;
>
> +	ASSERT_RTNL();
> +
>  	if (!umem->dev)
>  		return;
>
> @@ -153,17 +155,13 @@ static void xdp_umem_clear_dev(struct xdp_umem 
> *umem)
>  		bpf.xsk.umem = NULL;
>  		bpf.xsk.queue_id = umem->queue_id;
>
> -		rtnl_lock();
>  		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
> -		rtnl_unlock();
>
>  		if (err)
>  			WARN(1, "failed to disable umem!\n");
>  	}
>
> -	rtnl_lock();
>  	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
> -	rtnl_unlock();
>
>  	dev_put(umem->dev);
>  	umem->dev = NULL;
> @@ -195,7 +193,9 @@ static void xdp_umem_unaccount_pages(struct 
> xdp_umem *umem)
>
>  static void xdp_umem_release(struct xdp_umem *umem)
>  {
> +	rtnl_lock();
>  	xdp_umem_clear_dev(umem);
> +	rtnl_unlock();
>
>  	ida_simple_remove(&umem_ida, umem->id);
>
> diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
> index 27603227601b..a63a9fb251f5 100644
> --- a/net/xdp/xdp_umem.h
> +++ b/net/xdp/xdp_umem.h
> @@ -10,6 +10,7 @@
>
>  int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device 
> *dev,
>  			u16 queue_id, u16 flags);
> +void xdp_umem_clear_dev(struct xdp_umem *umem);
>  bool xdp_umem_validate_queues(struct xdp_umem *umem);
>  void xdp_get_umem(struct xdp_umem *umem);
>  void xdp_put_umem(struct xdp_umem *umem);
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..336723948a36 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -335,6 +335,22 @@ static int xsk_init_queue(u32 entries, struct 
> xsk_queue **queue,
>  	return 0;
>  }
>
> +static void xsk_unbind_dev(struct xdp_sock *xs)
> +{
> +	struct net_device *dev = xs->dev;
> +
> +	if (!dev || xs->state != XSK_BINDED)
> +		return;
> +
> +	xs->state = XSK_UNBINDED;
> +
> +	/* Wait for driver to stop using the xdp socket. */
> +	xdp_del_sk_umem(xs->umem, xs);
> +	xs->dev = NULL;
> +	synchronize_net();
> +	dev_put(dev);
> +}
> +
>  static int xsk_release(struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
> @@ -354,15 +370,7 @@ static int xsk_release(struct socket *sock)
>  	sock_prot_inuse_add(net, sk->sk_prot, -1);
>  	local_bh_enable();
>
> -	if (xs->dev) {
> -		struct net_device *dev = xs->dev;
> -
> -		/* Wait for driver to stop using the xdp socket. */
> -		xdp_del_sk_umem(xs->umem, xs);
> -		xs->dev = NULL;
> -		synchronize_net();
> -		dev_put(dev);
> -	}
> +	xsk_unbind_dev(xs);
>
>  	xskq_destroy(xs->rx);
>  	xskq_destroy(xs->tx);
> @@ -412,7 +420,7 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  		return -EINVAL;
>
>  	mutex_lock(&xs->mutex);
> -	if (xs->dev) {
> +	if (xs->state != XSK_UNINITIALIZED) {
>  		err = -EBUSY;
>  		goto out_release;
>  	}
> @@ -492,6 +500,8 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  out_unlock:
>  	if (err)
>  		dev_put(dev);
> +	else
> +		xs->state = XSK_BINDED;
>  out_release:
>  	mutex_unlock(&xs->mutex);
>  	return err;
> @@ -520,6 +530,10 @@ static int xsk_setsockopt(struct socket *sock, 
> int level, int optname,
>  			return -EFAULT;
>
>  		mutex_lock(&xs->mutex);
> +		if (xs->state != XSK_UNINITIALIZED) {
> +			mutex_unlock(&xs->mutex);
> +			return -EBUSY;
> +		}
>  		q = (optname == XDP_TX_RING) ? &xs->tx : &xs->rx;
>  		err = xsk_init_queue(entries, q, false);
>  		mutex_unlock(&xs->mutex);
> @@ -534,7 +548,7 @@ static int xsk_setsockopt(struct socket *sock, int 
> level, int optname,
>  			return -EFAULT;
>
>  		mutex_lock(&xs->mutex);
> -		if (xs->umem) {
> +		if (xs->state != XSK_UNINITIALIZED || xs->umem) {
>  			mutex_unlock(&xs->mutex);
>  			return -EBUSY;
>  		}
> @@ -561,6 +575,10 @@ static int xsk_setsockopt(struct socket *sock, 
> int level, int optname,
>  			return -EFAULT;
>
>  		mutex_lock(&xs->mutex);
> +		if (xs->state != XSK_UNINITIALIZED) {
> +			mutex_unlock(&xs->mutex);
> +			return -EBUSY;
> +		}
>  		if (!xs->umem) {
>  			mutex_unlock(&xs->mutex);
>  			return -EINVAL;
> @@ -662,6 +680,9 @@ static int xsk_mmap(struct file *file, struct 
> socket *sock,
>  	unsigned long pfn;
>  	struct page *qpg;
>
> +	if (xs->state != XSK_UNINITIALIZED)
> +		return -EBUSY;
> +
>  	if (offset == XDP_PGOFF_RX_RING) {
>  		q = READ_ONCE(xs->rx);
>  	} else if (offset == XDP_PGOFF_TX_RING) {
> @@ -693,6 +714,38 @@ static int xsk_mmap(struct file *file, struct 
> socket *sock,
>  			       size, vma->vm_page_prot);
>  }
>
> +static int xsk_notifier(struct notifier_block *this,
> +			unsigned long msg, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct net *net = dev_net(dev);
> +	struct sock *sk;
> +
> +	switch (msg) {
> +	case NETDEV_UNREGISTER:
> +		mutex_lock(&net->xdp.lock);
> +		sk_for_each(sk, &net->xdp.list) {
> +			struct xdp_sock *xs = xdp_sk(sk);
> +
> +			mutex_lock(&xs->mutex);
> +			if (xs->dev == dev) {
> +				sk->sk_err = ENETDOWN;
> +				if (!sock_flag(sk, SOCK_DEAD))
> +					sk->sk_error_report(sk);
> +
> +				xsk_unbind_dev(xs);
> +
> +				/* Clear device references in umem. */
> +				xdp_umem_clear_dev(xs->umem);
> +			}
> +			mutex_unlock(&xs->mutex);
> +		}
> +		mutex_unlock(&net->xdp.lock);
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
>  static struct proto xsk_proto = {
>  	.name =		"XDP",
>  	.owner =	THIS_MODULE,
> @@ -764,6 +817,7 @@ static int xsk_create(struct net *net, struct 
> socket *sock, int protocol,
>  	sock_set_flag(sk, SOCK_RCU_FREE);
>
>  	xs = xdp_sk(sk);
> +	xs->state = XSK_UNINITIALIZED;
>  	mutex_init(&xs->mutex);
>  	spin_lock_init(&xs->tx_completion_lock);
>
> @@ -784,6 +838,10 @@ static const struct net_proto_family 
> xsk_family_ops = {
>  	.owner	= THIS_MODULE,
>  };
>
> +static struct notifier_block xsk_netdev_notifier = {
> +	.notifier_call	= xsk_notifier,
> +};
> +
>  static int __net_init xsk_net_init(struct net *net)
>  {
>  	mutex_init(&net->xdp.lock);
> @@ -816,8 +874,15 @@ static int __init xsk_init(void)
>  	err = register_pernet_subsys(&xsk_net_ops);
>  	if (err)
>  		goto out_sk;
> +
> +	err = register_netdevice_notifier(&xsk_netdev_notifier);
> +	if (err)
> +		goto out_pernet;
> +
>  	return 0;
>
> +out_pernet:
> +	unregister_pernet_subsys(&xsk_net_ops);
>  out_sk:
>  	sock_unregister(PF_XDP);
>  out_proto:
> -- 
> 2.17.1
