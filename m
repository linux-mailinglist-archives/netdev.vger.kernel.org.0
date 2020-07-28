Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CDA230797
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgG1KYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgG1KYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:24:20 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664B0C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 03:24:20 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q16so8150591ybk.6
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 03:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ce1h1S6nNSz5Lf6tlgTDSJplWZsH3BbMkFogwd1wAsQ=;
        b=Dn8bdOlfKbu/XzU53bNHF/cNyArQ/jrc2BhP2fldnSD0Nfe0E1KQ8Ox5DLQ16ZIVoD
         TNmhorkBK9dySJ5exKJv0iCk6yYg7Cd0bjlXEMqK4qwTMVzeMtJZU/HDtj4H+P9RSJ4o
         6CMMbwS6yWNeNhh9pRM9rLyB1oWwPyGzU04wJCig64zIf6CBtPpRZlnGJ1zqK4CH6UHL
         IZYELXMZv+tTgJujEcT0LBiDPQRr9cNlbf8oJLJzXNfPRrYrNJqHlXZ1CG3hnC2l3k51
         xqeZXQeHck51Zb3lhRmZrRHj27icnnPJEIVibUtNvj+AZsOaP450vPJoGHqORSQDpOpM
         X8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ce1h1S6nNSz5Lf6tlgTDSJplWZsH3BbMkFogwd1wAsQ=;
        b=rUhHXEMIocWHdH6NsAFPbJ0qvDAALwmonhy90JBZdVmcIvrk4czUaPlCH080SyIM2N
         gFuJsAXVcStA8SYzjZmyxzuYXXaMbH24KsNDzE0Ikhs9pJPPg1zfn+HbCJEwnl/ZH8uo
         wP+ixcWYyzFNuF+eqCUQ/THBpg/i5bY+DUSKi9+lnCH4c8vDY1L1SexV1+IS66LAZ3ej
         8ar6mGdmeJby5nT4fW7DXB1jo+tZcLHQ2FfJ3NJFtLdXMIvnwvRyS+uYReQM2xaw0lkT
         gljgCc8B4Yaa5Ys2GfCBmUCda1L+IRfwbC9eRrwK3uNh2Wa4fOFuYLqRlsgW+06hOjy8
         XrNw==
X-Gm-Message-State: AOAM533KThM0/e72Ht6ej4kgN7LDQSNAZ/0AaGWTRu4YGtC/65z9pjIA
        7MEP/vOjEtixIwzMscJoH+0vTZ3w5XKPpaLokWw=
X-Google-Smtp-Source: ABdhPJw0EbgVMHZxu80uAj1gvMWxqGeQnsHAMCVJWEH2GVrqXG1xmSJ0qmiGvsZWQRVHGVZpdNqUsXekt26ASBqX1KI=
X-Received: by 2002:a25:aaf3:: with SMTP id t106mr15262468ybi.56.1595931859161;
 Tue, 28 Jul 2020 03:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200728091035.112067-1-saeedm@mellanox.com> <20200728091035.112067-12-saeedm@mellanox.com>
In-Reply-To: <20200728091035.112067-12-saeedm@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 28 Jul 2020 13:24:07 +0300
Message-ID: <CAJ3xEMg+wW2FFrC3rRQyQbcSJKFf5Lr9EvNYuRQ0JZEDAztw7g@mail.gmail.com>
Subject: Re: [net 11/12] net/mlx5e: Modify uplink state on interface up/down
To:     Ron Diskin <rondi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:16 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> From: Ron Diskin <rondi@mellanox.com>
>
> When setting the PF interface up/down, notify the firmware to update
> uplink state via MODIFY_VPORT_STATE

How this relates to e-switching? the patch touches the e-switch code
but I don't see mentioning of that in the change-log..

> This behavior will prevent sending traffic out on uplink port when PF is
> down, such as sending traffic from a VF interface which is still up.
> Currently when calling mlx5e_open/close(), the driver only sends PAOS
> command to notify the firmware to set the physical port state to
> up/down, however, it is not sufficient. When VF is in "auto" state, it

"auto" is nasty concept that applies only to legacy mode. However, the patch
touches the switchdev mode (representors) code, please explain...

> follows the uplink state, which was not updated on mlx5e_open/close()
> before this patch.
>
> Fixes: 63bfd399de55 ("net/mlx5e: Send PAOS command on interface up/down")
> Signed-off-by: Ron Diskin <rondi@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
