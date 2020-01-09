Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDA13533A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgAIGfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:35:20 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40155 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgAIGfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:35:20 -0500
Received: by mail-il1-f193.google.com with SMTP id c4so4803327ilo.7;
        Wed, 08 Jan 2020 22:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pctcYGkbGuhWDhvTW4O2H+ZFNhCyb4ZlmxLEnCxIhnk=;
        b=OUZ4Qnr6m1aNI9qAtYovF0D1qi5aEmtjYbd3hOX0kc39le4kT7Wem1RGkoxi0rERWm
         +25pjvz8eIyM1v2kdbj3/3YXKoBJAaG1u0u40iRSNk9qVIBQ0cgrc2cqIU86SHRwROSD
         baUdqd4xRHyDQ5bBQWvMAtqfsR2OpmCqZPumRQSCbWnPhmiBJtwPLj5CpU4pGqHkw0aH
         xiXBmuKlmbpY7G3p1gjm9XEW9CuUwJLiBFuxbxqButLSBfQU3l1DbezW3/Ecq77ipY+F
         1dcZgdcWT7BF2uQbXAhf5UkrUGSMW6mYEwCMrU/NqAHmrlJziVsekoxd6aDqNlx2X1GJ
         BGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pctcYGkbGuhWDhvTW4O2H+ZFNhCyb4ZlmxLEnCxIhnk=;
        b=MY2FSffrHR231yHfGNDsTxfP07QJYxHttZQCWGGYf01QyvIBFOhnZtRyruQ7lzzDlu
         L/oXeCueC5t2EQmixjauhRXHL4pWgpoBHAFQm4GndJfyg7fZ0YKPwNtAQXx5xBa4FEtg
         pYuzfc2K7Rb599XuCW0Joln+633WyhdbMh94yScMqe+vNK3SHm3Apo1FZhb+oL3CTg9O
         sww7fPP+O3UddvaUuH6QMdOKXLXkeE/Teg56PawWGnkuKs06RkUNJ9HNYiMLWmCUG1Ad
         Zss+2GzACBfcOddT3KLB94MwR3D7J2Rm3XxK1V7XjOI7hVH2YvlA8HM0FhMHkYOcZ4oZ
         BNyg==
X-Gm-Message-State: APjAAAUYxTnxrSat7yYk9SCvp8TU79qJqgu1WMRKZS9vk1jmRHCU4YAH
        43SYjbdsnwupxoCg560M6lc=
X-Google-Smtp-Source: APXvYqy5OWiYSuHqBj/7w0dqFPcOlCpgL9lzjPZEZEM4IBwQIckS53Jl+vS6p4ekc0kbwNArn27Cdg==
X-Received: by 2002:a92:cd02:: with SMTP id z2mr7856061iln.286.1578551719288;
        Wed, 08 Jan 2020 22:35:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n63sm1139619iod.57.2020.01.08.22.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 22:35:18 -0800 (PST)
Date:   Wed, 08 Jan 2020 22:35:10 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Message-ID: <5e16c99ecc70b_279f2af4a0e725c49a@john-XPS-13-9370.notmuch>
In-Reply-To: <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
 <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita wrote:
> On 2020/01/09 6:35, John Fastabend wrote:
> > Now that we depend on rcu_call() and synchronize_rcu() to also wait
> > for preempt_disabled region to complete the rcu read critical section
> > in __dev_map_flush() is no longer relevant.
> > 
> > These originally ensured the map reference was safe while a map was
> > also being free'd. But flush by new rules can only be called from
> > preempt-disabled NAPI context. The synchronize_rcu from the map free
> > path and the rcu_call from the delete path will ensure the reference
> > here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
> > pair to avoid any confusion around how this is being protected.
> > 
> > If the rcu_read_lock was required it would mean errors in the above
> > logic and the original patch would also be wrong.
> > 
> > Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   kernel/bpf/devmap.c |    2 --
> >   1 file changed, 2 deletions(-)
> > 
> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index f0bf525..0129d4a 100644
> > --- a/kernel/bpf/devmap.c
> > +++ b/kernel/bpf/devmap.c
> > @@ -378,10 +378,8 @@ void __dev_map_flush(void)
> >   	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
> >   	struct xdp_bulk_queue *bq, *tmp;
> >   
> > -	rcu_read_lock();
> >   	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
> >   		bq_xmit_all(bq, XDP_XMIT_FLUSH);
> > -	rcu_read_unlock();
> 
> I introduced this lock because some drivers have assumption that
> .ndo_xdp_xmit() is called under RCU. (commit 86723c864063)
> 
> Maybe devmap deletion logic does not need this anymore, but is it
> OK to drivers?

Ah OK thanks for catching this. So its a strange requirement from
virto_net to need read_lock like this. Quickly scanned the drivers
and seems its the only one.

I think the best path forward is to fix virtio_net so it doesn't
need rcu_read_lock() here then the locking is much cleaner IMO.

I'll send a v2 and either move the xdp enabled check (the piece
using the rcu_read_lock) into a bitmask flag or push the
rcu_read_lock() into virtio_net so its clear that this is a detail
of virtio_net and not a general thing. FWIW I don't think the
rcu_read_lock is actually needed in the virtio_net case anymore
either but pretty sure the rcu_dereference will cause an rcu
splat. Maybe there is another annotation we can use. I'll dig
into it tomorrow. Thanks

> 
> Toshiaki Makita


