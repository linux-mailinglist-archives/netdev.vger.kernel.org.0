Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9F36F0AC
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhD2TrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhD2TrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:47:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB25C06138C
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 12:46:12 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n4-20020a05600c4f84b029013151278decso418669wmq.4
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L2US6k9/NRuXpfqdPLSMoPdn96oSiBAwfE9XCCQrD7k=;
        b=HAj7M5FCReW/JYKJisw7Xfoq87HXo9eRrIXNeYojN3uOffmY/cXJ/7M+QmS+oAKa6T
         n4YbOU20b9W7k5M8QiD3NpT4riIpBXJwg/w+IxZBDhtoQOR7KvunHwwqaX/q9aIIOEuo
         azK43hOMRkyuMLGfBZXDqi+DqqhU25fYZbTayKmir/uK5+azvIK6ckbytcLHCo7INuzD
         TPxeFm47YuH7vFVa8SSy2YPawLIoVsCemtLzzsuSwW3UaEWFCzto5UhEmWDAGd7imePG
         RPpffIg+Nv+QxydN+W/1DiI0gSrgDDaej84pYFSnjvWFkF2bHTVIJc9ohn8Dap4fx8PA
         OSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L2US6k9/NRuXpfqdPLSMoPdn96oSiBAwfE9XCCQrD7k=;
        b=D7P4nLYhdDc/QrbPPlI7nh6iuOYtMrDtgWGC6fmp3YNxpbu4MVRYtyGsf/7d84zCGT
         JLvHU6ekIRe4syi+9oSpKadHouxhLxBfCgY7/DmTxpO1KObULoYjO5FdSLhJRRup3DFP
         nPyr/XGCdiFQP8C1UHdSXB/zVVA7va0E8ZtR+r94tr1ziaGd5w5NalhbS5tSn29r12EU
         sZC9VVdWCY0sE/qucQ8yFYW0JjoRu2X+wZcq/0vuGZCBzvxQAKAMjxfVA3H4AsG51HyT
         lz9qC2KvdcclMD4lmG5s6tujIihA7MRK9fqmGZ9Bv4MfKDDkK1iUgEzS248MrhAH6XzH
         dm4Q==
X-Gm-Message-State: AOAM533Yt2rlTEmUG4ErmclswUyrvwVupeaNhApzlSclTv9xiRYENnBJ
        sOf8g4iQb9WNJlUQEHhvmRh0gvQh/gPgB1r3TLBUDw==
X-Google-Smtp-Source: ABdhPJyBvetnrSH0KqinD/UDdtF/rL9bO+6PUb/wKmNRnjaNQBOufvQp3QxtyxEg84u65l4XXAJED7jVrl273C69PdE=
X-Received: by 2002:a1c:7903:: with SMTP id l3mr12833550wme.0.1619725567963;
 Thu, 29 Apr 2021 12:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAAMKmof+Y+qrro7Ohd9FSw1bf+-tLMPzaTba-tVniAMY0zwTOQ@mail.gmail.com>
 <b0a534b3-9bdf-868e-1f28-8e32d31013a2@gmail.com> <CAAMKmodhSsckMxH9jLKKwXN_B76RoLmDttbq5X9apE-eCo0hag@mail.gmail.com>
 <1cde5a72-033e-05e7-be58-b1b2ef95c80f@gmail.com>
In-Reply-To: <1cde5a72-033e-05e7-be58-b1b2ef95c80f@gmail.com>
From:   Erik Flodin <erik@flodin.me>
Date:   Thu, 29 Apr 2021 21:45:56 +0200
Message-ID: <CAAMKmoe8rUuoxFK2gKZL4um79gmtn-__-1ZDWuBgGTqfqPjZdw@mail.gmail.com>
Subject: Re: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        Stefan Rompf <stefan@loplof.de>,
        "David S. Miller" <davem@davemloft.net>,
        John Dykstra <john.dykstra1@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

Have there been any updates on this one?

// Erik

On Wed, 14 Apr 2021 at 21:56, Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
>
> [CC += netdev]
>
> Hi Erik,
>
> On 4/14/21 8:52 PM, Erik Flodin wrote:
> > Hi,
> >
> > On Fri, 19 Mar 2021 at 20:53, Alejandro Colomar (man-pages)
> > <alx.manpages@gmail.com> wrote:
> >> On 3/17/21 3:12 PM, Erik Flodin wrote:
> >>> The documentation for SIOCGIFFLAGS/SIOCSIFFLAGS in netdevice.7 lists
> >>> IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, but those can't be set in
> >>> ifr_flags as it is only a short and the flags start at 1<<16.
> >>>
> >>> See also https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c
> >>>
> >>
> >> I don't know what's the history of that.
> >
> > Judging from commit message in the commit linked above it was added by
> > mistake. As noted the flags are accessible via netlink, just not via
> > SIOCGIFFLAGS.
> >
> > // Erik
> >
>
> I should have CCd netdev@ before.  Thanks for the update.  Let's see if
> anyone there can comment.
>
> Thanks,
>
> Alex
>
>
> --
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/
