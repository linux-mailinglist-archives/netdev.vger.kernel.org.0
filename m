Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F961BEFFA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 08:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgD3GBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 02:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3GBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 02:01:54 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B3BC035494;
        Wed, 29 Apr 2020 23:01:54 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 72so3991864otu.1;
        Wed, 29 Apr 2020 23:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Aa3UitXCFbuTJBux4KS46nQWRa1PCa2MQgyHix6wDug=;
        b=kZgnKradh+4gpoJwCp1MJ3tB7TuolRMw9SwiW7nibfo44Tv9PAsB2xns1+L2Wny7VP
         U5ohBtK306N5Qr5pbHNRlQzHfZL6sCjqd8WS+IkMeKkYuEGEjd9zyWZW8LTb9quPYAg+
         H+Qd3eXvxn5midIIHrT5Du22c9gxboErvMUtsuybABTXCuYN6phvJr20LkfUmUE3IpAS
         56qpB7x4OHUkj4bd1iC1UvVpGfiY1OwB1i/BjYLTP7owSrOmey+7fB7wqMKo0TB6v5iw
         /YFQyqD2pkVBxaVhzxjvOtb2Fqpkl9rWv6h+sX8Ha5exq3nNv47MYsme3sPzrKdqO9Fe
         +B0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aa3UitXCFbuTJBux4KS46nQWRa1PCa2MQgyHix6wDug=;
        b=VSY3jiF/X8fgHYfmca8X3SPsOHi3W++wfFuy2xSe7N8xVDEJfTHhn5p6oaDUg36Rmr
         9UVW1QKHhy5HI6/udVi9qB+q/MNJ6nFejIYyx4KnCQWYQ5PCD0WlWPyvGiIeyG17fnOa
         W//TPuFuDb3ZW9MhNzyuxHMt24WrmV8lw35Urkh6qkqO5GftLzsy4uk1mlw4q/hv2Sye
         zTeHXzR/BjPCZPMWaeXRTcv/rtFIWHG5AZTelRfciL9WDUuhRf0RTEWJ4TFkiZYJsxSz
         WDkS5+XoaYOqLq7noNOJ6tqo3nkf6N4TXz/1wJ/p6mwMCl54NNUbk9W+ZBiMZfG27+Z3
         AGvQ==
X-Gm-Message-State: AGi0PuaqrWupxMeCLw4TPlQgLYSc0duzrgXQOQATA5gNKQ5Pf+jLXs2Y
        HJrR/f8Tyc2p4pzZL3am4cw=
X-Google-Smtp-Source: APiQypJA8lwMHREZR1z8guvVKGBGiHBDYRIAPZ3As+ejNU4wSQHxBl8S78vLQZNAcJrVqvEK+o6ZGA==
X-Received: by 2002:a9d:6391:: with SMTP id w17mr1276881otk.325.1588226513591;
        Wed, 29 Apr 2020 23:01:53 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 10sm993958oto.80.2020.04.29.23.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 23:01:53 -0700 (PDT)
Date:   Wed, 29 Apr 2020 23:01:51 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Message-ID: <20200430060151.GA3548130@ubuntu-s3-xlarge-x86>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
 <20200428175455.2109973-1-natechancellor@gmail.com>
 <MW2PR2101MB10522D4D5EBAB469FE5B4D8BD7AA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10522D4D5EBAB469FE5B4D8BD7AA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Apr 30, 2020 at 12:06:09AM +0000, Michael Kelley wrote:
> From: Nathan Chancellor <natechancellor@gmail.com> Sent: Tuesday, April 28, 2020 10:55 AM
> > 
> > Do note that netvsc_xmit still returns int because netvsc_xmit has a
> > potential return from netvsc_vf_xmit, which does not return netdev_tx_t
> > because of the call to dev_queue_xmit.
> > 
> > I am not sure if that is an oversight that was introduced by
> > commit 0c195567a8f6e ("netvsc: transparent VF management") or if
> > everything works properly as it is now.
> > 
> > My patch is purely concerned with making the definition match the
> > prototype so it should be NFC aside from avoiding the CFI panic.
> > 
> 
> While it probably works correctly now, I'm not too keen on just
> changing the return type for netvsc_start_xmit() and assuming the
> 'int' that is returned from netvsc_xmit() will be correctly mapped to
> the netdev_tx_t enum type.  While that mapping probably happens
> correctly at the moment, this really should have a more holistic fix.

While it might work correctly, I am not sure that the mapping is
correct, hence that comment.

netdev_tx_t is an enum with two acceptable types, 0x00 and 0x10. Up
until commit 0c195567a8f6e ("netvsc: transparent VF management"),
netvsc_xmit was guaranteed to return something of type netdev_tx_t.

However, after said commit, we could return anything from
netvsc_vf_xmit, which in turn calls dev_queue_xmit then
__dev_queue_xmit which will return either an error code (-ENOMEM or
-ENETDOWN) or something from __dev_xmit_skb, which appears to be
NET_XMIT_SUCCESS, NET_XMIT_DROP, or NET_XMIT_CN.

It does not look like netvsc_xmit or netvsc_vf_xmit try to convert those
returns to netdev_tx_t in some way; netvsc_vf_xmit just passes the
return value up to netvsc_xmit, which is the part that I am unsure
about...

> Nathan -- are you willing to look at doing the more holistic fix?  Or
> should we see about asking Haiyang Zhang to do it?

I would be fine trying to look at a more holistic fix but I know
basically nothing about this subsystem. I am unsure if something like
this would be acceptable or if something else needs to happen.
Otherwise, I'd be fine with you guys taking a look and just giving me
reported-by credit.

Cheers,
Nathan

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d8e86bdbfba1e..a39480cfb8fa7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -520,7 +520,8 @@ static int netvsc_vf_xmit(struct net_device *net, struct net_device *vf_netdev,
 	return rc;
 }
 
-static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
+static netdev_tx_t netvsc_xmit(struct sk_buff *skb, struct net_device *net,
+			       bool xdp_tx)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
 	struct hv_netvsc_packet *packet = NULL;
@@ -537,8 +538,11 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	 */
 	vf_netdev = rcu_dereference_bh(net_device_ctx->vf_netdev);
 	if (vf_netdev && netif_running(vf_netdev) &&
-	    !netpoll_tx_running(net))
-		return netvsc_vf_xmit(net, vf_netdev, skb);
+	    !netpoll_tx_running(net)) {
+		if (!netvsc_vf_xmit(net, vf_netdev, skb))
+			return NETDEV_TX_OK;
+		goto drop;
+	}
 
 	/* We will atmost need two pages to describe the rndis
 	 * header. We can only transmit MAX_PAGE_BUFFER_COUNT number
@@ -707,7 +711,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	goto drop;
 }
 
-static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	return netvsc_xmit(skb, ndev, false);
 }
