Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED506D9C2D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbjDFPYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239186AbjDFPYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:24:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E107EDC;
        Thu,  6 Apr 2023 08:24:48 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-932072d4c00so156405866b.1;
        Thu, 06 Apr 2023 08:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680794686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cOMO4X0KkT1wLKp3ZzLuqJYBOcq707+YpxHq0zavOgw=;
        b=mOLwUplHv9h7ct3oUi+VgdSBSfJfcHSz4omCFqbZjtcuXZHY1U4ilN33bGUgNEML1d
         Hjq7TbyKj4CJpjX2aYIhMpGOdWYEmKO/C293HsORhRG+hHjWFl30PxsM/93zkWlpk8lC
         R93xYEJiKmwfBwiccG8Qtkg09sf55JI7q8wuLs0blN9F/xMZYbUWJXHcGoXFlX6ATnp3
         2NOgQ3U7nnw2BBVkH+GM4uOAnLsCSM/U2wL9x/JpWe9suZa+OawzhG/gpICCvUkNwGR9
         3mDNsEgVogbvJdbZt8mKUnYQEY2TV3tWC5PUAfU/wajZEWpW4OikShq4SToCCxH61U6/
         zqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680794686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOMO4X0KkT1wLKp3ZzLuqJYBOcq707+YpxHq0zavOgw=;
        b=j5iQMnY13XVKIUzTonCUgh54fjWnKM4Pxf5aegGOE+FnUBYyFQHybJxYjaa8LbCmWw
         0ehzVJWQDoOhDw5UlL7qBF1y907b3KckM8dMBLvjuqVkOa/Smkg5xYklNfxMhZC1/lOX
         IKlPAu6GzKU1LuNEEaHAbREZaSHUKfKu5vVOVAyXSCOeknfasktFFpjiUshO+Q196FFG
         cybQv+TIktI66VjR9kmjx4pDOEhutVO3zAJHvuzufEr3zlc1qGl9bXUWG4ZrsOFbxgos
         k9SW0FQwwy84xstujxHHNKqFI4cRKRvp3pAV7O+Nz8zdeDCzDV8HEDmNMWmj33xfjIxI
         NvGg==
X-Gm-Message-State: AAQBX9fRXwidp0hNeP3bzpwPGZvuKtu5V/2fufaIwELfLS7LDJkDKRl5
        dTbYYTijnXzzAAJcIaAaMoE=
X-Google-Smtp-Source: AKy350bMKcJuUrKHxCynmrWlEri+wOd6BUJcWjnjfAUKYwzm18cdb+f7ZMxFTWEmAIFudRqwzqdrSg==
X-Received: by 2002:aa7:da06:0:b0:502:8f49:2552 with SMTP id r6-20020aa7da06000000b005028f492552mr5597291eds.27.1680794686523;
        Thu, 06 Apr 2023 08:24:46 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b15-20020a50cccf000000b004c10b4f9ebesm878829edj.15.2023.04.06.08.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:24:46 -0700 (PDT)
Date:   Thu, 6 Apr 2023 18:24:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
Message-ID: <20230406152443.b3ps4x7e4kz4aes2@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder>
 <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder>
 <874jq22h2u.fsf@kapio-technology.com>
 <20230330192714.oqosvifrftirshej@skbuf>
 <871ql5mjjp.fsf@kapio-technology.com>
 <20230331093732.s6loozkdhehewlm4@skbuf>
 <87tty1nlb4.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tty1nlb4.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:43:11PM +0200, Hans Schultz wrote:
> I will as long as the system is as it is with these selftests, just run
> single subtests at a time on target, but if I have new phy problems like
> the one you have seen I have had before, then testing on target becomes
> off limits.

Please open a dedicated communication channel (separate email thread on
netdev@vger.kernel.org) with the appropriate maintainers for the PHY
code that is failing for you in To:, and you will get the help that you
need to resolve that and to be able to test on the target board.
