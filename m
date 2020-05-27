Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EAA1E4F68
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgE0Ui0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgE0UiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:38:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67271C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:38:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n7so25624910ybh.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1P1IVYYqD7Lmk9JnpJwXopeg+n6aCPm5iww2pLfGskc=;
        b=PQ1PF9386ekV9M0GlLbVeudomlp8UYMvwHlWTTfmFvHcwC1XRE3WipoS0AOLefNVYa
         PCDZtZC3xEFqr3jVCKQLwEClapvSN4ZW3Fxm8JRE1bJ7U5PRKgx/MBdmcOtkfAjh4f9H
         YEPHdeZmTIreyzOW15DD3ejUrIjKX2+GfFMMbR4LA/PGFxDrN4fzkoZjT5co9HLsPX1B
         f9qvaoPx8zqYPILMrnVuwXiK8RBgYurSA0hIX5xhp77TPXc4hNf/CcFoTEZhpdyZvVG+
         XeFUpGxLlap3HyQ5umybDCIrR5TM9YCb6qY/Upj3YWbenSwKATdzbjZXQEewjL+cxQOc
         ddyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1P1IVYYqD7Lmk9JnpJwXopeg+n6aCPm5iww2pLfGskc=;
        b=RM2z+cpqQ8ZLI+MYg3XacgznhnYFKzYrtO+bHL3b0CdzogjuXxWVWHfDI646VpudSo
         tnMqQcS8zSnjKQ4OWI7De+deGliZOsbh2kgL2qixNlp+quXwqQcGD3g7E04WCPTN0PQV
         Nk0WoOSZG5ApW1/E94ilLWJxHY91cu+xi3hXqKnARMpBd5o5BN/a4ct13690EMj4kmCh
         iF9N9LA/5TAGNyBE6hPgydP8oURSJCFfrI5p3/r8AiS1c4aZqARd9J86fM62yPeNUU5N
         EoBTrdAI+qfFrEHHH50zdpeZyp/ye5a4zj373cOOxupXS/ktQJoOFReSfxXj2cJQPHmw
         eyrw==
X-Gm-Message-State: AOAM532kX1CJ1teok9pUy+qKz39x2MVKQc/G8a2amJVz60LGiJ8iloob
        a6bXC4L33yH4OHytn9QakeqFnzs=
X-Google-Smtp-Source: ABdhPJwhXIsHOW4VAq44rrgzdJVTNLBJ2Bt0DHNfkP+5zIV37LoxeqwMUISPBtDgagnouAEJkcKKHQA=
X-Received: by 2002:a25:148b:: with SMTP id 133mr100655ybu.38.1590611904629;
 Wed, 27 May 2020 13:38:24 -0700 (PDT)
Date:   Wed, 27 May 2020 13:38:23 -0700
In-Reply-To: <87tv012lxs.fsf@cloudflare.com>
Message-Id: <20200527203823.GB57268@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com>
 <20200527170840.1768178-6-jakub@cloudflare.com> <20200527174805.GG49942@google.com>
 <87tv012lxs.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment
 to network namespace
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27, Jakub Sitnicki wrote:
> On Wed, May 27, 2020 at 07:48 PM CEST, sdf@google.com wrote:
> > On 05/27, Jakub Sitnicki wrote:
> >> Add support for bpf() syscall subcommands that operate on
> >> bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points  
> tied to
> >> network namespaces (that is flow dissector at the moment).
> >
> >> Link-based and prog-based attachment can be used interchangeably, but  
> only
> >> one can be in use at a time. Attempts to attach a link when a prog is
> >> already attached directly, and the other way around, will be met with
> >> -EBUSY.
> >
> >> Attachment of multiple links of same attach type to one netns is not
> >> supported, with the intention to lift it when a use-case presents
> >> itself. Because of that attempts to create a netns link, when one  
> already
> >> exists result in -E2BIG error, signifying that there is no space left  
> for
> >> another attachment.
> >
> >> Link-based attachments to netns don't keep a netns alive by holding a  
> ref
> >> to it. Instead links get auto-detached from netns when the latter is  
> being
> >> destroyed by a pernet pre_exit callback.
> >
> >> When auto-detached, link lives in defunct state as long there are open  
> FDs
> >> for it. -ENOLINK is returned if a user tries to update a defunct link.
> >
> >> Because bpf_link to netns doesn't hold a ref to struct net, special  
> care is
> >> taken when releasing the link. The netns might be getting torn down  
> when
> >> the release function tries to access it to detach the link.
> >
> >> To ensure the struct net object is alive when release function  
> accesses it
> >> we rely on the fact that cleanup_net(), struct net destructor, calls
> >> synchronize_rcu() after invoking pre_exit callbacks. If auto-detach  
> from
> >> pre_exit happens first, link release will not attempt to access struct  
> net.
> >
> >> Same applies the other way around, network namespace doesn't keep an
> >> attached link alive because by not holding a ref to it. Instead  
> bpf_links
> >> to netns are RCU-freed, so that pernet pre_exit callback can safely  
> access
> >> and auto-detach the link when racing with link release/free.
> >
> > [..]
> >> +	rcu_read_lock();
> >>   	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
> >> -		if (rcu_access_pointer(net->bpf.progs[type]))
> >> +		if (rcu_access_pointer(net->bpf.links[type]))
> >> +			bpf_netns_link_auto_detach(net, type);
> >> +		else if (rcu_access_pointer(net->bpf.progs[type]))
> >>   			__netns_bpf_prog_detach(net, type);
> >>   	}
> >> +	rcu_read_unlock();
> > Aren't you doing RCU_INIT_POINTER in __netns_bpf_prog_detach?
> > Is it allowed under rcu_read_load?

> Yes, that's true. __netns_bpf_prog_detach does

> 	RCU_INIT_POINTER(net->bpf.progs[type], NULL);

> RCU read lock is here for the rcu_dereference() that happens in
> bpf_netns_link_auto_detach (netns doesn't hold a ref to bpf_link):

> /* Called with RCU read lock. */
> static void __net_exit
> bpf_netns_link_auto_detach(struct net *net, enum netns_bpf_attach_type  
> type)
> {
> 	struct bpf_netns_link *net_link;
> 	struct bpf_link *link;

> 	link = rcu_dereference(net->bpf.links[type]);
> 	if (!link)
> 		return;
> 	net_link = to_bpf_netns_link(link);
> 	RCU_INIT_POINTER(net_link->net, NULL);
> }

> I've pulled it up, out of the loop, perhaps too eagerly and just made it
> confusing, considering we're iterating over a 1-item array :-)

> Now, I'm also doing RCU_INIT_POINTER on the *contents of bpf_link* in
> bpf_netns_link_auto_detach. Is that allowed? I'm not sure, that bit is
> hazy to me.

> There are no concurrent writers to net_link->net, just readers, i.e.
> bpf_netns_link_release(). And I know bpf_link won't be freed until the
> grace period elapses.

> sparse and CONFIG_PROVE_RCU are not shouting at me, but please do if it
> doesn't hold up or make sense.

> I certainly can push the rcu_read_lock() down into
> bpf_netns_link_auto_detach().
I think it would be much nicer if you push them down to preserve the
assumption that nothing is modified under read lock and you flip
the pointers only when holding the mutexes.

I'll do another pass on this patch, I think I don't understand a bunch
of bits where you do:

mutex_lock
rcu_read_lock -> why? you're already in the update section, can use
                  rcu_dereference_protected
...
rcu_read_unlock
mutex_unlock


But I'll post those comments inline shortly.

