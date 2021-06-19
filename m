Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319883AD966
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 12:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFSKc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhFSKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:32:26 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A190C061574;
        Sat, 19 Jun 2021 03:30:15 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p14so4090318ilg.8;
        Sat, 19 Jun 2021 03:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=btyhMs4BkaLRs/VMcp+enV+QTHYcvlAoTR3AvLbdS/U=;
        b=jtsTLOo/2Og5PavjWiBWWetfdiOD6O3MtdQCnm67cZpkXC+khgTySN4toBchSCCkN8
         z96E/8suqcqpzGNMa7lscwSNRzJRgu3PCQV6F7pScTurBGWQueCoIzDfTaaJMauer4G6
         C9vfYEEDeb89jdtlfzvcWwPIXOnHlXI4zdClj9rZlqoemMtFoKrHsFYgqrkAhylIpYZV
         O4q8C+6FYIcDpzEKthEg7gSWsJJciIaQ9KGnTY6hE0+kwo9YwhUTNak973UWLUrSA1yC
         iZtBbo3N+uQ12BPSRVwO84vYhvlPS8InCXzSDypzHEJGNu2LP/mb31cpGIi4TuGRkGrH
         2k0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=btyhMs4BkaLRs/VMcp+enV+QTHYcvlAoTR3AvLbdS/U=;
        b=jPUMOpQFGs6/QYAi1Jl8K6hod5exASFFJG6K60OasfvvamPWUYeJbmAm4R/jp5M1fg
         KkWQAAzLnsCaFia94rcwXsuyMAMU2Ud/1hF6E+udZ/iayEgvWynuBsPN+PpCKhmLc3Pa
         otnOcg41ImvaxHM/z0R7SDNJL0qBMswHOsRGk4JCeUeC3fjWe3fndLo5p+ZqnHi771jd
         wOnPpHd9qUiw10YrYP7bdFmBZp5pm6rRx6wqLNitxFBFYj3tlpnxM6f3nm16LTf+v9pl
         YYhyUufa9hr+iowyVA8VIIRG2JTvpGBVzjvp5gFizRbp3JMP/jN1HsjFCU54CyIUK6oJ
         u71Q==
X-Gm-Message-State: AOAM531MBwcINKxJtw1RPkxruBJFc+QTvt094WUjoVzu9Q7NZd2tUK1i
        IMFSg5U1YNWTqT1pN5dqPvg=
X-Google-Smtp-Source: ABdhPJyvmJv4uXJsxkLlkbrO1wG4kwi3D99EUsIl+tbuYjBX1Gk1oJ3fY9NR2Acv3pMVeRzs92rZng==
X-Received: by 2002:a92:d2ce:: with SMTP id w14mr5111289ilg.217.1624098614544;
        Sat, 19 Jun 2021 03:30:14 -0700 (PDT)
Received: from ip-172-31-30-86.us-east-2.compute.internal (ec2-18-118-82-35.us-east-2.compute.amazonaws.com. [18.118.82.35])
        by smtp.gmail.com with ESMTPSA id l5sm6141996ion.44.2021.06.19.03.30.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Jun 2021 03:30:13 -0700 (PDT)
Date:   Sat, 19 Jun 2021 10:30:09 +0000
From:   Yunsheng Lin <yunshenglin0825@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Subject: Re: [PATCH net v2] net: sched: add barrier to ensure correct
 ordering for lockless qdisc
Message-ID: <20210619103009.GA1530@ip-172-31-30-86.us-east-2.compute.internal>
References: <1623891854-57416-1-git-send-email-linyunsheng@huawei.com>
 <20210618173047.68db0b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210618173837.0131edc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618173837.0131edc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 05:38:37PM -0700, Jakub Kicinski wrote:
> On Fri, 18 Jun 2021 17:30:47 -0700 Jakub Kicinski wrote:
> > On Thu, 17 Jun 2021 09:04:14 +0800 Yunsheng Lin wrote:
> > > The spin_trylock() was assumed to contain the implicit
> > > barrier needed to ensure the correct ordering between
> > > STATE_MISSED setting/clearing and STATE_MISSED checking
> > > in commit a90c57f2cedd ("net: sched: fix packet stuck
> > > problem for lockless qdisc").
> > > 
> > > But it turns out that spin_trylock() only has load-acquire
> > > semantic, for strongly-ordered system(like x86), the compiler
> > > barrier implicitly contained in spin_trylock() seems enough
> > > to ensure the correct ordering. But for weakly-orderly system
> > > (like arm64), the store-release semantic is needed to ensure
> > > the correct ordering as clear_bit() and test_bit() is store
> > > operation, see queued_spin_lock().
> > > 
> > > So add the explicit barrier to ensure the correct ordering
> > > for the above case.
> > > 
> > > Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")
> > > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>  
> > 
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Actually.. do we really need the _before_atomic() barrier?
> I'd think we only need to make sure we re-check the lock 
> after we set the bit, ordering of the first check doesn't 
> matter.

When debugging pointed to the misordering between STATE_MISSED
setting/clearing and STATE_MISSED checking, only _after_atomic()
was added first, and it did not fix the misordering problem,
when both _before_atomic() and _after_atomic() were added, the
misordering problem disappeared.

I suppose _before_atomic() matters because the STATE_MISSED
setting and the lock rechecking is only done when first check of
STATE_MISSED returns false. _before_atomic() is used to make sure
the first check returns correct result, if it does not return the
correct result, then we may have misordering problem too.

     cpu0                        cpu1
                              clear MISSED
                             _after_atomic()
                                dequeue
    enqueue
 first trylock() #false
  MISSED check #*true* ?

As above, even cpu1 has a _after_atomic() between clearing
STATE_MISSED and dequeuing, we might stiil need a barrier to
prevent cpu0 doing speculative MISSED checking before cpu1
clearing MISSED?

And the implicit load-acquire barrier contained in the first
trylock() does not seems to prevent the above case too.

And there is no load-acquire barrier in pfifo_fast_dequeue()
too, which possibly make the above case more likely to happen.
