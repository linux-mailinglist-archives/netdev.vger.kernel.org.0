Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709A82161D9
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgGFXIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgGFXIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:08:35 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A2EC061755;
        Mon,  6 Jul 2020 16:08:35 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t7so18024015qvl.8;
        Mon, 06 Jul 2020 16:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJTy/ZKtNePxlxQ8E0U9JYdohrE319mlkThftrxObes=;
        b=q9+PVyYDq6U6uC92ALdEIzz1xoekYs9cduBoKTcI54BaxGYmniaxUv1XKEF5PAgX4n
         t4YctUEdR4OrnWGYblUIHjqoLjgGU2VY0fjGE6RhaJmXKAaeHmzyEFdQLjCXJ5RltETW
         aiMY4oxyW2wFJ13JVfT6chR4q0kCbBAeJI4wA9sKgsuSsMnBcbBo5dVZxRVxyywJuhhO
         ahe2NrUJkJ0EqgLrgGLACkeZFuFMPEbKACsMz3hvV4xXVQf+hdQIxlOksTObKpMZ4xmv
         gcF3lCr5iHmFGkSoumXZpBTO4t+erTSTvy8uh0F4zAKIZttCFvoWpb00Ec36NEklHsbr
         mtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJTy/ZKtNePxlxQ8E0U9JYdohrE319mlkThftrxObes=;
        b=inyJ+rufnI7fOHRRYshfut4GQdkQDUpFWCVkE7FN1DouwoZW6JFIlSkj789T7H8DKf
         WN1gXD8KWYqYn191wWJZ7HeSNd83prGxVQjJ/UKDKAKU3lUh+iXJ8Lj+1uf5T0oSbSuU
         R2j/Azz84RNldmxcVn6fbGmOg5DkSF59VKyaDnE8S28RMSDXB4Uqs5t/QHfGDeLkN1b8
         fck3oma4Dh2p5P+/1kqD3GbGRdx3UhFo+kRk2MNqak6oulHptVd39FLyZfz1Juvler9U
         hmguGsUO1Uwzv8BL+r/k9YOQdpe728HSsIJjD4oViRthq81Lez7281wc3qih8RXpee8B
         2m2Q==
X-Gm-Message-State: AOAM530gzEIJQPLWJ8KpJnWdhAUjGEx4i+nq3KiBfT+01xB24iGf2RRw
        dr0/BW5VsXb/6d4Gzy+z3SSdGWC+FRqDORIcm2Y=
X-Google-Smtp-Source: ABdhPJzrMC0wl1xdaoXdQlmUCSGK+wh0NXovh8B4e8cFUYYRkHaixDwdHNXkmegcZmsp2AeIDy/gEOc1owBTPDOZA1Y=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr48127540qvf.247.1594076914393;
 Mon, 06 Jul 2020 16:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com> <20200702200329.83224-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20200702200329.83224-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:08:23 -0700
Message-ID: <CAEf4BzbemM5WpA-eiHkiHCU6+VcoQNEKr1rNnXHhGwYjPmny4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Factor out bpf_link_get_by_id() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Refactor the code a bit to extract bpf_link_get_by_id() helper.
> It's similar to existing bpf_prog_by_id().
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf.h  |  1 +
>  kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
>  2 files changed, 29 insertions(+), 18 deletions(-)
>

[...]
