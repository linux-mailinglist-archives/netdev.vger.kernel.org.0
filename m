Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFD18CE58
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHNI0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:26:04 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36048 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfHNI0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 04:26:03 -0400
Received: by mail-yb1-f194.google.com with SMTP id m9so3035343ybm.3
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 01:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CejZY3lyewNjJt+C+5hzfaV9gVWxxXHEWFUzG40TiII=;
        b=WhZRAlMrLkIDJrPuJ2TiXclmCaBgVTQM2UbQmQH3mMCal42gw7FegvxQd4y8uAyvly
         NOD9tdtXXjPOJ5tkCjpsMPNbZ+z46M8OxdwgQ9je+Dwz82qRfljE/UaY2MCetAm4eRCc
         GcMGWz4etfpkjB9S+twKdeoJqnFwMB2cPvouiXfkF+C5DUzcV/RwnwK/7fJEUmWh+X1G
         DqMFzzBg2mEO8eRA1+qI457OJVpE+VEym8SA30cOHAYaupsoxG+c8/RS4B7YUpxRFxYj
         EXzomp8icFTZgidtaV8PuIiLZrXu2JQ8YT6kS/CMip444Lv2751fZBXq6W+2e3oELHZl
         bGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CejZY3lyewNjJt+C+5hzfaV9gVWxxXHEWFUzG40TiII=;
        b=V7JP4X2Iq7uyEXGcUt9MuRs80ccYo5MJtxyCrkqLT/aCaEitCAJXvGwbq5l3PxY6jl
         x04tjdKwLg3E7TDWanudE4e0VgaA+xSWzvOfB4QA539QrJM9tPU3j4bXElXK6QT7gdex
         n71qcLtTzuxTIYf2onWd5AFUYr8hTOGRenLURZ8Rt3RSf0EsXZbKi9OCXwgO5sDEpUoy
         fWA6Ed6fldhh7VbwlOQ+oQFVEVfFrYCz1qS8O4GBFGSY02GHdRr+uI3AFpPVJD2VsvWm
         8oMwWnM7DkykswavSDvRlliz/dmUMAD1dMGhj6UV43MDzztZFDDT4Gd6P7Uyxi7mFG2U
         O10w==
X-Gm-Message-State: APjAAAXjLu0bC3SNqVDdbUABfxD6bHObt3U1hyKWU3PyM3I3AsHUAihI
        QcYAix+7mgfLKq0O7xIyMkQhqDF357jsRJz8+A==
X-Google-Smtp-Source: APXvYqzicIO/HMdQSgrpdILprHoPOjnVeQQmoxYoAeVM/+5TO1Wrikz9w15ete8i30HLNbF1vNtAWhJSgOTKpMkXCQo=
X-Received: by 2002:a25:d297:: with SMTP id j145mr10432614ybg.333.1565771162818;
 Wed, 14 Aug 2019 01:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190813024621.29886-1-danieltimlee@gmail.com> <20190813144303.10da8ff0@cakuba.netronome.com>
In-Reply-To: <20190813144303.10da8ff0@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 14 Aug 2019 17:25:51 +0900
Message-ID: <CAEKGpzjxvvXE79NZE8_C35mJvhRxTjzWYrcb-A3YQG4LgvDQ6g@mail.gmail.com>
Subject: Re: [v5,0/4] tools: bpftool: add net attach/detach command to attach
 XDP prog
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 6:43 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 13 Aug 2019 11:46:17 +0900, Daniel T. Lee wrote:
> > Currently, bpftool net only supports dumping progs attached on the
> > interface. To attach XDP prog on interface, user must use other tool
> > (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> > can attach/detach XDP prog on interface.
> >
> >     # bpftool prog
> >         16: xdp  name xdp_prog1  tag 539ec6ce11b52f98  gpl
> >         loaded_at 2019-08-07T08:30:17+0900  uid 0
> >         ...
> >         20: xdp  name xdp_fwd_prog  tag b9cb69f121e4a274  gpl
> >         loaded_at 2019-08-07T08:30:17+0900  uid 0
> >
> >     # bpftool net attach xdpdrv id 16 dev enp6s0np0
> >     # bpftool net
> >     xdp:
> >         enp6s0np0(4) driver id 16
> >
> >     # bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite
> >     # bpftool net
> >     xdp:
> >         enp6s0np0(4) driver id 20
> >
> >     # bpftool net detach xdpdrv dev enp6s0np0
> >     # bpftool net
> >     xdp:
> >
> >
> > While this patch only contains support for XDP, through `net
> > attach/detach`, bpftool can further support other prog attach types.
> >
> > XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.
> >
> > ---
> > Changes in v5:
> >   - fix wrong error message, from errno to err with do_attach/detach
>
> The inconsistency in libbpf's error reporting is generally troubling,
> but a problem of this set, so:
>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> In the future please keep review tags if you have only made minor
> changes to the code.

Thank you for the review.
Sorry to bother you. I'll keep that in mind.

Thanks!
