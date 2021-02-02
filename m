Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7930C6D5
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhBBRBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbhBBQ6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:58:45 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D61C061573;
        Tue,  2 Feb 2021 08:58:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bl23so31047918ejb.5;
        Tue, 02 Feb 2021 08:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QoFBWNVeW362Fh0rp8McJnSuJrL1LHsgZ+i7Ga7Dn18=;
        b=O2iZQSgfIE/lc2zb6VH0ZT0VPhAKwYt6lwQVacOkZJ6lTtoM/9vEmiHEVnEuVijguG
         XGxnv9BvDp4K7FG/w2uMgKwehCttagfv9Nl8f+2zw6YAqNUq62qg1G5L41+cP24P9QE9
         k+8+YcEEpFTltAa0jhaB1TbXqMaxtGgv4WbesVDk6PEXMvLcpsq0kSqLdP07+6u3LX+k
         xbp1SV5D/6Ah2//LmgZ7xtjW/9eBoAD+xlaSE/AKQ55TGH3G5uhyxjYT7+d+PNQvYtEi
         3bteKA1aLZaYtV/c2/gL2guGj/5j53QWsQj5WiX5h3fhYjAi8PzBx8y4eJ3JI/5hqUI3
         UE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QoFBWNVeW362Fh0rp8McJnSuJrL1LHsgZ+i7Ga7Dn18=;
        b=X8LGx3hUQ31hVj1yYSAfveABS+3z5sJYysGjl5XV08eDVUImLgIe8z9t8XiyM4IxX2
         OjBWRbkMubfj8kNFnR5DS6NlDZeHdvpxTQGwQOJf7zMxcUX0jCtQcwTb54vu/VFyCm9Z
         XvEPt9FBl044UX3sVycxMbmz8DsMafqk6U++vPcPesR2xMw7CRkeS9tAPI35/feqI4t/
         9FjcgDFdAuW/efNZoPaxL934ISjLmsFHAGzC1sjMGgMml6L7sbAeF0d8wDDdgGO2tMbc
         Mg4S4/CTIFppo7rKs355dt9UBSe2nrUcUKgKEv6TiE0k4I1XZ40qkDXHVArnQI/5LeMs
         wbOA==
X-Gm-Message-State: AOAM530Xaq+yXLqWsW6z7SxoeRmcXjCwhiWyMSxHcBqyyqEiIhLTPFdX
        +tes8Q8aJ6+iBBA1fVntSVVZjxSZaxRP8ruzvEVFolW2IPM=
X-Google-Smtp-Source: ABdhPJw1rKGDjesa27/kXYB2k0HXKRAXTuvm+6p7sOpvoQ9Bnr2LhDm7o/CQT6AxL7Uzs1eG5OIR8Pg4pFoMjr8nfsQ=
X-Received: by 2002:a17:906:b0c2:: with SMTP id bk2mr23572150ejb.223.1612285109601;
 Tue, 02 Feb 2021 08:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20210201160420.2826895-1-elver@google.com> <CALMXkpYaEEv6u1oY3cFSznWsGCeiFRxRJRDS0j+gZxAc8VESZg@mail.gmail.com>
 <CANpmjNNbK=99yjoWFOmPGHM8BH7U44v9qAyo6ZbC+Vap58iPPQ@mail.gmail.com> <CANn89iJbAQU7U61RD2pyZfcXah0P5huqK3W92OEP513pqGT_wA@mail.gmail.com>
In-Reply-To: <CANn89iJbAQU7U61RD2pyZfcXah0P5huqK3W92OEP513pqGT_wA@mail.gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Tue, 2 Feb 2021 08:58:18 -0800
Message-ID: <CALMXkpbpB7AWNvtH4dbgP_uFi0hV8Zg0JfPkkdOLFwLRvxGMPg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix up truesize of cloned skb in skb_prepare_for_shift()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        linmiaohe <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 9:58 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Feb 1, 2021 at 6:34 PM Marco Elver <elver@google.com> wrote:
> >
> > On Mon, 1 Feb 2021 at 17:50, Christoph Paasch
>
> > > just a few days ago we found out that this also fixes a syzkaller
> > > issue on MPTCP (https://github.com/multipath-tcp/mptcp_net-next/issues/136).
> > > I confirmed that this patch fixes the issue for us as well:
> > >
> > > Tested-by: Christoph Paasch <christoph.paasch@gmail.com>
> >
> > That's interesting, because according to your config you did not have
> > KFENCE enabled. Although it's hard to say what exactly caused the
> > truesize mismatch in your case, because it clearly can't be KFENCE
> > that caused ksize(kmalloc(S))!=ksize(kmalloc(S)) for you.
>
> Indeed, this seems strange. This might be a different issue.
>
> Maybe S != S ;)

Seems like letting syzkaller run for a few more days made it
eventually find the WARN again. As if Marco's change makes it harder
for us to trigger the issue.

Anyways, you can remove my "Tested-by" ;-)


Christoph
