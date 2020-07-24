Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF07C22CE82
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXTNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGXTNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 15:13:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CFEC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:13:08 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id x9so11057320ljc.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeBXoqXvoZOUWYA0uSHWWga3AkdX5vyutNg8ZrXSAQY=;
        b=dKBBgCOwDmZGz2DegDgyCK4t2bkYC9ZFFM6hnk9e5qhbOhxr4hKvbWkU48ymwuj4ZH
         ftlMkPiMoQkEbvGhzmUxLTo5iAJrlhlqc6vnaUQ+fzIrXyUnd1rsFgbPKKPCDVYc753K
         uRVGaK9Wu2p793cZ+ZU2BpN0K0JEJiVkWw/Am4WEDBBMeHiWR2+CIu317J66h0Frrt1O
         1Gs5+utSxh3lUr4qiHCgS0LzjwZ3EOfWye6U78TujNWXBPDomC6oCPowQQJ/qcpTXWGr
         W5dduQ6eZkQVBHzFWuwCrMY+HYJA4bGGQUEfK0JWpgQ5mwDQWk5kgGsTKGuleeKf0zGJ
         ByuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeBXoqXvoZOUWYA0uSHWWga3AkdX5vyutNg8ZrXSAQY=;
        b=eo//YWlF8eQnk0o8QgiXdOsWcdavzNku8Mx0QT6M8ctz+YM7yl0cnyu1SOL8XKf1SJ
         OI/DCXB08d2bkbkAJhZezT/DGBB0N+DW2GAOO6JX5bQZFZ3D+RQjDuxCGkMdDtW9WpJC
         WEw1Mejjvsr/fBZk6uGaziF1vne6u33bOUCzu1XxjobghEZxUDlOnYXE6O7YfdlTh69P
         iIYnAANeTvMqVgxX4Vd1dS2TW96wgwHTWZcWPhB9rbcoVDzfothHe7W+GcKk9U3YRw6H
         TNKiQ/MkqYHnXkaB5A35e+UvrSOk86Ufr+2Se+Fnwsf4csBpiDRpwoEEBH1axFuip6WD
         k4pw==
X-Gm-Message-State: AOAM530SxYjJnDCZss5pkibMNNGzpttEJtNjT7ezkZj65bAZLvY9GVML
        K7GmeFBfibuVYMAZdovfxGfFAnmSUEwcggRDqK8=
X-Google-Smtp-Source: ABdhPJzeME8Til+yUpnnJ7Sw0VQtu4Sa6tcUr1HC5aIxfRHmBKG3ivXQVsGiGcIh0O3oMmlPDCGdNWLcDPJtmsMI/5g=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr4677409ljh.290.1595617986369;
 Fri, 24 Jul 2020 12:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200723.151051.16194602184853977.davem@davemloft.net>
 <20200724061304.14997-1-kuniyu@amazon.co.jp> <CA+FuTSeyyxxt9AmKo8A3FNtnOxfcdVB-8hOzpitVD=auMMHFDQ@mail.gmail.com>
In-Reply-To: <CA+FuTSeyyxxt9AmKo8A3FNtnOxfcdVB-8hOzpitVD=auMMHFDQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Jul 2020 12:12:55 -0700
Message-ID: <CAADnVQKbW+TpMN5Pzu9LoSJyUeBcmUsVSX5UecGc+qpEkZPk8A@mail.gmail.com>
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 6:38 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Jul 24, 2020 at 2:13 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   David Miller <davem@davemloft.net>
> > Date:   Thu, 23 Jul 2020 15:10:51 -0700 (PDT)
> > > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > Date: Thu, 23 Jul 2020 01:52:27 +0900
> > >
> > > > This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
> > > > makes it easier to resolve a merge conflict with bpf-next reported in
> > > > the link below.
> > > >
> > > > Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
> > > > Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > >
> > > This doesn't apply to net-next.
> >
> > Yes. I think this kind of patch should be submitted to net-next, but this
> > is for the net tree. Please let me add more description.
> >
> > Currently, the net and net-next trees conflict in udp[46]_lib_lookup2()
> > between
> >
> >    efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> >
> > and
> >
> >    7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
> >    2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
> > .
> >
> > The conflict is reported in the link[0] and Jakub suggested how to resolve
> > it[1]. To ease the merge conflict, Jakub and I have to send follow up patches to
> > the bpf-next and net trees.
> >
> > Now, his patchset (7629c73a1466 and 2a08748cd384) to bpf-next is merged
> > into net-next, and his follow up patch is applied in bpf-next[2].
> >
> > I fixed a bug in efc6b6f6c311, but it introduced an unnecessary variable
> > and made the conflict worse. So I sent this follow up patch to net tree.
> >
> > However, I do not know the best way to resolve the conflict, so any comments
> > are welcome.
>
> Perhaps simpler is to apply this change to bpf-next:

I'm fine whichever way.
Could you please submit an official patch?
