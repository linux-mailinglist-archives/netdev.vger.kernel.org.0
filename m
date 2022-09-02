Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160295AB86C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIBSkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIBSkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:40:11 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19E6E8AA;
        Fri,  2 Sep 2022 11:40:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb36so5523580ejc.10;
        Fri, 02 Sep 2022 11:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=DVxDeaXZfKNHhIDqZtli0aAYoHM/3xsPWidZamTX/6Y=;
        b=APLqfOR9MAYorEatAahNmr8hGYTR8+l/WKnO2DMs1juMWCmu3b8Y7otG0f6qe29tRb
         LwjPlcGqB7CRfQHDhVScHpFHMB3nA8SPEQB6tiriF1FhTT7PwmGzgNkwlPmduusrjLVj
         fZ8bV4E9KgZYQ/6/xOYZxgAu5+EIpUMR5Nb3CLJdiJjHswLRgNDzjcoOtHPOJQdUn5zC
         Bt9iU8Ge6KjSzCZDeWKYQdhYwmGCB8yOW+gXOv8UtskJZMulyWVLOpeJVe6jmPaBu+6Y
         L4rvNpaUL9boZ/ajqNrRJx7xXXvSUg2SM93bbrYTtsCh9scySB9jehQrWqSSlEASR/DZ
         9viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=DVxDeaXZfKNHhIDqZtli0aAYoHM/3xsPWidZamTX/6Y=;
        b=h5xUouE9TmnJOnV2ioYFauqXAAmzdlQ/OkgCQWt9fKC8ELlrG/jhxabI/qglHQbLjs
         Q9NBGo0RMZgG3tnFKvjNxaTFyDNyAceiDu1Czp/F1XMJdwUDtipKnMgnmK4bkG5ANynm
         bxi6j3oMqSkT+OkVCzw3RlblWZ+m+Uhtn4i+HgUW1867ViLcaaHuIYh/JXfujlsEknhW
         zorr3FuK832YFChOybecZ1ugnrD1y0FJpuNKeOs/x1TmsHY9IuwC9cp+Vo4iMBLMmm0p
         FOcdmNsvNM8qxWLfdW+LQCbnwWaEFUzRPee7MYYpZnYef7UYhZ3M4SD/JKcT8RGNiE5a
         Jn6g==
X-Gm-Message-State: ACgBeo1t8EMMt//rGqBVUsnpFMfJA7HH6Ss3XQ4bBioXZw3o6d9/dtX+
        LXXovUk6uYhWgCPZJkVKXfo=
X-Google-Smtp-Source: AA6agR4TdzcK7kxJ6ekgK4iUOwn/5DLcrn5tZ+5dkRcqyuUoaCXbD8bongQcSRFwxcdcj6AJ6camyQ==
X-Received: by 2002:a17:906:8251:b0:741:7a62:2376 with SMTP id f17-20020a170906825100b007417a622376mr17971060ejx.689.1662144008166;
        Fri, 02 Sep 2022 11:40:08 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073d61238ae1sm1572560ejt.83.2022.09.02.11.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:40:07 -0700 (PDT)
Date:   Fri, 2 Sep 2022 21:40:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Message-ID: <20220902184004.6tpxo4vdwkqb3fso@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <20220902103145.faccoawnaqh6cn3r@skbuf>
 <3da14763-b495-77eb-e059-b62e496ba7e7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da14763-b495-77eb-e059-b62e496ba7e7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 11:33:31AM -0700, Florian Fainelli wrote:
> > at some point I was thinking we could change the way in which dsa_loop
> > probes, and allow dynamic creation of such interfaces using RTM_NEWLINK;
> > but looking closer at that, it's a bit more complicated, since we'd need
> > to attach dsa_loop user ports to a virtual switch, and probe all ports
> > at the same time rather than one by one.
> 
> Yes, not sure the custom netlink operations would be the preferred way of
> doing that configuration, maybe module parameters and/or debugfs might just
> do?

Yeah, or make dsa_loop OF-based and just insert a device tree overlay,
something of that sort, I'd guess.

So it's likely that we won't be extending the DSA rtnl_link_ops too much
in the future. However, it's also likely that "writable iflink" isn't
going to be very useful for other virtual netdevices except DSA, either.
So the argument goes both ways. And while the writable iflink requires a
new ndo operation, the IFLA_DSA_MASTER can be handled 100% within DSA.

I don't know, I'm just rambling, I'm open to suggestions.
