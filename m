Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE744C3D90
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiBYFQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiBYFQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:16:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD752692F6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:16:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so7013251pjq.0
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSMef4P8V8oFwb+fm6ARGIAQfVO/cSnY9ejRJmoQo0s=;
        b=Ewb/yOujkPM9R5/p7B5v5mUD5jig3mOS8f/0jmcIkgNG+ddSnNjMuHWrWZCBURza0l
         MRTUk4Ptq7H/eZ2J1tb85c0Cg7cNwkeRt4vCpcrjWVMbm1W14z1RROPX8kwY+xRpVnsP
         nmMU7lGABawCx73aPqCZiMzy1cLRuv3QvjZMmsdHhLTsbT0lB5YKwUwxn6lVbxMF9G61
         YcE9W/tJuw96klxn71dRGYNa4arpM1Gv+rhj+dari5fphLXBHUTw5eSkS1Rl4IAnILFd
         OtayBbUjYk23OHrOtzNDzfmQval41BA0OJyeb1nKkCreQUq7SNeka7fav8cxEYsZFBff
         WxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSMef4P8V8oFwb+fm6ARGIAQfVO/cSnY9ejRJmoQo0s=;
        b=QDb4Sp4y98H6+EJJK4uNIy9rfPHaUBQcu0gmXw20JxPirJI9/3n08UTBHhPlIzBbPu
         vQKgrxfbeKpTm8lM4RwHDqIn7j8mh8N3w9DZv4NZtXlNpJmhyCTThi3RnV42zr2XOcLO
         /QDtaFvohwbeBxpDz9scnREZvQoghiGLQb4EwG0JPVU7evL5cX5B/yKPJCtSlGuFeuGO
         VpTnCAtEpwS9s9rhDnjY0vs4pufYNAmHrpId1XyMTWumDntqKBmxpKYbczaYiV83L76G
         x8cNJWu0Q1uCSCYuWczZ7j6ODooua3zew5dUk8a/T6ZOoWm3F3FLwZ0PRB+8zbHhl4fH
         p1jA==
X-Gm-Message-State: AOAM532UV/ibRWcCVkjFMryEuztf1LPz8yxdu2nkGGVWvqonh3K0d4Hf
        OCg7ERQV+K3ikylHNIVOAMKSQHCXEhPuSR3iWmc=
X-Google-Smtp-Source: ABdhPJzxbbxXdDswd7BPYtr6y3n7xdccGUCrhse9UH2OjZJJ0zHoacn2a+RfvL2sO3FdfJ8a6pJgym8jd+zFz1BtQbY=
X-Received: by 2002:a17:902:e542:b0:150:e0a:c21e with SMTP id
 n2-20020a170902e54200b001500e0ac21emr5967617plf.59.1645766182763; Thu, 24 Feb
 2022 21:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20220222224758.11324-1-luizluca@gmail.com> <20220223234324.l24vak5usy6vpjkp@skbuf>
In-Reply-To: <20220223234324.l24vak5usy6vpjkp@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 25 Feb 2022 02:16:11 -0300
Message-ID: <CAJq09z59Sk_Z=BNJOmM38sLOhj1Ybx1Bje_yopxH1D00GrkMzQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/2] net: dsa: realtek: add rtl8_4t tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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

> On Tue, Feb 22, 2022 at 07:47:56PM -0300, Luiz Angelo Daros de Luca wrote:
> > In those cases, using 'rtl8_4t' might be an alternative way to avoid
> > checksum offload, either using runtime or device-tree property.
>
> Good point. Can you please add one more patch that updates
> Documentation/devicetree/bindings/net/dsa/dsa-port.yaml?

Sure
