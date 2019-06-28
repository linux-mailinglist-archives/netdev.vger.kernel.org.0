Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C45A546
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF1Tkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:40:39 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37865 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1Tki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:40:38 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so14948241iok.4;
        Fri, 28 Jun 2019 12:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Xs/Tl01EvfGNMeD+GoVP3auQNKbKsJ/nltUIgeSt/t4=;
        b=SIADeo8MsKFWe/5OSaQPCUXtS16pYY5akp3FE1yu4DT38aWoiCpW/Ieq5OHFR7Jjim
         MpuOfwnAoxqfZalqEn6rJWZU98c7UvXxgz3XJdwZN5ewMaxzqUCgyNBiGBCm8O1EAK6K
         R1BC9WQPYAcbBYY2GksqdEgYzmz6a4/l8KL0Zy71pxvIh40vDJ1V09R0bkKm0OtoazE+
         9A7D6W4XjE/82Yeecq7Ob6yBCslOf/JOfxGpzKufUJFRpmGlg0HVMeNZCCHTRfy5fIBQ
         oVE8zKeroR0q0wOi3fKELDgFWXzl6Di32XALfMopmdrCL9aQYRn226UMYb3Zep6Yo0Jy
         xtGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Xs/Tl01EvfGNMeD+GoVP3auQNKbKsJ/nltUIgeSt/t4=;
        b=spNXvMiFjy0vRujlNW7s0iMwT7M1JzT3dPPBinIMToJ8ija3E0YO3/8FbIE8cyGK5U
         SXdZsqiBHkZVmLJhewmwPevUflhBpVO5gNaelE1yxmJ2QUrmH3QTyRNQEJceRadfqPf5
         8Z/9tftyxnaxdarA1wY5FoVIgLZvLGn2GqXam17Dm7Z3ydU9PbME0fBxz5nF6VMK/OAt
         M9a2jB3geOfsne8Pub/tug72Gev5tuzLTBz5lWyhGXJr4hjInYsundDH8I5w7+DIjzNr
         YmTRBEN9jgw3HiVREXwYic0kjxO1F8yyvbl1g1sOtTEgL2JTaanzpqbgk5xz7r0a7uJA
         FimA==
X-Gm-Message-State: APjAAAXAgxtt15N+9pgh+M2zFJev9Ky1souCsgc5qqtUoi219Dud8oD7
        aLjPzaiZ600Nr7n6GjO46fA=
X-Google-Smtp-Source: APXvYqxwuUMjyznfV0WmZYRz+5pn4U5KCjFMiESgiHotkJ1qhodTAFp6C7Nds/EJgE5bXdIGgr5lpA==
X-Received: by 2002:a6b:5a17:: with SMTP id o23mr12749951iob.41.1561750838156;
        Fri, 28 Jun 2019 12:40:38 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i3sm2807496ion.9.2019.06.28.12.40.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 12:40:37 -0700 (PDT)
Date:   Fri, 28 Jun 2019 12:40:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.io, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
In-Reply-To: <20190628113100.597bfbe6@cakuba.netronome.com>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
 <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
 <20190627164402.31cbd466@cakuba.netronome.com>
 <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
 <20190628113100.597bfbe6@cakuba.netronome.com>
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 07:12:07 -0700, John Fastabend wrote:
> > Yeah seems possible although never seen in my testing. So I'll
> > move the test_bit() inside the lock and do a ctx check to ensure
> > still have the reference.
> > 
> >   CPU 0 (free)           CPU 1 (wq)
> > 
> >   lock(sk)
> >                          lock(sk)
> >   set_bit()
> >   cancel_work()
> >   release
> >                          ctx = tls_get_ctx(sk)
> >                          unlikely(!ctx) <- we may have free'd 
> >                          test_bit()
> >                          ...
> >                          release()
> > 
> > or
> > 
> >   CPU 0 (free)           CPU 1 (wq)
> > 
> >                          lock(sk)
> >   lock(sk)
> >                          ctx = tls_get_ctx(sk)
> >                          unlikely(!ctx)
> >                          test_bit()
> >                          ...
> >                          release()
> >   set_bit()
> >   cancel_work()
> >   release
> 
> Hmm... perhaps it's cleanest to stop the work from scheduling before we
> proceed?
> 
> close():
> 	while (!test_and_set(SHED))
> 		flush();
> 
> 	lock(sk);
> 	...
> 
> We just need to move init work, no?

The lock() is already held when entering unhash() side so need to
handle this case as well,

CPU 0 (free)          CPU 1 (wq)

lock(sk)              ctx = tls_get_ctx(sk) <- need to be check null ptr
sk_prot->unhash()
  set_bit()
  cancel_work()
  ...
  kfree(ctx)
unlock(sk)

but using cancel and doing an unlikely(!ctx) check should be
sufficient to handle wq. What I'm not sure how to solve now is
in patch 2 of this series unhash is still calling strp_done
with the sock lock. Maybe we need to do a deferred release
like sockmap side?

Trying to drop the lock and then grabbing it again doesn't
seem right to me seems based on comment in tcp_abort we
could potentially "race with userspace socket closes such
as tcp_close". iirc I think one of the tls splats from syzbot
looked something like this may have happened.

For now I'm considering adding a strp_cancel() op. Seeing
we are closing() the socket and tearkng down we can probably
be OK with throwing out strp results.

> 
> FWIW I never tested his async crypto stuff, I wonder if there is a way
> to convince normal CPU crypto to pretend to be async?
