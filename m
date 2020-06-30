Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E0420FC40
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgF3Sx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgF3Sx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:53:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01290C061755;
        Tue, 30 Jun 2020 11:53:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c1so2608431pja.5;
        Tue, 30 Jun 2020 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9a0KwjQKMXeAV0nmdFY4OU1EqQ+K6gG9zwvOGO0m7oY=;
        b=FDEQSjqTgu366Cmpoe/K7Mruj9tpRq7LoXw9jdlhHi1IR3z0BeG9SQvho/CMVVpCYS
         8SOBDUqTdJ75qXLppN+n6pSxkZBMsIdboBrz4UcVpnI4vzWbuYSntX2/XZ3f9hVXG7pL
         wNqQBavZyM6mMWngEES4TCzeasKUTtbWxTe8HVa+UNsCKjXQhKo2XwDbp9U6plnTnTFP
         efC8y66n3/a4mynK7Lj8OmUkvVSa7n+fTS+VlrazMYBlaYS9rIwQTLtryg51TJyaXLxy
         P5kI+JsoZr9VqLasIMawyJOE1GagNsUheLQd8UWYchi5GDV7N+yfhfUKhV8AptCGyfMm
         b7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9a0KwjQKMXeAV0nmdFY4OU1EqQ+K6gG9zwvOGO0m7oY=;
        b=XTpYLrI8QnQ0ZWms1pUkiYPLhnGmFSHE3crbeAMhUCHlNy9N5OXEXKNo3ne/cPpfjo
         pys0KSiumXe90dIXPBsZwBKN/o+jBxx+61BZu2zdotLiRxZetoNfoEcbkSA06VSCpd4e
         Tmw9b6OQFXyR0R+2ZL6D0EtupzaCOh1LdQJZ5vcR4gRyECjj9H53vjx3MuYBRRbSIrKS
         lNdxBjiPVIR729rKb4Gg5wHiW9tEgzfWWqEF4ErLQInmY1WcI1DvF9ChnBBrrSeaU9y4
         nd4LJRSWZPS15NjuHHqo7MWlYa445MlwZ3Ilxu/JEpqezoEOjdfhR5AjBmuHFWgwHkSc
         9UBw==
X-Gm-Message-State: AOAM533ybfh53iCh8btzdQaiiVEcTrLHEUbpOVqVJm61rfB/oP4du6LH
        OH1OpzAWLFLvYr8kgwzs29rCU7XO
X-Google-Smtp-Source: ABdhPJylpo/EGhb/o3iGo5RoCCDB4zOEi7S+7YnFv8RtZuwMJny/kQMiC6wMsggV6/SvI7/J3Xky5w==
X-Received: by 2002:a17:902:9346:: with SMTP id g6mr18596160plp.19.1593543207464;
        Tue, 30 Jun 2020 11:53:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e083])
        by smtp.gmail.com with ESMTPSA id bf11sm2909278pjb.48.2020.06.30.11.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:53:26 -0700 (PDT)
Date:   Tue, 30 Jun 2020 11:53:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH RFC v3 bpf-next 2/4] bpf: Add bpf_copy_from_user() helper.
Message-ID: <20200630185324.5elry5u3ctaohszx@ast-mbp.dhcp.thefacebook.com>
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
 <20200611222340.24081-3-alexei.starovoitov@gmail.com>
 <CAEf4BzYbvuZoQb7Sz4Q7McyEA4khHm5RaQPR3bL67owLoyv1RQ@mail.gmail.com>
 <CAADnVQ+ubYj8yA1_cO3aw-trShTHBRMJxSvZrLW75i8fM=mpvQ@mail.gmail.com>
 <CAEf4BzbfXajuL-1VLBUJsC3P796s2hk9oYGveYG5QnS2=YoN-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbfXajuL-1VLBUJsC3P796s2hk9oYGveYG5QnS2=YoN-A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:23:07AM -0700, Andrii Nakryiko wrote:
> On Mon, Jun 29, 2020 at 5:28 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 3:33 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > > > + *
> > > > + * int bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> > >
> > > Can we also add bpf_copy_str_from_user (or bpf_copy_from_user_str,
> > > whichever makes more sense) as well?
> >
> > Those would have to wait. I think strings need better long term design.
> > That would be separate patches.
> 
> I agree that it would be nice to have better support for strings, long
> term, but that's beside the point.
> 
> I think bpf_copy_from_user_str() is a must have right now as a
> sleepable counterpart to bpf_probe_read_user_str(), just like
> bpf_copy_from_user() is a sleepable variant of bpf_probe_read_user().
> Look at progs/strobemeta.h, it does bpf_probe_read_user_str() to get
> user-space zero-terminated strings. It's well defined interface and
> behavior. There is nothing extra needed beyond a sleepable variant of
> bpf_probe_read_user_str() to allow Strobemeta reliably fetch data from
> user-space from inside a sleepable BPF program.

short answer: may be.
long answer: I'm not sure that bpf_probe_read_user_str() is such a great interface.
Copy pasting something just because it exists and already known is imo not
the best approach.
I believe KP is thinking about string chunking logic to be able
to pass many null terminated strings from bpf prog to user space.
envvars is such example. It's one giant array of strings separated
by zeros. The semantics of bpf_probe_read_user_str() may or may not
be a good fit.
strobemeta is 'cheating' with strings by doing max bound on all of them.
For tracing applications like strobemeta it's ok, but for lsm it's not.
Hence I'd like to see an api that solves lsm case along with strobemeta case.
