Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A043A813
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 01:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhJYXWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 19:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhJYXWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 19:22:07 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D2EC061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:19:44 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id v200so29980942ybe.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 16:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/m+rGDyPgmkHNSDFPzk2eBpp1e1IMILcUX8qA35d4c=;
        b=ZQ2OHZJWoDMsFYhDGZXV/ORisGPqxd+Bine/TFp7oPJtkJQ7DtE0bbuZ0BO8fNc/sF
         fdXcgyvqS23e/mOtOMb+VNFBwU9qEgoLlqID5zfZgidGUhTYQIQk0Mf1RZzTiTQO+HqU
         Ye6ZJ4j4Vwg/WsyREgDOqShiYwfifOfxhhb+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/m+rGDyPgmkHNSDFPzk2eBpp1e1IMILcUX8qA35d4c=;
        b=jyh5pMMnm7FOanH8lXWUVNkcN85jxC2CGyEGfOvUB/9ZD8k/775SLdA/LwWAu+baHi
         ORXIH5R6BAKq3p1l1D58IptqZbO80EQ48Yy00EBlpjbgBItKFH5hYs0Xh5o5++S4eCLS
         8rjCI+1Zo3AGREPCDltiEBlAEDN/AKtgQRUL2Ne5tPAld9UePSK2MoZGUro8nbEWpnrr
         +z4islPxWl91EZL++XbJwP9+wMx2pJ0GFSTAX7uhesb0ZYVZu4g29slfht1yVQI+my6j
         WkpGCDEPuP9PmrJdVJwKIBRTQJVZsskOs77JEdH2BHGfnqkWFMXgyMPcqw9WGeFUNnd4
         XHdQ==
X-Gm-Message-State: AOAM532ku0t2nFJvMY2CtV98xbuAYTmYx6R0V7jG/M+xiW757rX0QK9e
        mXV1lx2obXwMluncLW53gLT1HsLMBm5ORSRvUNVB0Q==
X-Google-Smtp-Source: ABdhPJwQSDBIopxs6IO5I0vryH6ivhJw6gNvrARjSQOfppAImQtW0pAnwoQptiqF2lvTM5ezwXXHIG/POjMYu8hRwpw=
X-Received: by 2002:a25:4054:: with SMTP id n81mr21034759yba.85.1635203983180;
 Mon, 25 Oct 2021 16:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
In-Reply-To: <YXUhyLXsc2egWNKx@shredder>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 25 Oct 2021 16:19:07 -0700
Message-ID: <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink traps
 on probe/remove device
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
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

On Sun, Oct 24, 2021 at 3:35 PM Ido Schimmel <idosch@idosch.org> wrote:

> On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Align netdevsim to be like all other physical devices that register and
> > unregister devlink traps during their probe and removal respectively.
>
> No, this is incorrect. Out of the three drivers that support both reload
> and traps, both netdevsim and mlxsw unregister the traps during reload.
> Here is another report from syzkaller about mlxsw [1].
>
> Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> trap group notifications").

Could we also revert 82465bec3e97 ("devlink: Delete reload
enable/disable interface")? This interface is needed because bnxt_en
cannot reorder devlink last. If Leon had fully carried out the
re-ordering in our driver he would have introduced a udev
phys_port_name regression because of:

cda2cab0771 ("bnxt_en: Move devlink_register before registering netdev")

and:

ab178b058c4 ("bnxt: remove ndo_get_phys_port_name implementation")

I think this went unnoticed for bnxt_en, because Michael had not yet
posted our devlink reload patches, which presently rely on the reload
enable/disable API. Absent horrible kludges in reload down/up which
currently depends on the netdev, there doesn't appear to be a clean
way to resolve the circular dependency without the interlocks this API
provides.

I imagine other subtle regressions are lying in wait.

Regards,
Edwin Peer
