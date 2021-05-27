Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D162393125
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhE0On0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhE0OnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:43:24 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE5AC061574;
        Thu, 27 May 2021 07:41:49 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id b13so1009902ybk.4;
        Thu, 27 May 2021 07:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/Mn6m+0szuABGuNz4gdUEHH56ZKs2OQ3Dg8rDpxUzE=;
        b=XSW/W9WafmbrRZlc24lBgVOfwJ3pmFDiHzO44/xGvx7QKma/0OZXuepoaClYwEoYQL
         SUAr+kcAGGWYZ0fwQPpeTk358Rq/QVRXArqaLfrfbsG7rDfwAjtOCsQiwht90BVTbgGw
         CmhIq5/fs0DkSoIGxAmaLQy/EGSjgSXbQkpC0sAkBanhFAtwwDG6qkCmzIc26Udl5raY
         otShNCca77NEr/SI1VVhSU/+TKHLMlqrwbwd5zlesBlM34uqh5JpWhzZkNtCSRiYDsZE
         k2LBbSttOkkJuPJESN2+guVZTdIGm9cezRKbXnbvdn+CCZWZatV9dRDqeWa9mx2F0Ut+
         cDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/Mn6m+0szuABGuNz4gdUEHH56ZKs2OQ3Dg8rDpxUzE=;
        b=ettNYMPOrKPJ7LCKGbnEyD9bePESWSbFx6fQ2E7+w6GQsxjQP3YUsdINTMzTMpj0i5
         ay7DmE9bDYOxiko2uxjOQ75unhq4pkRfz9IJRqsAstfYH5rUwXx/umobDxBngqtNPx16
         73TEDCxSGZeXYNv64aoI/KBBXvJnzZWWpjvSqHM0o8kBpD8CouK2OHDXOSUDgbY0Gh7K
         G9Ox4aguqzh1g0Z3tINDeJMOOF70z0XVChG4rxVGlGoRsdbLUZhHNSKzQb4ThILEFbM7
         FeUibajWzFRbj2bRPtP3x+coAL6TOgBdFaSnU3ZNBvZqgXkDlx1LyUR60CFcNL+jsCMV
         V7ng==
X-Gm-Message-State: AOAM533NusCSsrC9ZWoGLBNC1tFESVOfKuqmE3gftJtZASv5gHs9ueZj
        ngBpu5Nsg1ujE6koqa6kzFJx6MJYQkvKkxNyxGo=
X-Google-Smtp-Source: ABdhPJxzJi1mIJCB7dkcmXbe4qDmLn1jrkqvUTD5Pi1mP9hJzrJ8ltrWO/v6eOsEXIj4lRFJpqjsZt/HSHtfTfFtyqE=
X-Received: by 2002:a25:1455:: with SMTP id 82mr5241773ybu.403.1622126508714;
 Thu, 27 May 2021 07:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net> <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net> <YK9j3YeMTZ+0I8NA@infradead.org> <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 07:41:37 -0700
Message-ID: <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 7:37 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 27, 2021 at 2:19 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, May 27, 2021 at 10:04:22AM +0100, Mel Gorman wrote:
> > > What do you suggest as an alternative?
> > >
> > > I added Arnaldo to the cc as he tagged the last released version of
> > > pahole (1.21) and may be able to tag a 1.22 with Andrii's fix for pahole
> > > included.
> > >
> > > The most obvious alternative fix for this issue is to require pahole
> > > 1.22 to set CONFIG_DEBUG_INFO_BTF but obviously a version 1.22 that works
> > > needs to exist first and right now it does not. I'd be ok with this but
> > > users of DEBUG_INFO_BTF may object given that it'll be impossible to set
> > > the option until there is a release.
> >
> > Yes, disable BTF.  Empty structs are a very useful feature that we use
> > in various places in the kernel.  We can't just keep piling hacks over
> > hacks to make that work with a recent fringe feature.

Sorry, I accidentally send out empty response.

CONFIG_DEBUG_INFO_BTF is a crucial piece of modern BPF ecosystem. It
is enabled by default by most popular Linux distros. So it's hardly a
fringe feature and is something that many people and applications
depend on.

I agree that empty structs are useful, but here we are talking about
per-CPU variables only, which is the first use case so far, as far as
I can see. If we had pahole 1.22 released and widely packaged it could
have been a viable option to force it on everyone. But right now
that's not the case. So while ugly, making sure pagesets is
non-zero-sized is going to avoid a lot of pain for a lot of people. By
the time we need another zero-sized per-CPU var, we might be able to
force pahole to 1.22.
