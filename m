Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97232A6E52
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgKDTxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKDTxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 14:53:34 -0500
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8670C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 11:53:34 -0800 (PST)
Received: by mail-ua1-x943.google.com with SMTP id a10so3059563uan.12
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 11:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJxPUcNSutStqK4O6mBjyWrgm1FTQ0U03ti+bTVMVpQ=;
        b=Kh2rpj15LcOhoHo76drsegQNj3TRyVrGlfM7yH2VK8yX+x2liWRY1PNqxl2U4kW8j6
         +HodthpUcvJM6L/ydCM4pwiqIAP9ydVL8O/VAb/22kBQ/PK/6gLZbYV2Yrf7iEPr/TcK
         A5GgoaKlKwwbuiPXfaacppIFQmCFrLriG4RNaGKOTdgYcecnuurYRJfx9HxLhVR/BU6o
         7wM6JS8NF4Ltta5ZRMv31TNcFCc+utJmwdUyE8jay7qfaPElzcXjUwWg4fvmD+8sKHnQ
         q+F0WVoK71S7jIOBiGO6toYjod7R2iTCrXxV89myp30btpEv1u/G82uOM6wkrBiRVRRN
         kmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJxPUcNSutStqK4O6mBjyWrgm1FTQ0U03ti+bTVMVpQ=;
        b=EeqCQedw/6QSXIAIBP8eevf1z4+DYsnkUUTj7dQf5gLDFEA+C0GdXmpfEIGTYWvLp1
         Lc/XGJctRzc4o2E/0BiG5dG54hjF4wqoxfvoeldrf0YQCif4LbcHL3DbYG941yFISU0Y
         GvYwDw0T9vd2Ph0krMk2Bj9y0Sb50M4iYUFP8Vq5TruBtUf1Jn0rsWOFP/udJPzU06Q8
         2b0jiUljPIbJFy/7mK0yfh5KNtGmkMnMR6ihWfOEAE1VNgfNKtpwSwpY945rP8PqtOsB
         8Odwn5MywudB5Yubdat87elheneaGGaSTSxnaYBiEY/cKUgDF7S8UpaJSjGImofF45nc
         tLFA==
X-Gm-Message-State: AOAM532UgGbIIDXr3C/9CScDcplCztnH/Bdbpfuc9lW1hHjWnCDo3MH7
        mei61PZ6znQXHIYFRnaF9ArLFJ7RzzU=
X-Google-Smtp-Source: ABdhPJz6ZSKXpITXWxuMc1fMDtO9F1PS2Ye5zT35yH7SI++1m7WRltvRGZKcYneLBqel4m0Iacm5kQ==
X-Received: by 2002:ab0:84f:: with SMTP id b15mr11811277uaf.55.1604519612052;
        Wed, 04 Nov 2020 11:53:32 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id z1sm393011vka.37.2020.11.04.11.53.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:53:29 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id k12so6403905uad.11
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 11:53:27 -0800 (PST)
X-Received: by 2002:a9f:28a7:: with SMTP id d36mr10511313uad.37.1604519606890;
 Wed, 04 Nov 2020 11:53:26 -0800 (PST)
MIME-Version: 1.0
References: <20201103104133.GA1573211@tws> <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
 <dc8f00ff-d484-f5cf-97a3-9f6d8984160e@gmail.com>
In-Reply-To: <dc8f00ff-d484-f5cf-97a3-9f6d8984160e@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 4 Nov 2020 14:52:50 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeqv=SJ=5sXCrWWiA=nUnLvCgX4wjcoqZm93VSyJQO1jg@mail.gmail.com>
Message-ID: <CA+FuTSeqv=SJ=5sXCrWWiA=nUnLvCgX4wjcoqZm93VSyJQO1jg@mail.gmail.com>
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 2:30 PM Oliver Herms
<oliver.peter.herms@gmail.com> wrote:
>
> On 03.11.20 19:42, Willem de Bruijn wrote:
> > Thanks. Yes, this is long overdue.
> >
> > The hard_header_len issue was also recently discussed in the context
> > of GRE in commit fdafed459998 ("ip_gre: set dev->hard_header_len and
> > dev->needed_headroom properly").
> >
> > Question is whether we should reserve room in needed_headroom instead.
> > AFAIK this existing update logic in ip6_tnl_xmit is sufficient
> >
> > "
> >         /* Calculate max headroom for all the headers and adjust
> >          * needed_headroom if necessary.
> >          */
> >         max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
> >                         + dst->header_len + t->hlen;
> >         if (max_headroom > dev->needed_headroom)
> >                 dev->needed_headroom = max_headroom;
> > "I think that's enough. At least it definitely works in my test and prod environment.
> Would be good to get another opinion on this though.

Sit should behave the same as other tunnels. At least in ip6_tunnel.c
and ip6_gre.c I do not see explicit initialization of needed_headroom.

> >> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> >
> > How did you arrive at this SHA1?
> I think the legacy usage of hard_header_len in ipv6/sit.c was overseen in c54419321455.
> Please correct me if I'm wrong.

I don't see anything in that patch assign or modify hard_header_len.
