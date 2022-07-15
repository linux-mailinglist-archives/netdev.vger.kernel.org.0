Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEC857680B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiGOURX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiGOURW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:17:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258AA5018C;
        Fri, 15 Jul 2022 13:17:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so7725902edd.0;
        Fri, 15 Jul 2022 13:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kUgUodRkFKUUOwUquDcWzYd3uzryMer8NNF5OFV/n3U=;
        b=Ea7DnxFB8YW7x85iotpMK+8GfKngvKz1AKd+YQL5lC/XhwtJw1GtCZtx9xMuj9P94v
         FmOQRLwMV8EilKg8d1ysdEVfV2oK3MhX5NW58snn/aSC8gYnHxfmIj0BiYIzRtA78709
         9RDrri8Gf4l3MLaRp1P5w0GiuB/67EixbDvUwBgZp9j6qCfs5j7q8pFbfiKyEqJt9fDU
         Utj6jP+4u9OTOnT19df2FLoVo2an6o9agEPdejrPnMaspOGKbuFXxmIDFvL+ZAVg3oi2
         pkavLyuX/t7U5CPvlzyU3E0f4pGl8E++BwgL+eU0bv5K3d/H3VF0IxbhMybLAuCyxwok
         XJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kUgUodRkFKUUOwUquDcWzYd3uzryMer8NNF5OFV/n3U=;
        b=aRa3oiJgihELyDP85fZ9O4wBKC+l1pOZ7XjD0n0SfEz2t4x8zBkTEeVTWRz0Z/Wver
         zx2pzjq1CM00FsCUtuQ1yXGn2bmjESUL/eq/Tvhleh90YzlzcqsAYhXWJlF7PqUuI9Mo
         qD62MZwY2kU/MxP3oCCMTX0lfrHDM8Ifll3/P9GZaPu6pAqRw6loq5GpZe8CELO28H62
         n9WHzWPRo/d5zfoRfZ28n5+78Zz7ko7E94WiBHUAKYl65spxHCPchVKoe2qBIirVexbY
         hWf8mp7LiJ0BP9C+lNibQJW/2tFW+7lXT48UPsCB8qqhgKVN5GfRxPHXrlHPzGH9WxCU
         wnoA==
X-Gm-Message-State: AJIora8n6DKGv/GeJI1mqLUImipWXdXdNmT37AmpS/mUYKE5KLw3gfig
        oR7lVhJKblY5et1lHbxz5JMreM7rkiKhTA==
X-Google-Smtp-Source: AGRyM1t1xV9P/w3xfqZD1QiQGwgq/xLXDMQuFjnnZzEH6CaG5uGAy6MlAs5/6lNobUF3nMAnDUSmDA==
X-Received: by 2002:a05:6402:278c:b0:43a:91cb:c43a with SMTP id b12-20020a056402278c00b0043a91cbc43amr21393953ede.188.1657916239591;
        Fri, 15 Jul 2022 13:17:19 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id o7-20020aa7c507000000b0043ab81e4230sm3448457edq.50.2022.07.15.13.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 13:17:18 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:17:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <20220715201715.foea4rifegmnti46@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:57:55PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 15, 2022 at 05:01:32PM +0100, Russell King wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Allow a named software node to be created, which is needed for software
> > nodes for a fixed-link specification for DSA.
> 
> In general I have no objection, but what's worrying me is a possibility to
> collide in namespace. With the current code the name is generated based on
> unique IDs, how can we make this one more robust?

Could you be more clear about the exact concern?
