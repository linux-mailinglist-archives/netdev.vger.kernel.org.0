Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A9939310A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhE0OjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbhE0OjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:39:11 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D07DC061574;
        Thu, 27 May 2021 07:37:35 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e10so969016ybb.7;
        Thu, 27 May 2021 07:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRnF4kAS3qhXpOKU/S5e/EyDvZ8VJSiLJYQXCB3/Htw=;
        b=XNffNLozWKxhduxFmbqbzLGjdrxdvvI+Ap0UkIe1KEJ1/tPLDUz6/Wxpl+VYiE82hB
         tBGq37HnDzHIZg2XNJ/FR+uKaCshHcyXU40xQSjEe9oRgpNbjxU0zhq3pmqrYR2qveWL
         4soK6Y+FoW9KQqFaMWZIND95qM+akKPWekrJgoozuDlWRRkGiYdxECS7FaDzKRI2ytax
         /2V8LbuQ+/c0GLNu8DcIkxnAc3iQuU71vlniIAwY2ly87GF0GN8jFxN/mlaygnZkOF56
         e0fEmvY7MQ0gz+b6VEsMPGynntb0Yzo73CZ/l9PLP4357JiApwS91S5fF1K7FYG8EHtY
         oYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRnF4kAS3qhXpOKU/S5e/EyDvZ8VJSiLJYQXCB3/Htw=;
        b=c5AtwUxca4MLFve8UrmLdDviW2dZ3rEVht8MplI5hMBhkWs3AOT6FvBmkZuhNlcbFH
         snIgIR5MJm1fp2KdgpLimfz/sFWKvcGU9OI+eWLONKU0wJlnoPv1r2/HO1zzgWBUmwym
         X0+piyKsVZRnLC3jdnbhpyW3rVwxfdNKvDN77bSGxBPKBJj5+Cpg94aG0KUe9n7wuKy5
         A50IAH5jSAI8JID2UEnPmBFRBp9lzMPMshyCMwbEGt71ZZTEk2x42Ejua5egkGkJTB+6
         +LLLP6DLRF9Pm5ZUwP31r+GuKw7HMkA6CED8dyrL8jKsXzPQlsxzjmY/L7zCM3BueD/D
         LP1w==
X-Gm-Message-State: AOAM532KgdxgvVQME+Z6HbpgqqfdU3/Xmqh258eu/nupf0Ku4aIgETTX
        c2T5b691GgTG6MRHPExnN5oRzHcy2g2J2ZFW2Jo=
X-Google-Smtp-Source: ABdhPJxmgH1A3+I50+c5X37BMXbr/rnqwS7h/1bj7Un87/hBdSe+jucE/s3XZuuOjc5PO2/sW6LnyzzFmyePJDDgkYk=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr5170003ybr.425.1622126254450;
 Thu, 27 May 2021 07:37:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net> <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net> <YK9j3YeMTZ+0I8NA@infradead.org>
In-Reply-To: <YK9j3YeMTZ+0I8NA@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 07:37:23 -0700
Message-ID: <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
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

On Thu, May 27, 2021 at 2:19 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, May 27, 2021 at 10:04:22AM +0100, Mel Gorman wrote:
> > What do you suggest as an alternative?
> >
> > I added Arnaldo to the cc as he tagged the last released version of
> > pahole (1.21) and may be able to tag a 1.22 with Andrii's fix for pahole
> > included.
> >
> > The most obvious alternative fix for this issue is to require pahole
> > 1.22 to set CONFIG_DEBUG_INFO_BTF but obviously a version 1.22 that works
> > needs to exist first and right now it does not. I'd be ok with this but
> > users of DEBUG_INFO_BTF may object given that it'll be impossible to set
> > the option until there is a release.
>
> Yes, disable BTF.  Empty structs are a very useful feature that we use
> in various places in the kernel.  We can't just keep piling hacks over
> hacks to make that work with a recent fringe feature.
