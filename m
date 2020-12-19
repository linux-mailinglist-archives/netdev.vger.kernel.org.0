Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54E02DF12D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 20:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgLSTCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 14:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgLSTCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 14:02:34 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA98C0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 11:01:35 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id j59so253421uad.5
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 11:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g//FK5JkJqWq/N862JClyeKYzop8m+pqv7c8aODeHsQ=;
        b=NsTivoLTBppWKjs2xWnb1uUHlEt44+3Q6KKyZt3U8nHqWzWFUc0vNLDwnpx/+VPJic
         BzAyBb8G1i/KV8NZqI55DIs1JSJZgNa55esIeeDlhWMYDpKmYJWDhIvcA2Vi5LjpydLK
         Nw2ug2nExi0kPedShhF8zD69bHitY+t+9DYcdW11tU0VKMMWAixRHK60Eug5LJGpe227
         2wfnTW6Khz9xUJPlDNc8eV/T9cZrWtovD5z0pSLcEhG8T/DizPFU81erwsX2JRGCKKsO
         l7yGnKChL2pnYb85zJidU4DDODAPr2P1CmkXzMPIGDAH1xGMX/Ig7mWWmXqwPcshTi9A
         hjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g//FK5JkJqWq/N862JClyeKYzop8m+pqv7c8aODeHsQ=;
        b=HLPnFIiBCEZOw5YcoVnN7KUQn9zV92tVTh1qQ6bmxdJn5Mzns+PvaT21r/7cSB4BkO
         wcW098RiDg3/hD/yPm87GGEg7GdGO67W8aE76yv+T3/Lufm7BcravfsVxwEl9GHEM9NI
         ixiUsZdVIV6KWUGg8DjPym1UFNmWrs3hSKJdd2yKSmWFp4W+acgJhm63mhebPofYD3Pe
         tSHgqk9LODaSEwFIzAoKUfNtrMTzWBkX5EKujt/3zxUl+oOvY3C1UNOSL2MihOsC2VVE
         10dMFVBDcmfHkNckcR3M76RopSOGgO7/HGONucXxQgFdlc2I1IVy3aCMFi7b6ptUDBW/
         8G0w==
X-Gm-Message-State: AOAM533XNf+Z/OiAI2cFhQhJKoyaWZVniq2UNn7nGlT+axyfi9iVW30z
        Z5dY+TMGUlJ6FmiYfiquWJ9YC6Q0Fg0=
X-Google-Smtp-Source: ABdhPJzmnMRHcRPq5N2NnRLkHVlMXLo0vYrvMBxtyACwOvrIvY5Il5d/GSGny4Se12h1MOKJpdJVnA==
X-Received: by 2002:ab0:65c2:: with SMTP id n2mr9001608uaq.73.1608404493843;
        Sat, 19 Dec 2020 11:01:33 -0800 (PST)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id i18sm1788228vkp.48.2020.12.19.11.01.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 11:01:33 -0800 (PST)
Received: by mail-ua1-f45.google.com with SMTP id 73so2004446uac.8
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 11:01:33 -0800 (PST)
X-Received: by 2002:ab0:5e98:: with SMTP id y24mr9154720uag.108.1608404492560;
 Sat, 19 Dec 2020 11:01:32 -0800 (PST)
MIME-Version: 1.0
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com> <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 19 Dec 2020 14:00:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com>
Message-ID: <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 4:27 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Fri, Dec 18, 2020 at 03:49:44PM -0500, Willem de Bruijn wrote:
> > On Fri, Dec 18, 2020 at 3:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > This is set of cleanup patches for zerocopy which are intended
> > > to allow a introduction of a different zerocopy implementation.
> >
> > Can you describe in more detail what exactly is lacking in the current
> > zerocopy interface for this this different implementation? Or point to
> > a github tree with the feature patches attached, perhaps.
>
> I'll get the zctap features up into a github tree.
>
> Essentially, I need different behavior from ubuf_info:
>   - no refcounts on RX packets (static ubuf)

That is already the case for vhost and tpacket zerocopy use cases.

>   - access to the skb on RX skb free (for page handling)

To refers only to patch 9, moving the callback earlier in
skb_release_data, right?

>   - no page pinning on TX/tx completion

That is not part of the skb zerocopy infrastructure?

>   - marking the skb data as inaccessible so skb_condense()
>     and skb_zeroocopy_clone() leave it alone.

Yep. Skipping content access on the Rx path will be interesting. I
wonder if that should be a separate opaque skb feature, independent
from whether the data is owned by userspace, peripheral memory, the
page cache or anything else.

> > I think it's good to split into multiple smaller patchsets, starting
> > with core stack support. But find it hard to understand which of these
> > changes are truly needed to support a new use case.
>
> Agree - kind of hard to see why this is done without a use case.
> These patches are purely restructuring, and don't introduce any
> new features.
>
>
> > If anything, eating up the last 8 bits in skb_shared_info should be last resort.
>
> I would like to add 2 more bits in the future, which is why I
> moved them.  Is there a compelling reason to leave the bits alone?

Opportunity cost.

We cannot grow skb_shared_info due to colocation with MTU sized linear
skbuff's in half a page.

It took me quite some effort to free up a few bytes in commit
4d276eb6a478 ("net: remove deprecated syststamp timestamp").

If we are very frugal, we could shadow some bits to have different
meaning in different paths. SKBTX_IN_PROGRESS is transmit only, I
think. But otherwise we'll have to just dedicate the byte to more
flags. Yours are likely not to be the last anyway.
