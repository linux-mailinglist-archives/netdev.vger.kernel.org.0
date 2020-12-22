Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6CE2E105A
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgLVWiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgLVWiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:38:03 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15211C06179C
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:37:23 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ce23so20287982ejb.8
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AQL4sip/nTjmrcmBEXcaSkXgV4jMeTMlJatdBHYqCk=;
        b=HDTNX5JOpnOFc6LCMQgZ0Ly8K5P9mU4Bqv4i4/ZgBjMkgbPqasXWE2WUPSrIkM+gBR
         Z2R/lQQ6wFLXKJPyAZ0Ty9POGC5RdSwop9S/Z0IUyCO46ZVpofpWfNnp8D7c7DIeBfct
         SPwslCXtn7gz8F2X7SZAiVhoiyQaTe9vi+oQyH1TM4+uegF/L+W8c+YMqmLN6LhBmiSP
         dsRcPS/D59luHj+n7V47t/JYxhzkH0nr2yUMAMau9Jom7D4u6kjrN4jwVjVF2coEsdeT
         IPa4QGXwvj+SC7TJKhtHDUrEp6AAQzrEuBaY0Pn3S1MmM99H7uDSH+MFVOVxDXvFihV0
         jUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AQL4sip/nTjmrcmBEXcaSkXgV4jMeTMlJatdBHYqCk=;
        b=cczlk1OPxsfISaefpKzNT5v0P7DsCehTOefzZO/hNHxrU1JuzyAk61jv1Qnq0N1eJL
         voh9YTb+6QSWbt9dWz7MZHMw6m5kXSrlCuY3rePfw3aXma6Y48pvj92X44hrpsJ7WZjF
         ZgS8r12Yw7tAdu9pUeF5usWenA4C4ngy1mwdoicJpgKFHw3Gvko7EjAe7GCvRbkIeQMQ
         +aLPK35E3tMljU7Vr+A3dJH34HFWuvyhNlty2GM5DrD8SboHnihV0b8eW9VXyk9d84Ss
         JnAnGxyfo2yKs7Wfpmv6/Ig5KN3nmYAp2RegBYcMYXu1HQwk3jva0Q6NaUgdE/L9l16U
         x1jg==
X-Gm-Message-State: AOAM5322owQNhwDqLEDKezx74JpJqzbkU5SLH1x7UjuJMpJaN8LTi8VK
        n2h/4v8d9um4WUq7hg13P455EK4/qk97fXdgp2A=
X-Google-Smtp-Source: ABdhPJz2vU0bPOLKVV7a8jRdbbWDIA8XEXvqWU0v3y6YsJfXTpzWzjD+2WWgQtBb9v2idmtaxOaTjZDnPrCREgwDnJI=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr8598930ejj.464.1608676641886;
 Tue, 22 Dec 2020 14:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-6-jonathan.lemon@gmail.com> <CAF=yD-L0uqGHp3u0Oi_eJYZAJ2r8EeaWihiKbK3RVwSTLK87Dg@mail.gmail.com>
 <20201222171940.ijpuhkuxhvk33czg@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201222171940.ijpuhkuxhvk33czg@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 17:36:44 -0500
Message-ID: <CAF=yD-JghpPB4X6X2P4MkZro0gZYTQkCdjSg4tyxzcpcsqvZhg@mail.gmail.com>
Subject: Re: [PATCH 05/12 v2 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:19 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 09:42:40AM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > Replace sock_zerocopy_put with the generic skb_zcopy_put()
> > > function.  Pass 'true' as the success argument, as this
> > > is identical to no change.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >
> > uarg->zerocopy may be false if sock_zerocopy_put_abort is called from
> > tcp_sendmsg_locked
>
> Yes, it may well be false.  The original logic goes:
>
>    sock_zerocopy_put_abort()
>    sock_zerocopy_put()
>    sock_zerocopy_callback(..., success = uarg->zerocopy)
>      if (success)
>
> The new logic is now:
>
>    sock_zerocopy_put_abort()
>    sock_zerocopy_callback(..., success = true)
>      uarg->zerocopy = uarg->zerocopy & success
>      if (uarg->zerocopy)
>
> The success value ls latched into uarg->zerocopy, and any failure
> is persistent.

Good point.

It's not entirely obvious, and a bit unintuitive to pass success in an
abort statement. But it works.

Abort does not schedule a notification if no skb associated with the
uarg was sent. And if it was, the zerocopy state will reflect the & of
all those packets. On which note, if renaming the currently
inconsistent name, maybe renaming to zerocopy_success is the more
descriptive one, then.
