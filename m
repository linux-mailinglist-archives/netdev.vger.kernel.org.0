Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3815115AD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiD0LKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiD0LJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:09:47 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBC73D1EF
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 04:06:36 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g19so2520799lfv.2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 04:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gfvLeYqHPQ+5/le1PQ5m8ByHdZe6xucvGKDboobiRU0=;
        b=IEONqacXGW4d4Shh0BedSQpSclgh5MPONe0xR8HELE1uME7x+KvZxhBOG0ICrBBtYe
         bh1lZGb5XU9VKtGgqmX17tk1jEPz11XnlFAnqyV2QA0tQmqxCWiqri+XMFBTJ5chj2Ke
         leWhFrYyrAQFu8R/mOMVZXcp67I3Ek+z11kNyZshDPS5YV7XX0x/FhMrNLlZL7sIAcpF
         MrU4pL0ZOZmJrzCsiKKOg8jLjzGN4hE6o+lVcb0H12vY8+yGYYW/JEtEPjvVPGLlJXxV
         P44OvM7Vkv9t+gPBiq2SD5hgL225lqaINSdUXNzZW500vpRDhzre4CQwcKabnsWhpCfP
         kTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gfvLeYqHPQ+5/le1PQ5m8ByHdZe6xucvGKDboobiRU0=;
        b=jc9TU6XVunktN/UQasE544kNlQbZAmJZIFJbnQIan6gODfwEQ3wZJ6bObzw1iv7IvH
         BQcHXaMYqCKr9Yq7Ko6SCwdyQElJq5mmK/thy1UYRCuuFnAftkPZZmdvxw3wNr1/Wsq1
         sEgyhnaEPdg5nNM8K+mU+QvJWPsb3r+s4vUORRyQ+Yun3IPTKwkiL7KvBzTZ/WdXn06p
         oNKUCjnuE5tjQlH3FVQEu7NXpKp6RVZASdQeSLs/Pi/ccQEiXGpRK8GuftllIjVjsSDZ
         npvk9pfFl56Q5/lznB92RbVmDSWk2sKrRSdfhqKDQiRIfJEVSMggijJB7FDv35BbU3ic
         fMow==
X-Gm-Message-State: AOAM531q92y1IuqULqkXwViyTFamcW/8yJzpTMjL/p68pbHhxd2lmyEw
        XOZuCTnJdiv0cpNr154sR2k=
X-Google-Smtp-Source: ABdhPJwL+DjvGRDTfiZaady0aDXdgUi4OkzGrOGL16MolRzvWR1QPFaJTzFIXeydZXiO/ycCbxD6zA==
X-Received: by 2002:a05:6512:694:b0:471:8eae:8c13 with SMTP id t20-20020a056512069400b004718eae8c13mr19889549lfe.37.1651057594884;
        Wed, 27 Apr 2022 04:06:34 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d14-20020a05651c088e00b0024daf492556sm1772408ljq.131.2022.04.27.04.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:06:34 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
In-Reply-To: <20220427103209.luyfereepqaha7dw@skbuf>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com>
 <867d7bga78.fsf@gmail.com> <YmgaX4On/2j3lJf/@lunn.ch>
 <20220426231755.7yhvabefzbyiaj4o@skbuf> <86ilquapl1.fsf@gmail.com>
 <20220427103209.luyfereepqaha7dw@skbuf>
Date:   Wed, 27 Apr 2022 13:06:32 +0200
Message-ID: <86zgk6eqfb.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, apr 27, 2022 at 10:32, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Wed, Apr 27, 2022 at 10:38:18AM +0200, Hans Schultz wrote:
>> 
>> I see that there is definitions for 64bit mac addresses out there, which
>> might also be needed to be supported at some point?
>
> I don't know about 64-bit MAC addresses, do you have more information?
>

I have only seen that there is a section about it in rfc7043:
https://www.rfc-editor.org/rfc/rfc7043

and some in rfc7042 also.
