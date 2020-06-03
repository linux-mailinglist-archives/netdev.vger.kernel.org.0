Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D31F1ED635
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCSfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:35:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A096C08C5C0;
        Wed,  3 Jun 2020 11:35:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so1112773plt.5;
        Wed, 03 Jun 2020 11:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EtKStJaR8AXyeEPFCQyFQM617jISNhk6yPBdUrn+8kQ=;
        b=ieQKZqde+kGAvKZ9Aeg/iwGIPFra+dmPi4X10XIZpbCBVcd/RQA4mXBknV/6qEm8MJ
         ehN9qIfkIfAqOEhsciYN1ALm0URxtOCGlf//v7qtepIOBo8HlGYgSqv2FN3yaoex1Puq
         sOYY7ulbG+pAga0boLM4qw8y3ieQkb9cbysJBE93rOf3RJnfE/nsxoq74CUznP6rpCiq
         gst2BdVifXkD93yoGVH9uQ6UFtaU22QFXRDVgG27yk9LlBF9xtRv98Bl/Y1B1kyrEi1m
         AFIuL3PJGDbGv0H6AmEUre5etn1AukTzdmS7O+1Ha+EXp22Yv8ahggB9dPGev7B4EyrZ
         F+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EtKStJaR8AXyeEPFCQyFQM617jISNhk6yPBdUrn+8kQ=;
        b=oTP/KT8+xLXn0La0AY7h8jETZ5LOqJmEqdV3LemT90Ccpr0Oy+dGhvFRZaMhDOYcmD
         Cuk2vObaZfSEct+MTFSQwkbbqwpy5elUR+bvarulCFGI82U5mLjLvgt03dmmfFWGwZhQ
         uOKnFTruFBFo1HH84L6MzZtVBP54VI8TDFafD73ReV0J77Xxrbo7JtVfFcCzj18L1Vaq
         uqcyL7L8WmmFwvyKfOpgkXAqgrFzxHmJWBURjRM9GRjSIMzhlAE2lPNVpVWns0rPm/ca
         UHO1nh1Jf40hMH8v4Ms8cgLLFCv927BfUoh/YjIktfR4CeN1T+wJTfqc/7gjDLBVlEF2
         oozA==
X-Gm-Message-State: AOAM533Rk97sPFtXFOkKNwDh8t68qa4K0al8/U45cRVBmrkIRzRswbN7
        VYoroCoJKs/KivVtFL5KAig=
X-Google-Smtp-Source: ABdhPJylSnZgNvV8pBUo7zgOP3lK0Nni8ORKb3jzFcXVy/Sk6lYzvESfpZwitod2LlZPzrnRocokdg==
X-Received: by 2002:a17:902:9e0c:: with SMTP id d12mr1160144plq.29.1591209351492;
        Wed, 03 Jun 2020 11:35:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i22sm2433759pfo.92.2020.06.03.11.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 11:35:50 -0700 (PDT)
Date:   Wed, 03 Jun 2020 11:35:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ed7ed7d315bd_36aa2ab64b3c85bcd9@john-XPS-13-9370.notmuch>
In-Reply-To: <87a71k2yje.fsf@cloudflare.com>
References: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
 <6f8bb6d8-bb70-4533-f15b-310db595d334@gmail.com>
 <87a71k2yje.fsf@cloudflare.com>
Subject: Re: [bpf PATCH] bpf: sockmap, remove bucket->lock from
 sock_{hash|map}_free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Jun 03, 2020 at 08:13 AM CEST, Eric Dumazet wrote:
> > On 3/10/20 9:41 AM, John Fastabend wrote:
> >> The bucket->lock is not needed in the sock_hash_free and sock_map_free
> >> calls, in fact it is causing a splat due to being inside rcu block.
> >>

[...]

>> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> >> index 085cef5..b70c844 100644
> >> --- a/net/core/sock_map.c
> >> +++ b/net/core/sock_map.c
> >> @@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map *map)
> >>  	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
> >>  	int i;
> >>
> >> +	/* After the sync no updates or deletes will be in-flight so it
> >> +	 * is safe to walk map and remove entries without risking a race
> >> +	 * in EEXIST update case.
> >
> >
> > What prevents other cpus from deleting stuff in sock_hash_delete_elem() ?
> >
> > What state has been changed before the synchronize_rcu() call here,
> > that other cpus check before attempting a delete ?
> >
> > Typically, synchronize_rcu() only makes sense if readers can not start a new cycle.
> >
> > A possible fix would be to check in sock_hash_delete_elem() (and possibly others methods)
> > if map->refcnt is not zero.
> >
> > syzbot found : (no repro yet)
> >
> > general protection fault, probably for non-canonical address 0xfbd59c0000000024: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
> > CPU: 2 PID: 14305 Comm: kworker/2:3 Not tainted 5.7.0-syzkaller #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > Workqueue: events bpf_map_free_deferred
> > RIP: 0010:__write_once_size include/linux/compiler.h:279 [inline]
> > RIP: 0010:__hlist_del include/linux/list.h:811 [inline]
> > RIP: 0010:hlist_del_rcu include/linux/rculist.h:485 [inline]
> > RIP: 0010:sock_hash_free+0x202/0x4a0 net/core/sock_map.c:1021
> > Code: 0f 85 15 02 00 00 4c 8d 7b 28 4c 8b 63 20 4c 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 47 02 00 00 4c 8b 6b 28 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 25 02 00 00 4d 85 e4 4d 89 65 00 74 20 e8 f6 82

[...]

Thanks Eric.

> My initial reasoning behind the change was that sock_hash_delete_elem()
> callers hold a ref to sockhash [0]. Either because there is an open FD
> for the map, or the map is in use by loaded BPF program. The same
> applies to updates.
> 
> If that holds, map->refcnt is > 0, and we should not see the map being
> freed at the same time as sock_hash_delete_elem() happens.
> 
> But then there is also sock_hash_delete_from_link() that deletes from
> sockhash when a sock/psock unlinks itself from the map. This operation
> happens without holding a ref to the map, so that sockets won't keep the
> map "alive". There is no corresponding *_update_from_link() for updates
> without holding a ref.

Yep we missed this case :/

> 
> Sadly, I can't spot anything preventing list mutation, hlist_del_rcu(),
> from happening both in sock_hash_delete_elem() and sock_hash_free()
> concurrently, now that the bucket spin-lock doesn't protect it any
> more. That is what I understand syzbot is reporting.

Agreed.

> 
> synchronize_rcu() before we walk the htable doesn't rule it out, because
> as you point out, new readers can start a new cycle, and we don't change
> any state that would signal that the map is going away.
> 
> I'm not sure that the check for map->refcnt when sock is unlinking
> itself from the map will do it. I worry we will then have issues when
> sockhash is unlinking itself from socks (so the other way around) in
> sock_hash_free(). We could no longer assume that the sock & psock
> exists.
> 
> What comes to mind is to reintroduce the spin-lock protected critical
> section in sock_hash_free(), but delay the processing of sockets to be
> unlinked from sockhash. We could grab a ref to sk_psock while holding a
> spin-lock and unlink it while no longer in atomic critical section.

It seems so. In sock_hash_free we logically need,

 for (i = 0; i < htab->buckets_num; i++) {
  hlist_for_each_entryy_safe(...) {
  	hlist_del_rcu() <- detached from bucket and no longer reachable
        synchronize_rcu()
        // now element can not be reached from unhash()
	... sock_map_unref(elem->sk, elem) ...
  }
 } 

We don't actually want to stick a synchronize_rcu() in that loop
so I agree we need to collect the elements do a sync then remove them.

> 
> Either way, Eric, thank you for the report and the pointers.

+1

> 
> John, WDYT?

Want to give it a try? Or I can draft something.

> 
> [0] https://lore.kernel.org/netdev/8736boor55.fsf@cloudflare.com/

[...]
