Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58D91D9DCC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgESRWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgESRWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:22:05 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E4C08C5C0;
        Tue, 19 May 2020 10:22:05 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id i89so203503uad.5;
        Tue, 19 May 2020 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R37GX8lcfHvrhVqcl+Q4iNaBYXnBxyCSRN5ixg5QveI=;
        b=MQLQi/vs5EIJuOIYYEgBjyY2ogMmqVHcUvY/iQc9n8ebdzBHDGZT1q2sByAaIEVFOP
         z9NAIRf3c5BblcP6pgONx6UQDeZPlQIslBs42spIU5pspQ5hZNTOJaQrw/zyXRKGFk7g
         tVYwSqCfgIv88Fdk2pgdTIG6+Ss3Lik4SLtnyEJ6fNMV/GCn1wwl9/zzWvQ7ihqIWfsO
         tJuB6oqoRNipFj5h7jXI/uOJEBft+2TGXSnz4lZiMTrG85nzAMaVeOh2cKr3yRUiUhtH
         QAztJ2BfdhnbGTGZ/i/k448GJBWeG7SG5kDwRH54fWbMTLLOzsOkA2y29dXmHIko9w0O
         OE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R37GX8lcfHvrhVqcl+Q4iNaBYXnBxyCSRN5ixg5QveI=;
        b=Md7eU/1gDHvWWcmUEuYiKuwB1ZK2mVlfVk2V8QJgNmbiPiECKux3yBZQNzEzU6kx4v
         PW0i94C/OGIz/BKimFWJwBMfLmy+ihcwxJxi9itOOKKwyrxiGOEIiHtGOR+pWyFwPdjd
         XkhqOGirXHl15sMWcPLS6p6UhDeB1/DidtGOC3bG0WnnaO4oqWq6pLtP6OhvcKAi6gb8
         lkhlJNK5gaFzyukrLdx1Y2mQPqBY/BC6ILoIv202hZqbItI1vVZeERz2ep+GeAtANyCY
         IuOW+1bjJi80HYkEopopQRskMR/F7NxtJ8zZTpuOAPSFW265IYZ22oEV/nDz7phiFI6o
         nYRg==
X-Gm-Message-State: AOAM5307ZQNoZULGUvqr48yTmumPmRaGu3+4u7CaWroi3gvFxD/3Ly+U
        d4nlEOWNInxGobntW6hXlqnM+MpcdlFnrIejWnI=
X-Google-Smtp-Source: ABdhPJw+v0Oiz1+AW3tGSdhibKk15suMY2wZnLoiTtvEQ26Sa0zcYpVOfhvxg2aok455yRTiNwA1kyX0yn1oggB1MmU=
X-Received: by 2002:ab0:5fd3:: with SMTP id g19mr405396uaj.28.1589908924917;
 Tue, 19 May 2020 10:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com> <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Tue, 19 May 2020 13:21:56 -0400
Message-ID: <CAOrEds=Mo4YHm1CPrgVmPhsJagUAQ0PzyDPk9Cq3URq-7vfCWA@mail.gmail.com>
Subject: Re: [PATCH net] net/tls(TLS_SW): Fix integrity issue with
 non-blocking sw KTLS request
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        Pooja Trivedi <pooja.trivedi@stackpath.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 6:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 17 May 2020 16:26:36 +0000 Pooja Trivedi wrote:
> > In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
> > encrypted record) gets treated as error, subtracts the offset, and
> > returns to application. Because of this, application sends data from
> > subtracted offset, which leads to data integrity issue. Since record is
> > already encrypted, ktls module marks it as partially sent and pushes the
> > packet to tcp layer in the following iterations (either from bottom half
> > or when pushing next chunk). So returning success in case of EAGAIN
> > will fix the issue.
> >
> > Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
> > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> > Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> > Reviewed-by: Josh Tway <josh.tway@stackpath.com>
>
> This looks reasonable, I think. Next time user space calls if no new
> buffer space was made available it will get a -EAGAIN, right?
>

Yes, this fix should only affect encrypted record. Plain text calls from
user space should be unaffected.

>
> Two questions - is there any particular application or use case that
> runs into this?
>

We are running into this case when we hit our kTLS-enabled homegrown
webserver with a 'pipeline' test tool, also homegrown. The issue basically
happens whenever the send buffer on the server gets full and TCP layer
returns EAGAIN when attempting to TX the encrypted record. In fact, we
are also able to reproduce the issue by using a simple wget with a large
file, if/when sndbuf fills up.

> Seems a bit surprising to see a patch from Vadim and
> you guys come at the same time.
>

Not familiar with Vadim or her/his patch. Could you please point me to it?

>
> Could you also add test for this bug?
> In tools/testing/selftests/net/tls.c
>

Sure, yes. Let me look into this.
