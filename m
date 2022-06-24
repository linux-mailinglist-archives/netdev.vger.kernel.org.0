Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705F155A4FE
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiFXXoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiFXXoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:44:05 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4828AC06;
        Fri, 24 Jun 2022 16:44:03 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i7so6957869ybe.11;
        Fri, 24 Jun 2022 16:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V1brg2y3JDj6U/8CjOdEq248XdYOzJ81ukpZs2/J6U8=;
        b=L5mUz/R7adkDYUiVk2Y8mAxfEW65sH5WSCnPVZqLvidJHxkq00zUfXXCrgaJLXeU0G
         TR7rTPQ+KG6YAtuMTX8GtWKTLjEwiPODRV3kz7Og/WwaDcRBfkIkIfCGPPTau/z4E2ko
         veRudcqY88uclMsw6twNecxETVIDpgpb6h9X/TgnD5usl5Wi5U5iDksSXb145bwBZ3Ue
         ZK9HMCqQqfHMn6HJB/gFMRH7XwUKNKiZbL4y+4/l8Po6DCb+XajGBL7HeKX/rdnDcLSb
         mx4sqh8Di0sTc+sdbHbpuTWpUZJU+TaT4nqAW7QttSEpOQkFKpMatP9Ztj+unehnNJRC
         DUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V1brg2y3JDj6U/8CjOdEq248XdYOzJ81ukpZs2/J6U8=;
        b=BNIXWDNkAlHcM0iJD8cBbbl9OXSpqqRbTKkpwvtoVqp8s4FbZcvbebkjV7Ug5165tF
         zM4pyLAHgYNiQwwhC3vQ5z4NQvAghP73EyZbLu8+kBl0At2mYaETUslEtTrUk78fRX6f
         Lk+vIDmK++/Xwk4ypgGq5cM5mxHjumhYC0nduAa8qk3UO/fMQyEiJvqep6YTlxrFVcG+
         rwQVMmlH4L6Zncqqj//EiEiAZsgU3QMsMVkmqjyRxFngYX8A0LEPSwLDYptG9vMMZ0Zh
         4hBxPoFf0GsS5VlJQLlBeEq5y7WnDPDnGr92sY/PCjSW7owWBdqp4VwnJf2uuGsIp4P0
         FU9A==
X-Gm-Message-State: AJIora8k8GY9+wNXrtUco61E8d0Bm1kllFa43HMl58WLUURXEhS6FxaO
        NcJ96hf+bpC1A2jWBMgWV4TSFP9M0y/3pmsTWK4=
X-Google-Smtp-Source: AGRyM1sjX822X/Dsy8VIFBGvzBLqvpKs7BIx362sSa5Zd+7UmGXE/g/4Z/fcgebJhZRBeq9CHZ6VxnHhew15CUmd9fU=
X-Received: by 2002:a25:be07:0:b0:664:4210:aaf3 with SMTP id
 h7-20020a25be07000000b006644210aaf3mr1716779ybk.415.1656114243169; Fri, 24
 Jun 2022 16:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
 <20220623162850.245608-2-sebastian.reichel@collabora.com> <YrWdnQKVbJR+NrfH@lunn.ch>
 <20220624162956.vn4b3va5cz2agvrb@mercury.elektranox.org> <YrXryvTpnSIOyUTD@lunn.ch>
 <20220624173547.ccads2mikb4np5wz@mercury.elektranox.org> <YrX2ROe3a5Qeot4z@lunn.ch>
 <20220624201537.l7p6aoquvvadmpei@mercury.elektranox.org>
In-Reply-To: <20220624201537.l7p6aoquvvadmpei@mercury.elektranox.org>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 24 Jun 2022 19:43:51 -0400
Message-ID: <CAMdYzYr_EA2Oxf6Q-WkX987eWUKRokRR1EsCWM4J+BcF+OkO9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: ethernet: stmmac: dwmac-rk: Disable delayline if
 it is invalid
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 4:16 PM Sebastian Reichel
<sebastian.reichel@collabora.com> wrote:
>
> Hi,
>
> On Fri, Jun 24, 2022 at 07:37:08PM +0200, Andrew Lunn wrote:
> > > The Rockchip hardware supports enabling/disabling delays and
> > > configuring a delay value of 0x00-0x7f. For the RK3588 evaluation
> > > board the RX delay should be disabled.
> >
> > So you can just put 0 in DT then.
>
> My understanding is, that there is a difference between
> enabled delay with a delay value of 0 and delay fully
> disabled. But I could not find any details aboout this
> in the datasheet unfortunately.

The driver already sets the delays to 0 in case of the rgmii-id modes.
0 is disabled, even in this patch. The only thing this patch does is
change the behavior when the delays are not set. If the rx delays
should be 0, they should be defined as 0 in the device tree. There is
rgmii-rxid for a reason as well, but if they are setting the rx delay
to 0 with rgmii that implies this hardware is fundamentally broken.

Very Respectfully,
Peter Geis

>
> -- Sebastian
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
