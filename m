Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC73BDBF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbfFJUr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:47:57 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36491 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389429AbfFJUr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 16:47:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so84494pfl.3;
        Mon, 10 Jun 2019 13:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=9FIvf0wdVvsh5I953IzVSfOkHxWGo3u/M3vEl9IVjf4=;
        b=dyo3HAQCVAXrKSUS/OuygXcHmDusgpOEkKSWnmNchqonJxYZXEUPC0DkQ36pdi7Ar0
         KARN/uVRF2ozIIBwvYLFiH55asDk+maKte0fddLEbvBs2cP4Y8UE8tU2PsSm18xFu32Q
         vq/7/zdh93XIfv28anmqwej7k1W3UMC+K8yrZNdTsx1emRpbpY2AaXiXCgBYrtFrmaC1
         Tv2Z9Gj3qL929kjCpu4izt58CwCj85IER8dtIxqLG16XRI9dOgYdkij9+NxYtpL3h20H
         CGBDeG/6xwshMWB7J8RmbDtMwfz0fKnQu/qaorPwI/bRMna20YY+b+jmcfYzHeSB6DTU
         Qa/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=9FIvf0wdVvsh5I953IzVSfOkHxWGo3u/M3vEl9IVjf4=;
        b=c1iGpAdDmmtJ3hGPcQ1Gl/FzeagHUey76E2AKDROC8cZEGXgJ1s30dzc3kX8LoYqUs
         jYZTYMGTomP9G9KR3z8JKxjwnZCgPlVyYWkOp4gD/K+umJ7ZWW3eR0fRUl7wZXc5EOR1
         72UR0v7qNlMkaS4dCR+i6DeqtcwBggVoyZDbyfAQNFAGb8pJcd0BPWkELtEUTJhoHBJ1
         KdnQdhSdZPbkofcay5NJok709D6nypnp0S7SwWUNfm25/8JsjImupv6tgiqytW9wvL/x
         HYWHNXWLsmtpzRVgvqiCs/a4xYhNyHrAHpmBfdw5GgHNXqXtrfoTnLJOT1LFy5wZGSLI
         imtQ==
X-Gm-Message-State: APjAAAX7fTy8HngD7WBDTpFyVQffn4eCfmp7FioDJFiD0Ct1N1Dwb0vi
        pXbbz1gtFCuxJx7H4HT54zxoVYMLWLI=
X-Google-Smtp-Source: APXvYqx7Q2aQkAXzVIegtQdOQ+87SITbXXreG8ofxTybxcwyRH/MJGlT5c5dytHzHzzj//q7XWREnw==
X-Received: by 2002:aa7:8013:: with SMTP id j19mr14391055pfi.212.1560199676141;
        Mon, 10 Jun 2019 13:47:56 -0700 (PDT)
Received: from [172.20.174.171] ([2620:10d:c090:180::1:1558])
        by smtp.gmail.com with ESMTPSA id d19sm310809pjs.22.2019.06.10.13.47.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 13:47:55 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
Date:   Mon, 10 Jun 2019 13:47:54 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <06C99519-64B9-4A91-96B9-0F99731E3857@gmail.com>
In-Reply-To: <20190610161546.30569-1-i.maximets@samsung.com>
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
 <20190610161546.30569-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Jun 2019, at 9:15, Ilya Maximets wrote:

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
>
> Version 3:
>
>     * Declaration lines ordered from longest to shortest.
>     * Checking of event type moved to the top to avoid unnecessary
>       locking.
>
> Version 2:
>
>     * Completely re-implemented using netdev event handler.
>
>  net/xdp/xsk.c | 65 
> ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..273a419a8c4d 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct 
> socket *sock,
>  			       size, vma->vm_page_prot);
>  }
>
> +static int xsk_notifier(struct notifier_block *this,
> +			unsigned long msg, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct net *net = dev_net(dev);
> +	int i, unregister_count = 0;
> +	struct sock *sk;
> +
> +	switch (msg) {
> +	case NETDEV_UNREGISTER:
> +		mutex_lock(&net->xdp.lock);

The call is under the rtnl lock, and we're not modifying
the list, so this mutex shouldn't be needed.


> +		sk_for_each(sk, &net->xdp.list) {
> +			struct xdp_sock *xs = xdp_sk(sk);
> +
> +			mutex_lock(&xs->mutex);
> +			if (dev != xs->dev) {
> +				mutex_unlock(&xs->mutex);
> +				continue;
> +			}
> +
> +			sk->sk_err = ENETDOWN;
> +			if (!sock_flag(sk, SOCK_DEAD))
> +				sk->sk_error_report(sk);
> +
> +			/* Wait for driver to stop using the xdp socket. */
> +			xdp_del_sk_umem(xs->umem, xs);
> +			xs->dev = NULL;
> +			synchronize_net();
Isn't this by handled by the unregister_count case below?

> +
> +			/* Clear device references in umem. */
> +			xdp_put_umem(xs->umem);
> +			xs->umem = NULL;

This makes me uneasy.  We need to unregister the umem from
the device (xdp_umem_clear_dev()) but this can remove the umem
pages out from underneath the xsk.

Perhaps what's needed here is the equivalent of an unbind()
call that just detaches the umem/sk from the device, but does
not otherwise tear them down.


> +			mutex_unlock(&xs->mutex);
> +			unregister_count++;
> +		}
> +		mutex_unlock(&net->xdp.lock);
> +
> +		if (unregister_count) {
> +			/* Wait for umem clearing completion. */
> +			synchronize_net();
> +			for (i = 0; i < unregister_count; i++)
> +				dev_put(dev);
> +		}
> +
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static struct proto xsk_proto = {
>  	.name =		"XDP",
>  	.owner =	THIS_MODULE,
> @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
>  	if (!sock_flag(sk, SOCK_DEAD))
>  		return;
>
> -	xdp_put_umem(xs->umem);
> +	if (xs->umem)
> +		xdp_put_umem(xs->umem);
Not needed - xdp_put_umem() already does a null check.
-- 
Jonathan


>
>  	sk_refcnt_debug_dec(sk);
>  }
> @@ -784,6 +836,10 @@ static const struct net_proto_family 
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
> @@ -816,8 +872,15 @@ static int __init xsk_init(void)
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
