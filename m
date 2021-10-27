Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01F943C578
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbhJ0Its (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbhJ0Itr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:49:47 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE9BC061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:47:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id u84so853807yba.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpwmGL8q732gZ5k2cD5aoLwnIVUmOGw5/VzkkTYxkIg=;
        b=JMCMuYh6Yuaf/upleikyxO5k9kDJMxBSqPkmgFsHj8CoV2zJ043vXEQ7VGHTkX7GoH
         yk75qwH1hs9rZR3qEQz9oZt3a7ExG/ja2uAvuoKsAQSRzUdAlIKHiRZr+AFRg/15WqNl
         W5kBihpfnHI/ofIDS6KQ9a8RJSjtU+du8IToQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpwmGL8q732gZ5k2cD5aoLwnIVUmOGw5/VzkkTYxkIg=;
        b=JvPuWskSZz+dGgZmcMWowxrrVxDJJAc6JhTzI8W2b/cAe0nAqVhxpgcz1AO18PMHaB
         gFNDyywmkvQROXxnw/KISMIVMhqoVSRvESoukPQ1i0dSgle6nqYWMSyl4WkAmtM0RZyG
         EqLZXoHnW0k/GbkxOIio5tBxcdBqm43bfeTmFDbte3iliHbcz71JijkjeSXOoL9JltCH
         BVSPZtZn4K544htRvoFU4SWbEeR8/a7RlVtknTfBxe0f6TQVqkR+jQlPIVWOyCYYbHX6
         k+ek7TnsZxmRK48P0Q2VM0xeRJHJcsFptSdxcZOlt8bnbr7sS2VbzJ6B6mVG+cXHSs24
         5CMA==
X-Gm-Message-State: AOAM532GVJReukYZpzWPyeo4vOMv0qQbRrRdrTtu0JmD+4kAOtG0lyxi
        /sFr65C/C3zXGdz7Uo29VQxD9OdIIx5YLTY0rEezkg==
X-Google-Smtp-Source: ABdhPJwE5xNCo48x/75YvJ0mwgD/O6cRnzR4h6s9Ry1FQ7g9JdulrWwb2E4aaVChFivA8OAT1p7QIoPSpIIBg0bYjk4=
X-Received: by 2002:a05:6902:724:: with SMTP id l4mr20420002ybt.193.1635324440879;
 Wed, 27 Oct 2021 01:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder> <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal> <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
 <YXhVd16heaHCegL1@unreal> <CAKOOJTzrQYz4FTDU_d_R0RLA4u6pfK9=+=E_uKMr4VCNbmF_kA@mail.gmail.com>
 <YXj1J/Z8HYvBWC6Y@unreal>
In-Reply-To: <YXj1J/Z8HYvBWC6Y@unreal>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 27 Oct 2021 01:46:44 -0700
Message-ID: <CAKOOJTyrUUydu9aNJSB4S_5dfqjkc6Y-14up4-V+aNcQ7TWVdQ@mail.gmail.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink traps
 on probe/remove device
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 11:43 PM Leon Romanovsky <leon@kernel.org> wrote:

> In our case, the eth driver is part of mlx5_core module, so at the
> device creation phase that module is already loaded and driver/core
> will try to autoprobe it.

> However, the last step is not always performed and controlled by the
> userspace. Users can disable driver autoprobe and bind manually. This
> is pretty standard practice in the SR-IOV or VFIO modes.

While you say the netdev will not necessarily be bound, that still
sounds like the netdev will indeed be presented to user space before
devlink_register() when it is auto-probed?

> This is why devlink has monitor mode where you can see devlink device
> addition and removal. It is user space job to check that device is
> ready.

Isn't it more a question of what existing user space _does_ rather
than what user space _should_ do?

> > This isn't about kernel API. This is precisely about existing user
> > space that expects devlink to work immediately after the netdev
> > appears.
>
> Can you please share open source project that has such assumption?

I'm no python expert, but it looks like
https://github.com/openstack-charmers/mlnx-switchdev-mode/ might.
We've certainly had implicit user space assumptions trip over
registration order before, hence the change we made in January last
year to move devlink registration earlier. Granted, upon deeper
analysis, that specific case pertained to phys port name via sysfs,
which technically only needs port attrs via ndo_get_devlink_port, not
devlink_register(). That said, I'm certainly not confident that there
are no other existing users that might expect to be able to invoke
devlink in ifup scripts.

> > What do you suggest instead?
>
> Fix your test respect devlink notifications and don't ignore them.

That's not very helpful. The test case does what the user in the field
did to break it. We can't assume users have always been using our APIs
the way we intended.

Regards,
Edwin Peer
