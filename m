Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB71BCB6E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgD1S5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728923AbgD1S5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:57:04 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17890C03C1AB;
        Tue, 28 Apr 2020 11:57:04 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s30so18244678qth.2;
        Tue, 28 Apr 2020 11:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2YfXGfuMuPy1ibXhyUOnPWtx+Rahyq0MEbZeaSjtBw=;
        b=k+Q+h8E4is2EZmHTf2X18V8HtnsuICXDJPSBnu0kofa+nB/O7cHfaeF8niq1ISfIi4
         0kk+FhyAPQAaqkpBj73hImkdZ+ONbBvj2DuWs5ngSOMRLQMV8NHiJW2oDhfC1+BHGous
         wvHs/KUH/BLweUOFYWB+fKt1iixrb9/vOmgwb0PG+oFXSXOxYIw2AkydaN5uXWp2CGfs
         NUYiTuzEbgG7fW1B+YAWqA0Q2GgiW7zOZmX56T2ppIcVaNjHGhAS8Uq73yp94MFv5TOM
         0CL9edQH37ToBAhMnj0A2X3UgWVDntvAHN7gDpdBduDcHgx1cqqQaYY7qYSqAmd0LK6X
         dAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2YfXGfuMuPy1ibXhyUOnPWtx+Rahyq0MEbZeaSjtBw=;
        b=Fvkl+XK0JPP7hnu3ZZX9Z+7XrwWA4U1TYiNIM/uLay0BCasZXY02hcR5uE0vhYl8Fm
         OMvO9jNHWB8YyGN/lMMsZP/ESfAyNWeejojvl3Fey+hg4JLKzY5gdhbYWMqpe+KfIrq+
         w8x0yfFqpOt5UjwjreloGvGFIUM51mU2prSdz/8Ug0DrPzDJb8oMRLb0jfcBX7uVRFSP
         tajnyw6u+rm98f46kvGfBQ2QVLhACbVCkYICU9/Uo/JFS+fiOL68RXFGC1FtTeOcSBe4
         R2un3hEISo/+KFDCvKJDvyNGPZV39JkTvPk02ifxSVvlZMWghLqrUjRdN0CHiFBXklCj
         X2bg==
X-Gm-Message-State: AGi0PuZQs5GzblEvc5S1fWo2G9OwbXBKPiTbyQA9ySmtU0a8nBxrIv53
        7lS+0l5vQ2QkXvG6oa1ECF0jUmYu6zel0URrOe8=
X-Google-Smtp-Source: APiQypJsk760Rzj8HzyCDJmenDxLtJpA7ptsF1BRkNA0whFcUGSaoWVa67+6lCuRGg2P0OunmWyyQcpxCN8vA+5kDDk=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr29476886qtk.171.1588100223255;
 Tue, 28 Apr 2020 11:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200428054944.4015462-1-andriin@fb.com> <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 11:56:52 -0700
Message-ID: <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:31 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> > +int bpf_link_settle(struct bpf_link_primer *primer)
> > +{
> > +     /* make bpf_link fetchable by ID */
> > +     WRITE_ONCE(primer->link->id, primer->id);
>
> what does WRITE_ONCE serve here?

To prevent compiler reordering this write with fd_install. So that by
the time FD is exposed to user-space, link has properly set ID.

> bpf_link_settle can only be called at the end of attach.
> If attach is slow than parallel get_fd_by_id can get an new FD
> instance for link with zero id.
> In such case deref of link->id will race with above assignment?

Yes, it does race, but it can either see zero and assume bpf_link is
not ready (which is fine to do) or will see correct link ID and will
proceed to create new FD for it. By the time we do context switch back
to user-space and return link FD, ID will definitely be visible due to
context switch and associated memory barriers. If anyone is guessing
FD and trying to create FD_BY_ID before LINK_CREATE syscall returns --
then returning failure due to link ID not yet set is totally fine,
IMO.

> But I don't see READ_ONCE in patch 3.
> It's under link_idr_lock there.

It doesn't need READ_ONCE because it does read under spinlock, so
compiler can't re-order it with code outside of spinlock.

> How about grabbing link_idr_lock here as well ?
> otherwise it's still racy since WRITE_ONCE is not paired.

As indicated above, seems unnecessary? But I also don't object
strongly, I don't expect this lock for links to be a major bottleneck
or anything like that.

>
> The mix of spin_lock_irqsave(&link_idr_lock)
> and spin_lock_bh(&link_idr_lock) looks weird.
> We do the same for map_idr because maps have complicated freeing logic,
> but prog_idr is consistent.
> If you see the need for irqsave variant then please use it in all cases.

No, my bad, I don't see any need to intermix them. I'll stick to
spin_lock_bh, thanks for catching!
