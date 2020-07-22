Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB2229F5F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732426AbgGVSlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:41:44 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:50021 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVSln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:41:43 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N1gac-1kvfav3ssK-011y0L; Wed, 22 Jul 2020 20:41:42 +0200
Received: by mail-qk1-f170.google.com with SMTP id 11so3029978qkn.2;
        Wed, 22 Jul 2020 11:41:41 -0700 (PDT)
X-Gm-Message-State: AOAM53327j9/gEy4SKdk466X3SK7KCj5RQnRWjScNWaky9ImPFBAE/0A
        xAwfqJJhrKF5y64x4VLVanAevGhBhYk6HEhKbfQ=
X-Google-Smtp-Source: ABdhPJyhbrD6tzQxx6tX0jvgDW3CuNZbeFESKXN/P3EjNbM4QSRZdQvTqZXS1d+oo+E+xij7I8GhcpR7DQeIgnPVjL0=
X-Received: by 2002:a05:620a:2444:: with SMTP id h4mr1481373qkn.352.1595443300710;
 Wed, 22 Jul 2020 11:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
In-Reply-To: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 Jul 2020 20:41:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a23zUHGnVBsBX=GqBzbRxwkqmOA_7heMze4EsyQvVfg3g@mail.gmail.com>
Message-ID: <CAK8P3a23zUHGnVBsBX=GqBzbRxwkqmOA_7heMze4EsyQvVfg3g@mail.gmail.com>
Subject: Re: [PATCH] drivers: isdn: capi: Fix data-race bug
To:     madhuparnabhowmik10@gmail.com
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        David Miller <davem@davemloft.net>,
        gregkh <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andrianov@ispras.ru, ldv-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:aNK/nvkB9ZCM6woMY5T9CGO9BENrHy5uQvQkanc1Pbed9KqX9tJ
 +wl76T0zrTQAvqp5NWj9g66YBoeEO7CUPufpzgwlLvKO5Hhos1cDtsE8iMP0L7oZyunRE3O
 iHLcO4Gz8xbieUn9OCCsUi+0J+alWL93SvuUF7a3LS/ba9c4+3AYJ/bAP4L+Qy4wfHP7k8v
 1u/XB48SzF4xGL1e7IuHg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4cJMUcNIDuo=:HoIR/x3awrbj3u6LAh5nU6
 30nvKnT+5L9dppHCuzlEVHcNQ4jXzmtw2LA054tTAz/2rYO8zYFXAnC5Ay818ISN7byLb+NYJ
 oQ2DOA/4vEhy+DkIJp/bOxcy9aNZoAeeZ2OYDwOLb1YhhnRQQXKnCb/WqYpjKZ8b0Y7/+Rdsf
 GPgsfloPJ6obgQjoXdcEOz0k+kZ0TWBAJBB14yimVco49RWEgVVtfJlBnMR08VAaYJ4x3sVlz
 K7HMH5zGvJrGL+MqBj7Atv8bxqj7F0nHb1UoY0ven9fTagxDPINLS3SX5ah5TgAaLYw5x42aq
 VHCe2+pz6DSGwWZkiVd5eCFsO5TQfXJSKG42hcYIHKgDYPaOiD/WJwpnRTsLCYB7XXCe0nEYU
 jn3FKVCq5NW372kzUpAn236drbHpo+DUXmTZ0vXL/TE1AaW7cFHba/2C5yTi6byp07R7lyNCx
 5qvuU5H9hFcYmXxj9B38Vfzj/AVNweMzpcXidv8Pbd50lxmbv1oSmthbvvjzK3dt7gAMByHu0
 uqopQncEaWsxdXNo0S2NTZoulTpkZM3S9SDvsRRbxE0ZGMCQTmEzaUmUskbmQO/AAMhV0Pb+j
 VXjk2i6kNR5Iqb+DKWFQQBerEAolWHQ+utixt6VssVSwbzAZdG69Rw9QVoUw0uM0ZX18BtKUk
 xiR4CFM+mraf07lVsB6ioxFdntcr1wdcjS0U1yEX72xp+CpuKMhLGenllnBZ3j0ais1+PYiCv
 hIcqcndLGgE7qor7OGJaAsXUqjxUI2hdI1IeGUJfPmXgcflO1rTum8mgO3705Hi2otEo8eUtJ
 qfJQHy4oR3Of8IIpDrX1ZPK3fUL0dlga7re+b2jleVH9IPC4QGmOTf90c7c2JEm77kHIoBb9d
 J89m3IjLH1Sl89HRoIThhaF64o81ejTpIgFHSwrMiEnQWsTHqcVsPfT3odEjvrOjg747gzyaV
 8VD3g2OyeIKQ71oWrDqEUO8dE9eUo/qksWSSHONzzTUU9WshlrWTC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 7:23 PM <madhuparnabhowmik10@gmail.com> wrote:
>
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
> In capi_init(), after register_chrdev() the file operation callbacks
> can be called. However capinc_tty_init() is called later.
> Since capiminors and capinc_tty_driver are initialized in
> capinc_tty_init(), their initialization can race with their usage
> in various callbacks like in capi_release().
>
> Therefore, call capinc_tty_init() before register_chrdev to avoid
> such race conditions.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

I don't think there are any users of this driver, but I had a look anyway.

The patch looks reasonable at first, but I'm not sure if you just
replace one race with another, since now the tty device can be
opened before the rest of the subsystem is initialized.

It's probably fine.

         Arnd
