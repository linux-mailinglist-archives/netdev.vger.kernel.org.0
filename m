Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D34126413
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 14:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLSN5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 08:57:31 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33751 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfLSN5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 08:57:30 -0500
Received: by mail-yw1-f65.google.com with SMTP id 192so2186400ywy.0
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 05:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yn+mK/5xEg4fegs3phGOsQ7/Ct6TERF9p632E4MnVU=;
        b=Z+70zlfpfDFUhG4zCZN0o7aK311Wb9wqmTfhJspMn390U/L7t8E4FJKmpey+FMMx+m
         MTrrHYTduZesm6fol+ZJfFmbXUWIpqMnwaYzeIw4f74e8jT8uVqAV65Rga3P/rBzQz12
         t3fhOs6j8YhRorlFhHq64M1oHtQQOHmkXE/UgtMGS/SQwbqOXSNKOW3/cr9q2XF8EoaT
         S8zSoSXCT9OwRrk+rJUEubK+m3qxHSe5oZ1JUCTlhyjI8QrEfKD/sOXaX44xHEOlYR0P
         QJU5pdTCLdk9Pu7p6orkgIjjgAjT/7ZDfZ4a49i0E9kzIhy8mQRWWEl8xV8Bzxfk+rQo
         u7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1yn+mK/5xEg4fegs3phGOsQ7/Ct6TERF9p632E4MnVU=;
        b=C7ZCoUDzBJqoc/VhX69XZ22eKUuHShOChJLa3iDXyUGl5ulvdjta4whUyWk4uBWonW
         LP+wNgDRFFmi17oaUf+RZtzdEH5M0eqEMAkfH8mDiUNPgzLz2yc25xS8d6yL0UCILzTX
         JX/gITaYWHTyPDsTj9p3KdTJyiw4FCwQXrU9nRlZw46uvDfJKOM4RswvrDPv1I4M9O6E
         OLauDmkALVFNsdu2XorQ9C4PIUsNzI228GSCg1YdKDLB2QP51Epl736CWSo/FyrE2ft4
         8sZeXsoLEkQW5cCEqMS1PRAe5IOjCuLBkswlqOL9lwOEXPkjQZ+8mwkp7ePdenZqVOBG
         Ih5g==
X-Gm-Message-State: APjAAAXeD+hTMPN5FGPKI8dya7SKselzi3QYVz5B/mgGx7RaQD3qAS6H
        mji8rmSwaiRioXRTdyNdDraVo6XO
X-Google-Smtp-Source: APXvYqzOxJ4q+m1sqgJMi036M4b6URkFVEzPnA1sHaxUqZBcpRGTtjnRsQfxGyLYCeRM5K/hhY636Q==
X-Received: by 2002:a81:6c04:: with SMTP id h4mr6577369ywc.431.1576763849350;
        Thu, 19 Dec 2019 05:57:29 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id 207sm2502810ywq.100.2019.12.19.05.57.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 05:57:28 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id a124so2199271ybg.2
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 05:57:28 -0800 (PST)
X-Received: by 2002:a5b:348:: with SMTP id q8mr6431302ybp.83.1576763847446;
 Thu, 19 Dec 2019 05:57:27 -0800 (PST)
MIME-Version: 1.0
References: <20191219013344.34603-1-maowenan@huawei.com>
In-Reply-To: <20191219013344.34603-1-maowenan@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Dec 2019 08:56:50 -0500
X-Gmail-Original-Message-ID: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
Message-ID: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: refactoring code for prb_calc_retire_blk_tmo
To:     Mao Wenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, maximmi@mellanox.com,
        Paolo Abeni <pabeni@redhat.com>, yuehaibing@huawei.com,
        Neil Horman <nhorman@tuxdriver.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 8:37 PM Mao Wenan <maowenan@huawei.com> wrote:
>
> If __ethtool_get_link_ksettings() is failed and with
> non-zero value, prb_calc_retire_blk_tmo() should return
> DEFAULT_PRB_RETIRE_TOV firstly. Refactoring code and make
> it more readable.
>
> Fixes: b43d1f9f7067 ("af_packet: set defaule value for tmo")

This is a pure refactor, not a fix.

Code refactors make backporting fixes across releases harder, among
other things. I think this code is better left as is. Either way, it
would be a candidate for net-next, not net.

> -       unsigned int mbits = 0, msec = 0, div = 0, tmo = 0;
> +       unsigned int mbits = 0, msec = 1, div = 0, tmo = 0;

Most of these do not need to be initialized here at all, really.
