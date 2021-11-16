Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B43445295E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhKPFHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbhKPFHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:07:38 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FCCC0AFD53
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:06:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c4so34288851wrd.9
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZZyVwV1rQ+tKG0KWx/hLK+JRq820EkRnM/kUQnvOqc=;
        b=CafQGLBVlCDPz1/9nPQviHCoStosJNX44rjFC+iyncdojjMSOdaBVR+VXzQqIL9/yL
         Rzyl3liR49tID7cGtLf4nYs0XlVkX4hd1BQsBvoqcgAFGUfyasNOKO0Y9dglIiy/dA0P
         oLr1wtqHjXDTA4FKk3Aj6uikt8hslun0KF/OEbsxpIwxYdP3Php9wQ5+idrNjfTP0DBp
         i5LoBhaP3G9DvAlqvfXyajSga+DnvQNrGWNxjo64R+UYLlqJ9+qYweQLLBN9tb+9UfMv
         VqauvU5yDrTVRfBRQ9fRosQK29CMMDRCvWh6wHCqHviF8aD8W4xhpAOGEAO+TiTt34Wm
         +I2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZZyVwV1rQ+tKG0KWx/hLK+JRq820EkRnM/kUQnvOqc=;
        b=Da85WVRNCceexgN4C/TTlzpEwEQiYHrh6Kyex6nx1nOT3mCU4fzvVz0Ry16f6otpXs
         XxqQhHa7KUelmdmX+XANtxHe72BPxEnCkxnOk4QREifIIeOJ+Svn/kAIOcHB3oqRtgZO
         8fDcSJ8p559tRv/5/YPsR0avf/bq9bFYYjlL8ru0zULgwmY4bSfPDxdoUzOOHdTiXYv8
         KTDlEGFFxToLOKphi8wRti7xyRlKgkUYJ1AzCEfdpqC6+8rQSJNqg1khJlpFqwLpiqL4
         xxG2MffJt656ff8eiTs9QYQE4vWAFC8nC27msZMMTSLmQbZZT6lRtA+5pGkSS0qF9Gxn
         e2sA==
X-Gm-Message-State: AOAM533qoahmSAObf+r8w0mwiGphnZYM7/46NVjR8N9ydVpoGAwXlIfn
        mVVcwiAQvm6kzeAS6J898/cL3c+i+OJr0iI9QNaKzw==
X-Google-Smtp-Source: ABdhPJw89LFVuFrgij0vFSFLcw8wFRBZmKG1wInMmkgXRswZvx9UFPu7e43PRBcng8UDQB8l7gThIlWC6Nxo56RFQOw=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr4892378wry.279.1637028401074;
 Mon, 15 Nov 2021 18:06:41 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com>
 <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com> <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com>
In-Reply-To: <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 Nov 2021 18:06:29 -0800
Message-ID: <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 1:47 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Nov 15, 2021 at 1:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
>
> >
> > Possibly there has been some issues with the ML while processing these
> > patches?!? only an handful of them reached patchwork (and my mailbox :)
> >
>
> Yeah, this sort of thing happens. Let's wait a bit before re-sending ?
>
> Maybe too much traffic today on vger or gmail, I honestly do not know.
>
> I will send the series privately to you in the meantime :)

Apparently the series is now complete on patchwork
https://patchwork.kernel.org/project/netdevbpf/list/?series=580363

Let me know if I need to resend (with few typos fixed)

Thanks.
