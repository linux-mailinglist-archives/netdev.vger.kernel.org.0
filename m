Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0846F38E280
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 10:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEXIq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 04:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhEXIqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 04:46:54 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBACC06138B
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 01:45:26 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e11so32491036ljn.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 01:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7Eot4reizRuUqmf0K/rkTFVGo7P8pVMLjLh6jyCFRA=;
        b=jInJomWEJ28bqvyt64gfUqIqCzsBLfPEp0SuWcOA9hPgIacmJdJNeky6DMbwP8Wz+q
         HDm6wLRis4iIKKkKF3NbsWrHYo2VBydUGn7Y2LAWpNbaA+Gc/NvqbfGoYIGcNOfV/cHA
         M11srfGLNcSGaAlz//XUQdiuQPC77HjtAAUlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7Eot4reizRuUqmf0K/rkTFVGo7P8pVMLjLh6jyCFRA=;
        b=n2njF4sWC+rEuJ0WFhmHuRDD6YW35l/Q7qSh0xoN0ZD7vyZKURA2KOOdGR6v9yaVyH
         zrlji7NJy7bO32NJotGUgJTt8e5Np0YB6girnWVO3AQrRW2YfT3fgiEQC5RVJ+tXEdtE
         m6SOG+4q3VGP42mih9VBce4JUGZ1zponrh2v5iY7Cmb4KL6+tno7WPUJwLPWU8Ct6KIK
         6+yNn+kzOo1/OiePSajvYvnmba2fyFXmDepXX6ZfUXLckt9hvxGakB4U+ztIDGjJSuaA
         jRnNDYkbxzvgaRAfNmLeUN00qcUGlEGxBh7nllXKTf14BpTxI7e2CVnf2bahA/iP8IVT
         hbkg==
X-Gm-Message-State: AOAM531VEZvuQSS/u6j1h6H9x+660bzEZYTAjqPhR/kPcnzw57r1/KXP
        O0ouzj9OoWtflAZCXKLHOUCWjnNptbdQP9ZaFHeUBQ==
X-Google-Smtp-Source: ABdhPJwA1x8pZHLOORWFrbzbiN4gz/ORPklgCSKn6iOCER1OtA5BndR6oypOHyH9f+eeYntk7OSUjehV0lu0suev7dE=
X-Received: by 2002:a05:651c:38d:: with SMTP id e13mr16419494ljp.226.1621845924323;
 Mon, 24 May 2021 01:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com> <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
In-Reply-To: <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 24 May 2021 09:45:13 +0100
Message-ID: <CACAyw9-aCgu5aApK4QKEJ-rdRTAEda5f8jdJDvmbnNod-RxP-Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 May 2021 at 17:01, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Hi, Alexei
> >
> > Why do you intentionally keep people in the original discussion
> > out of your CC? Remember you are the one who objected the
> > idea by questioning its usefulness no matter how I hard I tried
> > to explain? I am glad you changed your mind, but it does not
> > mean you should forget to credit other people.
>
> I didn't change my mind and I still object to your stated
> _reasons_ for timers.

For others reading along, here is the original thread
https://lore.kernel.org/bpf/CAM_iQpXJ4MWUhk-j+mC4ScsX12afcuUHT-64CpVj97QdQaNZZg@mail.gmail.com/

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
