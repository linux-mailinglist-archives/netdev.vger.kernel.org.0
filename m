Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2E3C713E
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhGMNfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbhGMNfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:35:42 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B0C0613DD;
        Tue, 13 Jul 2021 06:32:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a13so30478805wrf.10;
        Tue, 13 Jul 2021 06:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pI0cbCYu+L65LMy8pKJADG6rkLokSzcNjTpiGRxQp6k=;
        b=tzviYNhsTAOgc2k4Tair+DBq/t1cmo1dLBHrPo0PW+saTfiEvydWb0j1O24Sndv9/R
         leZ9yBtCnOJTAVSyzig0tskpCZKjiGg1v+q2Uwm7cylyrZ/4Sn6HD6yesz4C+koR4fMo
         2LdU4YrhXqSsU9mOASz5Wg2wnQLYSJs0A2zRvkgWqIIeOwlzcJqzgyri5ZFcoThvE2vp
         ECoIlOIbC1naxFkOkcF+Re80GLhKCkzEcNn32sgzCOcVUgyblMhNWvQBhF/zOkzEktCH
         4w3iRzTq7qRr9EnGIQyK1i6BKUNp5msOX67JBzKTdEldDQjPN1z4xaXUoEa9LiHg1XLu
         WpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pI0cbCYu+L65LMy8pKJADG6rkLokSzcNjTpiGRxQp6k=;
        b=TgkY3bbZrzuhId5KgVPHJLDNG+FztrpSm38UiLh/pYZ+34BleCq1vpPpe68HVszSyc
         RXl0g+Ekv5obHf23oxp08nfWk3+rbMh+ZjdC0EBo0rT4/tmZQWSwlRLkm4s6hrrzyB7t
         HW7i0nUSR3eOW1AFDCR1B/o7Sc4HtNGQbFLl6mbsobhv/zUpp2Ohcyy6+Mb1oQ4warBv
         i1D9AilT9PprVXWvvENq8KcJRo7GGDb2t9h4fSasIWOpSu1euCDAf23EIaDD7b2qPWsR
         mHrmYoi/Pqt60dmuJ/w6aWInIs3pmUwrkHtC1xjI68IuIlotusUqxbYwdzT0gHwK+CZO
         Af1w==
X-Gm-Message-State: AOAM530QEx8OuQCjnddAE96QWhq6ZX6etxhiVHJv8TNHAzlk5N8OpXpL
        5dF4HV4KS4LmZej6+NbleyLQbA+tZKvwnWCbi1w=
X-Google-Smtp-Source: ABdhPJxhCWRtbJ84J+zskZZNBBOaoz+1AY5nwuladFjDzzth+/dJ0F1O+mOOZVMk765mKL+AoYCJ93FyUD9euxl6NCg=
X-Received: by 2002:a5d:46c8:: with SMTP id g8mr5713496wrs.341.1626183169799;
 Tue, 13 Jul 2021 06:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210712134430.19372-1-yuehaibing@huawei.com>
In-Reply-To: <20210712134430.19372-1-yuehaibing@huawei.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 13 Jul 2021 09:32:38 -0400
Message-ID: <CAB_54W62WZCcPintGnu-kqzCmgAH7EsJxP9oaeD2NVZ03e_2Wg@mail.gmail.com>
Subject: Re: [PATCH] nl802154: Fix type check in nl802154_new_interface()
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 12 Jul 2021 at 09:49, YueHaibing <yuehaibing@huawei.com> wrote:
>
> We got this UBSAN warning:
>
> UBSAN: shift-out-of-bounds in net/ieee802154/nl802154.c:920:44
> shift exponent -1 is negative
> CPU: 3 PID: 8258 Comm: repro Not tainted 5.13.0+ #222
> Call Trace:
>  dump_stack_lvl+0x8d/0xcf
>  ubsan_epilogue+0xa/0x4e
>  __ubsan_handle_shift_out_of_bounds+0x161/0x182
>  nl802154_new_interface+0x3bf/0x3d0
>  genl_family_rcv_msg_doit.isra.15+0x12d/0x170
>  genl_rcv_msg+0x11a/0x240
>  netlink_rcv_skb+0x69/0x160
>  genl_rcv+0x24/0x40
>
> NL802154_IFTYPE_UNSPEC is -1, so enum nl802154_iftype type now
> is a signed integer, which is assigned by nla_get_u32 in
> nl802154_new_interface(), this may cause type is negative and trigger
> this warning.

I think this is not the right fix, the fix is to change the UAPI that
NL802154_IFTYPE_UNSPEC fits into the netlink range of U32. I will
prepare a fix for that, it should still be backwards compatible.

- Alex
