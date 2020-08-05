Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F8E23D43D
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHEXtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgHEXtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:49:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B107C061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 16:49:43 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o1so26585480plk.1
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 16:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VzNXsXNS0hT51lPyuL3wC3wt4td8XfixNGeKE3StwBc=;
        b=yk6svvFyCRGiTCEjNkj2d2WdbEgk/MZPL7OlIxiXQ5cghbelHIr5h4xqwS1PyqAT4V
         TjZktZ9Cd9o+fDZkrcVYP/fAwWCjiByvcgrKEgQ2RVCFx8rKcskIppOf0N2lA8W8B51Q
         u90uuWDzXiwLjSfeFAx0FtJdKSh8N9BdKyyhmfz3fKXHpsGA39jLK/BY0xp9l09jVIgM
         Fh4rZxoWMOU+W3WXfiXyIvRAjr9xR5qnR+5LtOzhGXOj2wkBCmkBkZ2fI/8N0jvz6GRd
         RLsZSUuarLZxj0rp2GFyu+ns+k+qLRof2ul2RjnJvUFniE1NwjAYc74yaW+Zip8Z/v6l
         Cn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VzNXsXNS0hT51lPyuL3wC3wt4td8XfixNGeKE3StwBc=;
        b=ZUpcBvroEhv5C6FHdgoWgl/qgUAYC5CdBWwmVG3qiioJmWyVsActgHAvbuJMPESfHP
         WVmlWZEYuI2lAcsd8SloNyCY7axj0La9bmp7UsvLVHCnscGpxr9eZQqjLHLl0SGicOre
         TMXrOshSNq/wWsWqbwdVKpTyptKPyjwQghGZgDq7eOdTgqlTCS/iN+6GOJXJpPkUTQ7k
         H6nVb0Aru6ujBTFvuZYyC7d4OtiIA8jCoTUGlsE9vSvLzdQH/NZbtFRx8onZUeVgOvoe
         KtVyIujqXO0eukgTn5J3Ky3PJ+CmcCriifws1WClBIRXHvJG9taGPiaOuNL9pkKEk6V/
         HvNA==
X-Gm-Message-State: AOAM5331+z8L58cTYs+1PvHp6gywU4w8kfTahFIRNF53KdVlLmUKIjyL
        VMOsSKcyxLJ46V8ePGUB8e2CGg==
X-Google-Smtp-Source: ABdhPJyEN/r8xk5QZHe3wMiuTEnquQfIzX4ASJGfb3165dR+RjQWOt39UD5N/uno1wBXOEQb9Q0jsA==
X-Received: by 2002:a17:90a:4701:: with SMTP id h1mr5560315pjg.93.1596671382513;
        Wed, 05 Aug 2020 16:49:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l22sm4378845pjy.31.2020.08.05.16.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 16:49:42 -0700 (PDT)
Date:   Wed, 5 Aug 2020 16:49:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, Willy Tarreau <w@1wt.eu>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805164934.253346fe@hermes.lan>
In-Reply-To: <CAHk-=wgcBW-VkiF+gQETt7UpZcEZtHNwbbKcN9jxKUQRUQersw@mail.gmail.com>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
        <20200805024941.GA17301@1wt.eu>
        <66f06ea1-3221-5661-e0de-6eef45ac3664@gmail.com>
        <CAHk-=wgcBW-VkiF+gQETt7UpZcEZtHNwbbKcN9jxKUQRUQersw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 09:39:17 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Aug 5, 2020 at 8:44 AM Marc Plumb <lkml.mplumb@gmail.com> wrote:
> >
> > I thought net_rand_state was assumed to be insecure and that anyone
> > could determine the internal state. Isn't this Working as Designed?  
> 
> I was working as designed - because it wasn't really designed to be
> "real crypto" - but sadly it's also the only thing that is fast enough
> for a lot of networking.
> 
> So it may be _designed_ to be "not real crypto" and to have a
> discoverable internal state. But once again, reality interferes, and
> it turns out that people really want something very very fast that is
> also not deterministic enough to be discoverable at least remotely.

If you turn on the wayback machine, the original net_random came out
of having ok values for network simulation with netem. In that use case,
the point was to just have something with good distribution and reasonably long
period.

Then the idea of TCP ports have to be random came along and that was both
a weak security feature and benchmark sensitive so the net_random got drafted
into more areas.
