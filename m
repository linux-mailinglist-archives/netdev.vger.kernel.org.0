Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FB931D7BC
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBQK4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBQK4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 05:56:00 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4F6C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 02:55:20 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id a17so15520882ljq.2
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 02:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zmrb68Ws79UDH7yjdddQC9zcXjTI2srk0ulWs+eJw8I=;
        b=hkU0fre1Subfb9EsWHBGIjlKfxKFtgB9K2YT5dcfsHtGiaZFt1dyHWEpjnwaaEJrnA
         aWATkEyAkeaFw+9fTYgK9sKEowd6LGJYj89DzMKY34JmernDr6i+3FYWxIQ6Gtq0p8iq
         tkKc5JISjuD9QFBzSEafYMKgYZE52HDCtYc9SgiOsjUS8LqzIZWuZr6ShFXCF+v33mlE
         01YMVYfKH94g2GwyswNUUseMGAG/v9Fnh/UMhkzuOwaIPvu6SFNOfFvS6CKwsAKUc7mf
         BCXCWAeZjaWDYkQUmtnZ8IXvGU4PvNxk7WVcaW3hqtCz7gRlC/N92noUKuZpK5+0h45p
         CTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zmrb68Ws79UDH7yjdddQC9zcXjTI2srk0ulWs+eJw8I=;
        b=CJoEa326tP5+09cSPTW/NZ89NBG29qFOSArcuqdKOEgkzgFvUiRVSCLagROJJGE7QM
         Pg9bxwKDILT9HHXifviY1ZnkDBh7a2KnwO/uwKXunvnAYYnWvq9PcR/n0NIjWqOxo1dF
         7/OAAAmeGtywylMKsAtGLpPbXypqAe1azpBgdD4qZ4hWMX12CYyyHRmQ/ShbNmIMEAKp
         uwmH92lqLWzYIRLdeLKfaJu1Vhc/SH3ca9RsLbaNX9cDNUPJ2Q8qYVma/gdtgnC6BIl2
         YTEO2C8a8e7ch8QVslR+MksgfpZCwXQcNaWL9lxTjyh4ZB73RCw1IfhDxgFVuG8IdY1D
         67NA==
X-Gm-Message-State: AOAM5336PPEzJZ36mjIJObFqdQvj9hg5l1L5v6jSyYos5yN+edEw3ja2
        gPDbcqYHU+VuR956QUq1pAfdiZSUAsB/CxQAtp7d1g==
X-Google-Smtp-Source: ABdhPJwX9UfBqtM/Ygb8y/bst0/OfwxV3Z0wmKC6sVCOtD1lwdKRWc4Fke/VhwLW6J3p3Lo7C+nZsdnj6rk3+6REXvY=
X-Received: by 2002:a2e:6c17:: with SMTP id h23mr14987355ljc.326.1613559317670;
 Wed, 17 Feb 2021 02:55:17 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
In-Reply-To: <20210217062139.7893-2-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Feb 2021 11:55:06 +0100
Message-ID: <CACRpkdYq2pE-6QKFXG_tEQ-8_gsuzDkusPpB8N_NVqoSE5u5aA@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:21 AM DENG Qingfang <dqfext@gmail.com> wrote:

> Add support for Realtek RTL8366S switch tag
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

I suppose this switch can just use the existing RTL4 A tag
code after the recent patch so this one is not needed?

Yours,
Linus Walleij
