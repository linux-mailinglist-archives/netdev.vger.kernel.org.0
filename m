Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142A5D7C35
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfJOQoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:44:24 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38669 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfJOQoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:44:24 -0400
Received: by mail-io1-f67.google.com with SMTP id u8so47410820iom.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+eIcTGGXdASyt+L3cK4UQUkI2FqtMOlOe9yZ4FCpjg=;
        b=b/LsQHXHO7iF6mi7t/bXnSZLubUE7/1lQFWhUvuoeDf7yjPYoaTpYdQu0eyC5gDxcE
         4f1/l25RHWnod5QL5wr1U8gifwsaxcJvSRDkhPnP8SOdSy2EVHQmjOwMnjQ5QQTybhvz
         rly3XONkfA3A41ncJvDAOjoz7DLOpIOJkuxJYXT/v6keboI60+CydnRkU/2z5cpccQa9
         MmhYt5wj9WMa19bY+RfEkXfgKdC3Zqns5ChkNF50q4h21B6n7HKXdpI35KVtseXIBwSZ
         f7HZJsTVw7Vfwr7W5tV5yZHnFYQU/L2rQauVNjBoMGkiPfpFIFESAyF8W1dluB0FyQN5
         zQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+eIcTGGXdASyt+L3cK4UQUkI2FqtMOlOe9yZ4FCpjg=;
        b=o7sv02oxvvyE0MbOuDwCZaAf4DQo/UMn2MRCRTVY1hlU/i1PeND6u5aRVMIC4hQfKj
         cPeyZdMX21kqvCiqYyIRKYZrTbO53a3nWO+uRNcLCDBdKfeNKTCepv8Te/V8WST3ZLI/
         QbPWuzJtEY05ywiqHiXnZzvCEIHSbMWhKdu84Of+PLDOSJaaMwLojvPn9VDi4p3idBhV
         4KETO6JqvrEcT4mVMRGwygCPcQgjWvPSh1IwClbCR5I97zS4Q/lr3zciaBd7zW7SSd3Z
         VqAhl7LgK744FcMJlPpSeun8Llc2QEXqGxL5fYPWA9ZcLLI2pIiydSpNKe9GkL9wmaG1
         QG0g==
X-Gm-Message-State: APjAAAXI4EcWFgKgm2du30yEE04D/L0yynkB6BdHc15oy/nKsK8cYe1w
        zmzctBLzRrZPfzZcqehqNLh1qbKdIC/uDIpN77aUDg==
X-Google-Smtp-Source: APXvYqx0D8023RVIPFWWSbhp3ho2k3CeVtEIvTK/flUiodDEvZBHyV8Mudd6WJr3zzJ0Z8jsxnxyV44YZl7Ihsr+13E=
X-Received: by 2002:a92:985d:: with SMTP id l90mr7704949ili.286.1571157863049;
 Tue, 15 Oct 2019 09:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <CANSNSoVMXcPpnHBYvDJ9P4PVB2pLGEBHW2j-iD7QqQrFmGFt_Q@mail.gmail.com>
In-Reply-To: <CANSNSoVMXcPpnHBYvDJ9P4PVB2pLGEBHW2j-iD7QqQrFmGFt_Q@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 15 Oct 2019 09:44:11 -0700
Message-ID: <CAEA6p_BQp1O6jGc+RY2YAHFVC3df7MEm9he7cajUnccVCzkMvw@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Jesse Hathaway <jesse@mbuki-mvuki.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 7:29 AM Jesse Hathaway <jesse@mbuki-mvuki.org> wrote:
>
> On Fri, Oct 11, 2019 at 12:54 PM Wei Wang <weiwan@google.com> wrote:
> > Hmm... Yes... I would think a per-CPU input cache should work for the
> > case above.
> > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > to switch out the dev, we call, rt_add_uncached_list() to add this
> > obsolete dst cache to the uncached list. And if the device gets
> > unregistered, rt_flush_dev() takes care of all dst entries in the
> > uncached list. I think that would work too.
> >
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index dc1f510a7c81..ee618d4234ce 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > *nhc, struct rtable *rt)
> >         prev = cmpxchg(p, orig, rt);
> >         if (prev == orig) {
> >                 if (orig) {
> > -                       dst_dev_put(&orig->dst);
> > +                       rt_add_uncached_list(orig);
> >                         dst_release(&orig->dst);
> >                 }
> >         } else {
> >
>
> Thanks Wei for your work on this issue,
>
> Any chance this patch will make it into 5.4?

I can submit the patch to NET branch if everyone agrees with this one liner fix.
Then I believe it will be patched into the next 5.4 release automatically?
