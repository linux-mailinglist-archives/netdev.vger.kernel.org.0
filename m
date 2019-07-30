Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF067B627
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfG3XR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 19:17:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36633 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfG3XR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 19:17:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so30627742pfl.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 16:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3NkrX7S/SZE/z05nSflRVpipYiefIx5yaTiBZV+O61U=;
        b=FjinH4xTcY1UJoby94aPZXIkB1zOVd1v4g+fpQ+TdCC0rDG//+dYrDlgiwItrpGgJj
         HC+FvHCxU9vYumhTymtd1yhktVXSY4gJpiXyHezqSgpBfYiAmnKkebsN486U+Vp5loaA
         NgLjnvRqgKDRTxivQtDeukZIZG/Gm/D1CA3H+CXrKInD4zNZ3IfBmmpAQhLFJgqTzmR4
         22n2G0KExOyAG0EX33InFc1XuTXugex4NUa8KOIZ3QunfSKVkoo7zBMV/gipysG6jfZy
         MHG/2YCc+C8mjxdlH7dbGN3xCsNJexSNEHgw4i5UzkqAwGHHmnYyka94cVk8hau0H9mv
         ZNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3NkrX7S/SZE/z05nSflRVpipYiefIx5yaTiBZV+O61U=;
        b=NbH+/H0btQwCO0VUgotrm1qnV8X40Z3PlBBjXApo0uDHC17eC4euDTkf/6mbhwNvV9
         QhIaA1IdR3B7l+CM+f7RF8znjBRxrnvxlhFTK1znTi7u2EnEPfn3be9+SbXud8dMZyqK
         0yecuoYQZZkMDw6BoVGeIhjA0K1QHLZE0Oj9QohYveQeh+5iLKdHyNHDM10DksiPFbPf
         2Pi2jtyntR4ph/1/lVD7y52gwaecQbdgWOlgSW7iwJ5lXb39WPtjHtQsh5W7zIt3TtgZ
         WviCBtN4fqKnPn55E7TU7Mv+WgmSRpaCOcSp/eNnK7kTdmDm5kl508EX5Ujc8oNko1CV
         ynyw==
X-Gm-Message-State: APjAAAUUrQkJosF65XmF7VszueLJ5HmgjfdIdQ5I/XRATissbAD36s4E
        uaiSY5fhJHv/4bxgPnonc5Q=
X-Google-Smtp-Source: APXvYqyzfZobJ9mf1E6X5KuJ0FXAQw5PJMuqRThhwKwb6HUBHESIIi/P7Jc0wsQr4WXUcYuUUlPHMw==
X-Received: by 2002:a17:90a:220a:: with SMTP id c10mr121242062pje.33.1564528678672;
        Tue, 30 Jul 2019 16:17:58 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:af4b])
        by smtp.gmail.com with ESMTPSA id r7sm77051003pfl.134.2019.07.30.16.17.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 16:17:57 -0700 (PDT)
Date:   Tue, 30 Jul 2019 16:17:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
Message-ID: <20190730231754.efh3fj4mnsbv445l@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
 <20190730155915.5bbe3a03@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730155915.5bbe3a03@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 03:59:15PM -0700, Jakub Kicinski wrote:
> On Wed, 31 Jul 2019 03:48:19 +0900, Daniel T. Lee wrote:
> > Currently, bpftool net only supports dumping progs loaded on the
> > interface. To load XDP prog on interface, user must use other tool
> > (eg. iproute2). By this patch, with `bpftool net (un)load`, user can
> > (un)load XDP prog on interface.
> 
> I don't understand why using another tool is a bad thing :(
> What happened to the Unix philosophy?
> 
> I remain opposed to duplicating iproute2's functionality under 
> bpftool net :( The way to attach bpf programs in the networking
> subsystem is through the iproute2 commends - ip and tc.. 
> 
> It seems easy enough to add a feature to bpftool but from 
> a perspective of someone adding a new feature to the kernel, 
> and wanting to update user space components it's quite painful :(
> 
> So could you describe to me in more detail why this is a good idea?
> Perhaps others can chime in?

I don't think it has anything to do with 'unix philosophy'.
Here the proposal to teach bpftool to attach xdp progs.
I see nothing wrong with that.
Another reason is iproute2 is still far away from adopting libbpf.
So all the latest goodness like BTF, introspection, etc will not
be available to iproute2 users for some time.
Even when iproute2 is ready it would be convenient for folks like me
(who need to debug stuff in production) to remember cmd line of
bpftool only to introspect the server. Debugging often includes
detaching/attaching progs. Not only doing 'bpftool p s'.

If bpftool was taught to do equivalent of 'ip link' that would be
very different story and I would be opposed to that.

