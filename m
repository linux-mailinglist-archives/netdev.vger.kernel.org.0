Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BFD26988E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgINWGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgINWGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:06:32 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D23CC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:06:32 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h1so727339qvo.9
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bvww47pszRQ19uPC5VMxxJpNqbHcfb7SBJv4kxWLrqo=;
        b=YbUSiTJ0MBEMgQ3jCQXEz3udq5jss7fKe4qvrR/7l6lGx+KjLbJqq3OzrUhPQdD0Go
         5CrqQwpJXFk7nuEQmsoSQEYLbCJYjqwdmFmM36n1j/OuDHA5EHwQ7wsUA9uSy9SDr5HE
         KjoGBN4JnM6eJxgmqMFS/t+V/fl9FchV9tOAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bvww47pszRQ19uPC5VMxxJpNqbHcfb7SBJv4kxWLrqo=;
        b=hC3pvIzSQqPtJJxYBUq3D30mpx2s4yPI4HkXd4dcT9YnnVsxwPY0JhMZomwl4Ck7n3
         wcKLr77xIql54oNCmJWw/XHMiXUHJ3NPZXB2h9sUPpxI55MrNEcXnbXvW4GnI8qtFlNP
         tD2VrOHlYVTNqJBzs/AarD7z+514i1cRzJpmL/08Zvew1cELLyZvmeSswsKv+zbpBC86
         BX9izpElx5JGHidxy5bXOvLeBkh6OIJ5/XZOIDEDez7PVmXQ9foPx7f7F+LREHqNBENU
         WXx14ImZXHws/ShvJGH6pec3zFJvMWlRNUqomOgV8ZoPFijZKll15pMpHmYiEu/qzFvC
         bjGA==
X-Gm-Message-State: AOAM532Ho7eWSWh9uVPpGraZ7KfCXDMDQdmT/ndrCGi52FTFeyCooiVv
        wtJXdc/KSUPxcPf6eaxmiAij7UUY4E7SXzGaKMnpTg==
X-Google-Smtp-Source: ABdhPJwtUlC2gt7OThNBezusn+sBOm6lH6YsxewcXPFD+oGZRKF5JQOHKsKIL5Nz2A9Q4zTK3mJApI8w7RWiyqy1/jo=
X-Received: by 2002:ad4:4c0a:: with SMTP id bz10mr15322361qvb.14.1600121190939;
 Mon, 14 Sep 2020 15:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com> <CAACQVJochmfmUgKSvSTe4McFvG6=ffBbkfXsrOJjiCDwQVvaRw@mail.gmail.com>
 <20200914093234.GB2236@nanopsycho.orion> <CAACQVJqVV_YLfV002wxU2s1WJUa3_AvqwMMVr8KLAtTa0d9iOw@mail.gmail.com>
 <20200914112829.GC2236@nanopsycho.orion> <20200914143100.06a4641d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914143100.06a4641d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 14 Sep 2020 15:06:19 -0700
Message-ID: <CACKFLinODtbqezEeYdiEwcgkTdCa66D3D5_Xx+OjT23qsLi4Og@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 2:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Sep 2020 13:28:29 +0200 Jiri Pirko wrote:
> > >> Instead, why don't you block in reload_up() until the reset is complete?
> > >
> > >Though user initiate "devlink dev reload" event on a single interface,
> > >all driver entities undergo reset and all entities recover
> > >independently. I don't think we can block the reload_up() on the
> > >interface(that user initiated the command), until whole reset is
> > >complete.
> >
> > Why not? mlxsw reset takes up to like 10 seconds for example.
>
> +1, why?

Yes, we should be able to block until the reset sequence is complete.
I don't see any problem.  I will work with Vasundhara on this.
