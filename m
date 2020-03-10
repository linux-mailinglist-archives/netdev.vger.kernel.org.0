Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FD1803D6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCJQof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:44:35 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39310 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgCJQof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:44:35 -0400
Received: by mail-pj1-f68.google.com with SMTP id d8so662943pje.4;
        Tue, 10 Mar 2020 09:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0p2YVHGL6lp61uxRv5NLn1qmIWDP6yCfI2xh2i2Pm1Y=;
        b=MhtgLRAuKpplE/whqcWb0A+tJmDYwcN+T0MomFscn4nogXG70v6ONNEJkWAoFg9cxs
         y927uwFcvheWjnhF0lso+saMMxrxoIp/ARhJIftlWAN+Wtu+nWh4Ji4aQvuRON3U49kU
         hp04Pjjy78GE8WGlJsieGR5r4LoH5PtxzoQ5ZGhAAdNhXBRPCLAnVw+Nr033kY32ttiZ
         Xb9wMQLNdxn9hFGfPhhXeOBbivFEdGwbxbyzTTY4aIbqfZ8QESGtfDkrxIOzfJ9rWJV4
         EVwxJ2gtosyBTKq6QqwrsMzRcTbrOf8qLjblVNvWYq37BUGe21mTsjD3laSWYLxybtEl
         Dbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0p2YVHGL6lp61uxRv5NLn1qmIWDP6yCfI2xh2i2Pm1Y=;
        b=nrP2DrO05a4eJ5KfItJTWdLkgKtgSm+/VkJ6OXLpYHfs0EnBqdtaHvW3ZUMJdxZvuc
         GKT+jRAxWLy31THfV224zcLJ35uZwm59YNs3BYPX3UN4TGFelZoHFrU+hmCX4wVrmjJh
         WvimnZpgcvBSt8IYX9/IhUnGySbHm9Oz8/2OvuIS82/AdaGVTIrR2MU18Hx5Y16AuckT
         NW3U5vJd+/iaimhj7bGkMVICfDvSSGUn6vP3CtAPUzYS63ucMw8jL3phIkZZ6FAn/0RZ
         c1i9RKiEbdYlq+FfMX3YgD9UYGnrveu40hvJjjvK7RqOrpOkj1kju4q0mr9R4mon7XK0
         k4Pw==
X-Gm-Message-State: ANhLgQ2axQDvUMwT9DOLNAtPSj1GlAduFYIkBisuPrviHIcX72XfPJ+9
        sEbb0b9Z2g99KItkJefqV0g=
X-Google-Smtp-Source: ADFU+vt4mBe5DFPGkaJimj5kiEB7fPJIEIY3ZiotNS6jos3AKvEiYYYFgihfBZgWgbhy91+ZzDTY/w==
X-Received: by 2002:a17:902:74cc:: with SMTP id f12mr13133943plt.232.1583858672512;
        Tue, 10 Mar 2020 09:44:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 8sm8579106pfp.67.2020.03.10.09.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 09:44:31 -0700 (PDT)
Date:   Tue, 10 Mar 2020 09:44:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Message-ID: <5e67c3e83fb25_1e8a2b0e88e0a5bc84@john-XPS-13-9370.notmuch>
In-Reply-To: <87zhdun0ay.fsf@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
 <87zhdun0ay.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 0/3] Fix locking order and synchronization on
 sockmap/sockhash tear-down
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Feb 06, 2020 at 08:43 PM CET, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> Couple of fixes that came from recent discussion [0] on commit
> >> 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down").
> >>
> >> This series doesn't address the sleeping while holding a spinlock
> >> problem. We're still trying to decide how to fix that [1].
> >>
> >> Until then sockmap users might see the following warnings:
> >>
> >> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
> 

[...]

> Hey John,

Patch sent.

> 
> > Untested at the moment, but this should also be fine per your suggestion
> > (if I read it correctly).  The reason we have stab->lock and bucket->locks
> > here is to handle checking EEXIST in update/delete cases. We need to
> > be careful that when an update happens and we check for EEXIST that the
> > socket is added/removed during this check. So both map_update_common and
> > sock_map_delete need to guard from being run together potentially deleting
> > an entry we are checking, etc.
> 
> Okay, thanks for explanation. IOW, we're serializing map writers.
> 
> > But by the time we get here we just did a synchronize_rcu() in the
> > line above so no updates/deletes should be in flight. So it seems safe
> > to drop these locks because of the condition no updates in flight.
> 
> This part is not clear to me. I might be missing something.
> 
> Here's my thinking - for any map writes (update/delete) to start,
> map->refcnt needs to be > 0, and the ref is not dropped until the write
> operation has finished.
> 
> Map FDs hold a ref to map until the FD gets released. And BPF progs hold
> refs to maps until the prog gets unloaded.
> 
> This would mean that map_free will get scheduled from __bpf_map_put only
> when no one is holding a map ref, and could start a write that would be
> happening concurrently with sock_{map,hash}_free:

Sorry bringing back this old thread I'm not sure I followed the couple
paragraphs here. Is this with regards to the lock or the rcu? II didn't
want to just drop this thanks.

We can't have new updates/lookups/deletes happening while we are free'ing
a map that would cause all sorts of problems, use after free's, etc.

> 
> /* decrement map refcnt and schedule it for freeing via workqueue
>  * (unrelying map implementation ops->map_free() might sleep)
>  */
> static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
> {
> 	if (atomic64_dec_and_test(&map->refcnt)) {
> 		/* bpf_map_free_id() must be called first */
> 		bpf_map_free_id(map, do_idr_lock);
> 		btf_put(map->btf);
> 		INIT_WORK(&map->work, bpf_map_free_deferred);
> 		schedule_work(&map->work);
> 	}
> }
> 
> > So with patch below we keep the sync rcu but that is fine IMO these
> > map free's are rare. Take a look and make sure it seems sane to you
> > as well.
> 
> I can't vouch for the need to keep synchronize_rcu here because I don't
> understand that part, but otherwise the change LGTM.
> 
> -jkbs
>

[...]
