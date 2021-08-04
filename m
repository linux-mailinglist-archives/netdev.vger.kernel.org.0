Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB43E02E1
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhHDOOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbhHDOOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:14:21 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95765C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 07:14:07 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i9so1791423ilk.9
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6E78/6zLDHtWRwajFV5K+kCnVIVVes2MqNHejOQaS6E=;
        b=vhAPM98ttnDbUN4JAbm0oJHOwVuyzxx1A3gOH5ff9H+jkXHwXrh98SfBcCaCrEdXH2
         htkVLFQJctJNT86mLuAlVwF2pSypVr7j5GVJi7UdTdfNVM9LRK4riLcQEzvk6IsiAxeO
         TPDDQJ0GW4LhBu9bix1JjBdiMvHfRujOg5EsLWfNXAiuHNjei3JkNC3GVeY7GE5svhsR
         dICREVX9pTY4wrdbx+noHQlbci9Fk8DE25D+RGniZwRLo2pz+zqVNZ5StlqOY6GJ78yH
         TQwlL7+reOx2rucQq3DcsR2OT4VcCcvfWt9K4B9I+Bvpl9zjPZ7JgK3lGMzibwsJV8GT
         JGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6E78/6zLDHtWRwajFV5K+kCnVIVVes2MqNHejOQaS6E=;
        b=nF20RBU0dRON+o5mPVRsnznw9rzAbHOJeGqtdn50JOk/U+IWD5Z2geUkIEZXo/Q5yZ
         ydV/wV3SNwwiHY2ST4rT8AlFVkfYG10c1Jy0lEytpXHNxi5PgpapYlgoNRFtWLzT0JzO
         TpkoJtWOiuL2H1VENPNyApW0B7dVUs7SoGarlAf6QolYyzt89O6Y1kTD3wDUU4zY+K6P
         /8MEaSQSnocuMdlc2FTk5faRV+50cQ094DTunrTjNWNxdzSA7DTrta2+Ekxq7lo/EXYh
         MSX5PGqR0m3RvyNTO/TUbYqGrpofjTgpu87nskVA8WpWZTEOJEG0geM7X48Ab7263hV0
         jGMA==
X-Gm-Message-State: AOAM533M3a9EGTSVqcpx5vUdIhLngvvTS2WbxYcQ+KV7Lpl00nmeJSw8
        WvW3+pEmf4E0qSilesaoYnfm9XSqPD5jvYXOIBQ=
X-Google-Smtp-Source: ABdhPJzI07cnNLAaxl2fP6+LCl/V6mxvF+ndNz0UwEqi0SZof6epBx37dsf8PW4pOi/lXNC8iZe7Ls1qtbBBa7OxdhE=
X-Received: by 2002:a05:6e02:2190:: with SMTP id j16mr823136ila.144.1628086447042;
 Wed, 04 Aug 2021 07:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-3-borisp@nvidia.com>
 <YPlzHTnoxDinpOsP@infradead.org> <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
 <20210723050302.GA30841@lst.de> <YPpRziMHmeatfAw2@zeniv-ca.linux.org.uk>
In-Reply-To: <YPpRziMHmeatfAw2@zeniv-ca.linux.org.uk>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 4 Aug 2021 17:13:55 +0300
Message-ID: <CAJ3xEMid0sWkCf4CPK5Aotu=+U4=vtDrdJANqn+CnWd7HTb-vg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
To:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 8:30 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jul 23, 2021 at 07:03:02AM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 22, 2021 at 11:23:38PM +0300, Boris Pismenny wrote:

>>> This routine, like other changes in this file, replicates the logic in
>>> memcpy_to_page. The only difference is that "ddp" avoids copies when the
>>> copy source and destinations buffers are one and the same.

>> Now why can't we just make that change to the generic routine?

> Doable... replace memcpy(base, addr + off, len) with
>         base != addr + off && memcpy(base, addr + off, len)
> in _copy_to_iter() and be done with that...

Guys,

AFAIR we did the adding ddp_ prefix exercise to the copy functions call chain

ddp_hash_and_copy_to_iter
-> ddp_copy_to_iter
-> _ddp_copy_to_iter
-> ddp_memcpy_to_page

to address feedback given on earlier versions of the series. So let's
decide please.. are we all set to remove the ddp_ prefixed calls and just
plant the new check (plus a nice comment!) as Al suggested?

re the comments given on ddp_memcpy_to_page, upstream move
to just call memcpy, so we need not have it anyway, will be fixed in v6
if we remain with ddp_ call chain or becomes irrelevant if we drop it.
