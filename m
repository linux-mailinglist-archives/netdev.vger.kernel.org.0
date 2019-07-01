Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892FE5B87A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfGAJ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:58:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45780 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfGAJ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:58:24 -0400
Received: by mail-ot1-f67.google.com with SMTP id x21so12847922otq.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ltOwdFJBUeid9JNdOaIc/hCE/8vObspqsg4V5ZbCWJY=;
        b=k5KYN26jBm7AeiB8FBGHM/6JKFM6yng4e5wZjzn1bkv4fFj3ncw34GqQzkFCLbRrQ6
         ZmtVh2c7cIaZUv7cQMcMUn2YRZgRXFrsHvK4T1vIo+0F1f/FkQALbUjg12dKKBNLqYJG
         4V0jLXrl7JkyRvukFBLVJbRkQ1YTfUr0VvC/urPqUuAiU8ipfUnR46b7Bvx2GiDsbKLc
         6LO4ddK7nISsK8O9wBdINa3DhKBIqs37Ns+EHla0GD32gTSIxAfIT2UPeco7OUR9QCJN
         xf4zmYYEb2UFKPfxyEqf4gdyL0I7iJiRnSCrq9ITKZbwjfdckWwO4Zw/sxnISBy0kt2B
         +ebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltOwdFJBUeid9JNdOaIc/hCE/8vObspqsg4V5ZbCWJY=;
        b=PAnzk35k/SHDWCtFi0/Y+KZDvYth1NGVsLZfNgaVFSKLDSplmQKhS8RgAIYvxhuhHT
         /NHkBd15eOtX9dGXEYfkqGjKEmcx/XIOi0DP+Z+vRH1+758W+ys4slmYZjD6aSR5lVAg
         KsR1juPuu3sFvZfn6dLSc5DaEjtA1IOAR4cvl7Avd1p0vxTHiKQhd25VMXvofHexNHxj
         VdjTirPXLa3VjBZV7Gq6SrGe4DplN//5BRWUPPjTIZtwCrxJ43yAbwAqV8r9uhc8X//X
         R6/EFH2DX/p9HMHti226JzJKYcGiU1pCQYa19f+U4UNVM9IdXKTLcxD4plcfAIl5+/9L
         O6Gg==
X-Gm-Message-State: APjAAAV84aBl4pUJZamVVKmO3yWuMdLqzSfedIuBJ4i5JQ18lO19SURA
        0ZNUPQBPi1Itw8H8Hdy0GGoAgcMbGkUq6+7YxvA=
X-Google-Smtp-Source: APXvYqy8AYjL78fKi3wdZInbLqtwMsh+g6gbRKbDoP1UrMyUb9ZXRBSVve6Oc8M+PUykIXx20kdg9t1yF9xVtDVnY18=
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr564000oto.39.1561975103774;
 Mon, 01 Jul 2019 02:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
 <20190627220836.2572684-3-jonathan.lemon@gmail.com> <20190627153856.1f4d4709@cakuba.netronome.com>
 <8E97A6A3-2B8D-4E03-960B-8625DA3BA4FF@gmail.com> <20190628134121.2f54c349@cakuba.netronome.com>
 <8E655F8E-1896-4EB9-992A-F93C64F2B490@gmail.com>
In-Reply-To: <8E655F8E-1896-4EB9-992A-F93C64F2B490@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 1 Jul 2019 11:58:12 +0200
Message-ID: <CAJ8uoz17WGtA2GdDYvRrwFo4=oVS5+wfbDWV9B_iMdHjAsq_bA@mail.gmail.com>
Subject: Re: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:09 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
>
>
> On 28 Jun 2019, at 13:41, Jakub Kicinski wrote:
>
> > On Thu, 27 Jun 2019 19:31:26 -0700, Jonathan Lemon wrote:
> >> On 27 Jun 2019, at 15:38, Jakub Kicinski wrote:
> >>
> >>> On Thu, 27 Jun 2019 15:08:32 -0700, Jonathan Lemon wrote:
> >>>> The reuseq is actually a recycle stack, only accessed from the kernel
> >>>> side.
> >>>> Also, the implementation details of the stack should belong to the
> >>>> umem
> >>>> object, and not exposed to the caller.
> >>>>
> >>>> Clean up and rename for consistency in preparation for the next
> >>>> patch.
> >>>>
> >>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >>>
> >>> Prepare/swap is to cater to how drivers should be written - being able
> >>> to allocate resources independently of those currently used.  Allowing
> >>> for changing ring sizes and counts on the fly.  This patch makes it
> >>> harder to write drivers in the way we are encouraging people to.
> >>>
> >>> IOW no, please don't do this.
> >>
> >> The main reason I rewrote this was to provide the same type
> >> of functionality as realloc() - no need to allocate/initialize a new
> >> array if the old one would still end up being used.  This would seem
> >> to be a win for the typical case of having the interface go up/down.
> >>
> >> Perhaps I should have named the function differently?
> >
> > Perhaps add a helper which calls both parts to help poorly architected
> > drivers?
>
> Still ends up taking more memory.
>
> There are only 3 drivers in the tree which do AF_XDP: i40e, ixgbe, and mlx5.
>
> All of these do the same thing:
>     reuseq = xsk_reuseq_prepare(n)
>     if (!reuseq)
>        error
>     xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
>
> I figured simplifying was a good thing.
>
> But I do take your point that some future driver might want to allocate
> everything up front before performing a commit of the resources.

Jonathan, can you come up with a solution that satisfies both these
goals: providing a lower level API that Jakub can and would like to
use for his driver and a higher level helper that can be used by
today's driver to make the AF_XDP part smaller and easier to
implement? I like the fact that you are simplifying the AF_XDP enabled
drivers that are out there today, but at the same time I do not want
to hinder Jakub from, hopefully, in the future upstreaming his
support.

Thanks: Magnus

> --
> Jonathan
