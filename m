Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7FAD9787
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406340AbfJPQgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:36:05 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35131 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404818AbfJPQgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:36:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id z6so20724701otb.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTD9JZxhpP5pEWy+qQhp3wBhS3wfLfoHx+FdeK88i0w=;
        b=fJUWiVKMO3zrXuKjtpgB9v7T3x+063YiRMujzbnaYrryx7W20wX9i5uaBH3UFeWto/
         OOafMBfcH4grm+LFkawxSZeGBzB8+6VzGpJhRhBRyp6kIApXX31aiIMozQFxBVEbh5SO
         B5U03CvYF+mWGfhl1CWxfQhn0U+RpNztxVSxssRnGgjsI5X+eRPRfR4S6Q6+QoLV72Av
         jIlY8McvsPBssaiDB0ZBdrJidknrrCISY7mZ5gWJ9RS2USIGbVTyeG2JGrQfn6s7Ja9V
         SzkIIYDAa5pPW8N8GLIdWNkJmJDXKzgCBhtpL+zW0mbrOQQMww6XThgTxgXl4K8We2Vq
         jFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTD9JZxhpP5pEWy+qQhp3wBhS3wfLfoHx+FdeK88i0w=;
        b=FW8YyETiGaR6pdHk2VQV+xrfngDyjXz5cJMg9zKMz4VLMS+vSSCWq2LJw/UXAOOyCx
         0pzF5/3Cp4SxgwEKEPn/u+UnqaxOJUJalXhKw5AkhfGSag+IeIGYU3eEOXu20UiTsgMI
         rJzZJPwHv5ER0P9Kdqb15pBAtB35x2c9EXSbNi/T0KqC/a3RkeNkAg+hgn3grvKZVt5b
         wGFhpJKylQJSIYatQ88ln14IJaVhkKeK+xwljOVUHVPFsV9vQj+Jo6diAK9EtEYM2Yqt
         5AUkczbA2bqwYD085JtLOhvKYQIOpTZzBe1skRSLxWefAnGtFfpGfVlDy6AMwt//mwy6
         JZIw==
X-Gm-Message-State: APjAAAXGOj9XxFU1rx7fiDB/p/IjUBV7xtCoFwoJTC1utopf517YEKq9
        Ug9iJcLneiAGaDa6bMVuVbuAZtCH45cryIXcGsn50CXp
X-Google-Smtp-Source: APXvYqwtnxn9WRIA65RDPDVj8DpxpaELfzTGqH69YKoY7i/L86GAT0gaq9VyJC2riSuZ7el2CUpK4nwC4i1HV7jCgzo=
X-Received: by 2002:a05:6830:215a:: with SMTP id r26mr31314723otd.330.1571243763717;
 Wed, 16 Oct 2019 09:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <CANSNSoVMXcPpnHBYvDJ9P4PVB2pLGEBHW2j-iD7QqQrFmGFt_Q@mail.gmail.com>
 <CAEA6p_BQp1O6jGc+RY2YAHFVC3df7MEm9he7cajUnccVCzkMvw@mail.gmail.com> <20191016063928.rwxe65paunw3jwel@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191016063928.rwxe65paunw3jwel@kafai-mbp.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 16 Oct 2019 09:35:50 -0700
Message-ID: <CAEA6p_AUxd+y9rXQ2RkggTqwmvkxDdDdrmQ=XEj4XEtn1ZFRkg@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Martin Lau <kafai@fb.com>
Cc:     Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Ido Schimmel <idosch@idosch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 11:39 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Oct 15, 2019 at 09:44:11AM -0700, Wei Wang wrote:
> > On Tue, Oct 15, 2019 at 7:29 AM Jesse Hathaway <jesse@mbuki-mvuki.org> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 12:54 PM Wei Wang <weiwan@google.com> wrote:
> > > > Hmm... Yes... I would think a per-CPU input cache should work for the
> > > > case above.
> > > > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > > > to switch out the dev, we call, rt_add_uncached_list() to add this
> > > > obsolete dst cache to the uncached list. And if the device gets
> > > > unregistered, rt_flush_dev() takes care of all dst entries in the
> > > > uncached list. I think that would work too.
> > > >
> > > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > > index dc1f510a7c81..ee618d4234ce 100644
> > > > --- a/net/ipv4/route.c
> > > > +++ b/net/ipv4/route.c
> > > > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > > > *nhc, struct rtable *rt)
> > > >         prev = cmpxchg(p, orig, rt);
> > > >         if (prev == orig) {
> > > >                 if (orig) {
> > > > -                       dst_dev_put(&orig->dst);
> > > > +                       rt_add_uncached_list(orig);
> > > >                         dst_release(&orig->dst);
> > > >                 }
> > > >         } else {
> > > >
> > >
> > > Thanks Wei for your work on this issue,
> > >
> > > Any chance this patch will make it into 5.4?
> >
> > I can submit the patch to NET branch if everyone agrees with this one liner fix.
> Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> I don't think it is a very critical bug though.  Not sure
> how far it should be ported.
>
Thanks Martin. I am preparing the patch and will send it out soon.

> > Then I believe it will be patched into the next 5.4 release automatically?
