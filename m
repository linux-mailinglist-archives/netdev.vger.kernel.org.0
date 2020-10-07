Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14779286AF2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 00:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgJGWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgJGWhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 18:37:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29855C061755;
        Wed,  7 Oct 2020 15:37:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u6so4218171iow.9;
        Wed, 07 Oct 2020 15:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+nCZGaCKql0nmWslwGogtqp1JQBKN8StPxSFOo545Nc=;
        b=cQl+zYM87AlFkL4GDXnM1vzw9Ux/JZjkbrVqQayOBh7zEUPwXxQLEq7j7e+8+lPW+/
         /LmPZdZ0ksdAuUcZmkdJpz0zR4DUSoj2YTkXYZyE7pg+qRyB8Cbmpx2+l+VVfp2sEStX
         qLowK5l9ArN5rApwCqCeR1RFsXIBSBspBsQMQNqZ0Y7e+D7d+FxnA3Xww52mOtd3VnWY
         bBOYxCIcDVehnL/EuOEXdzRXrcHnyi6IOBSPwPLilZDSYpB/2q6Qq0zqBr+3KTw9hZCC
         QV9w81mIc3tnrp0TOmnLUoTiS1k6GhYbOmwiSNzht/ynY88MNXbUiXg9xltHiNzga8yM
         9/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+nCZGaCKql0nmWslwGogtqp1JQBKN8StPxSFOo545Nc=;
        b=QCeYkWWYfSQAilG7wI3Sr9NEm16KaQWD3l0ENGtFOW0NlFgRmC3EuF30kfWSWoGg1j
         PQN4pvSinsUUHPw9GAnE/iFCdliu6Arw41DvHzYzCvNbMognR6kwl24LjxeXSMdGZpih
         5re3wLRWtOcdh2zFCgVvAtDYqZYmZG/OE8wNY5eUrdHq1GL70giMWQk/8Sx9GmfgqyND
         hi6oYnQD49sBq/kLECZxB2neJ0FJWHFcoCTh2ynjHPJNlnsP9GSupkGZkNk9U3thHcWo
         LR/f0Di4lEpPrOFvKZTpy71DGAMnSEnquZhlzioIilYDwyhduhvFKo5jM+V9WMnTt5/W
         hNjw==
X-Gm-Message-State: AOAM531MivAcj7PAuAG+GXenApxsDKjlsFXzLtgpq0ZKIq9RSVESsfYe
        w8vv6nl+92Fj42jn2ToJTzk=
X-Google-Smtp-Source: ABdhPJwPeX0EkdeZ6flmXCvR6Rb1gA5vcYwM7e1RhctXzHWnP5P2L4oY8jvDkhWHV4V/aYKM+cOKVg==
X-Received: by 2002:a02:a196:: with SMTP id n22mr4755191jah.104.1602110226326;
        Wed, 07 Oct 2020 15:37:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l4sm1676859ilk.14.2020.10.07.15.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 15:37:05 -0700 (PDT)
Date:   Wed, 07 Oct 2020 15:36:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5f7e430ae158b_1a8312084d@john-XPS-13-9370.notmuch>
In-Reply-To: <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
 <160208778070.798237.16265441131909465819.stgit@firesoul>
 <7aeb6082-48a3-9b71-2e2c-10adeb5ee79a@iogearbox.net>
Subject: Re: [PATCH bpf-next V2 5/6] bpf: Add MTU check for TC-BPF packets
 after egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 10/7/20 6:23 PM, Jesper Dangaard Brouer wrote:
> [...]
> >   net/core/dev.c |   24 ++++++++++++++++++++++--
> >   1 file changed, 22 insertions(+), 2 deletions(-)

