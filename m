Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015B643B83C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhJZRhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhJZRhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:37:40 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228EC061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:35:16 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o12so32825489ybk.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JdnY/fBFD3FOwUDjXbMPh8vlhFwvXax6wURvJ0dOGG8=;
        b=XZQg15YvmhU3/h4tVD1LA3EJNETBPC3hJ8CvqIZO2K08WyTBs+bwjj4pvP7x2Xic3k
         exzyywUY9eykdim9RaHXGjgNcQPr00jBYnFRpfG9dr6RxNu+Ow65FUcmxPtuDtw4mfnd
         zwrr7MkgjC69+JkWloMNW/ObTH+njzfT/Nbqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JdnY/fBFD3FOwUDjXbMPh8vlhFwvXax6wURvJ0dOGG8=;
        b=KQZDy3t4xjztyzmLlX+DDPO8ZPXvP4vkKT7ub7tf726l6UZGGgWvYBsO8loZ9RqXTJ
         cZh9LEBQmhiIheKRvrlc+AVNfkG9ULAPZNsrO7uH/QSaV/90X6HGmmHEgLaH6pPXvbvR
         dojmZoxHuVArf8wcaY/7GbR1CXawDwM5y5P92hmhbE212EeQ2jr7NAr2ikX2P+6U8Ccg
         62ptAtHlo2IjCa4fI9c5VPiC25BG5Bl1XHmz+R3SpuFwY0AS2C/78g1zM1RtjK6WVI84
         wO3y14FjSYRH/YlzaJo0668JVVDYSqbWKQi4aT9kepR1BplYJqAWJGQvDB+P8/wqyElf
         DQrw==
X-Gm-Message-State: AOAM533nhq3EqDNHo5jNrWCB3S3ZR6S91bM0W68/3C8MKfx28l3cNRpJ
        qgOTsRKEAJKMutxrjMf2sX8H+nlpkI3gTet7A0M7pg==
X-Google-Smtp-Source: ABdhPJyT9IMhMA1RkpQNM+h1QJDf702jzgffyD8KjZiBvtwu1fgVlS4UbpYb70ytUomc8VWHFlOK1zYQ/VUOyCpLq9U=
X-Received: by 2002:a25:6705:: with SMTP id b5mr25317945ybc.116.1635269715711;
 Tue, 26 Oct 2021 10:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder> <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal>
In-Reply-To: <YXeYjXx92wKdPe02@unreal>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 26 Oct 2021 10:34:39 -0700
Message-ID: <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
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

On Mon, Oct 25, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:

> > Could we also revert 82465bec3e97 ("devlink: Delete reload
> > enable/disable interface")?
>
> Absolutely not.

Although the following patch doesn't affect bnxt_en directly, I
believe the change that will ultimately cause regressions are the
patches of the form:

64ea2d0e7263 ("net/mlx5: Accept devlink user input after driver
initialization complete")

Removing the reload enable interface is merely the reason you're
moving devlink_register() later here, but it's the swapping of the
relative order of devlinqk_register() and register_netdev() which is
the problem.

Our proposed devlink reload depends on the netdev being registered.
This was previously gated by reload enable, but that is a secondary
issue. The real question is whether you now require devlink_register()
to go last in general? If so, that's a problem because we'll race with
user space. User visible regressions will definitely follow.

The bnxt_en driver was only saved from such regressions because you
did not carry out the same change there as you've done here.
Otherwise, you would have broken bnxt_en as a consequence. I'm
obviously not as familiar with mlx5, but I think you may have already
broken it. I imagine the only reason customers haven't complained
about this change yet is that few, if any, are running the net-next
code.

> In a nutshell, latest devlink_register() implementation is better
> implementation of previously existed "reload enable/disable" boolean.
>
> You don't need to reorder whole devlink logic, just put a call to
> devlink_register() in the place where you wanted to put your
> devlink_reload_enable().

We can't though, because of the two patches I pointed out previously.
Moving devlink_register() to the existing devlink_reload_enable()
location puts it after register_netdev(). That will cause a regression
with udev and phys port name. We already have the failing test case
and customer bug report for this. That is why devlink_register() was
moved earlier in bnxt_en. We can't now do the opposite and move it
later.

> You was supposed to update and retest your out-of-tree implementation
> of devlink reload before posting it to the ML. However, if you use
> devlink_*() API correctly, such dependency won't exist.

We dropped the ball there, absolutely, but the out-of-tree
implementation is only relevant to the extent that it is a testing
vehicle for our QA _before_ we post patches upstream. This API change
invalidates all of that testing work, which is regrettable, but not
the end of the world if your change is the right way to go (I don't
think it is).

I'm interested in the form that the _upstream_ implementation of our
devlink reload would need to take. I don't think we can move
devlink_register() later without introducing whole classes of user
space regressions. Thus, fixing our proposed devlink reload code in
the absence of devlink reload enable would entail implementing
precisely the kind of interlock that was previously provided by the
removed API, only internally. It doesn't seem right to remove a useful
shared API in favor of duplicative implementations in drivers to
accomplish the same goal.

> > I imagine other subtle regressions are lying in wait.
>
> Sorry, but we don't have crystal ball and can't guess what else is
> broken in your out-of-tree driver.

In addition to the udev phys port name regressions that we already
know about, it doesn't take a crystal ball to imagine user ifup
scripts that call into devlink. All sorts of things in user space kick
off in response to the presentation of the netdev. User enables
switchdev mode in ifup, that will break. User twiddles a devlink param
in ifup, that'll break too.

Regards,
Edwin Peer
