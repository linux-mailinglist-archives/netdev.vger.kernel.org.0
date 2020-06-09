Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42711F41C5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgFIRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbgFIRJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:09:28 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D538C05BD1E;
        Tue,  9 Jun 2020 10:09:27 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so21067224ilm.7;
        Tue, 09 Jun 2020 10:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OIlKxeZxM3e/pP7D/bVrWCwP7xeVBhGQH39vr/IlNIs=;
        b=u1w/EfgUFymmbHhQDsMU3qROHhi0t0IiG3U4A/K0Ldw6Wz2phZUh8S4/UBNUxQ2Eb4
         HeZuRu3CyqgYjOJOEgIPsqhtNfCBFo2H43Qfj5CMBe3nwzUU5opmFFCcTAwfbcdyYcu6
         AB202oFgvbRH8OdGlA9C3g05TDw4K3g9X6U6j6LfUYehuWCwEOLT2SjxBdFAymGqMY4v
         aFscgRjsTLRZcDXMPCyMeM0Jm8sLABe5wFiQo26g//dKH6T63DVao7OyFglC5FUy8Pka
         UgHFNdPLlWgNxrPCcgkqwf4NcnzqKBTss1nj1w8LU4NwxfAabrLQOmVgq1eApQdTBpSR
         e/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OIlKxeZxM3e/pP7D/bVrWCwP7xeVBhGQH39vr/IlNIs=;
        b=hZ1ZXbz2z/x8Ekw5Z+5wDi7+teAws21Q5KaG6LS+4HrHTTan65r9p/fNKOBCK/nxpy
         2RbNKtVVCa1/svLRgBwUg1U/k4q29dbZTw4v9f9jho8IcGTgAmzYw5ywYIJMnduUYNpM
         L/FkJVlq3XCjQkCdapjcyeRBcX31+d+bPZ5uylH3SNGu1uE1hggsH/csAt5KDSY3Qm8k
         793uW9Txo1MyTcLPwrOuQnWA6Fx5driU7oEQcJ6kdxtAYxRtp49hvVNhMm7HizxLRXY9
         T/e2m+kq/bzvXE9UkVX3aPAf1MSRRdEUAP1oTMqcB13RyJrbHh+5o4VbRMEldGLveJdL
         uWWw==
X-Gm-Message-State: AOAM530SfZv0oyUl0V86ht28Cysk/57TDS56LfnVDVUs8Z9Yh3Ptl7dT
        ESt4mVfwZyYoV+yQdPSzBEA=
X-Google-Smtp-Source: ABdhPJz3jHHUkB8Lb5+mbq05CxfJ2voNYFLh5a2c93QpZFppARqV3xBLsSfrenh9F57R4+9j6Kf0Ww==
X-Received: by 2002:a92:c94b:: with SMTP id i11mr28699657ilq.177.1591722566898;
        Tue, 09 Jun 2020 10:09:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v87sm337515ili.2.2020.06.09.10.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 10:09:26 -0700 (PDT)
Date:   Tue, 09 Jun 2020 10:09:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5edfc23e1bb3e_5cca2af6a27f45b8df@john-XPS-13-9370.notmuch>
In-Reply-To: <20200607205229.2389672-3-jakub@cloudflare.com>
References: <20200607205229.2389672-1-jakub@cloudflare.com>
 <20200607205229.2389672-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 2/2] bpf, sockhash: Synchronize delete from bucket
 list on map free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> We can end up modifying the sockhash bucket list from two CPUs when a
> sockhash is being destroyed (sock_hash_free) on one CPU, while a socket
> that is in the sockhash is unlinking itself from it on another CPU
> it (sock_hash_delete_from_link).
> 
> This results in accessing a list element that is in an undefined state as
> reported by KASAN:
> 
> | ==================================================================
> | BUG: KASAN: wild-memory-access in sock_hash_free+0x13c/0x280
> | Write of size 8 at addr dead000000000122 by task kworker/2:1/95
> |
> | CPU: 2 PID: 95 Comm: kworker/2:1 Not tainted 5.7.0-rc7-02961-ge22c35ab0038-dirty #691
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x97/0xe0
> |  ? sock_hash_free+0x13c/0x280
> |  __kasan_report.cold+0x5/0x40
> |  ? mark_lock+0xbc1/0xc00
> |  ? sock_hash_free+0x13c/0x280
> |  kasan_report+0x38/0x50
> |  ? sock_hash_free+0x152/0x280
> |  sock_hash_free+0x13c/0x280
> |  bpf_map_free_deferred+0xb2/0xd0
> |  ? bpf_map_charge_finish+0x50/0x50
> |  ? rcu_read_lock_sched_held+0x81/0xb0
> |  ? rcu_read_lock_bh_held+0x90/0x90
> |  process_one_work+0x59a/0xac0
> |  ? lock_release+0x3b0/0x3b0
> |  ? pwq_dec_nr_in_flight+0x110/0x110
> |  ? rwlock_bug.part.0+0x60/0x60
> |  worker_thread+0x7a/0x680
> |  ? _raw_spin_unlock_irqrestore+0x4c/0x60
> |  kthread+0x1cc/0x220
> |  ? process_one_work+0xac0/0xac0
> |  ? kthread_create_on_node+0xa0/0xa0
> |  ret_from_fork+0x24/0x30
> | ==================================================================
> 
> Fix it by reintroducing spin-lock protected critical section around the
> code that removes the elements from the bucket on sockhash free.
> 
> To do that we also need to defer processing of removed elements, until out
> of atomic context so that we can unlink the socket from the map when
> holding the sock lock.
> 
> Fixes: 90db6d772f74 ("bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
