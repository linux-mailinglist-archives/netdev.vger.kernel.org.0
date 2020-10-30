Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4931D2A0F93
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgJ3UgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgJ3UgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:36:15 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4A8C0613CF;
        Fri, 30 Oct 2020 13:36:15 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id l26so1888315oop.9;
        Fri, 30 Oct 2020 13:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ihg3mhJojtwO7pwU24A1IQ80IyOv+3PcZVgNS7+kyNQ=;
        b=ZOuYFIirYbVtmTcomhC8JrIM/xZIHsmrUhC5miDAKiUGHU0DZNw3SoZNCYMhzyqS6o
         qAt6rioZjfOE/vEQ+bPenCtGcfe8cxRrGS6xbspGWTMzQHduNMdLrNuGOARwcMuZX2GX
         dDY58/W8dLcHbLfR81C0P82gZQDLoC6aeP/W3N7zfyj/FR0AjrLCVQm8TfXr97XwyOVs
         px79vtOFWWP0emFCOLTzB/mNx7je6diPqTWlhREdOd/9BJtQCwMtkfcIoElSpbRGBh0X
         xxqzkrCjEgGOPKO76cVvwdGRG70Bm1NnRyL3iqJMfEQ1UOPTaLxWBF6nTZKCbUQY6Ywr
         1mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ihg3mhJojtwO7pwU24A1IQ80IyOv+3PcZVgNS7+kyNQ=;
        b=CsMLbWGgMtfy9qV7f0VOz3RVv94ekPGZDwBPIiZkTbsKFMQ86wkl+1BderbRGNzksJ
         z5+evxO+qTiD23e6U7566KbDBrPfaojlpsfW2u+7GiYoDm5W1ucWtSGGA6zMlIu4vwM1
         yN8Q3MRntfXmlXDmZO5J5sybxZ9qRp8Msb5ulgWFR/he03JRuqE6pMNwJwT+RIlbU3vT
         KgvCFOQ2ixko9iN4lhiuyQUaYEoCyb6+mk7z9WBjQP23BwTFBgCoR4OhGrFGnaJR1T/R
         AOfpLJc1llMCBikGrXP29L/svYlG1kJetupYNEgeqhZ5qNwJKgFHBKEHWEWJOZ/9E5vu
         bLGg==
X-Gm-Message-State: AOAM530FNQIelLKp8qm4VoBllocrLCtZvWcRMiUD7w6nE0lswE9Z6hbS
        KygpFrE4bXW5hngtTGj2ltwzWpR57kRglQ==
X-Google-Smtp-Source: ABdhPJx/0VqE4OOxeSkRkcbYdqrTTzlC8OrjQFBeSqVvQ+NHLPGYt/y4tVgOyVSlhhS+79ed4khWsg==
X-Received: by 2002:a4a:5182:: with SMTP id s124mr3298150ooa.88.1604090174670;
        Fri, 30 Oct 2020 13:36:14 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s27sm1570253otg.80.2020.10.30.13.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 13:36:14 -0700 (PDT)
Date:   Fri, 30 Oct 2020 13:36:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5f9c7935c6991_16d420838@john-XPS-13-9370.notmuch>
In-Reply-To: <160407666748.1525159.1515139110258948831.stgit@firesoul>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407666748.1525159.1515139110258948831.stgit@firesoul>
Subject: RE: [PATCH bpf-next V5 4/5] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The use-case for dropping the MTU check when TC-BPF does redirect to
> ingress, is described by Eyal Birger in email[0]. The summary is the
> ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> ingress redirect packet and let normal netstack fragment packet as needed.
> 
> [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> 
> V4:
>  - Keep net_device "up" (IFF_UP) check.
>  - Adjustment to handle bpf_redirect_peer() helper
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
>  net/core/dev.c            |   19 ++-----------------
>  net/core/filter.c         |   14 +++++++++++---
>  3 files changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 964b494b0e8d..bd02ddab8dfe 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3891,11 +3891,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
>  bool is_skb_forwardable(const struct net_device *dev,
>  			const struct sk_buff *skb);
>  
> +static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
> +						 const struct sk_buff *skb,
> +						 const bool check_mtu)

It looks like if check_mtu=false then this is just an interface up check.
Can we leave is_skb_forwardable logic alone and just change the spots where
this is called with false to something with a name that describes the check,
such as is_dev_up(dev). I think it will make this change smaller and the
code easier to read. Did I miss something?

> +{
> +	const u32 vlan_hdr_len = 4; /* VLAN_HLEN */
> +	unsigned int len;
> +
> +	if (!(dev->flags & IFF_UP))
> +		return false;
> +
> +	if (!check_mtu)
> +		return true;
> +
> +	len = dev->mtu + dev->hard_header_len + vlan_hdr_len;
> +	if (skb->len <= len)
> +		return true;
> +
> +	/* if TSO is enabled, we don't care about the length as the packet
> +	 * could be forwarded without being segmented before
> +	 */
> +	if (skb_is_gso(skb))
> +		return true;
> +
> +	return false;
> +}
> +
>  static __always_inline int ____dev_forward_skb(struct net_device *dev,
> -					       struct sk_buff *skb)
> +					       struct sk_buff *skb,
> +					       const bool check_mtu)
>  {

I guess you will get some duplication here if you have a dev_forward_skb()
and a dev_forward_skb_nocheck() or something. Take it or leave it. I know
I've added my share of bool swivel bits like this, but better to avoid
it if possible IMO.

Other than style aspects it looks correct to me.

>  	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> -	    unlikely(!is_skb_forwardable(dev, skb))) {
> +	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
>  		atomic_long_inc(&dev->rx_dropped);
>  		kfree_skb(skb);
>  		return NET_RX_DROP;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9499a414d67e..445ccf92c149 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2188,28 +2188,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
>  
