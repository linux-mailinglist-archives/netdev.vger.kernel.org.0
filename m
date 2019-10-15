Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876EDD848F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbfJOXpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:45:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38285 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbfJOXpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:45:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so13485260pfe.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 16:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zde/2EvOGyJVHgELKq3tUH6iDHa5DC1abeaGck2Hkeg=;
        b=Zg86mDDWBEjHecKXKUnKcm6jCJvouNz1uVLYrpeKJBIEEpp1EdotbSguvhU8SYOAqz
         fIxIcRM8cMpjqAYuMfo4EPYNL/y752pVbIbOTXJHaIxd1dF6JN091zp/4mKULxxzW4+Z
         ZGQ66fkFzQLuo5hYoDYIV2K5vWWWIDodcQTYrv6B4l644zaeO8wn3XF51bMpf2C5GOzj
         qWZ4Y2uyVLObYYLPjl7Tq7j5kQrrq8LD47xZfSmksNadQb4A2HW/wDY67RgmLFtwD490
         NKi91yQfy9l1LZKgzfP6MCs4rvfbNBC6j+bEPQMFnoejhYO3Vq5EtN/oD4oFYMJyazaQ
         sMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zde/2EvOGyJVHgELKq3tUH6iDHa5DC1abeaGck2Hkeg=;
        b=f/RMMiCqUNuMX0+4Zb9Bm3f9tCBBPbb1CRKYZy6Muoi87V9D+f+K2ZmxN7YdGoHdhV
         my++g/HeM4si4VyLi/4JyPhEL3JfaP7HQF3PufGWb/ZlwC05iC14aJNOzvWVEXNh4FG+
         eebdlfZuq2B/K63qw+jib4x42bFcjOffZq9YV3/ZQ3ctqAA7pE3Irf1uSUie5e6A2yFY
         1negCnRXGa2kSvSgcRgEhSuuXV1pwcTqX5N1uAHsYR2S28HAJakHRQDJOhvSh4DaFhUU
         8b4N5X5BdK6ZkWE/CeW+Dp7TK//iqWO28ZUKq4lTO1azxsxlR7J6ZIQa5C6dmQKUHJdH
         4FiQ==
X-Gm-Message-State: APjAAAX4mldYiVSpRGi0tNvhRVygDzHnHV8/Ukb3PTw3Pp7yrhzTlcCG
        n50OM4g0grR7f55DIOsZxEX7cA==
X-Google-Smtp-Source: APXvYqzen9OMXKNPAMisvZj8Ft/zTLPHT3WPx5UqTdL7nBQZJFMktDJFDKXRWA6oKSP72gjBwrICHQ==
X-Received: by 2002:a62:6842:: with SMTP id d63mr40591333pfc.16.1571183153820;
        Tue, 15 Oct 2019 16:45:53 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w14sm42330817pge.56.2019.10.15.16.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 16:45:53 -0700 (PDT)
Date:   Tue, 15 Oct 2019 16:45:52 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in
 BPF_PROG_TEST_RUN
Message-ID: <20191015234552.GC1897241@mini-arch>
References: <20191015183125.124413-1-sdf@google.com>
 <CAEf4Bzb+ZjwA-Jxd4fD6nkYnKGAjOt=2Pz-4GNWBbxtNZJ85UQ@mail.gmail.com>
 <CAADnVQKUV2TEDdekj0xApPqm6q0kCK-SvvpT5=80YQcsfuvXFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKUV2TEDdekj0xApPqm6q0kCK-SvvpT5=80YQcsfuvXFw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15, Alexei Starovoitov wrote:
> On Tue, Oct 15, 2019 at 4:15 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 15, 2019 at 2:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > It's useful for implementing EDT related tests (set tstamp, run the
> > > test, see how the tstamp is changed or observe some other parameter).
> > >
> > > Note that bpf_ktime_get_ns() helper is using monotonic clock, so for
> > > the BPF programs that compare tstamp against it, tstamp should be
> > > derived from clock_gettime(CLOCK_MONOTONIC, ...).
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  net/bpf/test_run.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > > index 1153bbcdff72..0be4497cb832 100644
> > > --- a/net/bpf/test_run.c
> > > +++ b/net/bpf/test_run.c
> > > @@ -218,10 +218,18 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
> > >
> > >         if (!range_is_zero(__skb, offsetof(struct __sk_buff, cb) +
> > >                            FIELD_SIZEOF(struct __sk_buff, cb),
> > > +                          offsetof(struct __sk_buff, tstamp)))
> > > +               return -EINVAL;
> > > +
> > > +       /* tstamp is allowed */
> > > +
> > > +       if (!range_is_zero(__skb, offsetof(struct __sk_buff, tstamp) +
> > > +                          FIELD_SIZEOF(struct __sk_buff, tstamp),
> >
> > with no context on this particular change whatsoever: isn't this the
> > same as offsetofend(struct __sk_buff, tstamp)? Same above for cb.
> >
> > Overall, this seems like the 4th similar check, would it make sense to
> > add a static array of ranges we want to check for zeros and just loop
> > over it?..
> 
> I wouldn't bother, but offsetofend() is a good suggestion that
> can be done in a followup.
> 
> Applied both patches. Thanks
Thanks. I'll follow up with offsetofend, sounds like a good suggestion
that can eliminate a bit of copy paste.
