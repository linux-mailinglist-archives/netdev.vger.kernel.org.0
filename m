Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476CE620C0A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiKHJVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiKHJVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:21:21 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7128120F7F;
        Tue,  8 Nov 2022 01:21:20 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f27so36969398eje.1;
        Tue, 08 Nov 2022 01:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZioQH0ZdPvbg8JsVgr0Jja7ENNA+LAa9Yzjp7in7/t0=;
        b=j1Pjb6kNYsWmK1z/0ZfR+rj2fv/BzIU7Cc/s9RwB+0OjIz3F4CIPFB+smNiDSa8Lf9
         5H6fOc2DgbtHWJdf1afjIs23ZBDkzsK+aaFuoLmqIwI8+Y0v6gotRO+p6rSB0FAt4e4L
         Qwf6HkDNBnTbPcmnq4D/wIm25H660M6LEUEhkYo4lMB7UN0gMe25PiRKbNLGzgyhRzER
         uvdM1qIdIym7MpTXh6CbD2hvSflwuFy1O3OjZmG5viYiPr2esoZNA/O8Q0uCvj3eVdji
         2nfwonLxxk0d1vN/wJ3niLrE3kf/hJsL7XmUX6Q5+Zl9LLeJ1uaBdLW9UtXLF8dsWLKO
         W8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZioQH0ZdPvbg8JsVgr0Jja7ENNA+LAa9Yzjp7in7/t0=;
        b=QoARKOnVK7kYReIN2DtFZGp1x64Kh4HHTegNWZfEdrDRc1Bn6ZZ3pPaSI3eX5eeeJR
         335jlAgyU7TeqZ+6p1XK53PbOkTzkd/K6bTvA1Pi3B56SZwv+j1vNj6dWYOLQe+MXzKw
         S52MaolpA2ka37V2ex17xaUxSKEGJTE2L7a4+LK9iXDKpZ+5arw6IVbaWR9DOjHAYyDp
         6eYPeckJD4nEupjHlTSmjiCayVW1SqrBD+1qFYD6Bejzog7ZHz4ifyNAD8PRipnkufx0
         O6cjil7c+/uDm8MhIbRRh6BcZLr/6uxbxOzhA/5r4KRvZoIL+tDK6HQzyprOz/EDDA9W
         lA3Q==
X-Gm-Message-State: ACrzQf3dd5rf4+EbQwya8sxLxWC9mIo2kHETCs03TBzlLZw/t0fgAzY/
        HR0XgZ5ChWxwN2V0XUJs0Bs=
X-Google-Smtp-Source: AMsMyM4K7Dnt5MgbcZZ6Jbqr39bnjzK1UMuZ/cq/6k5c3fxbSJR2e+7sONxrVE8EidbU65lN1t42OA==
X-Received: by 2002:a17:906:5e51:b0:7ae:32ca:78c9 with SMTP id b17-20020a1709065e5100b007ae32ca78c9mr20885499eju.166.1667899278966;
        Tue, 08 Nov 2022 01:21:18 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id h3-20020a1709066d8300b0074136cac2e7sm4398494ejt.81.2022.11.08.01.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:21:18 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:21:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 3/3] net: dsa: microchip: ksz8: add MTU
 configuration support
Message-ID: <20221108092116.fpwvlxz3bbvkha66@skbuf>
References: <20221108054336.4165931-1-o.rempel@pengutronix.de>
 <20221108054336.4165931-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108054336.4165931-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 06:43:36AM +0100, Oleksij Rempel wrote:
> +static int ksz8863_change_mtu(struct ksz_device *dev, int port, int max_frame)

Don't pass "int port" if you're not going to use it.

> +{
> +	u8 ctrl2 = 0;
> +
> +	if (max_frame <= KSZ8_LEGAL_PACKET_SIZE)
> +		ctrl2 |= KSZ8863_LEGAL_PACKET_ENABLE;
> +	else if (max_frame > KSZ8863_NORMAL_PACKET_SIZE)
> +		ctrl2 |= KSZ8863_HUGE_PACKET_ENABLE;
> +
> +	return ksz_rmw8(dev, REG_SW_CTRL_2, KSZ8863_LEGAL_PACKET_ENABLE
> +			| KSZ8863_HUGE_PACKET_ENABLE, ctrl2);

Coding conventions are to not start a new line with an operator, but to
put it at the end of the previous line:

	return ksz_rmw8(dev, REG_SW_CTRL_2, KSZ8863_LEGAL_PACKET_ENABLE |
			KSZ8863_HUGE_PACKET_ENABLE, ctrl2);

> +}
> +
> +static int ksz8795_change_mtu(struct ksz_device *dev, int port, int max_frame)

Same.

> +{
> +	u8 ctrl1 = 0, ctrl2 = 0;
> +	int ret;
> +
> +	if (max_frame > KSZ8_LEGAL_PACKET_SIZE)
> +		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
> +	else if (max_frame > KSZ8863_NORMAL_PACKET_SIZE)
> +		ctrl1 |= SW_HUGE_PACKET;
> +
> +	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
> +	if (ret)
> +		return ret;
> +
> +	return ksz_rmw8(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, ctrl2);
> +}
> +
> +int ksz8_change_mtu(struct ksz_device *dev, int port, int mtu)
> +{
> +	u16 frame_size, max_frame = 0;
> +	int i;
> +
> +	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
> +
> +	/* Cache the per-port MTU setting */
> +	dev->ports[port].max_frame = frame_size;
> +
> +	for (i = 0; i < dev->info->port_cnt; i++)
> +		max_frame = max(max_frame, dev->ports[i].max_frame);

You can do what other switches do, and instead of caching into an array,
"return 0" for everything except the CPU port. The CPU port will always
be programmed with the largest MTU.

> +
> +	switch (dev->chip_id) {
> +	case KSZ8795_CHIP_ID:
> +	case KSZ8794_CHIP_ID:
> +	case KSZ8765_CHIP_ID:
> +		return ksz8795_change_mtu(dev, port, max_frame);
> +	case KSZ8830_CHIP_ID:
> +		return ksz8863_change_mtu(dev, port, max_frame);
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +
