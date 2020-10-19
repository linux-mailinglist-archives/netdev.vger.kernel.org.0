Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCB2920CF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgJSBAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 21:00:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51490 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgJSBAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 21:00:30 -0400
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 7642686899; Mon, 19 Oct 2020 03:00:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1603069227;
        bh=x0qX4wCgYOfhUPOO64BV9loj3gVnQ4gOoP1bm12yY8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5L6BTdb2FvR2/pac+Nz1si3UzQaDXoiVHeooXCQQaaw2BR3TUHNGGlmn3B4Y1UvS
         Fva9ybfxcrXrLS17A7EqQGAV1u+Cmk8ykao6ILegPm7OTaj2RK1KfCPipVElPntWdm
         KOmF6BTZAWh8RSPYIY/cWyJl4+LXXeqNjL5aTvU0=
Date:   Sun, 18 Oct 2020 18:00:27 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: perf measure for stalled cycles per instruction on newer Intel
 processors
Message-ID: <20201019010026.x72tmoqv6uh76ene@two.firstfloor.org>
References: <CAJ3xEMiOtDe5OeC8oT2NyVu5BEmH_eLgAAH4voLqejWgsvG4xQ@mail.gmail.com>
 <20201015183352.o4zmciukdrdvvdj4@two.firstfloor.org>
 <CAJ3xEMgKfgbpxzxx595bG=bRM-ETm4vJfWALR3p-wVzzcHxHSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgKfgbpxzxx595bG=bRM-ETm4vJfWALR3p-wVzzcHxHSw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Don't use it. It's misleading on a out-of-order CPU because you don't
> > know if it's actually limiting anything.
> >
> > If you want useful bottleneck data use --topdown.
> 
> So running again, this time with the below params, I got this output
> where all the right most column is colored red. I wonder what can be
> said on the amount/ratio of stalls for this app - if you can maybe recommend
> some posts of yours to better understand that, I saw some comment in the
> perf-stat man page and some lwn article but wasn't really able to figure it out.

TopDown determines what limits the execution the most.

The application is mostly backend bound (55-72%). This can be either memory
issues (more common), or sometimes also execution issues. Standard perf
doesn't support a further break down beyond these high level categories,
but there are alternative tools that do (e.g. mine is "toplev" in
https://github.com/andikleen/pmu-tools or VTune)

Some references on TopDown:
https://github.com/andikleen/pmu-tools/wiki/toplev-manual
http://bit.ly/tma-ispass14

The tools above would also allow you to sample where the stalls
are occuring.

-Andi

