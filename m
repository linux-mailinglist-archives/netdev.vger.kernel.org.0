Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC8F9F50B
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfH0VYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:24:12 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:45005 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfH0VYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:24:11 -0400
Received: by mail-yb1-f196.google.com with SMTP id y21so66284ybi.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 14:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hKHsjcDAG4RhnSDgZIgpudEXoh90unKo1NgFp7jVQcc=;
        b=IlMVrY8a0gubOGCgBEMYd8GiOhL3xwel+QxSn4y8TfEFFhuI2Jeawj/2vJsXu2Rp4c
         L4WBsbQTMe7hCwngU/MyX1jESFbOSL6uDpIVOVEnkaN1AAInYIS6kdaDMKUkWI5yUbb6
         j4YpjEaIsV/PBjUlKdU26nDf0m6vmnfdfFMd/1zXZbJ2UpmjzI8svrKAFvLSdGgQu8tF
         syjPqGjo0oMGHkQXj7RerDZmkLfelnOUH+yKd/9c3iDr9ia2z8yKeU7NcpoVAGWqpVg5
         pKY7q5h+qt3iBFSOwvhaysX0I/PGxD/IvFa/2TC1s08wnhiCFoGHekKv2ItUQr2fjGqt
         Grng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hKHsjcDAG4RhnSDgZIgpudEXoh90unKo1NgFp7jVQcc=;
        b=WO99stnN5YvuU3WAdVkRXQWGbV3CpdbCGQY4GB0qy0bWz2YMwTHA6i14pSq5LMGOLg
         JpZZRjdt1hAvF1CGiezhTaRG2M2nsGDAUEsdqgiogr3oLNo1tko6O8vvttBokiG564kX
         XZC+n/uDJW4vcN13jDaMniaBnjFGbU8WwPtYkh4dzik0wJWCdRVpqIrpEAPm3F+JCsIb
         0ytZSuPNiIq4yusnLCq8XMhbxtfiKEbAP8HQj3WWVaNmermkhJi8cVTgIwgSnbGs3O2k
         kDO9TQvDHu+/44FTFtWay1lAWGXV4PBZwuSb8TdDY2IOGxI7NMureR9KLjulnQh2/o2w
         Ir3g==
X-Gm-Message-State: APjAAAVefL7gK/VY4ngDUKic0OsWHRRPHlmtB9jFiI97DjaVJnubSf5F
        lKxZkEHsNLW+GMY7qVceos9fqq6f7xx8Hl1je/+gdg==
X-Google-Smtp-Source: APXvYqwUw5ILYkrF8yEkRxm1bUiB3gfU/m4AQDf8m3sREGo2+wZqG3MUAFy4QIsezrpejS9UmoTWWTEpmD0Ik7mKfng=
X-Received: by 2002:a25:8149:: with SMTP id j9mr663614ybm.132.1566941050788;
 Tue, 27 Aug 2019 14:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
 <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com>
 <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com>
 <CANn89i++59nk_RFMOgor6XL3ZZY7t9QLa70sppKe6eQBrObagQ@mail.gmail.com> <CA+FuTSeVKSJHXY_LwJBiVreqm+MUSoJt+Dp3mdATKvB48DUz-g@mail.gmail.com>
In-Reply-To: <CA+FuTSeVKSJHXY_LwJBiVreqm+MUSoJt+Dp3mdATKvB48DUz-g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Aug 2019 23:23:59 +0200
Message-ID: <CANn89iKFXBVtoAjAMCNOG_qVaYRHDJ8prVdY58TCmZ35wTMjoA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 11:16 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Aug 27, 2019 at 4:58 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Aug 27, 2019 at 10:54 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > Sure, that's more descriptive.
> > >
> > > One caveat, the function is exposed in a header, so it's a
> > > bit more churn. If you don't mind that, I'll send the v2.
> >
> > Oh right it is also used from tcp_shifted_skb() after Martin KaFai Lau fix ...
>
> Leave as is then?

Not a big deal really ;)

Signed-off-by: Eric Dumazet <edumazet@google.com>
