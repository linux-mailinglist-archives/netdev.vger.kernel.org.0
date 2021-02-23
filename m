Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44F32261A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBWHBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBWHBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 02:01:12 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CD3C061574;
        Mon, 22 Feb 2021 23:00:32 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id h8so15253626qkk.6;
        Mon, 22 Feb 2021 23:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNyYQ8eKu7s3unoa5k0L4+5GZX6mT0/IxA4vZLT0/Zo=;
        b=H4q4TpqWOCpu63/9dvqHZrohhMKxiVEdRdkuNZNzYFbP6fn9CODQheXaKjP/Bu+/PA
         rZ+CjrpdQYUGvpqLkuXvkHpm37B6p9uA0wcSqFTDYtjriO+Sog+tuXQJFz28/C0MXuQT
         u4MybGZaCaoHQRsC3aqVqNIviVexwzjI7iob3z1cyIVMuAs4qdTmN9h1E/ojeJtBK30r
         6R/i3/GTyJygJ5JaysRVLGu1xji103HXq0ZehL3pu6AQA0pne9vDg+coU/706LZ0pt2B
         M4apxfBvHltG552YeuBpah7Wi3sLHWmBpOc1eYwSBglQQQJwQeNAhCDObVBx6IifJF+O
         JCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNyYQ8eKu7s3unoa5k0L4+5GZX6mT0/IxA4vZLT0/Zo=;
        b=og/t1WeU2F4G4ddNU/DjsXi8IVZMJriqFjYX2Z9ZkLK9ffPaj3cQIVhvgcGJwLQjr3
         tpv9MIerBGxo2PwnoBkBTn3pPMMu/7/77pcUpx8mH8r7ozrD6f8kcSzmA8ab28rZLa9+
         LP0ZhfEy3LsTOa+C5c+lWBrSwD5dsMnnjXTjSQpV7WdDl4pgYS81AGbGfPUc4wh/82e9
         y4uLHmordw6AujZ9Otz5DYgSJj7mCHU/zp41CBgLxvTRRZfQsqX66g87GOtv7bxnOMmu
         Deue3fqt1DpkkJ3IfsytZkK2riMFZsnow2pkMtjNOYj0I2/8xhrGYCFENv4tbGdiapXX
         rWaA==
X-Gm-Message-State: AOAM533Lsf5NkvCwNhXU+P0X8LJ/PTjvtFG7twEcjROt82l1RktnbYsV
        yK/oePLt7QkVy9Buzyyaq85aFkAeECadgHcTqD0=
X-Google-Smtp-Source: ABdhPJysrZ1xtUjw4q39GDtmpF6kYZ0WIuNINrL/UHXyaCB9jveusaEMa70DsNjWS11IzSnQOiRbfz9L9iE7nmWxr40=
X-Received: by 2002:a37:2cc1:: with SMTP id s184mr5551781qkh.304.1614063631291;
 Mon, 22 Feb 2021 23:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20210222031526.3834-1-yejune.deng@gmail.com> <0143f961-7530-3ae9-27f2-f076ea951975@gmail.com>
 <8de8cee8-55d3-5748-d17e-08dba3cf778d@gmail.com>
In-Reply-To: <8de8cee8-55d3-5748-d17e-08dba3cf778d@gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Tue, 23 Feb 2021 15:00:17 +0800
Message-ID: <CABWKuGW4aEinJx34q-dBEHjyKraKvpY5xterZeyLX-hp5zU6mA@mail.gmail.com>
Subject: Re: [PATCH] arp: Remove the arp_hh_ops structure
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the clarification.

On Tue, Feb 23, 2021 at 12:07 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/22/21 1:37 AM, Eric Dumazet wrote:
> >
> >
> > On 2/22/21 4:15 AM, Yejune Deng wrote:
> >> The arp_hh_ops structure is similar to the arp_generic_ops structure.
> >> but the latter is more general,so remove the arp_hh_ops structure.
> >>
> >> Fix when took out the neigh->ops assignment:
> >> 8.973653] #PF: supervisor read access in kernel mode
> >> [    8.975027] #PF: error_code(0x0000) - not-present page
> >> [    8.976310] PGD 0 P4D 0
> >> [    8.977036] Oops: 0000 [#1] SMP PTI
> >> [    8.977973] CPU: 1 PID: 210 Comm: sd-resolve Not tainted 5.11.0-rc7-02046-g4591591ab715 #1
> >> [    8.979998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> >> [    8.981996] RIP: 0010:neigh_probe (kbuild/src/consumer/net/core/neighbour.c:1009)
> >>
> >
> > I have a hard time understanding this patch submission.
> >
> > This seems a mix of a net-next and net material ?
>
> It is net-next at best.
>
> >
> >
> >
> >> Reported-by: kernel test robot <oliver.sang@intel.com>
> >
> > If this is a bug fix, we want a Fixes: tag
> >
> > This will really help us. Please don't let us guess what is going on.
> >
>
> This patch is a v2. v1 was clearly wrong and not tested; I responded as
> such 12 hours before the robot test.
