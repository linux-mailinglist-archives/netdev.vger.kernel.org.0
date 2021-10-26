Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19C543BB5B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhJZUGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhJZUGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:06:43 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07120C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:04:18 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a6so468039ybq.9
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eatsSJ90+7wtVivj0BA+XY9T/Yqtf/IIShhkQpS1u2U=;
        b=Ol+Xd7xfdmTF0nEr1WSsZg01qEplLaHwGMrNCTy7RvwubZbsuSVjHmoemXCSVTPrkm
         1Sil+Lopr26zO8CY+VtAbf/VM4w4p3S94KkfZQNxDOMZMT1PkErrNlNiqMtNNzvuoPSB
         rM7YHnaePQTP10yXowUZ7R96oiU834ZB0XXuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eatsSJ90+7wtVivj0BA+XY9T/Yqtf/IIShhkQpS1u2U=;
        b=t5WVbXxeYl0EitNvencdqP4VabzlpDoupGRdXCmRCyevs6SJplL55e0/8zBNY2Fndd
         UIJNSjgQU+wArexpiXF+vCq+yCvjMXV78eUMghcYpptmiFcpmWOhV3SqEjjSjZUwG6B/
         xki1HST392/3TMpKpmHC4AhhtwSRS1j866Jlfi6R7Rp8qrPmrxCxJmy6r+ztgTN0Q4jU
         xxtVtXLKQgS2SXVbHQ7lPRZQjjqy5xupFjVQk+LBPWRtxg3Jla6z04VygKYqqwgHnCSu
         0uIEu+FIbjQrmFaYoa2eDLIzgnvxnazEfRiDIygSxdCHWDpq60orOohBLm0dgSjYQhsC
         WeNA==
X-Gm-Message-State: AOAM531Gr7R58FtU2LB28cPmMNHGRKJZfBxz1POWKCPhkM+2jlFk8R3O
        0ZCg+/xumkpFAfbJ27Z0yYemrkbwEN1qu/Ophiw4TA==
X-Google-Smtp-Source: ABdhPJySCgAB2rXtsAgCv+0F76mx/WkeJEP1ldlyRor4O6FWWVGSLQEiGo0m2JJHaTFHkNUpQmQ7VSOwOOr7u3YbrP8=
X-Received: by 2002:a25:6705:: with SMTP id b5mr26165199ybc.116.1635278657910;
 Tue, 26 Oct 2021 13:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder> <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal> <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
 <YXhVd16heaHCegL1@unreal>
In-Reply-To: <YXhVd16heaHCegL1@unreal>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 26 Oct 2021 13:03:41 -0700
Message-ID: <CAKOOJTzrQYz4FTDU_d_R0RLA4u6pfK9=+=E_uKMr4VCNbmF_kA@mail.gmail.com>
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

On Tue, Oct 26, 2021 at 12:22 PM Leon Romanovsky <leon@kernel.org> wrote:

> At least in mlx5 case, reload_enable() was before register_netdev().
> It stayed like this after swapping it with devlink_register().

What am I missing here?

err = mlx5_init_one(dev);
if (err) {
       mlx5_core_err(dev, "mlx5_init_one failed with error code %d\n", err);
       goto err_init_one;
}

err = mlx5_crdump_enable(dev);
if (err)
        dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code
%d\n", err);

pci_save_state(pdev);
devlink_register(devlink);

Doesn't mlx5_init_one() ultimately result in the netdev being
presented to user space, even if it is via aux bus?

> No, it is not requirement, but my suggestion. You need to be aware that
> after call to devlink_register(), the device will be fully open for devlink
> netlink access. So it is strongly advised to put devlink_register to be the
> last command in PCI initialization sequence.

Right, that's the problem. Once we register the netdev, we're in a
race with user space, which may expect to be able to call devlink
before we get to devlink_register().

> You obviously need to fix your code. Upstream version of bnxt driver
> doesn't have reload_* support, so all this regression blaming it not
> relevant here.

Right, our timing is unfortunate and that's on us. It's still not
clear to me how to actually fix the devlink reload code without the
benefit of something similar to the reload enable API.

> In upstream code, devlink_register() doesn't accept ops like it was
> before and position of that call does only one thing - opens devlink
> netlink access. All kernel devlink APIs continue to be accessible even
> before devlink_register.

This isn't about kernel API. This is precisely about existing user
space that expects devlink to work immediately after the netdev
appears.

> It looks like your failure is in backport code.

Our out-of-tree driver isn't the issue here. I'm talking about the
proposed upstream code. The issue is what to do in order to get
something workable upstream for devlink reload. We can't move
devlink_register() later, that will cause a regression. What do you
suggest instead?

Regards,
Edwin Peer
