Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6119231D802
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBQLNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhBQLNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:13:10 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFC0C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:12:29 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v5so20698531lft.13
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgzeP1pHTzdsARzTKFGwOw6DB6q1E3wO4SquJ7Fv1tA=;
        b=rfgI35S28C1rl92sJwIoc55lJ0GQHCmPGwFmHrSkLiKYmDfQZ0B4Ia7ZT3/CBbZFov
         DTRGMdgmnIeQpN7Ib71UUQ5cO9iGShYcIQsCPj7ZpeR9bYrKqyKWvInmV2kCGkb5cqsn
         qhAUEHsTi9H/Suz6jYzTPdJhxifCvNCL1cHvFq1w04MMgh5d8bVle5z88v+kt/+02lOk
         9+P/FWXgaJxeyY+urANn+Btbs20iNx5UR/5YU8UL6nc4FfIgo63Brb6Z8p4KtL6dQ7UY
         NoRo5sA/bBBJEywQEQAC61DyXXINmAFWwKH7xD9XleWV8txXSVHmdu1jN1qlmPUGKpuS
         SDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgzeP1pHTzdsARzTKFGwOw6DB6q1E3wO4SquJ7Fv1tA=;
        b=aZVAw5MBty38Fp3sa5mqymPAEPytQqm/8pJm/cbWT09Gf70WcZ+e11EqcX6DHX0B19
         Ae8gAVRGRCrkVsWwAHq20i8beKf3oUSj6sCt7C5H0nx68E0iVEYqVQmEtUnG0TgrEYUu
         t4RpjtBXPh7hvJ3ENS6tTVTtHd/vvlo2Hi1yLzVAB+m7bBB0FN0GAyo0+FVGqbtnrQ8z
         RO9FkLfmwb32aZzOM/8gfb3e/EZMrsABqkS1nts2Ku24s10xszQqVYlJgxWXFn/fQtzA
         Qmn+NEwyBpzzJktS/uKisA73H3pwdKpnUV4eq8TwlcxIGOmAkgALivzL1tOHRihznb6k
         5JEQ==
X-Gm-Message-State: AOAM531C/vYS9FI7eHV7XwxQhET2bpAyXSAgLq5xb4ou+jxAoPjmLRQ0
        kUztOLYay8CsVodSp2m5tX/TibH6PAhDpsIVTf+xhQ==
X-Google-Smtp-Source: ABdhPJy9Y+cln57EmVUfv/yE9t288T59jP/dd+AfsT08RfH4C5xA1xA34Dpd9OFkehqfPG2fI02EQdZendhcy6xtsM4=
X-Received: by 2002:a19:70e:: with SMTP id 14mr13748295lfh.157.1613560348294;
 Wed, 17 Feb 2021 03:12:28 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-3-dqfext@gmail.com>
In-Reply-To: <20210217062139.7893-3-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Feb 2021 12:12:17 +0100
Message-ID: <CACRpkdZEQYahteQ3GdftkS82O2rz_ZZ88AUN0HGMhNQDHaFWRw@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: dsa: add Realtek RTL8366S switch driver
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

Hi Qingfang,

thanks for your patch! Overall it looks good and I will not
nitpick details since this is RFC.

On Wed, Feb 17, 2021 at 7:21 AM DENG Qingfang <dqfext@gmail.com> wrote:
>
> Support Realtek RTL8366S/SR switch
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

I would mention that the DT bindings for the switch are already in
Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
(Hmmm we should convert these bindings to YAML too.)

>         select NET_DSA_TAG_RTL4_A
> +       select NET_DSA_TAG_RTL8366S

Hopefully we can use NET_DSA_TAG_RTL4_A for this
switch as mentioned.

> +/* bits 0..7 = port 0, bits 8..15 = port 1 */
> +#define RTL8366S_PAACR0                        0x0011
> +/* bits 0..7 = port 2, bits 8..15 = port 3 */
> +#define RTL8366S_PAACR1                        0x0012
> +/* bits 0..7 = port 4, bits 8..15 = port 5 */
> +#define RTL8366S_PAACR2                        0x0013

Is this all? I was under the impression that RTL8366S
supports up to 8 ports (7+1).

> +#define RTL8366S_CHIP_ID_REG                   0x0105
> +#define RTL8366S_CHIP_ID_8366                  0x8366

Curiously RTL8366RB presents ID 0x5937. Oh well. Interesting
engineering process I suppose.

> +/* LED control registers */
> +#define RTL8366S_LED_BLINKRATE_REG             0x0420
> +#define RTL8366S_LED_BLINKRATE_BIT             0
> +#define RTL8366S_LED_BLINKRATE_MASK            0x0007
> +
> +#define RTL8366S_LED_CTRL_REG                  0x0421
> +#define RTL8366S_LED_0_1_CTRL_REG              0x0422
> +#define RTL8366S_LED_2_3_CTRL_REG              0x0423

Again I wonder if there are more registers here for 8 ports?

> +/* PHY registers control */
> +#define RTL8366S_PHY_ACCESS_CTRL_REG           0x8028
> +#define RTL8366S_PHY_ACCESS_DATA_REG           0x8029
> +
> +#define RTL8366S_PHY_CTRL_READ                 1
> +#define RTL8366S_PHY_CTRL_WRITE                        0
> +
> +#define RTL8366S_PORT_NUM_CPU          5
> +#define RTL8366S_NUM_PORTS             6

Hm 5+1? Isn't RTL8366S 7+1?

> +#define RTL8366S_PORT_1                        BIT(0) /* In userspace port 0 */
> +#define RTL8366S_PORT_2                        BIT(1) /* In userspace port 1 */
> +#define RTL8366S_PORT_3                        BIT(2) /* In userspace port 2 */
> +#define RTL8366S_PORT_4                        BIT(3) /* In userspace port 3 */
> +#define RTL8366S_PORT_5                        BIT(4) /* In userspace port 4 */
> +#define RTL8366S_PORT_CPU              BIT(5) /* CPU port */

Same here.

Overall the question about whether the switch is 5+1 or 7+1 is my
big design remark.

Maybe it is only 5+1 who knows...

Yours,
Linus Walleij
