Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40486310247
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhBEBdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhBEBdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 20:33:19 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ED1C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 17:32:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d2so2885057pjs.4
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 17:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5m/q933AKS5Da4UZBbBXaEy0isO/GWwDL1FAIdyxAWc=;
        b=de9RQJWfm2RC9hOG+DHu1tA2ilVFCJisbNxWOksKkUsjdLH+6SoyKCN6dzb/BEszkV
         PsFDp3IYzBr7VfBkxENRGKWiAI9QwZ6zJ10b42EnUoFuxsuiuSWszHoBoZx824J0QxiC
         Kna9fhCsZWKJeWTp7cF1gAkfGqdQrIJQ9P/r6r6CBjfpQvMVFDWLI957yiyB+iWTXLx4
         TNZBnP7ZN0kPw9AOh+xkf0JLM9j3N0WSuq7H94jNuVU13YkJupAvZ79QGbEjrYOfxDWZ
         NmQaCSZB+IAZlCgex1/p8hty24Ed/ZwfCQPOAPgD3mAHdhxFFebkbQRDQqNEDH7Bs8zD
         s7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5m/q933AKS5Da4UZBbBXaEy0isO/GWwDL1FAIdyxAWc=;
        b=Qt6ABebYZumCtywMFLW5SnJ3yhTwdvXnjMjqLYScaGy1r4g1XoJfjO3Nmpp+ym6/6m
         hhMfcxqwJqpPLJEE51Hfu058nP0rVgq7Y7WQYMLWMhSBtTNcikJ3kaCQt/dq8yGOOI0j
         ZELwijAJ6KqllW8NzzWfqVQ2NJ4Tpb1D8XbjL6tZTe92UDS24AVjiv/EN6efM/e/KlFo
         itEDkj/SGnAo5QQLD31PfdO/Gro1qGnc2UdwYgR00JOTJkIGALkKuLqBFKQapLFiMslQ
         vjbVPtic+Nx1fJc78z+F8AS22u0qsA3RPXG+Wm6kcXRiJcHAcOfnqe7fJ0/SDsQ9cqv/
         BdLg==
X-Gm-Message-State: AOAM533iMFTw5fgPneMxCqpjX3yq3oSQcAs779I2965AvQk3EoaNDUkC
        8zhmz0Az3Y9jn4Q3IbTecBEm8q6VBsGJIcltEmKLeA==
X-Google-Smtp-Source: ABdhPJzToYcGq8Rasu96vuqQvr90B0PSPwz1jTDwsyNFnSZzIDCTC/xQcQpUJtDFXCIduf21oFdSHpeutIb7YPlqYlI=
X-Received: by 2002:a17:902:c24b:b029:e1:8c46:f876 with SMTP id
 11-20020a170902c24bb02900e18c46f876mr1864303plg.15.1612488759090; Thu, 04 Feb
 2021 17:32:39 -0800 (PST)
MIME-Version: 1.0
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com> <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com> <20210125061508.GC579511@unreal>
 <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com> <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
 <20210202065221.GB1945456@unreal> <CAOFY-A0_MU3LP2HNY_5a1XZLZHDr3_9tDq6v-YB-FSJJb7508g@mail.gmail.com>
 <20210204160006.439ce566@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204160006.439ce566@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 4 Feb 2021 17:32:28 -0800
Message-ID: <CAOFY-A0fN20RdeLS+SXZ2-WC_3rtLEhgXkC8jJtX_431OrNy9Q@mail.gmail.com>
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive zerocopy.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 4:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 4 Feb 2021 15:03:40 -0800 Arjun Roy wrote:
> > But, if it's an IN or IN-OUT field, it seems like mandating that the
> > application set it to 0 could break the case where a future
> > application sets it to some non-zero value and runs on an older
> > kernel.
>
> That usually works fine in practice, 0 means "do what old kernels did /
> feature not requested", then if newer userspace sets the field to non-0
> that means it requires a feature the kernel doesn't support. So -EINVAL
> / -EOPNOTSUPP is right. BPF syscall has been successfully doing this
> since day 1, I'm not aware of any major snags.
>

Alright, sounds good.

> > And allowing it to be non-zero can maybe yield an unexpected
> > outcome if an old application that did not zero it runs on a newer
> > kernel.
>
> Could you refresh our memory as to why we can't require the application
> to pass zero-ed memory to TCP ZC? In practice is there are max
> reasonable length of the argument that such legacy application may pass
> so that we can start checking at a certain offset?
>

Actually I think that's fine. We have hitherto been just using length
checks to distinguish between feature capability for rx. zerocopy but
I think we can draw the line at this point (now that there's
ambiguity) and start requiring zero'd memory.

I will send out a patch soon; reserved u32 field, must be set to 0 for
the current kernel, can be non-zero and in/out in future kernels as
discussed.

Thanks,
-Arjun


> > So: maybe the right move is to mark it as reserved, not care what the
> > input value is, always set it to 0 before returning to the user, and
> > explicitly mandate that any future use of the field must be as an
> > OUT-only parameter?
>
