Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977AE63687C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiKWSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbiKWSNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:13:50 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BEC697F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 10:10:21 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E276C5C006C;
        Wed, 23 Nov 2022 13:10:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 23 Nov 2022 13:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1669227018; x=
        1669313418; bh=DpdO/3xOyV2ft6CakRajjajX4b/UNb4Jfcv5jd+O74Q=; b=P
        0K/ETe45xT0lCw7InimYJB1HkGEx5690IY+wX+dCIhP/j7L2wzfOCQNYjpGNGYvE
        M5HvvQ/YTqAgLjn8Z4k0x90l/e6qFKf6VDx8shmNudQDbj3Z5tMeDwmlhn+ERe/O
        MgCkFJ4TjwCUxnleCvtDD5rNSvKqo1nzWjScy6+hdonuZw59ommZTXNTbu1SlrWG
        kCbsBQDjgXzFiaxlj0/WJ8i8u1sADny/33DOtxHNG+1tYUHQkfRgHvf1J/AsjCJ0
        iLGPgMLOHkol9PgHk4sc8SNv+78qE+1f9hK04GEQ6t+QmAKeyOc6f+lWXnLRpUWU
        OU6ffxwfmVlK9z83Gwk7Q==
X-ME-Sender: <xms:CmJ-Y83_KLkZBHnwNtS1joDQwW3wDxT2CcjCmXFpchLRMCLx6HLiQQ>
    <xme:CmJ-Y3E0OYsz0iqadZIP7OWo5emtbyJsAjZIPFjXJDmCHX3CEequSXiTcY8fnvUWP
    wqn3eOLbDzN3cA>
X-ME-Received: <xmr:CmJ-Y04yBfqXkSenmd8FPJZ8rRMzNLymMfuVQoHe7fjZC2iVV4UHfv4mUhY8fETX3E52bO0_kk3N4xqR9XrBLjrFpOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedriedugddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepkeeggfeghfeuvdegtedtgedvue
    dvhfdujedvvdejteelvdeutdehheellefhhfdunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CmJ-Y13rM2gRbPkOp4abSMiZCMARWH7DR4zK3aJ-BMfGUwyYYgycEQ>
    <xmx:CmJ-Y_GIkN-hmz_zulGZTOTV9TvHIYyKwRk-L1aiJgx4erQdYEcNvQ>
    <xmx:CmJ-Y-9wpciYm8dRzPqxgTaQKUyRl6tz1GhW2pc6sNzH3z5enF1d0w>
    <xmx:CmJ-Yzhw8PzYGwAk8ycnPb80sEAM8OCzBun4r3u_Tn41hwv9DJLXWg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Nov 2022 13:10:17 -0500 (EST)
Date:   Wed, 23 Nov 2022 20:10:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     nb <nikolay.borisov@virtuozzo.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@virtuozzo.com
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Message-ID: <Y35iBgeq5iKyTmfT@shredder>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
 <Y345WyXayWF/2eDJ@shredder>
 <7a8bf56c-3db8-63c2-8440-7bbbfb4901ac@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a8bf56c-3db8-63c2-8440-7bbbfb4901ac@virtuozzo.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:21:23PM +0200, nb wrote:
> 
> 
> On 23.11.22 г. 17:16 ч., Ido Schimmel wrote:
> > On Wed, Nov 23, 2022 at 04:28:15PM +0200, Nikolay Borisov wrote:
> > >   static void trace_drop_common(struct sk_buff *skb, void *location)
> > >   {
> > >   	struct net_dm_alert_msg *msg;
> > > @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> > >   	int i;
> > >   	struct sk_buff *dskb;
> > >   	struct per_cpu_dm_data *data;
> > > -	unsigned long flags;
> > > +	unsigned long flags, ns_id = 0;
> > > +
> > > +	if (skb->dev && net_dm_ns &&
> > > +	    dev_net(skb->dev)->ns.inum != net_dm_ns)
> > 
> > I don't think this is going to work, unfortunately. 'skb->dev' is in a
> > union with 'dev_scratch' so 'skb->dev' does not necessarily point to a
> > valid netdev at all times. It can explode when dev_net() tries to
> > dereference it.
> > 
> > __skb_flow_dissect() is doing something similar, but I believe there the
> > code paths were audited to make sure it is safe.
> > 
> > Did you consider achieving this functionality with a BPF program
> > attached to skb::kfree_skb tracepoint? I believe BPF programs are run
> > with page faults disabled, so it should be safe to attempt this there.
> 
> How would that be different than the trace_drop_common which is called as
> part of the trace_kfree_skb, as it's really passed as trace point probe via:

Consider this call path:

__udp_queue_rcv_skb()
    __udp_enqueue_schedule_skb()
        udp_set_dev_scratch() // skb->dev is not NULL, but not a pointer to a netdev either
	// error is returned
    kfree_skb_reason() // probe is called

dev_net(skb->dev) in the probe will try to dereference skb->dev and
crash.

On the other hand, a BPF program that is registered as another probe on
the tracepoint will access the memory via bpf_probe_read_kernel(), which
will try to safely read the memory and return an error if it can't. You
can do that today without any kernel changes.
