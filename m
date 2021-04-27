Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F64636C976
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbhD0Q3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbhD0Q3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:29:31 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A0CC061574;
        Tue, 27 Apr 2021 09:28:46 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s9so11752861ybe.5;
        Tue, 27 Apr 2021 09:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IF3AMLseGg38yeYt0vbEDzgGMSelgzNHK5pThEOR2VA=;
        b=Rju9AcE4ILD4p86JXZ7bqZAAMZzvegFNDgA4kzCk9tAZ2wJweU4U0KU9l9zsF7RETv
         +F79tL/M+5ERy4eB3pQIllzYMWp9NbVXZ87D7u30abw4gixwd9Nyq3Ah0YpgKYupsLny
         7CPWpG5e3cwG2KzP+yA4nS4vvjLk9kZCqXdTK5SY5LpkWmocbadwsoA3v+JHqJf+maZg
         4/n0P+iD3u5tIb9sF+9O5GazqXTtUJduyOuVN/Aw9DvmlA8KDwCqLpmwq7HxmsR8fAry
         OwoSinn1WGoXUHrVok2yeyixmZvWcM2I8jzY6R4klZxln5N5n0IGy8hxyt3hp4TNLE2i
         F2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IF3AMLseGg38yeYt0vbEDzgGMSelgzNHK5pThEOR2VA=;
        b=NU0lOXt0lrnujL58XIGnMl24zQMdOR7jACIWnfgm5otueJYwwilMB7D/uvyUQ9ZAvI
         FNrBAru/t2hwTrgUNKFGQpSeojAPZewtO/tjCHMYouvaJ9Tjmn+XMQS2D+VV1UlusqCx
         FBPIJHa6D+35eZT0nYncJLQu/V8CjIdOwgHEsk8naQ/zggT9eGnKN0no3W7GJ+2WEFn6
         1/TALjJ4qhpdXEmqrkxdOihq2m/O95McT/jYPE6RDvDqjcmOVyH7gZLNWru+/C0u9Zkq
         F8JiY/mFOBsNaZX8e5Gk1bAz02rYdxN0CSSasPmSOrTcHmNezaD+/+OXGTwPCYgGoO0H
         8T5g==
X-Gm-Message-State: AOAM533kdkapBz7QK+CmpxaAkE3YZtWV311N2XkwfkAnA59ifAPvSS4z
        T1OOYzW0apRWUPoMnvE05C5bX2ffBpVN4ULa6w6djl+W
X-Google-Smtp-Source: ABdhPJw0ZhKRUd75ZmpCGKkbQnjr1S2/n/YCJbEu3GZoZKXf3QFp3G/wz8N8Y/rSnzI9S6JtQCw857Ktlh+kgAP3WSg=
X-Received: by 2002:a5b:489:: with SMTP id n9mr33527556ybp.45.1619540926184;
 Tue, 27 Apr 2021 09:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-6-alexei.starovoitov@gmail.com> <CAEf4BzafXkmX5RJ+c+4h9ZXV6mvto=Shx3JWL1m_AkXc9pU_4g@mail.gmail.com>
 <20210427024331.njt2conhkmhkuosx@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427024331.njt2conhkmhkuosx@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 09:28:35 -0700
Message-ID: <CAEf4BzZ2FZN3ThKiH6Aa98tq=zFCxssEuCe_YXniS7R_WhpDGQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/16] selftests/bpf: Test for syscall program type
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 7:43 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 10:02:59AM -0700, Andrii Nakryiko wrote:
> > > +/* Copyright (c) 2021 Facebook */
> > > +#include <linux/stddef.h>
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +#include <bpf/bpf_tracing.h>
> > > +#include <../../tools/include/linux/filter.h>
> >
> > with TOOLSINCDIR shouldn't this be just <linux/fiter.h>?
>
> sadly no. There is uapi/linux/filter.h that gets included first.
> And changing the order of -Is brings the whole set of other issues.
> I couldn't come up with anything better unfortunately.

Then let's at least drop TOOLSINCDIR for now, if it's not really used?
