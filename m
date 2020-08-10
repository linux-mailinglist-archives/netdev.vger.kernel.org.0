Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5E240B08
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHJQOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgHJQOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 12:14:30 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AB9C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 09:14:30 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s23so7136894qtq.12
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 09:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMeg13vWWmRfIsfEbY/5L/zD3yNNUMZvprD6hKw+gec=;
        b=a9fni8Vfd4UpXTxr2z7qLy5gwuCwdpzH2PHh1Szfxk9gTprR91QktXc2t8Lckk/xPN
         0hB/uzCBiOaglNEt8IlGQLguGXIIgB0UScz7d2QJ0I5iQH0lgFJLnF57qKD220Z7Xum1
         cCY4mNmPdr0pJMNpYebJRGEZUrNmWSsDYp5wT8bRx1I0tu+WYT6oU5YHcpfH8gQ8pXuc
         RY0tpcJGE4b3Wtec1Ji05eVNd00eyK3gWWDGXuYl/fvXJ/F5zerNnFUSLhpK5rEC6Kc/
         j8CksIuTM7coGU1cZB86P4IJ0TV25xSIXFBvyx9VfbAPcd9AA0z7gWlgiDVEjLJ5vHza
         y6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMeg13vWWmRfIsfEbY/5L/zD3yNNUMZvprD6hKw+gec=;
        b=mOAK1Gi25KzIHhpHzrbUFTMGU3vTeb/+4KJwLO0CEvemy/LAauBqP6cP1+wMIwT5ze
         sCObIyKGJlpdI1K6W3k3P44qjCCiJM9mFUK63q9qPYT7Wrwwu0kpqSMmSJM93F/8+Pqz
         eAH1ABaeTP1BgUf2Lk2GlWvCHi8WhqDpy70NEetcQpXn9GtclrWJ+x71dggoADu/1Ox9
         jQOCF+iMQmUHHj1SjNNPmkjIMTl1uK+di27tGlijnGnepV0HcpcPR1pZuoXlh2kg+aKz
         D8PRM0vO1P8TumT23gW7dNaW5v/ybnU7sriCAYP3BW5MoSudZFDvUMGdr/2KYLjRxNUH
         qocQ==
X-Gm-Message-State: AOAM533+BnRnsBLtpemklo481Emt6tszTvPN70XCYK/OGvxwdvGH8aYR
        yZiYnixLAsWbd4tA8JKZnHHhyQDkb0vq2PCb6KtUpHR8RQFFpg==
X-Google-Smtp-Source: ABdhPJxWpsf+El1UxUB4GUjQpBAURdSxTZDmE18DkEoW2NvJaeHtcdgkIKz/q8xm8uZrq8lV4BT46lCcv8sV47uo3aU=
X-Received: by 2002:ac8:5505:: with SMTP id j5mr28335317qtq.326.1597076069035;
 Mon, 10 Aug 2020 09:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200807223846.4190917-1-sdf@google.com> <87zh756kn7.fsf@cloudflare.com>
In-Reply-To: <87zh756kn7.fsf@cloudflare.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 10 Aug 2020 09:14:18 -0700
Message-ID: <CAKH8qBswCOU6oK2rLkUADRF-NUgwcHB-MyWNV+ug_cLRxnQBeQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix v4_to_v6 in sk_lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 11:46 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sat, Aug 08, 2020 at 12:38 AM CEST, Stanislav Fomichev wrote:
> > I'm getting some garbage in bytes 8 and 9 when doing conversion
> > from sockaddr_in to sockaddr_in6 (leftover from AF_INET?).
> > Let's explicitly clear the higher bytes.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> > index c571584c00f5..9ff0412e1fd3 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> > @@ -309,6 +309,7 @@ static void v4_to_v6(struct sockaddr_storage *ss)
> >       v6->sin6_addr.s6_addr[10] = 0xff;
> >       v6->sin6_addr.s6_addr[11] = 0xff;
> >       memcpy(&v6->sin6_addr.s6_addr[12], &v4.sin_addr.s_addr, 4);
> > +     memset(&v6->sin6_addr.s6_addr[0], 0, 10);
> >  }
> >
> >  static int udp_recv_send(int server_fd)
>
> That was badly written. Sorry about that. And thanks for the fix.
>
> I'd even zero out the whole thing:
>
>         memset(v6, 0, sizeof(*v6));
>
> ... because right now IPv4 address is left as sin6_flowinfo.  I can
> follow up with that change, unless you'd like to roll a v2.
Up to you, but I'm not sure zeroing out the whole v6 portion is the
best way forward.
IMO, it's a bit confusing when reading the code.
It will work, but only because v4 and v6 address portions don't really
overlap :-/
I was thinking about adding new, on the stack sin6, fully initializing
it and then doing memcpy into ss.
But I decided that adding memset is probably good enough :-)
