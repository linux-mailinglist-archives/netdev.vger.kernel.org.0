Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB151F4816
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387964AbgFIUaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbgFIUaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:30:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE01DC05BD1E;
        Tue,  9 Jun 2020 13:30:00 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u13so18103822iol.10;
        Tue, 09 Jun 2020 13:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rXAQo0qcSEf/rgmt1qeDzMiNFFqbt0zvsH1VBoTiGDw=;
        b=qJP+fhmpCHY7cMNch3DtBBYfSpR66LyX356B3xkOy8ukatNG36yfNajuq1vngLm2PN
         1NAOjgowp1+7gth3QdjaU7FyoCFDiAGp/2rU9Y9Zfsd1JcDgLY+3xzOAi7iVnE9E+uql
         UPabZLUqGPtfHkifu+Xtgt3vxGPOqTCyUBsji2uqfAZyar8m2iwFLmChYbt2aiq0q6fA
         SM8RoexJJbh31V/CjgSDd3jcZkqEAiGLiERXfiwhsN/jg30mT/G3a+atQuqu7GpvEzgH
         Ln+P+E1CWtlpyq3tnvWKyMC/3it8Asy9tO2yNCbB07wJ9eBSezhrn//X/IMNzaztLM4N
         v4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rXAQo0qcSEf/rgmt1qeDzMiNFFqbt0zvsH1VBoTiGDw=;
        b=bgay+aFeNzoKIRO7yoNNn7sDYVeTmcTJozpCFHLJ3jZ8uJpgwa7jPPc6EZXpVIDd+G
         gPTL747bdm6w/mp0ChdScJOAfLHYKI4tbKrq0zExJ4fXxHCNlk/VziJr4OONF6vuw8G+
         vSAMySAss5EM3UKGFwlNFCMYaAGo8NyDAkXyBhtd27QgYeeDwkqLqG+AmJ2AXdoIvCxN
         VGyacdWcxZY3ozDHOZtJ6xhW1Q7FiUjEtEbbjDBSq0taCci6Zj+iP6CPGOaAJulY8NuP
         /PQqwqNpvVJ9KXowvtnbChe9mXKmaYfvxyZ9b8w335qdSCQY+HpCGhVzzNzC768Ek9BL
         UgvQ==
X-Gm-Message-State: AOAM533uurP78KAUepDo7XA4pVc/7DA/L3z1T6NJS5V2GUCLcgnH23p8
        ruj8ipn8vBZsEZFRU507RDw=
X-Google-Smtp-Source: ABdhPJzTgxKHb5DwYljmQ1KeCLCQw4+mg9k15slXoEWjhqll8jgnS62DZWQl0cVXlC4pBKuRKjuAfA==
X-Received: by 2002:a02:a91a:: with SMTP id n26mr28808494jam.104.1591734600254;
        Tue, 09 Jun 2020 13:30:00 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g21sm7920663ioc.14.2020.06.09.13.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:29:59 -0700 (PDT)
Date:   Tue, 09 Jun 2020 13:29:52 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5edff140744f_3222ae3ab50e5c437@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQLe-vks4TpJzcWc+HPa1jzO2z6yZg-M8iD2JNAmfm9dXQ@mail.gmail.com>
References: <20200607205229.2389672-1-jakub@cloudflare.com>
 <20200607205229.2389672-3-jakub@cloudflare.com>
 <5edfc23e1bb3e_5cca2af6a27f45b8df@john-XPS-13-9370.notmuch>
 <CAADnVQLe-vks4TpJzcWc+HPa1jzO2z6yZg-M8iD2JNAmfm9dXQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf, sockhash: Synchronize delete from bucket
 list on map free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Jun 9, 2020 at 10:51 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Jakub Sitnicki wrote:
> > > We can end up modifying the sockhash bucket list from two CPUs when a
> > > sockhash is being destroyed (sock_hash_free) on one CPU, while a socket
> > > that is in the sockhash is unlinking itself from it on another CPU
> > > it (sock_hash_delete_from_link).
> > >
> > > This results in accessing a list element that is in an undefined state as
> > > reported by KASAN:
> > >
> > > | ==================================================================
> > > | BUG: KASAN: wild-memory-access in sock_hash_free+0x13c/0x280
> > > | Write of size 8 at addr dead000000000122 by task kworker/2:1/95
> > > |
> > > | CPU: 2 PID: 95 Comm: kworker/2:1 Not tainted 5.7.0-rc7-02961-ge22c35ab0038-dirty #691
> > > | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > > | Workqueue: events bpf_map_free_deferred
> > > | Call Trace:
> > > |  dump_stack+0x97/0xe0
> > > |  ? sock_hash_free+0x13c/0x280
> > > |  __kasan_report.cold+0x5/0x40
> > > |  ? mark_lock+0xbc1/0xc00
> > > |  ? sock_hash_free+0x13c/0x280
> > > |  kasan_report+0x38/0x50
> > > |  ? sock_hash_free+0x152/0x280
> > > |  sock_hash_free+0x13c/0x280
> > > |  bpf_map_free_deferred+0xb2/0xd0
> > > |  ? bpf_map_charge_finish+0x50/0x50
> > > |  ? rcu_read_lock_sched_held+0x81/0xb0
> > > |  ? rcu_read_lock_bh_held+0x90/0x90
> > > |  process_one_work+0x59a/0xac0
> > > |  ? lock_release+0x3b0/0x3b0
> > > |  ? pwq_dec_nr_in_flight+0x110/0x110
> > > |  ? rwlock_bug.part.0+0x60/0x60
> > > |  worker_thread+0x7a/0x680
> > > |  ? _raw_spin_unlock_irqrestore+0x4c/0x60
> > > |  kthread+0x1cc/0x220
> > > |  ? process_one_work+0xac0/0xac0
> > > |  ? kthread_create_on_node+0xa0/0xa0
> > > |  ret_from_fork+0x24/0x30
> > > | ==================================================================
> > >
> > > Fix it by reintroducing spin-lock protected critical section around the
> > > code that removes the elements from the bucket on sockhash free.
> > >
> > > To do that we also need to defer processing of removed elements, until out
> > > of atomic context so that we can unlink the socket from the map when
> > > holding the sock lock.
> > >
> > > Fixes: 90db6d772f74 ("bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free")
> > > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > ---
> > >  net/core/sock_map.c | 23 +++++++++++++++++++++--
> > >  1 file changed, 21 insertions(+), 2 deletions(-)
> >
> > Thanks.
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> Applied both to bpf tree.
> 
> FYI I see this splat:
>  ./test_sockmap
> # 1/ 6  sockmap::txmsg test passthrough:OK
> # 2/ 6  sockmap::txmsg test redirect:OK
> # 3/ 6  sockmap::txmsg test drop:OK
> # 4/ 6  sockmap::txmsg test ingress redirect:OK
> [   19.180397]
> [   19.180633] =============================
> [   19.181042] WARNING: suspicious RCU usage
> [   19.181517] 5.7.0-07177-g75e68e5bf2c7 #688 Not tainted
> [   19.182048] -----------------------------
> [   19.182570] include/linux/skmsg.h:284 suspicious
> rcu_dereference_check() usage!

I'll have a fix for this splat shortly thanks.
