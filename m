Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1706B490A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjCJPIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjCJPIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:08:18 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EF12CBD5;
        Fri, 10 Mar 2023 07:01:02 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d7so5867899qtr.12;
        Fri, 10 Mar 2023 07:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678460394;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cv0nqeG9ewE2ohDmFuTFqHY0vUZH9hoFb51iUvscY0c=;
        b=czmwilVn5p14xCmVVmK12l5bW3SJulgEzJIVeTAvcmSZHya1bN7nn1VHMo/qo+ZV0j
         R1aVo5tbFBhVmWbNyZ6Aa0vwDumsTMpbeI1sL0W6tjTbKsAeUlgDaOomPqB7kzlreRrI
         lLd3/xgAgYYfBbNxB7N8Fc7bfeHHVlDXPqAPa/EQhn2Jo3xJIKZ1JwZ6pnVmBhl5f1fX
         iw0uQSqQeGxYe5KEQhgJwffySbWy6tfYqNYCowVe78GEEYL9zEM+wU2CTK31wkNbs9Is
         Jd7stn7USKoQsKVI4pkewP4M6DbPErGumTajyR7XuktUZ3Y9eAFCrzhPVs6kpcKkyJoK
         2aMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460394;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Cv0nqeG9ewE2ohDmFuTFqHY0vUZH9hoFb51iUvscY0c=;
        b=ABCny72qg2l/7cBCFiMInPp8AFR2RhsZGRRhQ7+/pIy/Y+o23mjOspH7Dd/obbRrM3
         NAsOePGKER1CpaFziMysxlBlT9lF94PzgCPChkf1eQh+vdQXnW2+OZ7xdO9r0gnwz/3L
         9/x5JuImducbcORx46rlnleM7k5GX71udEyaXWfMO31cCrHsCyjJ9MP90mEHnlpEBy8P
         D/qG56UQxuUJdvi1J/0Mac06ftoX+Dcu6z36z+tNwuJ8/ZeO3LZvJH5i8atB3VYIXQgp
         VvIp7pD0LzVAMUoXFjxnnIxWuwvkpYGlX+VK7BHWMR0TKg9mHm43vqkFd1kqcR1EhpFH
         mIyA==
X-Gm-Message-State: AO0yUKWQFZeIpEQv3ubyUdFVRWyB7bVDVZtRkgNCdcgWgBW2SO45c3g9
        H16ST8eadqURhnOn1a8g+LA=
X-Google-Smtp-Source: AK7set+f+qUvbUmt/KzHLVUZlrsvvPrMFwM1YJAYDf8D1odORfl6fghTzRM20US5VWKyKujUjePzqQ==
X-Received: by 2002:ac8:5794:0:b0:3b9:bc8c:c202 with SMTP id v20-20020ac85794000000b003b9bc8cc202mr4414727qta.13.1678460394748;
        Fri, 10 Mar 2023 06:59:54 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id d207-20020a3768d8000000b0073df51b5127sm1472389qkc.43.2023.03.10.06.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 06:59:54 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:59:53 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?S8O2cnkgTWFpbmNlbnQ=?= <kory.maincent@bootlin.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Message-ID: <640b45e9c765e_1dc964208eb@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230310154125.696a3eb3@kmaincent-XPS-13-7390>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <6408a9b3c7ae1_13061c2082a@willemb.c.googlers.com.notmuch>
 <20230310154125.696a3eb3@kmaincent-XPS-13-7390>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

K=C3=B6ry Maincent wrote:
> On Wed, 08 Mar 2023 10:28:51 -0500
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> =

> > >  =

> > > +	enum timestamping_layer selected_timestamping_layer;
> > > +  =

> > =

> > can perhaps be a single bit rather than an enum
> =

> I need at least two bits to be able to list the PTPs available.
> Look at the ethtool_list_ptp function of the second patch.

In the available bitmap, yes. Since there are only two options,
in the selected case, a single bit would suffice.=
