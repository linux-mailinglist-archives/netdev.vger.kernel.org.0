Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2325282A4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiEPKwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243005AbiEPKvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:51:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A215FA3;
        Mon, 16 May 2022 03:51:29 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y21so17763442edo.2;
        Mon, 16 May 2022 03:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eiB8mF0XJDqU0woKp11msaKYyY3CXweFfzvmA5fnUk4=;
        b=f2s3GQqn4S9PGH3nB9DZ1rq4h0LJXkbhxdXM1/U7wD3heov1oWhN472Sx3Hjpr6NJj
         +OCg7DPOuLR4hGqQYgWKjHr6Da5gYpHKkauPMmG8U+9Yw0f7rpmjWYJtGpsozF8GivQx
         t3HWLgaMyKY6FWfp25x249Z5GaIfnVSSoFaUjpzbJQ7VXYpxGf+7O4mRu5irCNg0OX2u
         PZK93jVt3Y/W+s77rCO/0ie+4oYB8WYZIaBOXDgBwvrS1llrSXX4dAey8cyj6eliwj0p
         X9mspNM4FvI3COVaAoPVHkWb/oXpgOvzNNyuyiJftWbPb4F9YDKex3ghIIeJUKe0TPVX
         QkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eiB8mF0XJDqU0woKp11msaKYyY3CXweFfzvmA5fnUk4=;
        b=cxgedUHsaf3ayK8iI9hBnULaGqjGMavCcqe/0laO5ZsnAqEKoKhVKvGQINNiUxYVYQ
         i3onW+7XVHGQAH7YCdYrWlMnmuQCn9QjQfw5Cfrp2dKZnZPKmqjOUn+6Pcu+mO5/Am5L
         /SbYNUbffWeks9OFq7LLlfa+JEWHlP+Lw/pItdqWW+2oS15AYKmZ/XFb0YjKJrlOCSSz
         aCVlFHAE7rO8jFscOR9K6+xVdyKuqIZYKYmIsADz1XoOxpFkAGvq5vO/JaHVwUHuV7Cq
         jvM+CBXnXBcYiz+gQGTJav7g41upJpBZTqgb4JtsCGZtYP9nUryxoqBt0chIh6rEYTcV
         dmiw==
X-Gm-Message-State: AOAM530HDpab6KLO5rlwHPBU5NweupM2MzurjtxG+hrzcyjHCyNVwQdF
        XY54x5F30s1uUpmJ7jsAdE8=
X-Google-Smtp-Source: ABdhPJwOGLvumB5LTauGi5+AAvQjocjyBJVYONPHP+vtp9P9rvLzPF5ZLJ8lkrdX7RbbD4/UdGiW7A==
X-Received: by 2002:a05:6402:176b:b0:42a:a828:5d79 with SMTP id da11-20020a056402176b00b0042aa8285d79mr7888664edb.272.1652698288181;
        Mon, 16 May 2022 03:51:28 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id hx9-20020a170906846900b006fa9384a0b5sm3553841ejc.61.2022.05.16.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 03:51:27 -0700 (PDT)
Date:   Mon, 16 May 2022 13:51:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 2/9] net: dsa: microchip: move
 ksz_chip_data to ksz_common
Message-ID: <20220516105126.iwrytpsynzlt6xsz@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:12PM +0530, Arun Ramadoss wrote:
> This patch moves the ksz_chip_data in ksz8795 and ksz9477 to ksz_common.
> At present, the dev->chip_id is iterated with the ksz_chip_data and then
> copy its value to the ksz_dev structure. These values are declared as
> constant.
> Instead of copying the values and referencing it, this patch update the
> dev->info to the ksz_chip_data based on the chip_id in the init
> function. And also update the ksz_chip_data values for the LAN937x based
> switches.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Thanks, this looks good. I see that dev->info is assigned in
ksz_switch_register and I had to look to see whether there is any
dev->info dereference from before the call to ksz_switch_register(),
and it looks like we're ok.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
