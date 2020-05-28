Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80C11E5D39
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbgE1KfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387800AbgE1KfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:35:01 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E69C08C5C5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:34:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d7so31521392eja.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ih4qu3nrhFJBc0dVExbD6xtuqEnyjY/tH3t/Hv4k5ro=;
        b=x5nn/LqvtgJ5DSHhWhBqvQv1Qnl6jcIUUfUWyNuo97b2Gk+aArjYpOyTV6vS1FHMyH
         OntsRbK8DDDOmCKp8IVIAdQLr6f+49xp0cfEhYtwd9uns2MyT0PlfIoxIZgBv2KgbTIl
         Z0ySk4sdhgpNk55y2BmqqW+R3VX7W+Te1aIyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ih4qu3nrhFJBc0dVExbD6xtuqEnyjY/tH3t/Hv4k5ro=;
        b=mLSSs2TSVhXShN39uyD7BNtiRupPT6uw/cLzXvdPggmIVbj7gSble0xn60PYpJpCrZ
         OvJYTBPln7tg7icdZO7ywQvr2P26ZvpXNJ23fQlByaEr9cj0NUhafoehF64vaPzGJkxF
         lgIPfGSiAtMM31Wd5Lh4JxqvLcXhzCc643tJfSuA8zy7F3SI1OlPmnNwEBNCM5eF26Ce
         /YuEcCrO6PBtv/9tTHRBaSVhGwnf+vKgARJDaCiBrE0bZCIOB7polXf3aWzbWXwfbu8A
         XxJLeAR8JbTxMnkjsQoR1MVejM1c1W4VqTcbLJ75FhgI57m3UmYKTuXc//YDQYK4jN76
         6NOg==
X-Gm-Message-State: AOAM5301LyLSdYUiMvGMWAGoNpMlCoSoAEigHfw5DkIHWBwZSdLevSq0
        r/HtvpNl90nJwjbJbG0mQRPUeg==
X-Google-Smtp-Source: ABdhPJzpnzBbPeSN+Y8mIp++rpAKKbpG9TXa6AAMyAIM/sgSqjJeztb+dZGRbjgWSao5Q+gQTRDvtg==
X-Received: by 2002:a17:906:16d3:: with SMTP id t19mr2316230ejd.36.1590662098490;
        Thu, 28 May 2020 03:34:58 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q19sm4906881ejb.88.2020.05.28.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 03:34:57 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-6-jakub@cloudflare.com> <20200527174805.GG49942@google.com> <87tv012lxs.fsf@cloudflare.com> <20200527203823.GB57268@google.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment to network namespace
