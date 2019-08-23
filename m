Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D5B9B4D2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390029AbfHWQqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:46:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39583 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbfHWQqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:46:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so872139pfe.6;
        Fri, 23 Aug 2019 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rST+SlVYDLpVMPyRS+qsdmMP2jlyNDUlCKuJAVq8uBE=;
        b=H6yD+A8a0ikzpuBhVcli6hv42vI/XTVPCUZsQ3kZD+wjOGtBzAvJLnN7jxzDv6+R9o
         Rru5+EQHyz8PFYsLA5OufRJzdaeviot2CswPussHB5y4s5i/Ps0zHg3c0+RvH1VrIk5y
         lLh9nMZjZL8LAXO7s7qQsnHLi3jmbCzIOHc/GlirxQF4Ij+wCjzC1mwzVfv3+4+n32s/
         HGfN5kmB4vFagVDzJ5ovqzfbG9AzbFuso+2JTSZEnPrxC+s+/fKSHiwED5WVHEB3swU7
         H8eTMkZKFZQGmJDEnW3qCtoPhlWkykueC1DVR/h4U22EI6T7gpjDOweuERKTHn+99COP
         8mVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rST+SlVYDLpVMPyRS+qsdmMP2jlyNDUlCKuJAVq8uBE=;
        b=EQfupFN3GxPm66CFGZWbHOdKs3lbyk0aVWuklwm+x/3K7uLkTBmokPX1bhry+LaBcH
         UHUMLOa8ZuIw0apx/vNWyhqMhiLVx+D65SB9JpZR1qw4AlPCBsErJ5zmcGkWT3HLV+jH
         EZbSYmkKEn3tXfSqz011bVMiLs38rfMdx2L5tbrxmSUiPybW1yrwcxIVlM9CkNqlCmp0
         nW8eo6K9OdIPe2P1pYMmeVHXoxeSrTmMuOax9y3wboyu/j/VPkHfa0x6L8CDt/IVA+6n
         ku2HwOTdLOW33dwSR5U7u9TlFBxM4jhTab868r0S1/0FM4BRCrmNjDV6BZN2fV4tFoVE
         pOcg==
X-Gm-Message-State: APjAAAVpXseh+MiUy71j6oIu0X78u6HOPWl6nQBReQQlFiyU+t/iD4hF
        bakUVlN3Sh2lxx3ozGiYA2U=
X-Google-Smtp-Source: APXvYqxm8BLVbURLaRozYpgwfEVNh1WA8dgw2utWpLBnVpHVhD59/5HSopGim7/57eeH3bx4g9VzZg==
X-Received: by 2002:aa7:8a47:: with SMTP id n7mr6646437pfa.182.1566578801249;
        Fri, 23 Aug 2019 09:46:41 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id g8sm2518593pgk.1.2019.08.23.09.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:46:40 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
Date:   Fri, 23 Aug 2019 09:46:39 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <E18E14E3-3EC2-4A74-BB51-726FCDDA3881@gmail.com>
In-Reply-To: <20190822091306.20581-3-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
 <20190822091306.20581-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 2:13, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> The state variable was read, and written outside the control mutex
> (struct xdp_sock, mutex), without proper barriers and {READ,
> WRITE}_ONCE correctness.
>
> In this commit this issue is addressed, and the state member is now
> used a point of synchronization whether the socket is setup correctly
> or not.
>
> This also fixes a race, found by syzcaller, in xsk_poll() where umem
> could be accessed when stale.
>
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP 
> rings")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c | 57 
> ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f3351013c2a5..31236e61069b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, 
> struct xdp_buff *xdp, u32 len)
>  	return err;
>  }
>
> +static bool xsk_is_bound(struct xdp_sock *xs)
> +{
> +	if (READ_ONCE(xs->state) == XSK_BOUND) {
> +		/* Matches smp_wmb() in bind(). */
> +		smp_rmb();
> +		return true;
> +	}
> +	return false;
> +}
> +
>  int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
>  	u32 len;
>
> +	if (!xsk_is_bound(xs))
> +		return -EINVAL;
> +
>  	if (xs->dev != xdp->rxq->dev || xs->queue_id != 
> xdp->rxq->queue_index)
>  		return -EINVAL;
>
> @@ -362,6 +375,8 @@ static int xsk_sendmsg(struct socket *sock, struct 
> msghdr *m, size_t total_len)
>  	struct sock *sk = sock->sk;
>  	struct xdp_sock *xs = xdp_sk(sk);
>
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return -ENXIO;
>  	if (unlikely(!xs->dev))
>  		return -ENXIO;

