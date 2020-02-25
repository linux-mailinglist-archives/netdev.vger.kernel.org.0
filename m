Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4716BA19
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgBYGwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:52:51 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39467 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbgBYGwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 01:52:51 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 24de54a5;
        Tue, 25 Feb 2020 06:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=w/VRuCSCoIgAztIdpXTQQMuj6R4=; b=o8sPBP
        HKGtfQ4/MEqB+uKD1JRucKRjryc/AzoyImOFNOFm3wKCVV36ZRk7W+EAUWJAGLEm
        piXz8f04LEaGg3ullT52G4Uut12fjdUKsALvojga/y/I1iv3JiabvW2g9NHNnsbK
        L995X/GZTmtqACVcMH3IRsasogGyETu/A/IK6dJCzeaViGHUVwRpltAapdYwn2Pj
        BHLAflmFF/xMVWXB9djIQoiCC+MpLaDRirTAxpkEOA7f/zIUEZ0/R5dHK38FlQdE
        eDcalusRJ29vW8zpld2hBdXiwkVxU8VR89+Ni5BE7IhElxY2UgGv+hMv/zcH7l+b
        3HtgkEt+xvLbZHzw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e3c6b48b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 25 Feb 2020 06:49:20 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id p125so11560079oif.10;
        Mon, 24 Feb 2020 22:52:49 -0800 (PST)
X-Gm-Message-State: APjAAAWaiPwEAslod6+u9DSRa/xRWSImztWMkyk99JpAsGWzJbDqYZv4
        ZSLos9o+5Bq8VyuTcLYUKFAS02X7nzH4vTZ+Sg0=
X-Google-Smtp-Source: APXvYqyQZQlRN03OaJEP//qlurHmX85SOuhqZe8Tq3GnSkvspe+y64L3gV37B3MDmVV+Wj9Yylmucn8Xb6+4ZHmV4aY=
X-Received: by 2002:a05:6808:4d3:: with SMTP id a19mr2170522oie.119.1582613568322;
 Mon, 24 Feb 2020 22:52:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:dd10:0:0:0:0:0 with HTTP; Mon, 24 Feb 2020 22:52:47
 -0800 (PST)
In-Reply-To: <20200225063930.106436-1-chenzhou10@huawei.com>
References: <20200225063930.106436-1-chenzhou10@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 25 Feb 2020 14:52:47 +0800
X-Gmail-Original-Message-ID: <CAHmME9rWq+jJk5s+OoQ+MFMg74=b-a+LtJFjNWqLg6fcreLKbA@mail.gmail.com>
Message-ID: <CAHmME9rWq+jJk5s+OoQ+MFMg74=b-a+LtJFjNWqLg6fcreLKbA@mail.gmail.com>
Subject: Re: [PATCH -next] drivers: net: WIREGUARD depends on IPV6
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     davem@davemloft.net, jiri@mellanox.com, krzk@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20, Chen Zhou <chenzhou10@huawei.com> wrote:
> If CONFIG_IPV6 is n, build fails:
>
> drivers/net/wireguard/device.o: In function `wg_xmit':
> device.c:(.text+0xb2d): undefined reference to `icmpv6_ndo_send'
> make: *** [vmlinux] Error 1
>
> Set WIREGUARD depending on IPV6 to fix this.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  drivers/net/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 25a8f93..824292e 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -74,7 +74,7 @@ config DUMMY
>  config WIREGUARD
>  	tristate "WireGuard secure network tunnel"
>  	depends on NET && INET
> -	depends on IPV6 || !IPV6
> +	depends on IPV6

Thanks for reporting the breakage. However, this is not the correct
fix, as wireguard should work without IPv6. Rather, the recent icmp
fixes changed something. I'll investigate why when I'm off the road in
several hours.
