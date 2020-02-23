Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33F0169A55
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 22:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgBWVnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 16:43:37 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45356 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWVnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 16:43:37 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so3184364pls.12;
        Sun, 23 Feb 2020 13:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EYFt7TCGJFdSzBv48/uvMOjnjmgQwm23vB0vjtbvkQc=;
        b=gHkNxhjb22CGhIX8m5Y+yevQzK/nm2UrJrtUv8kzQ8orsoVNccXn3SurRR2Ww7xZ4d
         yxnUYDaHJHAbjcNkdxCXAh+7n2dBl2qZiESjK5tUz0vx2539wVlLvUcY4jQ8V4POgzVS
         wEI54DXBXEbslGxD1abTUqgJy7quDZqPVEYSHQ8Z6ozfs7HTELZdxOOBROo70UE1L82/
         Mh3DtxwQN9pYtBJDHcWDSwBXj+S3U+xgY5NtY0mN3jFqVcwmi+H/nKQc9hMBUPfvx3/K
         pRZdygpO7/yfW7W7/NzLWZ3yhlM+y6lnOd+V10ib3mq9LqUCttN6GSJW/XSoOMmb6B67
         8wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EYFt7TCGJFdSzBv48/uvMOjnjmgQwm23vB0vjtbvkQc=;
        b=APu6PYSUxxsICB92mF/3aVuB8yxHwL6hYl2tM2BvorRC+gfK5XXeGnbvVGcAJmw7dA
         CJMxriqMBddyKQei5S83412ZfEgxb11gnL6ECTCCqKG30dN8XCdTPhHA/po3m7/voFT2
         fqdjf0PfKyoOkjs1d4yPih9zZZ+RxtfIWHdKRu1/D3lhmw3aWvWmBMLDyG33XvtE9Q05
         Y5XW3+kIeNJhyKac/BEja/6iligWbZYilBNMIsmswLdxbUaeDnG/zZXY8nWo0/ukI/gl
         a2cSeMNtffR4JsJEm3W4sBVWLV3sqaWdFgGi9LGnPbDenW+hfEjd7WJ4j6xaEdD6R7uE
         PIOQ==
X-Gm-Message-State: APjAAAUc0DH8kFToEY8gNrkD52cJelAiCoz8Xi2OAfVaKta7ycS4mOm3
        31B0ixEbyEiyTIdghNbgOTI=
X-Google-Smtp-Source: APXvYqzco61O+NZf1hs63O+Y6TeuPW2YCJ2oKs0bMaWBDu1PS8SQvRB3ZqTNSH/mLAc2CjCz0mX8ig==
X-Received: by 2002:a17:902:8642:: with SMTP id y2mr46231747plt.306.1582494214609;
        Sun, 23 Feb 2020 13:43:34 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:7207])
        by smtp.gmail.com with ESMTPSA id o73sm9608971pje.7.2020.02.23.13.43.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Feb 2020 13:43:33 -0800 (PST)
Date:   Sun, 23 Feb 2020 13:43:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v7 00/11] Extend SOCKMAP/SOCKHASH to store
 listening sockets
Message-ID: <20200223214329.2djcyztfze3d34g5@ast-mbp>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <c86784f5-ef2c-cfd6-cb75-a67af7e11c3c@iogearbox.net>
 <CAADnVQJrsfpsT47SqyCTM6=MSkeMESZACZR12Kx+0kRGBnRbvg@mail.gmail.com>
 <87d0a668an.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0a668an.fsf@cloudflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 22, 2020 at 01:49:52PM +0000, Jakub Sitnicki wrote:
> Hi Alexei,
> 
> On Sat, Feb 22, 2020 at 12:47 AM GMT, Alexei Starovoitov wrote:
> > On Fri, Feb 21, 2020 at 1:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 2/18/20 6:10 PM, Jakub Sitnicki wrote:
> >> > This patch set turns SOCK{MAP,HASH} into generic collections for TCP
> >> > sockets, both listening and established. Adding support for listening
> >> > sockets enables us to use these BPF map types with reuseport BPF programs.
> >> >
> >> > Why? SOCKMAP and SOCKHASH, in comparison to REUSEPORT_SOCKARRAY, allow the
> >> > socket to be in more than one map at the same time.
> >> >
> >> > Having a BPF map type that can hold listening sockets, and gracefully
> >> > co-exist with reuseport BPF is important if, in the future, we want
> >> > BPF programs that run at socket lookup time [0]. Cover letter for v1 of
> >> > this series tells the full story of how we got here [1].
> >> >
> >> > Although SOCK{MAP,HASH} are not a drop-in replacement for SOCKARRAY just
> >> > yet, because UDP support is lacking, it's a step in this direction. We're
> >> > working with Lorenz on extending SOCK{MAP,HASH} to hold UDP sockets, and
> >> > expect to post RFC series for sockmap + UDP in the near future.
> >> >
> >> > I've dropped Acks from all patches that have been touched since v6.
> >> >
> >> > The audit for missing READ_ONCE annotations for access to sk_prot is
> >> > ongoing. Thus far I've found one location specific to TCP listening sockets
> >> > that needed annotating. This got fixed it in this iteration. I wonder if
> >> > sparse checker could be put to work to identify places where we have
> >> > sk_prot access while not holding sk_lock...
> >> >
> >> > The patch series depends on another one, posted earlier [2], that has been
> >> > split out of it.
> >> >
> >> > Thanks,
> >> > jkbs
> >> >
> >> > [0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> >> > [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
> >> > [2] https://lore.kernel.org/bpf/20200217121530.754315-1-jakub@cloudflare.com/
> >> >
> >> > v6 -> v7:
> >> >
> >> > - Extended the series to cover SOCKHASH. (patches 4-8, 10-11) (John)
> >> >
> >> > - Rebased onto recent bpf-next. Resolved conflicts in recent fixes to
> >> >    sk_state checks on sockmap/sockhash update path. (patch 4)
> >> >
> >> > - Added missing READ_ONCE annotation in sock_copy. (patch 1)
> >> >
> >> > - Split out patches that simplify sk_psock_restore_proto [2].
> >>
> >> Applied, thanks!
> >
> > Jakub,
> >
> > what is going on here?
> > # test_progs -n 40
> > #40 select_reuseport:OK
> > Summary: 1/126 PASSED, 30 SKIPPED, 0 FAILED
> >
> > Does it mean nothing was actually tested?
> > I really don't like to see 30 skipped tests.
> > Is it my environment?
> > If so please make them hard failures.
> > I will fix whatever I need to fix in my setup.
> 
> The UDP tests for sock{map,hash} are marked as skipped, because UDP
> support is not implemented yet. Sorry for the confusion.
> 
> Having read the recent thread about BPF selftests [0] I now realize that
> this is not the best idea. It sends the wrong signal to the developer.
> 
> I propose to exclude the UDP tests w/ sock{map,hash} by not registering
> them with test__start_subtest at all. Failing them would indicate a
> regression, which is not true. While skipping them points to a potential
> problem with the test environment, which isn't true, either.

So the tests are ready, but kernel support is missing?
Please don't run those tests then since they're guaranteed to fail atm.
