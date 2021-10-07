Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601DC42537E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbhJGMzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:55:47 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:49977 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhJGMzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:55:46 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MXp1Q-1mHrpT1A5c-00YBFI; Thu, 07 Oct 2021 14:53:51 +0200
Received: by mail-wr1-f52.google.com with SMTP id u18so18820851wrg.5;
        Thu, 07 Oct 2021 05:53:51 -0700 (PDT)
X-Gm-Message-State: AOAM533K7aW770QGwh1w3YzCr42cxRnA2bTLhGUYLZl2FbGbkyJSIg/u
        377Ycaek8Ol3dvQbemYa0VUZILfPkwuP72b8jQo=
X-Google-Smtp-Source: ABdhPJx3qpUbWvyNMVy1KNbxDMh4MqLKS5JIkc9RcdtCSvZi8OuENV0QF2OhHn5yo1RJXygzw/amDKF1gMtu7FnhAM8=
X-Received: by 2002:adf:f481:: with SMTP id l1mr5064678wro.411.1633611230987;
 Thu, 07 Oct 2021 05:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211007123147.5780-1-rpalethorpe@suse.com> <20211007123147.5780-2-rpalethorpe@suse.com>
In-Reply-To: <20211007123147.5780-2-rpalethorpe@suse.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 7 Oct 2021 14:53:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0BiS=mOxS8FeJnxz7pjWFuVNJz0WPFVVEPzsZ0bmzYkQ@mail.gmail.com>
Message-ID: <CAK8P3a0BiS=mOxS8FeJnxz7pjWFuVNJz0WPFVVEPzsZ0bmzYkQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vsock: Enable y2038 safe timeval for timeout
To:     Richard Palethorpe <rpalethorpe@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:0GPU+MHX7I6yLvPa5zhiZVDGC6SFqOrtvW27rHZ7j1V5l/Cm0KL
 u4B3D/KoB58F9TkE88+YTIhBeuJM2LThgqm2EOowLyKhAnt7JmKUg4oyE/qhHnO14BeP/fr
 GAIPPJ1Q9ECNqQ6PLLfH+iJOc1db/IltNX8jf4PdBqHeo9YqUZMZ+yHkrHe6KY4oJJvLHcG
 vhGR8Nanabz8W2sxTwEbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yAE/U057YVE=:wlh4KPRNxsy7azG19DE9BS
 g0yR7iI2u1R8XoOo7WU7gavbvsJJhli2LDLKqGMC0EZUrEAxGe7aMTCZJW00vN3gBE8PPj/cs
 MyRniNJzoTN0FyUFOaSFswiTBrO8Iv6IwJTbrDMBTI9+Had5vv8WSHBS3pz5CQ4hlpPHqO5+m
 Gqq4CJgaMarA1lEUrU1xS6Y5mAemIWD1RUGAOPp5hbbM13LY9szgLE7Pkh0NxVCWmh5evFM9d
 L7XuGmMWwzlXQm++h/uNyyNvxFPN+JPp3Ha7wrG8GT75E1b+Nt31dB9SuDzC3D5H78kqFmGKX
 fURUS0n8crl94wHycowQilB5+zAUSL6zoiPG7obFDTQeXSfAg5n1LC6TokU3jMz/fmzHgUCby
 1SPgNzJ8ouNmP14fbRG4OxK8UqSxo8CpGH5RTrP1V5GDZv2CfHw3KrnWN0mfxDll3ezrVdFJr
 BQgMeD0UHJ9zPJo654ZUfU4+X7Vp8rv0wT7CDon+VXdFv4QBfrkiGSdLDTvSsbDZu5V5rxM9H
 C/3xHFnixzto/CwDxI4B2ysI8vfbi6J9HrQXQXWV85PVKKbkMUaRACJsN0s8hpd83pS6qISJY
 +A6pcc4UXLrRTDaJ84J25nPG5bfcKNnKXRkz/IBTv+bVJzgb5D7lhGBAc4j/HH6t6B/7ThSHx
 d1xMTX4fTHDIkiVlkmWCEkazSEzNCt3R4lv1Y/C8iwovDzNUmhcY6DTT6MPSxFY30iffdqrOg
 JutxSpvljkd+rioGKLTbFsjnW+DigA/eON0Dh1lnHsmkjbgcsKLh/nn3kdg/1htkBAlAsJ9kT
 3dey1bvhxqjAP1Vi6zn5hA+2yUJ6pOjIzJ4EdZXBYlvd0tcD8YcPStpS/USlMg476qemxk+9f
 EQn03qGgXvbKNUrxuQ8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 2:34 PM Richard Palethorpe <rpalethorpe@suse.com> wrote:
>
> Reuse the timeval compat code from core/sock to handle 32-bit and
> 64-bit timeval structures. Also introduce a new socket option define
> to allow using y2038 safe timeval under 32-bit.
>
> The existing behavior of sock_set_timeout and vsock's timeout setter
> differ when the time value is out of bounds. vsocks current behavior
> is retained at the expense of not being able to share the full
> implementation.
>
> This allows the LTP test vsock01 to pass under 32-bit compat mode.
>
> Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Richard Palethorpe <rpalethorpe@richiejp.com>

I had a look to make sure you've covered all the tricky corner cases,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
