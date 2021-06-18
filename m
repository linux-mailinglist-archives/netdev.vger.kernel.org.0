Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8483AD246
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhFRSk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhFRSkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:40:25 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13DAC06175F
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:38:13 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id c17so3733160uao.1
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DB2KtV4huzDvhq/Zw0R+/LkrQSRw1LO05/D22qr6dbU=;
        b=tIIgm2cZNItj/jycwMzyYp3p96yXQ4kK1YCraXyqsKQp3CntGE7q58d7awGidqAldZ
         KTeDW7VMONgTvlomLboOwEJC+XNLpnBj83yWCpcZ3rwW7N/CpWGOrn56qf/N6ueEuKAv
         Rs+0Cttg0oqOzeN65pYDcFq+0dnIPaOpbx6vu+ZntyURMYHTkyv2T6mng7/Te7XmxcA1
         wd7+PIHBAbaHCGLqJ9bLZjTS4LdERnO4ChIcg/dSKQJwOYKNSJWv2SYWlRatAFIAt0oQ
         n63V02/IPwj2PjgsWvNIYUhMMj68GAEpH9aoAA6a8oNAV5TAcwrOrVO/GeP4MsWv31xg
         //Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DB2KtV4huzDvhq/Zw0R+/LkrQSRw1LO05/D22qr6dbU=;
        b=O+rMd9PIbwrZ+xXy4ESiaYTN06LNbk+6nK/q01LAX/9vWmmjgsG6d5xx3EQI4L2Z9j
         D2xjJ+qfCBvHcBDH0Jd76D8s1phSRNTdTyAmQld3jA6Su1h+5IuoTnPmZitjgTzLr1Wn
         lud8DM89IWET4SpySxnnmvGimAKS01t3EGOcuO1NGuR0ynTMZi4iIpKEqUgwyJSkqrev
         8Lj+BwBRqRWsPwbRlN3h7x4/zvMyJAtWN01Q7YCEx1166FqYGQvYooQ0fW2p/3SR5RQc
         3t9oMR7LIDYlWprJL+ADiqYDbSRAJrtwklnmyMD+hYiUyLzXMavmPa0PoW9wo1SLFLn/
         jcgw==
X-Gm-Message-State: AOAM53359BlgAafZQ9ACV6/33jLRamv4pXgpMq6PGG9hOfqUp0fWATau
        wyRoA38dHE8SU0l9e45IfXa5R7c4gxNO1m9mmiD4e9iL6eXfog==
X-Google-Smtp-Source: ABdhPJwz2ZJpfcsl04Unjheqw2xcmn3vHpAq9WrE/MNE1GmJYx0xXDii3HA6hXdDlYY9b3I3uvLTtIsMxZJggcn3Hlk=
X-Received: by 2002:ab0:30d4:: with SMTP id c20mr9018989uam.60.1624041492697;
 Fri, 18 Jun 2021 11:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com> <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
In-Reply-To: <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 18 Jun 2021 11:38:01 -0700
Message-ID: <CANP3RGcj_C-DorLcg58M2FYQMtz8wcX=qqVQmW6MH3uE-suh=w@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 4:55 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 18 Jun 2021 at 11:55, Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > This reverts commit d37300ed182131f1757895a62e556332857417e5.
> >
> > This breaks Android userspace which expects to be able to
> > fetch programs with just read permissions.
>
> Sorry about this! I'll defer to the maintainers what to do here.
> Reverting leaves us with a gaping hole for access control of pinned
> programs.


Not sure what hole you're referring to.  Could you provide more
details/explanation?

It seems perfectly reasonable to be able to get a program with just read pr=
ivs.
After all, you're not modifying it, just using it.

AFAIK there is no way to modify a program after it was loaded, has this cha=
nged?
if so, the checks should be on the modifications not the fd fetch.

I guess one could argue fetching with write only privs doesn't make sense?

Anyway... userspace is broken... so revert is the answer.

In Android the process loading/pinning bpf maps/programs is a different
process (the 'bpfloader') to the users (which are far less privileged)
