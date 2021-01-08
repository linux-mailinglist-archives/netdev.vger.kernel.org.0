Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04C2EF504
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 16:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbhAHPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 10:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbhAHPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 10:42:36 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7556DC061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 07:41:56 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id t8so10172972iov.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rdl53e5YzvjsgygPzGGIDR0O1KR91W7yRWB38HTDx3k=;
        b=Z0/LwqhozGvF1FFkwbE8FqMXl3ZWBW9m4WfcVSanU1/g++rHYB2lAhd4sKnQtw66G7
         KrZJu6cr0vAIqgz+mTzcUcere91I1Gd3si3F8zMhViIQ0tvm9WX+WG2y3w66PWNvMfg2
         1kgl20sKWrKdByvwWIDA7GLg2RR/SPcRaRuywFRnd852lBg73gy3+nUgLBmdG09GqW8/
         hnX1HURBC8QQJm6N8eehAzZH7fAzruocgEaLxHcqEqJ08DYWff6f3lsLSzXOZAD8KWun
         dVg926QFFTfkCy/qxKfxunomAvHzOOTNOoPkIBW1GPfrH2xxGFB1lSrkfbU2XwmylgjO
         2bkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rdl53e5YzvjsgygPzGGIDR0O1KR91W7yRWB38HTDx3k=;
        b=bD3qEY6A+OQMMkVe+W7jGCcWXAnYbAtp/mSEXZ9XKmxRQt4eF7F1X9NQOKbkxYJcnI
         kvt75SKViIj9pHqTO5DffTgyeinvgLTdfbOKk3bHd47rTshPgkewErMW4CS7x+slPIll
         7/+SCsFxJRjOSfTRjTkIrdkwHSNgRF+NgGyt/QpomJBxMqx2bjYKpWXI3ftKzqh2eGO2
         NX3DTRtXBOdNy4jaNIM2E3AiATYjBBJiwbGWF2U1wSNFyoFfo189KFD6R6S4FHiRhhWs
         LjVZCH+bR+Rk6WExtVsPedxqc9UbBaaYe7deEjuCfBk6UtrYqitFyPjACN+MfQgpoK69
         ijSQ==
X-Gm-Message-State: AOAM530oN8Lzj1v9UcPg7frj/0DUWr05m29fy+txrPpziP3mz1hBbJMT
        HIiUcVP2GG7rWETvtojfVjOTY4tQwa0Va6rJtAUC6g==
X-Google-Smtp-Source: ABdhPJxVULPHUrFgRLuWldg8LXgkifw9LjiXADsTCbFcbUm946tQ+FUloBnbR2mWL4ER2zCWcY64R4wjLJgOkOyaRZs=
X-Received: by 2002:a6b:918a:: with SMTP id t132mr5966388iod.157.1610120515642;
 Fri, 08 Jan 2021 07:41:55 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com> <CA+icZUW+v5ZHq4FGt7JPyGOL7y7wUrw1N9BHtiuE-EmwqQrcQw@mail.gmail.com>
 <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com>
 <CA+icZUXixAGnFYXn9NC2+QgU+gYdwVQv=pkndaBnbz8V0LBKiw@mail.gmail.com> <CA+icZUW5B4X-SMFCDfOdRQJ7bFsZXwL4QhDdtKQXA3iO8LjpgA@mail.gmail.com>
In-Reply-To: <CA+icZUW5B4X-SMFCDfOdRQJ7bFsZXwL4QhDdtKQXA3iO8LjpgA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 16:41:43 +0100
Message-ID: <CANn89i+GF1KuWLwKWxxafWrfQMfFMJdtS2rb=SzgAn9pERKg0g@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 2:51 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Jan 8, 2021 at 2:08 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Wed, Aug 12, 2020 at 6:25 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > > > Also, I tried the diff for tcp_conn_request...
> > > > With removing the call to prandom_u32() not useful for
> > > > prandom_u32/tracing via perf.
> > >
> > > I am planning to send the TCP patch once net-next is open. (probably next week)
> >
> > Ping.
> >
> > What is the status of this?
> >
>
> I am attaching the updated diff against latest Linus Git.
>
> - Sedat -

I have decided to not pursue this.

skb->hash might be populated by non random data if fed from a
problematic source/driver.

Better to leave current code in place, there is no convincing argument
to change this.
