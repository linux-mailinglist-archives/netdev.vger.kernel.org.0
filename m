Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5181E6A2323
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjBXU0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjBXU0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:26:53 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656E96A7B4;
        Fri, 24 Feb 2023 12:26:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso7242131pjv.0;
        Fri, 24 Feb 2023 12:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyET30miqKBMK2UOCASwTsnu/y18tHN3UC9dREFyH5w=;
        b=Ifa0u0rakYJwnlC5lmpqynPe4gNlRiWcUaSZDbOFcrTzCO8y3MhuTAjgvD5ABy2qqy
         dzwr/wB1JwYqcFD6er7RCyEyJFghMm0UaZyB9GbVGofGpXIGP4URYGrSr4IF++2DmKVh
         0wlNkpCzFufOY01xnw1XwAb6cqDSe5tFSUea2rGvvOCPQqDOTIqgEXzlu122rv5JuzZh
         DWVC4D1W9jotZLF9cfCl5sHGyc4xj7PA1TiXX3+QumG9nFbnHCzpmwIu1sVYU6gE8iT/
         E52PJYvY8LUcQNmDLAXOjxO1TACA2p5tj3MErqQK3SDwW7Qpbgn5i8d0JJ9K3NKdS6qB
         JtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MyET30miqKBMK2UOCASwTsnu/y18tHN3UC9dREFyH5w=;
        b=D6F/UiGpGzINcMPRhIwaGZP2lJrsdCF+0KqfO4nfeN5K//IQmm6dwBdy4/cjh1lK/Z
         UW+LQhLSqOlMo79kkUKe/nYCAEeXkhCWI4haJaQZaTCywcoDy02LpzuzOqQOgcX3mvav
         mgZt7ZS0xx4eML3i75dN46VwA8FYMF0qyP34XYxir42pLdUBt9WPq3A2vQojkNpdEhvQ
         hrZUg2AjQBvBkxeaqbh6ti9LCKDq9OltwOHRLAf758LJi0H4bj7okbnVRCQJZhotgHYj
         y5Zk6ckehw1iMphMp1/F9EFQ4HQyU7g0MB0PsAa0t+C55HXvcJwOo9/+Ou/Z0VrqwiS7
         QUWQ==
X-Gm-Message-State: AO0yUKWZfPnlVvA4yN5WQNtuhVJgizJSBhamOGvFh8mnmeszlFjXSBbK
        8xC5SWLWoNQ+UxJbUU8MYy0=
X-Google-Smtp-Source: AK7set8/p/OQVCH25mI0PflEw1Tf+8TCf2nCs6ylrUOtuCNCQls//FApbldUvZBbsRKbS8wn8JTaiw==
X-Received: by 2002:a17:902:d482:b0:19c:356f:e98f with SMTP id c2-20020a170902d48200b0019c356fe98fmr19904242plg.60.1677270411748;
        Fri, 24 Feb 2023 12:26:51 -0800 (PST)
Received: from localhost ([98.97.39.75])
        by smtp.gmail.com with ESMTPSA id e14-20020a170902ed8e00b0019aa8149cb9sm719953plj.79.2023.02.24.12.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 12:26:51 -0800 (PST)
Date:   Fri, 24 Feb 2023 12:26:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hsin-Wei Hung <hsinweih@uci.edu>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <63f91d89e85f5_30c8320858@john.notmuch>
In-Reply-To: <CABcoxUY=k8_aM0YE3_e_FaMTLiBmo-Yc4UMyBVuRNggj4ivA-Q@mail.gmail.com>
References: <CABcoxUayum5oOqFMMqAeWuS8+EzojquSOSyDA3J_2omY=2EeAg@mail.gmail.com>
 <87a614h62a.fsf@cloudflare.com>
 <CABcoxUYiRUBkhzsbvsux8=zjgs7KKWYUobjoKrM+JYpeyfNw8g@mail.gmail.com>
 <CABcoxUY=k8_aM0YE3_e_FaMTLiBmo-Yc4UMyBVuRNggj4ivA-Q@mail.gmail.com>
Subject: Re: A potential deadlock in sockhash map
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hsin-Wei Hung wrote:
> Hi,
> 
> Just a quick update. I can still trigger the lockdep warning on bpf
> tree (5b7c4cabbb65).
> 
> Thanks,
> Hsin-Wei

Thanks, I'll take a look.

> 
> On Fri, Feb 24, 2023 at 9:58 AM Hsin-Wei Hung <hsinweih@uci.edu> wrote:
> >
> > Hi Jakub,
> >
> > Thanks for following up. Sorry that I did not receive the previous reply.
> >
> > The latest version I tested is 5.19 (3d7cb6b04c3f) and we can reproduce the
> > issue with the BPF PoC included. Since we modified Syzkaller, we do not
> > have a Syzkaller reproducer.
> >
> > I will follow John's suggestion to test the latest kernel and bpf
> > tree. I will follow
> > up if the issue still reproduces.
> >
> > Thanks,
> > Hsin-Wei
> >
> >
> >
> >
> > On Fri, Feb 24, 2023 at 8:51 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, Feb 20, 2023 at 07:39 AM -06, Hsin-Wei Hung wrote:
> > > > I think my previous report got blocked since it contained HTML
> > > > subparts so I am sending it again. Our bpf runtime fuzzer (a
> > > > customized syzkaller) triggered a lockdep warning in the bpf subsystem
> > > > indicating a potential deadlock. We are able to trigger this bug on
> > > > v5.15.25 and v5.19. The following code is a BPF PoC, and the lockdep
> > > > warning is attached at the end.
> > >
> > > Not sure if you've seen John's reply to the previous report:
> > >
> > > https://urldefense.com/v3/__https://lore.kernel.org/all/63dddcc92fc31_6bb15208e9@john.notmuch/__;!!CzAuKJ42GuquVTTmVmPViYEvSg!PU-LFxMnx4b-GmTXGI0hYjBiq8vkwrFrlf_b0N5uzy8do5kPFiNcuZJbby-19TtOH2rJoY9UwOvzFArd$
> > >
> > > Are you also fuzzing any newer kernel versions? Or was v5.19 the latest?
> > >
> > > Did syzkaller find a reproducer?
> > >
> > > Thanks,
> > > Jakub


