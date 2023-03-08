Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916096B15AA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 23:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCHWyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 17:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCHWyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 17:54:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7047EB4F63;
        Wed,  8 Mar 2023 14:54:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o12so71934743edb.9;
        Wed, 08 Mar 2023 14:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678316070;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+J0b8VSa/m7CpwvWD16+VUtDl7LeR0FAxAMR+W7ckJc=;
        b=nTJ0zv0CYJkHIUxwc6QFze1Z7fTuDKOX3WhFNdJUvFRbnnu4P0YoFvcJNyh+8qKg+a
         9SQaYQvHAnIMo7hu9JLWrhblRyozZNPe/6qMHmI39gSez0wZdOk8iWb8OvYruLhydk4h
         RqRmCxMImh3W5wm9xrJQLX7acssLQDXDkBpOG35fWSOKD3AZriAvXM5NGyE/ShKZ2y3E
         uD42gkqrpIULtfb0oRfCrJewfMSrtEjWsHlIzA9i5BXVMbK3gyfV5ZoRF7aTnKvuFQyY
         p5+n42JUCJGP8up/SRgYZco4ZLZ4lmkTGs8NYb5LHbuP0F7EkuJzCWIEEfeHOtYNk+O6
         Q47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678316070;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+J0b8VSa/m7CpwvWD16+VUtDl7LeR0FAxAMR+W7ckJc=;
        b=8Ark+Ck0I4HqqhyX9n9jor+p7+muxq3eHHAFfXUAq0dSuxFQ+fTXjaUdhQUqyvRyKw
         gaoG3alFF4MBUV2d6cFT//j5KfdC3/js0eEvlLYuLCaQ+6WbtXd4g4dCuAHxGddwnFYq
         ei3f+o0cRCw1HS+l2FeaS0bRHLJfT0jV3nqeHWxHZnp44rDXuIyXCrTyQw8/XWPNw59+
         2CN/Xtno0drMHVvSR7sBpXm1xeeHV+Am/MBld12tz75P0SUOcg3lVcpZub4jiZjy1GUw
         k+t+qX9PBo68oqR/4oeyIXadhA0G/yISJQacRqA+nSdZdMKcG47uWQfK16XEAqvpQx1e
         bX1Q==
X-Gm-Message-State: AO0yUKXvRjTtH13jHxzqv8RRQVvDA2ezezyfKKGd7ZEeXARIxlvMBjuC
        ZqtMU/Sro/f7F9nfefMIOGSjl1XSriQQeg==
X-Google-Smtp-Source: AK7set/J2a/dCSAr+3ZD7kva5xaOieFb8KurXmVhg0eTSxMT844CdYCsJxox9jvOqm3Y1muk4FXh8Q==
X-Received: by 2002:a17:907:cf48:b0:8e0:4baf:59bb with SMTP id uv8-20020a170907cf4800b008e04baf59bbmr21320047ejc.22.1678316069809;
        Wed, 08 Mar 2023 14:54:29 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lo2-20020a170906fa0200b008e09deb6610sm7995732ejb.200.2023.03.08.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 14:54:29 -0800 (PST)
Date:   Thu, 9 Mar 2023 00:54:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 2/5] net: Expose available time stamping layers to
 user space.
Message-ID: <20230308225425.v6q3dglfz7me44ht@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-3-kory.maincent@bootlin.com>
 <20230308135936.761794-3-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308135936.761794-3-kory.maincent@bootlin.com>
 <20230308135936.761794-3-kory.maincent@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Köry,

On Wed, Mar 08, 2023 at 02:59:26PM +0100, Köry Maincent wrote:
> From: Kory Maincent <kory.maincent@bootlin.com>
> 
> Time stamping on network packets may happen either in the MAC or in
> the PHY, but not both.  In preparation for making the choice
> selectable, expose both the current and available layers via ethtool.
> 
> In accordance with the kernel implementation as it stands, the current
> layer will always read as "phy" when a PHY time stamping device is
> present.  Future patches will allow changing the current layer
> administratively.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> ---

I'm pretty sure that all new ethtool commands must be implemented
through the genetlink socket interface. The ioctl interface stopped
being extended and is in maintenance mode only.