Couple high-level comments. Whats the problem with just letting the driver
consume the packet? I would chalk it up to a buggy BPF program that is
sending these packets. The drivers really shouldn't panic or do anything
horrible under this case because even today I don't think we can be
100% certain MTU on skb matches set MTU. Imagine the case where I change
the MTU from 9kB->1500B there will be some skbs in-flight with the larger
length and some with the shorter. If the drivers panic/fault or otherwise
does something else horrible thats not going to be friendly in general case
regardless of what BPF does. And seeing this type of config is all done
async its tricky (not practical) to flush any skbs in-flight.

I've spent many hours debugging these types of feature flag, mtu
change bugs on the driver side I'm not sure it can be resolved by
the stack easily. Better to just build drivers that can handle it IMO.

Do we know if sending >MTU size skbs to drivers causes problems in real
cases? I haven't tried on the NICs I have here, but I expect they should
be fine. Fine here being system keeps running as expected. Dropping the
skb either on TX or RX side is expected. Even with this change though
its possible for the skb to slip through if I configure MTU on a live
system.

> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b433098896b2..19406013f93e 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3870,6 +3870,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >   	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
> >   	case TC_ACT_OK:
> >   	case TC_ACT_RECLASSIFY:
> > +		*ret = NET_XMIT_SUCCESS;
> >   		skb->tc_index = TC_H_MIN(cl_res.classid);
> >   		break;
> >   	case TC_ACT_SHOT:
> > @@ -4064,9 +4065,12 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   {
> >   	struct net_device *dev = skb->dev;
> >   	struct netdev_queue *txq;
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	bool mtu_check = false;
> > +#endif
> > +	bool again = false;
> >   	struct Qdisc *q;
> >   	int rc = -ENOMEM;
> > -	bool again = false;
> >   
> >   	skb_reset_mac_header(skb);
> >   
> > @@ -4082,14 +4086,28 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   
> >   	qdisc_pkt_len_init(skb);
> >   #ifdef CONFIG_NET_CLS_ACT
> > +	mtu_check = skb_is_redirected(skb);
> >   	skb->tc_at_ingress = 0;
> >   # ifdef CONFIG_NET_EGRESS
> >   	if (static_branch_unlikely(&egress_needed_key)) {
> > +		unsigned int len_orig = skb->len;
> > +
> >   		skb = sch_handle_egress(skb, &rc, dev);
> >   		if (!skb)
> >   			goto out;
> > +		/* BPF-prog ran and could have changed packet size beyond MTU */
> > +		if (rc == NET_XMIT_SUCCESS && skb->len > len_orig)
> > +			mtu_check = true;
> >   	}
> >   # endif
> > +	/* MTU-check only happens on "last" net_device in a redirect sequence
> > +	 * (e.g. above sch_handle_egress can steal SKB and skb_do_redirect it
> > +	 * either ingress or egress to another device).
> > +	 */
> 
> Hmm, quite some overhead in fast path. Also, won't this be checked multiple times
> on stacked devices? :( Moreover, this missed the fact that 'real' qdiscs can have
> filters attached too, this would come after this check. Can't this instead be in
> driver layer for those that really need it? I would probably only drop the check
> as done in 1/6 and allow the BPF prog to do the validation if needed.

Any checks like this should probably go in validate_xmit_skb_list() this is
where we check other things GSO, checksum, etc. that depend on drivers. Worse
case we could add a netif_needs_mtu() case in validate_xmit_skb if drivers
really can't handle >MTU size.

> 
> > +	if (mtu_check && !is_skb_forwardable(dev, skb)) {
> > +		rc = -EMSGSIZE;
> > +		goto drop;
> > +	}
> >   #endif
> >   	/* If device/qdisc don't need skb->dst, release it right now while
> >   	 * its hot in this cpu cache.
> > @@ -4157,7 +4175,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >   
> >   	rc = -ENETDOWN;
> >   	rcu_read_unlock_bh();
> > -
> > +#ifdef CONFIG_NET_CLS_ACT
> > +drop:
> > +#endif
> >   	atomic_long_inc(&dev->tx_dropped);
> >   	kfree_skb_list(skb);
> >   	return rc;
> > 