Can probably remove the xs->dev check now, replaced by checking 
xs->state, right?


>  	if (unlikely(!(xs->dev->flags & IFF_UP)))
> @@ -378,10 +393,15 @@ static unsigned int xsk_poll(struct file *file, 
> struct socket *sock,
>  			     struct poll_table_struct *wait)
>  {
>  	unsigned int mask = datagram_poll(file, sock, wait);
> -	struct sock *sk = sock->sk;
> -	struct xdp_sock *xs = xdp_sk(sk);
> -	struct net_device *dev = xs->dev;
> -	struct xdp_umem *umem = xs->umem;
> +	struct xdp_sock *xs = xdp_sk(sock->sk);
> +	struct net_device *dev;
> +	struct xdp_umem *umem;
> +
> +	if (unlikely(!xsk_is_bound(xs)))
> +		return mask;
> +
> +	dev = xs->dev;
> +	umem = xs->umem;
>
>  	if (umem->need_wakeup)
>  		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> @@ -417,10 +437,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>  {
>  	struct net_device *dev = xs->dev;
>
> -	if (!dev || xs->state != XSK_BOUND)
> +	if (xs->state != XSK_BOUND)
>  		return;
> -
> -	xs->state = XSK_UNBOUND;
> +	WRITE_ONCE(xs->state, XSK_UNBOUND);
>
>  	/* Wait for driver to stop using the xdp socket. */
>  	xdp_del_sk_umem(xs->umem, xs);
> @@ -495,7 +514,9 @@ static int xsk_release(struct socket *sock)
>  	local_bh_enable();
>
>  	xsk_delete_from_maps(xs);
> +	mutex_lock(&xs->mutex);
>  	xsk_unbind_dev(xs);
> +	mutex_unlock(&xs->mutex);
>
>  	xskq_destroy(xs->rx);
>  	xskq_destroy(xs->tx);
> @@ -589,19 +610,18 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  		}
>
>  		umem_xs = xdp_sk(sock->sk);
> -		if (!umem_xs->umem) {
> -			/* No umem to inherit. */
> +		if (!xsk_is_bound(umem_xs)) {
>  			err = -EBADF;
>  			sockfd_put(sock);
>  			goto out_unlock;
> -		} else if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
> +		}
> +		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
>  			err = -EINVAL;
>  			sockfd_put(sock);
>  			goto out_unlock;
>  		}
> -
>  		xdp_get_umem(umem_xs->umem);
> -		xs->umem = umem_xs->umem;
> +		WRITE_ONCE(xs->umem, umem_xs->umem);
>  		sockfd_put(sock);
>  	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
>  		err = -EINVAL;
> @@ -626,10 +646,15 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  	xdp_add_sk_umem(xs->umem, xs);
>
>  out_unlock:
> -	if (err)
> +	if (err) {
>  		dev_put(dev);
> -	else
> -		xs->state = XSK_BOUND;
> +	} else {
> +		/* Matches smp_rmb() in bind() for shared umem
> +		 * sockets, and xsk_is_bound().
> +		 */
> +		smp_wmb();
> +		WRITE_ONCE(xs->state, XSK_BOUND);
> +	}
>  out_release:
>  	mutex_unlock(&xs->mutex);
>  	rtnl_unlock();
> @@ -869,7 +894,7 @@ static int xsk_mmap(struct file *file, struct 
> socket *sock,
>  	unsigned long pfn;
>  	struct page *qpg;
>
> -	if (xs->state != XSK_READY)
> +	if (READ_ONCE(xs->state) != XSK_READY)
>  		return -EBUSY;
>
>  	if (offset == XDP_PGOFF_RX_RING) {
> -- 
> 2.20.1
