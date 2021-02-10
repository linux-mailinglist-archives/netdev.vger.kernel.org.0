Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA600317085
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhBJTpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhBJTpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:45:23 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7A6C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:44:43 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n14so3212216iog.3
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/DqmfLkxZx+xCDUq65b3U1VQF1+flY8LNt4TeHXR7M=;
        b=FOEYXnAtcqm/yvzGSFGDuIHaM+KTtPFJOwrpZ7yMOj9ZeF2idpL9qHKVNRjkpRX44o
         qeM/gZ4tqjjH7ft7Ybf5YyMwwjc4LlchoRZzPW0bHebPavQyXcca86RNtm7TpYH/qfUx
         KPMwiB1JKnnWV3lYIHp9+UUjH/PU+uqJspK5caeLRN4VbHzwjzSOsHdMHY5Db2qFu1BO
         vkRB5JwUwlPSZXrPoFyAVGcvJn3e0fZ7bC7m7eXri2hRMsVHjifrwQN+3MPx8x/wqFnv
         vanZnRCmp/GDkPyBlcaQldkZ032rO9Eds7Iatqioyvwtz2hXHKEOUICA7Kk08U0GaLWp
         gFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/DqmfLkxZx+xCDUq65b3U1VQF1+flY8LNt4TeHXR7M=;
        b=kkvtApC1SpV042yn1uJ29HcoLDsdcknLXJAsmRi+6DwiMHNbyHNmxbJds5bGsCPvhc
         fdeAF6QS80IWRAMvk+k/cvNxdZuQu80+it5pCv6pbrYpPayAvaDOKWVh1B0H1i2SEe1Z
         or1LawOfd07a8V/fQORD4FaJekhGRCVuphc1rTD2qtriWVFp01izVwlF9eWr1tz+6Mt3
         yYNwrkYwa2GMux5YpWM+OO64S9WzXl6ImbpCr5O5X3uLKs3QR78mZg0ZnPP75XSQQ0Kc
         e53gyX2J9zYWmIYarVV1pn2V/Sbjb6hVd61nfdOsOr2F1mYq7MQ7OafpAimNDnlALQ1T
         K7lw==
X-Gm-Message-State: AOAM531tbtw7/7gw/9tvR5IU2bjlgxAPVM6LKTz9w3N+m1WLXb0cwhaO
        Pn99OS2bqYVQBdtPiKjLcGmsIdol3TgfM3Ok2ds=
X-Google-Smtp-Source: ABdhPJy/l1p9PkhH+Bvkod4j9KnD6Z5WNf2ztyumugDHxm5vqoD6VuwZc9ruXuJrJIoIEGQUgYU1ep4zc+jQ6RuiQ7s=
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr4887712jaj.87.1612986282411;
 Wed, 10 Feb 2021 11:44:42 -0800 (PST)
MIME-Version: 1.0
References: <20210209103209.482770-1-razor@blackwall.org> <20210209103209.482770-4-razor@blackwall.org>
In-Reply-To: <20210209103209.482770-4-razor@blackwall.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Feb 2021 11:44:31 -0800
Message-ID: <CAKgT0UcZzdo2PBMW-hG6XAwjjFgJpYP8815KV_PQUKpx-8iXjw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] bonding: 3ad: Use a more verbose warning for
 unknown speeds
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Netdev <netdev@vger.kernel.org>, roopa@nvidia.com,
        idosch@nvidia.com, Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 2:42 AM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> From: Ido Schimmel <idosch@nvidia.com>
>
> The bond driver needs to be patched to support new ethtool speeds.
> Currently it emits a single warning [1] when it encounters an unknown
> speed. As evident by the two previous patches, this is not explicit
> enough. Instead, use WARN_ONCE() to get a more verbose warning [2].
>
> [1]
> bond10: (slave swp1): unknown ethtool speed (200000) for port 1 (set it to 0)
>
> [2]
> bond20: (slave swp2): unknown ethtool speed (400000) for port 1 (set it to 0)
> WARNING: CPU: 5 PID: 96 at drivers/net/bonding/bond_3ad.c:317 __get_link_speed.isra.0+0x110/0x120
> Modules linked in:
> CPU: 5 PID: 96 Comm: kworker/u16:5 Not tainted 5.11.0-rc6-custom-02818-g69a767ec7302 #3243
> Hardware name: Mellanox Technologies Ltd. MSN4700/VMOD0010, BIOS 5.11 01/06/2019
> Workqueue: bond20 bond_mii_monitor
> RIP: 0010:__get_link_speed.isra.0+0x110/0x120
> Code: 5b ff ff ff 52 4c 8b 4e 08 44 0f b7 c7 48 c7 c7 18 46 4a b8 48 8b 16 c6 05 d9 76 41 01 01 49 8b 31 89 44 24 04 e8 a2 8a 3f 00 <0f> 0b 8b 44 24 04 59 c3 0
> f 1f 84 00 00 00 00 00 48 85 ff 74 3b 53
> RSP: 0018:ffffb683c03afde0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff96bd3f2a9a38 RCX: 0000000000000000
> RDX: ffff96c06fd67560 RSI: ffff96c06fd57850 RDI: ffff96c06fd57850
> RBP: 0000000000000000 R08: ffffffffb8b49888 R09: 0000000000009ffb
> R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
> R13: ffff96bd3f2a9a38 R14: ffff96bd49c56400 R15: ffff96bd49c564f0
> FS:  0000000000000000(0000) GS:ffff96c06fd40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f327ad804b0 CR3: 0000000142ad5006 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ad_update_actor_keys+0x36/0xc0
>  bond_3ad_handle_link_change+0x5d/0xf0
>  bond_mii_monitor.cold+0x1c2/0x1e8
>  process_one_work+0x1c9/0x360
>  worker_thread+0x48/0x3c0
>  kthread+0x113/0x130
>  ret_from_fork+0x1f/0x30
>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

I'm not really sure making the warning consume more text is really
going to solve the problem. I was actually much happier with just the
first error as I don't need a stack trace. Just having the line is
enough information for me to search and find the cause for the issue.
Adding a backtrace is just overkill.

If we really think this is something that is important maybe we should
move this up to an error instead of a warning. For example why not
make this use pr_err_once, instead of pr_warn_once? It should make it
more likely to be highlighted in the system log.
