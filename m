Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD607452A03
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhKPFtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbhKPFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:49:13 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A01C04E217
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 20:01:56 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r23so553575pgu.13
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 20:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kP6wmSDyXAWSQKk8ozhtBFSP3AEfj41pxw6AIYIArQ=;
        b=rscerWIrBkvuYKKAjOdKfjWUyn34O8E7V+ghFZvLOEiaIixcB0ivwvdvEMeWbKwJeA
         RZRkZjinrNsgprMSHrMkM6pd9heWAaG3+Es1ydP+xF/1A8yR81TY+3JCiUqG3ct2n+Ow
         JDx/4YwDAq8x/MKPCH6C00qE3KKGP0nX7RysbHbWOSv3L6Xs141mEcHFq050rEui0Ef3
         SJ8rWaYsUSIAAudRiAuQVX5MyDbXDLq31JdbloONreKkQJNTR2+iYYTDfig4W00jjLY6
         LGxmQw7Ug0zFnDH6oJVEGLFQIjKjHAZL3tfLIIYYVSVYEa8zy4TE3ECvE+oHbaLke1sk
         w4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kP6wmSDyXAWSQKk8ozhtBFSP3AEfj41pxw6AIYIArQ=;
        b=5idOJCqsNRi4gk3B42dl0BAyUvj3rl1NH2NWYPhnvLBubmJ7KA89NnlkXsSSS0RBVZ
         pkGZRnSbYBvb66dJ4/Gx7WJ1gVb08HV1hDVn3zvMQGjzyPz1vsIa1241/pDlR+BMcCK/
         0EilPYlolKD8fbuFd6VNLB0jRdJ1ciBSPBJKJ98CEllC2/i3zN4XkKCuQsaozzYqLU3q
         QGrvtYyUdHG+RxJzj/pvmj14p51pMB476e//RvnDGltIFm1TqDI2t/RAEG1/JI/IEgLs
         EQKNQ+0+UlX5QR+FgXibVxAhyMSWteAz08SZ0wNWsrOnWJaHwZxaALum7T8aWVEvD4wz
         jjNQ==
X-Gm-Message-State: AOAM53201rAmOimWNqK3/RNE5ugvlGI2FnalyvHP0QUygqKhOYzlKHYu
        lZyj7Os5F4jz1t/aKgaano8JvMnBZaCQ6oCRi+XfCg==
X-Google-Smtp-Source: ABdhPJzUqAUkD3+tkkdfSKswPa2lduAOjjYiq+DhmFAFGiWTPGO2mADh1HM4aFkUh2wtwSvGV/Jsi1CkzsBW508Q3JE=
X-Received: by 2002:aa7:88d6:0:b0:49f:dd4b:ddbc with SMTP id
 k22-20020aa788d6000000b0049fdd4bddbcmr37875096pff.31.1637035316250; Mon, 15
 Nov 2021 20:01:56 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com>
 <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
 <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com> <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com>
In-Reply-To: <CANn89iJ2vjOrH_asxiPtPbJmPiyWXf1gpE5EKYTf+3zMrVt_Bw@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Mon, 15 Nov 2021 20:01:45 -0800
Message-ID: <CAOFY-A0KEfE37=sr8UiJdH3VbqShY5Miaa0UGDQcwZX54sLnfg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 6:06 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Nov 15, 2021 at 1:47 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Nov 15, 2021 at 1:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> >
> > >
> > > Possibly there has been some issues with the ML while processing these
> > > patches?!? only an handful of them reached patchwork (and my mailbox :)
> > >
> >
> > Yeah, this sort of thing happens. Let's wait a bit before re-sending ?
> >
> > Maybe too much traffic today on vger or gmail, I honestly do not know.
> >
> > I will send the series privately to you in the meantime :)
>
> Apparently the series is now complete on patchwork
> https://patchwork.kernel.org/project/netdevbpf/list/?series=580363
>
> Let me know if I need to resend (with few typos fixed)
>

Deferred SKB free looks good.

Acked-by: Arjun Roy <arjunroy@google.com>

Thanks,
-Arjun

> Thanks.
