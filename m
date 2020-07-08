Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0902A21892A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 15:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgGHNeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 09:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbgGHNeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 09:34:19 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4022AC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 06:34:19 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so26885997lfh.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 06:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vu6aW+Rmwj7jbxqhsKNvl9pmfsozoZQZ7TDS9hFK8Xk=;
        b=XlhZ20fbKuMJSamFYpKXTXqbFrcWLW4pks98uB0+SBtd/5+aKIdw7N0WnoKfKhD4QV
         fOjJapxxh7VLgNfxQYWjqflxTnNtsUs14RKK7rNx47KiFQOJytns4DKL8KgCdacKbX9G
         8aLCh7ArP8DX9JDM4YbQdZVMWMWAz0YC0ZNzxoSSRcYGxJUDCAM5PVcjeVOmCmmyVSTO
         Hfyl7MvCR/+F3ReTAJQopzVjO5k735fEm+OrBu4Snbu+XhzzNOPb1HJ+VhxSeXiBi9Kh
         Hptdss3Yn5wHO02vFU2Q5QXUrSeWom64O2hZteElZVPz8hBGJ2K4Hxa5FP/xiEfApEHA
         7OEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vu6aW+Rmwj7jbxqhsKNvl9pmfsozoZQZ7TDS9hFK8Xk=;
        b=C513vfka4u39VvOq4BQXBEBKdV3uqLaPRJMSinhgU4+ijgYfDW51tBi5368cMJc0xb
         PCNl4Yw/5RBM2TJIWr7DdiTPTxqmUNfdp/ZBRczwZ0KTlNb1PnzQXuuPpCGKOIQyCvuB
         p4+7WJXyPSt/cchJhw4mO/gWepkMnFHXMMvRM5IkRmD867f9/XJlgfgfo29MG/5P6put
         UHZ5LF9Nhzc7YkaNvUKhH8CQZ2bKwYQ8J0lLmvUrXoXGI0X2RvaVvZyuZ6KFnZLyKrLF
         z61UZ9kzlz6ZXYIAhJ0q1vClm4GCig3UpuQkGi3cmAO8jTQ+8MhAQJTMZARH84fqYM4t
         vjyQ==
X-Gm-Message-State: AOAM532eBWz1RtTmtj2ZVRGM51FMVFpNElBASGLy2DK64J+0Dof5dXI5
        +8ZHI01WGaMOi6bgVfxpxHttK+b745s0Ua1Rpiay0g==
X-Google-Smtp-Source: ABdhPJzlNPwgUQQTeaSK8S/mIk5s7VrC5jiddyi7sHIGBFkNzi72hw02BipeYT+ftRW/B7wFFLtHOjgmsdXBSbwYrVw=
X-Received: by 2002:a05:6512:3150:: with SMTP id s16mr25610441lfi.47.1594215257640;
 Wed, 08 Jul 2020 06:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200706205245.937091-1-linus.walleij@linaro.org>
 <20200706205245.937091-5-linus.walleij@linaro.org> <9a87a847-05e9-0de8-bdf1-d56eab15f2a9@gmail.com>
In-Reply-To: <9a87a847-05e9-0de8-bdf1-d56eab15f2a9@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 8 Jul 2020 15:34:06 +0200
Message-ID: <CACRpkdY6pcC+w5ipgApFP-72xGU1S_YNz0gBy4r+_V5M4MhEbA@mail.gmail.com>
Subject: Re: [net-next PATCH 4/5 v4] net: dsa: rtl8366: VLAN 0 as disable tagging
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 11:23 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> As mentioned before, if you need VLAN awareness into the switch from the
> get go, you need to set configure_vlan_while_not_filtering and that
> would ensure that all ports belong to a VID at startup. Later on, when
> the bridge gets set-up, it will be requesting the ports added as bridge
> ports to be programmed into VID 1 as PVID untagged. And this should
> still be fine.

I actually managed to figure this out. There were some confusing bugs in
the code that needed fixing but after that it works smoothly.

It is maybe not the most optimal setup - using one VLAN 1 for the whole
bridge and all ports denies the bridge to optimize the packet flow
per-port, but that is something we should fix in generic code and I
will describe it in detail in some patches I'm cooking.

Yours,
Linus Walleij
