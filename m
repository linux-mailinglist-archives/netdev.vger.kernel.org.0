Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2E7B67D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfGaAHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:07:40 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35053 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGaAHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:07:40 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so47979565qke.2
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 17:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1p3DaCLg9S/tgmzxpBDiiC5B+Zd96jER2OLDmXrqQF4=;
        b=nzMPrDnMyxR1657uPgIX6XTe6EnEOWzIzfrXScYYsYjRaubIf+37cLxh84+bwmwqZ8
         VN3knUnhkkyKA3s1vGfVlU0p/668HHa9x+DtfiAaIAixcc0Opx10GgASVSW/0tHq7z7J
         l/0bABq0cxSwDJXtdXrqY8fYgqb4eNZJh/d+ppTryTACQV2mirOY4ETGp8487cMlWdP0
         +XkbrsNQ2oEgnRRrIoILG21K/QngkWDm8mPW7aRd3COeuBDOh+sKOHnCwWpiDsgzNTCO
         C6HSYO0svJd9AMM6Ps/yrr945Fq2vv5r4w8yqHwyv+9Kjgu9yQGOpQGDPV5fho1o6VSj
         PiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1p3DaCLg9S/tgmzxpBDiiC5B+Zd96jER2OLDmXrqQF4=;
        b=fBnTu84nQNsCAXdg/rX9U7M4HVNeMv7x2J+3DrcbqAVBtP9m1F4aJc8f0v4sjSij6h
         5uJ7iDEDdOqAZEvj8CESxD6gwiYIgTtnXN9xpaJzN5nB45tLNxo4NbMssACSn+3CcgpL
         /UCuu49Dkbfk94qwx6em4Ucr6g50qiy8euEj8jhJmavpE9qwwob2zChpqiKVVe+rcNjL
         KKnHhhLJ90pEvKKJ0xXBbB9VXnC7Tm8rxuOvqSI4qzFH3JYCSo1Y3vwpe5J1w7OY7dlw
         zopY4W6Dj2yuWvMnfzHJ3zo6CgdKgt5HRLV67FNLU4alWE2iO0mVY5XmNK04suPklfwP
         e9fg==
X-Gm-Message-State: APjAAAXWkdxOFaCmiF1Mt4onaa8k9YmkqR5xcgVJl+Q4renn6GObntne
        r8WvK52Y3sqAsmS+UU4W/+Ntvw==
X-Google-Smtp-Source: APXvYqzrI7zQraol46Q7KVyvrLpSVDbBKZZPHa3T5VCbttsxZ7F257plRW+t2/5UMWrkn4Z3RNVZCQ==
X-Received: by 2002:a05:620a:705:: with SMTP id 5mr19103251qkc.330.1564531659120;
        Tue, 30 Jul 2019 17:07:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z19sm30775951qtu.43.2019.07.30.17.07.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 17:07:38 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:07:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load
 XDP
Message-ID: <20190730170725.279761e7@cakuba.netronome.com>
In-Reply-To: <20190730231754.efh3fj4mnsbv445l@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
        <20190730155915.5bbe3a03@cakuba.netronome.com>
        <20190730231754.efh3fj4mnsbv445l@ast-mbp>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 16:17:56 -0700, Alexei Starovoitov wrote:
> On Tue, Jul 30, 2019 at 03:59:15PM -0700, Jakub Kicinski wrote:
> > On Wed, 31 Jul 2019 03:48:19 +0900, Daniel T. Lee wrote:  
> > > Currently, bpftool net only supports dumping progs loaded on the
> > > interface. To load XDP prog on interface, user must use other tool
> > > (eg. iproute2). By this patch, with `bpftool net (un)load`, user can
> > > (un)load XDP prog on interface.  
> > 
> > I don't understand why using another tool is a bad thing :(
> > What happened to the Unix philosophy?
> > 
> > I remain opposed to duplicating iproute2's functionality under 
> > bpftool net :( The way to attach bpf programs in the networking
> > subsystem is through the iproute2 commends - ip and tc.. 
> > 
> > It seems easy enough to add a feature to bpftool but from 
> > a perspective of someone adding a new feature to the kernel, 
> > and wanting to update user space components it's quite painful :(
> > 
> > So could you describe to me in more detail why this is a good idea?
> > Perhaps others can chime in?  
> 
> I don't think it has anything to do with 'unix philosophy'.
> Here the proposal to teach bpftool to attach xdp progs.
> I see nothing wrong with that.

Nothing meaning you disagree it's duplicated effort and unnecessary 
LoC the community has to maintain, review, test..?

> Another reason is iproute2 is still far away from adopting libbpf.
> So all the latest goodness like BTF, introspection, etc will not
> be available to iproute2 users for some time.

Duplicating the same features in bpftool will only diminish the
incentive for moving iproute2 to libbpf. And for folks who deal
with a wide variety of customers, often novices maintaining two
ways of doing the same thing is a hassle :(

> Even when iproute2 is ready it would be convenient for folks like me
> (who need to debug stuff in production) to remember cmd line of
> bpftool only to introspect the server. Debugging often includes
> detaching/attaching progs. Not only doing 'bpftool p s'.

Let's just put the two commands next to each other:

       ip link set xdp $PROG dev $DEV

bpftool net attach xdp $PROG dev $DEV

Are they that different?

> If bpftool was taught to do equivalent of 'ip link' that would be
> very different story and I would be opposed to that.

Yes, that'd be pretty clear cut, only the XDP stuff is a bit more 
of a judgement call.
