Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64F837BC6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfFFSDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:03:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39646 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:03:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so1977662pfe.6;
        Thu, 06 Jun 2019 11:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=vL/yJFjtKE26N8WppeIL8DymV0OTQcN/8h3vh7inQew=;
        b=IFN7rlmIbyt4XlgxMONME0XVhDVkFm4/1VckRnhxVZgALeXceWARI58K7ZtGHpKwOy
         L5Kr/+0Y6h16yPS6wINB6v5GwmzYnv8/ROmq8FDfXI2OChdFeehg5PTa+6E9rn07F1/c
         86Bjl/RxTuS9675ElTVkQ08H1BugEjAEStdtVAFSEjn0vuy2IL1eeIigSXH53HnEmEiq
         O6i/7I3Z30JHDLj6OZHCCYg49GCvhr+8x838/5cttfZtDVtgyFT6LKL92FY4YEHRFFAg
         9NpjqI95GwWz7JrVJ2Vw4C8hvOYaqyfeKSUBWYLP0SIBqpnWSWHbOGeaVCQl9zRtEeDg
         HQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=vL/yJFjtKE26N8WppeIL8DymV0OTQcN/8h3vh7inQew=;
        b=FfeP4oI6FbzcPEBgNw1/zXbxaI7M26EDyBDJFjgjnrgw5FchJID1TibeUOwMc7/wRm
         IcA9TGA1lo0sSrdr8C3MOKPUtyBATiXb+IkcljQ10UMaBhGIPDPTCr9A+6poVcLtws/C
         E0GPyEGzKy+0wFW/gT+VOYVosfls3TKpaEDnApQct7+EbPjsFJFBdb2g6EtAqLKk2zqS
         bC78E4+4lQaPrA7Xt/T6Z3zKspulqB5DaI8euRiSopxfyxTPkC825lgiQWTB/whPeVi1
         knUInvh8GaztguXc5MpUuc0Ama+Ii6ZO4EyZwrO64qvhd3CSNbdUbMF/Nd5X2sjfn1Xl
         pLSg==
X-Gm-Message-State: APjAAAUkkyzO3E+okDaSeLO3s7uufceCeZuEb38eaOFVrJNfFmHxsmVg
        Q7A2mmCRVdzXCOefP6DJmEw=
X-Google-Smtp-Source: APXvYqyfjbd021wZbVjBB+70qJRPXGTgTljHe/nVnBfkUy4Y3ButrRqFGUdwG5ulgCJppMyvpTGiDA==
X-Received: by 2002:a62:1a93:: with SMTP id a141mr54671966pfa.72.1559844220056;
        Thu, 06 Jun 2019 11:03:40 -0700 (PDT)
Received: from [172.26.126.80] ([2620:10d:c090:180::1:627e])
        by smtp.gmail.com with ESMTPSA id h2sm2125014pgs.17.2019.06.06.11.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 11:03:39 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>
Subject: Re: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
Date:   Thu, 06 Jun 2019 11:03:38 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
In-Reply-To: <20190606124014.23231-1-i.maximets@samsung.com>
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
 <20190606124014.23231-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6 Jun 2019, at 5:40, Ilya Maximets wrote:

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
> Fix that by counting XDP references for the device and failing
> RTM_DELLINK with EBUSY if device is still in use by any XDP socket.
>
> With this change:
>
>   # ip link del p1
>   RTNETLINK answers: Device or resource busy
>
> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>
> Another option could be to force closing all the corresponding AF_XDP
> sockets, but I didn't figure out how to do this properly yet.
>
>  include/linux/netdevice.h | 25 +++++++++++++++++++++++++
>  net/core/dev.c            | 10 ++++++++++
>  net/core/rtnetlink.c      |  6 ++++++
>  net/xdp/xsk.c             |  7 ++++++-
>  4 files changed, 47 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 44b47e9df94a..24451cfc5590 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
>   *	@watchdog_timer:	List of timers
>   *
>   *	@pcpu_refcnt:		Number of references to this device
> + *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
>   *	@todo_list:		Delayed register/unregister
>   *	@link_watch_list:	XXX: need comments on this one
>   *
> @@ -1966,6 +1967,7 @@ struct net_device {
>  	struct timer_list	watchdog_timer;
>
>  	int __percpu		*pcpu_refcnt;
> +	int __percpu		*pcpu_xdp_refcnt;
>  	struct list_head	todo_list;


I understand the intention here, but don't think that putting a XDP reference
into the generic netdev structure is the right way of doing this.  Likely the
NETDEV_UNREGISTER notifier should be used so the socket and umem unbinds from
the device.
-- 
Jonathan
