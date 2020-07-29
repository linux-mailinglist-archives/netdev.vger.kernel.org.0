Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92C1231964
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgG2GSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgG2GSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 02:18:02 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05627C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 23:18:02 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x9so11953955ybd.4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 23:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fRfLmqXm0tbP5GNK88YLMm+eE8sbYKF2zxcwDzt8ySo=;
        b=I/A5KgLXJD9HPuXzkTi9WClLJlXwBpqRQKh6ApYUyEysFupWBB8ifBZr+O1ub6/2TL
         ZZ9Yf2fa2NY33qBj3Ur8x3HGXrj/3OZdqRJzp3mAk0o04VXAryljS0vpuFx6qb36nBYV
         zTVXbrca2m6MRyz5MtSUB/zIbrOzaK6d4gCjv0vLtMIsDxQq8TERFEKbat1OtrHs39ze
         evLCcHMZtqau5Sp2t/TU1EhDDjGcoGuWPhtBMUucPQefgc9LH6vYfYNaAip4wdMAAdTL
         3AlGWiQkKcWxaruCSKw/34teNVTjg6ieXQKcFzEvwS+kAa+fT+wFLd1rTrsWEpatK6zZ
         mFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fRfLmqXm0tbP5GNK88YLMm+eE8sbYKF2zxcwDzt8ySo=;
        b=mRRGWxf9ONLXZHDIQeF7sdj0uDKn0dp0NthQCnpr9LvZJD64seofeG/p4SKKkZQUzY
         C28L+mqNAcMVhEev/Na717ohqVxXFZFBZuywjfv6e7a9ZvvKsYbiQOudwdBEO6Pe7vdN
         94k3iLluAvsxy4/e3o6krx6o7IVFuzboFPMOgf+5SN3ryqHBcXR6nN0xXjFszAoiBHiR
         cLFTL82zpnxIqh22g2SR19wTYEINdIWVEXgjoy8LXi7Z7OqDkhpyDZniFbkP7AXpk4VV
         9oqWfaWo0JYz8Qfj2bmuCSVZ0OOmtx0onaYlxG1P2YJYRVT7m4QYGGHdi+Gz647pzWMQ
         oW8Q==
X-Gm-Message-State: AOAM533rBZ3iYMV1/bE4s+LKk+gnXDW9Ya9Pi/qFRWeL3oW08B66V27N
        aKsXCl+xX11KPygZhlLWKECoGlrRL3di/KkkwsY=
X-Google-Smtp-Source: ABdhPJwF4P8gBbsJrAm6vdlqe752MZqlv3aSDknhJRaRkFtyO1fuZDhUAvnU/bA/fMNgmCz5VSYihqz3ZDgZPSms5Mo=
X-Received: by 2002:a25:3bc1:: with SMTP id i184mr37689420yba.97.1596003481073;
 Tue, 28 Jul 2020 23:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200728195935.155604-1-saeedm@mellanox.com> <20200728195935.155604-11-saeedm@mellanox.com>
In-Reply-To: <20200728195935.155604-11-saeedm@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 29 Jul 2020 09:17:49 +0300
Message-ID: <CAJ3xEMgJg5RQROKUjR3tGu+khu80ogtZY=8Q2sJkrej4MCZPAg@mail.gmail.com>
Subject: Re: [net V2 10/11] net/mlx5e: Modify uplink state on interface up/down
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Ron Diskin <rondi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:07 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> When setting the PF interface up/down, notify the firmware to update
> uplink state via MODIFY_VPORT_STATE, when E-Switch is enabled.
> This behavior will prevent sending traffic out on uplink port when PF is
> down, such as sending traffic from a VF interface which is still up.
> Currently when calling mlx5e_open/close(), the driver only sends PAOS
> command to notify the firmware to set the physical port state to
> up/down, however, it is not sufficient. When VF is in "auto" state, it
> follows the uplink state, which was not updated on mlx5e_open/close()
> before this patch.

> When switchdev mode is enabled and uplink representor is first enabled,
> set the uplink port state value back to its FW default "AUTO".

So this is not the legacy mode "auto" vf vport state but rather something else?

If this is the case what is the semantics of the firmware "auto" state and
how it related to the switchdev vport representors architecture/behaviour?


> Fixes: 63bfd399de55 ("net/mlx5e: Send PAOS command on interface up/down")
