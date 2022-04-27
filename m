Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435F951118B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358261AbiD0Gso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239747AbiD0Gsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:48:43 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05884578D
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 23:45:32 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w19so1393197lfu.11
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=kNopuFaI+OTYD8gqOyJVqbYSljb9D2fzYG3RIU/KQUk=;
        b=bt9IKsJqojBmD1/bPuvz2Ah6qKgUOfMC0EKCB/0F6vHD1Hrtx50r0ETrtBQ/GdeLSs
         g+E0wE1oeogtPpOqnBbaG9DOXD8xwaxsAUYWDM9/+UHCWhygtoQfwObr4Yhm4WyWLoC9
         RJ7DcIGnD2m2wTG74Wd7JlkXLfVDaTLMexHjBXvTpSwOR884GoKqquKXGdgCqtHU0vRz
         OINc6h7DbKCNLk0xJ24kyva/t+toCsh/FHninj5AviIuDbJEDOFrJbo0b2W3bpsGMR+D
         DSC3PfMgm0wntrivEvxxkAOp45EGReBeV4VIEcMWOwf3nCVlN2cKS6Z9OeKsYtnUDZCi
         l5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kNopuFaI+OTYD8gqOyJVqbYSljb9D2fzYG3RIU/KQUk=;
        b=ippyRYXcixAlKyaKSDcV5uue4e3C1HGV8+z/D85uhC31roi/RHGep8FMKc1pMYGE0/
         koUXdMrIqGKQbInVK/pCBdRRzCciDDKUfzY4aqjauzx0Nd784sSql2bRBU1G/KxyGHXI
         oiASwHf3HdasMZI19OJKNZU6ieUuj9g9Hnz9Jy5BvccrkWT2xskvjHl9Pfnt0SwXDF42
         CYcoVZr/a4ZNRZIaEajPP/dDKIPnIUUAPK1YSKFyoV/a8AAb73F0ITGPClTPLj535qtP
         9/R9nw7Ttb1UN3HQXzTNJRO97r80cBov9xL2jBIlmmDhWlO5maWnEdPExoDioD6tpccD
         hh+g==
X-Gm-Message-State: AOAM533bA3p0VE0cFwIPYTN2quMh1e467o1J5y4muV4BONr+LAzE6MON
        IGH/oZS3NWAESGagDUY7QyY=
X-Google-Smtp-Source: ABdhPJwk19/2OW0aUMwLZnc89T9c7+S0drwXy/r9lYUDlqNEDFmdVPc/Jf0iZHqCBignFVKvQp9Kow==
X-Received: by 2002:a05:6512:114c:b0:471:c3c9:6c00 with SMTP id m12-20020a056512114c00b00471c3c96c00mr19475483lfg.138.1651041930843;
        Tue, 26 Apr 2022 23:45:30 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id s8-20020a05651c200800b0024f1745e0aesm500220ljo.68.2022.04.26.23.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 23:45:30 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Hans Schultz <schultz.hans@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
In-Reply-To: <YmgaX4On/2j3lJf/@lunn.ch>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com>
 <867d7bga78.fsf@gmail.com> <YmgaX4On/2j3lJf/@lunn.ch>
Date:   Wed, 27 Apr 2022 08:45:28 +0200
Message-ID: <86levr9g8n.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, apr 26, 2022 at 18:14, Andrew Lunn <andrew@lunn.ch> wrote:
>> > @@ -941,23 +965,29 @@ struct dsa_switch_ops {
>> >  	 * Forwarding database
>> >  	 */
>> >  	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
>> > -				const unsigned char *addr, u16 vid);
>> > +				const unsigned char *addr, u16 vid,
>> > +				struct dsa_db db);
>>=20
>> Hi! Wouldn't it be better to have a struct that has all the functions
>> parameters in one instead of adding further parameters to these
>> functions?
>>=20
>> I am asking because I am also needing to add a parameter to
>> port_fdb_add(), and it would be more future oriented to have a single
>> function parameter as a struct, so that it is easier to add parameters
>> to these functions without hav=C3=ADng to change the prototype of the
>> function every time.
>
> Hi Hans
>
> Please trim the text to only what is relevant when replying. It is
> easy to miss comments when having to Page Down, Page Down, Page down,
> to find comments.
>
>    Andrew

Hi Andrew,

ahh yes, my client collapses those lines, but thanks for letting me
know. I will trim going forward.

Hans
