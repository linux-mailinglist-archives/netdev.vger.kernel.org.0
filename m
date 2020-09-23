Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE527634C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIWVsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWVsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:48:37 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A80FC0613CE;
        Wed, 23 Sep 2020 14:48:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id k18so844028ybh.1;
        Wed, 23 Sep 2020 14:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYpy6Y3dvNQYeEnKjK36BAueAYXhkMsnjV7+h87a38c=;
        b=NcTdZzUb/8/H1vCSXMwZnJmR76EXcKd65XpHHSQNino6w46oGVuPAyTJztdYC9wiCX
         rKUVDMcxMwjXscgr0Lclb+cJRBflymezFKXaSiEFrp9dy+ZCVv629NPSjEpA5RaN8Aok
         HHgJZQjUzaYCu4LqY60DGcRe6prOVXcN6oQ0zFKIgcKgoz9n0iu/Xe/o9mT/aDJkOJJk
         B9NPTAbwDUFNYuh9ETFYRlNIIZ0YR5+Ia0QTfW+ZYFDzTfkOwN0qJ2gGxkZHUBxOCjSx
         c6mBTy/MTGJYsH04BaKsV5hyfc3/MIN7taf4MixV+8sFgtsH86LNUaDpUKccRL1IG9Tz
         Mdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYpy6Y3dvNQYeEnKjK36BAueAYXhkMsnjV7+h87a38c=;
        b=MqS+A5jfjead+iOHrHUTfarqk5Find4plhgfNWWDtSVWCWD4eElAm98Mjc5Ll6fgdC
         b7jMgA1quDcrTRT9WaPy+kvLHbEevbFaHgNYRf6QeN6d2BisoKYYsrktVjMRZb1mIkdx
         P/+yzXVbiz2B8NJ7AqESmotw5KprP3cgqgvXsJCJn+7U2OVeQKTRDXSv7Y8lg+eYrFA4
         Lea37whQpDLCHlRORjYjMhxCBjFQLrEoi3xB6MUdDYCOr3oBo3C0bg4JbYJBEVL5QoSG
         15mazECH/EQzCH82ErgSMEexyMemX5A7y5SqJE6kGza9Lcna87jm+D+toF2L6WiKaRVq
         gVVA==
X-Gm-Message-State: AOAM532QDmkafs5hXa45F3XoHHz78nIN5RqAMrgRf4ZqUKprVnoDenYt
        gB5BHQeDxHOuQJBTApf4wk7XJNglOKWv4nvGCvo=
X-Google-Smtp-Source: ABdhPJyNKrYaGysoCv+tgn7JSDpz0aoRSmkAtPOpg1jK2VSTWQsaoFiFyT2ZOd02Mxe7nMOVgNxM5RT96s3u4UEumzY=
X-Received: by 2002:a25:730a:: with SMTP id o10mr3062527ybc.403.1600897715673;
 Wed, 23 Sep 2020 14:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
In-Reply-To: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 14:48:24 -0700
Message-ID: <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
Subject: Re: Keep bpf-next always open
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> BPF developers,
>
> The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the past we
> observed a rush of patches to get in before bpf-next closes for the duration of
> the merge window. Then there is a flood of patches right after bpf-next
> reopens. Both periods create unnecessary tension for developers and maintainers.
> In order to mitigate these issues we're planning to keep bpf-next open
> during upcoming merge window and if this experiment works out we will keep
> doing it in the future. The problem that bpf-next cannot be fully open, since
> during the merge window lots of trees get pulled by Linus with inevitable bugs
> and conflicts. The merge window is the time to fix bugs that got exposed
> because of merges and because more people test torvalds/linux.git than
> bpf/bpf-next.git.
>
> Hence starting roughly one week before the merge window few risky patches will
> be applied to the 'next' branch in the bpf-next tree instead of

Riskiness would be up to maintainers to determine or should we mark
patches with a different tag (bpf-next-next?) explicitly?

> bpf-next/master. Then during the two weeks of the merge window the patches will
> be reviewed as normal and will be applied to the 'next' branch as well. After
> Linus cuts -rc1 and net-next reopens, we will fast forward bpf-next tree to
> net-next tree and will try to merge the 'next' branch that accumulated the
> patches over these three weeks. After fast-forward the bpf-next tree might look
> very different vs its state before the merge window and there is a chance that
> some of the patches in the 'next' branch will not apply. We will try to resolve
> the conflicts as much as we can and apply them all. Essentially bpf-next/next
> is a strong promise that the patches will land into bpf-next. This scheme will
> allow developers to work on new features and post them for review and landing
> regardless of the merge window or not. Having said that the bug fixing is
> always a priority.
>
> We've considered creating a bpf-next-next.git tree for this purpose, but decided
> that bpf-next/next branch will be easier for everyone.
>
> Thoughts and comments?

I like more continuous mode, thanks! bpf-next/next branch still means
that libbpf on Github is effectively frozen for the duration of the
merge window (merging an extra branch automatically is too much pain,
we have enough fun with bpf and bpf-next trees), but let's see how it
goes.
