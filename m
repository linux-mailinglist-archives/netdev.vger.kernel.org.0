Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EEF32FACD
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhCFNMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 08:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCFNMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 08:12:24 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CB7C06174A;
        Sat,  6 Mar 2021 05:12:23 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id l11so1105730oov.13;
        Sat, 06 Mar 2021 05:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0wzqVaXChjStroXwWRXVPgVCKcQRwhC1Jqv2F7KESE=;
        b=jTbA/XBo32PJVo5h9pweUfGkPzzzASN2PlqlO2iMKECp9f6xXlgS4CsbDebpWqCg1Q
         ce5aUNqcsqZYGiy+41bIVEt2nG5/uqpUYAQCy4mZT/6N7lCajHCZUUUOMo7qGVsgifar
         jkRl/jlNkzxFP5VpEMaqV4oGE7GwdAuN1+opdE+pEaKu8Mq+LBsX95fhpk+Ppyd3eovD
         wpPejfHj8qV9s6WED/DZKBlCaBjvgrPmIaBx7qbWCWvwckEiWHrdKUnzqCFIWCERlkwL
         /17bie4/eD6//XM3rNZJkwsoi7N/JOwGk639Jc4f8bx2q2ajYXkZnVeoVbsnO0VYAGOM
         Y8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0wzqVaXChjStroXwWRXVPgVCKcQRwhC1Jqv2F7KESE=;
        b=m2C8RnS68OJMPWoUY2538UdL5b4oDviQu44CjxicHaD8DuH4PL09o32nDDkNKKSGjo
         adH8v/TuWq41VDHs+bSw64M2Ds2OJGp7n+4JLGwpQ/+nM29JHps/Y5QycbWQM765j393
         QASWm+lRdPMKFPkRO4paebqxMGuh5RlLaFkS7eOTHicxGR9v2O1yXb2e/6wGmRB+PFRJ
         mZQ5hk2HtvfaeY1yqR3KarEfa1RgLGXkNKYPu9bQSI5islafm/AOprk/ksoyQHcOqvD4
         1/yYWAuQ9r3d3RrKXfMOF/uo0iS5c0YBT7CCzPmRSqql3xYwUpvSejiRTZG+xDEke+Nj
         4sZA==
X-Gm-Message-State: AOAM5335u8e0ppu7Ow8DvTZAuUWmopcWHwBdZLkSFyZnua5LdEG8rsq/
        HqU7vCOgjJxFEub15IFykXYdF4rmPFE9z8rg8HE=
X-Google-Smtp-Source: ABdhPJx2f+GvGkQmfvyAUv1PcXcuXHOti6AZ0WFUwteLTO7ruLs4FWUEI5Yv3dLXtHPMOz+i8C0FeIr1plvB83xuN9k=
X-Received: by 2002:a4a:a1a1:: with SMTP id k33mr11715767ool.34.1615036342478;
 Sat, 06 Mar 2021 05:12:22 -0800 (PST)
MIME-Version: 1.0
References: <20210228151817.95700-1-aahringo@redhat.com> <20210228151817.95700-5-aahringo@redhat.com>
 <f4599ca2-31c3-a08e-fad8-444f35cc6f6b@datenfreihafen.org>
In-Reply-To: <f4599ca2-31c3-a08e-fad8-444f35cc6f6b@datenfreihafen.org>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sat, 6 Mar 2021 08:12:11 -0500
Message-ID: <CAB_54W5JrDSi89-5EEouutNMv6wwvS=8CzgOjcyecasfaw9pKQ@mail.gmail.com>
Subject: Re: [PATCH wpan 04/17] net: ieee802154: forbid monitor for set llsec params
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 4 Mar 2021 at 02:28, Stefan Schmidt <stefan@datenfreihafen.org> wrote:
>
> Hello Alex.
>
> On 28.02.21 16:18, Alexander Aring wrote:
> > This patch forbids to set llsec params for monitor interfaces which we
> > don't support yet.
> >
> > Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >   net/ieee802154/nl802154.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 3ee09f6d13b7..67f0dc622bc2 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -1384,6 +1384,9 @@ static int nl802154_set_llsec_params(struct sk_buff *skb,
> >       u32 changed = 0;
> >       int ret;
> >
> > +     if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > +             return -EOPNOTSUPP;
> > +
> >       if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
> >               u8 enabled;
> >
> >
>
> I am fine with this patch and all the rest up to 17. They just do not
> apply for me with 1 and 2 left out and only 3 applied.
>

I am sorry, I will recheck.

> Could you resend 3-17 as a series and we can discuss 1 & 2 separately?

okay.

- Alex
