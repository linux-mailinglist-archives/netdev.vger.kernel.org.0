Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0096D63A254
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiK1Hy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiK1Hy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:54:57 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE3B1582E
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 23:54:56 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F9AD5C00BF;
        Mon, 28 Nov 2022 02:54:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 28 Nov 2022 02:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1669622095; x=
        1669708495; bh=A/mwzHs/0UYBA4v/5ce7hr1N+4vVioIhSVJO0ZkTGYE=; b=V
        ddhyVbU7kgm01kFR3nUj8ZECizDULgP7OjiyjZ5YlWPjXMDIKevyAMMExjzMTJg1
        Nx19galzXaChbmwbiWt7jlqmiQNrqt7kUzIFlE3rd7eNThZzNzi9L2dSUcSbGev+
        T3J4TQQaSjszSfEMLjUl9+0WPxyx13YJAmkDIoK6ZgyoiiVJZ2wy2rKmWzfzeynx
        GOFrwUEUFdYYjzgRv590gIGARsWJR1jNPdojaLBsBZDQZZoj1mqrPlgfjvelky9u
        d9T7sDt3zLoii65E7a7zjFwJ3HYIuAwuiz+pz5H6cu/uYXS8bgPz6I4ywuTftDqB
        ZAaVsGJNFeOFw8Huj6dDg==
X-ME-Sender: <xms:T2mEY6bekqa_1EpZPv9oLMc7b8BYrOqsjz1zeOhTPCWkbc0hdgcXPg>
    <xme:T2mEY9YMkF0t9IxvbkO_Fd1uAJ04BCXlHUf3Br9vuYFWtq7HpQQKsFBUMuZxJNEZj
    v3YBtaiE5degMI>
X-ME-Received: <xmr:T2mEY08ThqK_VAJ-MOAhTlr7IFOk63QKQgugNXHR63_BpDnSwYSFDGh4cWW->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepkeeggfeghfeuvdegtedtgedvue
    dvhfdujedvvdejteelvdeutdehheellefhhfdunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:T2mEY8qeJjzvh1iw5G5tJXddEJWOaGLsG__EVLWSVpmBZRg0hSyj9g>
    <xmx:T2mEY1rclhlBRHHMpnYsclJLO6E5KWYpdEeuzoEpzz1C8v53vJoAiw>
    <xmx:T2mEY6RKEx80SD2xFlGHZ_B9XAEw6nwywB0evRm1XfIOKGhzfYIGRg>
    <xmx:T2mEY2lRpGQpY4YX_c8G_WlrvznaTR9IWkpsIX0VfSJvUapeBeG34w>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Nov 2022 02:54:54 -0500 (EST)
Date:   Mon, 28 Nov 2022 09:54:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     nb <nikolay.borisov@virtuozzo.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@openvz.org
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Message-ID: <Y4RpTM8141eTNhsD@shredder>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
 <Y345WyXayWF/2eDJ@shredder>
 <7a8bf56c-3db8-63c2-8440-7bbbfb4901ac@virtuozzo.com>
 <Y35iBgeq5iKyTmfT@shredder>
 <8c6aee78-2247-bcd5-ea48-b76652745301@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c6aee78-2247-bcd5-ea48-b76652745301@virtuozzo.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 01:41:38PM +0200, nb wrote:
> 
> 
> On 23.11.22 г. 20:10 ч., Ido Schimmel wrote:
> > On Wed, Nov 23, 2022 at 05:21:23PM +0200, nb wrote:
> > > 
> > > 
> > > On 23.11.22 г. 17:16 ч., Ido Schimmel wrote:
> > > > On Wed, Nov 23, 2022 at 04:28:15PM +0200, Nikolay Borisov wrote:
> > > > >    static void trace_drop_common(struct sk_buff *skb, void *location)
> > > > >    {
> > > > >    	struct net_dm_alert_msg *msg;
> > > > > @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> > > > >    	int i;
> > > > >    	struct sk_buff *dskb;
> > > > >    	struct per_cpu_dm_data *data;
> > > > > -	unsigned long flags;
> > > > > +	unsigned long flags, ns_id = 0;
> > > > > +
> > > > > +	if (skb->dev && net_dm_ns &&
> > > > > +	    dev_net(skb->dev)->ns.inum != net_dm_ns)
> > > > 
> > > > I don't think this is going to work, unfortunately. 'skb->dev' is in a
> > > > union with 'dev_scratch' so 'skb->dev' does not necessarily point to a
> > > > valid netdev at all times. It can explode when dev_net() tries to
> > > > dereference it.
> > > > 
> > > > __skb_flow_dissect() is doing something similar, but I believe there the
> > > > code paths were audited to make sure it is safe.
> > > > 
> > > > Did you consider achieving this functionality with a BPF program
> > > > attached to skb::kfree_skb tracepoint? I believe BPF programs are run
> > > > with page faults disabled, so it should be safe to attempt this there.
> > > 
> > > How would that be different than the trace_drop_common which is called as
> > > part of the trace_kfree_skb, as it's really passed as trace point probe via:
> > 
> > Consider this call path:
> > 
> > __udp_queue_rcv_skb()
> >      __udp_enqueue_schedule_skb()
> >          udp_set_dev_scratch() // skb->dev is not NULL, but not a pointer to a netdev either
> > 	// error is returned
> >      kfree_skb_reason() // probe is called
> > 
> > dev_net(skb->dev) in the probe will try to dereference skb->dev and
> > crash.
> 
> This can easily be rectified by using is_kernel() .

The layout of 'struct udp_dev_scratch' is not fixed and it can be
arranged to contain values that make it seem like a valid kernel
address, but does not actually point to a 'struct net_device'.

> 
> > 
> > On the other hand, a BPF program that is registered as another probe on
> > the tracepoint will access the memory via bpf_probe_read_kernel(), which
> > will try to safely read the memory and return an error if it can't. You
> > can do that today without any kernel changes.
> 
> I did a PoC for this and indeed it works, however I'd still like to pursue
> this code provided there is upstream interest.
