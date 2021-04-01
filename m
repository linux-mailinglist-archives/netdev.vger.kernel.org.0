Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611133521D3
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhDAVo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhDAVo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 17:44:28 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A32C0613E6;
        Thu,  1 Apr 2021 14:44:28 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b14so4904997lfv.8;
        Thu, 01 Apr 2021 14:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5UHqgEsaG4BovGbqPF81FuvYChe6c9272oCDYHdNkg=;
        b=eE8/j9uvnFhGf6BuQMC4WU7xwhoeyYJfwvaI7+4TNwgA8tl5PUc05hXZLGDMj5ftr2
         Lr1atxW0tNcdBEtwONv02QzXVuPDR0wc1NEqgUwbK+fDrFqEkkyYLmv2HjqMz//doT7Q
         rmmiTEdCKSZctq5j0fXw2IvoUp5CTlUZNC3jXjEqgCyjbbmN/VdqT0JD4JSyFjSUcJ9i
         rK1rQBermHh/vGwx4Z+ntQbNcbR443P9bQpts2NLlvhGpq93WOiQeBaiwl10aTx90TwF
         2Y+2nfUhL6AVYgsQc+lHuGINiUU0wvr2cQQ5lmaQ9l4UWYflto/TjTqokkzRmhA699jO
         lh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5UHqgEsaG4BovGbqPF81FuvYChe6c9272oCDYHdNkg=;
        b=o7U1v85v1vFqZznqxXb6/kCtnF9GB4o8Es/SBo6HGBPpD1pyKmu4qUpdBBidUbe3ro
         lR/gUS3fXBDa/PXy9YWa0kj22bfFJrDGG1Xy9FZp9MrNho2sBoz3XpSGbBkGaB0zd/sm
         1On57qt7vOLY1vEYh9GHyT0FR5D4Z3eE+3yyr96DWrUJ9BeQCB99IRiDfx/trWYDggFf
         lRhCESGJ1O3zCfocSAL0Y2cYh1zb85Y7aodEBSDhsNMJB+sN1QFu19ldKJO07svvTmPr
         uGAl0my+n2C9F/73QosTykRv7+5S6uknspIfVmwAysBy6NTWy6KUDi0gjLjFsR6YLim8
         GC7w==
X-Gm-Message-State: AOAM531LnfDp6cHW0PkgiEqIjdLRZqisCXImOljIbahi3Qnl0t6fjdq5
        oWkEoUCTXlX3r2wXeQE8CGVRqljJaZjKO12aK9A=
X-Google-Smtp-Source: ABdhPJx1Pvtv4tV9xeYq56fM/HgtZqpb5E1pcEg8D6OdsZRm+i/Yai4bpcat2Kb0U1ulEmUUcFpxE6U8EuGi3KJku9Q=
X-Received: by 2002:a19:ed06:: with SMTP id y6mr6899997lfy.539.1617313466544;
 Thu, 01 Apr 2021 14:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com> <CACAyw9_FHepkTzdFkiGUFV6F8u7zaZYOeH+bUjWxcBNBNeBYBg@mail.gmail.com>
In-Reply-To: <CACAyw9_FHepkTzdFkiGUFV6F8u7zaZYOeH+bUjWxcBNBNeBYBg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Apr 2021 14:44:15 -0700
Message-ID: <CAADnVQJa0UX_64exKQ-k5GQKzQSCEnsL8uHYhKmck4sEXpeewQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: link: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 7:04 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 26 Mar 2021 at 16:05, Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
> > permissions based on file_flags, but the returned fd ignores flags.
> > This means that any user can acquire a "read-write" fd for a pinned
> > link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
> > file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.
> >
> > Fix this by refusing non-O_RDWR flags in BPF_OBJ_GET. This works
> > because OBJ_GET by default returns a read write mapping and libbpf
> > doesn't expose a way to override this behaviour for programs
> > and links.
>
> Hi Alexei and Daniel,
>
> I think these two patches might have fallen through the cracks, could
> you take a look? I'm not sure what the etiquette is around bumping a
> set, so please let me know if you'd prefer me to send the patches with
> acks included or something like that.

Applied both. Thanks
