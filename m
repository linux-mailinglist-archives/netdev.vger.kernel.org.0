Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1772318F9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 07:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgG2FQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 01:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgG2FQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 01:16:04 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4982BC061794;
        Tue, 28 Jul 2020 22:16:04 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c12so7739873qtn.9;
        Tue, 28 Jul 2020 22:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jX5yf0QJnZjcpEQTYW1U3YX8bndFjPEWG4OkpnNCvzc=;
        b=dVO1ZJSFkxLJTIAuXW5J160Hlnm1MI3+E1SGJ64dMTiOPBrSVkhjKvMZgj5CJY652N
         zWryOE7wcXQI/Ok5oR1Au908HPCCtTNAHcGx0/mcAvF5aXHkEikb3Sz9xM6Kt7ek6eMs
         bcb10GKXncyvAVn8rpSBw28Sg/VCIYt5O0UTnk+ZvB/J2ICHs5DNRmlnwEQVNZlzJ5nC
         weSBJ/HWVLBZyGCF+ssOIF/zs2LA0iKmimDyjYmlqVDGgdk2HnVnbEnFW6QwIOjmsZyi
         8wikfD/BrJN41IFPhoSgcIvOmq3cF8usGuecf8138k+4dGczkCLEP/z8YkWV36yjhQSx
         enaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jX5yf0QJnZjcpEQTYW1U3YX8bndFjPEWG4OkpnNCvzc=;
        b=md0Su7KMJ0rThlC3OeXFPongKZ9LgLszwKzjtitwDPo+GoRcYWFZVrmzLe27MtaD6L
         0ss2JeFi5rKzNu12JtDr4fBYyL7sqbbKNeTET5Q/+ELQ55a2HfhTpoAJAkGQk2BIzZEO
         fmtgvgQx96hntsgSgISVJqkEzMAIRq3uFxCD77AkImiFVUWC2ebxW95/TL5emEbSI3Qe
         MMD5I29eag9T0t0wZiZFe8RrB8rHfpvhU9UZFdaYDXjolv0rmUldIIKQjNOf08JmmDP9
         BvRMQf4aLK5yY4vASCmLTdOWcqf+W7w1Y58eNF4Ti98aBcGKW6JgT8r611bu5ctc2Z0r
         kaSg==
X-Gm-Message-State: AOAM531li6A26vawS6OJu1ZawwROVh9CpihvUbXDDeVgyDoUddcbT7ft
        Ylg86FxfgKob3+xIAUTVxMoeV87oebOmHYn4u88=
X-Google-Smtp-Source: ABdhPJwzQnEaMvnFfVx2AIlbY9Y47+07H/NaFDv0w88PjoOpLmf8l6hNi/nUHza4dBiLkfdkPanHZRlgzoCA0W/InW8=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr29614082qtd.59.1595999762284;
 Tue, 28 Jul 2020 22:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200727233431.4103-1-bimmy.pujari@intel.com> <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
 <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com> <9e9ca486-f6f5-2301-8850-8f53429b160e@gmail.com>
In-Reply-To: <9e9ca486-f6f5-2301-8850-8f53429b160e@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 22:15:51 -0700
Message-ID: <CAEf4BzaNyBHOrTrrvua1fe4PTzYvzBtY0oYw63iubgk=K84mrQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        bimmy.pujari@intel.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, mchehab@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 1:57 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/28/20 12:28 PM, Andrii Nakryiko wrote:
> > In some, yes, which also means that in some other they can't. So I'm
> > still worried about misuses of REALCLOCK, within (internal daemons
> > within the company) our outside (BCC tools and alike) of data centers.
> > Especially if people will start using it to measure elapsed time
> > between events. I'd rather not have to explain over and over again
> > that REALCLOCK is not for measuring passage of time.
>
> Why is documenting the type of clock and its limitations not sufficient?
> Users are going to make mistakes and use of gettimeofday to measure time
> differences is a common one for userspace code. That should not define
> or limit the ability to correctly and most directly do something in bpf.
>
> I have a patch to export local_clock as bpf_ktime_get_fast_ns. It too
> can be abused given that it has limitations (can not be used across CPUs
> and does not correlate to any exported clock), but it too has important
> use cases (twice as fast as bpf_ktime_get_ns and useful for per-cpu
> delta-time needs).
>
> Users have to know what they are doing; making mistakes is part of
> learning. Proper documentation is all you can do.

I don't believe that's all we can do. Designing APIs that are less
error-prone is at least one way to go about that. One can find plenty
of examples where well-documented and standardized APIs are
nevertheless misused regularly. Also, "users read and follow
documentation" doesn't match my experience, unfortunately.