In-reply-to: <20200527203823.GB57268@google.com>
Date:   Thu, 28 May 2020 12:34:56 +0200
Message-ID: <87sgfk2vqn.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 10:38 PM CEST, sdf@google.com wrote:
> On 05/27, Jakub Sitnicki wrote:
>> On Wed, May 27, 2020 at 07:48 PM CEST, sdf@google.com wrote:
>> > On 05/27, Jakub Sitnicki wrote:
>> >> Add support for bpf() syscall subcommands that operate on
>> >> bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points tied to
>> >> network namespaces (that is flow dissector at the moment).
>> >
>> >> Link-based and prog-based attachment can be used interchangeably, but only
>> >> one can be in use at a time. Attempts to attach a link when a prog is
>> >> already attached directly, and the other way around, will be met with
>> >> -EBUSY.
>> >
>> >> Attachment of multiple links of same attach type to one netns is not
>> >> supported, with the intention to lift it when a use-case presents
>> >> itself. Because of that attempts to create a netns link, when one already
>> >> exists result in -E2BIG error, signifying that there is no space left for
>> >> another attachment.
>> >
>> >> Link-based attachments to netns don't keep a netns alive by holding a ref
>> >> to it. Instead links get auto-detached from netns when the latter is being
>> >> destroyed by a pernet pre_exit callback.
>> >
>> >> When auto-detached, link lives in defunct state as long there are open FDs
>> >> for it. -ENOLINK is returned if a user tries to update a defunct link.
>> >
>> >> Because bpf_link to netns doesn't hold a ref to struct net, special care is
>> >> taken when releasing the link. The netns might be getting torn down when
>> >> the release function tries to access it to detach the link.
>> >
>> >> To ensure the struct net object is alive when release function accesses it
>> >> we rely on the fact that cleanup_net(), struct net destructor, calls
>> >> synchronize_rcu() after invoking pre_exit callbacks. If auto-detach from
>> >> pre_exit happens first, link release will not attempt to access struct net.
>> >
>> >> Same applies the other way around, network namespace doesn't keep an
>> >> attached link alive because by not holding a ref to it. Instead bpf_links
>> >> to netns are RCU-freed, so that pernet pre_exit callback can safely access
>> >> and auto-detach the link when racing with link release/free.
>> >
>> > [..]
>> >> +	rcu_read_lock();
>> >>   	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
>> >> -		if (rcu_access_pointer(net->bpf.progs[type]))
>> >> +		if (rcu_access_pointer(net->bpf.links[type]))
>> >> +			bpf_netns_link_auto_detach(net, type);
>> >> +		else if (rcu_access_pointer(net->bpf.progs[type]))
>> >>   			__netns_bpf_prog_detach(net, type);
>> >>   	}
>> >> +	rcu_read_unlock();
>> > Aren't you doing RCU_INIT_POINTER in __netns_bpf_prog_detach?
>> > Is it allowed under rcu_read_load?
>
>> Yes, that's true. __netns_bpf_prog_detach does
>
>> 	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
>
>> RCU read lock is here for the rcu_dereference() that happens in
>> bpf_netns_link_auto_detach (netns doesn't hold a ref to bpf_link):
>
>> /* Called with RCU read lock. */
>> static void __net_exit
>> bpf_netns_link_auto_detach(struct net *net, enum netns_bpf_attach_type type)
>> {
>> 	struct bpf_netns_link *net_link;
>> 	struct bpf_link *link;
>
>> 	link = rcu_dereference(net->bpf.links[type]);
>> 	if (!link)
>> 		return;
>> 	net_link = to_bpf_netns_link(link);
>> 	RCU_INIT_POINTER(net_link->net, NULL);
>> }
>
>> I've pulled it up, out of the loop, perhaps too eagerly and just made it
>> confusing, considering we're iterating over a 1-item array :-)
>
>> Now, I'm also doing RCU_INIT_POINTER on the *contents of bpf_link* in
>> bpf_netns_link_auto_detach. Is that allowed? I'm not sure, that bit is
>> hazy to me.
>
>> There are no concurrent writers to net_link->net, just readers, i.e.
>> bpf_netns_link_release(). And I know bpf_link won't be freed until the
>> grace period elapses.
>
>> sparse and CONFIG_PROVE_RCU are not shouting at me, but please do if it
>> doesn't hold up or make sense.
>
>> I certainly can push the rcu_read_lock() down into
>> bpf_netns_link_auto_detach().
> I think it would be much nicer if you push them down to preserve the
> assumption that nothing is modified under read lock and you flip
> the pointers only when holding the mutexes.

I certainly see how that would save some head-scratching. Might be
doable with grabbing a temporary reference to struct net/struct
bpf_link. Please see the code snippet below.

>
> I'll do another pass on this patch, I think I don't understand a bunch
> of bits where you do:
>
> mutex_lock
> rcu_read_lock -> why? you're already in the update section, can use
>                  rcu_dereference_protected
> ...
> rcu_read_unlock
> mutex_unlock

The rcu_read_lock is to get the grace-period guarantee for the value
(struct net) we access by dereferencing RCU protected pointer
(bpf_netns_link.net).

While mutex_lock is to serialize updates to values within struct
net. That is net->bpf.progs or net->bpf.links.

The locking is done in reverse order because I cannot grab the mutex
while in RCU read-side critical section.

If I was holding a reference to struct net, I would not need to be
inside an RCU read-side critical section to access it. (This is how
bpf_cgroup_link does it when accessing cgroup->bpf.)

One thought I had is that I could rearrange sychnronization so that we
try to grab a reference to struct net when we need to modify it:

	rcu_read_lock();
	net = rcu_dereference(to_bpf_netns_link(link)->net);
	if (net)
		net = maybe_get_net(net);
	rcu_read_unlock();

	if (!net)
		return; /* netns is dead */

	mutex_lock(&netns_bpf_mutex);
	rcu_assign_pointer(net->bpf.progs[type], link->prog);
	rcu_assign_pointer(net->bpf.links[type], link);
	mutex_unlock(&netns_bpf_mutex);
	put_net(net);

That seems be easier to reason about, no?

> But I'll post those comments inline shortly.

Thanks. Will be better to discuss in context.
