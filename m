Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0545F0DF
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354156AbhKZPor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhKZPmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:42:46 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F24C06137F
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:33:13 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id b12so19472005wrh.4
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9jDX5nG7ioGkbdiDYXS1fdgmBHoztHHt2b89vYy/Vw=;
        b=ZbubdHtw41Z6BhnHw6viECjH25yQ6uFEioLV7N3v+PfU0wR+sd7DnFtXBim60fcCFj
         Xej4kHEpADBvS17z9kz3O3OUcOlAQJzwQNGAXVrY0P95IbBT6S6n1RN+hDg6pxtlSDA6
         /ub5iQ7tkxqW99uKl4uB9HD0DW0N4HUE4sEJnllGqSNyicYYFt/RO0gDPsB6Fgitc5RD
         cpv93E3hNleJvnQ5yWq+lI9FE+nAWbcp+dorLNIyKeXf0OW5pJsuuN/V9TQC7xKdH5+e
         2w2KSDC2G7uCMMv02NEbgzC1fOflrjvE0NPUqx981u/hZ0RQ/qXDzGXLDvzZQHkV40/V
         XFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9jDX5nG7ioGkbdiDYXS1fdgmBHoztHHt2b89vYy/Vw=;
        b=XKJZ8Kj482hj1Szc0iyfXe7ipewFQiJMxVuOl36LwveRbSjmL175CpFGV6WmvgVtza
         l33JrsLAbM17lB4obuTAlALUVpJ5bNEFsdc+U/LfldE/+jGBvuPgGtTbQpR/IcytusDG
         u55Re4AY5IkoR/+Fhy+SyxDsIQfN/3laAuvURl40E17ufD+1ZvVARfLxaZTqQcHpkyeO
         3O5qWeaKGy4tIbtI5N+3XqZ8hfPiNJdInP8+G6wPF4ejZ+qagqVt8JIB9K7j6jPWKdYc
         r7hpWQrZbGU5QtXtXvJkDK1PZwsMwz+TI2OPXpoQsWGZxaxMR6n2+0hHDxLjYtg1Gp3I
         6A7g==
X-Gm-Message-State: AOAM531MlZGJyfuWpgnhS6oAFZS9Eg12MprJdSxf+93JExQsw5WlJW/a
        OIMxMycB0OwyR/AQaGmb99uNpas5XAkI+YRBexOu0URuC3CzJw==
X-Google-Smtp-Source: ABdhPJwp0+mxQomX1+v9/EVhEaJcAOTuLcmc8bUKWQEvv70RR2b809mQsF51zlXt565YNU6Foz/N/WtLmknMqbckXCQ=
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr15289188wrp.226.1637940791470;
 Fri, 26 Nov 2021 07:33:11 -0800 (PST)
MIME-Version: 1.0
References: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
 <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com>
 <169f6a93856664dd4001840081c82f792ae1dc99.camel@redhat.com> <CANn89iJ=BRJheZjb_hMoLbEca1h3p79iKkpgPbF7DTpGcx=46g@mail.gmail.com>
In-Reply-To: <CANn89iJ=BRJheZjb_hMoLbEca1h3p79iKkpgPbF7DTpGcx=46g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Nov 2021 07:32:59 -0800
Message-ID: <CANn89iJx9b=Z=40TGhNtc7fRQSd=9MeG1x1PnJv2S5PYdYUoyw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix page frag corruption on page fault
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 7:27 AM Eric Dumazet <edumazet@google.com> wrote:

> We need to find one flag that can ask  gfpflags_normal_context() to
> return false for this case.
>
> Or if too difficult, stop only using sk->sk_allocation to decide
> between the per-thread frag, or the per socket one.
>
> I presume there are few active CIFS sockets on a host. They should use
> a per socket sk_frag.
>

A pure networking change could be to use a new MSG_  flag to force sendmsg()
to use the sk->sk_frag, but that would add yet another test in TCP fast path.

About gfpflags_normal_context being used by dlm : we can simply add our own
helper with a new name describing that we want:

Both being in process context, and not from page fault handler .
