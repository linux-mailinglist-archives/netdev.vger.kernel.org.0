Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7902D176E
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgLGRV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgLGRV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 12:21:58 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB8C061749;
        Mon,  7 Dec 2020 09:21:18 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id q25so1373756otn.10;
        Mon, 07 Dec 2020 09:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cjCr+Bife3NCISA/1z8hJ3myAPYy5+E6PhYUWMatoHc=;
        b=fQbU6WPLuNm8GOxwHY5L7E9YKNXrbBKUs1pFs2Wyr9FxN4A5dZ262vMxvcfW7I6eyJ
         2HC4UxeNKr0buKMJZ8EQVVCRDUgf0rptSxZ73cON88q+vt8ovhyQDPkhyEG844Ewulbu
         T7d8pAwCgTE5BFwQJp+F4L/yalAobWdijmFYEHYhl2orjj3vIGK+uVR33C007MgehmR1
         YE8zAgD3vjvEz45WfKUH0yqYGCpoAHLfKI5ub0Y0KBOF+D6JVEZ9hPGaVOOJb5jUc+O0
         t4mLWSvIWb7KinhL4qZ5JwveyWxvQnJF32TivdT6JrnIIgCSG+OBc/THfkSyBG74ruRg
         0Yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cjCr+Bife3NCISA/1z8hJ3myAPYy5+E6PhYUWMatoHc=;
        b=mm9rQJ10kBftdIBEn5NJGWhO/rQKCHtErFjhkm5dkf5ZHgETEA/M+lQKonqT3N3qXi
         iXWo4d4YATuBJN9yHq2X0fODuF91W3Mc4l4cnmS2UYpF2Bm8eMmPWqMVlonPeESsLqjA
         wji547nrwIhSNPXB/MbztpqnoNPjVpjRKUBm3xJT5t0JgCLGuKI+fXZHXlqD82bnFvXB
         1Kfr3+u8RkNh/f/yTDXAysJ4D5YBaJMi4ehhkGDgAidGwcpR9PWNDfejpUKLoFE+kE+x
         owAo2Q98WERzgh1QQ+uRh4bZeUTtu1oN0XVfKUr8TUxWCVuWTEQAhsZZ3iK5i4vYdETz
         Uqmw==
X-Gm-Message-State: AOAM532K1bevWSYHs6KLscc10gtQkRdxZU1W1wjXJZRlrfbZo+kzZuD7
        YCUZiP0Qua9bIJM4g1EYXtG8b+qDZt1Td2Z8cnWXtaw=
X-Google-Smtp-Source: ABdhPJxU6l8AnysVEepUmq23xsoPl/q+c4f9G0ZWjF6tZnrIESY2MfDZLrVYKqtgvkZSyBPwDrWwYpdujCPSPblFdOI=
X-Received: by 2002:a05:6830:1f11:: with SMTP id u17mr13650946otg.287.1607361677684;
 Mon, 07 Dec 2020 09:21:17 -0800 (PST)
MIME-Version: 1.0
References: <20201204145624.11713-1-o.rempel@pengutronix.de> <20201204145624.11713-2-o.rempel@pengutronix.de>
In-Reply-To: <20201204145624.11713-2-o.rempel@pengutronix.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 7 Dec 2020 11:21:05 -0600
Message-ID: <CAFSKS=PuCNsk=Gun=LnP1ytcceU5wbxQrvhq4DCsFVGK=7Qaog@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 1/2] net: dsa: add optional stats64 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 8:59 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Allow DSA drivers to export stats64
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: George McCollister <george.mccollister@gmail.com>

I've already updated my xrs700x dsa driver for v3 to use this. I'm
blocked on sending v3 until this is in. Please CC me on any updates.

Thanks,
George
