Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD91D487067
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiAGCbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:31:21 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:47483 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345392AbiAGCbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:31:20 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Md6ZB-1mVV8X2suh-00aALI; Fri, 07 Jan 2022 03:31:18 +0100
Received: by mail-wm1-f51.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso2175544wme.1;
        Thu, 06 Jan 2022 18:31:18 -0800 (PST)
X-Gm-Message-State: AOAM532YdSewgeC5zVPrxViB+szycqARFioOuqPwKzF7DOfngCSxl9qr
        ux5u6i7e/9Y1tCKBxc/uR9AN+G1ViZPMoFpRC+M=
X-Google-Smtp-Source: ABdhPJzPjYESERWywY2r/vy27PoJsyUe/sO9mYrCqlCb0tB5N5fglYx3siWs052mww9CA4oxRJdgYwk0eCv1ZWNvEtA=
X-Received: by 2002:a7b:c190:: with SMTP id y16mr8685720wmi.35.1641522678363;
 Thu, 06 Jan 2022 18:31:18 -0800 (PST)
MIME-Version: 1.0
References: <20220106225716.7425-1-paskripkin@gmail.com>
In-Reply-To: <20220106225716.7425-1-paskripkin@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 6 Jan 2022 21:31:15 -0500
X-Gmail-Original-Message-ID: <CAK8P3a1tJTcFKfSSXzXRM1NLYacjf=-RYbz54HATxv0WSfu+qw@mail.gmail.com>
Message-ID: <CAK8P3a1tJTcFKfSSXzXRM1NLYacjf=-RYbz54HATxv0WSfu+qw@mail.gmail.com>
Subject: Re: [PATCH] net: mcs7830: handle usb read errors properly
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tanghui20@huawei.com,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Arnd Bergmann <arnd@arndb.de>,
        USB list <linux-usb@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:SIguIQGIepHyKd+m+UmjqM0lRVpbV/pQlunQrt5W39xZwXGZejK
 +pdbkrelzYFXvkwxnV+7keszsCKDfb8zBZ73QcFlEJq35pqY5bBpXX3rNrYWyYlTjwvWQQB
 BpwLhDpbmw+AuxgzABPWSHKb8rstA19x/hLDG0VjrAQ0pX8IDNfw4hqDPA0CLudaPG6alDA
 1x0izyfMDFGCPJQZgmOIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZtxTtvMqY9U=:tIA7LuSFE3AIcuJ877bcvW
 g27NHZ1Xb22IAaSdHlqo8g9lgxrsRlRv5uvd+AjlWjJLQTDIj9DzYIMK4NNNXyEdiWPAhEFnm
 ixlGlP+d1HUeWeBzZufLPtJUe0vc8rQGVtCbyDKzxc85GUY9RwGcskLi8onNGVJXYU1ZcM4MN
 PPAUEXHjIDhLLUGbTqLcY0yRWlF7azUJEGjyAxRz9G2YDq6sIIIqrzPiZZz/lJFDBe9U9Hsi3
 58erfT9fCQG7XvbBFxCGMneqedJERFMcrfLcDcmF0KM4DX0Okaie3zIUT8MvEukfIX/TdonZO
 3OPeY/L1M36fKxD/ViykKhw1BDM1MDQPK2tlQV66+OQnMGas33G0fKsazCyGS+nqOrsAl7pyr
 8yr6fM3YUZ/6+MiWxYlSfWomCVHvdKjzzZjT/a8rLs3uw9zqBWZXYE/8SM4hyeeYXtO7yUREa
 kUMyugLDGl+kl2+hOVzWMIzpBCwe6ONi90xWNo4wiHoayd1XIBOjTJgsiACvpeVe5krO5WNQk
 hNeVSG2OvceUMQK/IhmCE4O0N/ORUMp1xeW3KV9zgm5dV99IM7wMt+wd8RDoL8uyj8GGImMeM
 RjZIuzhzSc3cbzZaEXaImeeN33QNor03IVbiWPxPpNulyDi6JbDCGZBiZ7iqJmtXgDsy/z/Rz
 hZN6sR5T+CPq9tDmQNADLtFzH+2/tZ3rHdcP+cGD0LsmcwzxtamtsMGDzLfsFIgSmj7kKr/El
 ttiwKbEdoIMDxO5qPnkDxZDyB2BNu1JHJl61omPCdQorkLfYjr/qyKYVFtDKWDAedW72cIGzd
 c0iXHeTZiqzLPScJWWTudMYk0ib3dmCvP+EIsHSYBurfSwMWHs=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 5:57 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Syzbot reported uninit value in mcs7830_bind(). The problem was in
> missing validation check for bytes read via usbnet_read_cmd().
>
> usbnet_read_cmd() internally calls usb_control_msg(), that returns
> number of bytes read. Code should validate that requested number of bytes
> was actually read.
>
> So, this patch adds missing size validation check inside
> mcs7830_get_reg() to prevent uninit value bugs
>
> CC: Arnd Bergmann <arnd@arndb.de>
> Reported-and-tested-by: syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
> Fixes: 2a36d7083438 ("USB: driver for mcs7830 (aka DeLOCK) USB ethernet adapter")

Looks good to me.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>
> @Arnd, I am not sure about mcs7830_get_rev() function.
>
> Is get_reg(22, 2) == 1 valid read? If so, I think, we should call
> usbnet_read_cmd() directly here, since other callers care only about
> negative error values.

I have no idea, I never had a datasheet for this device, only
the hardware I bought cheaply and vendor source code I
found somewhere on the net, and that was 16 years ago.

I would not expect the hardware to ever return less data than
was asked for, so any length checking would only have to
account for attackers that fake this device.

         Arnd
