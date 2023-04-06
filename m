Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B566D9C1F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbjDFPWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbjDFPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:22:06 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD1B93C5;
        Thu,  6 Apr 2023 08:22:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l17so2263935ejp.8;
        Thu, 06 Apr 2023 08:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680794523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8yHOaVQ4mahqDoWUZZ0X3+twLrUdiCW/OQNIgPHkpM=;
        b=oZwLocsV6/myf95tPXquC5P3/ayH6gAbBmWdKPVSUnZn6kRTeDqScnnIn5GIxlwbz8
         nJZGvjOLRNAUgjKN8PXwWDCRcZdQQt4RZRHWNK89ycCHgppu7C7O4ozWDeJaf41K61Uh
         XCHSLNMP4ONIQjVBXkMf3l59MTq8pFp/jjC78wzeOS3zutEYhIVWmg4bj8p5L5DGPRsg
         0AOgBoukthw2oMSbXy0UwTa90FzkZqEBtvZJoMFgwYe2I8IudvnqJLxGrI48c+S2ONUQ
         rMDe4Q+9Kvi+Z/zD00KMVwCpG6F+iLyt51C8aFhkLH0FITM+kp655rE19bJGxaKHTUQ5
         YXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680794523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8yHOaVQ4mahqDoWUZZ0X3+twLrUdiCW/OQNIgPHkpM=;
        b=dq7gEHIjrHIK7BpRudtZbASIU7u03qKVr4GfKc4UABdzoQUfS9TcZQEGPkNeSEvp8U
         UJ6LPGT5yr/sft1wW/khCoKfKkbCwDo3tJ6MqAsjo05MshNUXrjo+s2eC89HTiouOX+N
         c9pz2F93rkDYPfmxq2R+Mv7w7PTh+ogq3+6odtpjgllEPLq5QORG0IlochvJjGmVKeCo
         TQ09MpV3DS0vr+NFDPUT57jJPHD1IhckdOvdPF98R7ijwpRAPwZjjkrT+feE3xaBm097
         BvPvGRwyzuScEHV/DGER8zjZg02oydzMTG6KBIAtlVcWpLG+Uaud6GiyrqIGRpN0pGFv
         Ji9A==
X-Gm-Message-State: AAQBX9dhbb6OJEzzy/vhzf5FmSFq8A4yIyewZH7FRklFLNwxCUVJ9+NX
        K06RgYu6JLY6JaZUG0CgjkA=
X-Google-Smtp-Source: AKy350YlpYZ/5WyZfEsJM9r0STUEnAAOWTh66kJerlTJdTbxs18L9N8B47hs1vImrQMlTMzWf6mr9A==
X-Received: by 2002:a17:907:a413:b0:92f:43a2:bf7d with SMTP id sg19-20020a170907a41300b0092f43a2bf7dmr7965899ejc.73.1680794522609;
        Thu, 06 Apr 2023 08:22:02 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id dd20-20020a1709069b9400b009475bf82935sm937459ejc.31.2023.04.06.08.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:22:02 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:21:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230406152159.zfg6kxuimulnpops@skbuf>
References: <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
 <87cz4slkx5.fsf@kapio-technology.com>
 <20230330124326.v5mqg7do25tz6izk@skbuf>
 <87wn2yxunb.fsf@kapio-technology.com>
 <20230330130936.hxme34qrqwolvpsh@skbuf>
 <875yaimgro.fsf@kapio-technology.com>
 <20230330150752.gdquw5kudtrqgzyz@skbuf>
 <87o7o1ox9h.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7o1ox9h.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 05:17:46PM +0200, Hans Schultz wrote:
> On Thu, Mar 30, 2023 at 18:07, Vladimir Oltean <olteanv@gmail.com> wrote:
> > As a bug fix, stop reporting to switchdev those FDB entries with
> > BR_FDB_ADDED_BY_USER && !BR_FDB_STATIC. Then, after "net" is merged into
> > "net-next" next Thursday (the ship has sailed for today), add "bool static"
> 
> It is probably too late today (now I have a Debian based VM that can do
> the selftests), but with this bug fix I have 1) not submitted bug fixes
> before and 2) it probably needs an appropriate explanation, where I
> don't know the problem well enough for general switchcores to submit
> with a suitable text.

Do you want me to try to submit this change as a bug fix?
