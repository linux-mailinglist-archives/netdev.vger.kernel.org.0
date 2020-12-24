Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418342E27FF
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgLXP5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 10:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgLXP5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 10:57:38 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E8AC061573
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 07:56:58 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id w7so780067uap.13
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 07:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XRYO0lFUVOrah75uQXi2tgidobUUXCXbkVzNcCSUK7Y=;
        b=vD+85mxRjBfgH/Sr9fNWdZGEZkGCHFeLsjU3Ur+c3zJ5wpb8lGtmkFUlNYttDgBl3q
         pA+Xr1MSgCOJD31ItdxXMEyce5g0ByZJ9cV5+yoh1TlZ15r9KptXP5AmQAA5IDLtQhSo
         ufPxBCA+vBcRbjE/l97R4uobG1CxRofdyDygsn0r4YzTJg8fHwRFCRGXpRcV5HWb4UPy
         822ceXGoh7xsp9/ALp7vqguO5tHDyI9vzdm+X9EY4dOxT5LvNdfSw1BnYqGU9VZB5pot
         qJt/EEOUvT0cHl2EwwDJ6Hu7uMhSyi+zlsutqz9l1oa6vxvhfH+qb8i8zb7TkPf/dwEh
         7QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XRYO0lFUVOrah75uQXi2tgidobUUXCXbkVzNcCSUK7Y=;
        b=XZT/IdY4sMZOgVaw5eBx3Ejiiy2j9FV1Fov1RA9bn+B+8rBLjNdMRGyBjItqngZbwx
         O0Kz0dvZ5l1BZlK1JMMw84VSzMy2lEQ8E4jTy84yhQXLvlyht0FH3JBewf4oiPQ845LL
         Ie+VMN7aprJGi4FUCTldCo+UrtUgl4hjBlx0tYbZ3206aN0ETH6edaUuARBAuCcMOPEM
         nSrK0Pto9iLCipAZ/ZN2nnymIL5qgbRhf304KZodxeMWf8fDQO5wHrs+duF3dmn+Nouf
         A0KPX7GhYN1pyP/OpUKzzFOtD0qB1V7Q1Lj475fegeKHQZEz/TDZbKdTADl7Ju245Twk
         237Q==
X-Gm-Message-State: AOAM532Hzbsto0LpZqHWzhW7GglZLl3raYmAPfT9ltkJpqzmrFlwhEzz
        ccboGOT4E11Jh7xWthbLkeMPkBZYIPU=
X-Google-Smtp-Source: ABdhPJwmlVswiRCzCp8b33mjw5JxPXMhBKxKeMQpzEbqXvWUimj1yUpse5RfPVQp/1f+oUgCkzTvRQ==
X-Received: by 2002:ab0:1866:: with SMTP id j38mr20116644uag.27.1608825415636;
        Thu, 24 Dec 2020 07:56:55 -0800 (PST)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id z10sm3208037vsf.26.2020.12.24.07.56.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Dec 2020 07:56:54 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id h6so1501601vsr.6
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 07:56:54 -0800 (PST)
X-Received: by 2002:a67:3201:: with SMTP id y1mr21661285vsy.22.1608825414045;
 Thu, 24 Dec 2020 07:56:54 -0800 (PST)
MIME-Version: 1.0
References: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 24 Dec 2020 10:56:16 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfmKFVZ7_q6nU92YYk-MLKWTa_bkE+L4C8vi5+UQ1_a8A@mail.gmail.com>
Message-ID: <CA+FuTSfmKFVZ7_q6nU92YYk-MLKWTa_bkE+L4C8vi5+UQ1_a8A@mail.gmail.com>
Subject: Re: [PATCH net] tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 6:51 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> we should use -EMSGSIZE instead of -ENOMEM.
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Willem de Bruijn <willemb@google.com>

It might be good to explain why the distinction matters: one denotes a
transient failure that the caller (specifically vhost_net) can retry,
the other a persistent failure due to bad packet geometry that should
be dropped.
