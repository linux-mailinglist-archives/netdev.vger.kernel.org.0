Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0F134D03
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgAHUSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:18:02 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36716 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgAHUSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:18:02 -0500
Received: by mail-ot1-f65.google.com with SMTP id 19so4886424otz.3
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 12:18:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UM9Yhyyn+nTPYkkQGog0oC/YJwVnBTJCjtlyMYqJ2Ow=;
        b=W2dWqCmKy4w9YlBogK3iMoqO2vUeLn8RNUigyxiO0ws1gIuPFkvSCELZYvZ1zudhSE
         M8vsLVSEhKbYUWI8N5x9yeEw8UHB0qN3MfRB0mZRM/BUGKVDWKTmUHYT3M4+S5PlNnFl
         abCOO8dRJ+9F8dm9ClzNeuMTPXybhw0bsLumkq7cNeH1ym5DBgFs6/cVhyzEW+9eI84d
         aL+vQwiUPqr1VAA7iUkBl1aveqAmVpHhxOFzgXJO8UyUkqj3JmGYMEWXUgBe7QtTN5tE
         gXuw2UmkI6lE5eheZCce3QmYXdqcv3wIQz6vxu38u8QI7P2ouP6zsXKY7qhytCV3ldxs
         kTqQ==
X-Gm-Message-State: APjAAAX15csWq1+YO/1q8qiYdVVq63o25d3en3Zv6p4OIEFOGOGksGR/
        hp5IBY0Ozkyizq6N9jgx6iM3mmk=
X-Google-Smtp-Source: APXvYqw+tK27AG/4uHWvF5+kZMJoAAKfOxVX5Yit8GkCqVd01y1iUrLH9kMLMxjIVL9rHBalJeiXww==
X-Received: by 2002:a9d:21f5:: with SMTP id s108mr5898393otb.152.1578514681178;
        Wed, 08 Jan 2020 12:18:01 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l17sm1519189ota.27.2020.01.08.12.18.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 12:18:00 -0800 (PST)
Received: from rob (uid 1000)
        (envelope-from rob@rob-hp-laptop)
        id 2208fa
        by rob-hp-laptop (DragonFly Mail Agent v0.11);
        Wed, 08 Jan 2020 14:17:59 -0600
Date:   Wed, 8 Jan 2020 14:17:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code
 check
Message-ID: <20200108201759.GA28519@bogus>
References: <20200106045833.1725-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Jan 2020 13:58:33 +0900, Masahiro Yamada wrote:
> 'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
> 
> The semantic patch that generates this commit is as follows:
> 
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
> +PTR_ERR(ptr) == - error_code
> // </smpl>
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  crypto/af_alg.c                      | 2 +-
>  drivers/acpi/scan.c                  | 2 +-
>  drivers/char/hw_random/bcm2835-rng.c | 2 +-
>  drivers/char/hw_random/omap-rng.c    | 4 ++--
>  drivers/clk/clk.c                    | 2 +-
>  drivers/dma/mv_xor_v2.c              | 2 +-
>  drivers/gpio/gpiolib-devres.c        | 2 +-
>  drivers/gpio/gpiolib-of.c            | 8 ++++----
>  drivers/gpio/gpiolib.c               | 2 +-
>  drivers/i2c/busses/i2c-mv64xxx.c     | 5 ++---
>  drivers/i2c/busses/i2c-synquacer.c   | 2 +-
>  drivers/mtd/ubi/build.c              | 2 +-
>  drivers/of/device.c                  | 2 +-
>  drivers/pci/controller/pci-tegra.c   | 2 +-
>  drivers/phy/phy-core.c               | 4 ++--
>  drivers/spi/spi-orion.c              | 3 +--
>  drivers/video/fbdev/imxfb.c          | 2 +-
>  fs/ext4/super.c                      | 2 +-
>  fs/f2fs/node.c                       | 2 +-
>  fs/ocfs2/suballoc.c                  | 2 +-
>  fs/sysfs/group.c                     | 2 +-
>  net/core/dev.c                       | 2 +-
>  net/core/filter.c                    | 2 +-
>  net/xfrm/xfrm_policy.c               | 2 +-
>  sound/soc/codecs/ak4104.c            | 3 +--
>  sound/soc/codecs/cs4270.c            | 3 +--
>  sound/soc/codecs/tlv320aic32x4.c     | 6 ++----
>  sound/soc/sunxi/sun4i-spdif.c        | 2 +-
>  28 files changed, 35 insertions(+), 41 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
