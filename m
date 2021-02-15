Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771F031C231
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBOTIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhBOTIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:08:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E2CC061574;
        Mon, 15 Feb 2021 11:08:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z9so4442112pjl.5;
        Mon, 15 Feb 2021 11:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wSIIQAoU/qUrHpFtDE4/r1lSSmKppFfAx3tPckyTMg=;
        b=WbZcgfONHMSwsib7jyirAckorAOZ9aIz8BGaGHSxzE9IBK0w2zS4RqERyv2kXqLehJ
         3t8lWW9K6eT2uy0zdiiz5yw0F973t4nNTNikpF/3wmhOu4W+uyQhaNPTzHPv6VQ/2hUY
         KnTwYi3LIV47D4qZMGp4KzyAZ5M5bA3FNgErZoYU6Jgld4bPjW3+WRUSdght+GGuXTZp
         daPGMuEim6QxghMcWiixp9ekOdJZUBSvPyCR3vEmPtVYD0uvuYoCgON6wsyhzteVgbij
         yi8/6n0rOG9nERGp9qWfRIavxLSavRIlWxuocVYOSKY7Xp42kWhkmvRtGstyQJR3MyiF
         /Ncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wSIIQAoU/qUrHpFtDE4/r1lSSmKppFfAx3tPckyTMg=;
        b=A5IsLRspe+UuP//qIrGmUFgiAN9k2BPqYZocqxEJeFTXpukzu7ek+mIQS0M4zJd1Gx
         XzZSvzVFpcKr1w67iBinFhXoV5qCf1ze70KqHsgzOoYMhiR6JEq5wHJ6FHWELHH8CocY
         sBya1M4/C1H/sUTfG3i3dfnXQAhGEtSmyVoxoxh20b7pmPLWnwWBS+S12kOT9MGA9v7I
         9eEBLQ0DnH4GW3ZFyNZnSTxn6z8WG5x6f8vNRMxRuSGKFNoWxhqHOsc5iBvgb9xpRbGn
         zBW+v9GyATqcoW2IQmTYRGoJPkYgp8fnViSIhROaLQh/a7vaFq6l9MQ0uNZWSfSjz69V
         AHWw==
X-Gm-Message-State: AOAM530MtjHReV0iQ90QWYzojAWkmwEwAn4fWXtiIDHtxtIT7YeP3dYm
        Hk8HocUN9YgqYNv83+czL7exOPNRu4WxebvIYXkYDo7O
X-Google-Smtp-Source: ABdhPJxDZr+X+ZsMEuCZzWkgLuUXSqSIjI3o/9+cA1CacZg3xnxdlHN5Yv/Z3oJQVozefnLe/dMGd0jGtjOZgc/zmwI=
X-Received: by 2002:a17:903:310f:b029:e3:53e8:bfe6 with SMTP id
 w15-20020a170903310fb02900e353e8bfe6mr6541429plc.78.1613416093556; Mon, 15
 Feb 2021 11:08:13 -0800 (PST)
MIME-Version: 1.0
References: <20210215072703.43952-1-xie.he.0141@gmail.com> <YCo96zjXHyvKpbUM@unreal>
 <CAJht_EOQBDdwa0keS9XTKZgXE44_b5cHJt=fFaKy-wFDpe6iaw@mail.gmail.com> <YCrDcMYgSgdKp4eX@unreal>
In-Reply-To: <YCrDcMYgSgdKp4eX@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 15 Feb 2021 11:08:02 -0800
Message-ID: <CAJht_EPy1Us72YGMune2G3s1TLB4TOCBFJpZt+KbVUV8uoFbfA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v3] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 10:54 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Feb 15, 2021 at 09:23:32AM -0800, Xie He wrote:
> > On Mon, Feb 15, 2021 at 1:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > > +     /* When transmitting data:
> > > > +      * first we'll remove a pseudo header of 1 byte,
> > > > +      * then the LAPB module will prepend an LAPB header of at most 3 bytes.
> > > > +      */
> > > > +     dev->needed_headroom = 3 - 1;
> > >
> > > 3 - 1 = 2
> > >
> > > Thanks
> >
> > Actually this is intentional. It makes the numbers more meaningful.
> >
> > The compiler should automatically generate the "2" so there would be
> > no runtime penalty.
>
> If you want it intentional, write it in the comment.
>
> /* When transmitting data, we will need extra 2 bytes headroom,
>  * which are 3 bytes of LAPB header minus one byte of pseudo header.
>  */
>  dev->needed_headroom = 2;

I think this is unnecessary. The current comment already explains the
meaning of the "1" and the "3". There's no need for a reader of this
code to understand what a "2" is. That is the job of the compiler, not
the human reader.
