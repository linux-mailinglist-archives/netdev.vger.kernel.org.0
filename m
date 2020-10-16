Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67D229070F
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408780AbgJPOU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408771AbgJPOUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:20:55 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4716AC0613D4
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:20:55 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w17so2806015ilg.8
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILU1JiiWwmc95Pb/WWnMrCIUzuQZgL65VpWvlyy0uws=;
        b=HEPkXoSC4+XViOa2NstBZBi5peIDrb80Thy9EpYPPQFO80kSOluTlFVunJ9q7XLi41
         PPqK2THj7pyPrLghVLfFynw1npRcrsx6jx0Wgrfgyqg2brX8ZvopZSU7YSdH/0LkVpDO
         JDE22r1UgDghP9r57+WICgOjhnO4KERaBTDhCVUqUaqDquxzefiNcEqHITD9Mjmgv5b5
         40IbFKVTza9Er2Gz15cRfaJF4YHhV8o59A792eqKJ7sq/2zyOuZ7e5fpSaA3CJyWm7DS
         7srxW9LYUi2hOcy39d6X4sgQNR4S94gbsuLgztiZqFFOuee8yzBElhn/1AHSiVKSaaxD
         Ewrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILU1JiiWwmc95Pb/WWnMrCIUzuQZgL65VpWvlyy0uws=;
        b=ooEBp7uqj9GTeZd7HRpYgqlhbidOo3oookNoBqpifcgra6q+/GdPxt/J+/2mpotzrP
         OTEPIYC6+6lqMCwXS7xTcAFT6mnSt5X2iGZ+X+qToYiRtDHVRo9uzJ7uMvhaeuDgD4iK
         AMor2IPqD/LtQ0bM16H46lgjbSXHYExvFiZsKmmRaSpPyJt5yayvh7/5e2tNuLF4VCE3
         Z0xKkSk+SQOb4eUx5WX6fP8CT0vO56Lac5Z9B8VRMCmloDfAbSqPm5nUIQLdC0ItXzH8
         X8lJeIfenboe3C93eOwyrfUFCPPuqtaLjB+W9dFrjLaYt8lGODKJV8O8/M6qk26INg41
         47aw==
X-Gm-Message-State: AOAM532AbLV1CS9pANcRFuGu8tLZFEbMspsxUwRa5ZUuGnn3GmPIF0DV
        yN+dPjBWUX1DQ2ttIkWBFCLK+5GB54ACBYCwgA3CTA==
X-Google-Smtp-Source: ABdhPJxubq2fzGL00SIrDkBpOu8eo1lYW9KXkOhd7VAlU2NeWINOP4NjqVxzNovv5CI4q3PGv41TQKCIzUMr+AlwxJ8=
X-Received: by 2002:a92:8404:: with SMTP id l4mr3069053ild.134.1602858054317;
 Fri, 16 Oct 2020 07:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <20201007101726.3149375-2-a.nogikh@gmail.com>
 <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
 <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
 <CADpXja8i4YPT=vcuCr412RYqRMjTOGuaMW2dyV0j7BtEwNBgFA@mail.gmail.com>
 <20201013095038.61ba8f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+FuTSf2kfvdYydXYJNCCfE62q9DXXOBMh_ZSO5W=L9GK478HA@mail.gmail.com>
In-Reply-To: <CA+FuTSf2kfvdYydXYJNCCfE62q9DXXOBMh_ZSO5W=L9GK478HA@mail.gmail.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Fri, 16 Oct 2020 17:20:42 +0300
Message-ID: <CANp29Y69mvAuwdcNk8DyjYSjDMBkQupMh0JHHLkybg+rA2zCLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 10:04 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Oct 13, 2020 at 12:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 13 Oct 2020 18:59:28 +0300 Aleksandr Nogikh wrote:
> > > On Mon, 12 Oct 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
> > > >
> > > > On Sat, Oct 10, 2020 at 5:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:
> > > > > > On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > [...]
> > > > > > > Could you use skb_extensions for this?
> > > > > >
> > > > > > Why? If for space, this is already under a non-production ifdef.
> > > > >
> > > > > I understand, but the skb_ext infra is there for uncommon use cases
> > > > > like this one. Any particular reason you don't want to use it?
> > > > > The slight LoC increase?
> > > > >
> > > > > Is there any precedent for adding the kcov field to other performance
> > > > > critical structures?
> > >
> > > It would be great to come to some conclusion on where exactly to store
> > > kcov_handle. Technically, it is possible to use skb extensions for the
> > > purpose, though it will indeed slightly increase the complexity.
> > >
> > > Jakub, you think that kcov_handle should be added as an skb extension,
> > > right?
> >
> > That'd be preferable. I understand with current use cases it doesn't
> > really matter, but history shows people come up with all sort of
> > wonderful use cases down the line. And when they do they rarely go back
> > and fix such fundamental minutiae.
> >
> > > Though I do not really object to moving the field, it still seems to
> > > me that sk_buff itself is a better place. Right now skb extensions
> > > store values that are local to specific protocols and that are only
> > > meaningful in the context of these protocols (correct me if I'm
> > > wrong). Although this patch only adds remote kcov coverage to the wifi
> > > code, kcov_handle can be meaningful for other protocols as well - just
> > > like the already existing sk_buff fields. So adding kcov_handle to skb
> > > extensions will break this logical separation.
> >
> > It's not as much protocols as subsystems. The values are meaningful to
> > a subsystem which inserts them, that doesn't mean single layer of the
> > stack. If it was about storing layer's context we would just use
> > skb->cb.
> >
> > So I think the kcov use matches pretty well.
>
> skb_extensions was the first thing that came to mind when I read this
> patchset too. It is not specific to protocols.
>
> We have long stopped growing sk_buff size.

Thank you all for your comments. I'll use skb extensions in v3 of the series.
